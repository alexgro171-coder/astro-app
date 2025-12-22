import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionTier, BillingPeriod, PaymentProvider, PaymentStatus } from '@prisma/client';
import Stripe from 'stripe';
import { PRODUCT_IDS, PRICING } from '../entitlements/entitlements.types';

/**
 * Stripe Service
 * 
 * Handles Stripe subscriptions, payments, and refunds
 * 
 * Required ENV vars:
 * - STRIPE_SECRET_KEY: Your Stripe secret key (sk_live_... or sk_test_...)
 * - STRIPE_WEBHOOK_SECRET: Webhook endpoint signing secret (whsec_...)
 * - STRIPE_PUBLISHABLE_KEY: For frontend (pk_live_... or pk_test_...)
 * 
 * Setup in Stripe Dashboard:
 * 1. Create Products for Standard and Premium
 * 2. Create Prices (monthly/yearly) for each product
 * 3. Configure webhook endpoint for subscription events
 */
@Injectable()
export class StripeService {
  private readonly logger = new Logger(StripeService.name);
  private stripe: Stripe | null = null;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    this.initializeStripe();
  }

  private initializeStripe(): void {
    const secretKey = this.configService.get<string>('STRIPE_SECRET_KEY');
    
    if (!secretKey) {
      this.logger.warn('Stripe secret key not configured');
      return;
    }

    this.stripe = new Stripe(secretKey, {
      apiVersion: '2024-11-20.acacia',
      typescript: true,
    });

    this.logger.log('Stripe client initialized');
  }

  /**
   * Create a checkout session for subscription
   */
  async createCheckoutSession(
    userId: string,
    priceId: string,
    successUrl: string,
    cancelUrl: string,
  ): Promise<{ sessionId: string; url: string }> {
    if (!this.stripe) {
      throw new BadRequestException('Stripe not configured');
    }

    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    // Check if user already has a Stripe customer
    let customerId: string | undefined;
    const existingSubscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    if (existingSubscription?.provider === 'STRIPE' && existingSubscription.metadata) {
      customerId = (existingSubscription.metadata as any).stripeCustomerId;
    }

    // Create customer if doesn't exist
    if (!customerId) {
      const customer = await this.stripe.customers.create({
        email: user.email,
        name: user.name || undefined,
        metadata: { userId },
      });
      customerId = customer.id;
    }

    // Create checkout session
    const session = await this.stripe.checkout.sessions.create({
      customer: customerId,
      mode: 'subscription',
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: successUrl,
      cancel_url: cancelUrl,
      subscription_data: {
        trial_period_days: 3, // Free trial
        metadata: { userId },
      },
      metadata: { userId },
    });

    return {
      sessionId: session.id,
      url: session.url!,
    };
  }

  /**
   * Create a customer portal session for subscription management
   */
  async createPortalSession(userId: string, returnUrl: string): Promise<{ url: string }> {
    if (!this.stripe) {
      throw new BadRequestException('Stripe not configured');
    }

    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    if (!subscription || subscription.provider !== 'STRIPE') {
      throw new BadRequestException('No Stripe subscription found');
    }

    const customerId = (subscription.metadata as any)?.stripeCustomerId;
    
    if (!customerId) {
      throw new BadRequestException('Stripe customer not found');
    }

    const session = await this.stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: returnUrl,
    });

    return { url: session.url };
  }

  /**
   * Handle Stripe webhook events
   */
  async handleWebhook(rawBody: Buffer, signature: string): Promise<void> {
    if (!this.stripe) {
      throw new BadRequestException('Stripe not configured');
    }

    const webhookSecret = this.configService.get<string>('STRIPE_WEBHOOK_SECRET');
    
    if (!webhookSecret) {
      throw new BadRequestException('Webhook secret not configured');
    }

    let event: Stripe.Event;

    try {
      event = this.stripe.webhooks.constructEvent(rawBody, signature, webhookSecret);
    } catch (error) {
      this.logger.error(`Webhook signature verification failed: ${error.message}`);
      throw new BadRequestException('Invalid webhook signature');
    }

    this.logger.log(`Processing Stripe webhook: ${event.type}`);

    switch (event.type) {
      case 'checkout.session.completed':
        await this.handleCheckoutComplete(event.data.object as Stripe.Checkout.Session);
        break;

      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        await this.handleSubscriptionUpdate(event.data.object as Stripe.Subscription);
        break;

      case 'customer.subscription.deleted':
        await this.handleSubscriptionDeleted(event.data.object as Stripe.Subscription);
        break;

      case 'invoice.paid':
        await this.handleInvoicePaid(event.data.object as Stripe.Invoice);
        break;

      case 'invoice.payment_failed':
        await this.handlePaymentFailed(event.data.object as Stripe.Invoice);
        break;

      case 'charge.refunded':
        await this.handleChargeRefunded(event.data.object as Stripe.Charge);
        break;

      default:
        this.logger.log(`Unhandled event type: ${event.type}`);
    }
  }

  /**
   * Process a refund
   */
  async processRefund(
    refundId: string,
    amount?: number,
    adminNotes?: string,
  ): Promise<{ success: boolean; refund?: any; error?: string }> {
    if (!this.stripe) {
      return { success: false, error: 'Stripe not configured' };
    }

    const refundRequest = await this.prisma.refund.findUnique({
      where: { id: refundId },
      include: { subscription: true },
    });

    if (!refundRequest) {
      return { success: false, error: 'Refund request not found' };
    }

    if (refundRequest.provider !== 'STRIPE') {
      return { success: false, error: 'Can only process Stripe refunds here' };
    }

    // Find the last payment
    const lastPayment = await this.prisma.payment.findFirst({
      where: {
        userId: refundRequest.userId,
        provider: 'STRIPE',
        status: 'COMPLETED',
      },
      orderBy: { paidAt: 'desc' },
    });

    if (!lastPayment?.externalPaymentId) {
      return { success: false, error: 'No payment found to refund' };
    }

    try {
      // Get payment intent from charge
      const paymentIntent = lastPayment.externalPaymentId;

      const stripeRefund = await this.stripe.refunds.create({
        payment_intent: paymentIntent,
        amount: amount || undefined, // undefined = full refund
        reason: 'requested_by_customer',
        metadata: {
          refundRequestId: refundId,
          adminNotes: adminNotes || '',
        },
      });

      // Update refund record
      await this.prisma.refund.update({
        where: { id: refundId },
        data: {
          status: 'PROCESSED',
          amount: stripeRefund.amount,
          externalRefundId: stripeRefund.id,
          adminNotes,
          processedAt: new Date(),
        },
      });

      // Update payment status
      await this.prisma.payment.update({
        where: { id: lastPayment.id },
        data: {
          status: amount && amount < lastPayment.amount ? 'PARTIALLY_REFUNDED' : 'REFUNDED',
        },
      });

      this.logger.log(`Refund processed: ${stripeRefund.id}`);

      return { success: true, refund: stripeRefund };
    } catch (error) {
      this.logger.error(`Refund error: ${error.message}`);
      
      await this.prisma.refund.update({
        where: { id: refundId },
        data: {
          status: 'FAILED',
          adminNotes: `${adminNotes || ''}\nError: ${error.message}`,
        },
      });

      return { success: false, error: error.message };
    }
  }

  /**
   * Cancel subscription
   */
  async cancelSubscription(
    userId: string,
    immediate: boolean = false,
  ): Promise<{ success: boolean; error?: string }> {
    if (!this.stripe) {
      return { success: false, error: 'Stripe not configured' };
    }

    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    if (!subscription || subscription.provider !== 'STRIPE') {
      return { success: false, error: 'No Stripe subscription found' };
    }

    const stripeSubId = subscription.externalSubscriptionId;
    
    if (!stripeSubId) {
      return { success: false, error: 'Stripe subscription ID not found' };
    }

    try {
      if (immediate) {
        await this.stripe.subscriptions.cancel(stripeSubId);
      } else {
        await this.stripe.subscriptions.update(stripeSubId, {
          cancel_at_period_end: true,
        });
      }

      await this.prisma.subscription.update({
        where: { id: subscription.id },
        data: {
          status: 'CANCELED',
          canceledAt: new Date(),
        },
      });

      return { success: true };
    } catch (error) {
      this.logger.error(`Cancel subscription error: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  // Private webhook handlers

  private async handleCheckoutComplete(session: Stripe.Checkout.Session): Promise<void> {
    const userId = session.metadata?.userId;
    
    if (!userId) {
      this.logger.warn('No userId in checkout session metadata');
      return;
    }

    this.logger.log(`Checkout completed for user ${userId}`);
    // Subscription will be created/updated by subscription.created webhook
  }

  private async handleSubscriptionUpdate(stripeSubscription: Stripe.Subscription): Promise<void> {
    const userId = stripeSubscription.metadata?.userId;
    
    if (!userId) {
      this.logger.warn('No userId in subscription metadata');
      return;
    }

    const priceId = stripeSubscription.items.data[0]?.price.id;
    const { tier, period } = this.parsePriceId(priceId);

    const statusMap: Record<string, 'TRIAL' | 'ACTIVE' | 'CANCELED' | 'PAST_DUE' | 'PAUSED'> = {
      trialing: 'TRIAL',
      active: 'ACTIVE',
      canceled: 'CANCELED',
      past_due: 'PAST_DUE',
      paused: 'PAUSED',
    };

    const status = statusMap[stripeSubscription.status] || 'ACTIVE';

    await this.prisma.subscription.upsert({
      where: { userId },
      update: {
        provider: PaymentProvider.STRIPE,
        tier,
        period,
        status,
        currentPeriodEndAt: new Date(stripeSubscription.current_period_end * 1000),
        trialEndAt: stripeSubscription.trial_end 
          ? new Date(stripeSubscription.trial_end * 1000) 
          : null,
        externalSubscriptionId: stripeSubscription.id,
        metadata: {
          stripeCustomerId: stripeSubscription.customer as string,
          priceId,
        },
      },
      create: {
        userId,
        provider: PaymentProvider.STRIPE,
        tier,
        period,
        status,
        startAt: new Date(stripeSubscription.start_date * 1000),
        currentPeriodEndAt: new Date(stripeSubscription.current_period_end * 1000),
        trialEndAt: stripeSubscription.trial_end 
          ? new Date(stripeSubscription.trial_end * 1000) 
          : null,
        externalSubscriptionId: stripeSubscription.id,
        metadata: {
          stripeCustomerId: stripeSubscription.customer as string,
          priceId,
        },
      },
    });

    this.logger.log(`Subscription updated for user ${userId}, status: ${status}`);
  }

  private async handleSubscriptionDeleted(stripeSubscription: Stripe.Subscription): Promise<void> {
    const subscription = await this.prisma.subscription.findFirst({
      where: { externalSubscriptionId: stripeSubscription.id },
    });

    if (subscription) {
      await this.prisma.subscription.update({
        where: { id: subscription.id },
        data: {
          status: 'EXPIRED',
          canceledAt: new Date(),
        },
      });
    }
  }

  private async handleInvoicePaid(invoice: Stripe.Invoice): Promise<void> {
    const subscription = await this.prisma.subscription.findFirst({
      where: { externalSubscriptionId: invoice.subscription as string },
    });

    if (!subscription) return;

    // Check for duplicate
    const existingPayment = await this.prisma.payment.findFirst({
      where: { externalPaymentId: invoice.payment_intent as string },
    });

    if (existingPayment) return;

    await this.prisma.payment.create({
      data: {
        userId: subscription.userId,
        subscriptionId: subscription.id,
        provider: PaymentProvider.STRIPE,
        amount: invoice.amount_paid,
        currency: invoice.currency.toUpperCase(),
        status: PaymentStatus.COMPLETED,
        paidAt: new Date(invoice.status_transitions?.paid_at || Date.now() * 1000),
        externalPaymentId: invoice.payment_intent as string,
        metadata: {
          invoiceId: invoice.id,
          invoiceNumber: invoice.number,
        },
      },
    });

    this.logger.log(`Payment recorded for subscription ${subscription.id}`);
  }

  private async handlePaymentFailed(invoice: Stripe.Invoice): Promise<void> {
    const subscription = await this.prisma.subscription.findFirst({
      where: { externalSubscriptionId: invoice.subscription as string },
    });

    if (subscription) {
      await this.prisma.subscription.update({
        where: { id: subscription.id },
        data: { status: 'PAST_DUE' },
      });
    }
  }

  private async handleChargeRefunded(charge: Stripe.Charge): Promise<void> {
    const payment = await this.prisma.payment.findFirst({
      where: { externalPaymentId: charge.payment_intent as string },
    });

    if (payment) {
      const isFullRefund = charge.amount_refunded >= charge.amount;
      
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          status: isFullRefund ? 'REFUNDED' : 'PARTIALLY_REFUNDED',
        },
      });
    }
  }

  private parsePriceId(priceId: string): { tier: SubscriptionTier; period: BillingPeriod } {
    const id = priceId.toLowerCase();
    
    const tier: SubscriptionTier = id.includes('premium') ? 'PREMIUM' : 'STANDARD';
    const period: BillingPeriod = id.includes('yearly') || id.includes('annual') ? 'YEARLY' : 'MONTHLY';
    
    return { tier, period };
  }
}

