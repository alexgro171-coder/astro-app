import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AnalyticsEventType, Prisma } from '@prisma/client';

export interface MetricsOverview {
  range: string;
  newUsers: number;
  activeSubscribers: number;
  oneTimePurchasers: number;
  oneTimeByService: Record<string, number>;
  onlineNow: number;
  learnUsers: number;
}

@Injectable()
export class AnalyticsService {
  private readonly logger = new Logger(AnalyticsService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Log an analytics event
   */
  async logEvent(
    eventType: AnalyticsEventType,
    userId?: string,
    meta?: Record<string, any>,
  ): Promise<void> {
    try {
      await this.prisma.analyticsEvent.create({
        data: {
          eventType,
          userId,
          meta: meta ?? Prisma.JsonNull,
        },
      });
      this.logger.debug(`Logged event: ${eventType} for user: ${userId || 'anonymous'}`);
    } catch (error) {
      // Don't throw - analytics should never break the main flow
      this.logger.error(`Failed to log event ${eventType}: ${error.message}`);
    }
  }

  /**
   * Query metrics for admin dashboard
   */
  async queryMetrics(range: '1d' | '7d' | '30d' | '90d'): Promise<MetricsOverview> {
    const now = new Date();
    const rangeMs = {
      '1d': 24 * 60 * 60 * 1000,
      '7d': 7 * 24 * 60 * 60 * 1000,
      '30d': 30 * 24 * 60 * 60 * 1000,
      '90d': 90 * 24 * 60 * 60 * 1000,
    };
    
    const startDate = new Date(now.getTime() - rangeMs[range]);
    const fiveMinutesAgo = new Date(now.getTime() - 5 * 60 * 1000);

    // Run queries in parallel for efficiency
    const [
      newUsers,
      activeSubscribers,
      oneTimePurchaseEvents,
      onlineNow,
      learnEvents,
    ] = await Promise.all([
      // New users in range
      this.prisma.user.count({
        where: {
          createdAt: { gte: startDate },
        },
      }),

      // Active subscribers (current)
      this.prisma.subscription.count({
        where: {
          status: 'ACTIVE',
        },
      }),

      // One-time purchases in range
      this.prisma.analyticsEvent.findMany({
        where: {
          eventType: 'ONE_TIME_PURCHASE',
          createdAt: { gte: startDate },
        },
        select: {
          userId: true,
          meta: true,
        },
      }),

      // Online now (active in last 5 minutes)
      this.prisma.user.count({
        where: {
          lastActiveAt: { gte: fiveMinutesAgo },
        },
      }),

      // Learn users in range
      this.prisma.analyticsEvent.findMany({
        where: {
          eventType: 'LEARN_OPENED',
          createdAt: { gte: startDate },
        },
        select: {
          userId: true,
        },
        distinct: ['userId'],
      }),
    ]);

    // Calculate one-time purchasers (distinct users)
    const uniquePurchasers = new Set(oneTimePurchaseEvents.filter(e => e.userId).map(e => e.userId));
    
    // Breakdown by service
    const oneTimeByService: Record<string, number> = {};
    for (const event of oneTimePurchaseEvents) {
      const service = (event.meta as any)?.service || 'unknown';
      oneTimeByService[service] = (oneTimeByService[service] || 0) + 1;
    }

    return {
      range,
      newUsers,
      activeSubscribers,
      oneTimePurchasers: uniquePurchasers.size,
      oneTimeByService,
      onlineNow,
      learnUsers: learnEvents.length,
    };
  }

  /**
   * Stub for future rollups implementation
   * TODO: Implement daily rollups for efficient historical queries
   */
  async buildDailyRollups(dateFrom: Date, dateTo: Date): Promise<void> {
    this.logger.warn('buildDailyRollups is not yet implemented');
    // Future implementation:
    // 1. Query raw events for the date range
    // 2. Aggregate by day + eventType
    // 3. Store in analytics_daily_rollups table
    // 4. Use rollups for historical queries instead of raw events
  }
}

