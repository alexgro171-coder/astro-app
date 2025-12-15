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
   * Get today's guidance for the authenticated user.
   * 
   * IMPORTANT: Guidance is generated ON-DEMAND when this endpoint is called.
   * - If guidance exists for today → returns cached version
   * - If not → generates new guidance (calls AstrologyAPI + OpenAI)
   * 
   * This approach distributes load evenly instead of spiking at a specific time.
   */
  @Get('today')
  @ApiOperation({ 
    summary: "Get today's guidance (on-demand generation)",
    description: 'Returns cached guidance if available, otherwise generates new guidance by calling AstrologyAPI and OpenAI.'
  })
  @ApiHeader({
    name: 'X-User-Timezone',
    description: 'User timezone (e.g., Europe/Bucharest). Falls back to user profile timezone or UTC.',
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
   * Get paginated guidance history for the user.
   */
  @Get('history')
  @ApiOperation({ summary: 'Get guidance history' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number (default: 1)' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Items per page (default: 10, max: 30)' })
  async getHistory(
    @CurrentUser() user: User,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const pageNum = Math.max(1, parseInt(page || '1', 10));
    const limitNum = Math.min(30, Math.max(1, parseInt(limit || '10', 10)));
    
    return this.guidanceService.getHistory(user.id, pageNum, limitNum);
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
   * Useful if user wants a fresh perspective or if there was an error.
   */
  @Post('regenerate')
  @ApiOperation({ 
    summary: "Force regenerate today's guidance",
    description: 'Deletes existing guidance for today and generates new one. Use sparingly as it calls external APIs.'
  })
  @ApiHeader({
    name: 'X-User-Timezone',
    description: 'User timezone (e.g., Europe/Bucharest)',
    required: false,
  })
  async regenerateGuidance(
    @CurrentUser() user: User,
    @Headers('x-user-timezone') timezone?: string,
  ) {
    const guidance = await this.guidanceService.regenerateGuidance(user, timezone);
    return this.guidanceService['formatGuidanceResponse'](guidance);
  }
}
