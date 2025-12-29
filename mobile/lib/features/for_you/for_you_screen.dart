import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Header
            const Text(
              'For You',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Personalized cosmic insights',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 32),

            // Menu items
            _buildMenuItem(
              icon: Icons.stars_rounded,
              title: 'My Natal Chart',
              subtitle: 'Your birth chart analysis',
              color: const Color(0xFF9C27B0),
              onTap: () => context.push('/natal-chart'),
            ),
            
            _buildMenuItem(
              icon: Icons.favorite_rounded,
              title: 'Romantic Compatibilities',
              subtitle: 'Love & relationship synastry',
              color: const Color(0xFFE91E63),
              onTap: () => context.push('/placeholder', extra: {
                'title': 'Romantic Compatibilities',
                'subtitle': 'Coming soon - Discover your love compatibility',
                'icon': Icons.favorite_rounded,
              }),
            ),
            
            _buildMenuItem(
              icon: Icons.handshake_rounded,
              title: 'Partnership Compatibilities',
              subtitle: 'Business & friendship synastry',
              color: const Color(0xFFFF9800),
              onTap: () => context.push('/placeholder', extra: {
                'title': 'Partnership Compatibilities',
                'subtitle': 'Coming soon - Find your ideal partners',
                'icon': Icons.handshake_rounded,
              }),
            ),
            
            _buildMenuItem(
              icon: Icons.calendar_month_rounded,
              title: '12 Months Ahead',
              subtitle: 'Your yearly forecast',
              color: const Color(0xFF2196F3),
              onTap: () => context.push('/placeholder', extra: {
                'title': '12 Months Ahead',
                'subtitle': 'Coming soon - Annual cosmic forecast',
                'icon': Icons.calendar_month_rounded,
              }),
            ),
            
            _buildMenuItem(
              icon: Icons.school_rounded,
              title: 'Learn Astrology',
              subtitle: 'Free educational content',
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
                              child: const Text(
                                'FREE',
                                style: TextStyle(
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

