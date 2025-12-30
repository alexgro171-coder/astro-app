import { Process, Processor, OnQueueFailed, OnQueueCompleted } from '@nestjs/bull';
import { Job } from 'bull';
import { Injectable, Logger, Inject, forwardRef } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { GuidanceService } from './guidance.service';
import { GuidanceJobData } from './guidance-queue.service';
import { GuidanceStatus } from '@prisma/client';

@Processor('guidance')
@Injectable()
export class GuidanceQueueProcessor {
  private readonly logger = new Logger(GuidanceQueueProcessor.name);

  constructor(
    private prisma: PrismaService,
    @Inject(forwardRef(() => GuidanceService))
    private guidanceService: GuidanceService,
  ) {}

  @Process('GENERATE_GUIDANCE')
  async handleGenerateGuidance(job: Job<GuidanceJobData>): Promise<void> {
    const { userId, localDateStr, priority } = job.data;
    const logPrefix = `[Job ${job.id}] [User ${userId}] [Date ${localDateStr}]`;

    this.logger.log(`${logPrefix} Starting guidance generation (priority: ${priority})`);

    try {
      // Step 1: Check if guidance already exists and is READY
      const existingGuidance = await this.prisma.dailyGuidance.findUnique({
        where: {
          userId_localDateStr: { userId, localDateStr },
        },
        select: { id: true, status: true },
      });

      if (existingGuidance?.status === 'READY') {
        this.logger.log(`${logPrefix} Guidance already READY, skipping generation`);
        return;
      }

      // Step 2: Get user
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!user) {
        throw new Error(`User ${userId} not found`);
      }

      // Step 3: Convert localDateStr to Date for generation
      const targetDate = new Date(`${localDateStr}T00:00:00.000Z`);

      // Step 4: Generate guidance (this calls AstrologyAPI + OpenAI)
      this.logger.log(`${logPrefix} Calling generateGuidanceForDate...`);
      await this.guidanceService.generateGuidanceForDate(user, targetDate, localDateStr);

      this.logger.log(`${logPrefix} Guidance generation completed successfully`);
    } catch (error) {
      this.logger.error(`${logPrefix} Generation failed: ${error.message}`);

      // Update status to FAILED
      await this.prisma.dailyGuidance.update({
        where: {
          userId_localDateStr: { userId, localDateStr },
        },
        data: {
          status: 'FAILED',
          errorMsg: error.message,
        },
      }).catch((e) => {
        // Record might not exist if creation failed
        this.logger.error(`${logPrefix} Could not update status to FAILED: ${e.message}`);
      });

      throw error; // Re-throw to trigger retry
    }
  }

  @OnQueueCompleted()
  onCompleted(job: Job<GuidanceJobData>) {
    this.logger.debug(`Job ${job.id} completed for user ${job.data.userId}`);
  }

  @OnQueueFailed()
  onFailed(job: Job<GuidanceJobData>, error: Error) {
    this.logger.error(
      `Job ${job.id} failed for user ${job.data.userId}, date ${job.data.localDateStr}: ${error.message}`,
    );
  }
}

