import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../constants/app_constants.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'InnerWisdomApp',
      publicKey: 'InnerWisdomApp',
    ),
  );
  
  // Cache the IANA timezone identifier
  String _cachedTimezone = 'UTC';
  
  // Completer to ensure timezone is initialized before first API call
  late final Future<void> _timezoneInitialized;

  ApiClient() {
    // Initialize timezone asynchronously and track completion
    _timezoneInitialized = _initTimezone();
    
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl, // Production URL with HTTPS
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ensure timezone is initialized before any request
        await _timezoneInitialized;
        
        // Add auth token if available
        final token = await _storage.read(key: AppConstants.accessTokenKey);
        if (kDebugMode) {
          print('API Request: ${options.method} ${options.path}');
          print('Token available: ${token != null ? "YES" : "NO"}');
        }
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // Add user timezone for guidance endpoints (IANA format like "Europe/Bucharest")
        if (options.path.contains('/guidance')) {
          // Refresh timezone in case it changed (e.g., user traveled)
          await _initTimezone();
          options.headers['X-User-Timezone'] = _cachedTimezone;
          if (kDebugMode) {
            print('Using timezone: $_cachedTimezone');
          }
        }
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('API Response: ${response.statusCode} for ${response.requestOptions.path}');
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        if (kDebugMode) {
          print('API Error: ${error.response?.statusCode} - ${error.message} for ${error.requestOptions.path}');
        }
        // Handle 401 - try refresh token
        if (error.response?.statusCode == 401) {
          if (kDebugMode) print('Attempting token refresh...');
          final refreshed = await _refreshToken();
          if (refreshed) {
            if (kDebugMode) print('Token refreshed successfully, retrying request');
            // Retry the request
            final token = await _storage.read(key: AppConstants.accessTokenKey);
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            return handler.resolve(response);
          }
          if (kDebugMode) print('Token refresh failed');
        }
        return handler.next(error);
      },
    ));
  }

  /// Initialize and cache the IANA timezone identifier
  /// Uses flutter_timezone to get proper IANA names like "Europe/Bucharest"
  /// instead of abbreviations like "EET" or "EEST"
  Future<void> _initTimezone() async {
    try {
      // flutter_timezone returns IANA identifiers like "Europe/Bucharest"
      _cachedTimezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting timezone: $e');
      }
      _cachedTimezone = 'UTC';
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        await _storage.write(
          key: AppConstants.accessTokenKey,
          value: response.data['accessToken'],
        );
        await _storage.write(
          key: AppConstants.refreshTokenKey,
          value: response.data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== AUTH ====================
  
  Future<Response> signup(Map<String, dynamic> data) {
    return _dio.post('/auth/signup', data: data);
  }

  Future<Response> login(Map<String, dynamic> data) {
    return _dio.post('/auth/login', data: data);
  }

  Future<Response> logout() {
    return _dio.post('/auth/logout');
  }

  // ==================== USER PROFILE ====================
  
  Future<Response> getProfile() {
    return _dio.get('/me');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put('/me', data: data);
  }

  Future<Response> setBirthData(Map<String, dynamic> data) {
    return _dio.post('/me/birth-data', data: data);
  }

  // ==================== ASTROLOGY ====================
  
  Future<Response> searchLocation(String place) {
    return _dio.get('/astrology/geo-search', queryParameters: {'place': place});
  }

  Future<Response> getNatalChart() {
    return _dio.get('/astrology/natal-chart');
  }

  Future<Response> getTodayTransits() {
    return _dio.get('/astrology/transits/today');
  }

  // ==================== CONCERNS ====================
  
  Future<Response> createConcern(Map<String, dynamic> data) {
    return _dio.post('/concerns', data: data);
  }

  Future<Response> getConcerns() {
    return _dio.get('/concerns');
  }

  Future<Response> getActiveConcern() {
    return _dio.get('/concerns/active');
  }

  Future<Response> resolveConcern(String id) {
    return _dio.post('/concerns/$id/resolve');
  }

  // ==================== GUIDANCE ====================
  
  /// Get today's guidance (ON-DEMAND generation)
  /// 
  /// This triggers guidance generation if not already cached.
  /// The X-User-Timezone header is automatically added.
  Future<Response> getTodayGuidance() {
    return _dio.get('/guidance/today');
  }

  /// Get a specific guidance by ID
  /// 
  /// If the ID is 'today' or matches today's guidance, returns today's guidance.
  /// Otherwise fetches from history.
  Future<Response> getGuidanceById(String id) async {
    // If 'today' is passed, get today's guidance
    if (id == 'today') {
      return getTodayGuidance();
    }
    
    // Try to get from history - the backend returns the specific guidance
    // For now, we'll get history and find the matching one
    // TODO: Add dedicated /guidance/:id endpoint in backend
    final historyResponse = await getGuidanceHistory(limit: 30);
    final history = historyResponse.data as List<dynamic>;
    
    // Find the guidance with matching ID
    final guidance = history.firstWhere(
      (g) => g['id'] == id,
      orElse: () => null,
    );
    
    if (guidance != null) {
      // Return a response-like object with the found guidance
      return Response(
        requestOptions: historyResponse.requestOptions,
        data: guidance,
        statusCode: 200,
      );
    }
    
    // Fallback to today's guidance if not found
    return getTodayGuidance();
  }

  /// Get guidance history with pagination
  Future<Response> getGuidanceHistory({int page = 1, int limit = 10}) {
    return _dio.get('/guidance/history', queryParameters: {
      'page': page,
      'limit': limit,
    });
  }

  /// Submit feedback for a guidance
  Future<Response> submitFeedback(String id, Map<String, dynamic> data) {
    return _dio.post('/guidance/$id/feedback', data: data);
  }

  /// Force regenerate today's guidance
  Future<Response> regenerateGuidance() {
    return _dio.post('/guidance/regenerate');
  }

  // ==================== BILLING & SUBSCRIPTIONS ====================
  
  /// Get current user entitlements
  Future<Response> getEntitlements() {
    return _dio.get('/billing/entitlements');
  }

  /// Get current subscription details
  Future<Response> getSubscription() {
    return _dio.get('/billing/subscription');
  }

  /// Get trial information
  Future<Response> getTrialInfo() {
    return _dio.get('/billing/trial');
  }

  /// Get available subscription plans
  Future<Response> getPlans() {
    return _dio.get('/billing/plans');
  }

  /// Verify Apple receipt
  Future<Response> verifyAppleReceipt({
    required String receiptData,
    required String productId,
    bool sandbox = false,
  }) {
    return _dio.post('/billing/iap/apple/verify', data: {
      'receiptData': receiptData,
      'productId': productId,
      'sandbox': sandbox,
    });
  }

  /// Verify Google Play purchase
  Future<Response> verifyGooglePurchase({
    required String purchaseToken,
    required String productId,
    String? packageName,
  }) {
    return _dio.post('/billing/iap/google/verify', data: {
      'purchaseToken': purchaseToken,
      'productId': productId,
      if (packageName != null) 'packageName': packageName,
    });
  }

  /// Restore purchases
  Future<Response> restorePurchases({
    required String platform,
    String? receiptData,
    String? purchaseToken,
    String? productId,
  }) {
    return _dio.post('/billing/iap/restore', data: {
      'platform': platform,
      if (receiptData != null) 'receiptData': receiptData,
      if (purchaseToken != null) 'purchaseToken': purchaseToken,
      if (productId != null) 'productId': productId,
    });
  }

  /// Cancel subscription
  Future<Response> cancelSubscription({String? reason, bool immediate = false}) {
    return _dio.post('/billing/cancel', data: {
      if (reason != null) 'reason': reason,
      'immediate': immediate,
    });
  }

  /// Request refund
  Future<Response> requestRefund(String reason, {String? paymentId}) {
    return _dio.post('/billing/refund-request', data: {
      'reason': reason,
      if (paymentId != null) 'paymentId': paymentId,
    });
  }

  /// Get payment history
  Future<Response> getPaymentHistory() {
    return _dio.get('/billing/payments');
  }

  // ==================== CONTEXT PROFILE (V1 Questionnaire) ====================

  /// Get context profile
  Future<Response> getContextProfile() {
    return _dio.get('/context/profile');
  }

  /// Get context review status (for 90-day check)
  Future<Response> getContextStatus() {
    return _dio.get('/context/status');
  }

  /// Create context profile (onboarding)
  Future<Response> createContextProfile(Map<String, dynamic> answers) {
    return _dio.post('/context/profile', data: answers);
  }

  /// Update context profile (settings / 90-day refresh)
  Future<Response> updateContextProfile(Map<String, dynamic> answers) {
    return _dio.put('/context/profile', data: answers);
  }

  /// Defer context review (user selected "No changes")
  Future<Response> deferContextReview() {
    return _dio.post('/context/review/defer');
  }

  /// Delete context profile
  Future<Response> deleteContextProfile() {
    return _dio.delete('/context/profile');
  }

  /// Get context profile history
  Future<Response> getContextHistory() {
    return _dio.get('/context/history');
  }

  // ==================== ONBOARDING STATUS ====================

  /// Get onboarding status (legacy)
  Future<Response> getOnboardingStatus() {
    return _dio.get('/onboarding/status');
  }

  // ==================== AUDIO TTS ====================

  /// Get audio for today's guidance (Premium only)
  Future<Response> getTodayAudio() {
    return _dio.get('/guidance/today/audio');
  }

  /// Request audio generation for specific guidance
  Future<Response> requestAudioGeneration(String guidanceId) {
    return _dio.post('/guidance/$guidanceId/audio');
  }

  /// Get audio status for specific guidance
  Future<Response> getAudioStatus(String guidanceId) {
    return _dio.get('/guidance/$guidanceId/audio');
  }

  // ==================== TOKEN MANAGEMENT ====================
  
  /// Save authentication tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  /// Clear authentication tokens (logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }
}
