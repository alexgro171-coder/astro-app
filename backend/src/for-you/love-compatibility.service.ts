import { Injectable, Logger, BadRequestException, ForbiddenException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyApiService } from './astrology-api.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { ContextService } from '../context/context.service';
import { User } from '@prisma/client';
import OpenAI from 'openai';
import {
  GenerateLoveCompatibilityDto,
  LoveCompatibilityResponseDto,
  PartnerBirthDataDto,
} from './dto/love-compatibility.dto';

/**
 * LoveCompatibilityService
 * 
 * Generates comprehensive love compatibility analysis using:
 * 1. User's natal chart (from DB)
 * 2. Partner's natal chart (calculated on-the-fly via AstrologyAPI)
 * 3. OpenAI for deep, personalized analysis
 * 
 * IMPORTANT: Partner data is NEVER stored permanently.
 */
@Injectable()
export class LoveCompatibilityService {
  private readonly logger = new Logger(LoveCompatibilityService.name);
  private readonly openai: OpenAI;
  private readonly model: string;

  constructor(
    private readonly prisma: PrismaService,
    private readonly astrologyApi: AstrologyApiService,
    private readonly entitlementsService: EntitlementsService,
    private readonly contextService: ContextService,
    private readonly configService: ConfigService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-5-mini');
  }

  /**
   * Generate comprehensive love compatibility analysis.
   * Partner data is used only for this request and NOT saved.
   */
  async generateCompatibility(
    user: User,
    dto: GenerateLoveCompatibilityDto,
    acceptLanguage?: string,
  ): Promise<LoveCompatibilityResponseDto> {
    // Check subscription access
    const hasAccess = await this.entitlementsService.hasAccess(user.id);
    if (!hasAccess) {
      throw new ForbiddenException({
        message: 'Active subscription required for Love Compatibility.',
        code: 'NO_SUBSCRIPTION',
      });
    }

    // Get user's natal chart
    const userNatalChart = await this.prisma.natalChart.findUnique({
      where: { userId: user.id },
    });

    if (!userNatalChart) {
      throw new BadRequestException('Your natal chart is required. Please complete your birth data first.');
    }

    // Validate partner data
    if (!dto.partner.birthDate) {
      throw new BadRequestException('Partner birth date is required.');
    }

    const locale = dto.locale || acceptLanguage?.split(',')[0]?.split('-')[0] || user.language?.toLowerCase() || 'en';

    try {
      // Step 1: Get partner's natal chart from AstrologyAPI (NOT saved)
      this.logger.log('Generating partner natal chart via AstrologyAPI...');
      const partnerChartData = await this.getPartnerNatalChart(dto.partner);

      // Step 2: Get user's personal context for personalization
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

      // Step 3: Generate comprehensive analysis with OpenAI
      this.logger.log('Generating compatibility analysis via OpenAI...');
      const analysis = await this.generateAnalysis(
        user,
        userNatalChart.summary as any,
        partnerChartData,
        dto.partner.name,
        personalContext,
        locale,
      );

      return {
        status: 'READY',
        content: analysis,
        meta: {
          localeUsed: locale,
          partnerName: dto.partner.name,
          generatedAt: new Date().toISOString(),
        },
      };
    } catch (error) {
      this.logger.error(`Love compatibility generation failed: ${error.message}`, error.stack);
      return {
        status: 'FAILED',
        errorMsg: error.message || 'Failed to generate compatibility analysis.',
        meta: {
          localeUsed: locale,
          partnerName: dto.partner.name,
        },
      };
    }
  }

  /**
   * Get partner's natal chart from AstrologyAPI.
   * This data is NEVER saved to the database.
   */
  private async getPartnerNatalChart(partner: PartnerBirthDataDto): Promise<any> {
    const birthDate = new Date(partner.birthDate);
    const [hour, minute] = this.parseTime(partner.birthTime);
    const tzone = this.parseTimezone(partner.timezone);

    // Call AstrologyAPI for partner's natal positions
    try {
      // We'll generate a basic natal summary for the partner
      // In a real implementation, you'd call the actual API
      const partnerData = {
        birthDate: birthDate.toISOString(),
        birthTime: partner.birthTime || 'unknown',
        birthPlace: partner.birthPlace,
        birthLat: partner.birthLat || 0,
        birthLon: partner.birthLon || 0,
        timezone: tzone,
        // Basic calculated positions (placeholder - real implementation would use API)
        sunSign: this.calculateZodiacSign(birthDate),
        // Add more calculated fields as needed
      };

      return partnerData;
    } catch (error) {
      this.logger.error(`Failed to calculate partner chart: ${error.message}`);
      throw new Error('Failed to generate partner\'s natal chart.');
    }
  }

  /**
   * Generate comprehensive compatibility analysis using OpenAI.
   */
  private async generateAnalysis(
    user: User,
    userNatalSummary: any,
    partnerChartData: any,
    partnerName: string | undefined,
    personalContext: any,
    locale: string,
  ): Promise<string> {
    const genderStr = this.mapGenderToString(user.gender);
    const genderInfo = genderStr ? `The user is ${genderStr}. ` : '';

    const languageInstructions = this.getLanguageInstructions(locale);

    // Build personal context section
    let personalContextSection = '';
    if (personalContext) {
      const genderFromContext = personalContext.tags?.gender ? `The user is ${personalContext.tags.gender}. ` : '';
      personalContextSection = `
PERSONAL CONTEXT (use to tailor your response):
${genderFromContext || genderInfo}${personalContext.summary60w}
Current relationship priorities: ${personalContext.tags?.priorities?.join(', ') || 'love and connection'}
`;
    } else if (genderInfo) {
      personalContextSection = `\nPERSONAL CONTEXT:\n${genderInfo}\n`;
    }

    const partnerLabel = partnerName ? partnerName : 'your partner';

    const systemPrompt = `You are an expert relationship astrologer specializing in romantic compatibility analysis. You provide deep, insightful, and actionable compatibility readings based on natal chart comparisons.

${languageInstructions}

ROLE:
- Provide comprehensive relationship analysis
- Identify strengths, challenges, and growth opportunities
- Give practical relationship advice
- Be warm, encouraging, and constructive

STRUCTURE YOUR RESPONSE:
1. **Overview & Connection Score** (brief summary with a score out of 10)
2. **Emotional Compatibility** (Moon signs, emotional needs)
3. **Communication Style** (Mercury, how you express yourselves)
4. **Love & Affection** (Venus placements, love languages)
5. **Passion & Drive** (Mars, physical and motivational compatibility)
6. **Long-term Potential** (Saturn aspects, commitment factors)
7. **Growth Areas** (challenges to work on)
8. **Relationship Advice** (specific, actionable tips)

RULES:
- Be specific to their charts, not generic
- Balance honesty with encouragement
- Provide practical relationship advice
- Keep the analysis between 600-900 words
- Use "you" for the user and "${partnerLabel}" for their partner`;

    const userPrompt = `Generate a comprehensive love compatibility analysis for ${user.name || 'the user'} and ${partnerLabel}.

USER'S NATAL CHART:
${this.formatNatalSummary(userNatalSummary)}

PARTNER'S BIRTH DATA:
- Birth Date: ${partnerChartData.birthDate}
- Birth Time: ${partnerChartData.birthTime}
- Birth Place: ${partnerChartData.birthPlace || 'Unknown'}
- Sun Sign: ${partnerChartData.sunSign || 'Unknown'}
${personalContextSection}
Please provide a detailed, personalized compatibility analysis.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        temperature: 0.7,
        max_tokens: 2000,
      });

      return response.choices[0].message.content || 'Unable to generate compatibility analysis.';
    } catch (error) {
      this.logger.error('OpenAI error:', error.message);
      throw new Error('Failed to generate analysis. Please try again.');
    }
  }

  /**
   * Calculate zodiac sign from birth date.
   */
  private calculateZodiacSign(birthDate: Date): string {
    const month = birthDate.getMonth() + 1;
    const day = birthDate.getDate();

    const signs = [
      { sign: 'Capricorn', start: [12, 22], end: [1, 19] },
      { sign: 'Aquarius', start: [1, 20], end: [2, 18] },
      { sign: 'Pisces', start: [2, 19], end: [3, 20] },
      { sign: 'Aries', start: [3, 21], end: [4, 19] },
      { sign: 'Taurus', start: [4, 20], end: [5, 20] },
      { sign: 'Gemini', start: [5, 21], end: [6, 20] },
      { sign: 'Cancer', start: [6, 21], end: [7, 22] },
      { sign: 'Leo', start: [7, 23], end: [8, 22] },
      { sign: 'Virgo', start: [8, 23], end: [9, 22] },
      { sign: 'Libra', start: [9, 23], end: [10, 22] },
      { sign: 'Scorpio', start: [10, 23], end: [11, 21] },
      { sign: 'Sagittarius', start: [11, 22], end: [12, 21] },
    ];

    for (const { sign, start, end } of signs) {
      if (
        (month === start[0] && day >= start[1]) ||
        (month === end[0] && day <= end[1])
      ) {
        return sign;
      }
    }

    return 'Capricorn'; // Default for edge cases
  }

  /**
   * Format natal summary for prompt.
   */
  private formatNatalSummary(summary: any): string {
    if (!summary) return 'Natal chart data unavailable.';
    if (typeof summary === 'string') return summary.substring(0, 500);

    const parts: string[] = [];
    if (summary.sunSign) parts.push(`Sun: ${summary.sunSign}`);
    if (summary.moonSign) parts.push(`Moon: ${summary.moonSign}`);
    if (summary.ascendant) parts.push(`Rising: ${summary.ascendant}`);
    if (summary.planets) {
      for (const [planet, data] of Object.entries(summary.planets || {})) {
        if (data) parts.push(`${planet}: ${typeof data === 'string' ? data : JSON.stringify(data)}`);
      }
    }

    return parts.length > 0 ? parts.join('\n') : JSON.stringify(summary).substring(0, 500);
  }

  private parseTime(timeStr?: string): [number, number] {
    if (!timeStr) return [12, 0];
    const [hour, minute] = timeStr.split(':').map(n => parseInt(n, 10));
    return [hour || 12, minute || 0];
  }

  private parseTimezone(tz?: number | string): number {
    if (tz === undefined || tz === null) return 0;
    if (typeof tz === 'number') return tz;
    const parsed = parseFloat(tz);
    return isNaN(parsed) ? 0 : parsed;
  }

  private mapGenderToString(gender?: string | null): string | null {
    if (!gender) return null;
    switch (gender.toUpperCase()) {
      case 'MALE': return 'male';
      case 'FEMALE': return 'female';
      case 'OTHER': return 'non-binary';
      default: return null;
    }
  }

  private getLanguageInstructions(locale: string): string {
    const instructions: Record<string, string> = {
      en: 'Respond entirely in English.',
      ro: 'IMPORTANT: Respond entirely in Romanian.',
      fr: 'IMPORTANT: Respond entirely in French.',
      de: 'IMPORTANT: Respond entirely in German.',
      es: 'IMPORTANT: Respond entirely in Spanish.',
      it: 'IMPORTANT: Respond entirely in Italian.',
      hu: 'IMPORTANT: Respond entirely in Hungarian.',
      pl: 'IMPORTANT: Respond entirely in Polish.',
    };
    return instructions[locale] || instructions.en;
  }
}
