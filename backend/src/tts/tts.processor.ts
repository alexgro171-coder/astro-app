import { Processor, Process, OnQueueFailed } from '@nestjs/bull';
import { Logger } from '@nestjs/common';
import { Job } from 'bull';
import { TtsService } from './tts.service';

/**
 * TTS Queue Processor
 * 
 * Processes audio generation jobs in the background.
 * This prevents blocking the main request thread during TTS generation.
 */
@Processor('tts')
export class TtsProcessor {
  private readonly logger = new Logger(TtsProcessor.name);

  constructor(private ttsService: TtsService) {}

  @Process('generate')
  async handleGenerate(job: Job<{ userId: string; guidanceId: string }>) {
    this.logger.log(`Processing TTS job ${job.id} for guidance ${job.data.guidanceId}`);

    try {
      await this.ttsService.processGeneration(job.data.userId, job.data.guidanceId);
      this.logger.log(`TTS job ${job.id} completed successfully`);
    } catch (error) {
      this.logger.error(`TTS job ${job.id} failed: ${error.message}`);
      throw error; // Re-throw to trigger retry
    }
  }

  @OnQueueFailed()
  handleFailed(job: Job, error: Error) {
    this.logger.error(`TTS job ${job.id} failed after ${job.attemptsMade} attempts: ${error.message}`);
  }
}

