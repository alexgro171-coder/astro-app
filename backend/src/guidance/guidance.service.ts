import { Injectable, Logger, NotFoundException, Inject, forwardRef } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { AiService } from '../ai/ai.service';
import { ConcernsService } from '../concerns/concerns.service';
import { ContextService } from '../context/context.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { User } from '@prisma/client';

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
  ) {}

  /**
   * Get today's guidance for a user (ON-DEMAND generation)
   * 
   * Flow:
   * 1. Calculate "today" based on user's timezone
   * 2. Check if guidance already exists for today
   * 3. If exists → return immediately (cached)
   * 4. If not → generate on-demand (calls AstrologyAPI + OpenAI)
   * 
   * @param user - Authenticated user
   * @param timezone - User's timezone (from header or profile)
   */
  async getTodayGuidance(user: User, timezone?: string) {
    // Determine user's timezone
    const userTimezone = timezone || user.timezone || 'UTC';
    
    // Calculate "today" in user's timezone
    const today = this.getTodayInTimezone(userTimezone);
    
    this.logger.log(`Getting guidance for user ${user.id}, timezone: ${userTimezone}, date: ${today.toISOString()}`);

    // Check if guidance already exists (cache hit)
    let guidance = await this.prisma.dailyGuidance.findUnique({
      where: {
        userId_date: {
          userId: user.id,
          date: today,
        },
      },
      include: {
        concern: true,
      },
    });

    // If no guidance exists, generate it ON-DEMAND
    // This is where AstrologyAPI and OpenAI are called
    if (!guidance) {
      this.logger.log(`No cached guidance found, generating on-demand for user ${user.id}`);
      guidance = await this.generateGuidance(user, today);
    } else {
      this.logger.log(`Returning cached guidance for user ${user.id}`);
    }

    return this.formatGuidanceResponse(guidance);
  }

  /**
   * Get today's date at UTC midnight based on user's local date
   * 
   * This ensures consistent date storage across timezones.
   * We store the user's local DATE at UTC midnight for consistent querying.
   * 
   * Example: User in Europe/Bucharest (UTC+2) at 2025-12-15 01:00 local time
   * - Their "today" is 2025-12-15
   * - We store: 2025-12-15T00:00:00.000Z (the calendar date at UTC midnight)
   * 
   * This way, when we query the astrology API with getUTCDate(), getUTCMonth(), etc.,
   * we get the correct calendar date (15 Dec) regardless of timezone.
   */
  private getTodayInTimezone(timezone: string): Date {
    try {
      const now = new Date();
      
      // Get the date parts in user's timezone using Intl.DateTimeFormat
      const options: Intl.DateTimeFormatOptions = {
        timeZone: timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      };
      
      // en-CA locale gives YYYY-MM-DD format
      const formatter = new Intl.DateTimeFormat('en-CA', options);
      const dateString = formatter.format(now); // e.g., "2025-12-15"
      
      // Create date at UTC midnight for this calendar date
      // This preserves the calendar date for database queries and API calls
      const todayUTC = new Date(`${dateString}T00:00:00.000Z`);
      
      this.logger.debug(`User timezone: ${timezone}, local date: ${dateString}, stored as: ${todayUTC.toISOString()}`);
      
      return todayUTC;
    } catch (e) {
      this.logger.warn(`Invalid timezone ${timezone}, falling back to UTC: ${e}`);
      const today = new Date();
      today.setUTCHours(0, 0, 0, 0);
      return today;
    }
  }

  /**
   * Generate guidance for a specific user and date
   * 
   * This method calls external APIs:
   * - AstrologyAPI for daily transits
   * - OpenAI GPT for AI-generated guidance
   * 
   * For Premium users with personal context, guidance is more personalized.
   * 
   * Called ON-DEMAND when user opens the app, NOT at scheduled times
   */
  async generateGuidance(user: User, date: Date = new Date()) {
    // Normalize date to midnight
    const normalizedDate = new Date(date);
    normalizedDate.setUTCHours(0, 0, 0, 0);

    // Step 1: Get natal chart (from database, no external API call)
    const natalChart = await this.astrologyService.getNatalChart(user.id);
    if (!natalChart) {
      throw new NotFoundException('Natal chart not found. Please set your birth data first.');
    }

    // Step 2: Get daily transits (calls AstrologyAPI)
    this.logger.log(`Fetching transits from AstrologyAPI for user ${user.id}`);
    const transits = await this.astrologyService.getDailyTransits(user, normalizedDate);

    // Step 3: Get active concern (from database)
    const activeConcern = await this.concernsService.findActive(user.id);

    // Step 4: Get previous days' guidance for AI context (from database)
    const previousDays = await this.getPreviousDaysData(user.id, normalizedDate, 3);

    // Step 5: Check entitlements and get personal context (Premium only)
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
          this.logger.log(`Including personal context for Premium user ${user.id}`);
        }
      } else {
        this.logger.debug(`Personal context not included for user ${user.id} (not Premium)`);
      }
    } catch (error) {
      this.logger.warn(`Failed to get entitlements/context for user ${user.id}: ${error.message}`);
      // Continue without personal context
    }

    // Step 6: Generate guidance using AI (calls OpenAI)
    this.logger.log(`Generating guidance via OpenAI for user ${user.id}${usedPersonalContext ? ' (with personal context)' : ''}`);
    const sections = await this.aiService.generateDailyGuidance({
      natalSummary: natalChart.summary,
      transits: transits.transits as any[],
      activeConcern: activeConcern ? {
        category: activeConcern.category,
        text: activeConcern.textOriginal,
      } : undefined,
      previousDays,
      language: user.language,
      userName: user.name || undefined,
      personalContext, // NEW: Include for Premium users
    });

    // Step 7: Save guidance to database (upsert for idempotency)
    const guidance = await this.prisma.dailyGuidance.upsert({
      where: {
        userId_date: {
          userId: user.id,
          date: normalizedDate,
        },
      },
      update: {
        sections: sections as any,
        concernId: activeConcern?.id,
        aiModelVersion: this.aiService.getModelVersion(),
        usedPersonalContext, // Track if personal context was used
        generatedAt: new Date(),
      },
      create: {
        userId: user.id,
        date: normalizedDate,
        sections: sections as any,
        concernId: activeConcern?.id,
        aiModelVersion: this.aiService.getModelVersion(),
        usedPersonalContext, // Track if personal context was used
      },
      include: {
        concern: true,
      },
    });

    this.logger.log(`Generated guidance for user ${user.id} for date ${normalizedDate.toISOString()}`);
    return guidance;
  }

  /**
   * Get previous days' guidance data for AI context
   * This provides continuity and avoids repetition
   */
  private async getPreviousDaysData(userId: string, currentDate: Date, days: number) {
    const previousGuidances = await this.prisma.dailyGuidance.findMany({
      where: {
        userId,
        date: {
          lt: currentDate,
        },
      },
      orderBy: { date: 'desc' },
      take: days,
      include: {
        concern: {
          select: {
            textOriginal: true,
          },
        },
      },
    });

    return previousGuidances.map(g => {
      const sections = g.sections as any;
      return {
        date: g.date.toISOString().split('T')[0],
        scores: {
          health: sections.health?.score || 5,
          job: sections.job?.score || 5,
          business_money: sections.business_money?.score || 5,
          love: sections.love?.score || 5,
          partnerships: sections.partnerships?.score || 5,
          personal_growth: sections.personal_growth?.score || 5,
        },
        concernText: g.concern?.textOriginal,
      };
    });
  }

  /**
   * Get guidance history
   */
  async getHistory(userId: string, page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;
    
    const guidances = await this.prisma.dailyGuidance.findMany({
      where: { userId },
      orderBy: { date: 'desc' },
      skip,
      take: limit,
      include: {
        concern: {
          select: {
            category: true,
            textOriginal: true,
          },
        },
      },
    });

    return guidances.map(g => this.formatGuidanceResponse(g));
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
    // Verify guidance exists and belongs to user
    const guidance = await this.prisma.dailyGuidance.findFirst({
      where: { id: guidanceId, userId },
    });

    if (!guidance) {
      throw new NotFoundException('Guidance not found');
    }

    // Upsert feedback
    return this.prisma.guidanceFeedback.upsert({
      where: {
        userId_guidanceId: {
          userId,
          guidanceId,
        },
      },
      update: feedback,
      create: {
        userId,
        guidanceId,
        ...feedback,
      },
    });
  }

  /**
   * Force regenerate today's guidance (manual refresh)
   */
  async regenerateGuidance(user: User, timezone?: string) {
    const userTimezone = timezone || user.timezone || 'UTC';
    const today = this.getTodayInTimezone(userTimezone);
    
    // Delete existing guidance for today
    await this.prisma.dailyGuidance.deleteMany({
      where: {
        userId: user.id,
        date: today,
      },
    });

    // Generate fresh guidance
    return this.generateGuidance(user, today);
  }

  /**
   * Format guidance for API response
   */
  formatGuidanceResponse(guidance: any) {
    const sections = guidance.sections as any;

    // Helper to format section with actions
    const formatSection = (key: string, title: string, isHighlighted: boolean) => {
      const section = sections[key] || {};
      return {
        title: isHighlighted ? `${title} ⭐` : title,
        content: section.content || 'Guidance unavailable.',
        score: section.score || 5,
        actions: section.actions || [], // NEW: Include micro-actions
      };
    };

    return {
      id: guidance.id,
      date: guidance.date,
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
      activeConcern: guidance.concern ? {
        category: guidance.concern.category,
        text: guidance.concern.textOriginal,
      } : null,
      usedPersonalContext: guidance.usedPersonalContext || false, // NEW: Indicate if Premium personalization was used
      generatedAt: guidance.generatedAt,
    };
  }

  /**
   * Get all users who need guidance generated
   * (Used only for analytics, NOT for batch generation)
   */
  async getUsersNeedingGuidance(): Promise<User[]> {
    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);

    const users = await this.prisma.user.findMany({
      where: {
        isActive: true,
        onboardingComplete: true,
        natalChart: {
          isNot: null,
        },
        dailyGuidances: {
          none: {
            date: today,
          },
        },
      },
    });

    return users;
  }
}
