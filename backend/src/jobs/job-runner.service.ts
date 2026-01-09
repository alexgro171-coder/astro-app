import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { GenerationJob, GenerationJobType, User } from '@prisma/client';
import { GuidanceService } from '../guidance/guidance.service';
import { ForYouService } from '../for-you/for-you.service';
import { KarmicService } from '../karmic/karmic.service';
import { AstrologyService } from '../astrology/astrology.service';
import { NatalChartService } from '../natal-chart/natal-chart.service';

/**
 * Executes generation pipelines for different job types.
 */
@Injectable()
export class JobRunnerService {
  private readonly logger = new Logger(JobRunnerService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly guidanceService: GuidanceService,
    private readonly forYouService: ForYouService,
    private readonly karmicService: KarmicService,
    private readonly astrologyService: AstrologyService,
    private readonly natalChartService: NatalChartService,
  ) {}

  /**
   * Execute a job based on its type.
   */
  async executeJob(job: GenerationJob): Promise<void> {
    this.logger.log(`Executing job ${job.id} of type ${job.jobType}`);

    // Set status to RUNNING
    await this.prisma.generationJob.update({
      where: { id: job.id },
      data: { status: 'RUNNING' },
    });

    try {
      // Get user for context
      const user = await this.prisma.user.findUnique({
        where: { id: job.userId },
      });

      if (!user) {
        throw new Error('User not found');
      }

      let resultRef: Record<string, any>;

      switch (job.jobType) {
        case 'DAILY_GUIDANCE':
          resultRef = await this.executeDailyGuidance(job, user);
          break;

        case 'NATAL_CHART_SHORT':
          resultRef = await this.executeNatalChartShort(job, user);
          break;

        case 'NATAL_CHART_PRO':
          resultRef = await this.executeNatalChartPro(job, user);
          break;

        case 'KARMIC_ASTROLOGY':
          resultRef = await this.executeKarmicAstrology(job, user);
          break;

        case 'ONE_TIME_REPORT':
          resultRef = await this.executeOneTimeReport(job, user);
          break;

        default:
          throw new Error(`Unknown job type: ${job.jobType}`);
      }

      // Mark job as READY
      await this.prisma.generationJob.update({
        where: { id: job.id },
        data: {
          status: 'READY',
          resultRef,
        },
      });

      this.logger.log(`Job ${job.id} completed successfully`);
    } catch (error) {
      this.logger.error(`Job ${job.id} failed: ${error.message}`, error.stack);

      // Mark job as FAILED
      await this.prisma.generationJob.update({
        where: { id: job.id },
        data: {
          status: 'FAILED',
          errorMsg: error.message,
        },
      });
    }
  }

  /**
   * Execute Daily Guidance generation.
   * 
   * IMPORTANT: This method uses generateGuidanceForDate() directly instead of
   * getTodayGuidance() because:
   * - getTodayGuidance() is designed for lazy compute with client retry
   * - It may return PENDING status and enqueue to Bull queue
   * - That would cause this job to complete with READY while guidance is still PENDING
   * - generateGuidanceForDate() performs synchronous generation and waits for completion
   */
  private async executeDailyGuidance(
    job: GenerationJob,
    user: User,
  ): Promise<Record<string, any>> {
    const payload = job.payload as Record<string, any> | null;
    const localDateStr = payload?.localDateStr || new Date().toISOString().split('T')[0];
    const targetDate = new Date(`${localDateStr}T00:00:00.000Z`);

    this.logger.log(`Generating daily guidance for ${localDateStr}`);

    // Check if guidance already exists for this date
    const existingGuidance = await this.prisma.dailyGuidance.findFirst({
      where: {
        userId: user.id,
        OR: [
          { localDateStr },
          { date: targetDate },
        ],
        status: 'READY',
      },
    });

    if (existingGuidance) {
      this.logger.log(`Daily guidance already exists for ${localDateStr}`);
      return {
        kind: 'daily_guidance',
        localDateStr,
        id: existingGuidance.id,
        status: 'READY',
      };
    }

    // Generate guidance synchronously using generateGuidanceForDate
    // This ensures the job only completes when guidance is actually ready
    await this.guidanceService.generateGuidanceForDate(user, targetDate, localDateStr);

    // Fetch the generated guidance to return its ID
    const newGuidance = await this.prisma.dailyGuidance.findFirst({
      where: {
        userId: user.id,
        localDateStr,
        status: 'READY',
      },
    });

    if (!newGuidance) {
      throw new Error(`Guidance generation completed but record not found for ${localDateStr}`);
    }

    return {
      kind: 'daily_guidance',
      localDateStr,
      id: newGuidance.id,
      status: 'READY',
    };
  }

  /**
   * Execute Natal Chart Short interpretation.
   */
  private async executeNatalChartShort(
    job: GenerationJob,
    user: User,
  ): Promise<Record<string, any>> {
    this.logger.log(`Generating natal chart short for user ${user.id}`);

    // Check if natal chart exists
    let natalChart = await this.prisma.natalChart.findUnique({
      where: { userId: user.id },
    });

    // Generate natal chart if not exists
    if (!natalChart) {
      natalChart = await this.astrologyService.generateNatalChart(user);
    }

    // For short interpretation, we use the summary data
    return {
      kind: 'natal_chart_short',
      natalChartId: natalChart.id,
      sunSign: natalChart.sunSign,
      moonSign: natalChart.moonSign,
      ascendant: natalChart.ascendant,
    };
  }

  /**
   * Execute Natal Chart Pro interpretation.
   * This generates detailed 150-200 word interpretations for each planet.
   */
  private async executeNatalChartPro(
    job: GenerationJob,
    user: User,
  ): Promise<Record<string, any>> {
    this.logger.log(`Generating natal chart pro for user ${user.id}`);

    // Check if natal chart exists
    let natalChart = await this.prisma.natalChart.findUnique({
      where: { userId: user.id },
    });

    // Generate natal chart if not exists
    if (!natalChart) {
      natalChart = await this.astrologyService.generateNatalChart(user);
    }

    // Check if Pro interpretations already exist
    const existingPro = await this.prisma.natalInterpretation.findFirst({
      where: { userId: user.id, isPro: true },
    });

    if (existingPro) {
      this.logger.log(`Pro interpretations already exist for user ${user.id}`);
      return {
        kind: 'natal_chart_pro',
        natalChartId: natalChart.id,
        hasFullData: true,
        status: 'READY',
      };
    }

    // Generate Pro interpretations (this is the long-running operation)
    this.logger.log(`Generating Pro interpretations for user ${user.id}...`);
    const interpretations = await this.natalChartService.generateProInterpretations(
      user.id,
      user.language || 'EN',
    );

    this.logger.log(`Generated ${interpretations.length} Pro interpretations for user ${user.id}`);

    return {
      kind: 'natal_chart_pro',
      natalChartId: natalChart.id,
      hasFullData: true,
      interpretationsCount: interpretations.length,
      status: 'READY',
    };
  }

  /**
   * Execute Karmic Astrology reading.
   */
  private async executeKarmicAstrology(
    job: GenerationJob,
    user: User,
  ): Promise<Record<string, any>> {
    this.logger.log(`Generating karmic astrology for user ${user.id}`);

    // Check for existing reading with same locale
    const existingReading = await this.prisma.karmicAstrologyReading.findFirst({
      where: {
        userId: user.id,
        locale: job.locale,
        status: 'READY',
      },
    });

    if (existingReading) {
      this.logger.log(`Karmic reading already exists for locale ${job.locale}`);
      return {
        kind: 'karmic_astrology',
        id: existingReading.id,
        locale: job.locale,
        status: 'READY',
      };
    }

    // Generate new karmic reading using existing service
    // generateReading takes User object and handles the full pipeline
    const result = await this.karmicService.generateReading(user, job.locale);

    return {
      kind: 'karmic_astrology',
      locale: job.locale,
      status: result.status,
    };
  }

  /**
   * Execute One-Time Report generation.
   */
  private async executeOneTimeReport(
    job: GenerationJob,
    user: User,
  ): Promise<Record<string, any>> {
    const payload = job.payload as Record<string, any> | null;
    
    if (!payload?.serviceType) {
      throw new Error('Missing serviceType in payload for ONE_TIME_REPORT');
    }

    this.logger.log(`Generating one-time report: ${payload.serviceType}`);

    // Use ForYouService to generate the report
    const result = await this.forYouService.generateReport(
      user.id,
      payload.serviceType,
      {
        locale: job.locale,
        partnerProfile: payload.partnerProfile,
        date: payload.date,
      },
      undefined, // Accept-Language header not needed here
    );

    return {
      kind: 'one_time_report',
      serviceType: payload.serviceType,
      status: result.status,
      locale: job.locale,
    };
  }
}

