import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import axios, { AxiosInstance } from 'axios';
import { User } from '@prisma/client';

interface GeoLocation {
  place_name: string;
  latitude: number;
  longitude: number;
  country_code: string;
  timezone_id: string;
}

interface NatalChartData {
  planets: any[];
  houses: any[];
  aspects: any[];
  interpretations?: any;
}

@Injectable()
export class AstrologyService {
  private readonly logger = new Logger(AstrologyService.name);
  private readonly apiClient: AxiosInstance;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    const userId = this.configService.get<string>('ASTROLOGY_API_USER_ID');
    const apiKey = this.configService.get<string>('ASTROLOGY_API_KEY');
    const baseURL = this.configService.get<string>('ASTROLOGY_API_BASE_URL', 'https://json.astrologyapi.com/v1');

    // Create axios instance with Basic Auth
    const auth = Buffer.from(`${userId}:${apiKey}`).toString('base64');
    
    this.apiClient = axios.create({
      baseURL,
      headers: {
        'Authorization': `Basic ${auth}`,
        'Content-Type': 'application/json',
      },
      timeout: 30000,
    });
  }

  /**
   * Get geo details for a place name
   */
  async getGeoDetails(placeName: string): Promise<GeoLocation[]> {
    // Normalize place name by removing diacritics for better API compatibility
    const normalizedPlace = this.removeDiacritics(placeName);
    
    // Extract just the city name (API doesn't work well with "City, Country" format)
    const cityOnly = this.extractCityName(normalizedPlace);
    
    this.logger.log(`Looking up location: "${placeName}" (normalized: "${normalizedPlace}", city: "${cityOnly}")`);
    
    try {
      const response = await this.apiClient.post('/geo_details', {
        place: cityOnly,
        maxRows: 10,
      });

      const results = response.data.geonames || response.data || [];
      this.logger.log(`Geo lookup returned ${results.length} results`);
      
      return results;
    } catch (error) {
      this.logger.error(`Failed to get geo details for "${placeName}":`, error.message);
      throw new BadRequestException('Failed to lookup location');
    }
  }

  /**
   * Extract city name from "City, Country" format
   */
  private extractCityName(placeName: string): string {
    // Split by comma and take the first part (city name)
    const parts = placeName.split(',').map(p => p.trim());
    return parts[0] || placeName;
  }

  /**
   * Remove diacritics/accents from a string for better API compatibility
   */
  private removeDiacritics(str: string): string {
    return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  }

  /**
   * Get timezone offset for a country
   */
  async getTimezone(countryCode: string, isDst: boolean = false): Promise<number> {
    try {
      const response = await this.apiClient.post('/timezone', {
        country_code: countryCode,
        isDst: isDst,
      });

      return response.data.timezone || 0;
    } catch (error) {
      this.logger.error(`Failed to get timezone for "${countryCode}":`, error.message);
      // Return 0 as fallback
      return 0;
    }
  }

  /**
   * Generate and store natal chart for a user
   * Uses Western/Tropical astrology system (not Vedic/Sidereal)
   */
  async generateNatalChart(user: User) {
    if (!user.birthDate || !user.birthLat || !user.birthLon) {
      throw new BadRequestException('Missing birth data');
    }

    const birthDate = new Date(user.birthDate);
    const [hour, minute] = (user.birthTime || '12:00').split(':').map(Number);

    // Use UTC methods for consistent date extraction regardless of server timezone
    const birthData = {
      day: birthDate.getUTCDate(),
      month: birthDate.getUTCMonth() + 1,
      year: birthDate.getUTCFullYear(),
      hour: hour || 12,
      min: minute || 0,
      lat: user.birthLat,
      lon: user.birthLon,
      tzone: user.birthTimezone || 0,
    };

    this.logger.log(`Generating natal chart for birth data: ${JSON.stringify(birthData)}`);

    try {
      // Use Western/Tropical horoscope endpoint (not Vedic/Sidereal)
      const [westernResponse, interpretationResponse] = await Promise.all([
        this.apiClient.post('/western_horoscope', birthData),
        this.apiClient.post('/general_house_report/tropical', birthData),
      ]);

      const rawData = {
        planets: westernResponse.data.planets,
        houses: westernResponse.data.houses,
        aspects: westernResponse.data.aspects,
        ascendant: westernResponse.data.ascendant,
        midheaven: westernResponse.data.midheaven,
        interpretation: interpretationResponse.data,
      };

      // Parse summary for AI prompts (using Western format)
      const summary = this.parseWesternNatalChartSummary(westernResponse.data);

      this.logger.log(`Natal chart generated - Sun: ${summary.sun?.sign}, Moon: ${summary.moon?.sign}`);

      // Store in database
      const natalChart = await this.prisma.natalChart.upsert({
        where: { userId: user.id },
        update: {
          rawData,
          summary,
          sunSign: summary.sun?.sign,
          moonSign: summary.moon?.sign,
          ascendant: summary.ascendant?.sign,
        },
        create: {
          userId: user.id,
          rawData,
          summary,
          sunSign: summary.sun?.sign,
          moonSign: summary.moon?.sign,
          ascendant: summary.ascendant?.sign,
        },
      });

      return natalChart;
    } catch (error) {
      this.logger.error('Failed to generate natal chart:', error.message);
      throw new BadRequestException('Failed to generate natal chart');
    }
  }

  /**
   * Get daily transits for a user (Premium plan)
   * 
   * IMPORTANT: The date parameter should be stored at UTC midnight
   * representing the user's local calendar date.
   * We use getUTC* methods to extract the calendar date correctly.
   */
  async getDailyTransits(user: User, date: Date = new Date()) {
    if (!user.birthDate || !user.birthLat || !user.birthLon) {
      throw new BadRequestException('Missing birth data');
    }

    // Use UTC methods to get the calendar date components
    // This ensures we get the correct date regardless of server timezone
    const transitYear = date.getUTCFullYear();
    const transitMonth = date.getUTCMonth() + 1; // 0-indexed
    const transitDay = date.getUTCDate();
    
    const dateStr = `${transitYear}-${String(transitMonth).padStart(2, '0')}-${String(transitDay).padStart(2, '0')}`;
    
    this.logger.log(`Getting transits for date: ${dateStr} (from UTC: ${date.toISOString()})`);

    // Check cache first
    const cached = await this.prisma.dailyTransit.findUnique({
      where: {
        userId_date: {
          userId: user.id,
          date: new Date(`${dateStr}T00:00:00.000Z`),
        },
      },
    });

    if (cached) {
      this.logger.log(`Returning cached transits for ${dateStr}`);
      return cached;
    }

    // Birth data - also use UTC methods for consistency
    const birthDate = new Date(user.birthDate);
    const [hour, minute] = (user.birthTime || '12:00').split(':').map(Number);

    const requestData = {
      // Birth data
      day: birthDate.getUTCDate(),
      month: birthDate.getUTCMonth() + 1,
      year: birthDate.getUTCFullYear(),
      hour: hour || 12,
      min: minute || 0,
      lat: user.birthLat,
      lon: user.birthLon,
      tzone: user.birthTimezone || 0,
      // Transit date - the date we want transits for
      transit_date: {
        day: transitDay,
        month: transitMonth,
        year: transitYear,
      },
    };

    this.logger.log(`Requesting transits from AstrologyAPI for transit_date: ${JSON.stringify(requestData.transit_date)}`);

    try {
      const response = await this.apiClient.post('/natal_transits/daily', requestData);

      // Parse relevant transits
      const transits = this.parseTransits(response.data);

      // Store in database at UTC midnight
      const dailyTransit = await this.prisma.dailyTransit.create({
        data: {
          userId: user.id,
          date: new Date(`${dateStr}T00:00:00.000Z`),
          rawData: response.data,
          transits,
        },
      });

      return dailyTransit;
    } catch (error) {
      this.logger.error(`Failed to get daily transits for ${dateStr}:`, error.message);
      throw new BadRequestException('Failed to get daily transits');
    }
  }

  /**
   * Parse Western horoscope data into a summary for AI prompts
   * Format uses underscore naming (full_degree, is_retro, etc.)
   */
  private parseWesternNatalChartSummary(westernData: any): any {
    const planets: Record<string, any> = {};

    // Parse planets array from Western horoscope response
    if (westernData.planets && Array.isArray(westernData.planets)) {
      for (const planet of westernData.planets) {
        const name = planet.name?.toLowerCase();
        // Handle special cases like "Part of Fortune" -> "partoffortune"
        const key = name?.replace(/\s+/g, '');
        planets[key] = {
          sign: planet.sign,
          house: planet.house,
          degree: planet.full_degree,
          normDegree: planet.norm_degree,
          isRetro: planet.is_retro === 'true',
        };
      }
    }

    // Parse ascendant from degree to sign
    let ascendantSign = null;
    if (westernData.ascendant !== undefined) {
      ascendantSign = this.degreeToSign(westernData.ascendant);
    }

    // Parse midheaven from degree to sign  
    let midheavenSign = null;
    if (westernData.midheaven !== undefined) {
      midheavenSign = this.degreeToSign(westernData.midheaven);
    }

    return {
      sun: planets['sun'],
      moon: planets['moon'],
      mercury: planets['mercury'],
      venus: planets['venus'],
      mars: planets['mars'],
      jupiter: planets['jupiter'],
      saturn: planets['saturn'],
      uranus: planets['uranus'],
      neptune: planets['neptune'],
      pluto: planets['pluto'],
      ascendant: ascendantSign ? { sign: ascendantSign, degree: westernData.ascendant } : planets['ascendant'],
      midheaven: midheavenSign ? { sign: midheavenSign, degree: westernData.midheaven } : planets['midheaven'],
      node: planets['node'],
      chiron: planets['chiron'],
      lilith: westernData.lilith ? {
        sign: westernData.lilith.sign,
        house: westernData.lilith.house,
        degree: westernData.lilith.full_degree,
      } : null,
    };
  }

  /**
   * Convert zodiac degree (0-360) to sign name
   */
  private degreeToSign(degree: number): string {
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 
      'Leo', 'Virgo', 'Libra', 'Scorpio',
      'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    const signIndex = Math.floor(degree / 30) % 12;
    return signs[signIndex];
  }

  /**
   * Parse natal chart data into a summary for AI prompts (legacy Vedic format)
   * @deprecated Use parseWesternNatalChartSummary for Western astrology
   */
  private parseNatalChartSummary(planetsData: any): any {
    const planets: Record<string, any> = {};

    if (Array.isArray(planetsData)) {
      for (const planet of planetsData) {
        planets[planet.name?.toLowerCase()] = {
          sign: planet.sign,
          signLord: planet.signLord,
          house: planet.house,
          degree: planet.fullDegree,
          isRetro: planet.isRetro === 'true',
        };
      }
    }

    return {
      sun: planets['sun'],
      moon: planets['moon'],
      mercury: planets['mercury'],
      venus: planets['venus'],
      mars: planets['mars'],
      jupiter: planets['jupiter'],
      saturn: planets['saturn'],
      uranus: planets['uranus'],
      neptune: planets['neptune'],
      pluto: planets['pluto'],
      ascendant: planets['ascendant'],
      midheaven: planets['midheaven'],
    };
  }

  /**
   * Parse transit data for AI consumption
   */
  private parseTransits(transitData: any): any[] {
    if (!Array.isArray(transitData)) {
      return [];
    }

    return transitData.map((transit: any) => ({
      transitPlanet: transit.transit_planet,
      natalPlanet: transit.natal_planet,
      aspect: transit.aspect,
      orb: transit.orb,
      transitSign: transit.transit_sign,
      natalSign: transit.natal_sign,
      description: transit.description,
    }));
  }

  /**
   * Get natal chart for a user
   */
  async getNatalChart(userId: string) {
    return this.prisma.natalChart.findUnique({
      where: { userId },
    });
  }
}

