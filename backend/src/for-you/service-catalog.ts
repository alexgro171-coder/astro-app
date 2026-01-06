import { OneTimeServiceType } from '@prisma/client';

export interface ServiceCatalogEntry {
  serviceType: OneTimeServiceType;
  title: string;
  description: string;
  priceUsd: number; // in cents
  requiresPartner: boolean;
  requiresDate: boolean;
  productKey: string; // for purchase tracking
  astrologyApiEndpoint: string;
}

// Price environment variable names
const PRICE_ENV_MAP: Record<OneTimeServiceType, string> = {
  PERSONALITY_REPORT: 'ONE_TIME_PRICE_USD_PERSONALITY',
  ROMANTIC_PERSONALITY_REPORT: 'ONE_TIME_PRICE_USD_ROMANTIC_PERSONALITY',
  FRIENDSHIP_REPORT: 'ONE_TIME_PRICE_USD_FRIENDSHIP',
  LOVE_COMPATIBILITY_REPORT: 'ONE_TIME_PRICE_USD_LOVE',
  ROMANTIC_FORECAST_COUPLE_REPORT: 'ONE_TIME_PRICE_USD_ROMANTIC_FORECAST',
  MOON_PHASE_REPORT: 'ONE_TIME_PRICE_USD_MOON_PHASE',
};

// Default prices in cents (used if env not set)
const DEFAULT_PRICES: Record<OneTimeServiceType, number> = {
  PERSONALITY_REPORT: 499,           // $4.99
  ROMANTIC_PERSONALITY_REPORT: 499,  // $4.99
  FRIENDSHIP_REPORT: 699,            // $6.99
  LOVE_COMPATIBILITY_REPORT: 699,    // $6.99
  ROMANTIC_FORECAST_COUPLE_REPORT: 899, // $8.99
  MOON_PHASE_REPORT: 299,            // $2.99
};

function getPriceFromEnv(serviceType: OneTimeServiceType): number {
  const envKey = PRICE_ENV_MAP[serviceType];
  const envValue = process.env[envKey];
  if (envValue) {
    const parsed = parseInt(envValue, 10);
    if (!isNaN(parsed)) return parsed;
  }
  return DEFAULT_PRICES[serviceType];
}

export const SERVICE_CATALOG: Record<OneTimeServiceType, ServiceCatalogEntry> = {
  PERSONALITY_REPORT: {
    serviceType: 'PERSONALITY_REPORT',
    title: 'Personality Report',
    description: 'A comprehensive analysis of your personality based on your natal chart. Discover your strengths, challenges, and unique traits.',
    priceUsd: getPriceFromEnv('PERSONALITY_REPORT'),
    requiresPartner: false,
    requiresDate: false,
    productKey: 'one_time_personality_report',
    astrologyApiEndpoint: 'personality_report/tropical',
  },
  ROMANTIC_PERSONALITY_REPORT: {
    serviceType: 'ROMANTIC_PERSONALITY_REPORT',
    title: 'Romantic Personality Report',
    description: 'Understand how you approach love, romance, and intimate relationships based on your astrological profile.',
    priceUsd: getPriceFromEnv('ROMANTIC_PERSONALITY_REPORT'),
    requiresPartner: false,
    requiresDate: false,
    productKey: 'one_time_romantic_personality_report',
    astrologyApiEndpoint: 'romantic_personality_report/tropical',
  },
  FRIENDSHIP_REPORT: {
    serviceType: 'FRIENDSHIP_REPORT',
    title: 'Friendship Compatibility Report',
    description: 'Analyze the friendship dynamics between you and another person. Discover shared interests and potential challenges.',
    priceUsd: getPriceFromEnv('FRIENDSHIP_REPORT'),
    requiresPartner: true,
    requiresDate: false,
    productKey: 'one_time_friendship_report',
    astrologyApiEndpoint: 'friendship_report/tropical',
  },
  LOVE_COMPATIBILITY_REPORT: {
    serviceType: 'LOVE_COMPATIBILITY_REPORT',
    title: 'Love Compatibility Report',
    description: 'A detailed romantic compatibility analysis between you and your partner. Understand your love language and connection.',
    priceUsd: getPriceFromEnv('LOVE_COMPATIBILITY_REPORT'),
    requiresPartner: true,
    requiresDate: false,
    productKey: 'one_time_love_compatibility_report',
    astrologyApiEndpoint: 'love_compatibility_report/tropical',
  },
  ROMANTIC_FORECAST_COUPLE_REPORT: {
    serviceType: 'ROMANTIC_FORECAST_COUPLE_REPORT',
    title: 'Romantic Couple Forecast',
    description: 'Get insights into the future of your relationship. Discover upcoming opportunities and challenges for your partnership.',
    priceUsd: getPriceFromEnv('ROMANTIC_FORECAST_COUPLE_REPORT'),
    requiresPartner: true,
    requiresDate: false,
    productKey: 'one_time_romantic_forecast_couple_report',
    astrologyApiEndpoint: 'romantic_forecast_couple/tropical',
  },
  MOON_PHASE_REPORT: {
    serviceType: 'MOON_PHASE_REPORT',
    title: 'Moon Phase Report',
    description: 'Understand the current lunar energy and how it affects you. Get guidance aligned with the moon\'s phase.',
    priceUsd: getPriceFromEnv('MOON_PHASE_REPORT'),
    requiresPartner: false,
    requiresDate: true,
    productKey: 'one_time_moon_phase_report',
    astrologyApiEndpoint: 'moon_phase_report',
  },
};

// Get all services ordered for display
export function getOrderedServices(): ServiceCatalogEntry[] {
  return [
    SERVICE_CATALOG.PERSONALITY_REPORT,
    SERVICE_CATALOG.LOVE_COMPATIBILITY_REPORT,
    SERVICE_CATALOG.ROMANTIC_FORECAST_COUPLE_REPORT,
    SERVICE_CATALOG.ROMANTIC_PERSONALITY_REPORT,
    SERVICE_CATALOG.FRIENDSHIP_REPORT,
  ];
}

// Get compatibility services only (for Compatibilities Hub)
export function getCompatibilityServices(): ServiceCatalogEntry[] {
  return [
    SERVICE_CATALOG.PERSONALITY_REPORT,
    SERVICE_CATALOG.LOVE_COMPATIBILITY_REPORT,
    SERVICE_CATALOG.ROMANTIC_FORECAST_COUPLE_REPORT,
    SERVICE_CATALOG.ROMANTIC_PERSONALITY_REPORT,
    SERVICE_CATALOG.FRIENDSHIP_REPORT,
  ];
}

// Check if beta free mode is enabled
export function isBetaFree(): boolean {
  return process.env.BETA_FREE_ONE_TIME === 'true';
}

// Supported locales
export const SUPPORTED_LOCALES = ['en', 'ro', 'fr', 'de', 'es', 'it', 'hu', 'pl'];
export const DEFAULT_LOCALE = 'en';

