import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bull';
import { Queue, Job } from 'bull';
import { PrismaService } from '../prisma/prisma.service';

export interface GuidanceJobData {
  userId: string;
  localDateStr: string; // "YYYY-MM-DD"
  priority: 'high' | 'low';
}

@Injectable()
export class GuidanceQueueService {
  private readonly logger = new Logger(GuidanceQueueService.name);

  constructor(
    @InjectQueue('guidance') private guidanceQueue: Queue<GuidanceJobData>,
    private prisma: PrismaService,
  ) {}

  /**
   * Enqueue a guidance generation job
   * 
   * @param data - Job payload
   * @returns Job ID if enqueued, null if already exists
   */
  async enqueueGuidanceJob(data: GuidanceJobData): Promise<string | null> {
    const jobId = `guidance-${data.userId}-${data.localDateStr}`;

    // Check if job already exists
    const existingJob = await this.guidanceQueue.getJob(jobId);
    if (existingJob) {
      const state = await existingJob.getState();
      this.logger.debug(`Job ${jobId} already exists with state: ${state}`);
      return null;
    }

    // Queue with appropriate priority (lower number = higher priority)
    const priority = data.priority === 'high' ? 1 : 10;

    const job = await this.guidanceQueue.add('GENERATE_GUIDANCE', data, {
      jobId,
      priority,
      delay: data.priority === 'high' ? 0 : 1000, // Slight delay for backfill
    });

    this.logger.log(`Enqueued guidance job ${jobId} with priority=${data.priority}`);
    return job.id as string;
  }

  /**
   * Enqueue backfill jobs for missing past days (max 3)
   * 
   * @param userId - User ID
   * @param userTimezone - User's IANA timezone
   * @param currentDateStr - Current date string "YYYY-MM-DD"
   */
  async enqueueBackfillJobs(
    userId: string,
    userTimezone: string,
    currentDateStr: string,
  ): Promise<void> {
    const MAX_BACKFILL_DAYS = 3;

    // Calculate past date strings
    const pastDates: string[] = [];
    const currentDate = new Date(`${currentDateStr}T12:00:00Z`);

    for (let i = 1; i <= MAX_BACKFILL_DAYS; i++) {
      const pastDate = new Date(currentDate);
      pastDate.setDate(pastDate.getDate() - i);
      pastDates.push(this.formatDateStr(pastDate));
    }

    // Check which dates are missing from DB
    const existingGuidances = await this.prisma.dailyGuidance.findMany({
      where: {
        userId,
        localDateStr: { in: pastDates },
      },
      select: { localDateStr: true },
    });

    const existingDates = new Set(existingGuidances.map((g) => g.localDateStr));
    const missingDates = pastDates.filter((d) => !existingDates.has(d));

    // Enqueue jobs for missing dates
    for (const dateStr of missingDates) {
      await this.enqueueGuidanceJob({
        userId,
        localDateStr: dateStr,
        priority: 'low',
      });
    }

    if (missingDates.length > 0) {
      this.logger.log(
        `Enqueued ${missingDates.length} backfill jobs for user ${userId}: ${missingDates.join(', ')}`,
      );
    }
  }

  /**
   * Wait for a job to complete (with timeout)
   * 
   * @param userId - User ID
   * @param localDateStr - Date string
   * @param timeoutMs - Max wait time in ms
   * @returns true if job completed, false if timeout or not found
   */
  async waitForJobCompletion(
    userId: string,
    localDateStr: string,
    timeoutMs: number = 10000,
  ): Promise<boolean> {
    const jobId = `guidance-${userId}-${localDateStr}`;
    const startTime = Date.now();
    const pollInterval = 500;

    while (Date.now() - startTime < timeoutMs) {
      // Check if guidance is ready in DB
      const guidance = await this.prisma.dailyGuidance.findUnique({
        where: {
          userId_localDateStr: { userId, localDateStr },
        },
        select: { status: true },
      });

      if (guidance?.status === 'READY') {
        return true;
      }

      if (guidance?.status === 'FAILED') {
        return false;
      }

      await this.sleep(pollInterval);
    }

    this.logger.debug(`Timeout waiting for job ${jobId}`);
    return false;
  }

  /**
   * Get job status
   */
  async getJobStatus(userId: string, localDateStr: string): Promise<string | null> {
    const jobId = `guidance-${userId}-${localDateStr}`;
    const job = await this.guidanceQueue.getJob(jobId);
    
    if (!job) return null;
    return job.getState();
  }

  private formatDateStr(date: Date): string {
    return date.toISOString().split('T')[0];
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

