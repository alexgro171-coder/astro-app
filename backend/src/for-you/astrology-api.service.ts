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
  birthTimezone?: number | string; // Can be numeric offset or IANA timezone ID
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

    // Parse user timezone (can be IANA ID or numeric offset)
    const userTzone = this.parseTimezone(userNatal.birthTimezone);

    const baseUserData = {
      day: userDate.getUTCDate(),
      month: userDate.getUTCMonth() + 1,
      year: userDate.getUTCFullYear(),
      hour: userHour,
      min: userMinute,
      lat: userNatal.birthLat || 0,
      lon: userNatal.birthLon || 0,
      tzone: userTzone,
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
        tzone: userTzone,
      };
    }

    // For single person reports
    if (!partner) {
      return baseUserData;
    }

    // For compatibility/couple reports
    const partnerDate = new Date(partner.birthDate);
    const [partnerHour, partnerMinute] = this.parseTime(partner.birthTime);
    
    // Get normalized partner location (supports both old and new field names)
    const partnerLat = partner.birthLat ?? partner.lat ?? 0;
    const partnerLon = partner.birthLon ?? partner.lon ?? 0;
    // For timezone, prefer IANA timezone ID but fall back to numeric offset
    const partnerTzone = partner.timezone ?? this.parseTimezone(partner.birthTimezone) ?? 0;

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
      p2_lat: partnerLat,
      p2_lon: partnerLon,
      p2_tzone: partnerTzone,
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

  /**
   * Parse timezone value - can be numeric offset or IANA timezone ID.
   * Returns numeric offset in hours.
   */
  private parseTimezone(tz?: string | number): number {
    if (tz === undefined || tz === null) return 0;
    
    // If already a number, use it directly
    if (typeof tz === 'number') return tz;
    
    // Try to parse as number first
    const numTz = parseFloat(tz);
    if (!isNaN(numTz)) return numTz;
    
    // IANA timezone ID - try to get offset
    // This is a simplified mapping; for production you might want to use a proper library
    const tzOffsets: Record<string, number> = {
      'UTC': 0,
      'GMT': 0,
      'America/New_York': -5,
      'America/Chicago': -6,
      'America/Denver': -7,
      'America/Los_Angeles': -8,
      'Europe/London': 0,
      'Europe/Paris': 1,
      'Europe/Berlin': 1,
      'Europe/Rome': 1,
      'Europe/Madrid': 1,
      'Europe/Bucharest': 2,
      'Europe/Moscow': 3,
      'Asia/Dubai': 4,
      'Asia/Kolkata': 5.5,
      'Asia/Singapore': 8,
      'Asia/Tokyo': 9,
      'Australia/Sydney': 10,
      'Pacific/Auckland': 12,
    };
    
    // Try exact match
    if (tzOffsets[tz]) return tzOffsets[tz];
    
    // Try partial match (continent/city format)
    for (const [key, value] of Object.entries(tzOffsets)) {
      if (tz.includes(key.split('/')[1] || '')) return value;
    }
    
    this.logger.warn(`Unknown timezone: ${tz}, defaulting to 0`);
    return 0;
  }
}

