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
    try {
      const response = await this.apiClient.post('/geo_details', {
        place: placeName,
        maxRows: 10,
      });

      return response.data.geonames || response.data || [];
    } catch (error) {
      this.logger.error(`Failed to get geo details for "${placeName}":`, error.message);
      throw new BadRequestException('Failed to lookup location');
    }
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
   */
  async generateNatalChart(user: User) {
    if (!user.birthDate || !user.birthLat || !user.birthLon) {
      throw new BadRequestException('Missing birth data');
    }

    const birthDate = new Date(user.birthDate);
    const [hour, minute] = (user.birthTime || '12:00').split(':').map(Number);

    const birthData = {
      day: birthDate.getDate(),
      month: birthDate.getMonth() + 1,
      year: birthDate.getFullYear(),
      hour: hour || 12,
      min: minute || 0,
      lat: user.birthLat,
      lon: user.birthLon,
      tzone: user.birthTimezone || 0,
    };

    try {
      // Get natal chart data (premium endpoints)
      const [planetsResponse, interpretationResponse] = await Promise.all([
        this.apiClient.post('/planets', birthData),
        this.apiClient.post('/general_house_report/tropical', birthData),
      ]);

      const rawData = {
        planets: planetsResponse.data,
        interpretation: interpretationResponse.data,
      };

      // Parse summary for AI prompts
      const summary = this.parseNatalChartSummary(planetsResponse.data);

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
   * Get daily transits for a user
   */
  async getDailyTransits(user: User, date: Date = new Date()) {
    if (!user.birthDate || !user.birthLat || !user.birthLon) {
      throw new BadRequestException('Missing birth data');
    }

    const dateStr = date.toISOString().split('T')[0];

    // Check cache first
    const cached = await this.prisma.dailyTransit.findUnique({
      where: {
        userId_date: {
          userId: user.id,
          date: new Date(dateStr),
        },
      },
    });

    if (cached) {
      return cached;
    }

    const birthDate = new Date(user.birthDate);
    const [hour, minute] = (user.birthTime || '12:00').split(':').map(Number);

    const requestData = {
      day: birthDate.getDate(),
      month: birthDate.getMonth() + 1,
      year: birthDate.getFullYear(),
      hour: hour || 12,
      min: minute || 0,
      lat: user.birthLat,
      lon: user.birthLon,
      tzone: user.birthTimezone || 0,
      // Transit date
      transit_date: {
        day: date.getDate(),
        month: date.getMonth() + 1,
        year: date.getFullYear(),
      },
    };

    try {
      const response = await this.apiClient.post('/natal_transits/daily', requestData);

      // Parse relevant transits
      const transits = this.parseTransits(response.data);

      // Store in database
      const dailyTransit = await this.prisma.dailyTransit.create({
        data: {
          userId: user.id,
          date: new Date(dateStr),
          rawData: response.data,
          transits,
        },
      });

      return dailyTransit;
    } catch (error) {
      this.logger.error('Failed to get daily transits:', error.message);
      throw new BadRequestException('Failed to get daily transits');
    }
  }

  /**
   * Parse natal chart data into a summary for AI prompts
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

