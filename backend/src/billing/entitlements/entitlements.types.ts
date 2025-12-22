/**
 * Entitlements Types
 * 
 * Central definition of user entitlements based on subscription status.
 * These flags are used throughout the app for feature gating.
 */

export interface Entitlements {
  // Feature flags
  canUsePersonalContext: boolean;   // Premium only: use onboarding answers in AI
  canUseAudioTts: boolean;          // Premium only: audio reading
  
  // AI configuration
  aiProfileDepth: 'basic' | 'deep'; // basic = Standard, deep = Premium
  
  // Subscription state
  trialActive: boolean;
  trialDaysRemaining: number | null;
  
  // Plan info
  planTier: 'free' | 'standard' | 'premium';
  billingPeriod: 'monthly' | 'yearly' | null;
  
  // Status
  subscriptionStatus: 'none' | 'trial' | 'active' | 'canceled' | 'expired' | 'past_due';
  
  // Dates
  subscriptionEndDate: Date | null;
  
  // Provider info
  provider: 'stripe' | 'apple' | 'google' | null;
}

export const DEFAULT_ENTITLEMENTS: Entitlements = {
  canUsePersonalContext: false,
  canUseAudioTts: false,
  aiProfileDepth: 'basic',
  trialActive: false,
  trialDaysRemaining: null,
  planTier: 'free',
  billingPeriod: null,
  subscriptionStatus: 'none',
  subscriptionEndDate: null,
  provider: null,
};

export const TRIAL_ENTITLEMENTS: Entitlements = {
  canUsePersonalContext: true,   // Trial gets Premium features
  canUseAudioTts: true,
  aiProfileDepth: 'deep',
  trialActive: true,
  trialDaysRemaining: 3,
  planTier: 'premium',
  billingPeriod: null,
  subscriptionStatus: 'trial',
  subscriptionEndDate: null,
  provider: null,
};

export const STANDARD_ENTITLEMENTS: Partial<Entitlements> = {
  canUsePersonalContext: false,
  canUseAudioTts: false,
  aiProfileDepth: 'basic',
  trialActive: false,
  planTier: 'standard',
};

export const PREMIUM_ENTITLEMENTS: Partial<Entitlements> = {
  canUsePersonalContext: true,
  canUseAudioTts: true,
  aiProfileDepth: 'deep',
  trialActive: false,
  planTier: 'premium',
};

/**
 * Product IDs for each store
 * Must match exactly what's configured in App Store Connect / Google Play Console / Stripe
 */
export const PRODUCT_IDS = {
  APPLE: {
    STANDARD_MONTHLY: 'com.innerwidsom.standard.monthly',
    STANDARD_YEARLY: 'com.innerwidsom.standard.yearly',
    PREMIUM_MONTHLY: 'com.innerwidsom.premium.monthly',
    PREMIUM_YEARLY: 'com.innerwidsom.premium.yearly',
  },
  GOOGLE: {
    STANDARD_MONTHLY: 'standard_monthly',
    STANDARD_YEARLY: 'standard_yearly',
    PREMIUM_MONTHLY: 'premium_monthly',
    PREMIUM_YEARLY: 'premium_yearly',
  },
  STRIPE: {
    STANDARD_MONTHLY: 'price_standard_monthly',
    STANDARD_YEARLY: 'price_standard_yearly',
    PREMIUM_MONTHLY: 'price_premium_monthly',
    PREMIUM_YEARLY: 'price_premium_yearly',
  },
} as const;

/**
 * Pricing configuration (in cents USD)
 */
export const PRICING = {
  STANDARD: {
    MONTHLY: 499,   // $4.99
    YEARLY: 3999,   // $39.99 (save ~33%)
  },
  PREMIUM: {
    MONTHLY: 999,   // $9.99
    YEARLY: 7999,   // $79.99 (save ~33%)
  },
} as const;

/**
 * Trial configuration
 */
export const TRIAL_CONFIG = {
  DURATION_DAYS: 3,
  TIER: 'premium' as const,
} as const;

