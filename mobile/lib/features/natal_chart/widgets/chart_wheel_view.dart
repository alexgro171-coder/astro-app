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
          // Hint text
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap to view fullscreen • Pinch to zoom',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          // Chart wheel container with zoom
          wheelSvgAsync.when(
            data: (svg) => svg != null
                ? _buildInteractiveChart(context, svg)
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

  Widget _buildInteractiveChart(BuildContext context, String svgString) {
    return GestureDetector(
      onTap: () => _openFullscreenChart(context, svgString),
      child: Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: SvgPicture.string(
                svgString,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullscreenChart(BuildContext context, String svgString) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenChartView(
          svgString: svgString,
          placements: placements,
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
    return GestureDetector(
      onTap: () => _openFullscreenFallback(context),
      child: Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: CustomPaint(
                painter: _SimpleChartWheelPainter(placements),
                child: Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullscreenFallback(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenChartView(
          svgString: null,
          placements: placements,
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

/// Fullscreen chart view with enhanced zoom capabilities
class _FullscreenChartView extends StatefulWidget {
  final String? svgString;
  final NatalPlacements placements;

  const _FullscreenChartView({
    required this.svgString,
    required this.placements,
  });

  @override
  State<_FullscreenChartView> createState() => _FullscreenChartViewState();
}

class _FullscreenChartViewState extends State<_FullscreenChartView> {
  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {
      _currentScale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Natal Chart',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _resetZoom,
            tooltip: 'Reset zoom',
          ),
        ],
      ),
      body: Column(
        children: [
          // Zoom indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.zoom_in_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'Zoom: ${(_currentScale * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Pinch to zoom • Drag to pan',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          // Chart
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 5.0,
              boundaryMargin: const EdgeInsets.all(100),
              onInteractionUpdate: (details) {
                setState(() {
                  _currentScale = _transformationController.value.getMaxScaleOnAxis();
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: widget.svgString != null
                      ? SvgPicture.string(
                          widget.svgString!,
                          fit: BoxFit.contain,
                        )
                      : CustomPaint(
                          size: const Size(400, 400),
                          painter: _SimpleChartWheelPainter(widget.placements),
                        ),
                ),
              ),
            ),
          ),
          
          // Bottom controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildZoomButton(
                    icon: Icons.zoom_out_rounded,
                    label: 'Zoom Out',
                    onTap: () {
                      final currentScale = _transformationController.value.getMaxScaleOnAxis();
                      final newScale = (currentScale - 0.5).clamp(0.5, 5.0);
                      _transformationController.value = Matrix4.identity()..scale(newScale);
                      setState(() {
                        _currentScale = newScale;
                      });
                    },
                  ),
                  _buildZoomButton(
                    icon: Icons.fit_screen_rounded,
                    label: 'Fit',
                    onTap: _resetZoom,
                  ),
                  _buildZoomButton(
                    icon: Icons.zoom_in_rounded,
                    label: 'Zoom In',
                    onTap: () {
                      final currentScale = _transformationController.value.getMaxScaleOnAxis();
                      final newScale = (currentScale + 0.5).clamp(0.5, 5.0);
                      _transformationController.value = Matrix4.identity()..scale(newScale);
                      setState(() {
                        _currentScale = newScale;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
