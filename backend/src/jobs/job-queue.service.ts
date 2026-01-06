import { Injectable, Logger, OnModuleDestroy } from '@nestjs/common';

/**
 * Interface for job queue service - allows easy swap to BullMQ later.
 */
export interface IJobQueueService {
  enqueue(jobId: string): Promise<void>;
}

/**
 * MVP in-process job queue with concurrency control.
 * Can be replaced with BullMQ/Redis for production scaling.
 */
@Injectable()
export class JobQueueService implements IJobQueueService, OnModuleDestroy {
  private readonly logger = new Logger(JobQueueService.name);
  private readonly queue: string[] = [];
  private readonly running = new Set<string>();
  private readonly maxConcurrency = 5;
  private isProcessing = false;
  private isShuttingDown = false;

  // Callback to process jobs - set by JobsService
  private processCallback?: (jobId: string) => Promise<void>;

  /**
   * Set the callback function that will process jobs.
   */
  setProcessCallback(callback: (jobId: string) => Promise<void>): void {
    this.processCallback = callback;
  }

  /**
   * Add a job to the queue.
   */
  async enqueue(jobId: string): Promise<void> {
    if (this.isShuttingDown) {
      this.logger.warn(`Queue is shutting down, rejecting job ${jobId}`);
      return;
    }

    // Avoid duplicate enqueue
    if (this.queue.includes(jobId) || this.running.has(jobId)) {
      this.logger.debug(`Job ${jobId} already in queue or running, skipping`);
      return;
    }

    this.queue.push(jobId);
    this.logger.log(`Job ${jobId} enqueued. Queue size: ${this.queue.length}`);

    // Start processing if not already running
    this.processQueue();
  }

  /**
   * Process jobs from the queue with concurrency control.
   */
  private async processQueue(): Promise<void> {
    if (this.isProcessing) return;
    this.isProcessing = true;

    try {
      while (this.queue.length > 0 && !this.isShuttingDown) {
        // Wait if at max concurrency
        if (this.running.size >= this.maxConcurrency) {
          await this.sleep(100);
          continue;
        }

        const jobId = this.queue.shift();
        if (!jobId) continue;

        // Process job without blocking
        this.executeJob(jobId);
      }
    } finally {
      this.isProcessing = false;
    }
  }

  /**
   * Execute a single job.
   */
  private async executeJob(jobId: string): Promise<void> {
    if (!this.processCallback) {
      this.logger.error(`No process callback set for job ${jobId}`);
      return;
    }

    this.running.add(jobId);
    this.logger.log(`Starting job ${jobId}. Running: ${this.running.size}/${this.maxConcurrency}`);

    try {
      await this.processCallback(jobId);
      this.logger.log(`Job ${jobId} completed successfully`);
    } catch (error) {
      this.logger.error(`Job ${jobId} failed: ${error.message}`, error.stack);
      // Error handling is done in the callback - job status should be updated there
    } finally {
      this.running.delete(jobId);
      // Continue processing queue
      if (this.queue.length > 0 && !this.isShuttingDown) {
        this.processQueue();
      }
    }
  }

  /**
   * Get queue stats for monitoring.
   */
  getStats(): { queued: number; running: number; maxConcurrency: number } {
    return {
      queued: this.queue.length,
      running: this.running.size,
      maxConcurrency: this.maxConcurrency,
    };
  }

  /**
   * Graceful shutdown - wait for running jobs to complete.
   */
  async onModuleDestroy(): Promise<void> {
    this.logger.log('Shutting down job queue...');
    this.isShuttingDown = true;

    // Wait for running jobs (max 30s)
    const maxWait = 30000;
    const startTime = Date.now();

    while (this.running.size > 0 && Date.now() - startTime < maxWait) {
      this.logger.log(`Waiting for ${this.running.size} running jobs to complete...`);
      await this.sleep(1000);
    }

    if (this.running.size > 0) {
      this.logger.warn(`Shutdown timeout - ${this.running.size} jobs still running`);
    }

    this.logger.log('Job queue shutdown complete');
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

