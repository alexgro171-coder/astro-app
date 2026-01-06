import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { OneTimeServiceType } from '@prisma/client';
import { PartnerProfileDto } from './dto/partner-profile.dto';

interface NatalData {
  birthDate: Date;
  birthTime?: string;
  birthLat?: number;
  birthLon?: number;
  birthTimezone?: number;
}

interface AstrologyApiResponse {
  reportText: string;
  rawData?: any;
}

@Injectable()
export class AstrologyApiService {
  private readonly logger = new Logger(AstrologyApiService.name);
  private readonly client: AxiosInstance;
  private readonly userId: string;
  private readonly apiKey: string;

  constructor(private readonly configService: ConfigService) {
    this.userId = this.configService.get<string>('ASTROLOGY_API_USER_ID', '');
    this.apiKey = this.configService.get<string>('ASTROLOGY_API_KEY', '');

    this.client = axios.create({
      baseURL: 'https://json.astrologyapi.com/v1',
      headers: {
        'Content-Type': 'application/json',
      },
      auth: {
        username: this.userId,
        password: this.apiKey,
      },
    });
  }

  /**
   * Generate a one-time report via AstrologyAPI.
   */
  async generateReport(
    serviceType: OneTimeServiceType,
    userNatal: NatalData,
    partner?: PartnerProfileDto,
    date?: string,
  ): Promise<AstrologyApiResponse> {
    const endpoint = this.getEndpointForService(serviceType);

    // Build request body based on service type
    const body = this.buildRequestBody(serviceType, userNatal, partner, date);

    this.logger.log(`Calling AstrologyAPI: ${endpoint}`);
    this.logger.debug(`Request body: ${JSON.stringify(body)}`);

    try {
      const response = await this.client.post(`/${endpoint}`, body);

      // Extract report text from response
      const reportText = this.extractReportText(response.data, serviceType);

      this.logger.log(`AstrologyAPI response received for ${serviceType}`);

      return {
        reportText,
        rawData: response.data,
      };
    } catch (error) {
      this.logger.error(
        `AstrologyAPI error for ${serviceType}: ${error.message}`,
        error.stack,
      );
      throw new Error(`Failed to generate ${serviceType}: ${error.message}`);
    }
  }

  private getEndpointForService(serviceType: OneTimeServiceType): string {
    const endpoints: Record<OneTimeServiceType, string> = {
      PERSONALITY_REPORT: 'personality_report/tropical',
      ROMANTIC_PERSONALITY_REPORT: 'romantic_personality_report/tropical',
      FRIENDSHIP_REPORT: 'friendship_report/tropical',
      LOVE_COMPATIBILITY_REPORT: 'love_compatibility_report/tropical',
      ROMANTIC_FORECAST_COUPLE_REPORT: 'romantic_forecast_couple/tropical',
      MOON_PHASE_REPORT: 'moon_phase',
    };
    return endpoints[serviceType];
  }

  private buildRequestBody(
    serviceType: OneTimeServiceType,
    userNatal: NatalData,
    partner?: PartnerProfileDto,
    date?: string,
  ): any {
    // Parse birth date and time for user
    const userDate = new Date(userNatal.birthDate);
    const [userHour, userMinute] = this.parseTime(userNatal.birthTime);

    const baseUserData = {
      day: userDate.getUTCDate(),
      month: userDate.getUTCMonth() + 1,
      year: userDate.getUTCFullYear(),
      hour: userHour,
      min: userMinute,
      lat: userNatal.birthLat || 0,
      lon: userNatal.birthLon || 0,
      tzone: userNatal.birthTimezone || 0,
    };

    // For Moon Phase report
    if (serviceType === 'MOON_PHASE_REPORT') {
      const targetDate = date ? new Date(date) : new Date();
      return {
        day: targetDate.getUTCDate(),
        month: targetDate.getUTCMonth() + 1,
        year: targetDate.getUTCFullYear(),
        lat: userNatal.birthLat || 0,
        lon: userNatal.birthLon || 0,
        tzone: userNatal.birthTimezone || 0,
      };
    }

    // For single person reports
    if (!partner) {
      return baseUserData;
    }

    // For compatibility/couple reports
    const partnerDate = new Date(partner.birthDate);
    const [partnerHour, partnerMinute] = this.parseTime(partner.birthTime);

    return {
      // Primary person (user)
      p1_day: baseUserData.day,
      p1_month: baseUserData.month,
      p1_year: baseUserData.year,
      p1_hour: baseUserData.hour,
      p1_min: baseUserData.min,
      p1_lat: baseUserData.lat,
      p1_lon: baseUserData.lon,
      p1_tzone: baseUserData.tzone,
      // Secondary person (partner)
      p2_day: partnerDate.getUTCDate(),
      p2_month: partnerDate.getUTCMonth() + 1,
      p2_year: partnerDate.getUTCFullYear(),
      p2_hour: partnerHour,
      p2_min: partnerMinute,
      p2_lat: partner.lat || 0,
      p2_lon: partner.lon || 0,
      p2_tzone: partner.timezone || 0,
    };
  }

  private parseTime(timeStr?: string): [number, number] {
    if (!timeStr) return [12, 0]; // Default to noon if unknown
    const [hour, minute] = timeStr.split(':').map((n) => parseInt(n, 10));
    return [hour || 12, minute || 0];
  }

  private extractReportText(data: any, serviceType: OneTimeServiceType): string {
    // AstrologyAPI returns different structures per endpoint
    // We need to extract the text content

    // For most reports, the structure is an object with report sections
    if (typeof data === 'string') {
      return data;
    }

    // Try common patterns
    if (data.report) {
      return this.flattenReport(data.report);
    }

    if (data.interpretation) {
      return data.interpretation;
    }

    if (data.content) {
      return data.content;
    }

    // For structured reports, concatenate all text sections
    if (typeof data === 'object') {
      return this.flattenReport(data);
    }

    this.logger.warn(
      `Unknown response structure for ${serviceType}, returning JSON`,
    );
    return JSON.stringify(data, null, 2);
  }

  private flattenReport(obj: any, prefix = ''): string {
    if (!obj) return '';

    if (typeof obj === 'string') {
      return obj;
    }

    if (Array.isArray(obj)) {
      return obj
        .map((item, idx) => this.flattenReport(item, `${prefix}[${idx}]`))
        .filter(Boolean)
        .join('\n\n');
    }

    if (typeof obj === 'object') {
      const parts: string[] = [];

      for (const [key, value] of Object.entries(obj)) {
        // Skip metadata keys
        if (['status', 'code', 'raw_data'].includes(key)) continue;

        const content = this.flattenReport(value, key);
        if (content) {
          // Format section headers nicely
          const header = this.formatSectionHeader(key);
          if (header && typeof value === 'object') {
            parts.push(`## ${header}\n\n${content}`);
          } else {
            parts.push(content);
          }
        }
      }

      return parts.join('\n\n');
    }

    return String(obj);
  }

  private formatSectionHeader(key: string): string {
    // Convert snake_case or camelCase to Title Case
    return key
      .replace(/_/g, ' ')
      .replace(/([A-Z])/g, ' $1')
      .replace(/^\w/, (c) => c.toUpperCase())
      .trim();
  }
}

