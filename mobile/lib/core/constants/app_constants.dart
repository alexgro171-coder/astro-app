class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.innerwisdomapp.com/api/v1/v1';
  static const String apiBaseUrlDev = 'http://64.225.97.205/api/v1/v1';
  
  // App Info
  static const String appName = 'Inner Wisdom';
  static const String appTagline = 'Your Personal Astrologer';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String languageKey = 'language';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDuration = Duration(seconds: 2);
}

