import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionStatus, SubscriptionTier, BillingPeriod } from '@prisma/client';
import {
  Entitlements,
  DEFAULT_ENTITLEMENTS,
  TRIAL_ENTITLEMENTS,
  STANDARD_ENTITLEMENTS,
  PREMIUM_ENTITLEMENTS,
  TRIAL_CONFIG,
} from './entitlements.types';

/**
 * EntitlementsService
 * 
 * Central module for resolving user entitlements based on subscription status.
 * This is the SINGLE SOURCE OF TRUTH for feature gating.
 * 
 * Usage:
 *   const entitlements = await entitlementsService.resolveEntitlements(userId);
 *   if (entitlements.canUseAudioTts) { ... }
 */
@Injectable()
export class EntitlementsService {
  private readonly logger = new Logger(EntitlementsService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Resolve entitlements for a user
   * 
   * Flow:
   * 1. Check if user has subscription
   * 2. If no subscription, check if in trial period (based on account creation)
   * 3. Return appropriate entitlements based on status
   */
  async resolveEntitlements(userId: string): Promise<Entitlements> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        subscription: true,
      },
    });

    if (!user) {
      this.logger.warn(`User not found: ${userId}`);
      return DEFAULT_ENTITLEMENTS;
    }

    const subscription = user.subscription;

    // Case 1: User has an active subscription
    if (subscription) {
      return this.resolveFromSubscription(subscription);
    }

    // Case 2: No subscription - check if in free trial period
    const trialResult = this.checkTrialStatus(user.createdAt);
    
    if (trialResult.isInTrial) {
      return {
        ...TRIAL_ENTITLEMENTS,
        trialDaysRemaining: trialResult.daysRemaining,
        subscriptionEndDate: trialResult.trialEndDate,
      };
    }

    // Case 3: Trial expired, no subscription = blocked/free tier
    this.logger.log(`User ${userId} trial expired, no subscription`);
    return DEFAULT_ENTITLEMENTS;
  }

  /**
   * Resolve entitlements from a subscription record
   */
  private resolveFromSubscription(subscription: {
    status: SubscriptionStatus;
    tier: SubscriptionTier;
    period: BillingPeriod;
    provider: string;
    trialEndAt: Date | null;
    currentPeriodEndAt: Date | null;
  }): Entitlements {
    const now = new Date();

    // Handle trial status
    if (subscription.status === 'TRIAL' && subscription.trialEndAt) {
      const trialEnd = new Date(subscription.trialEndAt);
      if (trialEnd > now) {
        const daysRemaining = Math.ceil((trialEnd.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
        return {
          ...TRIAL_ENTITLEMENTS,
          trialDaysRemaining: daysRemaining,
          subscriptionEndDate: trialEnd,
          provider: subscription.provider.toLowerCase() as 'stripe' | 'apple' | 'google',
        };
      }
    }

    // Map subscription status to entitlements
    const baseEntitlements = subscription.tier === 'PREMIUM' 
      ? PREMIUM_ENTITLEMENTS 
      : STANDARD_ENTITLEMENTS;

    const statusMap: Record<SubscriptionStatus, Entitlements['subscriptionStatus']> = {
      TRIAL: 'trial',
      ACTIVE: 'active',
      CANCELED: 'canceled',
      EXPIRED: 'expired',
      PAST_DUE: 'past_due',
      PAUSED: 'canceled',
    };

    // Check if subscription is still valid
    const isActive = ['ACTIVE', 'CANCELED', 'PAST_DUE'].includes(subscription.status) &&
      subscription.currentPeriodEndAt &&
      new Date(subscription.currentPeriodEndAt) > now;

    if (!isActive && subscription.status !== 'TRIAL') {
      return {
        ...DEFAULT_ENTITLEMENTS,
        subscriptionStatus: 'expired',
      };
    }

    return {
      ...DEFAULT_ENTITLEMENTS,
      ...baseEntitlements,
      billingPeriod: subscription.period.toLowerCase() as 'monthly' | 'yearly',
      subscriptionStatus: statusMap[subscription.status] || 'none',
      subscriptionEndDate: subscription.currentPeriodEndAt,
      provider: subscription.provider.toLowerCase() as 'stripe' | 'apple' | 'google',
    };
  }

  /**
   * Check if user is in trial period based on account creation date
   */
  private checkTrialStatus(createdAt: Date): {
    isInTrial: boolean;
    daysRemaining: number;
    trialEndDate: Date;
  } {
    const now = new Date();
    const trialEndDate = new Date(createdAt);
    trialEndDate.setDate(trialEndDate.getDate() + TRIAL_CONFIG.DURATION_DAYS);

    const isInTrial = trialEndDate > now;
    const daysRemaining = isInTrial 
      ? Math.ceil((trialEndDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
      : 0;

    return {
      isInTrial,
      daysRemaining,
      trialEndDate,
    };
  }

  /**
   * Check if user has access (trial or active subscription)
   */
  async hasAccess(userId: string): Promise<boolean> {
    const entitlements = await this.resolveEntitlements(userId);
    return entitlements.subscriptionStatus !== 'none' && 
           entitlements.subscriptionStatus !== 'expired';
  }

  /**
   * Check if user can use premium features
   */
  async isPremium(userId: string): Promise<boolean> {
    const entitlements = await this.resolveEntitlements(userId);
    return entitlements.planTier === 'premium';
  }

  /**
   * Get trial info for user
   */
  async getTrialInfo(userId: string): Promise<{
    isInTrial: boolean;
    daysRemaining: number;
    trialEndDate: Date | null;
  }> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { subscription: true },
    });

    if (!user) {
      return { isInTrial: false, daysRemaining: 0, trialEndDate: null };
    }

    // If has subscription with trial status
    if (user.subscription?.status === 'TRIAL' && user.subscription.trialEndAt) {
      const trialEnd = new Date(user.subscription.trialEndAt);
      const now = new Date();
      const isInTrial = trialEnd > now;
      const daysRemaining = isInTrial 
        ? Math.ceil((trialEnd.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
        : 0;
      return { isInTrial, daysRemaining, trialEndDate: trialEnd };
    }

    // Check automatic trial based on account creation
    if (!user.subscription) {
      const result = this.checkTrialStatus(user.createdAt);
      return {
        isInTrial: result.isInTrial,
        daysRemaining: result.daysRemaining,
        trialEndDate: result.isInTrial ? result.trialEndDate : null,
      };
    }

    return { isInTrial: false, daysRemaining: 0, trialEndDate: null };
  }
}

