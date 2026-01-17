import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../learn/services/learn_service.dart';
import '../learn/providers/learn_session_provider.dart';

class FreeLearnScreen extends ConsumerStatefulWidget {
  const FreeLearnScreen({super.key});

  @override
  ConsumerState<FreeLearnScreen> createState() => _FreeLearnScreenState();
}

class _FreeLearnScreenState extends ConsumerState<FreeLearnScreen> {
  String _locale = 'en';

  @override
  void initState() {
    super.initState();
    _loadUserLocale();
    // Log that user opened Learn section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learnSessionProvider.notifier).logOpenedIfNeeded();
    });
  }

  Future<void> _loadUserLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(AppConstants.languageKey) ?? 'EN';
    if (mounted) {
      setState(() {
        _locale = language.toLowerCase();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = _locale;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        l10n.learnTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.learnFreeTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.learnFreeSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Learning cards grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                        children: [
                          _buildLearnCard(
                            context,
                            category: LearnCategory.signs,
                            icon: Icons.brightness_7_rounded,
                            title: l10n.learnSignsTitle,
                            subtitle: l10n.learnSignsSubtitle,
                            color: const Color(0xFFFF9800),
                            locale: locale,
                          ),
                          _buildLearnCard(
                            context,
                            category: LearnCategory.planets,
                            icon: Icons.public_rounded,
                            title: l10n.learnPlanetsTitle,
                            subtitle: l10n.learnPlanetsSubtitle,
                            color: const Color(0xFF2196F3),
                            locale: locale,
                          ),
                          _buildLearnCard(
                            context,
                            category: LearnCategory.houses,
                            icon: Icons.home_rounded,
                            title: l10n.learnHousesTitle,
                            subtitle: l10n.learnHousesSubtitle,
                            color: const Color(0xFF9C27B0),
                            locale: locale,
                          ),
                          _buildLearnCard(
                            context,
                            category: LearnCategory.transits,
                            icon: Icons.sync_alt_rounded,
                            title: l10n.learnTransitsTitle,
                            subtitle: l10n.learnTransitsSubtitle,
                            color: const Color(0xFF4CAF50),
                            locale: locale,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Info box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.learnPaceTitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    l10n.learnPaceSubtitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildLearnCard(
    BuildContext context, {
    required LearnCategory category,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String locale,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/learn/${category.name}/$locale');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

