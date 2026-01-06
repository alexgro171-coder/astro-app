import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  OnModuleInit,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { GenerationJob, GenerationJobStatus, GenerationJobType, User } from '@prisma/client';
import { JobQueueService } from './job-queue.service';
import { JobRunnerService } from './job-runner.service';
import { computeInputHash } from './utils/input-hash.util';
import {
  buildNormalizedInput,
  getUserLocalDateStr,
} from './utils/normalized-input.util';
import { StartJobDto } from './dto/start-job.dto';
import { JobStartResponse, JobStatusResponse } from './dto/job-response.dto';

// Supported locales
const SUPPORTED_LOCALES = ['en', 'ro', 'fr', 'de', 'es', 'it', 'hu', 'pl'];

/**
 * Progress hints for different job types and statuses.
 */
const PROGRESS_HINTS: Record<GenerationJobType, Record<string, string>> = {
  DAILY_GUIDANCE: {
    PENDING: 'Preparing to read the stars...',
    RUNNING: 'Reading the stars and asking the Universe about you...',
  },
  NATAL_CHART_SHORT: {
    PENDING: 'Preparing your birth chart...',
    RUNNING: 'Analyzing your planetary positions...',
  },
  NATAL_CHART_PRO: {
    PENDING: 'Preparing your detailed birth chart...',
    RUNNING: 'Deep diving into your cosmic blueprint...',
  },
  KARMIC_ASTROLOGY: {
    PENDING: 'Connecting to your karmic path...',
    RUNNING: 'Exploring your soul journey...',
  },
  ONE_TIME_REPORT: {
    PENDING: 'Preparing your personalized report...',
    RUNNING: 'Consulting the cosmos for your insights...',
  },
};

@Injectable()
export class JobsService implements OnModuleInit {
  private readonly logger = new Logger(JobsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly jobQueue: JobQueueService,
    private readonly jobRunner: JobRunnerService,
  ) {}

  /**
   * Initialize the job queue processor callback.
   */
  onModuleInit() {
    this.jobQueue.setProcessCallback(async (jobId: string) => {
      const job = await this.prisma.generationJob.findUnique({
        where: { id: jobId },
      });

      if (!job) {
        this.logger.error(`Job ${jobId} not found in database`);
        return;
      }

      await this.jobRunner.executeJob(job);
    });

    this.logger.log('Jobs service initialized');
  }

  /**
   * Start a generation job (idempotent).
   */
  async startJob(
    userId: string,
    dto: StartJobDto,
    acceptLanguage?: string,
  ): Promise<JobStartResponse> {
    // Get user for context
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Resolve locale: Accept-Language > body.locale > user.language > "en"
    const locale = this.resolveLocale(acceptLanguage, dto.locale, user.language);

    // Get local date for date-based jobs
    const localDateStr = getUserLocalDateStr(user);

    // Build normalized input for hashing
    const normalizedInput = buildNormalizedInput(
      dto.jobType,
      user,
      localDateStr,
      dto.payload,
    );

    // Compute input hash
    const inputHash = computeInputHash(normalizedInput);

    this.logger.log(
      `Starting job ${dto.jobType} for user ${userId}, locale: ${locale}, hash: ${inputHash.substring(0, 8)}...`,
    );

    // Check for existing job (idempotency)
    const existingJob = await this.prisma.generationJob.findUnique({
      where: {
        userId_jobType_locale_inputHash: {
          userId,
          jobType: dto.jobType,
          locale,
          inputHash,
        },
      },
    });

    if (existingJob) {
      this.logger.log(
        `Existing job found: ${existingJob.id}, status: ${existingJob.status}`,
      );

      // Return existing job status
      return {
        jobId: existingJob.id,
        status: existingJob.status,
        resultRef: existingJob.resultRef as Record<string, any> | undefined,
        errorMsg: existingJob.errorMsg || undefined,
      };
    }

    // Create new job
    const job = await this.prisma.generationJob.create({
      data: {
        userId,
        jobType: dto.jobType,
        locale,
        inputHash,
        status: 'PENDING',
        payload: {
          ...dto.payload,
          localDateStr,
          normalizedInput,
        },
      },
    });

    this.logger.log(`Created new job ${job.id}`);

    // Enqueue for processing
    await this.jobQueue.enqueue(job.id);

    return {
      jobId: job.id,
      status: job.status,
    };
  }

  /**
   * Get job status.
   */
  async getJobStatus(userId: string, jobId: string): Promise<JobStatusResponse> {
    const job = await this.prisma.generationJob.findUnique({
      where: { id: jobId },
    });

    if (!job) {
      throw new NotFoundException('Job not found');
    }

    // Verify job belongs to user
    if (job.userId !== userId) {
      throw new ForbiddenException('Access denied');
    }

    // Get progress hint
    const progressHint = this.getProgressHint(job);

    return {
      jobId: job.id,
      jobType: job.jobType,
      status: job.status,
      resultRef: job.resultRef as Record<string, any> | undefined,
      errorMsg: job.errorMsg || undefined,
      progressHint,
    };
  }

  /**
   * Retry a failed job.
   */
  async retryJob(userId: string, jobId: string): Promise<JobStartResponse> {
    const job = await this.prisma.generationJob.findUnique({
      where: { id: jobId },
    });

    if (!job) {
      throw new NotFoundException('Job not found');
    }

    if (job.userId !== userId) {
      throw new ForbiddenException('Access denied');
    }

    if (job.status !== 'FAILED') {
      // If not failed, just return current status
      return {
        jobId: job.id,
        status: job.status,
        resultRef: job.resultRef as Record<string, any> | undefined,
      };
    }

    // Reset job to PENDING and re-enqueue
    await this.prisma.generationJob.update({
      where: { id: job.id },
      data: {
        status: 'PENDING',
        errorMsg: null,
      },
    });

    await this.jobQueue.enqueue(job.id);

    return {
      jobId: job.id,
      status: 'PENDING',
    };
  }

  /**
   * Resolve locale from multiple sources.
   */
  private resolveLocale(
    acceptLanguage?: string,
    bodyLocale?: string,
    userLanguage?: string,
  ): string {
    // Priority: Accept-Language > body.locale > user.language > "en"
    const candidates = [
      acceptLanguage?.split(',')[0]?.split('-')[0]?.toLowerCase(),
      bodyLocale?.toLowerCase(),
      userLanguage?.toLowerCase(),
      'en',
    ];

    for (const candidate of candidates) {
      if (candidate && SUPPORTED_LOCALES.includes(candidate)) {
        return candidate;
      }
    }

    return 'en';
  }

  /**
   * Get progress hint for UI display.
   */
  private getProgressHint(job: GenerationJob): string | undefined {
    const hints = PROGRESS_HINTS[job.jobType];
    if (!hints) return undefined;

    if (job.status === 'PENDING' || job.status === 'RUNNING') {
      return hints[job.status] || hints.RUNNING;
    }

    return undefined;
  }

  /**
   * Get queue statistics (for monitoring).
   */
  getQueueStats() {
    return this.jobQueue.getStats();
  }

  /**
   * Clean up old completed jobs (maintenance).
   */
  async cleanupOldJobs(olderThanDays: number = 7): Promise<number> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - olderThanDays);

    const result = await this.prisma.generationJob.deleteMany({
      where: {
        status: { in: ['READY', 'FAILED'] },
        updatedAt: { lt: cutoffDate },
      },
    });

    this.logger.log(`Cleaned up ${result.count} old jobs`);
    return result.count;
  }
}

