import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/universe_loading_overlay.dart';
import 'models/natal_placement.dart';
import 'services/natal_chart_service.dart';
import 'widgets/placements_table.dart';
import 'widgets/chart_wheel_view.dart';

/// View mode for the natal chart screen
enum NatalChartViewMode { table, chart }

/// Provider for the current view mode
final natalChartViewModeProvider = StateProvider<NatalChartViewMode>(
  (ref) => NatalChartViewMode.table,
);

class NatalChartScreen extends ConsumerStatefulWidget {
  const NatalChartScreen({super.key});

  @override
  ConsumerState<NatalChartScreen> createState() => _NatalChartScreenState();
}

class _NatalChartScreenState extends ConsumerState<NatalChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(natalChartViewModeProvider.notifier).state =
            _tabController.index == 0
                ? NatalChartViewMode.table
                : NatalChartViewMode.chart;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartDataAsync = ref.watch(natalChartDataProvider);
    final isGeneratingPro = ref.watch(proGeneratingProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.cosmicGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  _buildTabBar(),
                  Expanded(
                    child: chartDataAsync.when(
                      data: (data) => data != null
                          ? _buildContent(data)
                          : _buildEmptyState(),
                      loading: () => _buildLoadingState(),
                      error: (error, stack) => _buildErrorState(error.toString()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show loading overlay when generating Pro interpretations
          if (isGeneratingPro)
            const UniverseLoadingOverlay(
              showCancelAfter: false,
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              l10n.natalChartTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => ref.invalidate(natalChartDataProvider),
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.table_chart_rounded, size: 18),
                const SizedBox(width: 8),
                Text(l10n.natalChartTabTable),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.blur_circular_rounded, size: 18),
                const SizedBox(width: 8),
                Text(l10n.natalChartTabChart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(NatalChartData data) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Table View
        PlacementsTableView(chartData: data),
        // Chart View
        ChartWheelView(placements: data.placements),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const UniverseLoadingOverlay(
      showCancelAfter: false,
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stars_rounded,
              size: 64,
              color: AppColors.accent.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.natalChartEmptyTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.natalChartEmptySubtitle,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/birth-data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(l10n.natalChartAddBirthData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.natalChartErrorTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(natalChartDataProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: Text(l10n.commonTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

