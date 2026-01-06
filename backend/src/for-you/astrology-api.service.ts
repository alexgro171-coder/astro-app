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
    // Correct AstrologyAPI endpoints
    const endpoints: Record<OneTimeServiceType, string> = {
      PERSONALITY_REPORT: 'personality_report/tropical',
      ROMANTIC_PERSONALITY_REPORT: 'romantic_personality_report/tropical',
      // Compatibility reports use match_making_report with m_/f_ field format
      FRIENDSHIP_REPORT: 'match_making_report',
      LOVE_COMPATIBILITY_REPORT: 'match_making_report',
      ROMANTIC_FORECAST_COUPLE_REPORT: 'match_making_report',
      // Moon phase uses advanced_panchang
      MOON_PHASE_REPORT: 'advanced_panchang',
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

    // For compatibility/couple reports - uses m_/f_ field format for AstrologyAPI
    const partnerDate = new Date(partner.birthDate);
    const [partnerHour, partnerMinute] = this.parseTime(partner.birthTime);
    
    // Get normalized partner location (supports both old and new field names)
    const partnerLat = partner.birthLat ?? partner.lat ?? 0;
    const partnerLon = partner.birthLon ?? partner.lon ?? 0;
    // For timezone, prefer IANA timezone ID but fall back to numeric offset
    const partnerTzone = partner.timezone ?? this.parseTimezone(partner.birthTimezone) ?? 0;

    // AstrologyAPI match_making endpoints use m_ (male) and f_ (female) prefixes
    // We'll use user as "m" and partner as "f" (arbitrary, just for API format)
    return {
      // User data (as "male" in API terms)
      m_day: baseUserData.day,
      m_month: baseUserData.month,
      m_year: baseUserData.year,
      m_hour: baseUserData.hour,
      m_min: baseUserData.min,
      m_lat: baseUserData.lat,
      m_lon: baseUserData.lon,
      m_tzone: baseUserData.tzone,
      // Partner data (as "female" in API terms)
      f_day: partnerDate.getUTCDate(),
      f_month: partnerDate.getUTCMonth() + 1,
      f_year: partnerDate.getUTCFullYear(),
      f_hour: partnerHour,
      f_min: partnerMinute,
      f_lat: partnerLat,
      f_lon: partnerLon,
      f_tzone: partnerTzone,
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

    // Handle match_making_report specifically for compatibility reports
    if (this.isCompatibilityReport(serviceType) && data.conclusion) {
      return this.formatCompatibilityReport(data, serviceType);
    }

    // Handle personality reports (array of paragraphs)
    if (data.report && Array.isArray(data.report)) {
      const reportText = data.report.join('\n\n');
      const spiritualLesson = data.spiritual_lesson ? `\n\n**Spiritual Lesson:** ${data.spiritual_lesson}` : '';
      const keyQuality = data.key_quality ? `\n\n**Key Quality:** ${data.key_quality}` : '';
      return reportText + spiritualLesson + keyQuality;
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

  private isCompatibilityReport(serviceType: OneTimeServiceType): boolean {
    return [
      'LOVE_COMPATIBILITY_REPORT',
      'ROMANTIC_FORECAST_COUPLE_REPORT',
      'FRIENDSHIP_REPORT',
    ].includes(serviceType);
  }

  private formatCompatibilityReport(data: any, serviceType: OneTimeServiceType): string {
    const sections: string[] = [];
    
    // Title based on service type
    const titles: Record<string, string> = {
      'LOVE_COMPATIBILITY_REPORT': 'Love Compatibility Analysis',
      'ROMANTIC_FORECAST_COUPLE_REPORT': 'Romantic Forecast for Your Relationship',
      'FRIENDSHIP_REPORT': 'Friendship Compatibility Analysis',
    };
    
    sections.push(`# ${titles[serviceType] || 'Compatibility Report'}\n`);

    // Overall compatibility score (Ashtakoota)
    if (data.ashtakoota) {
      const points = data.ashtakoota.received_points || 0;
      const maxPoints = 36; // Traditional max for Ashtakoota
      const percentage = Math.round((points / maxPoints) * 100);
      sections.push(`## Overall Compatibility Score\n`);
      sections.push(`**${points} out of ${maxPoints} points (${percentage}%)**\n`);
      sections.push(this.getCompatibilityLevel(percentage));
    }

    // Manglik analysis
    if (data.manglik) {
      sections.push(`\n## Energy Balance\n`);
      const maleEnergy = data.manglik.male_percentage || 0;
      const femaleEnergy = data.manglik.female_percentage || 0;
      sections.push(`- Partner 1 energy influence: ${maleEnergy.toFixed(1)}%`);
      sections.push(`- Partner 2 energy influence: ${femaleEnergy.toFixed(1)}%`);
      
      const diff = Math.abs(maleEnergy - femaleEnergy);
      if (diff < 10) {
        sections.push(`\nYour energies are well-balanced, suggesting natural harmony in your relationship.`);
      } else if (diff < 20) {
        sections.push(`\nThere's a moderate difference in your energy levels, which can create dynamic tension and growth opportunities.`);
      } else {
        sections.push(`\nThe difference in your energy levels suggests that you'll need to be mindful of balancing your different approaches to life.`);
      }
    }

    // Potential challenges
    sections.push(`\n## Relationship Dynamics\n`);
    
    if (data.rajju_dosha) {
      if (data.rajju_dosha.status) {
        sections.push(`⚠️ **Health & Longevity:** There may be some challenges related to physical well-being that require attention and care in the relationship.`);
      } else {
        sections.push(`✓ **Health & Longevity:** Your charts indicate a supportive influence on each other's health and well-being.`);
      }
    }

    if (data.vedha_dosha) {
      if (data.vedha_dosha.status) {
        sections.push(`\n⚠️ **Emotional Harmony:** Some emotional friction points may arise that will require patience and understanding.`);
      } else {
        sections.push(`\n✓ **Emotional Harmony:** Your emotional wavelengths are compatible, supporting smooth communication and understanding.`);
      }
    }

    // Main conclusion
    if (data.conclusion && data.conclusion.match_report) {
      sections.push(`\n## Conclusion\n`);
      sections.push(data.conclusion.match_report);
    }

    // Add service-specific advice
    sections.push(this.getServiceSpecificAdvice(serviceType, data));

    return sections.join('\n');
  }

  private getCompatibilityLevel(percentage: number): string {
    if (percentage >= 80) {
      return `This is an **excellent** compatibility score! You share a deep natural connection that supports long-term harmony.`;
    } else if (percentage >= 65) {
      return `This is a **very good** compatibility score. Your connection has a strong foundation with great potential for growth.`;
    } else if (percentage >= 50) {
      return `This is a **good** compatibility score. While there are differences, these can complement each other with understanding.`;
    } else if (percentage >= 35) {
      return `This is a **moderate** compatibility score. Success in this relationship will require extra effort and communication.`;
    } else {
      return `This compatibility score suggests **significant differences**. Building a strong relationship will require dedication and mutual understanding.`;
    }
  }

  private getServiceSpecificAdvice(serviceType: OneTimeServiceType, data: any): string {
    const points = data.ashtakoota?.received_points || 0;
    const percentage = Math.round((points / 36) * 100);

    switch (serviceType) {
      case 'LOVE_COMPATIBILITY_REPORT':
        return `\n## Advice for Your Love Connection\n\n` +
          `${percentage >= 65 ? 
            'Your romantic connection shows strong potential. Focus on nurturing emotional intimacy and maintaining open communication to let your natural compatibility flourish.' :
            'Building a strong romantic bond will benefit from patience and intentional effort. Focus on understanding each other\'s emotional needs and creating shared experiences.'}`;
      
      case 'ROMANTIC_FORECAST_COUPLE_REPORT':
        return `\n## Looking Ahead\n\n` +
          `${percentage >= 65 ?
            'The stars favor your union. This is a good time to make plans together and deepen your commitment. Trust in your connection as you navigate life\'s journey together.' :
            'The coming period invites you to work together on strengthening your bond. Use any challenges as opportunities to grow closer and understand each other more deeply.'}`;
      
      case 'FRIENDSHIP_REPORT':
        return `\n## Friendship Insights\n\n` +
          `${percentage >= 65 ?
            'You have the makings of a wonderful, lasting friendship! Your natural compatibility supports easy communication and mutual understanding.' :
            'Your friendship can grow strong with nurturing. Embrace your differences as opportunities to learn from each other and expand your perspectives.'}`;
      
      default:
        return '';
    }
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

