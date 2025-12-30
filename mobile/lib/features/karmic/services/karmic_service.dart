import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

/// Status for karmic astrology reading
class KarmicStatus {
  final bool betaFree;
  final int priceUsd;
  final String locale;
  final bool isUnlocked;
  final String status; // 'READY', 'PENDING', 'NONE', 'FAILED'
  final String? content;
  final String? errorMsg;

  KarmicStatus({
    required this.betaFree,
    required this.priceUsd,
    required this.locale,
    required this.isUnlocked,
    required this.status,
    this.content,
    this.errorMsg,
  });

  factory KarmicStatus.fromJson(Map<String, dynamic> json) {
    return KarmicStatus(
      betaFree: json['betaFree'] ?? false,
      priceUsd: json['priceUsd'] ?? 15,
      locale: json['locale'] ?? 'en',
      isUnlocked: json['isUnlocked'] ?? false,
      status: json['status'] ?? 'NONE',
      content: json['content'],
      errorMsg: json['errorMsg'],
    );
  }

  bool get isReady => status == 'READY';
  bool get isPending => status == 'PENDING';
  bool get isFailed => status == 'FAILED';
  bool get isNone => status == 'NONE';
}

/// Provider for KarmicService
final karmicServiceProvider = Provider<KarmicService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return KarmicService(apiClient);
});

/// Provider for karmic status
final karmicStatusProvider = FutureProvider<KarmicStatus>((ref) async {
  final service = ref.watch(karmicServiceProvider);
  return service.getStatus();
});

/// Service for Karmic Astrology feature
class KarmicService {
  final ApiClient _apiClient;

  KarmicService(this._apiClient);

  /// Get karmic astrology status
  Future<KarmicStatus> getStatus() async {
    try {
      final response = await _apiClient.get('/for-you/karmic');
      if (response.statusCode == 200 && response.data != null) {
        return KarmicStatus.fromJson(response.data);
      }
      return KarmicStatus(
        betaFree: false,
        priceUsd: 15,
        locale: 'en',
        isUnlocked: false,
        status: 'NONE',
      );
    } catch (e) {
      debugPrint('KarmicService: Error getting status: $e');
      return KarmicStatus(
        betaFree: false,
        priceUsd: 15,
        locale: 'en',
        isUnlocked: false,
        status: 'NONE',
        errorMsg: e.toString(),
      );
    }
  }

  /// Generate karmic astrology reading
  /// Uses longer timeout (90s) as AI generation can take time
  Future<KarmicStatus> generateReading() async {
    try {
      final response = await _apiClient.post(
        '/for-you/karmic/generate',
        options: Options(
          receiveTimeout: const Duration(seconds: 90),
          sendTimeout: const Duration(seconds: 90),
        ),
      );
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        return KarmicStatus.fromJson(response.data);
      }
      throw Exception('Failed to generate reading: ${response.statusCode}');
    } catch (e) {
      debugPrint('KarmicService: Error generating reading: $e');
      rethrow;
    }
  }
}

