import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/services/entitlements_service.dart';
import 'iap_service.dart';
import 'widgets/plan_card.dart';

/// Paywall Screen
/// 
/// Shown when user needs to subscribe (after trial expires or skip trial).
/// Displays available plans and handles purchase flow.
class PaywallScreen extends ConsumerStatefulWidget {
  final bool fromTrialExpired;
  final bool canDismiss;

  const PaywallScreen({
    super.key,
    this.fromTrialExpired = false,
    this.canDismiss = true,
  });

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedTier = 'premium';
  String _selectedPeriod = 'yearly';

  @override
  void initState() {
    super.initState();
    // Initialize IAP service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(iapServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iapService = ref.watch(iapServiceProvider);
    final entitlements = ref.watch(entitlementsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Trial expired message
                      if (widget.fromTrialExpired)
                        _buildTrialExpiredMessage(),

                      const SizedBox(height: 20),

                      // Plan toggle (Standard / Premium)
                      _buildTierToggle(),

                      const SizedBox(height: 20),

                      // Period toggle (Monthly / Yearly)
                      _buildPeriodToggle(),

                      const SizedBox(height: 24),

                      // Selected plan details
                      _buildSelectedPlanCard(iapService),

                      const SizedBox(height: 24),

                      // Features comparison
                      _buildFeaturesComparison(),

                      const SizedBox(height: 32),

                      // Purchase button
                      _buildPurchaseButton(iapService),

                      const SizedBox(height: 16),

                      // Restore purchases
                      _buildRestoreButton(iapService),

                      const SizedBox(height: 16),

                      // Terms and privacy
                      _buildLegalLinks(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (widget.canDismiss)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              'Unlock Your Potential',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTrialExpiredMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.accent),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Your free trial has ended. Subscribe to continue receiving personalized guidance.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              'Standard',
              _selectedTier == 'standard',
              () => setState(() => _selectedTier = 'standard'),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              'Premium',
              _selectedTier == 'premium',
              () => setState(() => _selectedTier = 'premium'),
              isPremium: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              'Monthly',
              _selectedPeriod == 'monthly',
              () => setState(() => _selectedPeriod = 'monthly'),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              'Yearly (Save 33%)',
              _selectedPeriod == 'yearly',
              () => setState(() => _selectedPeriod = 'yearly'),
              showBadge: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    bool isSelected,
    VoidCallback onTap, {
    bool isPremium = false,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPremium && isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.star, size: 16, color: Colors.white),
              ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPlanCard(IapService iapService) {
    final plans = iapService.plans;
    final selectedPlan = plans.firstWhere(
      (p) => p.tier == _selectedTier && p.period == _selectedPeriod,
      orElse: () => SubscriptionPlan(
        productId: '',
        tier: _selectedTier,
        period: _selectedPeriod,
        price: _selectedTier == 'premium'
            ? (_selectedPeriod == 'yearly' ? '\$79.99' : '\$9.99')
            : (_selectedPeriod == 'yearly' ? '\$39.99' : '\$4.99'),
      ),
    );

    return PlanCard(
      plan: selectedPlan,
      isSelected: true,
      onTap: () {},
    );
  }

  Widget _buildFeaturesComparison() {
    final isPremiumSelected = _selectedTier == 'premium';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s included',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow('Daily personalized guidance', true),
          _buildFeatureRow('6 life areas covered', true),
          _buildFeatureRow('Daily focus tracking', true),
          _buildFeatureRow(
            'AI-powered personalization',
            isPremiumSelected,
            isPremium: true,
          ),
          _buildFeatureRow(
            'Audio narration',
            isPremiumSelected,
            isPremium: true,
          ),
          _buildFeatureRow(
            'Priority support',
            isPremiumSelected,
            isPremium: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, bool included, {bool isPremium = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle : Icons.cancel,
            color: included ? AppColors.success : AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                color: included ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ),
          if (isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton(IapService iapService) {
    final isLoading = iapService.purchaseInProgress || iapService.isLoading;
    final plans = iapService.plans;
    final selectedPlan = plans.firstWhere(
      (p) => p.tier == _selectedTier && p.period == _selectedPeriod,
      orElse: () => SubscriptionPlan(
        productId: '',
        tier: _selectedTier,
        period: _selectedPeriod,
        price: '',
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || selectedPlan.productDetails == null
            ? null
            : () => _handlePurchase(iapService, selectedPlan),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.accent,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Subscribe for ${selectedPlan.price}${selectedPlan.periodDisplay}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRestoreButton(IapService iapService) {
    return TextButton(
      onPressed: iapService.isLoading ? null : () => iapService.restorePurchases(),
      child: const Text(
        'Restore Purchases',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildLegalLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // Open Terms of Service
          },
          child: const Text(
            'Terms of Service',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
        const Text('•', style: TextStyle(color: AppColors.textMuted)),
        TextButton(
          onPressed: () {
            // Open Privacy Policy
          },
          child: const Text(
            'Privacy Policy',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePurchase(IapService iapService, SubscriptionPlan plan) async {
    final success = await iapService.purchase(plan);
    
    if (success && mounted) {
      // Navigate to home after successful purchase
      context.go('/home');
    } else if (iapService.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(iapService.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

