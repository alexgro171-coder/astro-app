import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/entitlements_service.dart';

/// Trial Banner Widget
/// 
/// Displays trial status and days remaining.
/// Shows on home screen during trial period.
class TrialBanner extends ConsumerWidget {
  const TrialBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entitlements = ref.watch(entitlementsProvider);

    // Don't show if not in trial
    if (!entitlements.trialActive) return const SizedBox.shrink();

    final daysRemaining = entitlements.trialDaysRemaining ?? 0;
    final isLastDay = daysRemaining <= 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLastDay
              ? [AppColors.error.withOpacity(0.2), AppColors.error.withOpacity(0.1)]
              : [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLastDay
              ? AppColors.error.withOpacity(0.3)
              : AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/paywall'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isLastDay
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isLastDay ? Icons.warning_amber : Icons.star,
                    color: isLastDay ? AppColors.error : AppColors.accent,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLastDay
                            ? 'Last day of trial!'
                            : 'Premium Trial',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isLastDay
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLastDay
                            ? 'Subscribe to keep your access'
                            : '$daysRemaining ${daysRemaining == 1 ? "day" : "days"} remaining',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // CTA button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isLastDay ? AppColors.error : AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Choose Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Trial Badge
/// 
/// Smaller version for use in app bar or other compact spaces.
class TrialBadge extends ConsumerWidget {
  const TrialBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementsProvider);

    if (!entitlements.trialActive) return const SizedBox.shrink();

    final daysRemaining = entitlements.trialDaysRemaining ?? 0;
    final isLastDay = daysRemaining <= 1;

    return GestureDetector(
      onTap: () => context.push('/paywall'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isLastDay
              ? AppColors.error
              : AppColors.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLastDay ? Icons.warning : Icons.star,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              isLastDay ? 'Last day!' : 'Trial: $daysRemaining days',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium Feature Lock
/// 
/// Shows when user tries to access premium feature without subscription.
class PremiumFeatureLock extends StatelessWidget {
  final String featureName;
  final VoidCallback? onUpgrade;

  const PremiumFeatureLock({
    super.key,
    required this.featureName,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline,
              size: 32,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.billingFeatureLocked(featureName),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.billingUpgradeBody,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onUpgrade ?? () => context.push('/paywall'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 18),
                const SizedBox(width: 8),
                Text(l10n.billingUpgrade),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

