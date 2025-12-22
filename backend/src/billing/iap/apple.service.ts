import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionTier, BillingPeriod, PaymentProvider } from '@prisma/client';
import axios from 'axios';
import { PRODUCT_IDS } from '../entitlements/entitlements.types';

/**
 * Apple In-App Purchase Service
 * 
 * Handles receipt validation with App Store Server API
 * 
 * Required ENV vars:
 * - APPLE_SHARED_SECRET: Your App Store shared secret
 * - APPLE_BUNDLE_ID: Your app bundle ID (e.g., com.innerwidsom.app)
 * 
 * For production, you should use the App Store Server API v2 with JWT auth.
 * This implementation uses the verifyReceipt endpoint for simplicity.
 */
@Injectable()
export class AppleIapService {
  private readonly logger = new Logger(AppleIapService.name);
  
  // App Store endpoints
  private readonly SANDBOX_URL = 'https://sandbox.itunes.apple.com/verifyReceipt';
  private readonly PRODUCTION_URL = 'https://buy.itunes.apple.com/verifyReceipt';
  
  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {}

  /**
   * Verify Apple receipt and update subscription
   */
  async verifyReceipt(
    userId: string,
    receiptData: string,
    productId: string,
    useSandbox: boolean = false,
  ): Promise<{ success: boolean; subscription?: any; error?: string }> {
    const sharedSecret = this.configService.get<string>('APPLE_SHARED_SECRET');
    
    if (!sharedSecret) {
      throw new BadRequestException('Apple shared secret not configured');
    }

    try {
      // First try production, fall back to sandbox if status 21007
      let response = await this.callAppleApi(
        useSandbox ? this.SANDBOX_URL : this.PRODUCTION_URL,
        receiptData,
        sharedSecret,
      );

      // Status 21007 means receipt is from sandbox
      if (response.status === 21007 && !useSandbox) {
        this.logger.log('Receipt is from sandbox, retrying...');
        response = await this.callAppleApi(this.SANDBOX_URL, receiptData, sharedSecret);
      }

      // Check for errors
      if (response.status !== 0) {
        this.logger.error(`Apple receipt validation failed: status ${response.status}`);
        return { success: false, error: this.getAppleErrorMessage(response.status) };
      }

      // Find the latest receipt for our product
      const latestReceipt = this.findLatestReceiptForProduct(
        response.latest_receipt_info || response.receipt?.in_app || [],
        productId,
      );

      if (!latestReceipt) {
        return { success: false, error: 'Product not found in receipt' };
      }

      // Parse product info
      const { tier, period } = this.parseProductId(latestReceipt.product_id);
      
      // Check if subscription is active
      const expiresDate = new Date(parseInt(latestReceipt.expires_date_ms));
      const isActive = expiresDate > new Date();
      const isTrial = latestReceipt.is_trial_period === 'true';

      // Update or create subscription
      const subscription = await this.prisma.subscription.upsert({
        where: { userId },
        update: {
          provider: PaymentProvider.APPLE,
          tier,
          period,
          status: isTrial ? 'TRIAL' : (isActive ? 'ACTIVE' : 'EXPIRED'),
          currentPeriodEndAt: expiresDate,
          trialEndAt: isTrial ? expiresDate : null,
          externalSubscriptionId: latestReceipt.original_transaction_id,
          externalProductId: latestReceipt.product_id,
          metadata: {
            lastReceiptValidation: new Date().toISOString(),
            webOrderLineItemId: latestReceipt.web_order_line_item_id,
          },
        },
        create: {
          userId,
          provider: PaymentProvider.APPLE,
          tier,
          period,
          status: isTrial ? 'TRIAL' : 'ACTIVE',
          startAt: new Date(parseInt(latestReceipt.purchase_date_ms)),
          currentPeriodEndAt: expiresDate,
          trialEndAt: isTrial ? expiresDate : null,
          externalSubscriptionId: latestReceipt.original_transaction_id,
          externalProductId: latestReceipt.product_id,
        },
      });

      // Record payment if not trial
      if (!isTrial) {
        await this.recordPayment(userId, subscription.id, latestReceipt);
      }

      this.logger.log(`Apple receipt verified for user ${userId}, tier: ${tier}, active: ${isActive}`);

      return { success: true, subscription };
    } catch (error) {
      this.logger.error(`Apple receipt verification error: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  /**
   * Handle Apple Server-to-Server notifications
   * 
   * These are sent by Apple when subscription status changes:
   * - INITIAL_BUY, DID_RENEW, CANCEL, DID_CHANGE_RENEWAL_STATUS, etc.
   */
  async handleServerNotification(notification: any): Promise<void> {
    const notificationType = notification.notification_type;
    const latestReceiptInfo = notification.latest_receipt_info || notification.unified_receipt?.latest_receipt_info?.[0];

    if (!latestReceiptInfo) {
      this.logger.warn('No receipt info in Apple notification');
      return;
    }

    const originalTransactionId = latestReceiptInfo.original_transaction_id;

    // Find subscription by external ID
    const subscription = await this.prisma.subscription.findFirst({
      where: { externalSubscriptionId: originalTransactionId },
    });

    if (!subscription) {
      this.logger.warn(`Subscription not found for transaction: ${originalTransactionId}`);
      return;
    }

    this.logger.log(`Processing Apple notification: ${notificationType} for user ${subscription.userId}`);

    switch (notificationType) {
      case 'DID_RENEW':
      case 'DID_RECOVER':
        await this.handleRenewal(subscription, latestReceiptInfo);
        break;
      
      case 'CANCEL':
      case 'DID_FAIL_TO_RENEW':
        await this.handleCancellation(subscription, notificationType);
        break;
      
      case 'DID_CHANGE_RENEWAL_STATUS':
        await this.handleRenewalStatusChange(subscription, notification.auto_renew_status);
        break;
      
      case 'REFUND':
        await this.handleRefund(subscription, latestReceiptInfo);
        break;
      
      default:
        this.logger.log(`Unhandled Apple notification type: ${notificationType}`);
    }
  }

  private async handleRenewal(subscription: any, receiptInfo: any): Promise<void> {
    const expiresDate = new Date(parseInt(receiptInfo.expires_date_ms));
    
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status: 'ACTIVE',
        currentPeriodEndAt: expiresDate,
      },
    });

    await this.recordPayment(subscription.userId, subscription.id, receiptInfo);
  }

  private async handleCancellation(subscription: any, reason: string): Promise<void> {
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status: 'CANCELED',
        canceledAt: new Date(),
        metadata: {
          ...((subscription.metadata as object) || {}),
          cancellationReason: reason,
        },
      },
    });
  }

  private async handleRenewalStatusChange(subscription: any, autoRenewStatus: string): Promise<void> {
    const willRenew = autoRenewStatus === '1';
    
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: {
        status: willRenew ? 'ACTIVE' : 'CANCELED',
        metadata: {
          ...((subscription.metadata as object) || {}),
          autoRenewStatus: willRenew,
        },
      },
    });
  }

  private async handleRefund(subscription: any, receiptInfo: any): Promise<void> {
    // Create refund record
    await this.prisma.refund.create({
      data: {
        userId: subscription.userId,
        subscriptionId: subscription.id,
        provider: PaymentProvider.APPLE,
        reason: 'Apple refund',
        status: 'PROCESSED',
        externalRefundId: receiptInfo.transaction_id,
        processedAt: new Date(),
      },
    });

    // Update subscription status
    await this.prisma.subscription.update({
      where: { id: subscription.id },
      data: { status: 'EXPIRED' },
    });
  }

  private async recordPayment(userId: string, subscriptionId: string, receiptInfo: any): Promise<void> {
    const existingPayment = await this.prisma.payment.findFirst({
      where: { externalPaymentId: receiptInfo.transaction_id },
    });

    if (existingPayment) {
      return; // Idempotency: don't create duplicate payments
    }

    await this.prisma.payment.create({
      data: {
        userId,
        subscriptionId,
        provider: PaymentProvider.APPLE,
        amount: 0, // Apple doesn't provide price in receipt
        currency: 'USD',
        status: 'COMPLETED',
        paidAt: new Date(parseInt(receiptInfo.purchase_date_ms)),
        externalPaymentId: receiptInfo.transaction_id,
        receiptData: receiptInfo,
      },
    });
  }

  private async callAppleApi(url: string, receiptData: string, sharedSecret: string): Promise<any> {
    const response = await axios.post(url, {
      'receipt-data': receiptData,
      'password': sharedSecret,
      'exclude-old-transactions': true,
    });
    return response.data;
  }

  private findLatestReceiptForProduct(receipts: any[], productId: string): any {
    const productReceipts = receipts.filter(r => 
      r.product_id === productId || 
      Object.values(PRODUCT_IDS.APPLE).includes(r.product_id)
    );
    
    if (productReceipts.length === 0) {
      return receipts.length > 0 ? receipts[receipts.length - 1] : null;
    }

    return productReceipts.sort((a, b) => 
      parseInt(b.expires_date_ms || '0') - parseInt(a.expires_date_ms || '0')
    )[0];
  }

  private parseProductId(productId: string): { tier: SubscriptionTier; period: BillingPeriod } {
    const id = productId.toLowerCase();
    
    const tier: SubscriptionTier = id.includes('premium') ? 'PREMIUM' : 'STANDARD';
    const period: BillingPeriod = id.includes('yearly') || id.includes('annual') ? 'YEARLY' : 'MONTHLY';
    
    return { tier, period };
  }

  private getAppleErrorMessage(status: number): string {
    const errorMessages: Record<number, string> = {
      21000: 'The request was not made using HTTP POST',
      21002: 'The data in the receipt-data property was malformed',
      21003: 'The receipt could not be authenticated',
      21004: 'The shared secret does not match',
      21005: 'The receipt server is temporarily unavailable',
      21006: 'This receipt is valid but the subscription has expired',
      21007: 'This receipt is from the test environment',
      21008: 'This receipt is from the production environment',
      21010: 'This receipt could not be authorized',
    };
    return errorMessages[status] || `Unknown error: ${status}`;
  }
}

