import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import * as fs from 'fs';
import * as path from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';
import { Language } from '@prisma/client';

const execAsync = promisify(exec);

/**
 * TTS Service - Coqui TTS Integration
 * 
 * Generates audio narration for daily guidance (Premium feature).
 * 
 * Implementation Options:
 * 1. Local Coqui TTS (Python): Run TTS model locally
 * 2. Coqui Cloud API: Use Coqui's cloud service
 * 3. Alternative: Google Cloud TTS, Amazon Polly, ElevenLabs
 * 
 * This implementation uses local Coqui TTS via Python subprocess.
 * 
 * Setup:
 * 1. Install Coqui TTS: pip install TTS
 * 2. Download a model (automatic on first run)
 * 3. Set TTS_OUTPUT_DIR env var for output files
 * 
 * For production, consider:
 * - Object storage (S3/Spaces) for MP3 files
 * - CDN for delivery
 * - Pre-signed URLs for security
 */
@Injectable()
export class TtsService {
  private readonly logger = new Logger(TtsService.name);
  private readonly outputDir: string;
  private readonly baseUrl: string;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
    @InjectQueue('tts') private ttsQueue: Queue,
  ) {
    this.outputDir = this.configService.get<string>('TTS_OUTPUT_DIR') || '/tmp/tts-audio';
    this.baseUrl = this.configService.get<string>('TTS_BASE_URL') || '/audio';
    
    // Ensure output directory exists
    if (!fs.existsSync(this.outputDir)) {
      fs.mkdirSync(this.outputDir, { recursive: true });
    }
  }

  /**
   * Request audio generation for a guidance
   * Returns immediately with status, actual generation happens in background
   */
  async requestAudioGeneration(userId: string, guidanceId: string): Promise<{
    status: 'pending' | 'processing' | 'completed' | 'failed';
    audioUrl?: string;
    message?: string;
  }> {
    // Check if audio already exists
    const existingAudio = await this.prisma.guidanceAudio.findUnique({
      where: { userId_guidanceId: { userId, guidanceId } },
    });

    if (existingAudio) {
      if (existingAudio.status === 'COMPLETED' && existingAudio.fileUrl) {
        return {
          status: 'completed',
          audioUrl: existingAudio.fileUrl,
        };
      }
      
      if (existingAudio.status === 'PROCESSING') {
        return {
          status: 'processing',
          message: 'Audio is being generated, please check back shortly',
        };
      }

      if (existingAudio.status === 'FAILED') {
        // Retry failed generation
        await this.prisma.guidanceAudio.update({
          where: { id: existingAudio.id },
          data: { status: 'PENDING', errorMessage: null },
        });
      }
    }

    // Create audio record if doesn't exist
    if (!existingAudio) {
      await this.prisma.guidanceAudio.create({
        data: {
          userId,
          guidanceId,
          status: 'PENDING',
        },
      });
    }

    // Add to queue
    await this.ttsQueue.add('generate', {
      userId,
      guidanceId,
    }, {
      attempts: 3,
      backoff: {
        type: 'exponential',
        delay: 5000,
      },
    });

    return {
      status: 'pending',
      message: 'Audio generation queued',
    };
  }

  /**
   * Get audio URL for a guidance
   */
  async getAudioUrl(userId: string, guidanceId: string): Promise<{
    available: boolean;
    audioUrl?: string;
    status: string;
  }> {
    const audio = await this.prisma.guidanceAudio.findUnique({
      where: { userId_guidanceId: { userId, guidanceId } },
    });

    if (!audio) {
      return { available: false, status: 'not_requested' };
    }

    if (audio.status === 'COMPLETED' && audio.fileUrl) {
      return {
        available: true,
        audioUrl: audio.fileUrl,
        status: 'completed',
      };
    }

    return {
      available: false,
      status: audio.status.toLowerCase(),
    };
  }

  /**
   * Process audio generation (called by queue worker)
   */
  async processGeneration(userId: string, guidanceId: string): Promise<void> {
    this.logger.log(`Processing TTS for guidance ${guidanceId}`);

    // Update status to processing
    await this.prisma.guidanceAudio.update({
      where: { userId_guidanceId: { userId, guidanceId } },
      data: { status: 'PROCESSING' },
    });

    try {
      // Get user's language preference
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { language: true },
      });
      const language = user?.language || 'EN';
      this.logger.log(`TTS language for user ${userId}: ${language}`);

      // Get guidance content
      const guidance = await this.prisma.dailyGuidance.findUnique({
        where: { id: guidanceId },
      });

      if (!guidance) {
        throw new Error('Guidance not found');
      }

      // Build text for TTS in user's language
      const text = this.buildAudioScript(guidance.sections as any, language);

      // Generate audio file
      const filename = `${guidanceId}-${Date.now()}.mp3`;
      const filepath = path.join(this.outputDir, filename);

      await this.generateAudioFile(text, filepath);

      // Get file stats
      const stats = fs.statSync(filepath);
      
      // Calculate approximate duration (rough estimate: ~150 words per minute)
      const wordCount = text.split(/\s+/).length;
      const duration = Math.ceil(wordCount / 2.5); // seconds

      // Update record
      const audioUrl = `${this.baseUrl}/${filename}`;
      
      await this.prisma.guidanceAudio.update({
        where: { userId_guidanceId: { userId, guidanceId } },
        data: {
          status: 'COMPLETED',
          fileUrl: audioUrl,
          filePath: filepath,
          fileSize: stats.size,
          duration,
          generatedAt: new Date(),
          expiresAt: new Date(Date.now() + 48 * 60 * 60 * 1000), // 48 hours
        },
      });

      this.logger.log(`TTS completed for guidance ${guidanceId}: ${audioUrl}`);
    } catch (error) {
      this.logger.error(`TTS generation failed: ${error.message}`);

      await this.prisma.guidanceAudio.update({
        where: { userId_guidanceId: { userId, guidanceId } },
        data: {
          status: 'FAILED',
          errorMessage: error.message,
        },
      });

      throw error;
    }
  }

  /**
   * Build audio script from guidance sections
   * Supports English (EN) and Romanian (RO)
   */
  private buildAudioScript(sections: {
    dailySummary?: { content?: string };
    health?: { content?: string };
    job?: { content?: string };
    business?: { content?: string };
    love?: { content?: string };
    partnership?: { content?: string };
    growth?: { content?: string };
  }, language: Language = 'EN'): string {
    const parts: string[] = [];

    // Get localized strings
    const localized = this.getLocalizedTtsStrings(language);

    // Intro
    parts.push(localized.intro);
    parts.push('');

    // Daily summary
    if (sections.dailySummary?.content) {
      parts.push(localized.dailySummaryTitle);
      parts.push(sections.dailySummary.content);
      parts.push('');
    }

    // Sections in order
    const sectionOrder = [
      { key: 'health', titleKey: 'healthTitle' },
      { key: 'job', titleKey: 'jobTitle' },
      { key: 'business', titleKey: 'businessTitle' },
      { key: 'love', titleKey: 'loveTitle' },
      { key: 'partnership', titleKey: 'partnershipTitle' },
      { key: 'growth', titleKey: 'growthTitle' },
    ];

    for (const section of sectionOrder) {
      const content = (sections as any)[section.key]?.content;
      if (content) {
        parts.push(`${(localized as any)[section.titleKey]}:`);
        parts.push(content);
        parts.push('');
      }
    }

    // Outro
    parts.push(localized.outro);

    return parts.join('\n');
  }

  /**
   * Get localized strings for TTS script
   */
  private getLocalizedTtsStrings(language: Language): {
    intro: string;
    dailySummaryTitle: string;
    healthTitle: string;
    jobTitle: string;
    businessTitle: string;
    loveTitle: string;
    partnershipTitle: string;
    growthTitle: string;
    outro: string;
  } {
    if (language === 'RO') {
      return {
        intro: 'Bună dimineața. Iată ghidarea ta astrologică zilnică.',
        dailySummaryTitle: 'Prezentarea zilei',
        healthTitle: 'Sănătate și Bunăstare',
        jobTitle: 'Carieră și Muncă',
        businessTitle: 'Afaceri și Decizii',
        loveTitle: 'Dragoste și Relații',
        partnershipTitle: 'Parteneriate',
        growthTitle: 'Dezvoltare Personală',
        outro: 'Fie ca stelele să-ți ghideze calea astăzi. O zi minunată!',
      };
    }

    // Default: English
    return {
      intro: 'Good morning. Here is your daily astrological guidance.',
      dailySummaryTitle: "Today's overview",
      healthTitle: 'Health and Wellness',
      jobTitle: 'Career and Work',
      businessTitle: 'Business and Decisions',
      loveTitle: 'Love and Relationships',
      partnershipTitle: 'Partnerships',
      growthTitle: 'Personal Growth',
      outro: 'May the stars guide your path today. Have a wonderful day.',
    };
  }

  /**
   * Generate audio file using Coqui TTS
   */
  private async generateAudioFile(text: string, outputPath: string): Promise<void> {
    // Write text to temp file
    const textFile = `${outputPath}.txt`;
    fs.writeFileSync(textFile, text, 'utf8');

    try {
      // Call Coqui TTS via Python
      // Model: tts_models/en/ljspeech/tacotron2-DDC (or configure your preferred model)
      const command = `tts --text "$(cat ${textFile})" --out_path ${outputPath}`;
      
      this.logger.debug(`Running TTS command: ${command}`);
      
      const { stdout, stderr } = await execAsync(command, {
        timeout: 300000, // 5 minute timeout
      });

      if (stderr && !stderr.includes('Downloading')) {
        this.logger.warn(`TTS stderr: ${stderr}`);
      }

      // Verify output exists
      if (!fs.existsSync(outputPath)) {
        throw new Error('TTS did not produce output file');
      }

      this.logger.log(`Audio file generated: ${outputPath}`);
    } finally {
      // Clean up temp text file
      if (fs.existsSync(textFile)) {
        fs.unlinkSync(textFile);
      }
    }
  }

  /**
   * Clean up expired audio files
   */
  async cleanupExpiredAudio(): Promise<number> {
    const expired = await this.prisma.guidanceAudio.findMany({
      where: {
        expiresAt: { lt: new Date() },
        status: 'COMPLETED',
      },
    });

    let cleaned = 0;

    for (const audio of expired) {
      try {
        // Delete file
        if (audio.filePath && fs.existsSync(audio.filePath)) {
          fs.unlinkSync(audio.filePath);
        }

        // Delete record
        await this.prisma.guidanceAudio.delete({
          where: { id: audio.id },
        });

        cleaned++;
      } catch (error) {
        this.logger.error(`Failed to clean up audio ${audio.id}: ${error.message}`);
      }
    }

    this.logger.log(`Cleaned up ${cleaned} expired audio files`);
    return cleaned;
  }
}

