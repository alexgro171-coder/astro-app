import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  ApiClient() {
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
        // Add auth token if available
        final token = await _storage.read(key: AppConstants.accessTokenKey);
        print('API Request: ${options.method} ${options.path}');
        print('Token available: ${token != null ? "YES (${token.substring(0, 20)}...)" : "NO"}');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('API Response: ${response.statusCode} for ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('API Error: ${error.response?.statusCode} - ${error.message} for ${error.requestOptions.path}');
        // Handle 401 - try refresh token
        if (error.response?.statusCode == 401) {
          print('Attempting token refresh...');
          final refreshed = await _refreshToken();
          if (refreshed) {
            print('Token refreshed successfully, retrying request');
            // Retry the request
            final token = await _storage.read(key: AppConstants.accessTokenKey);
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            return handler.resolve(response);
          }
          print('Token refresh failed');
        }
        return handler.next(error);
      },
    ));
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

  // Auth
  Future<Response> signup(Map<String, dynamic> data) {
    return _dio.post('/auth/signup', data: data);
  }

  Future<Response> login(Map<String, dynamic> data) {
    return _dio.post('/auth/login', data: data);
  }

  Future<Response> logout() {
    return _dio.post('/auth/logout');
  }

  // User Profile
  Future<Response> getProfile() {
    return _dio.get('/me');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put('/me', data: data);
  }

  Future<Response> setBirthData(Map<String, dynamic> data) {
    return _dio.post('/me/birth-data', data: data);
  }

  // Astrology
  Future<Response> searchLocation(String place) {
    return _dio.get('/astrology/geo-search', queryParameters: {'place': place});
  }

  Future<Response> getNatalChart() {
    return _dio.get('/astrology/natal-chart');
  }

  Future<Response> getTodayTransits() {
    return _dio.get('/astrology/transits/today');
  }

  // Concerns
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

  // Guidance
  Future<Response> getTodayGuidance() {
    return _dio.get('/guidance/today');
  }

  Future<Response> getGuidanceHistory({String? from, String? to}) {
    return _dio.get('/guidance/history', queryParameters: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });
  }

  Future<Response> submitFeedback(String id, Map<String, dynamic> data) {
    return _dio.post('/guidance/$id/feedback', data: data);
  }

  // Save tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  // Clear tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }
}

