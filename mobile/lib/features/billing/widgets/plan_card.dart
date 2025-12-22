import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../iap_service.dart';

/// Plan Card Widget
/// 
/// Displays subscription plan details in a card format.
class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Plan name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: plan.isPremium 
                        ? AppColors.accent 
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (plan.isPremium)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.star, size: 14, color: Colors.white),
                        ),
                      Text(
                        plan.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: plan.isPremium 
                              ? Colors.white 
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Period badge
                if (plan.isYearly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'BEST VALUE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4),
                  child: Text(
                    plan.periodDisplay,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            
            // Yearly savings
            if (plan.isYearly) ...[
              const SizedBox(height: 8),
              Text(
                'Save 33% compared to monthly',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Features preview
            ..._buildFeaturesList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    final features = plan.isPremium
        ? [
            'Everything in Standard',
            'AI-powered personalization',
            'Audio narration (TTS)',
            'Priority support',
          ]
        : [
            'Daily guidance',
            '6 life areas',
            'Focus tracking',
          ];

    return features.map((f) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Text(
            f,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    )).toList();
  }
}

