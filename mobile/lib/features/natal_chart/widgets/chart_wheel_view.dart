import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../models/natal_placement.dart';
import '../services/natal_chart_service.dart';

class ChartWheelView extends ConsumerWidget {
  final NatalPlacements placements;

  const ChartWheelView({super.key, required this.placements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wheelSvgAsync = ref.watch(natalChartWheelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Chart wheel container
          wheelSvgAsync.when(
            data: (svg) => svg != null
                ? _buildSvgWheel(svg)
                : _buildFallbackWheel(context),
            loading: () => _buildLoadingWheel(),
            error: (_, __) => _buildFallbackWheel(context),
          ),

          const SizedBox(height: 24),

          // Legend
          _buildLegend(),

          // Bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildSvgWheel(String svgString) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: SvgPicture.string(
          svgString,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLoadingWheel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: const AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.accent),
              SizedBox(height: 16),
              Text(
                'Generating chart...',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackWheel(BuildContext context) {
    // Simple fallback using CustomPaint when SVG is not available
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: _SimpleChartWheelPainter(placements),
          child: Container(),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
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
          const Text(
            'Planets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: placements.planets.map((p) {
              final info = PlanetInfo.planets[p.planet];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    info?.symbol ?? '●',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    p.planet,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Signs',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: ZodiacInfo.signs.entries.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.value.symbol,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    e.key,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Simple fallback chart painter when SVG is not available
class _SimpleChartWheelPainter extends CustomPainter {
  final NatalPlacements placements;

  _SimpleChartWheelPainter(this.placements);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 40;

    // Draw outer circle (zodiac ring)
    final outerPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerPaint);

    // Draw inner circle (houses)
    final innerPaint = Paint()
      ..color = AppColors.textMuted.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius * 0.7, innerPaint);
    canvas.drawCircle(center, radius * 0.4, innerPaint);

    // Draw zodiac divisions (12 signs)
    final divisionPaint = Paint()
      ..color = AppColors.textMuted.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (math.pi / 180);
      final start = Offset(
        center.dx + radius * 0.7 * math.cos(angle),
        center.dy + radius * 0.7 * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, divisionPaint);
    }

    // Draw zodiac symbols
    final signs = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 12; i++) {
      final angle = ((i * 30) + 15 - 90) * (math.pi / 180);
      final pos = Offset(
        center.dx + radius * 0.85 * math.cos(angle),
        center.dy + radius * 0.85 * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: signs[i],
        style: const TextStyle(fontSize: 16),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2),
      );
    }

    // Draw planets
    for (final planet in placements.planets) {
      final angle = (planet.longitude - 90) * (math.pi / 180);
      final pos = Offset(
        center.dx + radius * 0.55 * math.cos(angle),
        center.dy + radius * 0.55 * math.sin(angle),
      );

      final info = PlanetInfo.planets[planet.planet];
      textPainter.text = TextSpan(
        text: info?.symbol ?? '●',
        style: const TextStyle(fontSize: 14),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

