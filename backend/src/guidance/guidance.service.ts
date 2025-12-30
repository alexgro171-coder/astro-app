import { Injectable, Logger, NotFoundException, Inject, forwardRef } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { AiService } from '../ai/ai.service';
import { ConcernsService } from '../concerns/concerns.service';
import { ContextService } from '../context/context.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { User, GuidanceStatus, DailyGuidance } from '@prisma/client';
import { GuidanceQueueService } from './guidance-queue.service';

// Maximum time to wait for generation before returning PENDING
const MAX_WAIT_MS = 10000;

// Maximum backfill days
const MAX_BACKFILL_DAYS = 3;

@Injectable()
export class GuidanceService {
  private readonly logger = new Logger(GuidanceService.name);

  constructor(
    private prisma: PrismaService,
    private astrologyService: AstrologyService,
    private aiService: AiService,
    private concernsService: ConcernsService,
    private contextService: ContextService,
    @Inject(forwardRef(() => EntitlementsService))
    private entitlementsService: EntitlementsService,
    @Inject(forwardRef(() => GuidanceQueueService))
    private guidanceQueueService: GuidanceQueueService,
  ) {}

  /**
   * Resolve user's IANA timezone from various sources
   */
  resolveUserTimezone(user: User, headerTimezone?: string): string {
    // Priority: header > user.timezoneIana > user.timezone > UTC
    if (headerTimezone && this.isValidTimezone(headerTimezone)) {
      return headerTimezone;
    }
    if (user.timezoneIana && this.isValidTimezone(user.timezoneIana)) {
      return user.timezoneIana;
    }
    if (user.timezone && this.isValidTimezone(user.timezone)) {
      return user.timezone;
    }
    return 'UTC';
  }

  /**
   * Get today's guidance for a user (LAZY COMPUTE)
   * 
   * Flow:
   * 1. Calculate "today" based on user's timezone -> localDateStr
   * 2. Check DB for existing guidance
   * 3. If READY -> return immediately
   * 4. If PENDING -> wait or return pending status
   * 5. If not exists -> create PENDING record, enqueue job, optionally wait
   * 6. Trigger backfill for past 3 days (low priority)
   */
  async getTodayGuidance(user: User, timezone?: string) {
    // Step 1: Resolve timezone and get today's date string
    const userTimezone = this.resolveUserTimezone(user, timezone);
    const localDateStr = this.getLocalDateStr(userTimezone);
    const today = this.localDateStrToDate(localDateStr);

    this.logger.log(
      `Getting guidance for user ${user.id}, timezone: ${userTimezone}, date: ${localDateStr}`,
    );

    // Step 2: Update user's lastActiveAt
    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastActiveAt: new Date() },
    });

    // Step 3: Check if guidance exists
    let guidance = await this.prisma.dailyGuidance.findUnique({
      where: {
        userId_localDateStr: { userId: user.id, localDateStr },
      },
      include: { concern: true },
    });

    // Step 4: Handle based on status
    if (guidance) {
      if (guidance.status === 'READY') {
        this.logger.log(`Returning cached READY guidance for user ${user.id}`);
        // Trigger backfill in background (non-blocking)
        this.triggerBackfill(user.id, userTimezone, localDateStr);
        return this.formatGuidanceResponse(guidance);
      }

      if (guidance.status === 'FAILED') {
        // Allow retry - delete failed record and regenerate
        this.logger.log(`Previous guidance FAILED, retrying for user ${user.id}`);
        await this.prisma.dailyGuidance.delete({
          where: { id: guidance.id },
        });
        guidance = null;
      }

      if (guidance?.status === 'PENDING') {
        // Wait for completion
        this.logger.log(`Guidance PENDING, waiting for completion...`);
        const completed = await this.guidanceQueueService.waitForJobCompletion(
          user.id,
          localDateStr,
          MAX_WAIT_MS,
        );

        if (completed) {
          const readyGuidance = await this.prisma.dailyGuidance.findUnique({
            where: { userId_localDateStr: { userId: user.id, localDateStr } },
            include: { concern: true },
          });
          if (readyGuidance?.status === 'READY') {
            this.triggerBackfill(user.id, userTimezone, localDateStr);
            return this.formatGuidanceResponse(readyGuidance);
          }
        }

        // Still pending after wait
        return {
          status: 'PENDING',
          message: 'Your guidance is being generated. Please try again in a few seconds.',
          date: localDateStr,
        };
      }
    }

    // Step 5: No guidance exists - create PENDING record and enqueue
    this.logger.log(`No guidance found, creating PENDING record for user ${user.id}`);

    try {
      guidance = await this.prisma.dailyGuidance.create({
        data: {
          userId: user.id,
          date: today,
          localDateStr,
          status: 'PENDING',
          priority: 'high',
        },
        include: { concern: true },
      });
    } catch (error) {
      // Handle unique constraint violation (another request created it)
      if (error.code === 'P2002') {
        this.logger.debug(`Concurrent request created guidance, fetching...`);
        guidance = await this.prisma.dailyGuidance.findUnique({
          where: { userId_localDateStr: { userId: user.id, localDateStr } },
          include: { concern: true },
        });
        if (guidance?.status === 'READY') {
          return this.formatGuidanceResponse(guidance);
        }
      } else {
        throw error;
      }
    }

    // Enqueue high-priority job
    await this.guidanceQueueService.enqueueGuidanceJob({
      userId: user.id,
      localDateStr,
      priority: 'high',
    });

    // Wait for completion
    const completed = await this.guidanceQueueService.waitForJobCompletion(
      user.id,
      localDateStr,
      MAX_WAIT_MS,
    );

    if (completed) {
      const readyGuidance = await this.prisma.dailyGuidance.findUnique({
        where: { userId_localDateStr: { userId: user.id, localDateStr } },
        include: { concern: true },
      });
      if (readyGuidance?.status === 'READY') {
        this.triggerBackfill(user.id, userTimezone, localDateStr);
        return this.formatGuidanceResponse(readyGuidance);
      }
    }

    // Return pending status
    return {
      status: 'PENDING',
      message: 'Your guidance is being generated. Please try again in a few seconds.',
      date: localDateStr,
    };
  }

  /**
   * Trigger backfill for past days (non-blocking)
   */
  private triggerBackfill(userId: string, timezone: string, currentDateStr: string): void {
    // Fire and forget
    this.guidanceQueueService.enqueueBackfillJobs(userId, timezone, currentDateStr).catch((err) => {
      this.logger.error(`Backfill enqueue failed for user ${userId}: ${err.message}`);
    });
  }

  /**
   * Generate guidance for a specific date (called by queue processor)
   * This is the actual generation logic with idempotency checks
   */
  async generateGuidanceForDate(user: User, date: Date, localDateStr: string): Promise<void> {
    const logPrefix = `[User ${user.id}] [Date ${localDateStr}]`;

    // Idempotency check: is it already READY?
    const existing = await this.prisma.dailyGuidance.findUnique({
      where: { userId_localDateStr: { userId: user.id, localDateStr } },
      select: { status: true },
    });

    if (existing?.status === 'READY') {
      this.logger.log(`${logPrefix} Already READY, skipping generation`);
      return;
    }

    // Ensure PENDING record exists
    await this.prisma.dailyGuidance.upsert({
      where: { userId_localDateStr: { userId: user.id, localDateStr } },
      update: { status: 'PENDING' },
      create: {
        userId: user.id,
        date,
        localDateStr,
        status: 'PENDING',
      },
    });

    // Step 1: Get natal chart
    const natalChart = await this.astrologyService.getNatalChart(user.id);
    if (!natalChart) {
      throw new Error('Natal chart not found. Please set your birth data first.');
    }

    // Step 2: Get daily transits
    this.logger.log(`${logPrefix} Fetching transits from AstrologyAPI`);
    const transits = await this.astrologyService.getDailyTransits(user, date);

    // Step 3: Get active concern
    const activeConcern = await this.concernsService.findActive(user.id);

    // Step 4: Get previous days' guidance
    const previousDays = await this.getPreviousDaysData(user.id, date, 3);

    // Step 5: Check entitlements and get personal context
    let personalContext = null;
    let usedPersonalContext = false;

    try {
      const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
      if (entitlements.canUsePersonalContext) {
        const context = await this.contextService.getContextForAI(user.id);
        if (context) {
          personalContext = {
            summary60w: context.summary60w,
            tags: context.tags,
          };
          usedPersonalContext = true;
          this.logger.log(`${logPrefix} Including personal context (Premium)`);
        }
      }
    } catch (error) {
      this.logger.warn(`${logPrefix} Failed to get context: ${error.message}`);
    }

    // Step 6: Generate via AI
    this.logger.log(`${logPrefix} Generating guidance via OpenAI`);
    const sections = await this.aiService.generateDailyGuidance({
      natalSummary: natalChart.summary,
      transits: transits.transits as any[],
      activeConcern: activeConcern
        ? { category: activeConcern.category, text: activeConcern.textOriginal }
        : undefined,
      previousDays,
      language: user.language,
      userName: user.name || undefined,
      personalContext,
    });

    // Step 7: Update guidance to READY
    await this.prisma.dailyGuidance.update({
      where: { userId_localDateStr: { userId: user.id, localDateStr } },
      data: {
        status: 'READY',
        sections: sections as any,
        concernId: activeConcern?.id,
        aiModelVersion: this.aiService.getModelVersion(),
        usedPersonalContext,
        generatedAt: new Date(),
      },
    });

    this.logger.log(`${logPrefix} Guidance generation completed`);
  }

  /**
   * Get today's date string "YYYY-MM-DD" in user's timezone
   */
  getLocalDateStr(timezone: string): string {
    try {
      const now = new Date();
      const options: Intl.DateTimeFormatOptions = {
        timeZone: timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      };
      const formatter = new Intl.DateTimeFormat('en-CA', options);
      return formatter.format(now); // "YYYY-MM-DD"
    } catch (e) {
      this.logger.warn(`Invalid timezone ${timezone}, using UTC: ${e}`);
      return new Date().toISOString().split('T')[0];
    }
  }

  /**
   * Convert localDateStr to Date at UTC midnight
   */
  localDateStrToDate(localDateStr: string): Date {
    return new Date(`${localDateStr}T00:00:00.000Z`);
  }

  /**
   * Validate IANA timezone
   */
  private isValidTimezone(tz: string): boolean {
    try {
      Intl.DateTimeFormat(undefined, { timeZone: tz });
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Legacy method for backward compatibility
   * @deprecated Use getTodayGuidance with lazy compute
   */
  private getTodayInTimezone(timezone: string): Date {
    return this.localDateStrToDate(this.getLocalDateStr(timezone));
  }

  /**
   * Generate guidance immediately (old sync method, kept for compatibility)
   * @deprecated Use queue-based generation
   */
  async generateGuidance(user: User, date: Date = new Date()) {
    const normalizedDate = new Date(date);
    normalizedDate.setUTCHours(0, 0, 0, 0);
    const localDateStr = normalizedDate.toISOString().split('T')[0];

    // Call the new method
    await this.generateGuidanceForDate(user, normalizedDate, localDateStr);

    // Return the generated guidance
    const guidance = await this.prisma.dailyGuidance.findUnique({
      where: { userId_localDateStr: { userId: user.id, localDateStr } },
      include: { concern: true },
    });

    return guidance;
  }

  /**
   * Get previous days' guidance data for AI context
   */
  private async getPreviousDaysData(userId: string, currentDate: Date, days: number) {
    const previousGuidances = await this.prisma.dailyGuidance.findMany({
      where: {
        userId,
        date: { lt: currentDate },
        status: 'READY',
      },
      orderBy: { date: 'desc' },
      take: days,
      include: {
        concern: { select: { textOriginal: true } },
      },
    });

    return previousGuidances.map((g) => {
      const sections = g.sections as any;
      return {
        date: g.localDateStr,
        scores: {
          health: sections?.health?.score || 5,
          job: sections?.job?.score || 5,
          business_money: sections?.business_money?.score || 5,
          love: sections?.love?.score || 5,
          partnerships: sections?.partnerships?.score || 5,
          personal_growth: sections?.personal_growth?.score || 5,
        },
        concernText: g.concern?.textOriginal,
      };
    });
  }

  /**
   * Get guidance history with status
   */
  async getHistory(userId: string, days: number = 7) {
    const limitDays = Math.min(days, 14); // Cap at 14 days

    // Calculate date range
    const now = new Date();
    const startDate = new Date(now);
    startDate.setDate(startDate.getDate() - limitDays);
    startDate.setUTCHours(0, 0, 0, 0);

    const guidances = await this.prisma.dailyGuidance.findMany({
      where: {
        userId,
        date: { gte: startDate },
      },
      orderBy: { date: 'desc' },
      include: {
        concern: {
          select: { category: true, textOriginal: true },
        },
      },
    });

    return guidances.map((g) => ({
      id: g.id,
      date: g.localDateStr,
      status: g.status,
      ...(g.status === 'READY' ? this.formatGuidanceResponse(g) : {}),
      ...(g.status === 'FAILED' ? { errorMsg: g.errorMsg } : {}),
    }));
  }

  /**
   * Submit feedback for a guidance
   */
  async submitFeedback(
    userId: string,
    guidanceId: string,
    feedback: {
      healthRating?: number;
      jobRating?: number;
      businessRating?: number;
      loveRating?: number;
      partnershipRating?: number;
      growthRating?: number;
      overallRating?: number;
      freeText?: string;
    },
  ) {
    const guidance = await this.prisma.dailyGuidance.findFirst({
      where: { id: guidanceId, userId },
    });

    if (!guidance) {
      throw new NotFoundException('Guidance not found');
    }

    return this.prisma.guidanceFeedback.upsert({
      where: { userId_guidanceId: { userId, guidanceId } },
      update: feedback,
      create: { userId, guidanceId, ...feedback },
    });
  }

  /**
   * Force regenerate today's guidance
   */
  async regenerateGuidance(user: User, timezone?: string) {
    const userTimezone = this.resolveUserTimezone(user, timezone);
    const localDateStr = this.getLocalDateStr(userTimezone);

    // Delete existing guidance for today
    await this.prisma.dailyGuidance.deleteMany({
      where: { userId: user.id, localDateStr },
    });

    // Re-fetch to trigger new generation
    return this.getTodayGuidance(user, timezone);
  }

  /**
   * Format guidance for API response
   */
  formatGuidanceResponse(guidance: any) {
    const sections = (guidance.sections || {}) as any;

    const formatSection = (key: string, title: string, isHighlighted: boolean) => {
      const section = sections[key] || {};
      return {
        title: isHighlighted ? `${title} ⭐` : title,
        content: section.content || 'Guidance unavailable.',
        score: section.score || 5,
        actions: section.actions || [],
      };
    };

    return {
      id: guidance.id,
      date: guidance.localDateStr || guidance.date,
      status: guidance.status,
      dailySummary: sections.dailySummary || {
        content: 'Welcome to your daily guidance.',
        mood: 'Balanced',
        focusArea: 'Personal Growth',
      },
      sections: {
        health: formatSection('health', 'Health & Energy', guidance.concern?.category === 'HEALTH'),
        job: formatSection('job', 'Career & Job', guidance.concern?.category === 'JOB'),
        business_money: formatSection(
          'business_money',
          'Business & Money',
          ['BUSINESS_DECISION', 'MONEY'].includes(guidance.concern?.category),
        ),
        love: formatSection(
          'love',
          'Love & Romance',
          ['COUPLE', 'FAMILY'].includes(guidance.concern?.category),
        ),
        partnerships: formatSection(
          'partnerships',
          'Partnerships',
          guidance.concern?.category === 'PARTNERSHIP',
        ),
        personal_growth: formatSection(
          'personal_growth',
          'Personal Growth',
          guidance.concern?.category === 'PERSONAL_GROWTH',
        ),
      },
      activeConcern: guidance.concern
        ? { category: guidance.concern.category, text: guidance.concern.textOriginal }
        : null,
      usedPersonalContext: guidance.usedPersonalContext || false,
      generatedAt: guidance.generatedAt,
    };
  }

  /**
   * Get all users who need guidance generated (for analytics only)
   */
  async getUsersNeedingGuidance(): Promise<User[]> {
    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    const todayStr = today.toISOString().split('T')[0];

    return this.prisma.user.findMany({
      where: {
        isActive: true,
        onboardingComplete: true,
        natalChart: { isNot: null },
        dailyGuidances: {
          none: { localDateStr: todayStr },
        },
      },
    });
  }
}
