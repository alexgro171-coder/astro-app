import {
  Injectable,
  Logger,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { ContextService } from '../context/context.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { User, Language, AskGuideStatus } from '@prisma/client';
import OpenAI from 'openai';
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

const MONTHLY_LIMIT = 40;

@Injectable()
export class AskGuideService {
  private readonly logger = new Logger(AskGuideService.name);
  private readonly openai: OpenAI;
  private readonly model: string;

  constructor(
    private prisma: PrismaService,
    private astrologyService: AstrologyService,
    private contextService: ContextService,
    private entitlementsService: EntitlementsService,
    private configService: ConfigService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-5-mini');
  }

  /**
   * Get user's current usage for the billing month.
   */
  async getUsage(userId: string): Promise<AskGuideUsageResponseDto> {
    const { billingMonthStart, billingMonthEnd } = await this.getBillingPeriod(userId);

    // Get or create usage record
    let usage = await this.prisma.askGuideUsage.findUnique({
      where: {
        userId_billingMonthStart: { userId, billingMonthStart },
      },
    });

    if (!usage) {
      usage = await this.prisma.askGuideUsage.create({
        data: {
          userId,
          billingMonthStart,
          billingMonthEnd,
          requestCount: 0,
          limitCount: MONTHLY_LIMIT,
        },
      });
    }

    // Check for add-on
    const addon = await this.prisma.askGuideAddon.findUnique({
      where: {
        userId_billingMonthStart: { userId, billingMonthStart },
      },
    });

    const hasAddon = !!addon && addon.status === 'COMPLETED';
    const effectiveLimit = hasAddon ? usage.limitCount * 2 : usage.limitCount; // Double limit with add-on
    const remaining = Math.max(0, effectiveLimit - usage.requestCount);

    return {
      requestCount: usage.requestCount,
      limitCount: effectiveLimit,
      remaining,
      hasAddon,
      billingMonthEnd: billingMonthEnd.toISOString().split('T')[0],
      canRequest: remaining > 0,
    };
  }

  /**
   * Submit a question to Ask Your Guide.
   */
  async askQuestion(
    user: User,
    dto: AskGuideQuestionDto,
    acceptLanguage?: string,
  ): Promise<AskGuideRequestResponseDto> {
    // Check usage limits
    const usage = await this.getUsage(user.id);
    
    if (!usage.canRequest) {
      throw new ForbiddenException({
        message: 'You have reached your monthly limit of requests.',
        code: 'LIMIT_REACHED',
        billingMonthEnd: usage.billingMonthEnd,
        hasAddon: usage.hasAddon,
      });
    }

    // Verify user has subscription access
    const hasAccess = await this.entitlementsService.hasAccess(user.id);
    if (!hasAccess) {
      throw new ForbiddenException({
        message: 'Active subscription required to use Ask Your Guide.',
        code: 'NO_SUBSCRIPTION',
      });
    }

    // Check for natal chart
    const natalChart = await this.astrologyService.getNatalChart(user.id);
    if (!natalChart) {
      throw new BadRequestException('Natal chart required. Please complete your birth data first.');
    }

    // Resolve locale
    const locale = dto.locale || acceptLanguage?.split(',')[0]?.split('-')[0] || user.language?.toLowerCase() || 'en';

    // Create the request record
    const request = await this.prisma.askGuideRequest.create({
      data: {
        userId: user.id,
        question: dto.question,
        status: 'PENDING',
        locale,
      },
    });

    // Generate answer asynchronously
    try {
      const answer = await this.generateAnswer(user, dto.question, natalChart, locale);

      // Update request with answer
      const updatedRequest = await this.prisma.askGuideRequest.update({
        where: { id: request.id },
        data: {
          answer,
          status: 'READY',
        },
      });

      // Increment usage counter
      await this.incrementUsage(user.id);

      return {
        id: updatedRequest.id,
        question: updatedRequest.question,
        answer: updatedRequest.answer || undefined,
        status: updatedRequest.status as 'PENDING' | 'READY' | 'FAILED',
        createdAt: updatedRequest.createdAt.toISOString(),
      };
    } catch (error) {
      this.logger.error(`Failed to generate answer: ${error.message}`, error.stack);

      // Update request with error
      const failedRequest = await this.prisma.askGuideRequest.update({
        where: { id: request.id },
        data: {
          status: 'FAILED',
          errorMsg: error.message,
        },
      });

      return {
        id: failedRequest.id,
        question: failedRequest.question,
        status: 'FAILED',
        errorMsg: failedRequest.errorMsg || undefined,
        createdAt: failedRequest.createdAt.toISOString(),
      };
    }
  }

  /**
   * Get request history for user.
   */
  async getHistory(userId: string, limit: number = 20): Promise<AskGuideHistoryResponseDto> {
    const requests = await this.prisma.askGuideRequest.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    const usage = await this.getUsage(userId);

    return {
      requests: requests.map((r) => ({
        id: r.id,
        question: r.question,
        answer: r.answer || undefined,
        status: r.status as 'PENDING' | 'READY' | 'FAILED',
        errorMsg: r.errorMsg || undefined,
        createdAt: r.createdAt.toISOString(),
      })),
      usage,
    };
  }

  /**
   * Get a single request by ID.
   */
  async getRequest(userId: string, requestId: string): Promise<AskGuideRequestResponseDto> {
    const request = await this.prisma.askGuideRequest.findFirst({
      where: { id: requestId, userId },
    });

    if (!request) {
      throw new NotFoundException('Request not found');
    }

    return {
      id: request.id,
      question: request.question,
      answer: request.answer || undefined,
      status: request.status as 'PENDING' | 'READY' | 'FAILED',
      errorMsg: request.errorMsg || undefined,
      createdAt: request.createdAt.toISOString(),
    };
  }

  /**
   * Generate AI answer based on natal chart and transits.
   */
  private async generateAnswer(
    user: User,
    question: string,
    natalChart: any,
    locale: string,
  ): Promise<string> {
    // Get current transits
    const today = new Date();
    const transits = await this.astrologyService.getDailyTransits(user, today);

    // Get personal context (if available)
    let personalContext = null;
    try {
      const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
      if (entitlements.canUsePersonalContext) {
        const context = await this.contextService.getContextForAI(user.id);
        if (context) {
          personalContext = {
            summary60w: context.summary60w,
            tags: context.tags,
          };
        }
      }
    } catch (e) {
      this.logger.warn(`Failed to get personal context: ${e.message}`);
    }

    // Get user gender for personalized language
    const genderStr = this.mapGenderToString(user.gender);
    const genderInfo = genderStr ? `The user is ${genderStr}. ` : '';

    // Build language instructions
    const languageInstructions = this.getLanguageInstructions(locale);

    // Build personal context section
    let personalContextSection = '';
    if (personalContext) {
      const genderFromContext = personalContext.tags?.gender ? `The user is ${personalContext.tags.gender}. ` : '';
      personalContextSection = `
PERSONAL CONTEXT (use to tailor your response):
${genderFromContext || genderInfo}${personalContext.summary60w}
Key priorities: ${personalContext.tags?.priorities?.join(', ') || 'general well-being'}
Tone preference: ${personalContext.tags?.tone_preference || 'balanced'}
`;
    } else if (genderInfo) {
      personalContextSection = `\nPERSONAL CONTEXT:\n${genderInfo}\n`;
    }

    const systemPrompt = `You are a wise, compassionate personal astrologer and spiritual guide. You provide deeply personalized guidance based on the user's natal chart and current planetary transits.

${languageInstructions}

ROLE:
- You are "Your Guide" - a trusted advisor who combines astrological wisdom with practical, empathetic guidance
- Speak directly to the user in second person ("you")
- Be warm, supportive, and specific to their situation
- Reference specific planetary positions and transits when relevant

RULES:
- Always connect your answer to the user's natal chart and current transits
- Be encouraging and empowering, never fatalistic
- Provide practical, actionable advice
- Keep responses between 200-400 words
- Do not give medical, legal, or financial professional advice
- If the question is outside astrology's scope, acknowledge this gracefully while still offering supportive guidance
${personalContext?.tags?.sensitivity_mode ? '- SENSITIVITY MODE: Use gentle, optimistic language. Avoid anxiety-inducing phrases.' : ''}

Your response should feel like advice from a caring, insightful friend who happens to understand the cosmic influences at play.`;

    const userPrompt = `The user asks: "${question}"

THEIR NATAL CHART:
${this.compactNatalSummary(natalChart.summary)}

TODAY'S PLANETARY TRANSITS:
${this.formatTransits(Array.isArray(transits.transits) ? transits.transits : [])}
${personalContextSection}
Please provide thoughtful, personalized guidance that addresses their question while incorporating relevant astrological insights.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        temperature: 0.7,
        max_tokens: 1000,
      });

      return response.choices[0].message.content || 'Unable to generate guidance at this time.';
    } catch (error) {
      this.logger.error('OpenAI error:', error.message);
      throw new Error('Failed to generate guidance. Please try again.');
    }
  }

  /**
   * Calculate billing period based on subscription.
   */
  private async getBillingPeriod(userId: string): Promise<{
    billingMonthStart: Date;
    billingMonthEnd: Date;
  }> {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    const now = new Date();
    
    if (!subscription || !subscription.startAt) {
      // No subscription - use calendar month
      const billingMonthStart = new Date(now.getFullYear(), now.getMonth(), 1);
      const billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0);
      return { billingMonthStart, billingMonthEnd };
    }

    const subStartDay = subscription.startAt.getDate();

    if (subscription.period === 'MONTHLY') {
      // For monthly: billing cycle is from subscription start day
      let billingMonthStart: Date;
      let billingMonthEnd: Date;

      if (now.getDate() >= subStartDay) {
        // Current billing period started this month
        billingMonthStart = new Date(now.getFullYear(), now.getMonth(), subStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, subStartDay - 1);
      } else {
        // Current billing period started last month
        billingMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, subStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth(), subStartDay - 1);
      }

      return { billingMonthStart, billingMonthEnd };
    } else {
      // For yearly: use the day of month when subscription started
      let billingMonthStart: Date;
      let billingMonthEnd: Date;

      if (now.getDate() >= subStartDay) {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth(), subStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, subStartDay - 1);
      } else {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, subStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth(), subStartDay - 1);
      }

      return { billingMonthStart, billingMonthEnd };
    }
  }

  /**
   * Increment the usage counter for current billing period.
   */
  private async incrementUsage(userId: string): Promise<void> {
    const { billingMonthStart, billingMonthEnd } = await this.getBillingPeriod(userId);

    await this.prisma.askGuideUsage.upsert({
      where: {
        userId_billingMonthStart: { userId, billingMonthStart },
      },
      update: {
        requestCount: { increment: 1 },
      },
      create: {
        userId,
        billingMonthStart,
        billingMonthEnd,
        requestCount: 1,
        limitCount: MONTHLY_LIMIT,
      },
    });
  }

  /**
   * Map gender enum to string.
   */
  private mapGenderToString(gender?: string | null): string | null {
    if (!gender) return null;
    switch (gender.toUpperCase()) {
      case 'MALE':
        return 'male';
      case 'FEMALE':
        return 'female';
      case 'OTHER':
        return 'non-binary';
      default:
        return null;
    }
  }

  /**
   * Get language instructions.
   */
  private getLanguageInstructions(locale: string): string {
    const instructions: Record<string, string> = {
      en: 'Respond entirely in English. Use warm, approachable language.',
      ro: 'IMPORTANT: Respond entirely in Romanian. Use warm, formal language (folosește "dumneavoastră").',
      fr: 'IMPORTANT: Respond entirely in French. Use elegant, warm language with vous.',
      de: 'IMPORTANT: Respond entirely in German. Use Sie form, warm but professional.',
      es: 'IMPORTANT: Respond entirely in Spanish. Use warm, engaging language with usted.',
      it: 'IMPORTANT: Respond entirely in Italian. Use Lei form, expressive and warm.',
      hu: 'IMPORTANT: Respond entirely in Hungarian. Use magázódás, warm and respectful.',
      pl: 'IMPORTANT: Respond entirely in Polish. Use Pan/Pani form, warm and polite.',
    };
    return instructions[locale] || instructions.en;
  }

  /**
   * Compact natal summary for AI prompt.
   */
  private compactNatalSummary(natalSummary: any): string {
    if (!natalSummary) return 'Natal chart data unavailable.';

    if (typeof natalSummary === 'string') {
      const words = natalSummary.split(/\s+/);
      return words.length > 200 ? words.slice(0, 200).join(' ') + '...' : natalSummary;
    }

    const parts: string[] = [];
    if (natalSummary.sunSign) parts.push(`Sun: ${natalSummary.sunSign}`);
    if (natalSummary.moonSign) parts.push(`Moon: ${natalSummary.moonSign}`);
    if (natalSummary.ascendant) parts.push(`Ascendant: ${natalSummary.ascendant}`);

    if (natalSummary.planets) {
      const keyPlanets = ['Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn'];
      for (const planet of keyPlanets) {
        if (natalSummary.planets[planet]) {
          parts.push(`${planet}: ${natalSummary.planets[planet]}`);
        }
      }
    }

    return parts.join('. ') || JSON.stringify(natalSummary).substring(0, 500);
  }

  /**
   * Format transits for AI prompt.
   */
  private formatTransits(transits: any[]): string {
    if (!transits || transits.length === 0) {
      return 'No significant transits today.';
    }

    const personalPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
    const prioritized = [...transits].sort((a, b) => {
      const aScore = personalPlanets.includes(a.transitPlanet) ? 2 : 0;
      const bScore = personalPlanets.includes(b.transitPlanet) ? 2 : 0;
      return bScore - aScore;
    });

    return prioritized
      .slice(0, 8)
      .map((t) => {
        if (typeof t === 'string') return t;
        if (t.transitPlanet && t.aspectType && t.natalPlanet) {
          let desc = `${t.transitPlanet} ${t.aspectType} natal ${t.natalPlanet}`;
          if (t.transitSign) desc += ` (in ${t.transitSign})`;
          return desc;
        }
        return t.description || JSON.stringify(t).substring(0, 60);
      })
      .join('\n');
  }

  // ============================================
  // ADD-ON PURCHASE METHODS
  // ============================================

  /**
   * Get add-on status for user.
   */
  async getAddonStatus(userId: string): Promise<AddonStatusResponseDto> {
    const { billingMonthStart, billingMonthEnd } = await this.getBillingPeriod(userId);

    // Check existing add-on
    const existingAddon = await this.prisma.askGuideAddon.findUnique({
      where: {
        userId_billingMonthStart: { userId, billingMonthStart },
      },
    });

    const hasAddon = !!existingAddon && existingAddon.status === 'COMPLETED';

    // Check if user has hit limit
    const usage = await this.getUsage(userId);
    const canPurchase = !hasAddon && !usage.canRequest;

    return {
      hasAddon,
      canPurchase,
      price: {
        amount: 199, // $1.99 in cents
        currency: 'USD',
        display: '$1.99',
      },
      billingMonthEnd: billingMonthEnd.toISOString().split('T')[0],
    };
  }

  /**
   * Purchase add-on to extend monthly limit.
   */
  async purchaseAddon(
    userId: string,
    dto: PurchaseAddonDto,
  ): Promise<AddonPurchaseResponseDto> {
    const { billingMonthStart, billingMonthEnd } = await this.getBillingPeriod(userId);

    // Check if already purchased
    const existingAddon = await this.prisma.askGuideAddon.findUnique({
      where: {
        userId_billingMonthStart: { userId, billingMonthStart },
      },
    });

    if (existingAddon && existingAddon.status === 'COMPLETED') {
      return {
        success: false,
        message: 'Add-on already purchased for this billing period.',
      };
    }

    // TODO: Validate purchase with respective store (Apple/Google/Stripe)
    // For now, we trust the client-provided purchase ID
    // In production, you should validate the receipt/transaction

    try {
      const addon = await this.prisma.askGuideAddon.upsert({
        where: {
          userId_billingMonthStart: { userId, billingMonthStart },
        },
        create: {
          userId,
          billingMonthStart,
          billingMonthEnd,
          purchaseId: dto.purchaseId,
          provider: dto.provider as any,
          amount: 199,
          currency: 'USD',
          status: 'COMPLETED',
        },
        update: {
          purchaseId: dto.purchaseId,
          provider: dto.provider as any,
          status: 'COMPLETED',
          purchasedAt: new Date(),
        },
      });

      this.logger.log(`User ${userId} purchased Ask Guide add-on for billing period starting ${billingMonthStart}`);

      return {
        success: true,
        message: 'Add-on purchased successfully! You now have additional requests available.',
        addon: {
          id: addon.id,
          billingMonthEnd: billingMonthEnd.toISOString().split('T')[0],
          newLimit: MONTHLY_LIMIT * 2, // Double the limit
        },
      };
    } catch (error) {
      this.logger.error(`Failed to purchase add-on: ${error.message}`);
      return {
        success: false,
        message: 'Failed to process add-on purchase. Please try again.',
      };
    }
  }
}
