import { Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { AiService } from '../ai/ai.service';
import { User, Language, KarmicReadingStatus } from '@prisma/client';

// Product key for purchases
const KARMIC_PRODUCT_KEY = 'karmic_astrology';

// Node planet names (varies by API)
const NODE_NAMES = ['North Node', 'Node', 'Rahu', 'True Node', 'Mean Node'];

interface NodePlacement {
  sign: string;
  house: number;
}

interface RetrogradePlanet {
  planet: string;
  sign: string;
  house: number;
}

interface KarmicInputSnapshot {
  node: NodePlacement | null;
  retrogrades: RetrogradePlanet[];
}

export interface KarmicStatusResponse {
  betaFree: boolean;
  priceUsd: number;
  locale: string;
  isUnlocked: boolean;
  status: 'READY' | 'PENDING' | 'NONE' | 'FAILED';
  content?: string;
  errorMsg?: string;
}

@Injectable()
export class KarmicService {
  private readonly logger = new Logger(KarmicService.name);

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
    private aiService: AiService,
  ) {}

  /**
   * Check if beta free mode is enabled
   */
  isBetaFree(): boolean {
    const betaFree = this.configService.get<string>('KARMIC_BETA_FREE', 'true');
    return betaFree === 'true' || betaFree === '1';
  }

  /**
   * Get configured price in USD
   */
  getPriceUsd(): number {
    return parseInt(this.configService.get<string>('KARMIC_PRICE_USD', '15'), 10);
  }

  /**
   * Resolve user's locale from Accept-Language header or profile
   */
  resolveLocale(acceptLanguage?: string, userLanguage?: Language): string {
    // Parse Accept-Language header (e.g., "en-US,en;q=0.9,ro;q=0.8")
    if (acceptLanguage) {
      const primary = acceptLanguage.split(',')[0]?.split('-')[0]?.toLowerCase();
      if (primary && this.isValidLocale(primary)) {
        return primary;
      }
    }
    
    // Fall back to user's language setting
    if (userLanguage) {
      return userLanguage.toLowerCase();
    }
    
    return 'en';
  }

  private isValidLocale(locale: string): boolean {
    const validLocales = ['en', 'ro', 'fr', 'de', 'es', 'it', 'hu', 'pl'];
    return validLocales.includes(locale);
  }

  /**
   * Check if user has purchased karmic astrology
   */
  async isUnlocked(userId: string): Promise<boolean> {
    // Beta free bypass
    if (this.isBetaFree()) {
      return true;
    }

    // Check for completed purchase
    const purchase = await this.prisma.userPurchase.findUnique({
      where: {
        userId_productKey: {
          userId,
          productKey: KARMIC_PRODUCT_KEY,
        },
      },
    });

    return purchase?.status === 'COMPLETED';
  }

  /**
   * Get karmic astrology status and reading if available
   */
  async getStatus(user: User, acceptLanguage?: string): Promise<KarmicStatusResponse> {
    const locale = this.resolveLocale(acceptLanguage, user.language);
    const isUnlocked = await this.isUnlocked(user.id);

    // Check for existing reading
    const reading = await this.prisma.karmicAstrologyReading.findUnique({
      where: {
        userId_locale: { userId: user.id, locale },
      },
    });

    let status: 'READY' | 'PENDING' | 'NONE' | 'FAILED' = 'NONE';
    let content: string | undefined;
    let errorMsg: string | undefined;

    if (reading) {
      switch (reading.status) {
        case 'READY':
          status = 'READY';
          content = reading.content || undefined;
          break;
        case 'PENDING':
          status = 'PENDING';
          break;
        case 'FAILED':
          status = 'FAILED';
          errorMsg = reading.errorMsg || 'Generation failed';
          break;
      }
    }

    return {
      betaFree: this.isBetaFree(),
      priceUsd: this.getPriceUsd(),
      locale,
      isUnlocked,
      status,
      content,
      errorMsg,
    };
  }

  /**
   * Generate karmic astrology reading
   */
  async generateReading(user: User, acceptLanguage?: string): Promise<KarmicStatusResponse> {
    const locale = this.resolveLocale(acceptLanguage, user.language);
    const isUnlocked = await this.isUnlocked(user.id);

    // Check access
    if (!isUnlocked) {
      throw new ForbiddenException({
        message: 'Purchase required to access Karmic Astrology',
        requiresPurchase: true,
        productKey: KARMIC_PRODUCT_KEY,
        priceUsd: this.getPriceUsd(),
      });
    }

    // Check for existing READY reading
    const existingReading = await this.prisma.karmicAstrologyReading.findUnique({
      where: {
        userId_locale: { userId: user.id, locale },
      },
    });

    if (existingReading?.status === 'READY' && existingReading.content) {
      this.logger.log(`Returning existing READY reading for user ${user.id}, locale ${locale}`);
      return {
        betaFree: this.isBetaFree(),
        priceUsd: this.getPriceUsd(),
        locale,
        isUnlocked: true,
        status: 'READY',
        content: existingReading.content,
      };
    }

    // Load natal placements and build input snapshot
    const inputSnapshot = await this.loadKarmicInputs(user.id);
    
    if (!inputSnapshot.node) {
      throw new ForbiddenException({
        message: 'Natal chart data not available. Please complete your birth data first.',
      });
    }

    // Determine prompt variant
    const promptVariant = inputSnapshot.retrogrades.length <= 1 ? 'extended' : 'standard';
    
    this.logger.log(
      `Generating karmic reading for user ${user.id}, locale ${locale}, variant ${promptVariant}`,
    );

    // Upsert PENDING record
    await this.prisma.karmicAstrologyReading.upsert({
      where: {
        userId_locale: { userId: user.id, locale },
      },
      update: {
        status: 'PENDING',
        errorMsg: null,
        inputSnapshotJson: inputSnapshot as any,
        promptVariant,
      },
      create: {
        userId: user.id,
        locale,
        status: 'PENDING',
        inputSnapshotJson: inputSnapshot as any,
        promptVariant,
      },
    });

    try {
      // Generate content via AI
      const content = await this.generateKarmicContent(inputSnapshot, locale, promptVariant);

      // Save READY
      await this.prisma.karmicAstrologyReading.update({
        where: {
          userId_locale: { userId: user.id, locale },
        },
        data: {
          status: 'READY',
          content,
        },
      });

      this.logger.log(`Karmic reading generated successfully for user ${user.id}`);

      return {
        betaFree: this.isBetaFree(),
        priceUsd: this.getPriceUsd(),
        locale,
        isUnlocked: true,
        status: 'READY',
        content,
      };
    } catch (error) {
      this.logger.error(`Failed to generate karmic reading for user ${user.id}: ${error.message}`);

      // Save FAILED
      await this.prisma.karmicAstrologyReading.update({
        where: {
          userId_locale: { userId: user.id, locale },
        },
        data: {
          status: 'FAILED',
          errorMsg: error.message,
        },
      });

      throw error;
    }
  }

  /**
   * Load natal placements and extract karmic markers
   */
  private async loadKarmicInputs(userId: string): Promise<KarmicInputSnapshot> {
    const placements = await this.prisma.natalPlacements.findUnique({
      where: { userId },
    });

    if (!placements || !placements.placementsJson) {
      return { node: null, retrogrades: [] };
    }

    const data = placements.placementsJson as any;
    const planets = data.planets || [];

    // Find North Node
    let node: NodePlacement | null = null;
    for (const p of planets) {
      const planetName = p.planet || p.name || '';
      if (NODE_NAMES.some((n) => planetName.toLowerCase().includes(n.toLowerCase()))) {
        node = {
          sign: p.sign,
          house: p.house,
        };
        break;
      }
    }

    // Find retrograde planets (excluding nodes and chiron)
    const retrogrades: RetrogradePlanet[] = [];
    const excludedFromRetrograde = ['north node', 'south node', 'rahu', 'ketu', 'chiron', 'true node', 'mean node'];
    
    for (const p of planets) {
      const planetName = (p.planet || p.name || '').toLowerCase();
      if (
        p.isRetrograde === true &&
        !excludedFromRetrograde.some((ex) => planetName.includes(ex))
      ) {
        retrogrades.push({
          planet: p.planet || p.name,
          sign: p.sign,
          house: p.house,
        });
      }
    }

    this.logger.debug(`Karmic inputs for user ${userId}: node=${JSON.stringify(node)}, retrogrades=${retrogrades.length}`);

    return { node, retrogrades };
  }

  /**
   * Generate karmic content using AI
   */
  private async generateKarmicContent(
    input: KarmicInputSnapshot,
    locale: string,
    variant: 'standard' | 'extended',
  ): Promise<string> {
    const languageName = this.getLanguageName(locale);
    
    // Build retrograde list
    const retrogradeList = input.retrogrades
      .map((r) => `- ${r.planet} retrograde in ${r.sign} in House ${r.house}`)
      .join('\n');

    const systemPrompt = `You are a karmic astrology interpreter. Your style is creative, reflective, and insightful without being fatalistic or alarming. You help people understand soul lessons and growth opportunities. Never make medical, legal, or financial claims. Focus on self-reflection and personal growth.`;

    let userPrompt: string;

    if (variant === 'extended') {
      // Extended prompt for node + max 1 retrograde
      userPrompt = `Write the response entirely in ${languageName}.

Natal Karmic Markers:
- North Node: ${input.node?.sign} in House ${input.node?.house}
${input.retrogrades.length > 0 ? `Retrograde planets:\n${retrogradeList}` : '(No retrograde planets)'}

Instructions:
Provide a detailed and deep karmic astrology interpretation focusing on:
- Soul lessons and evolutionary direction (North Node)
- Unresolved patterns from past lives (South Node implications)
- Karmic connections and relationship dynamics
- Growth path and practical self-reflection exercises
${input.retrogrades.length > 0 ? '- How the retrograde energy interacts with karmic themes' : ''}

Structure the response with 8-10 sections, each with a clear heading.
Include specific examples and actionable recommendations.
End with a gentle disclaimer (1-2 sentences) about astrological interpretation.

Target length: 700-1100 words. Be thorough but avoid repetition.`;
    } else {
      // Standard prompt for multiple retrogrades
      userPrompt = `Write the response entirely in ${languageName}.

Natal Karmic Markers:
- North Node: ${input.node?.sign} in House ${input.node?.house}
Retrograde planets:
${retrogradeList}

Instructions:
Provide a creative karmic astrology interpretation focusing on:
- Soul lessons and life direction (North Node)
- Unresolved patterns and karmic ties
- How each retrograde planet influences your karmic journey
- Growth path and areas for self-reflection

Structure the response with 5-7 short sections, each with a clear heading.
Add a gentle disclaimer at the end (1 sentence).

Target length: 700-1100 words. Keep it readable and insightful.`;
    }

    // Call AI service
    const content = await this.aiService.generateText(systemPrompt, userPrompt);
    return content;
  }

  /**
   * Get language name from locale code
   */
  private getLanguageName(locale: string): string {
    const names: Record<string, string> = {
      en: 'English',
      ro: 'Romanian',
      fr: 'French',
      de: 'German',
      es: 'Spanish',
      it: 'Italian',
      hu: 'Hungarian',
      pl: 'Polish',
    };
    return names[locale] || 'English';
  }
}

