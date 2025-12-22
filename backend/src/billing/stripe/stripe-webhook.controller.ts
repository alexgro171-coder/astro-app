import {
  Controller,
  Post,
  Headers,
  RawBodyRequest,
  Req,
  HttpCode,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiExcludeEndpoint } from '@nestjs/swagger';
import { Request } from 'express';
import { StripeService } from './stripe.service';
import { Public } from '../../auth/decorators/public.decorator';

/**
 * Stripe Webhook Controller
 * 
 * Receives webhook events from Stripe.
 * This endpoint must be public (no auth) and handle raw body for signature verification.
 * 
 * Configure in Stripe Dashboard:
 * Developers > Webhooks > Add endpoint
 * URL: https://api.yourapp.com/api/v1/billing/stripe/webhook
 * Events to send:
 *   - checkout.session.completed
 *   - customer.subscription.created
 *   - customer.subscription.updated
 *   - customer.subscription.deleted
 *   - invoice.paid
 *   - invoice.payment_failed
 *   - charge.refunded
 */
@ApiTags('billing/stripe')
@Controller('billing/stripe')
export class StripeWebhookController {
  private readonly logger = new Logger(StripeWebhookController.name);

  constructor(private stripeService: StripeService) {}

  @Post('webhook')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Stripe webhook endpoint' })
  @ApiExcludeEndpoint() // Hide from Swagger docs
  async handleWebhook(
    @Req() req: RawBodyRequest<Request>,
    @Headers('stripe-signature') signature: string,
  ) {
    if (!req.rawBody) {
      this.logger.error('No raw body available for webhook');
      return { received: false, error: 'No raw body' };
    }

    try {
      await this.stripeService.handleWebhook(req.rawBody, signature);
      return { received: true };
    } catch (error) {
      this.logger.error(`Stripe webhook error: ${error.message}`);
      // Return 200 to prevent Stripe from retrying on validation errors
      return { received: true, error: error.message };
    }
  }
}

