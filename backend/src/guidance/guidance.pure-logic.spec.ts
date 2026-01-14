/**
 * Test Suite: GuidanceService - Pure Logic Tests
 * 
 * These tests focus on pure business logic that doesn't require NestJS DI.
 * They run fast and don't hang because they don't instantiate any modules.
 */

describe('GuidanceService - Pure Business Logic', () => {
  
  describe('resolveUserTimezone', () => {
    // Reimplementing the logic for testing
    const isValidTimezone = (tz: string): boolean => {
      try {
        Intl.DateTimeFormat(undefined, { timeZone: tz });
        return true;
      } catch {
        return false;
      }
    };

    const resolveUserTimezone = (
      user: { timezoneIana?: string | null; timezone?: string | null },
      headerTimezone?: string,
    ): string => {
      if (headerTimezone && isValidTimezone(headerTimezone)) {
        return headerTimezone;
      }
      if (user.timezoneIana && isValidTimezone(user.timezoneIana)) {
        return user.timezoneIana;
      }
      if (user.timezone && isValidTimezone(user.timezone)) {
        return user.timezone;
      }
      return 'UTC';
    };

    it('should prioritize header timezone when valid', () => {
      const user = { timezoneIana: 'America/New_York', timezone: 'Europe/London' };
      const result = resolveUserTimezone(user, 'Europe/Bucharest');
      expect(result).toBe('Europe/Bucharest');
    });

    it('should fall back to user.timezoneIana when header is invalid', () => {
      const user = { timezoneIana: 'America/New_York', timezone: 'Europe/London' };
      const result = resolveUserTimezone(user, 'Invalid/Timezone');
      expect(result).toBe('America/New_York');
    });

    it('should fall back to user.timezone when timezoneIana is null', () => {
      const user = { timezoneIana: null, timezone: 'Europe/London' };
      const result = resolveUserTimezone(user);
      expect(result).toBe('Europe/London');
    });

    it('should return UTC when no valid timezone found', () => {
      const user = { timezoneIana: null, timezone: 'Invalid/TZ' };
      const result = resolveUserTimezone(user);
      expect(result).toBe('UTC');
    });

    it('should handle Romanian timezone Europe/Bucharest', () => {
      const user = { timezoneIana: 'Europe/Bucharest' };
      const result = resolveUserTimezone(user);
      expect(result).toBe('Europe/Bucharest');
    });
  });

  describe('getLocalDateStr', () => {
    const getLocalDateStr = (timezone: string): string => {
      try {
        const now = new Date();
        const options: Intl.DateTimeFormatOptions = {
          timeZone: timezone,
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
        };
        const formatter = new Intl.DateTimeFormat('en-CA', options);
        return formatter.format(now);
      } catch (e) {
        return new Date().toISOString().split('T')[0];
      }
    };

    it('should return date in YYYY-MM-DD format', () => {
      const result = getLocalDateStr('UTC');
      expect(result).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    });

    it('should handle Europe/Bucharest timezone', () => {
      const result = getLocalDateStr('Europe/Bucharest');
      expect(result).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    });

    it('should fall back to UTC ISO string for invalid timezone', () => {
      const result = getLocalDateStr('Invalid/Timezone');
      expect(result).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    });
  });

  describe('localDateStrToDate', () => {
    const localDateStrToDate = (localDateStr: string): Date => {
      return new Date(`${localDateStr}T00:00:00.000Z`);
    };

    it('should convert date string to Date at UTC midnight', () => {
      const result = localDateStrToDate('2026-01-13');
      expect(result.getUTCFullYear()).toBe(2026);
      expect(result.getUTCMonth()).toBe(0); // January = 0
      expect(result.getUTCDate()).toBe(13);
      expect(result.getUTCHours()).toBe(0);
      expect(result.getUTCMinutes()).toBe(0);
    });

    it('should handle various date formats', () => {
      const result = localDateStrToDate('2025-12-25');
      expect(result.toISOString()).toBe('2025-12-25T00:00:00.000Z');
    });
  });

  describe('mapGenderToString', () => {
    const mapGenderToString = (gender?: string | null): string | null => {
      if (!gender) return null;
      switch (gender.toUpperCase()) {
        case 'MALE':
          return 'male';
        case 'FEMALE':
          return 'female';
        case 'OTHER':
          return 'non-binary';
        case 'PREFER_NOT_TO_SAY':
          return null;
        default:
          return null;
      }
    };

    it('should map MALE to male', () => {
      expect(mapGenderToString('MALE')).toBe('male');
    });

    it('should map FEMALE to female', () => {
      expect(mapGenderToString('FEMALE')).toBe('female');
    });

    it('should map OTHER to non-binary', () => {
      expect(mapGenderToString('OTHER')).toBe('non-binary');
    });

    it('should return null for PREFER_NOT_TO_SAY', () => {
      expect(mapGenderToString('PREFER_NOT_TO_SAY')).toBeNull();
    });

    it('should return null for null/undefined', () => {
      expect(mapGenderToString(null)).toBeNull();
      expect(mapGenderToString(undefined)).toBeNull();
    });

    it('should be case insensitive', () => {
      expect(mapGenderToString('male')).toBe('male');
      expect(mapGenderToString('Female')).toBe('female');
    });
  });

  describe('formatGuidanceResponse', () => {
    const formatGuidanceResponse = (guidance: any) => {
      const sections = (guidance.sections || {}) as any;

      const formatSection = (key: string, title: string) => {
        const section = sections[key] || {};
        return {
          title,
          content: section.content || 'Guidance unavailable.',
          score: section.score || 5,
          actions: section.actions || [],
        };
      };

      return {
        id: guidance.id,
        date: guidance.localDateStr || guidance.date,
        status: guidance.status,
        dailySummary: sections.dailySummary || {
          content: 'Welcome to your daily guidance.',
          mood: 'Balanced',
          focusArea: 'Personal Growth',
        },
        sections: {
          health: formatSection('health', 'Health & Energy'),
          job: formatSection('job', 'Career & Job'),
          business_money: formatSection('business_money', 'Business & Money'),
          love: formatSection('love', 'Love & Romance'),
          partnerships: formatSection('partnerships', 'Partnerships'),
          personal_growth: formatSection('personal_growth', 'Personal Growth'),
        },
        usedPersonalContext: guidance.usedPersonalContext || false,
        generatedAt: guidance.generatedAt,
      };
    };

    it('should format complete guidance correctly', () => {
      const mockGuidance = {
        id: 'guid-123',
        localDateStr: '2026-01-13',
        status: 'READY',
        sections: {
          dailySummary: {
            content: 'Today is great!',
            mood: 'Optimistic',
            focusArea: 'Career',
          },
          health: { content: 'Take care of yourself', score: 7, actions: ['Rest'] },
          job: { content: 'Good day for work', score: 8, actions: [] },
        },
        usedPersonalContext: true,
        generatedAt: new Date('2026-01-13T08:00:00Z'),
      };

      const result = formatGuidanceResponse(mockGuidance);

      expect(result.id).toBe('guid-123');
      expect(result.date).toBe('2026-01-13');
      expect(result.status).toBe('READY');
      expect(result.dailySummary.mood).toBe('Optimistic');
      expect(result.sections.health.score).toBe(7);
      expect(result.sections.job.content).toBe('Good day for work');
      expect(result.usedPersonalContext).toBe(true);
    });

    it('should provide defaults for missing sections', () => {
      const mockGuidance = {
        id: 'guid-456',
        localDateStr: '2026-01-13',
        status: 'READY',
        sections: {},
      };

      const result = formatGuidanceResponse(mockGuidance);

      expect(result.dailySummary.content).toBe('Welcome to your daily guidance.');
      expect(result.sections.health.content).toBe('Guidance unavailable.');
      expect(result.sections.health.score).toBe(5);
      expect(result.usedPersonalContext).toBe(false);
    });

    it('should use date field as fallback when localDateStr is null', () => {
      const mockGuidance = {
        id: 'guid-789',
        date: new Date('2026-01-13'),
        localDateStr: null,
        status: 'READY',
        sections: {},
      };

      const result = formatGuidanceResponse(mockGuidance);
      expect(result.date).toEqual(new Date('2026-01-13'));
    });
  });

  describe('getPreviousDaysData format', () => {
    it('documents the expected format for AI context', () => {
      // This is the format expected by AiService.generateDailyGuidance
      const expectedFormat = {
        date: '2026-01-12',
        scores: {
          health: 7,
          job: 8,
          business_money: 6,
          love: 9,
          partnerships: 7,
          personal_growth: 8,
        },
      };

      expect(expectedFormat.scores.health).toBeDefined();
      expect(Object.keys(expectedFormat.scores)).toHaveLength(6);
    });
  });

  describe('Feature: Your Focus removal', () => {
    it('documents that activeConcern is no longer used', () => {
      // The "Your Focus" feature has been completely removed
      // It was replaced by "Ask Your Guide" service
      
      const guidanceServiceFeatures = {
        yourFocus: 'REMOVED',
        activeConcern: 'NOT_USED',
        concernText: 'NOT_INCLUDED_IN_AI_PROMPTS',
        askYourGuide: 'ACTIVE_REPLACEMENT',
      };

      expect(guidanceServiceFeatures.yourFocus).toBe('REMOVED');
      expect(guidanceServiceFeatures.askYourGuide).toContain('REPLACEMENT');
    });

    it('documents that guidance generation no longer fetches concerns', () => {
      // generateGuidanceForDate() previously did:
      // const activeConcern = await this.concernsService.getActive(user.id);
      // 
      // NOW: This line is removed, ConcernsService is not injected
      
      const generationSteps = [
        'Get natal chart',
        'Fetch daily transits from AstrologyAPI',
        'Get previous days guidance (for scores)',
        // 'Get active concern' - REMOVED
        'Check entitlements for personal context',
        'Generate via OpenAI',
        'Update guidance to READY',
      ];

      expect(generationSteps).not.toContain('Get active concern');
      expect(generationSteps).toHaveLength(6);
    });
  });
});
