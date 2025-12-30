import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  Headers,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery, ApiHeader } from '@nestjs/swagger';
import { GuidanceService } from './guidance.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { FeedbackDto } from './dto/feedback.dto';
import { User } from '@prisma/client';

@ApiTags('guidance')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('guidance')
export class GuidanceController {
  constructor(private readonly guidanceService: GuidanceService) {}

  /**
   * GET /guidance/today
   * 
   * Get today's guidance for the authenticated user (LAZY COMPUTE).
   * 
   * Flow:
   * 1. Check if guidance exists for today
   * 2. If READY -> return immediately (cached)
   * 3. If PENDING -> wait briefly or return pending status
   * 4. If not exists -> enqueue generation job, wait briefly
   * 
   * Returns either:
   * - Full guidance object with status "READY"
   * - Pending response with status "PENDING" (client should retry)
   */
  @Get('today')
  @ApiOperation({ 
    summary: "Get today's guidance (lazy compute)",
    description: 'Returns cached guidance if available. If not, queues generation and may return PENDING status.'
  })
  @ApiHeader({
    name: 'X-User-Timezone',
    description: 'IANA timezone (e.g., Europe/Bucharest). Falls back to user profile or UTC.',
    required: false,
  })
  async getTodayGuidance(
    @CurrentUser() user: User,
    @Headers('x-user-timezone') timezone?: string,
  ) {
    return this.guidanceService.getTodayGuidance(user, timezone);
  }

  /**
   * GET /guidance/history
   * 
   * Get guidance history for the past N days.
   * Includes status (READY/PENDING/FAILED) for each day.
   */
  @Get('history')
  @ApiOperation({ 
    summary: 'Get guidance history',
    description: 'Returns guidance for the past N days, including their generation status.'
  })
  @ApiQuery({ 
    name: 'days', 
    required: false, 
    type: Number, 
    description: 'Number of days to fetch (default: 7, max: 14)' 
  })
  async getHistory(
    @CurrentUser() user: User,
    @Query('days') days?: string,
  ) {
    const daysNum = Math.min(14, Math.max(1, parseInt(days || '7', 10)));
    return this.guidanceService.getHistory(user.id, daysNum);
  }

  /**
   * POST /guidance/:id/feedback
   * 
   * Submit feedback for a specific guidance.
   */
  @Post(':id/feedback')
  @ApiOperation({ summary: 'Submit feedback for a guidance' })
  async submitFeedback(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() feedbackDto: FeedbackDto,
  ) {
    return this.guidanceService.submitFeedback(user.id, id, feedbackDto);
  }

  /**
   * POST /guidance/regenerate
   * 
   * Force regenerate today's guidance.
   * Deletes existing and triggers new generation.
   */
  @Post('regenerate')
  @ApiOperation({ 
    summary: "Force regenerate today's guidance",
    description: 'Deletes existing guidance for today and queues new generation. Use sparingly.'
  })
  @ApiHeader({
    name: 'X-User-Timezone',
    description: 'IANA timezone (e.g., Europe/Bucharest)',
    required: false,
  })
  async regenerateGuidance(
    @CurrentUser() user: User,
    @Headers('x-user-timezone') timezone?: string,
  ) {
    return this.guidanceService.regenerateGuidance(user, timezone);
  }
}
