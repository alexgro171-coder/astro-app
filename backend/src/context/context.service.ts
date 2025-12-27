import { Injectable, Logger, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ContextSummarizerService, ContextTags } from './context-summarizer.service';
import { ContextAnswersDto } from './dto/context-answers.dto';

const REVIEW_INTERVAL_DAYS = 90;

/**
 * ContextService
 *
 * Manages user context profiles (V1 Questionnaire):
 * - Create profile on onboarding
 * - Update profile (settings / 90-day review)
 * - Track history for audit
 * - Provide context for AI prompts (Premium only)
 */
@Injectable()
export class ContextService {
  private readonly logger = new Logger(ContextService.name);

  constructor(
    private prisma: PrismaService,
    private summarizerService: ContextSummarizerService,
  ) {}

  /**
   * Get user's current context profile
   */
  async getProfile(userId: string) {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    if (!profile) {
      return null;
    }

    return {
      id: profile.id,
      version: profile.version,
      answers: profile.answersJson as unknown as ContextAnswersDto,
      summary60w: profile.summary60w ?? null,
      summaryTags: (profile.summaryTags as unknown as ContextTags) ?? [],
      nextReviewAt: profile.nextReviewAt,
      completedAt: profile.completedAt,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    };
  }

  /**
   * Check if user needs review prompt
   */
  async checkReviewStatus(userId: string) {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
      select: {
        nextReviewAt: true,
        version: true,
      },
    });

    if (!profile) {
      return {
        hasProfile: false,
        needsReview: false,
      };
    }

    const now = new Date();
    const needsReview = profile.nextReviewAt <= now;

    return {
      hasProfile: true,
      needsReview,
      nextReviewAt: profile.nextReviewAt,
      currentVersion: profile.version,
    };
  }

  /**
   * Create initial context profile (onboarding)
   */
  async createProfile(userId: string, answers: ContextAnswersDto) {
    // Check if profile already exists
    const existing = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    if (existing) {
      throw new BadRequestException(
        'Context profile already exists. Use update endpoint instead.',
      );
    }

    // Generate AI summary and tags
    this.logger.log(`Generating context summary for user ${userId}`);
    const { summary60w, tags } = await this.summarizerService.generateSummary(answers);

    // Calculate next review date (90 days from now)
    const nextReviewAt = new Date();
    nextReviewAt.setDate(nextReviewAt.getDate() + REVIEW_INTERVAL_DAYS);

    // Create profile
    const profile = await this.prisma.userContextProfile.create({
      data: {
        userId,
        version: 1,
        answersJson: answers as any,
        summary60w,
        summaryTags: tags as any,
        nextReviewAt,
        completedAt: new Date(),
      },
    });

    this.logger.log(`Created context profile v1 for user ${userId}`);

    return {
      id: profile.id,
      version: profile.version,
      answers,
      summary60w: profile.summary60w,
      summaryTags: profile.summaryTags,
      nextReviewAt: profile.nextReviewAt,
      completedAt: profile.completedAt,
    };
  }

  /**
   * Update existing context profile (settings / 90-day review)
   */
  async updateProfile(userId: string, answers: ContextAnswersDto) {
    // Get existing profile
    const existing = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    if (!existing) {
      throw new NotFoundException(
        'Context profile not found. Use create endpoint first.',
      );
    }

    // Save current version to history
    await this.prisma.userContextProfileHistory.create({
      data: {
        userId,
        profileId: existing.id,
        version: existing.version,
        answersJson: existing.answersJson as any,
        summary60w: existing.summary60w,
        summaryTags: existing.summaryTags as any,
      },
    });

    this.logger.log(`Archived context profile v${existing.version} for user ${userId}`);

    // Generate new AI summary
    const { summary60w, tags } = await this.summarizerService.generateSummary(answers);

    // Calculate next review date
    const nextReviewAt = new Date();
    nextReviewAt.setDate(nextReviewAt.getDate() + REVIEW_INTERVAL_DAYS);

    // Update profile
    const profile = await this.prisma.userContextProfile.update({
      where: { userId },
      data: {
        version: existing.version + 1,
        answersJson: answers as any,
        summary60w,
        summaryTags: tags as any,
        nextReviewAt,
        completedAt: new Date(),
      },
    });

    this.logger.log(`Updated context profile to v${profile.version} for user ${userId}`);

    return {
      id: profile.id,
      version: profile.version,
      answers,
      summary60w: profile.summary60w,
      summaryTags: profile.summaryTags,
      nextReviewAt: profile.nextReviewAt,
      completedAt: profile.completedAt,
    };
  }

  /**
   * Defer review (user selected "No changes")
   */
  async deferReview(userId: string) {
    const existing = await this.prisma.userContextProfile.findUnique({
      where: { userId },
    });

    if (!existing) {
      throw new NotFoundException('Context profile not found.');
    }

    // Add 90 days to current next_review_at
    const nextReviewAt = new Date(existing.nextReviewAt);
    nextReviewAt.setDate(nextReviewAt.getDate() + REVIEW_INTERVAL_DAYS);

    await this.prisma.userContextProfile.update({
      where: { userId },
      data: { nextReviewAt },
    });

    this.logger.log(`Deferred context review for user ${userId} to ${nextReviewAt.toISOString()}`);

    return {
      success: true,
      nextReviewAt,
    };
  }

  /**
   * Get context for AI prompt (Premium only)
   *
   * Returns the summary and tags that should be included in the AI prompt.
   * The caller is responsible for checking entitlements.
   */
  async getContextForAI(userId: string): Promise<{
    summary60w: string;
    tags: ContextTags;
    tonePreference: string;
  } | null> {
    const profile = await this.prisma.userContextProfile.findUnique({
      where: { userId },
      select: {
        summary60w: true,
        summaryTags: true,
        completedAt: true,
      },
    });

    if (!profile || !profile.completedAt) {
      return null;
    }

    const tags = profile.summaryTags as unknown as ContextTags;

    return {
      summary60w: profile.summary60w,
      tags,
      tonePreference: tags?.tone_preference || 'balanced',
    };
  }

  /**
   * Get profile history (for audit/settings display)
   */
  async getProfileHistory(userId: string) {
    const history = await this.prisma.userContextProfileHistory.findMany({
      where: { userId },
      orderBy: { version: 'desc' },
      take: 10,
    });

    return history.map((h) => ({
      version: h.version,
      summary60w: h.summary60w,
      createdAt: h.createdAt,
    }));
  }

  /**
   * Delete context profile (GDPR / user request)
   */
  async deleteProfile(userId: string) {
    // Delete history first (foreign key constraint)
    await this.prisma.userContextProfileHistory.deleteMany({
      where: { userId },
    });

    // Delete main profile
    await this.prisma.userContextProfile.delete({
      where: { userId },
    }).catch(() => {
      // Ignore if doesn't exist
    });

    this.logger.log(`Deleted context profile for user ${userId}`);
  }
}

