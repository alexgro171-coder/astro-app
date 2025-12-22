import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

/// Entitlements - Feature flags based on subscription status
class Entitlements {
  final bool canUsePersonalContext;
  final bool canUseAudioTts;
  final String aiProfileDepth; // 'basic' | 'deep'
  final bool trialActive;
  final int? trialDaysRemaining;
  final String planTier; // 'free' | 'standard' | 'premium'
  final String? billingPeriod; // 'monthly' | 'yearly'
  final String subscriptionStatus; // 'none' | 'trial' | 'active' | 'canceled' | 'expired' | 'past_due'
  final DateTime? subscriptionEndDate;
  final String? provider; // 'stripe' | 'apple' | 'google'

  const Entitlements({
    required this.canUsePersonalContext,
    required this.canUseAudioTts,
    required this.aiProfileDepth,
    required this.trialActive,
    this.trialDaysRemaining,
    required this.planTier,
    this.billingPeriod,
    required this.subscriptionStatus,
    this.subscriptionEndDate,
    this.provider,
  });

  /// Default entitlements for unauthenticated/free users
  factory Entitlements.free() => const Entitlements(
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
      );

  /// Parse from API response
  factory Entitlements.fromJson(Map<String, dynamic> json) {
    return Entitlements(
      canUsePersonalContext: json['canUsePersonalContext'] ?? false,
      canUseAudioTts: json['canUseAudioTts'] ?? false,
      aiProfileDepth: json['aiProfileDepth'] ?? 'basic',
      trialActive: json['trialActive'] ?? false,
      trialDaysRemaining: json['trialDaysRemaining'],
      planTier: json['planTier'] ?? 'free',
      billingPeriod: json['billingPeriod'],
      subscriptionStatus: json['subscriptionStatus'] ?? 'none',
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.parse(json['subscriptionEndDate'])
          : null,
      provider: json['provider'],
    );
  }

  /// Check if user has any active access (trial or subscription)
  bool get hasAccess => subscriptionStatus != 'none' && subscriptionStatus != 'expired';

  /// Check if user is on Premium tier
  bool get isPremium => planTier == 'premium';

  /// Check if user is on Standard tier
  bool get isStandard => planTier == 'standard';

  /// Check if user needs to see paywall
  bool get needsPaywall => subscriptionStatus == 'none' || subscriptionStatus == 'expired';

  /// Get display text for subscription status
  String get statusDisplayText {
    switch (subscriptionStatus) {
      case 'trial':
        return 'Trial (${trialDaysRemaining ?? 0} days left)';
      case 'active':
        return '${planTier.toUpperCase()} - ${billingPeriod ?? ""}';
      case 'canceled':
        return 'Canceled (expires ${_formatDate(subscriptionEndDate)})';
      case 'expired':
        return 'Expired';
      case 'past_due':
        return 'Payment issue';
      default:
        return 'Free';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }
}

/// Entitlements Service - Fetches and caches user entitlements
class EntitlementsService extends ChangeNotifier {
  final ApiClient _apiClient;
  Entitlements _entitlements = Entitlements.free();
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetch;

  EntitlementsService(this._apiClient);

  Entitlements get entitlements => _entitlements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch entitlements from API
  Future<Entitlements> fetchEntitlements({bool forceRefresh = false}) async {
    // Use cached if recent (5 minutes) unless force refresh
    if (!forceRefresh &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(minutes: 5)) {
      return _entitlements;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.getEntitlements();
      _entitlements = Entitlements.fromJson(response.data);
      _lastFetch = DateTime.now();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('Error fetching entitlements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _entitlements;
  }

  /// Update entitlements (called after purchase/restore)
  void updateEntitlements(Entitlements newEntitlements) {
    _entitlements = newEntitlements;
    _lastFetch = DateTime.now();
    notifyListeners();
  }

  /// Clear entitlements (on logout)
  void clear() {
    _entitlements = Entitlements.free();
    _lastFetch = null;
    _error = null;
    notifyListeners();
  }

  /// Check if feature is available
  bool canUseFeature(String feature) {
    switch (feature) {
      case 'personal_context':
        return _entitlements.canUsePersonalContext;
      case 'audio_tts':
        return _entitlements.canUseAudioTts;
      default:
        return _entitlements.hasAccess;
    }
  }
}

/// Provider for EntitlementsService
final entitlementsServiceProvider = ChangeNotifierProvider<EntitlementsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EntitlementsService(apiClient);
});

/// Provider for current entitlements (convenience)
final entitlementsProvider = Provider<Entitlements>((ref) {
  return ref.watch(entitlementsServiceProvider).entitlements;
});

/// Provider for checking if user has access
final hasAccessProvider = Provider<bool>((ref) {
  return ref.watch(entitlementsProvider).hasAccess;
});

/// Provider for checking if user is premium
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(entitlementsProvider).isPremium;
});

/// Provider for checking if paywall should be shown
final needsPaywallProvider = Provider<bool>((ref) {
  return ref.watch(entitlementsProvider).needsPaywall;
});

