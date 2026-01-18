import { Injectable, Logger, BadRequestException, ForbiddenException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { ContextService } from '../context/context.service';
import { User } from '@prisma/client';
import OpenAI from 'openai';
import {
  GenerateLoveCompatibilityDto,
  LoveCompatibilityResponseDto,
  PartnerBirthDataDto,
} from './dto/love-compatibility.dto';
import { isBetaFree } from './service-catalog';

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
    private readonly astrologyService: AstrologyService,
    private readonly entitlementsService: EntitlementsService,
    private readonly contextService: ContextService,
    private readonly configService: ConfigService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-4o-mini');
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
    // Check subscription access (skip in beta free mode)
    if (!isBetaFree()) {
      const hasAccess = await this.entitlementsService.hasAccess(user.id);
      if (!hasAccess) {
        throw new ForbiddenException({
          message: 'Active subscription required for Love Compatibility.',
          code: 'NO_SUBSCRIPTION',
        });
      }
    } else {
      this.logger.log('Beta free mode: granting access to Love Compatibility');
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
      // Step 1: Get partner's natal chart details from AstrologyAPI (NOT saved)
      this.logger.log('Generating partner natal chart via AstrologyAPI...');
      const partnerNatal = await this.getPartnerNatalChartDetails(dto.partner);

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
        userNatalChart.rawData as any,
        partnerNatal.summary,
        partnerNatal.rawData,
        dto.partner.name,
        dto.partner.gender,
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
  private async getPartnerNatalChartDetails(partner: PartnerBirthDataDto): Promise<{ summary: any; rawData: any }> {
    try {
      return await this.astrologyService.generateNatalChartDetailsFromBirthData({
        birthDate: partner.birthDate,
        birthTime: partner.birthTime,
        birthLat: partner.birthLat,
        birthLon: partner.birthLon,
        birthTimezone: partner.timezone,
      });
    } catch (error) {
      this.logger.error(`Failed to generate partner natal chart: ${error.message}`);
      throw new Error('Failed to generate partner\'s natal chart.');
    }
  }

  /**
   * Generate comprehensive compatibility analysis using OpenAI.
   */
  private async generateAnalysis(
    user: User,
    userNatalSummary: any,
    userNatalRaw: any,
    partnerNatalSummary: any,
    partnerNatalRaw: any,
    partnerName: string | undefined,
    partnerGender: string | undefined,
    personalContext: any,
    locale: string,
  ): Promise<string> {
    const genderStr = this.mapGenderToString(user.gender);
    const genderInfo = genderStr ? `The user is ${genderStr}. ` : '';
    const partnerGenderStr = this.mapGenderToString(partnerGender);
    const userName = user.name || 'the user';
    const partnerLabel = partnerName ? partnerName : 'your partner';

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
- Use "you" for the user and "${partnerLabel}" for their partner
- Use the provided names and genders to avoid ambiguity; if missing, use neutral terms`;

    const userPrompt = `Generate a comprehensive love compatibility analysis for ${userName} and ${partnerLabel}.

USER PROFILE:
- Name: ${userName}
- Gender: ${genderStr || 'not specified'}

PARTNER PROFILE:
- Name: ${partnerName || 'not specified'}
- Gender: ${partnerGenderStr || 'not specified'}

USER'S NATAL CHART (DETAILED POSITIONS):
${this.formatNatalChartDetails(userNatalSummary, userNatalRaw)}

PARTNER'S NATAL CHART (DETAILED POSITIONS):
${this.formatNatalChartDetails(partnerNatalSummary, partnerNatalRaw)}
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
   * Format natal summary for prompt.
   */
  private formatNatalSummary(summary: any): string {
    if (!summary) return 'Natal chart data unavailable.';
    if (typeof summary === 'string') return summary.substring(0, 500);

    const parts: string[] = [];
    if (summary.sun?.sign) parts.push(`Sun: ${summary.sun.sign}`);
    if (summary.moon?.sign) parts.push(`Moon: ${summary.moon.sign}`);
    if (summary.ascendant?.sign) parts.push(`Rising: ${summary.ascendant.sign}`);

    const planetKeys = [
      'mercury',
      'venus',
      'mars',
      'jupiter',
      'saturn',
      'uranus',
      'neptune',
      'pluto',
      'node',
      'chiron',
      'lilith',
    ];
    for (const key of planetKeys) {
      if (summary[key]?.sign) {
        parts.push(`${this.capitalize(key)}: ${summary[key].sign}`);
      }
    }

    return parts.length > 0 ? parts.join('\n') : JSON.stringify(summary).substring(0, 500);
  }

  private formatNatalChartDetails(summary: any, rawData?: any): string {
    if (!summary && !rawData) return 'Natal chart data unavailable.';

    const lines: string[] = [];
    const planetLines = this.formatPlanetPositions(rawData?.planets, summary);
    lines.push(...planetLines);

    const ascendantLine = this.formatAngle('Ascendant', rawData?.ascendant, summary?.ascendant);
    if (ascendantLine) lines.push(ascendantLine);
    const midheavenLine = this.formatAngle('Midheaven', rawData?.midheaven, summary?.midheaven);
    if (midheavenLine) lines.push(midheavenLine);

    const aspectLines = this.formatAspects(rawData?.aspects);
    if (aspectLines.length) {
      lines.push('');
      lines.push(...aspectLines);
    }

    return lines.length ? lines.join('\n') : this.formatNatalSummary(summary);
  }

  private formatPlanetPositions(planets?: any[], summary?: any): string[] {
    const order = [
      'sun',
      'moon',
      'mercury',
      'venus',
      'mars',
      'jupiter',
      'saturn',
      'uranus',
      'neptune',
      'pluto',
      'node',
      'chiron',
      'lilith',
    ];

    const fromRaw = Array.isArray(planets)
      ? planets.map((planet) => {
          const name = String(planet.name || '').toLowerCase().replace(/\s+/g, '');
          return {
            key: name,
            label: planet.name || this.capitalize(name),
            sign: planet.sign,
            house: planet.house,
            degree: planet.full_degree,
            isRetro: planet.is_retro === true || planet.is_retro === 'true',
          };
        })
      : [];

    const byKey = new Map<string, any>();
    for (const item of fromRaw) {
      if (item.key) byKey.set(item.key, item);
    }

    const lines: string[] = [];
    for (const key of order) {
      const raw = byKey.get(key);
      if (raw?.sign) {
        lines.push(this.formatPlacement(raw.label, raw.sign, raw.degree, raw.house, raw.isRetro));
        continue;
      }
      const fallback = summary?.[key];
      if (fallback?.sign) {
        lines.push(
          this.formatPlacement(
            this.capitalize(key),
            fallback.sign,
            fallback.degree ?? fallback.normDegree,
            fallback.house,
            fallback.isRetro,
          ),
        );
      }
    }

    return lines;
  }

  private formatPlacement(
    label: string,
    sign?: string,
    degree?: number,
    house?: number,
    isRetro?: boolean,
  ): string {
    const degreeStr = typeof degree === 'number' ? `${degree.toFixed(2)}°` : 'unknown°';
    const houseStr = house ? `House ${house}` : 'House ?';
    const retroStr = isRetro ? 'retrograde' : 'direct';
    return `${label}: ${sign || 'Unknown'} ${degreeStr} (${houseStr}, ${retroStr})`;
  }

  private formatAngle(label: string, degree?: number, summaryAngle?: any): string | null {
    if (typeof degree === 'number') {
      const sign = this.degreeToSign(degree);
      return `${label}: ${sign} ${degree.toFixed(2)}°`;
    }
    if (summaryAngle?.sign) {
      const angleDegree =
        typeof summaryAngle.degree === 'number' ? `${summaryAngle.degree.toFixed(2)}°` : 'unknown°';
      return `${label}: ${summaryAngle.sign} ${angleDegree}`;
    }
    return null;
  }

  private formatAspects(aspects?: any[]): string[] {
    if (!Array.isArray(aspects) || aspects.length === 0) return [];

    const majorTypes = new Set([
      'conjunction',
      'trine',
      'square',
      'opposition',
      'sextile',
    ]);

    const lines = aspects
      .filter((aspect) => {
        const type = String(
          aspect?.aspect || aspect?.aspect_type || aspect?.aspectType || aspect?.type || '',
        ).toLowerCase();
        return majorTypes.has(type);
      })
      .slice(0, 12)
      .map((aspect) => this.formatAspectLine(aspect))
      .filter((line): line is string => Boolean(line));

    return lines.length ? ['ASPECTS:', ...lines] : [];
  }

  private formatAspectLine(aspect: any): string | null {
    if (!aspect) return null;
    const planet1 =
      aspect.planet1 ||
      aspect.planet_1 ||
      aspect.planet1_name ||
      aspect.planet_name ||
      aspect.planet ||
      aspect.p1;
    const planet2 =
      aspect.planet2 ||
      aspect.planet_2 ||
      aspect.planet2_name ||
      aspect.planet_name_2 ||
      aspect.planet_partner ||
      aspect.p2;
    const type = aspect.aspect || aspect.aspect_type || aspect.aspectType || aspect.type;
    const orb = aspect.orb ?? aspect.orb_deg ?? aspect.orb_degrees;

    if (!planet1 || !planet2 || !type) return null;
    const orbText = typeof orb === 'number' ? ` (orb ${orb.toFixed(2)}°)` : '';
    return `${this.capitalize(String(planet1))} ${this.capitalize(String(type))} ${this.capitalize(String(planet2))}${orbText}`;
  }

  private degreeToSign(degree: number): string {
    const signs = [
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];
    const index = Math.floor(degree / 30) % 12;
    return signs[index];
  }

  private capitalize(value: string): string {
    if (!value) return value;
    return value.charAt(0).toUpperCase() + value.slice(1);
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
