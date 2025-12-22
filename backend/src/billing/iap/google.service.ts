import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionTier, BillingPeriod, PaymentProvider } from '@prisma/client';
import { google, androidpublisher_v3 } from 'googleapis';
import { PRODUCT_IDS } from '../entitlements/entitlements.types';

/**
 * Google Play Billing Service
 * 
 * Handles purchase verification with Google Play Developer API
 * 
 * Required ENV vars:
 * - GOOGLE_PLAY_PACKAGE_NAME: Your app package name
 * - GOOGLE_SERVICE_ACCOUNT_KEY: Base64 encoded service account JSON key
 * 
 * Setup:
 * 1. Create a service account in Google Cloud Console
 * 2. Grant it access in Google Play Console (Settings > API Access)
 * 3. Download JSON key and set as env var (base64 encoded)
 */
@Injectable()
export class GoogleIapService {
  private readonly logger = new Logger(GoogleIapService.name);
  private androidPublisher: androidpublisher_v3.Androidpublisher | null = null;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    this.initializeClient();
  }

  private async initializeClient(): Promise<void> {
    try {
      const keyBase64 = this.configService.get<string>('GOOGLE_SERVICE_ACCOUNT_KEY');
      
      if (!keyBase64) {
        this.logger.warn('Google service account key not configured');
        return;
      }

      const keyJson = Buffer.from(keyBase64, 'base64').toString('utf8');
      const key = JSON.parse(keyJson);

      const auth = new google.auth.GoogleAuth({
        credentials: key,
        scopes: ['https://www.googleapis.com/auth/androidpublisher'],
      });

      this.androidPublisher = google.androidpublisher({
        version: 'v3',
        auth,
      });

      this.logger.log('Google Play API client initialized');
    } catch (error) {
      this.logger.error(`Failed to initialize Google Play client: ${error.message}`);
    }
  }

  /**
   * Verify Google Play purchase and update subscription
   */
  async verifyPurchase(
    userId: string,
    purchaseToken: string,
    productId: string,
    packageName?: string,
  ): Promise<{ success: boolean; subscription?: any; error?: string }> {
    if (!this.androidPublisher) {
      return { success: false, error: 'Google Play API not configured' };
    }

    const appPackageName = packageName || this.configService.get<string>('GOOGLE_PLAY_PACKAGE_NAME');
    
    if (!appPackageName) {
      throw new BadRequestException('Package name not provided');
    }

    try {
      // Verify subscription purchase
      const response = await this.androidPublisher.purchases.subscriptions.get({
        packageName: appPackageName,
        subscriptionId: productId,
        token: purchaseToken,
      });

      const purchaseData = response.data;

      // Check payment state
      // 0 = Pending, 1 = Received, 2 = Free trial, 3 = Pending deferred upgrade/downgrade
      const paymentState = purchaseData.paymentState;
      const isValid = paymentState === 1 || paymentState === 2;

      if (!isValid && paymentState !== 0) {
        return { success: false, error: 'Purchase not valid' };
      }

      // Parse product info
      const { tier, period } = this.parseProductId(productId);

      // Check expiry
      const expiryTimeMillis = parseInt(purchaseData.expiryTimeMillis || '0');
      const expiresDate = new Date(expiryTimeMillis);
      const isActive = expiresDate > new Date();
      const isTrial = paymentState === 2;

      // Determine status
      let status: 'TRIAL' | 'ACTIVE' | 'CANCELED' | 'EXPIRED' | 'PAST_DUE' = 'ACTIVE';
      
      if (isTrial) {
        status = 'TRIAL';
      } else if (!isActive) {
        status = 'EXPIRED';
      } else if (purchaseData.cancelReason !== undefined && purchaseData.cancelReason !== null) {
        status = 'CANCELED';
      } else if (paymentState === 0) {
        status = 'PAST_DUE';
      }

      // Update or create subscription
      const subscription = await this.prisma.subscription.upsert({
        where: { userId },
        update: {
          provider: PaymentProvider.GOOGLE,
          tier,
          period,
          status,
          currentPeriodEndAt: expiresDate,
          trialEndAt: isTrial ? expiresDate : null,
          externalSubscriptionId: purchaseData.orderId || purchaseToken.substring(0, 50),
          externalProductId: productId,
          metadata: {
            purchaseToken,
            lastValidation: new Date().toISOString(),
            linkedPurchaseToken: purchaseData.linkedPurchaseToken,
            autoRenewing: purchaseData.autoRenewing,
          },
        },
        create: {
          userId,
          provider: PaymentProvider.GOOGLE,
          tier,
          period,
          status,
          startAt: new Date(parseInt(purchaseData.startTimeMillis || Date.now().toString())),
          currentPeriodEndAt: expiresDate,
          trialEndAt: isTrial ? expiresDate : null,
          externalSubscriptionId: purchaseData.orderId || purchaseToken.substring(0, 50),
          externalProductId: productId,
          metadata: { purchaseToken },
        },
      });

      // Record payment if not trial
      if (!isTrial && paymentState === 1) {
        await this.recordPayment(userId, subscription.id, purchaseData, productId);
      }

      this.logger.log(`Google purchase verified for user ${userId}, tier: ${tier}, active: ${isActive}`);

      return { success: true, subscription };
    } catch (error) {
      this.logger.error(`Google purchase verification error: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  /**
   * Handle Google Play Real-Time Developer Notifications (RTDN)
   * 
   * These are sent via Cloud Pub/Sub when subscription status changes.
   */
  async handleNotification(notification: {
    subscriptionNotification?: {
      notificationType: number;
      purchaseToken: string;
      subscriptionId: string;
    };
    packageName: string;
  }): Promise<void> {
    const subNotification = notification.subscriptionNotification;
    
    if (!subNotification) {
      this.logger.warn('No subscription notification in Google RTDN');
      return;
    }

    const { notificationType, purchaseToken, subscriptionId } = subNotification;
    const packageName = notification.packageName;

    this.logger.log(`Processing Google RTDN: type ${notificationType} for ${subscriptionId}`);

    // Find subscription by purchase token in metadata
    const subscription = await this.prisma.subscription.findFirst({
      where: {
        metadata: {
          path: ['purchaseToken'],
          equals: purchaseToken,
        },
      },
    });

    if (!subscription) {
      this.logger.warn(`Subscription not found for purchase token`);
      // Try to verify and create if new
      return;
    }

    /**
     * Notification types:
     * 1 = RECOVERED - Subscription recovered from account hold
     * 2 = RENEWED - Active subscription renewed
     * 3 = CANCELED - Subscription canceled by user
     * 4 = PURCHASED - New subscription purchased
     * 5 = ON_HOLD - Account hold (payment issue)
     * 6 = IN_GRACE_PERIOD - Grace period for failed payment
     * 7 = RESTARTED - User restarted subscription
     * 12 = REVOKED - Subscription revoked (refund)
     * 13 = EXPIRED - Subscription expired
     */
    switch (notificationType) {
      case 1: // RECOVERED
      case 2: // RENEWED
      case 7: // RESTARTED
        await this.handleRenewal(subscription, purchaseToken, subscriptionId, packageName);
        break;
      
      case 3: // CANCELED
        await this.handleCancellation(subscription);
        break;
      
      case 5: // ON_HOLD
      case 6: // IN_GRACE_PERIOD
        await this.handlePaymentIssue(subscription, notificationType);
        break;
      
      case 12: // REVOKED (refund)
        await this.handleRefund(subscription);
        break;
      
      case 13: // EXPIRED
        await this.handleExpiration(subscription);
        break;
      
      default:
        this.logger.log(`Unhandled Google notification type: ${notificationType}`);
    }
  }

  private async handleRenewal(
    subscription: any,
    purchaseToken: string,
    subscriptionId: string,
    packageName: string,
  ): Promise<void> {
    // Re-verify to get latest data
    const result = await this.verifyPurchase(
      subscription.userId,
      purchaseToken,
      subscriptionId,
      packageName,
    );

    if (!result.success) {
      this.logger.error(`Failed to verify renewal: ${result.error}`);
    }
  }

  private async handleCancellation(subscription: any): Promise<void> {
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status: 'CANCELED',
        canceledAt: new Date(),
      },
    });
  }

  private async handlePaymentIssue(subscription: any, notificationType: number): Promise<void> {
    const status = notificationType === 5 ? 'PAUSED' : 'PAST_DUE';
    
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status,
        metadata: {
          ...((subscription.metadata as object) || {}),
          paymentIssue: true,
          paymentIssueType: notificationType === 5 ? 'on_hold' : 'grace_period',
        },
      },
    });
  }

  private async handleRefund(subscription: any): Promise<void> {
    await this.prisma.refund.create({
      data: {
        userId: subscription.userId,
        subscriptionId: subscription.id,
        provider: PaymentProvider.GOOGLE,
        reason: 'Google Play refund',
        status: 'PROCESSED',
        processedAt: new Date(),
      },
    });

    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: { status: 'EXPIRED' },
    });
  }

  private async handleExpiration(subscription: any): Promise<void> {
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: { status: 'EXPIRED' },
    });
  }

  private async recordPayment(
    userId: string,
    subscriptionId: string,
    purchaseData: any,
    productId: string,
  ): Promise<void> {
    const orderId = purchaseData.orderId;
    
    if (!orderId) return;

    const existingPayment = await this.prisma.payment.findFirst({
      where: { externalPaymentId: orderId },
    });

    if (existingPayment) {
      return; // Idempotency
    }

    // Try to get price from product ID
    const price = this.getPriceFromProductId(productId);

    await this.prisma.payment.create({
      data: {
        userId,
        subscriptionId,
        provider: PaymentProvider.GOOGLE,
        amount: price,
        currency: 'USD',
        status: 'COMPLETED',
        paidAt: new Date(parseInt(purchaseData.startTimeMillis || Date.now().toString())),
        externalPaymentId: orderId,
        receiptData: purchaseData,
      },
    });
  }

  private parseProductId(productId: string): { tier: SubscriptionTier; period: BillingPeriod } {
    const id = productId.toLowerCase();
    
    const tier: SubscriptionTier = id.includes('premium') ? 'PREMIUM' : 'STANDARD';
    const period: BillingPeriod = id.includes('yearly') || id.includes('annual') ? 'YEARLY' : 'MONTHLY';
    
    return { tier, period };
  }

  private getPriceFromProductId(productId: string): number {
    const id = productId.toLowerCase();
    
    if (id.includes('premium') && id.includes('yearly')) return 7999;
    if (id.includes('premium')) return 999;
    if (id.includes('yearly')) return 3999;
    return 499; // Standard monthly default
  }
}

