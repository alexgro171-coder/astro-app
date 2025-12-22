import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Logger,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { EntitlementsService } from './entitlements/entitlements.service';
import { StripeService } from './stripe/stripe.service';
import { CreateStripeCheckoutDto, CancelSubscriptionDto } from './dto/subscription.dto';
import { CreateRefundRequestDto } from './dto/refund.dto';

@ApiTags('billing')
@Controller('billing')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class BillingController {
  private readonly logger = new Logger(BillingController.name);

  constructor(
    private prisma: PrismaService,
    private entitlementsService: EntitlementsService,
    private stripeService: StripeService,
  ) {}

  /**
   * Get current user's entitlements
   * 
   * This is the PRIMARY endpoint for feature gating.
   * Frontend should call this on app launch and cache the result.
   */
  @Get('entitlements')
  @ApiOperation({ summary: 'Get current entitlements based on subscription status' })
  @ApiResponse({ status: 200, description: 'Returns entitlement flags' })
  async getEntitlements(@CurrentUser() user: User) {
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
    return entitlements;
  }

  /**
   * Get current subscription details
   */
  @Get('subscription')
  @ApiOperation({ summary: 'Get current subscription details' })
  async getSubscription(@CurrentUser() user: User) {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId: user.id },
    });

    if (!subscription) {
      // Return trial info if no subscription
      const trialInfo = await this.entitlementsService.getTrialInfo(user.id);
      return {
        hasSubscription: false,
        trial: trialInfo,
      };
    }

    return {
      hasSubscription: true,
      subscription: {
        id: subscription.id,
        provider: subscription.provider.toLowerCase(),
        tier: subscription.tier.toLowerCase(),
        period: subscription.period.toLowerCase(),
        status: subscription.status.toLowerCase(),
        startAt: subscription.startAt,
        trialEndAt: subscription.trialEndAt,
        currentPeriodEndAt: subscription.currentPeriodEndAt,
        canceledAt: subscription.canceledAt,
      },
    };
  }

  /**
   * Get trial information
   */
  @Get('trial')
  @ApiOperation({ summary: 'Get trial status and remaining days' })
  async getTrialInfo(@CurrentUser() user: User) {
    return this.entitlementsService.getTrialInfo(user.id);
  }

  /**
   * Create Stripe checkout session (for web/future use)
   */
  @Post('stripe/checkout')
  @ApiOperation({ summary: 'Create Stripe checkout session' })
  async createStripeCheckout(
    @CurrentUser() user: User,
    @Body() dto: CreateStripeCheckoutDto,
  ) {
    return this.stripeService.createCheckoutSession(
      user.id,
      dto.priceId,
      dto.successUrl,
      dto.cancelUrl,
    );
  }

  /**
   * Get Stripe customer portal URL
   */
  @Get('stripe/portal')
  @ApiOperation({ summary: 'Get Stripe customer portal URL for subscription management' })
  async getStripePortal(@CurrentUser() user: User) {
    const returnUrl = 'innerwidsom://settings'; // Deep link back to app
    return this.stripeService.createPortalSession(user.id, returnUrl);
  }

  /**
   * Cancel subscription
   */
  @Post('cancel')
  @ApiOperation({ summary: 'Cancel subscription' })
  async cancelSubscription(
    @CurrentUser() user: User,
    @Body() dto: CancelSubscriptionDto,
  ) {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId: user.id },
    });

    if (!subscription) {
      return { success: false, error: 'No subscription found' };
    }

    // For Stripe, use Stripe API
    if (subscription.provider === 'STRIPE') {
      return this.stripeService.cancelSubscription(user.id, dto.immediate);
    }

    // For IAP, just mark as canceled (actual cancellation through store)
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status: 'CANCELED',
        canceledAt: new Date(),
        metadata: {
          ...((subscription.metadata as object) || {}),
          cancellationReason: dto.reason,
        },
      },
    });

    return {
      success: true,
      message: subscription.provider === 'APPLE'
        ? 'Please manage your subscription in the App Store settings'
        : 'Please manage your subscription in Google Play settings',
    };
  }

  /**
   * Request a refund
   */
  @Post('refund-request')
  @ApiOperation({ summary: 'Submit a refund request' })
  async requestRefund(
    @CurrentUser() user: User,
    @Body() dto: CreateRefundRequestDto,
  ) {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId: user.id },
    });

    if (!subscription) {
      return { success: false, error: 'No subscription found' };
    }

    // Create refund request
    const refund = await this.prisma.refund.create({
      data: {
        userId: user.id,
        subscriptionId: subscription.id,
        provider: subscription.provider,
        reason: dto.reason,
        status: 'REQUESTED',
      },
    });

    this.logger.log(`Refund requested by user ${user.id}`);

    // For IAP, provide instructions
    const message = subscription.provider === 'STRIPE'
      ? 'Your refund request has been submitted and will be processed shortly.'
      : subscription.provider === 'APPLE'
        ? 'Please request a refund through Apple at reportaproblem.apple.com'
        : 'Please request a refund through Google Play';

    return {
      success: true,
      refundId: refund.id,
      message,
    };
  }

  /**
   * Get payment history
   */
  @Get('payments')
  @ApiOperation({ summary: 'Get payment history' })
  async getPaymentHistory(@CurrentUser() user: User) {
    const payments = await this.prisma.payment.findMany({
      where: { userId: user.id },
      orderBy: { createdAt: 'desc' },
      take: 20,
    });

    return payments.map(p => ({
      id: p.id,
      provider: p.provider.toLowerCase(),
      amount: p.amount,
      currency: p.currency,
      status: p.status.toLowerCase(),
      paidAt: p.paidAt,
      createdAt: p.createdAt,
    }));
  }

  /**
   * Get available plans with pricing
   */
  @Get('plans')
  @ApiOperation({ summary: 'Get available subscription plans' })
  async getPlans() {
    return {
      standard: {
        name: 'Standard',
        features: [
          'Daily astrological guidance',
          '6 life areas covered',
          'Daily focus tracking',
        ],
        pricing: {
          monthly: { amount: 499, currency: 'USD', formatted: '$4.99/month' },
          yearly: { amount: 3999, currency: 'USD', formatted: '$39.99/year', savings: '33%' },
        },
      },
      premium: {
        name: 'Premium',
        features: [
          'Everything in Standard',
          'Personalized AI guidance',
          'Audio narration (TTS)',
          'Priority support',
        ],
        pricing: {
          monthly: { amount: 999, currency: 'USD', formatted: '$9.99/month' },
          yearly: { amount: 7999, currency: 'USD', formatted: '$79.99/year', savings: '33%' },
        },
      },
      trial: {
        duration: 3,
        features: 'Full Premium access for 3 days',
      },
    };
  }
}

