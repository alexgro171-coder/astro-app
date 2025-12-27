import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/context_answers.dart';
import '../models/context_profile.dart';

/// Provider for ContextService
final contextServiceProvider = Provider<ContextService>((ref) {
  return ContextService(ref.read(apiClientProvider));
});

/// Provider for current context profile
final contextProfileProvider = StateNotifierProvider<ContextProfileNotifier, AsyncValue<ContextProfile?>>((ref) {
  return ContextProfileNotifier(ref.read(contextServiceProvider));
});

/// Provider for context review status
final contextStatusProvider = FutureProvider<ContextStatus>((ref) async {
  return ref.read(contextServiceProvider).getStatus();
});

/// Service for managing user context profile (V1 Questionnaire)
class ContextService {
  final ApiClient _apiClient;

  ContextService(this._apiClient);

  /// Get current context profile
  Future<ContextProfileResponse> getProfile() async {
    try {
      final response = await _apiClient.getContextProfile();
      return ContextProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) print('Error getting context profile: $e');
      rethrow;
    }
  }

  /// Get context review status (for 90-day check)
  Future<ContextStatus> getStatus() async {
    try {
      final response = await _apiClient.getContextStatus();
      return ContextStatus.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) print('Error getting context status: $e');
      // Return default status on error
      return ContextStatus(hasProfile: false, needsReview: false);
    }
  }

  /// Create initial context profile (onboarding)
  Future<ContextProfile> createProfile(ContextAnswers answers) async {
    try {
      final response = await _apiClient.createContextProfile(answers.toJson());
      return ContextProfile.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) print('Error creating context profile: $e');
      rethrow;
    }
  }

  /// Update existing context profile (settings / 90-day refresh)
  Future<ContextProfile> updateProfile(ContextAnswers answers) async {
    try {
      final response = await _apiClient.updateContextProfile(answers.toJson());
      return ContextProfile.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) print('Error updating context profile: $e');
      rethrow;
    }
  }

  /// Defer review (user selected "No changes" in 90-day prompt)
  Future<void> deferReview() async {
    try {
      await _apiClient.deferContextReview();
    } catch (e) {
      if (kDebugMode) print('Error deferring context review: $e');
      rethrow;
    }
  }

  /// Delete context profile
  Future<void> deleteProfile() async {
    try {
      await _apiClient.deleteContextProfile();
    } catch (e) {
      if (kDebugMode) print('Error deleting context profile: $e');
      rethrow;
    }
  }

  /// Get profile history (versions)
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final response = await _apiClient.getContextHistory();
      return (response.data as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      if (kDebugMode) print('Error getting context history: $e');
      return [];
    }
  }
}

/// State notifier for context profile
class ContextProfileNotifier extends StateNotifier<AsyncValue<ContextProfile?>> {
  final ContextService _service;

  ContextProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  /// Load profile from server
  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.getProfile();
      state = AsyncValue.data(response.profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Create new profile
  Future<void> createProfile(ContextAnswers answers) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.createProfile(answers);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update existing profile
  Future<void> updateProfile(ContextAnswers answers) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.updateProfile(answers);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Clear profile state (on logout)
  void clear() {
    state = const AsyncValue.data(null);
  }
}

