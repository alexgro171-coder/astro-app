import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Headers,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { AskGuideService } from './ask-guide.service';
import {
  AskGuideQuestionDto,
  AskGuideUsageResponseDto,
  AskGuideRequestResponseDto,
  AskGuideHistoryResponseDto,
} from './dto/ask-guide.dto';
import {
  PurchaseAddonDto,
  AddonPurchaseResponseDto,
  AddonStatusResponseDto,
} from './dto/purchase-addon.dto';

@Controller('ask-guide')
@UseGuards(JwtAuthGuard)
export class AskGuideController {
  constructor(private readonly askGuideService: AskGuideService) {}

  /**
   * Get current usage status.
   * Returns request count, limit, remaining, and billing period end date.
   */
  @Get('usage')
  async getUsage(@CurrentUser() user: User): Promise<AskGuideUsageResponseDto> {
    return this.askGuideService.getUsage(user.id);
  }

  /**
   * Submit a new question.
   */
  @Post('ask')
  async askQuestion(
    @CurrentUser() user: User,
    @Body() dto: AskGuideQuestionDto,
    @Headers('accept-language') acceptLanguage?: string,
  ): Promise<AskGuideRequestResponseDto> {
    return this.askGuideService.askQuestion(user, dto, acceptLanguage);
  }

  /**
   * Get Q&A history with usage info.
   */
  @Get('history')
  async getHistory(
    @CurrentUser() user: User,
    @Query('limit') limit?: string,
  ): Promise<AskGuideHistoryResponseDto> {
    const limitNum = limit ? parseInt(limit, 10) : 20;
    return this.askGuideService.getHistory(user.id, limitNum);
  }

  /**
   * Get a specific request by ID.
   */
  @Get('request/:id')
  async getRequest(
    @CurrentUser() user: User,
    @Param('id') requestId: string,
  ): Promise<AskGuideRequestResponseDto> {
    return this.askGuideService.getRequest(user.id, requestId);
  }

  /**
   * Get add-on status (can purchase, price, etc.)
   */
  @Get('addon/status')
  async getAddonStatus(@CurrentUser() user: User): Promise<AddonStatusResponseDto> {
    return this.askGuideService.getAddonStatus(user.id);
  }

  /**
   * Purchase add-on to extend monthly limit.
   */
  @Post('addon/purchase')
  async purchaseAddon(
    @CurrentUser() user: User,
    @Body() dto: PurchaseAddonDto,
  ): Promise<AddonPurchaseResponseDto> {
    return this.askGuideService.purchaseAddon(user.id, dto);
  }
}
