import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { ContextService } from './context.service';
import {
  ContextAnswersDto,
  ContextProfileResponseDto,
  ContextStatusResponseDto,
} from './dto/context-answers.dto';

@ApiTags('context')
@Controller('context')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ContextController {
  constructor(private contextService: ContextService) {}

  /**
   * GET /context/profile
   *
   * Get user's current context profile
   */
  @Get('profile')
  @ApiOperation({ summary: 'Get current context profile' })
  @ApiResponse({ status: 200, type: ContextProfileResponseDto })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async getProfile(@CurrentUser() user: User) {
    const profile = await this.contextService.getProfile(user.id);

    if (!profile) {
      return {
        hasProfile: false,
        profile: null,
      };
    }

    return {
      hasProfile: true,
      profile,
    };
  }

  /**
   * GET /context/status
   *
   * Check if user needs to review their context (90-day check)
   */
  @Get('status')
  @ApiOperation({ summary: 'Check context review status' })
  @ApiResponse({ status: 200, type: ContextStatusResponseDto })
  async getStatus(@CurrentUser() user: User) {
    return this.contextService.checkReviewStatus(user.id);
  }

  /**
   * POST /context/profile
   *
   * Create initial context profile (onboarding)
   */
  @Post('profile')
  @ApiOperation({
    summary: 'Create context profile (onboarding)',
    description:
      'Creates the initial context profile. Calls OpenAI to generate summary.',
  })
  @ApiResponse({
    status: 201,
    description: 'Profile created successfully',
    type: ContextProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Profile already exists or validation error',
  })
  async createProfile(
    @CurrentUser() user: User,
    @Body() answers: ContextAnswersDto,
  ) {
    return this.contextService.createProfile(user.id, answers);
  }

  /**
   * PUT /context/profile
   *
   * Update existing context profile (settings / 90-day refresh)
   */
  @Put('profile')
  @ApiOperation({
    summary: 'Update context profile',
    description:
      'Updates the context profile. Archives old version and regenerates summary.',
  })
  @ApiResponse({
    status: 200,
    description: 'Profile updated successfully',
    type: ContextProfileResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async updateProfile(
    @CurrentUser() user: User,
    @Body() answers: ContextAnswersDto,
  ) {
    return this.contextService.updateProfile(user.id, answers);
  }

  /**
   * POST /context/review/defer
   *
   * Defer review (user selected "No changes" in 90-day prompt)
   */
  @Post('review/defer')
  @ApiOperation({
    summary: 'Defer context review',
    description: 'Extends next review date by 90 days',
  })
  @ApiResponse({
    status: 200,
    description: 'Review deferred successfully',
    schema: {
      type: 'object',
      properties: {
        success: { type: 'boolean' },
        nextReviewAt: { type: 'string', format: 'date-time' },
      },
    },
  })
  async deferReview(@CurrentUser() user: User) {
    return this.contextService.deferReview(user.id);
  }

  /**
   * GET /context/history
   *
   * Get profile version history (for settings display)
   */
  @Get('history')
  @ApiOperation({ summary: 'Get context profile history' })
  async getHistory(@CurrentUser() user: User) {
    return this.contextService.getProfileHistory(user.id);
  }

  /**
   * DELETE /context/profile
   *
   * Delete context profile (GDPR / user request)
   */
  @Delete('profile')
  @ApiOperation({ summary: 'Delete context profile' })
  async deleteProfile(@CurrentUser() user: User) {
    await this.contextService.deleteProfile(user.id);
    return { success: true, message: 'Context profile deleted' };
  }
}

