import { Injectable, Logger } from '@nestjs/common';
import { execFile } from 'child_process';
import { promisify } from 'util';
import * as path from 'path';
import { PrismaService } from '../prisma/prisma.service';
import { StripeService } from '../billing/stripe/stripe.service';

/**
 * Admin Service
 * 
 * Provides data for admin dashboard and admin operations.
 */
@Injectable()
export class AdminService {
  private readonly logger = new Logger(AdminService.name);
  private readonly execFileAsync = promisify(execFile);

  constructor(
    private prisma: PrismaService,
    private stripeService: StripeService,
  ) {}

  /**
   * Get active clients with subscription info
   */
  async getActiveClients(options: {
    page?: number;
    limit?: number;
    status?: string;
    tier?: string;
    provider?: string;
  }) {
    const { page = 1, limit = 50, status, tier, provider } = options;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (status) where.status = status.toUpperCase();
    if (tier) where.tier = tier.toUpperCase();
    if (provider) where.provider = provider.toUpperCase();

    const [subscriptions, total] = await Promise.all([
      this.prisma.subscription.findMany({
        where,
        include: {
          user: {
            select: {
              id: true,
              email: true,
              name: true,
              createdAt: true,
            },
          },
          payments: {
            orderBy: { createdAt: 'desc' },
            take: 1,
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.subscription.count({ where }),
    ]);

    return {
      clients: subscriptions.map(sub => ({
        userId: sub.userId,
        email: sub.user.email,
        name: sub.user.name,
        provider: sub.provider.toLowerCase(),
        tier: sub.tier.toLowerCase(),
        period: sub.period.toLowerCase(),
        status: sub.status.toLowerCase(),
        startAt: sub.startAt,
        trialEndAt: sub.trialEndAt,
        currentPeriodEndAt: sub.currentPeriodEndAt,
        canceledAt: sub.canceledAt,
        lastPayment: sub.payments[0] ? {
          amount: sub.payments[0].amount,
          currency: sub.payments[0].currency,
          paidAt: sub.payments[0].paidAt,
        } : null,
        userCreatedAt: sub.user.createdAt,
      })),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Get payment history
   */
  async getPayments(options: {
    page?: number;
    limit?: number;
    userId?: string;
    status?: string;
    provider?: string;
    startDate?: Date;
    endDate?: Date;
  }) {
    const { page = 1, limit = 50, userId, status, provider, startDate, endDate } = options;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (userId) where.userId = userId;
    if (status) where.status = status.toUpperCase();
    if (provider) where.provider = provider.toUpperCase();
    if (startDate || endDate) {
      where.createdAt = {};
      if (startDate) where.createdAt.gte = startDate;
      if (endDate) where.createdAt.lte = endDate;
    }

    const [payments, total] = await Promise.all([
      this.prisma.payment.findMany({
        where,
        include: {
          subscription: {
            select: {
              tier: true,
              period: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.payment.count({ where }),
    ]);

    // Get user emails for display
    const userIds = [...new Set(payments.map(p => p.userId))];
    const users = await this.prisma.user.findMany({
      where: { id: { in: userIds } },
      select: { id: true, email: true, name: true },
    });
    const userMap = new Map(users.map(u => [u.id, u]));

    return {
      payments: payments.map(p => ({
        id: p.id,
        userId: p.userId,
        userEmail: userMap.get(p.userId)?.email,
        userName: userMap.get(p.userId)?.name,
        provider: p.provider.toLowerCase(),
        tier: p.subscription?.tier.toLowerCase(),
        period: p.subscription?.period.toLowerCase(),
        amount: p.amount,
        currency: p.currency,
        status: p.status.toLowerCase(),
        paidAt: p.paidAt,
        externalId: p.externalPaymentId,
        createdAt: p.createdAt,
      })),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Get refund requests
   */
  async getRefunds(options: {
    page?: number;
    limit?: number;
    status?: string;
    provider?: string;
  }) {
    const { page = 1, limit = 50, status, provider } = options;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (status) where.status = status.toUpperCase();
    if (provider) where.provider = provider.toUpperCase();

    const [refunds, total] = await Promise.all([
      this.prisma.refund.findMany({
        where,
        include: {
          subscription: {
            select: {
              tier: true,
              period: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.refund.count({ where }),
    ]);

    // Get user info
    const userIds = [...new Set(refunds.map(r => r.userId))];
    const users = await this.prisma.user.findMany({
      where: { id: { in: userIds } },
      select: { id: true, email: true, name: true },
    });
    const userMap = new Map(users.map(u => [u.id, u]));

    return {
      refunds: refunds.map(r => ({
        id: r.id,
        userId: r.userId,
        userEmail: userMap.get(r.userId)?.email,
        userName: userMap.get(r.userId)?.name,
        provider: r.provider.toLowerCase(),
        tier: r.subscription?.tier.toLowerCase(),
        amount: r.amount,
        reason: r.reason,
        status: r.status.toLowerCase(),
        adminNotes: r.adminNotes,
        processedAt: r.processedAt,
        createdAt: r.createdAt,
      })),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Process Stripe refund
   */
  async processStripeRefund(refundId: string, amount?: number, adminNotes?: string) {
    return this.stripeService.processRefund(refundId, amount, adminNotes);
  }

  /**
   * Update refund status (for IAP refunds that can't be processed through API)
   */
  async updateRefundStatus(
    refundId: string,
    status: 'approved' | 'rejected' | 'processed',
    adminNotes?: string,
    externalRefundId?: string,
  ) {
    const statusMap = {
      approved: 'APPROVED',
      rejected: 'REJECTED',
      processed: 'PROCESSED',
    };

    const refund = await this.prisma.refund.update({
      where: { id: refundId },
      data: {
        status: statusMap[status] as any,
        adminNotes,
        externalRefundId,
        processedAt: status === 'processed' ? new Date() : undefined,
      },
    });

    this.logger.log(`Refund ${refundId} updated to status: ${status}`);

    return refund;
  }

  /**
   * Get dashboard statistics
   */
  async getDashboardStats() {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const endOfLastMonth = new Date(now.getFullYear(), now.getMonth(), 0);

    const [
      totalUsers,
      activeSubscriptions,
      trialUsers,
      monthlyRevenue,
      lastMonthRevenue,
      pendingRefunds,
      subscriptionsByTier,
      subscriptionsByProvider,
    ] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.subscription.count({
        where: { status: { in: ['ACTIVE', 'TRIAL'] } },
      }),
      this.prisma.subscription.count({
        where: { status: 'TRIAL' },
      }),
      this.prisma.payment.aggregate({
        where: {
          status: 'COMPLETED',
          paidAt: { gte: startOfMonth },
        },
        _sum: { amount: true },
      }),
      this.prisma.payment.aggregate({
        where: {
          status: 'COMPLETED',
          paidAt: { gte: startOfLastMonth, lte: endOfLastMonth },
        },
        _sum: { amount: true },
      }),
      this.prisma.refund.count({
        where: { status: 'REQUESTED' },
      }),
      this.prisma.subscription.groupBy({
        by: ['tier'],
        where: { status: { in: ['ACTIVE', 'TRIAL'] } },
        _count: true,
      }),
      this.prisma.subscription.groupBy({
        by: ['provider'],
        where: { status: { in: ['ACTIVE', 'TRIAL'] } },
        _count: true,
      }),
    ]);

    return {
      totalUsers,
      activeSubscriptions,
      trialUsers,
      monthlyRevenue: (monthlyRevenue._sum.amount || 0) / 100, // Convert cents to dollars
      lastMonthRevenue: (lastMonthRevenue._sum.amount || 0) / 100,
      revenueGrowth: lastMonthRevenue._sum.amount
        ? ((monthlyRevenue._sum.amount || 0) - lastMonthRevenue._sum.amount) / lastMonthRevenue._sum.amount * 100
        : 0,
      pendingRefunds,
      subscriptionsByTier: Object.fromEntries(
        subscriptionsByTier.map(s => [s.tier.toLowerCase(), s._count])
      ),
      subscriptionsByProvider: Object.fromEntries(
        subscriptionsByProvider.map(s => [s.provider.toLowerCase(), s._count])
      ),
    };
  }

  /**
   * Get user details
   */
  async getUserDetails(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        subscription: true,
        natalChart: {
          select: {
            sunSign: true,
            moonSign: true,
            ascendant: true,
          },
        },
        contextProfile: true,
        _count: {
          select: {
            dailyGuidances: true,
            feedbacks: true,
          },
        },
      },
    });

    if (!user) return null;

    const payments = await this.prisma.payment.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 10,
    });

    const refunds = await this.prisma.refund.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        createdAt: user.createdAt,
        onboardingComplete: user.onboardingComplete,
        natalChart: user.natalChart,
        hasContextProfile: !!user.contextProfile?.completedAt,
        guidanceCount: user._count.dailyGuidances,
        feedbackCount: user._count.feedbacks,
      },
      subscription: user.subscription,
      payments,
      refunds,
    };
  }

  /**
   * Run UI ARB translation script (OpenAI-powered)
   */
  async runUiTranslations() {
    if (!process.env.OPENAI_API_KEY) {
      throw new Error('OPENAI_API_KEY is not set on the server');
    }

    const scriptPath = path.resolve(process.cwd(), 'scripts', 'translate-ui-arb.js');
    this.logger.log(`Running UI translation script: ${scriptPath}`);

    const { stdout, stderr } = await this.execFileAsync('node', [scriptPath], {
      env: process.env,
      maxBuffer: 10 * 1024 * 1024,
    });

    return {
      ok: true,
      stdout: stdout?.trim() || '',
      stderr: stderr?.trim() || '',
    };
  }
}

