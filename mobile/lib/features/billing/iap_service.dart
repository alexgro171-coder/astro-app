import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../../core/network/api_client.dart';
import '../../core/services/entitlements_service.dart';

/// Product IDs - Must match store configuration
class ProductIds {
  // iOS Product IDs (App Store Connect)
  static const iosStandardMonthly = 'com.innerwidsom.standard.monthly';
  static const iosStandardYearly = 'com.innerwidsom.standard.yearly';
  static const iosPremiumMonthly = 'com.innerwidsom.premium.monthly';
  static const iosPremiumYearly = 'com.innerwidsom.premium.yearly';

  // Android Product IDs (Google Play Console)
  static const androidStandardMonthly = 'standard_monthly';
  static const androidStandardYearly = 'standard_yearly';
  static const androidPremiumMonthly = 'premium_monthly';
  static const androidPremiumYearly = 'premium_yearly';

  static Set<String> get all => Platform.isIOS
      ? {iosStandardMonthly, iosStandardYearly, iosPremiumMonthly, iosPremiumYearly}
      : {androidStandardMonthly, androidStandardYearly, androidPremiumMonthly, androidPremiumYearly};

  static String getProductId(String tier, String period) {
    final isMonthly = period == 'monthly';
    final isPremium = tier == 'premium';

    if (Platform.isIOS) {
      if (isPremium) {
        return isMonthly ? iosPremiumMonthly : iosPremiumYearly;
      } else {
        return isMonthly ? iosStandardMonthly : iosStandardYearly;
      }
    } else {
      if (isPremium) {
        return isMonthly ? androidPremiumMonthly : androidPremiumYearly;
      } else {
        return isMonthly ? androidStandardMonthly : androidStandardYearly;
      }
    }
  }
}

/// Subscription Plan for UI
class SubscriptionPlan {
  final String productId;
  final String tier; // 'standard' | 'premium'
  final String period; // 'monthly' | 'yearly'
  final String price;
  final String? introductoryPrice;
  final ProductDetails? productDetails;

  SubscriptionPlan({
    required this.productId,
    required this.tier,
    required this.period,
    required this.price,
    this.introductoryPrice,
    this.productDetails,
  });

  String get displayName => '${tier[0].toUpperCase()}${tier.substring(1)}';
  String get periodDisplay => period == 'monthly' ? '/month' : '/year';
  bool get isPremium => tier == 'premium';
  bool get isYearly => period == 'yearly';
}

/// IAP Service - Handles in-app purchases
class IapService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final ApiClient _apiClient;
  final EntitlementsService _entitlementsService;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<SubscriptionPlan> _plans = [];
  bool _isAvailable = false;
  bool _isLoading = false;
  String? _error;
  bool _purchaseInProgress = false;

  IapService(this._apiClient, this._entitlementsService);

  List<SubscriptionPlan> get plans => _plans;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get purchaseInProgress => _purchaseInProgress;

  /// Initialize IAP
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      
      if (!_isAvailable) {
        _error = 'Store not available';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Listen for purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );

      // Finish any pending transactions (iOS)
      if (Platform.isIOS) {
        final paymentWrapper = SKPaymentQueueWrapper();
        final transactions = await paymentWrapper.transactions();
        for (final transaction in transactions) {
          await paymentWrapper.finishTransaction(transaction);
        }
      }

      // Load products
      await loadProducts();
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('IAP initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load products from store
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    try {
      final response = await _inAppPurchase.queryProductDetails(ProductIds.all);

      if (response.notFoundIDs.isNotEmpty) {
        if (kDebugMode) print('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      _plans = _buildPlans(_products);
      _error = response.error?.message;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('Error loading products: $e');
    }

    notifyListeners();
  }

  /// Build subscription plans from product details
  List<SubscriptionPlan> _buildPlans(List<ProductDetails> products) {
    final plans = <SubscriptionPlan>[];

    for (final product in products) {
      final id = product.id.toLowerCase();
      final tier = id.contains('premium') ? 'premium' : 'standard';
      final period = id.contains('yearly') || id.contains('annual') ? 'yearly' : 'monthly';

      plans.add(SubscriptionPlan(
        productId: product.id,
        tier: tier,
        period: period,
        price: product.price,
        productDetails: product,
      ));
    }

    // Sort: Premium first, then yearly within each tier
    plans.sort((a, b) {
      if (a.tier != b.tier) return a.isPremium ? -1 : 1;
      return a.isYearly ? -1 : 1;
    });

    return plans;
  }

  /// Purchase a subscription
  Future<bool> purchase(SubscriptionPlan plan) async {
    if (_purchaseInProgress) return false;
    if (plan.productDetails == null) {
      _error = 'Product details not available';
      notifyListeners();
      return false;
    }

    _purchaseInProgress = true;
    _error = null;
    notifyListeners();

    try {
      final purchaseParam = PurchaseParam(productDetails: plan.productDetails!);
      
      // For subscriptions, use buyNonConsumable
      final success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      if (!success) {
        _error = 'Purchase initiation failed';
        _purchaseInProgress = false;
        notifyListeners();
        return false;
      }

      // Purchase result will come through the stream
      return true;
    } catch (e) {
      _error = e.toString();
      _purchaseInProgress = false;
      notifyListeners();
      return false;
    }
  }

  /// Handle purchase updates from stream
  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (kDebugMode) {
        print('Purchase update: ${purchaseDetails.productID} - ${purchaseDetails.status}');
      }

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Show loading state
          _purchaseInProgress = true;
          notifyListeners();
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify with backend
          final verified = await _verifyPurchase(purchaseDetails);
          
          if (verified) {
            // Complete the purchase
            await _inAppPurchase.completePurchase(purchaseDetails);
            
            // Refresh entitlements
            await _entitlementsService.fetchEntitlements(forceRefresh: true);
          } else {
            _error = 'Purchase verification failed';
          }
          
          _purchaseInProgress = false;
          notifyListeners();
          break;

        case PurchaseStatus.error:
          _error = purchaseDetails.error?.message ?? 'Purchase error';
          _purchaseInProgress = false;
          await _inAppPurchase.completePurchase(purchaseDetails);
          notifyListeners();
          break;

        case PurchaseStatus.canceled:
          _purchaseInProgress = false;
          notifyListeners();
          break;
      }
    }
  }

  /// Verify purchase with backend
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (Platform.isIOS) {
        // iOS: Send receipt data
        final receiptData = purchaseDetails.verificationData.serverVerificationData;
        
        final response = await _apiClient.verifyAppleReceipt(
          receiptData: receiptData,
          productId: purchaseDetails.productID,
        );
        
        return response.data['success'] == true;
      } else {
        // Android: Send purchase token
        final googleDetails = purchaseDetails as GooglePlayPurchaseDetails;
        
        final response = await _apiClient.verifyGooglePurchase(
          purchaseToken: googleDetails.verificationData.serverVerificationData,
          productId: purchaseDetails.productID,
        );
        
        return response.data['success'] == true;
      }
    } catch (e) {
      if (kDebugMode) print('Verification error: $e');
      _error = 'Verification failed: $e';
      return false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _inAppPurchase.restorePurchases();
      // Results will come through the stream
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Open subscription management
  Future<void> openSubscriptionManagement() async {
    // On iOS, this opens the App Store subscriptions page
    // On Android, this opens Google Play subscriptions
    if (Platform.isIOS) {
      // iOS: Open App Store subscription management
      final transactions = await SKPaymentQueueWrapper().transactions();
      // The user needs to manage subscriptions in Settings > Apple ID > Subscriptions
    } else {
      // Android: Use Play Store deep link
      // https://play.google.com/store/account/subscriptions
    }
  }

  /// Dispose
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider for IapService
final iapServiceProvider = ChangeNotifierProvider<IapService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final entitlementsService = ref.watch(entitlementsServiceProvider);
  return IapService(apiClient, entitlementsService);
});

/// Provider for subscription plans
final subscriptionPlansProvider = Provider<List<SubscriptionPlan>>((ref) {
  return ref.watch(iapServiceProvider).plans;
});

