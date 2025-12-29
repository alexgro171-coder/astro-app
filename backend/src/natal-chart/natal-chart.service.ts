import { Injectable, Logger, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AiService } from '../ai/ai.service';
import { NatalPlacementsDto, NatalInterpretationDto, NatalChartDataDto } from './dto/natal-placement.dto';
import { Language } from '@prisma/client';

@Injectable()
export class NatalChartService {
  private readonly logger = new Logger(NatalChartService.name);

  constructor(
    private prisma: PrismaService,
    private aiService: AiService,
  ) {}

  /**
   * Get full natal chart data for a user
   */
  async getNatalChartData(userId: string): Promise<NatalChartDataDto | null> {
    const placements = await this.getOrCreatePlacements(userId);
    
    if (!placements) {
      return null;
    }

    const freeInterpretations = await this.getFreeInterpretations(userId);
    const hasProAccess = await this.hasProAccess(userId);
    const proInterpretations = hasProAccess ? await this.getProInterpretations(userId) : null;

    return {
      placements: placements.placementsJson as unknown as NatalPlacementsDto,
      freeInterpretations: freeInterpretations.map(i => this.mapInterpretation(i)),
      proInterpretations: proInterpretations?.map(i => this.mapInterpretation(i, true)),
      hasProAccess,
    };
  }

  /**
   * Get placements for a user (creates if not exists from natal chart)
   * Also updates existing placements if they're missing ascendant data
   */
  async getOrCreatePlacements(userId: string): Promise<any> {
    // Check if placements already exist
    let placements = await this.prisma.natalPlacements.findUnique({
      where: { userId },
    });

    if (placements) {
      // Check if we need to update (missing ascendant/midheaven)
      const existingData = placements.placementsJson as any;
      const needsUpdate = !existingData?.ascendantLongitude || !existingData?.midheavenLongitude;
      
      if (needsUpdate) {
        this.logger.log(`Placements for user ${userId} missing ASC/MC, re-extracting...`);
        
        const natalChart = await this.prisma.natalChart.findUnique({
          where: { userId },
        });
        
        if (natalChart) {
          const rawData = natalChart.rawData as any;
          const summary = natalChart.summary as any;
          const placementsData = this.extractPlacementsFromNatalChart(rawData, summary);
          
          placements = await this.prisma.natalPlacements.update({
            where: { userId },
            data: {
              placementsJson: placementsData as any,
              updatedAt: new Date(),
            },
          });
          
          // Also invalidate wheel cache since placements changed
          await this.prisma.natalChartWheel.deleteMany({
            where: { userId },
          });
          this.logger.log(`Updated placements and invalidated wheel cache for user ${userId}`);
        }
      }
      
      return placements;
    }

    // Get natal chart and extract placements
    const natalChart = await this.prisma.natalChart.findUnique({
      where: { userId },
    });

    if (!natalChart) {
      return null;
    }

    // Parse placements from natal chart raw data
    const rawData = natalChart.rawData as any;
    const summary = natalChart.summary as any;
    
    const placementsData = this.extractPlacementsFromNatalChart(rawData, summary);

    // Create placements record
    placements = await this.prisma.natalPlacements.create({
      data: {
        userId,
        placementsJson: placementsData as any,
      },
    });

    return placements;
  }

  /**
   * Extract structured placements from natal chart raw data
   */
  private extractPlacementsFromNatalChart(rawData: any, summary: any): NatalPlacementsDto {
    const planets: any[] = [];
    const houses: any[] = [];

    // Extract from summary.planets if available
    if (summary?.planets) {
      for (const [planetName, data] of Object.entries(summary.planets as any)) {
        const planetData = data as any;
        planets.push({
          planet: planetName,
          sign: planetData.sign || 'Unknown',
          house: planetData.house || 1,
          longitude: planetData.longitude || 0,
          isRetrograde: planetData.isRetrograde || false,
        });
      }
    }

    // Try extracting from rawData if summary doesn't have enough
    if (planets.length === 0 && rawData?.planets) {
      for (const planet of rawData.planets) {
        planets.push({
          planet: planet.name || planet.planet || 'Unknown',
          sign: planet.sign || 'Unknown',
          house: planet.house || 1,
          longitude: parseFloat(planet.fullDegree || planet.longitude || 0),
          isRetrograde: planet.isRetrograde === true || planet.retrograde === 'R',
        });
      }
    }

    // Extract houses if available
    if (rawData?.houses || summary?.houses) {
      const housesData = rawData?.houses || summary?.houses;
      if (Array.isArray(housesData)) {
        for (let i = 0; i < housesData.length; i++) {
          const h = housesData[i];
          houses.push({
            house: h.house || i + 1,
            cuspLongitude: parseFloat(h.degree || h.cuspLongitude || 0),
            sign: h.sign || this.getLongitudeSign(h.degree || 0),
          });
        }
      }
    }

    // Get Ascendant and MC from multiple possible sources
    let ascendantLongitude: number | undefined;
    let midheavenLongitude: number | undefined;

    // Try explicit ascendant field
    if (rawData?.ascendant) {
      ascendantLongitude = parseFloat(rawData.ascendant.fullDegree || rawData.ascendant.degree || 0);
      this.logger.log(`Found ascendant in rawData.ascendant: ${ascendantLongitude}°`);
    }
    
    // Try summary.ascendant
    if (ascendantLongitude === undefined && summary?.ascendant) {
      ascendantLongitude = parseFloat(summary.ascendant.longitude || summary.ascendant.fullDegree || summary.ascendant.degree || 0);
      this.logger.log(`Found ascendant in summary.ascendant: ${ascendantLongitude}°`);
    }
    
    // Fallback: Use House 1 cusp as Ascendant (they are the same by definition)
    if ((ascendantLongitude === undefined || ascendantLongitude === 0) && houses.length > 0) {
      const house1 = houses.find(h => h.house === 1);
      if (house1 && house1.cuspLongitude) {
        ascendantLongitude = house1.cuspLongitude;
        this.logger.log(`Using House 1 cusp as ascendant: ${ascendantLongitude}°`);
      }
    }

    // Try explicit midheaven field
    if (rawData?.midheaven) {
      midheavenLongitude = parseFloat(rawData.midheaven.fullDegree || rawData.midheaven.degree || 0);
      this.logger.log(`Found midheaven in rawData.midheaven: ${midheavenLongitude}°`);
    }
    
    // Try summary.midheaven
    if (midheavenLongitude === undefined && summary?.midheaven) {
      midheavenLongitude = parseFloat(summary.midheaven.longitude || summary.midheaven.fullDegree || summary.midheaven.degree || 0);
      this.logger.log(`Found midheaven in summary.midheaven: ${midheavenLongitude}°`);
    }
    
    // Fallback: Use House 10 cusp as MC (they are the same by definition)
    if ((midheavenLongitude === undefined || midheavenLongitude === 0) && houses.length > 0) {
      const house10 = houses.find(h => h.house === 10);
      if (house10 && house10.cuspLongitude) {
        midheavenLongitude = house10.cuspLongitude;
        this.logger.log(`Using House 10 cusp as midheaven: ${midheavenLongitude}°`);
      }
    }

    this.logger.log(`Extracted placements: ${planets.length} planets, ${houses.length} houses, ASC=${ascendantLongitude}°, MC=${midheavenLongitude}°`);

    return {
      planets,
      houses: houses.length > 0 ? houses : undefined,
      ascendantLongitude,
      midheavenLongitude,
    };
  }

  /**
   * Get zodiac sign from longitude
   */
  private getLongitudeSign(longitude: number): string {
    const signs = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
                   'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'];
    const index = Math.floor(longitude / 30) % 12;
    return signs[index];
  }

  /**
   * Get FREE interpretations for a user
   */
  async getFreeInterpretations(userId: string): Promise<any[]> {
    return this.prisma.natalInterpretationFree.findMany({
      where: { userId },
    });
  }

  /**
   * Get a single FREE interpretation (lazy load)
   * Respects user's language preference - generates in that language
   */
  async getInterpretation(userId: string, planetKey: string, language: Language = 'EN'): Promise<NatalInterpretationDto | null> {
    // Check if interpretation exists in user's language
    let interpretation = await this.prisma.natalInterpretationFree.findUnique({
      where: {
        userId_planetKey_language: { userId, planetKey, language },
      },
    });

    if (interpretation) {
      return this.mapInterpretation(interpretation);
    }

    // Generate new interpretation in user's language
    const placements = await this.getOrCreatePlacements(userId);
    if (!placements) {
      return null;
    }

    const placementsData = placements.placementsJson as NatalPlacementsDto;
    const planet = placementsData.planets.find(p => p.planet.toLowerCase() === planetKey.toLowerCase());

    if (!planet) {
      this.logger.warn(`Planet ${planetKey} not found in placements for user ${userId}`);
      return null;
    }

    // Generate interpretation via AI in user's language
    this.logger.log(`Generating FREE interpretation for ${planet.planet} in language ${language}`);
    const text = await this.generateFreeInterpretation(planet.planet, planet.sign, planet.house, language);

    // Save to database with language
    interpretation = await this.prisma.natalInterpretationFree.create({
      data: {
        userId,
        placementsId: placements.id,
        planetKey: planet.planet,
        sign: planet.sign,
        house: planet.house,
        language,
        text,
      },
    });

    return this.mapInterpretation(interpretation);
  }

  /**
   * Generate FREE interpretation via AI (~60 words)
   * Generates in the specified language
   */
  private async generateFreeInterpretation(planet: string, sign: string, house: number, language: Language = 'EN'): Promise<string> {
    const languageInstruction = this.getLanguageInstruction(language);
    
    const prompt = `You are an astrology expert. Generate a concise natal chart interpretation for:
Planet: ${planet}
Sign: ${sign}
House: ${house}

Requirements:
- Keep it to approximately 60 words
- Be practical and applicable to daily life
- Focus on personality traits and tendencies
- Do not use deterministic language
- Be encouraging and constructive
${languageInstruction}

Output only the interpretation text, nothing else.`;

    try {
      const response = await this.aiService.generateText(prompt);
      return response.trim();
    } catch (error) {
      this.logger.error(`Failed to generate interpretation for ${planet} in ${sign}:`, error);
      // Fallback text in the appropriate language
      if (language === 'RO') {
        return `${planet} în ${sign} în casa ${house} influențează ${this.getPlanetThemeRo(planet)}. Această plasare sugerează tendințe naturale care pot fi dezvoltate prin conștientizare și practică.`;
      }
      return `${planet} in ${sign} in the ${this.ordinal(house)} house influences your ${this.getPlanetTheme(planet)}. This placement suggests natural tendencies that can be developed through awareness and practice.`;
    }
  }

  /**
   * Check if user has PRO access
   */
  async hasProAccess(userId: string): Promise<boolean> {
    const purchase = await this.prisma.natalProPurchase.findUnique({
      where: { userId },
    });
    return purchase?.status === 'COMPLETED';
  }

  /**
   * Get PRO interpretations
   */
  async getProInterpretations(userId: string): Promise<any[]> {
    return this.prisma.natalInterpretationPro.findMany({
      where: { userId },
    });
  }

  /**
   * Generate all PRO interpretations for a user (after purchase)
   * Generates in the specified language
   */
  async generateProInterpretations(userId: string, language: Language = 'EN'): Promise<NatalInterpretationDto[]> {
    // Verify purchase
    const purchase = await this.prisma.natalProPurchase.findUnique({
      where: { userId },
    });

    // For demo purposes, create a purchase record if it doesn't exist
    if (!purchase) {
      await this.prisma.natalProPurchase.create({
        data: {
          userId,
          status: 'COMPLETED',
          amount: 999,
        },
      });
    }

    // Get placements
    const placements = await this.getOrCreatePlacements(userId);
    if (!placements) {
      throw new NotFoundException('No natal chart data found');
    }

    const placementsData = placements.placementsJson as NatalPlacementsDto;
    const interpretations: NatalInterpretationDto[] = [];

    this.logger.log(`Generating PRO interpretations for user ${userId} in language ${language}`);

    // Generate for each planet
    for (const planet of placementsData.planets) {
      // Check if already exists in user's language
      let existing = await this.prisma.natalInterpretationPro.findUnique({
        where: {
          userId_planetKey_language: { userId, planetKey: planet.planet, language },
        },
      });

      if (!existing) {
        const text = await this.generateProInterpretation(planet.planet, planet.sign, planet.house, language);
        
        existing = await this.prisma.natalInterpretationPro.create({
          data: {
            userId,
            placementsId: placements.id,
            planetKey: planet.planet,
            sign: planet.sign,
            house: planet.house,
            language,
            text,
          },
        });
      }

      interpretations.push(this.mapInterpretation(existing, true));
    }

    return interpretations;
  }

  /**
   * Generate PRO interpretation via AI (~150-200 words)
   * Generates in the specified language
   */
  private async generateProInterpretation(planet: string, sign: string, house: number, language: Language = 'EN'): Promise<string> {
    const languageInstruction = this.getLanguageInstruction(language);
    
    const prompt = `You are an expert astrologer providing a detailed natal chart reading. Generate a comprehensive interpretation for:

Planet: ${planet}
Sign: ${sign}
House: ${house}

Requirements:
- Write 150-200 words
- Cover multiple life areas affected by this placement
- Include specific, actionable guidance
- Explain WHY this placement manifests in certain ways
- Include both challenges and gifts of this placement
- Be encouraging while remaining realistic
- Use accessible language (avoid jargon)
- Do not use deterministic language like "you will" or "this will happen"
${languageInstruction}

Output only the interpretation text, nothing else.`;

    try {
      const response = await this.aiService.generateText(prompt);
      return response.trim();
    } catch (error) {
      this.logger.error(`Failed to generate PRO interpretation for ${planet} in ${sign}:`, error);
      throw new BadRequestException('Failed to generate interpretation');
    }
  }

  /**
   * Get language instruction for AI prompts
   */
  private getLanguageInstruction(language: Language): string {
    switch (language) {
      case 'RO':
        return '- IMPORTANT: Write entirely in Romanian. Use warm, formal language.';
      case 'EN':
      default:
        return '- Write in English.';
    }
  }

  /**
   * Get planet theme in Romanian
   */
  private getPlanetThemeRo(planet: string): string {
    const themes: Record<string, string> = {
      'Sun': 'identitatea și expresia de sine',
      'Moon': 'emoțiile și instinctele',
      'Mercury': 'comunicarea și gândirea',
      'Venus': 'relațiile și valorile',
      'Mars': 'energia și acțiunea',
      'Jupiter': 'expansiunea și norocul',
      'Saturn': 'disciplina și responsabilitatea',
      'Uranus': 'inovația și schimbarea',
      'Neptune': 'intuiția și visele',
      'Pluto': 'transformarea și puterea',
    };
    return themes[planet] || 'dezvoltarea personală';
  }

  /**
   * Map database record to DTO
   */
  private mapInterpretation(record: any, isPro = false): NatalInterpretationDto {
    return {
      id: record.id,
      planetKey: record.planetKey,
      sign: record.sign,
      house: record.house,
      text: record.text,
      isPro,
      createdAt: record.createdAt.toISOString(),
    };
  }

  /**
   * Helper: ordinal number
   */
  private ordinal(n: number): string {
    const s = ['th', 'st', 'nd', 'rd'];
    const v = n % 100;
    return n + (s[(v - 20) % 10] || s[v] || s[0]);
  }

  /**
   * Helper: planet theme
   */
  private getPlanetTheme(planet: string): string {
    const themes: Record<string, string> = {
      'Sun': 'core identity and vitality',
      'Moon': 'emotions and inner world',
      'Mercury': 'communication and thinking',
      'Venus': 'love, beauty, and values',
      'Mars': 'drive, energy, and action',
      'Jupiter': 'growth, expansion, and luck',
      'Saturn': 'discipline, structure, and maturity',
      'Uranus': 'innovation and change',
      'Neptune': 'intuition and spirituality',
      'Pluto': 'transformation and power',
    };
    return themes[planet] || 'personal expression';
  }
}

