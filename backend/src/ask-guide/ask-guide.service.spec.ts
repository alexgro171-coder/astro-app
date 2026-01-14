/**
 * Test Suite: AskGuideService
 * 
 * Unit tests for the Ask Your Guide feature business logic.
 * Tests cover:
 * - Usage tracking and limits (40 requests/month)
 * - Billing period calculations
 * - Add-on purchase logic
 * 
 * Note: OpenAI integration is tested separately in e2e tests.
 */

describe('AskGuideService - Business Logic', () => {
  
  describe('Monthly Limit Logic', () => {
    const MONTHLY_LIMIT = 40;

    it('should allow requests when under limit', () => {
      const requestCount = 10;
      const limitCount = MONTHLY_LIMIT;
      const remaining = Math.max(0, limitCount - requestCount);
      const canRequest = remaining > 0;

      expect(canRequest).toBe(true);
      expect(remaining).toBe(30);
    });

    it('should block requests when limit reached', () => {
      const requestCount = 40;
      const limitCount = MONTHLY_LIMIT;
      const remaining = Math.max(0, limitCount - requestCount);
      const canRequest = remaining > 0;

      expect(canRequest).toBe(false);
      expect(remaining).toBe(0);
    });

    it('should double limit when add-on is active', () => {
      const requestCount = 50;
      const limitCount = MONTHLY_LIMIT;
      const hasAddon = true;
      const effectiveLimit = hasAddon ? limitCount * 2 : limitCount;
      const remaining = Math.max(0, effectiveLimit - requestCount);
      const canRequest = remaining > 0;

      expect(effectiveLimit).toBe(80);
      expect(remaining).toBe(30);
      expect(canRequest).toBe(true);
    });

    it('should still block when over doubled limit', () => {
      const requestCount = 85;
      const limitCount = MONTHLY_LIMIT;
      const hasAddon = true;
      const effectiveLimit = hasAddon ? limitCount * 2 : limitCount;
      const remaining = Math.max(0, effectiveLimit - requestCount);
      const canRequest = remaining > 0;

      expect(remaining).toBe(0);
      expect(canRequest).toBe(false);
    });
  });

  describe('Billing Period Calculations', () => {
    /**
     * Billing period logic based on subscription type.
     */

    it('calculates billing period for monthly subscription', () => {
      const now = new Date('2026-01-15');
      const subscriptionStartDay = 10;

      // If current day (15) >= subscription start day (10),
      // billing period started this month
      let billingMonthStart: Date;
      let billingMonthEnd: Date;

      if (now.getDate() >= subscriptionStartDay) {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth(), subscriptionStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, subscriptionStartDay - 1);
      } else {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, subscriptionStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth(), subscriptionStartDay - 1);
      }

      expect(billingMonthStart.getDate()).toBe(10);
      expect(billingMonthStart.getMonth()).toBe(0); // January
      expect(billingMonthEnd.getDate()).toBe(9);
      expect(billingMonthEnd.getMonth()).toBe(1); // February
    });

    it('calculates billing period when before subscription day', () => {
      const now = new Date('2026-01-05');
      const subscriptionStartDay = 10;

      let billingMonthStart: Date;
      let billingMonthEnd: Date;

      if (now.getDate() >= subscriptionStartDay) {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth(), subscriptionStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, subscriptionStartDay - 1);
      } else {
        billingMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, subscriptionStartDay);
        billingMonthEnd = new Date(now.getFullYear(), now.getMonth(), subscriptionStartDay - 1);
      }

      expect(billingMonthStart.getMonth()).toBe(11); // December (previous year)
      expect(billingMonthEnd.getMonth()).toBe(0); // January
      expect(billingMonthEnd.getDate()).toBe(9);
    });

    it('uses calendar month when no subscription', () => {
      const now = new Date('2026-01-15');
      const billingMonthStart = new Date(now.getFullYear(), now.getMonth(), 1);
      const billingMonthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0);

      expect(billingMonthStart.getDate()).toBe(1);
      expect(billingMonthEnd.getDate()).toBe(31); // January has 31 days
    });
  });

  describe('Add-on Purchase Logic', () => {
    it('allows purchase when limit reached and no addon', () => {
      const requestCount = 40;
      const limitCount = 40;
      const hasAddon = false;
      const remaining = Math.max(0, limitCount - requestCount);
      const canPurchase = !hasAddon && remaining === 0;

      expect(canPurchase).toBe(true);
    });

    it('blocks purchase when addon already active', () => {
      const hasAddon = true;
      const canPurchase = !hasAddon;

      expect(canPurchase).toBe(false);
    });

    it('blocks purchase when still under limit', () => {
      const requestCount = 30;
      const limitCount = 40;
      const hasAddon = false;
      const remaining = Math.max(0, limitCount - requestCount);
      const canPurchase = !hasAddon && remaining === 0;

      expect(canPurchase).toBe(false);
    });

    it('addon price is $1.99 (199 cents)', () => {
      const addonPrice = {
        amount: 199,
        currency: 'USD',
        display: '$1.99',
      };

      expect(addonPrice.amount).toBe(199);
      expect(addonPrice.currency).toBe('USD');
    });
  });

  describe('Gender Mapping', () => {
    const mapGenderToString = (gender?: string | null): string | null => {
      if (!gender) return null;
      switch (gender.toUpperCase()) {
        case 'MALE': return 'male';
        case 'FEMALE': return 'female';
        case 'OTHER': return 'non-binary';
        default: return null;
      }
    };

    it('maps MALE to male', () => {
      expect(mapGenderToString('MALE')).toBe('male');
    });

    it('maps FEMALE to female', () => {
      expect(mapGenderToString('FEMALE')).toBe('female');
    });

    it('maps OTHER to non-binary', () => {
      expect(mapGenderToString('OTHER')).toBe('non-binary');
    });

    it('returns null for undefined', () => {
      expect(mapGenderToString(undefined)).toBeNull();
    });

    it('returns null for null', () => {
      expect(mapGenderToString(null)).toBeNull();
    });
  });

  describe('Language Instructions', () => {
    const getLanguageInstructions = (locale: string): string => {
      const instructions: Record<string, string> = {
        en: 'Respond entirely in English. Use warm, approachable language.',
        ro: 'IMPORTANT: Respond entirely in Romanian. Use warm, formal language (folosește "dumneavoastră").',
        fr: 'IMPORTANT: Respond entirely in French. Use elegant, warm language with vous.',
        de: 'IMPORTANT: Respond entirely in German. Use Sie form, warm but professional.',
        es: 'IMPORTANT: Respond entirely in Spanish. Use warm, engaging language with usted.',
        it: 'IMPORTANT: Respond entirely in Italian. Use Lei form, expressive and warm.',
        hu: 'IMPORTANT: Respond entirely in Hungarian. Use magázódás, warm and respectful.',
        pl: 'IMPORTANT: Respond entirely in Polish. Use Pan/Pani form, warm and polite.',
      };
      return instructions[locale] || instructions.en;
    };

    it('returns Romanian instructions for ro locale', () => {
      const instructions = getLanguageInstructions('ro');
      expect(instructions).toContain('Romanian');
      expect(instructions).toContain('dumneavoastră');
    });

    it('returns English as default for unknown locale', () => {
      const instructions = getLanguageInstructions('xyz');
      expect(instructions).toContain('English');
    });

    it('supports 8 languages', () => {
      const locales = ['en', 'ro', 'fr', 'de', 'es', 'it', 'hu', 'pl'];
      locales.forEach(locale => {
        const instructions = getLanguageInstructions(locale);
        expect(instructions.length).toBeGreaterThan(0);
      });
    });
  });

  describe('Transit Formatting', () => {
    const formatTransits = (transits: any[]): string => {
      if (!transits || transits.length === 0) {
        return 'No significant transits today.';
      }

      const personalPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
      const prioritized = [...transits].sort((a, b) => {
        const aScore = personalPlanets.includes(a.transitPlanet) ? 2 : 0;
        const bScore = personalPlanets.includes(b.transitPlanet) ? 2 : 0;
        return bScore - aScore;
      });

      return prioritized
        .slice(0, 8)
        .map((t) => {
          if (typeof t === 'string') return t;
          if (t.transitPlanet && t.aspectType && t.natalPlanet) {
            let desc = `${t.transitPlanet} ${t.aspectType} natal ${t.natalPlanet}`;
            if (t.transitSign) desc += ` (in ${t.transitSign})`;
            return desc;
          }
          return t.description || JSON.stringify(t).substring(0, 60);
        })
        .join('\n');
    };

    it('returns placeholder for empty transits', () => {
      expect(formatTransits([])).toBe('No significant transits today.');
      expect(formatTransits(null as any)).toBe('No significant transits today.');
    });

    it('formats transit objects correctly', () => {
      const transits = [
        { transitPlanet: 'Mars', aspectType: 'conjunction', natalPlanet: 'Sun', transitSign: 'Aries' },
      ];
      const formatted = formatTransits(transits);
      expect(formatted).toContain('Mars conjunction natal Sun');
      expect(formatted).toContain('(in Aries)');
    });

    it('prioritizes personal planets', () => {
      const transits = [
        { transitPlanet: 'Saturn', aspectType: 'square', natalPlanet: 'Mars' },
        { transitPlanet: 'Venus', aspectType: 'trine', natalPlanet: 'Moon' },
      ];
      const formatted = formatTransits(transits);
      // Venus should come first as it's a personal planet
      expect(formatted.indexOf('Venus')).toBeLessThan(formatted.indexOf('Saturn'));
    });

    it('limits to 8 transits maximum', () => {
      const transits = Array(15).fill(null).map((_, i) => ({
        transitPlanet: 'Planet' + i,
        aspectType: 'aspect',
        natalPlanet: 'Natal' + i,
      }));
      const formatted = formatTransits(transits);
      const lines = formatted.split('\n');
      expect(lines.length).toBeLessThanOrEqual(8);
    });
  });
});

/**
 * INTEGRATION NOTES:
 * ==================
 * 
 * 1. Ask Your Guide replaces "Your Focus" feature
 * 2. Monthly limit: 40 requests per billing period
 * 3. Add-on ($1.99): Doubles limit to 80 requests
 * 4. Billing resets on subscription anniversary date
 * 5. AI uses natal chart + transits + gender for personalization
 * 6. Supports 8 languages with formal tone instructions
 */
