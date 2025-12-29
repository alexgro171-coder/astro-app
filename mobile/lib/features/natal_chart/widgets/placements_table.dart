import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../models/natal_placement.dart';
import '../services/natal_chart_service.dart';

class PlacementsTableView extends ConsumerWidget {
  final NatalChartData chartData;

  const PlacementsTableView({super.key, required this.chartData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planetsByHouse = chartData.placements.planetsByHouse;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          _buildSummaryCard(),
          const SizedBox(height: 24),

          // Placements grouped by house
          const Text(
            'Placements by House',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // House groups
          ...planetsByHouse.entries.map((entry) => _buildHouseGroup(
                context,
                ref,
                entry.key,
                entry.value,
              )),

          // Interpretations section
          const SizedBox(height: 32),
          const Text(
            'Interpretations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Planet interpretations
          ...chartData.placements.planets.map((planet) => _buildInterpretationCard(
                context,
                ref,
                planet,
                chartData.freeInterpretations,
              )),

          // Pro upsell
          const SizedBox(height: 32),
          if (!chartData.hasProAccess) _buildProUpsell(context),

          // Bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final placements = chartData.placements;
    final sun = placements.planets.firstWhere(
      (p) => p.planet == 'Sun',
      orElse: () => placements.planets.first,
    );
    final moon = placements.planets.firstWhere(
      (p) => p.planet == 'Moon',
      orElse: () => placements.planets.first,
    );
    final asc = placements.houses?.firstWhere(
      (h) => h.house == 1,
      orElse: () => placements.houses!.first,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withOpacity(0.2),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.accent, size: 24),
              SizedBox(width: 8),
              Text(
                'Your Big Three',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBigThreeItem('☉ Sun', sun.sign),
              _buildBigThreeItem('☽ Moon', moon.sign),
              if (asc != null) _buildBigThreeItem('↑ Rising', asc.sign),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBigThreeItem(String label, String sign) {
    final zodiac = ZodiacInfo.signs[sign];
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            zodiac?.symbol ?? '',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sign,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseGroup(
    BuildContext context,
    WidgetRef ref,
    int house,
    List<PlanetPlacement> planets,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceLight.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    house.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'House $house',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                _getHouseTheme(house),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...planets.map((planet) => _buildPlanetRow(planet)),
        ],
      ),
    );
  }

  Widget _buildPlanetRow(PlanetPlacement planet) {
    final planetInfo = PlanetInfo.planets[planet.planet];
    final zodiac = ZodiacInfo.signs[planet.sign];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            planetInfo?.symbol ?? '●',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Text(
            planet.planet,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'in',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            zodiac?.symbol ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(
            planet.sign,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (planet.isRetrograde == true) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'R',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterpretationCard(
    BuildContext context,
    WidgetRef ref,
    PlanetPlacement planet,
    List<NatalInterpretation> interpretations,
  ) {
    final interpretation = interpretations.firstWhere(
      (i) => i.planetKey.toLowerCase() == planet.planet.toLowerCase(),
      orElse: () => NatalInterpretation(
        id: '',
        planetKey: planet.planet,
        sign: planet.sign,
        house: planet.house,
        text: '',
        isPro: false,
        createdAt: DateTime.now(),
      ),
    );

    final planetInfo = PlanetInfo.planets[planet.planet];
    final zodiac = ZodiacInfo.signs[planet.sign];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceLight.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(
                              planetInfo?.color.replaceFirst('#', '0xFF') ??
                                  '0xFF9C27B0'))
                          .withOpacity(0.3),
                      Color(int.parse(
                              planetInfo?.color.replaceFirst('#', '0xFF') ??
                                  '0xFF9C27B0'))
                          .withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    planetInfo?.symbol ?? '●',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planet.fullTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${zodiac?.element ?? ''} Sign',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (interpretation.text.isEmpty)
            _buildLoadingInterpretation(ref, planet.planet)
          else
            Text(
              interpretation.text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingInterpretation(WidgetRef ref, String planetKey) {
    final interpretationAsync = ref.watch(interpretationProvider(planetKey));

    return interpretationAsync.when(
      data: (interpretation) {
        if (interpretation == null) {
          return const Text(
            'Generating interpretation...',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          );
        }
        return Text(
          interpretation.text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        );
      },
      loading: () => Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Generating interpretation...',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
      error: (_, __) => const Text(
        'Unable to load interpretation',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildProUpsell(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9C27B0).withOpacity(0.3),
            const Color(0xFFE91E63).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9C27B0).withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 48,
            color: Color(0xFFFFD700),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pro Natal Chart Interpretation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get detailed 150-200 word interpretations for each planet with personalized life guidance.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/pro-natal-offer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Get Pro Interpretation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '\$9.99',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getHouseTheme(int house) {
    const themes = {
      1: 'Self & Identity',
      2: 'Money & Values',
      3: 'Communication',
      4: 'Home & Family',
      5: 'Creativity & Romance',
      6: 'Health & Routine',
      7: 'Relationships',
      8: 'Transformation',
      9: 'Philosophy & Travel',
      10: 'Career & Status',
      11: 'Friends & Goals',
      12: 'Spirituality',
    };
    return themes[house] ?? '';
  }
}

