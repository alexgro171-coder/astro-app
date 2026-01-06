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

    // Check if we have detailed ashtakoota data (from match_making_detailed_report)
    if (data.ashtakoota) {
      // Overall compatibility score
      const total = data.ashtakoota.total || data.ashtakoota;
      const receivedPoints = total.received_points || data.ashtakoota.received_points || 0;
      const totalPoints = total.total_points || 36;
      const percentage = Math.round((receivedPoints / totalPoints) * 100);
      
      sections.push(`## Overall Compatibility Score\n`);
      sections.push(`**${receivedPoints} out of ${totalPoints} points (${percentage}%)**\n`);
      sections.push(this.getCompatibilityLevel(percentage));
      
      // Add ashtakoota conclusion if available
      if (data.ashtakoota.conclusion?.report) {
        sections.push(`\n${data.ashtakoota.conclusion.report}`);
      }

      // Detailed breakdown of each attribute
      sections.push(`\n## Detailed Compatibility Analysis\n`);
      
      const attributes = ['varna', 'vashya', 'tara', 'yoni', 'maitri', 'gan', 'bhakut', 'nadi'];
      for (const attr of attributes) {
        if (data.ashtakoota[attr]) {
          const item = data.ashtakoota[attr];
          const attrTitle = this.getAttributeTitle(attr);
          const desc = item.description || '';
          const received = item.received_points || 0;
          const total = item.total_points || 0;
          const status = received >= (total * 0.5) ? '✓' : '△';
          
          sections.push(`### ${status} ${attrTitle}`);
          if (desc) sections.push(`*${desc}*`);
          sections.push(`Score: **${received}/${total}** points`);
          
          if (item.male_koot_attribute && item.female_koot_attribute) {
            sections.push(`- Partner 1: ${item.male_koot_attribute}`);
            sections.push(`- Partner 2: ${item.female_koot_attribute}`);
          }
          sections.push('');
        }
      }
    }

    // Manglik analysis
    if (data.manglik) {
      sections.push(`## Mars Energy (Manglik)\n`);
      const maleEnergy = data.manglik.male_percentage || 0;
      const femaleEnergy = data.manglik.female_percentage || 0;
      sections.push(`- Partner 1 Mars influence: ${maleEnergy.toFixed(1)}%`);
      sections.push(`- Partner 2 Mars influence: ${femaleEnergy.toFixed(1)}%`);
      
      const diff = Math.abs(maleEnergy - femaleEnergy);
      if (diff < 10) {
        sections.push(`\nYour Mars energies are well-balanced, suggesting natural harmony and similar drive levels in your relationship.`);
      } else if (diff < 20) {
        sections.push(`\nThere's a moderate difference in your Mars energy, which can create dynamic tension and passion while also requiring understanding of different activity levels.`);
      } else {
        sections.push(`\nThe significant difference in Mars energy suggests one partner may be more driven or assertive than the other. Understanding and respecting these differences will strengthen your bond.`);
      }
    }

    // Potential challenges (Doshas)
    sections.push(`\n## Relationship Harmony Indicators\n`);
    
    if (data.rajju_dosha) {
      if (data.rajju_dosha.status) {
        sections.push(`⚠️ **Rajju Dosha (Life Path):** Some challenges may arise related to life direction and long-term goals. Communication about your individual paths will help navigate these differences.`);
      } else {
        sections.push(`✓ **Rajju Dosha (Life Path):** Your life paths are harmoniously aligned, supporting mutual growth and shared goals.`);
      }
    }

    if (data.vedha_dosha) {
      if (data.vedha_dosha.status) {
        sections.push(`\n⚠️ **Vedha Dosha (Obstacles):** Some recurring friction points may appear in daily interactions. Patience and conscious effort will help smooth these rough edges.`);
      } else {
        sections.push(`\n✓ **Vedha Dosha (Obstacles):** No significant obstacles are indicated. Your daily interactions should flow relatively smoothly.`);
      }
    }

    // Main conclusion
    if (data.conclusion?.match_report) {
      sections.push(`\n## Overall Conclusion\n`);
      sections.push(data.conclusion.match_report);
    }

    // Add service-specific advice
    sections.push(this.getServiceSpecificAdvice(serviceType, data));

    return sections.join('\n');
  }
  
  private getAttributeTitle(attr: string): string {
    const titles: Record<string, string> = {
      'varna': 'Varna (Natural Compatibility & Work)',
      'vashya': 'Vashya (Mutual Attraction & Devotion)',
      'tara': 'Tara (Prosperity & Health)',
      'yoni': 'Yoni (Intimate & Physical Compatibility)',
      'maitri': 'Maitri (Friendship & Mental Harmony)',
      'gan': 'Gana (Temperament & Nature)',
      'bhakut': 'Bhakut (Love & Family Life)',
      'nadi': 'Nadi (Health & Progeny)',
    };
    return titles[attr] || attr.charAt(0).toUpperCase() + attr.slice(1);
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
    const total = data.ashtakoota?.total || data.ashtakoota || {};
    const points = total.received_points || data.ashtakoota?.received_points || 0;
    const percentage = Math.round((points / 36) * 100);
    
    // Extract specific scores for nuanced advice
    const maitri = data.ashtakoota?.maitri?.received_points || 0;
    const yoni = data.ashtakoota?.yoni?.received_points || 0;
    const bhakut = data.ashtakoota?.bhakut?.received_points || 0;
    const gan = data.ashtakoota?.gan?.received_points || 0;
    const nadi = data.ashtakoota?.nadi?.received_points || 0;

    switch (serviceType) {
      case 'LOVE_COMPATIBILITY_REPORT':
        let loveAdvice = `\n## Romantic Insights & Advice\n\n`;
        
        // Physical/intimate compatibility (yoni)
        if (yoni >= 3) {
          loveAdvice += `**Physical Connection:** Your physical and intimate compatibility is strong. There's a natural attraction and understanding of each other's needs in this area.\n\n`;
        } else {
          loveAdvice += `**Physical Connection:** Building physical intimacy may require more conscious attention and communication about needs and preferences.\n\n`;
        }
        
        // Emotional bond (bhakut)
        if (bhakut >= 5) {
          loveAdvice += `**Emotional Bond:** You share a deep emotional connection that supports long-term commitment and family harmony.\n\n`;
        } else {
          loveAdvice += `**Emotional Bond:** Emotional connection will benefit from dedicated quality time and expressing appreciation for each other.\n\n`;
        }
        
        // Overall advice
        loveAdvice += percentage >= 65 ? 
          `**Overall:** Your romantic connection shows strong potential. Focus on nurturing emotional intimacy and maintaining open communication to let your natural compatibility flourish.` :
          `**Overall:** Building a strong romantic bond will benefit from patience and intentional effort. Focus on understanding each other's emotional needs and creating meaningful shared experiences.`;
        
        return loveAdvice;
      
      case 'ROMANTIC_FORECAST_COUPLE_REPORT':
        let forecastAdvice = `\n## Your Relationship Forecast\n\n`;
        
        // Future outlook based on different factors
        if (nadi >= 6) {
          forecastAdvice += `**Long-term Potential:** The stars indicate excellent potential for growth, family expansion, and lasting commitment.\n\n`;
        } else if (nadi >= 4) {
          forecastAdvice += `**Long-term Potential:** Your relationship has good foundations for the future. Focus on health and wellness as a couple.\n\n`;
        } else {
          forecastAdvice += `**Long-term Potential:** Your path together will benefit from attention to health, lifestyle choices, and building shared wellness practices.\n\n`;
        }
        
        // Temperament alignment
        if (gan >= 4) {
          forecastAdvice += `**Daily Harmony:** Your temperaments align well, making everyday life together smooth and enjoyable.\n\n`;
        } else {
          forecastAdvice += `**Daily Harmony:** Different temperaments mean exciting variety but may require patience in daily routines.\n\n`;
        }
        
        forecastAdvice += percentage >= 65 ?
          `**Looking Ahead:** The stars favor your union. This is a wonderful time to make plans together and deepen your commitment. Trust in your connection as you navigate life's journey together.` :
          `**Looking Ahead:** The coming period invites you to work together on strengthening your bond. Use any challenges as opportunities to grow closer and understand each other more deeply.`;
        
        return forecastAdvice;
      
      case 'FRIENDSHIP_REPORT':
        let friendAdvice = `\n## Friendship Dynamics & Insights\n\n`;
        
        // Mental compatibility (maitri)
        if (maitri >= 4) {
          friendAdvice += `**Mental Connection:** You share excellent mental rapport! Conversations flow easily and you understand each other's thought patterns naturally.\n\n`;
        } else if (maitri >= 2) {
          friendAdvice += `**Mental Connection:** You bring different perspectives which can enrich conversations and expand each other's thinking.\n\n`;
        } else {
          friendAdvice += `**Mental Connection:** Your different mental approaches mean you can learn a lot from each other, though patience in communication is valuable.\n\n`;
        }
        
        // Temperament for friendship
        if (gan >= 4) {
          friendAdvice += `**Spending Time Together:** Your similar temperaments make you naturally comfortable together. Social activities and shared hobbies will strengthen your bond.\n\n`;
        } else {
          friendAdvice += `**Spending Time Together:** Your different temperaments mean some compromise in activities, but this diversity keeps the friendship interesting!\n\n`;
        }
        
        friendAdvice += percentage >= 65 ?
          `**Friendship Potential:** You have the makings of a wonderful, lasting friendship! Your natural compatibility supports easy communication and mutual understanding. Invest in this connection—it can be deeply rewarding.` :
          `**Friendship Potential:** Your friendship can grow strong with nurturing. Embrace your differences as opportunities to learn from each other and expand your perspectives. Some of the best friendships are built across differences!`;
        
        return friendAdvice;
      
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

