import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../shell/main_shell.dart';

class ForYouScreen extends ConsumerStatefulWidget {
  const ForYouScreen({super.key});

  @override
  ConsumerState<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends ConsumerState<ForYouScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentNavIndexProvider.notifier).state = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Header
            Text(
              l10n.forYouTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.forYouSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 32),

            // Menu items (New Order)
            // 1. My Natal Chart
            _buildMenuItem(
              icon: Icons.stars_rounded,
              title: l10n.forYouNatalChartTitle,
              subtitle: l10n.forYouNatalChartSubtitle,
              color: const Color(0xFF9C27B0),
              onTap: () => context.push('/natal-chart'),
            ),
            
            // 2. Compatibilities Hub (replaces Romantic + Partnership)
            _buildMenuItem(
              icon: Icons.favorite_rounded,
              title: l10n.forYouCompatibilitiesTitle,
              subtitle: l10n.forYouCompatibilitiesSubtitle,
              color: const Color(0xFFE91E63),
              onTap: () => context.push('/compatibilities'),
            ),
            
            // 3. Karmic Astrology
            _buildMenuItem(
              icon: Icons.auto_awesome_rounded,
              title: l10n.forYouKarmicTitle,
              subtitle: l10n.forYouKarmicSubtitle,
              color: const Color(0xFF7C4DFF),
              onTap: () => context.push('/karmic-astrology'),
            ),
            
            // Moon Phase Report - HIDDEN (kept in backend, not shown in UI)
            // _buildMenuItem(
            //   icon: Icons.nightlight_round,
            //   title: 'Moon Phase Report',
            //   subtitle: 'Current lunar energy guidance',
            //   color: const Color(0xFF3F51B5),
            //   onTap: () => context.push('/moon-phase'),
            // ),
            
            // 4. Learn Astrology
            _buildMenuItem(
              icon: Icons.school_rounded,
              title: l10n.forYouLearnTitle,
              subtitle: l10n.forYouLearnSubtitle,
              color: const Color(0xFF4CAF50),
              onTap: () => context.push('/free-learn'),
              isFree: true,
            ),

            // Bottom padding for navigation bar
            SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isFree = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.3),
                        color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isFree) ...[
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
                              child: Text(
                                AppLocalizations.of(context)!.commonFree,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
