import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { OnboardingService } from './onboarding.service';
import { SaveContextAnswersDto, ContextQuestionsResponseDto } from './dto/context-answers.dto';

@ApiTags('onboarding')
@Controller('onboarding')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class OnboardingController {
  constructor(private onboardingService: OnboardingService) {}

  /**
   * Get onboarding questions
   * 
   * Returns the list of questions for personal context collection,
   * along with any existing answers the user has provided.
   */
  @Get('questions')
  @ApiOperation({ summary: 'Get context questions with existing answers' })
  @ApiResponse({ status: 200, type: ContextQuestionsResponseDto })
  async getQuestions(@CurrentUser() user: User) {
    return this.onboardingService.getQuestions(user.id);
  }

  /**
   * Save context answers
   * 
   * Saves the user's answers to personalization questions.
   * These are used for Premium users' AI guidance.
   */
  @Post('context')
  @ApiOperation({ summary: 'Save personal context answers' })
  async saveContext(
    @CurrentUser() user: User,
    @Body() dto: SaveContextAnswersDto,
  ) {
    return this.onboardingService.saveContextAnswers(user.id, dto);
  }

  /**
   * Get user's context profile
   */
  @Get('context')
  @ApiOperation({ summary: 'Get saved context profile' })
  async getContext(@CurrentUser() user: User) {
    const profile = await this.onboardingService.getContextProfile(user.id);
    
    if (!profile) {
      return {
        completed: false,
        profile: null,
      };
    }

    return {
      completed: !!profile.completedAt,
      profile: {
        answers: profile.answers,
        summary: profile.summary,
        preferredTone: profile.preferredTone,
        priorityAreas: profile.priorityAreas,
        completedAt: profile.completedAt,
      },
    };
  }

  /**
   * Delete context profile
   * 
   * Allows user to reset their personalization data.
   */
  @Delete('context')
  @ApiOperation({ summary: 'Delete context profile' })
  async deleteContext(@CurrentUser() user: User) {
    await this.onboardingService.deleteProfile(user.id);
    return { success: true, message: 'Context profile deleted' };
  }

  /**
   * Check onboarding completion status
   */
  @Get('status')
  @ApiOperation({ summary: 'Get onboarding completion status' })
  async getStatus(@CurrentUser() user: User) {
    const hasContext = await this.onboardingService.hasCompletedProfile(user.id);
    
    return {
      birthDataComplete: user.onboardingComplete,
      contextComplete: hasContext,
      fullyComplete: user.onboardingComplete && hasContext,
    };
  }
}

