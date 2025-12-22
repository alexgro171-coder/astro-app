import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SaveContextAnswersDto, ONBOARDING_QUESTIONS } from './dto/context-answers.dto';

/**
 * OnboardingService
 * 
 * Manages user context profiles for personalized AI guidance.
 * 
 * Premium users: Context is used in AI prompts
 * Standard users: Context is stored but NOT used in prompts
 */
@Injectable()
export class OnboardingService {
  private readonly logger = new Logger(OnboardingService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Get onboarding questions with user's existing answers
   */
  async getQuestions(userId: string) {
    const existingProfile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    return {
      questions: ONBOARDING_QUESTIONS,
      completed: !!existingProfile?.completedAt,
      existingAnswers: existingProfile?.answers || null,
    };
  }

  /**
   * Save or update user's context answers
   */
  async saveContextAnswers(userId: string, dto: SaveContextAnswersDto) {
    // Convert array of answers to object
    const answersObject: Record<string, any> = {};
    for (const answer of dto.answers) {
      answersObject[answer.questionId] = answer.answer;
    }

    // Generate AI-friendly summary from answers
    const summary = this.generateContextSummary(answersObject);

    const contextProfile = await this.prisma.userContextProfile.upsert({
      where: { userId },
      update: {
        answers: answersObject,
        summary,
        preferredTone: dto.preferredTone || null,
        priorityAreas: dto.priorityAreas || [],
        completedAt: new Date(),
      },
      create: {
        userId,
        answers: answersObject,
        summary,
        preferredTone: dto.preferredTone || null,
        priorityAreas: dto.priorityAreas || [],
        completedAt: new Date(),
      },
    });

    this.logger.log(`Context profile saved for user ${userId}`);

    return {
      success: true,
      profileId: contextProfile.id,
      summary,
    };
  }

  /**
   * Get user's context profile
   */
  async getContextProfile(userId: string) {
    return this.prisma.userContextProfile.findUnique({
      where: { userId },
    });
  }

  /**
   * Get context summary for AI prompt (only for Premium users)
   * 
   * This returns a formatted string that can be injected into the AI prompt.
   */
  async getContextForAI(userId: string): Promise<string | null> {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    if (!profile || !profile.completedAt) {
      return null;
    }

    return profile.summary;
  }

  /**
   * Generate a human-readable summary from answers
   * This is what gets injected into the AI prompt for Premium users
   */
  private generateContextSummary(answers: Record<string, any>): string {
    const parts: string[] = [];

    // Relationship status
    if (answers.relationship_status && answers.relationship_status !== 'Prefer not to say') {
      parts.push(`Relationship: ${answers.relationship_status}`);
    }

    // Career
    if (answers.career_situation) {
      parts.push(`Career: ${answers.career_situation}`);
    }

    // Life focus areas
    if (answers.main_life_focus && Array.isArray(answers.main_life_focus)) {
      parts.push(`Focus areas: ${answers.main_life_focus.join(', ')}`);
    }

    // Stress level
    if (answers.stress_level) {
      parts.push(`Stress level: ${answers.stress_level}`);
    }

    // Current challenge (if provided)
    if (answers.current_challenge && typeof answers.current_challenge === 'string' && answers.current_challenge.trim()) {
      parts.push(`Current challenge: ${answers.current_challenge.trim()}`);
    }

    // Astrology experience
    if (answers.astrology_experience) {
      parts.push(`Astrology knowledge: ${answers.astrology_experience}`);
    }

    return parts.join('. ') + '.';
  }

  /**
   * Get preferred tone for user
   */
  async getPreferredTone(userId: string): Promise<string> {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    return profile?.preferredTone || 'balanced';
  }

  /**
   * Check if user has completed context profile
   */
  async hasCompletedProfile(userId: string): Promise<boolean> {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
      select: { completedAt: true },
    });

    return !!profile?.completedAt;
  }

  /**
   * Delete user's context profile
   */
  async deleteProfile(userId: string): Promise<void> {
    await this.prisma.userContextProfile.delete({
      where: { userId },
    }).catch(() => {
      // Ignore if doesn't exist
    });
  }
}

