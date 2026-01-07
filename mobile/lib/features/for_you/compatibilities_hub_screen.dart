import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';

// Service type enum matching backend
enum OneTimeServiceType {
  personalityReport,
  romanticPersonalityReport,
  friendshipReport,
  loveCompatibilityReport,
  romanticForecastCoupleReport,
}

// Service catalog entry
class ServiceEntry {
  final OneTimeServiceType type;
  final String apiType;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool requiresPartner;
  final int priceUsdCents;
  final bool comingSoon; // NEW: Mark services as coming soon
  final bool hidden; // NEW: Hide services from UI but keep in backend

  const ServiceEntry({
    required this.type,
    required this.apiType,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requiresPartner,
    required this.priceUsdCents,
    this.comingSoon = false,
    this.hidden = false,
  });
}

// Local service catalog for UI - ordered as specified
const List<ServiceEntry> compatibilityServices = [
  // 1. Personality Report - active
  ServiceEntry(
    type: OneTimeServiceType.personalityReport,
    apiType: 'PERSONALITY_REPORT',
    title: 'Personality Report',
    description: 'Comprehensive analysis of your personality based on your natal chart',
    icon: Icons.person_rounded,
    color: Color(0xFF9C27B0),
    requiresPartner: false,
    priceUsdCents: 499,
  ),
  // 2. Romantic Personality Report - active
  ServiceEntry(
    type: OneTimeServiceType.romanticPersonalityReport,
    apiType: 'ROMANTIC_PERSONALITY_REPORT',
    title: 'Romantic Personality Report',
    description: 'Understand how you approach love and romance',
    icon: Icons.spa_rounded,
    color: Color(0xFFFF5722),
    requiresPartner: false,
    priceUsdCents: 499,
  ),
  // 3. Love Compatibility Report - Coming Soon
  ServiceEntry(
    type: OneTimeServiceType.loveCompatibilityReport,
    apiType: 'LOVE_COMPATIBILITY_REPORT',
    title: 'Love Compatibility',
    description: 'Detailed romantic compatibility analysis with your partner',
    icon: Icons.favorite_rounded,
    color: Color(0xFFE91E63),
    requiresPartner: true,
    priceUsdCents: 699,
    comingSoon: true, // Show "Coming Soon" instead of price
  ),
  // 4. Romantic Couple Forecast - HIDDEN (exists in backend, not shown in UI)
  ServiceEntry(
    type: OneTimeServiceType.romanticForecastCoupleReport,
    apiType: 'ROMANTIC_FORECAST_COUPLE_REPORT',
    title: 'Romantic Couple Forecast',
    description: 'Insights into the future of your relationship',
    icon: Icons.calendar_month_rounded,
    color: Color(0xFF2196F3),
    requiresPartner: true,
    priceUsdCents: 899,
    hidden: true, // Not displayed in UI
  ),
  // 5. Friendship Report - HIDDEN (exists in backend, not shown in UI)
  ServiceEntry(
    type: OneTimeServiceType.friendshipReport,
    apiType: 'FRIENDSHIP_REPORT',
    title: 'Friendship Report',
    description: 'Analyze friendship dynamics and compatibility',
    icon: Icons.handshake_rounded,
    color: Color(0xFF4CAF50),
    requiresPartner: true,
    priceUsdCents: 699,
    hidden: true, // Not displayed in UI
  ),
];

// Provider for catalog data from backend
final compatibilityCatalogProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/for-you/catalog');
  return response.data;
});

class CompatibilitiesHubScreen extends ConsumerWidget {
  const CompatibilitiesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(compatibilityCatalogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibilities'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: catalogAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, ref, error),
            data: (catalogData) => _buildServiceList(context, catalogData),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(compatibilityCatalogProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(BuildContext context, Map<String, dynamic> catalogData) {
    final bool betaFree = catalogData['betaFree'] ?? false;
    final List<dynamic> backendServices = catalogData['services'] ?? [];

    // Create a map of backend services for lookup
    final Map<String, dynamic> backendMap = {};
    for (final svc in backendServices) {
      backendMap[svc['serviceType']] = svc;
    }

    // Filter out hidden services
    final visibleServices = compatibilityServices.where((s) => !s.hidden).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Beta badge
          if (betaFree)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Beta: All reports are FREE!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const Text(
            'Choose a Report',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover insights about yourself and your relationships',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Service cards (only visible services)
          ...visibleServices.map((service) {
            final backendSvc = backendMap[service.apiType];
            final isUnlocked = betaFree || (backendSvc?['isUnlocked'] ?? false);
            final priceUsd = backendSvc?['priceUsd'] ?? service.priceUsdCents;

            return _buildServiceCard(
              context,
              service: service,
              priceUsd: priceUsd,
              isUnlocked: isUnlocked,
              betaFree: betaFree,
            );
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required ServiceEntry service,
    required int priceUsd,
    required bool isUnlocked,
    required bool betaFree,
  }) {
    final priceDisplay = '\$${(priceUsd / 100).toStringAsFixed(2)}';
    final isComingSoon = service.comingSoon;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isComingSoon
              ? null // Disable tap for coming soon services
              : () {
                  context.push(
                    '/service-offer',
                    extra: {
                      'serviceType': service.apiType,
                      'title': service.title,
                      'description': service.description,
                      'priceUsd': priceUsd,
                      'requiresPartner': service.requiresPartner,
                      'isUnlocked': isUnlocked,
                      'betaFree': betaFree,
                    },
                  );
                },
          borderRadius: BorderRadius.circular(20),
          child: Opacity(
            opacity: isComingSoon ? 0.7 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: service.color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          service.color.withOpacity(0.3),
                          service.color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(service.icon, color: service.color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                service.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (service.requiresPartner && !isComingSoon) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '+Partner',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Price or Coming Soon
                        Row(
                          children: [
                            if (isComingSoon) ...[
                              // Coming Soon badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ] else if (betaFree) ...[
                              Text(
                                priceDisplay,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'FREE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Text(
                                isUnlocked ? 'Unlocked' : priceDisplay,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isUnlocked
                                      ? Colors.green
                                      : AppColors.accent,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow (not shown for coming soon)
                  if (!isComingSoon)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

