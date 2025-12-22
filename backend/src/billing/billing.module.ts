import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../prisma/prisma.module';

// Controllers
import { BillingController } from './billing.controller';
import { IapController } from './iap/iap.controller';
import { StripeWebhookController } from './stripe/stripe-webhook.controller';

// Services
import { EntitlementsService } from './entitlements/entitlements.service';
import { AppleIapService } from './iap/apple.service';
import { GoogleIapService } from './iap/google.service';
import { StripeService } from './stripe/stripe.service';

/**
 * BillingModule
 * 
 * Handles all monetization:
 * - Entitlements resolution
 * - IAP (Apple/Google) verification
 * - Stripe payments
 * - Refunds
 * 
 * Required ENV vars:
 * - APPLE_SHARED_SECRET: App Store Connect shared secret
 * - GOOGLE_SERVICE_ACCOUNT_KEY: Base64 encoded service account JSON
 * - GOOGLE_PLAY_PACKAGE_NAME: Android package name
 * - STRIPE_SECRET_KEY: Stripe API key
 * - STRIPE_WEBHOOK_SECRET: Stripe webhook signing secret
 */
@Module({
  imports: [
    ConfigModule,
    PrismaModule,
  ],
  controllers: [
    BillingController,
    IapController,
    StripeWebhookController,
  ],
  providers: [
    EntitlementsService,
    AppleIapService,
    GoogleIapService,
    StripeService,
  ],
  exports: [
    EntitlementsService,
    AppleIapService,
    GoogleIapService,
    StripeService,
  ],
})
export class BillingModule {}

