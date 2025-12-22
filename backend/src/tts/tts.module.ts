import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { BullModule } from '@nestjs/bull';
import { ScheduleModule } from '@nestjs/schedule';
import { PrismaModule } from '../prisma/prisma.module';
import { BillingModule } from '../billing/billing.module';
import { TtsService } from './tts.service';
import { TtsController } from './tts.controller';
import { TtsProcessor } from './tts.processor';
import { TtsScheduler } from './tts.scheduler';

/**
 * TTS Module
 * 
 * Handles audio generation for Premium users using Coqui TTS.
 * 
 * Features:
 * - Background processing via BullMQ queue
 * - Automatic cleanup of expired audio files
 * - Streaming and direct URL access
 * 
 * Required infrastructure:
 * - Redis (for BullMQ queue)
 * - Coqui TTS installed (pip install TTS)
 * - Storage for audio files (local or S3/Spaces)
 */
@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    BillingModule,
    BullModule.registerQueue({
      name: 'tts',
      defaultJobOptions: {
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 5000,
        },
        removeOnComplete: 100,
        removeOnFail: 50,
      },
    }),
  ],
  controllers: [TtsController],
  providers: [TtsService, TtsProcessor, TtsScheduler],
  exports: [TtsService],
})
export class TtsModule {}

