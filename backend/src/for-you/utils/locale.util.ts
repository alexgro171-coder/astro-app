import { SUPPORTED_LOCALES, DEFAULT_LOCALE } from '../service-catalog';

/**
 * Parse Accept-Language header and return the best supported locale.
 * @param acceptLanguage - The Accept-Language header value
 * @returns The best matching supported locale or default
 */
export function parseAcceptLanguage(acceptLanguage?: string): string {
  if (!acceptLanguage) {
    return DEFAULT_LOCALE;
  }

  // Parse Accept-Language header (e.g., "en-US,en;q=0.9,ro;q=0.8")
  const languages = acceptLanguage
    .split(',')
    .map((lang) => {
      const [code, qValue] = lang.trim().split(';q=');
      return {
        code: code.split('-')[0].toLowerCase(), // Get primary language code
        quality: qValue ? parseFloat(qValue) : 1.0,
      };
    })
    .sort((a, b) => b.quality - a.quality);

  // Find first supported locale
  for (const lang of languages) {
    if (SUPPORTED_LOCALES.includes(lang.code)) {
      return lang.code;
    }
  }

  return DEFAULT_LOCALE;
}

/**
 * Resolve the locale to use based on priority:
 * 1. Body locale parameter (if valid)
 * 2. Accept-Language header
 * 3. User's stored language preference
 * 4. Default locale
 */
export function resolveLocale(
  bodyLocale?: string,
  acceptLanguage?: string,
  userLanguage?: string,
): string {
  // Priority 1: Body locale (if valid)
  if (bodyLocale && SUPPORTED_LOCALES.includes(bodyLocale.toLowerCase())) {
    return bodyLocale.toLowerCase();
  }

  // Priority 2: Accept-Language header
  const headerLocale = parseAcceptLanguage(acceptLanguage);
  if (headerLocale !== DEFAULT_LOCALE) {
    return headerLocale;
  }

  // Priority 3: User's stored language preference
  if (userLanguage && SUPPORTED_LOCALES.includes(userLanguage.toLowerCase())) {
    return userLanguage.toLowerCase();
  }

  // Priority 4: Default
  return DEFAULT_LOCALE;
}

/**
 * Get full language name from locale code.
 */
export function getLanguageName(locale: string): string {
  const names: Record<string, string> = {
    en: 'English',
    ro: 'Romanian',
    fr: 'French',
    de: 'German',
    es: 'Spanish',
    it: 'Italian',
    hu: 'Hungarian',
    pl: 'Polish',
  };
  return names[locale.toLowerCase()] || 'English';
}

