import {
  Controller,
  Post,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
  Headers,
  RawBodyRequest,
  Req,
  Logger,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { AppleIapService } from './apple.service';
import { GoogleIapService } from './google.service';
import { VerifyAppleReceiptDto, VerifyGoogleReceiptDto } from '../dto/verify-receipt.dto';
import { EntitlementsService } from '../entitlements/entitlements.service';
import { Request } from 'express';

@ApiTags('billing/iap')
@Controller('billing/iap')
export class IapController {
  private readonly logger = new Logger(IapController.name);

  constructor(
    private appleIapService: AppleIapService,
    private googleIapService: GoogleIapService,
    private entitlementsService: EntitlementsService,
  ) {}

  /**
   * Verify Apple App Store receipt
   */
  @Post('apple/verify')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify Apple receipt and activate subscription' })
  @ApiResponse({ status: 200, description: 'Receipt verified successfully' })
  @ApiResponse({ status: 400, description: 'Invalid receipt' })
  async verifyAppleReceipt(
    @CurrentUser() user: User,
    @Body() dto: VerifyAppleReceiptDto,
  ) {
    this.logger.log(`Verifying Apple receipt for user ${user.id}`);
    
    const result = await this.appleIapService.verifyReceipt(
      user.id,
      dto.receiptData,
      dto.productId,
      dto.sandbox,
    );

    if (!result.success) {
      return {
        success: false,
        error: result.error,
      };
    }

    // Return updated entitlements
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);

    return {
      success: true,
      subscription: result.subscription,
      entitlements,
    };
  }

  /**
   * Verify Google Play purchase
   */
  @Post('google/verify')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify Google Play purchase and activate subscription' })
  @ApiResponse({ status: 200, description: 'Purchase verified successfully' })
  @ApiResponse({ status: 400, description: 'Invalid purchase' })
  async verifyGooglePurchase(
    @CurrentUser() user: User,
    @Body() dto: VerifyGoogleReceiptDto,
  ) {
    this.logger.log(`Verifying Google purchase for user ${user.id}`);
    
    const result = await this.googleIapService.verifyPurchase(
      user.id,
      dto.purchaseToken,
      dto.productId,
      dto.packageName,
    );

    if (!result.success) {
      return {
        success: false,
        error: result.error,
      };
    }

    // Return updated entitlements
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);

    return {
      success: true,
      subscription: result.subscription,
      entitlements,
    };
  }

  /**
   * Apple Server-to-Server Notification Webhook
   * 
   * Configure in App Store Connect:
   * App > App Information > App Store Server Notifications > Production URL
   */
  @Post('apple/webhook')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Apple S2S notification webhook' })
  async handleAppleWebhook(
    @Req() req: RawBodyRequest<Request>,
    @Body() body: any,
  ) {
    this.logger.log('Received Apple S2S notification');
    
    try {
      await this.appleIapService.handleServerNotification(body);
      return { received: true };
    } catch (error) {
      this.logger.error(`Error processing Apple webhook: ${error.message}`);
      // Return 200 anyway to prevent Apple from retrying
      return { received: true, error: error.message };
    }
  }

  /**
   * Google Play Real-Time Developer Notification Webhook
   * 
   * Configure in Google Play Console:
   * Monetization setup > Real-time developer notifications
   * 
   * This endpoint receives messages from Cloud Pub/Sub
   */
  @Post('google/webhook')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Google Play RTDN webhook' })
  async handleGoogleWebhook(
    @Body() body: { message: { data: string; messageId: string } },
  ) {
    this.logger.log('Received Google RTDN notification');
    
    try {
      // Decode base64 message data
      const messageData = Buffer.from(body.message.data, 'base64').toString('utf8');
      const notification = JSON.parse(messageData);

      await this.googleIapService.handleNotification(notification);
      
      return { success: true };
    } catch (error) {
      this.logger.error(`Error processing Google webhook: ${error.message}`);
      // Return 200 to acknowledge message
      return { success: false, error: error.message };
    }
  }

  /**
   * Restore purchases (for users reinstalling or switching devices)
   */
  @Post('restore')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Restore purchases from App Store or Google Play' })
  async restorePurchases(
    @CurrentUser() user: User,
    @Body() body: { platform: 'ios' | 'android'; receiptData?: string; purchaseToken?: string; productId?: string },
  ) {
    this.logger.log(`Restoring purchases for user ${user.id}, platform: ${body.platform}`);

    let result;

    if (body.platform === 'ios' && body.receiptData) {
      result = await this.appleIapService.verifyReceipt(
        user.id,
        body.receiptData,
        body.productId || '',
        false,
      );
    } else if (body.platform === 'android' && body.purchaseToken && body.productId) {
      result = await this.googleIapService.verifyPurchase(
        user.id,
        body.purchaseToken,
        body.productId,
      );
    } else {
      return {
        success: false,
        error: 'Invalid restore request',
      };
    }

    if (!result.success) {
      return {
        success: false,
        error: result.error,
        message: 'No active subscription found',
      };
    }

    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);

    return {
      success: true,
      subscription: result.subscription,
      entitlements,
      message: 'Purchases restored successfully',
    };
  }
}

