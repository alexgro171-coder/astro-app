import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { TtsService } from './tts.service';

/**
 * TTS Scheduler
 * 
 * Handles periodic cleanup of expired audio files.
 */
@Injectable()
export class TtsScheduler {
  private readonly logger = new Logger(TtsScheduler.name);

  constructor(private ttsService: TtsService) {}

  /**
   * Clean up expired audio files every 6 hours
   */
  @Cron(CronExpression.EVERY_6_HOURS)
  async handleCleanup() {
    this.logger.log('Running TTS audio cleanup...');
    
    try {
      const cleaned = await this.ttsService.cleanupExpiredAudio();
      this.logger.log(`TTS cleanup completed: ${cleaned} files removed`);
    } catch (error) {
      this.logger.error(`TTS cleanup failed: ${error.message}`);
    }
  }
}

