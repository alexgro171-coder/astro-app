import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { AiService } from '../ai/ai.service';
import { ConcernsService } from '../concerns/concerns.service';
import { User } from '@prisma/client';

@Injectable()
export class GuidanceService {
  private readonly logger = new Logger(GuidanceService.name);

  constructor(
    private prisma: PrismaService,
    private astrologyService: AstrologyService,
    private aiService: AiService,
    private concernsService: ConcernsService,
  ) {}

  /**
   * Get today's guidance for a user
   */
  async getTodayGuidance(user: User) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Check if guidance already exists
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

    // If no guidance exists, generate it on-demand
    if (!guidance) {
      guidance = await this.generateGuidance(user, today);
    }

    return this.formatGuidanceResponse(guidance);
  }

  /**
   * Generate guidance for a specific user and date
   */
  async generateGuidance(user: User, date: Date = new Date()) {
    date.setHours(0, 0, 0, 0);

    // Get natal chart
    const natalChart = await this.astrologyService.getNatalChart(user.id);
    if (!natalChart) {
      throw new NotFoundException('Natal chart not found. Please set your birth data first.');
    }

    // Get daily transits
    const transits = await this.astrologyService.getDailyTransits(user, date);

    // Get active concern
    const activeConcern = await this.concernsService.findActive(user.id);

    // Get previous days' guidance for continuity (last 3 days)
    const previousDays = await this.getPreviousDaysData(user.id, date, 3);

    // Generate guidance using AI
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
    });

    // Save guidance
    const guidance = await this.prisma.dailyGuidance.upsert({
      where: {
        userId_date: {
          userId: user.id,
          date,
        },
      },
      update: {
        sections: sections as any,
        concernId: activeConcern?.id,
        aiModelVersion: this.aiService.getModelVersion(),
        generatedAt: new Date(),
      },
      create: {
        userId: user.id,
        date,
        sections: sections as any,
        concernId: activeConcern?.id,
        aiModelVersion: this.aiService.getModelVersion(),
      },
      include: {
        concern: true,
      },
    });

    this.logger.log(`Generated guidance for user ${user.id} for date ${date.toISOString()}`);
    return guidance;
  }

  /**
   * Get previous days' guidance data for AI context
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
  async getHistory(userId: string, from?: Date, to?: Date) {
    const where: any = { userId };

    if (from || to) {
      where.date = {};
      if (from) where.date.gte = from;
      if (to) where.date.lte = to;
    }

    const guidances = await this.prisma.dailyGuidance.findMany({
      where,
      orderBy: { date: 'desc' },
      take: 30, // Limit to last 30 days
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
   * Format guidance for API response
   */
  private formatGuidanceResponse(guidance: any) {
    const sections = guidance.sections as any;

    return {
      id: guidance.id,
      date: guidance.date,
      dailySummary: sections.dailySummary || {
        content: 'Welcome to your daily guidance.',
        mood: 'Balanced',
        focusArea: 'Personal Growth',
      },
      sections: {
        health: {
          title: guidance.concern?.category === 'HEALTH' ? 'Health & Energy ⭐' : 'Health & Energy',
          ...sections.health,
        },
        job: {
          title: guidance.concern?.category === 'JOB' ? 'Career & Job ⭐' : 'Career & Job',
          ...sections.job,
        },
        business_money: {
          title: ['BUSINESS_DECISION', 'MONEY'].includes(guidance.concern?.category) 
            ? 'Business & Money ⭐' 
            : 'Business & Money',
          ...sections.business_money,
        },
        love: {
          title: ['COUPLE', 'FAMILY'].includes(guidance.concern?.category)
            ? 'Love & Romance ⭐'
            : 'Love & Romance',
          ...sections.love,
        },
        partnerships: {
          title: guidance.concern?.category === 'PARTNERSHIP' 
            ? 'Partnerships ⭐' 
            : 'Partnerships',
          ...sections.partnerships,
        },
        personal_growth: {
          title: guidance.concern?.category === 'PERSONAL_GROWTH'
            ? 'Personal Growth ⭐'
            : 'Personal Growth',
          ...sections.personal_growth,
        },
      },
      activeConcern: guidance.concern ? {
        category: guidance.concern.category,
        text: guidance.concern.textOriginal,
      } : null,
      generatedAt: guidance.generatedAt,
    };
  }

  /**
   * Get all users who need guidance generated
   */
  async getUsersNeedingGuidance(): Promise<User[]> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Get users with completed onboarding who don't have today's guidance
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

