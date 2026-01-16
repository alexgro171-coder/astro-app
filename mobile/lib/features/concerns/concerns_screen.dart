import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../shell/main_shell.dart';

class ConcernsScreen extends ConsumerStatefulWidget {
  const ConcernsScreen({super.key});

  @override
  ConsumerState<ConcernsScreen> createState() => _ConcernsScreenState();
}

class _ConcernsScreenState extends ConsumerState<ConcernsScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  List<dynamic> _concerns = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    // Set navigation index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentNavIndexProvider.notifier).state = 2;
    });
    _loadConcerns();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadConcerns();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload concerns when screen comes back into view
    if (!_isLoading) {
      _loadConcerns();
    }
  }

  List<dynamic> get _activeConcerns => 
      _concerns.where((c) => c['status'] == 'ACTIVE').toList();
  
  List<dynamic> get _resolvedConcerns => 
      _concerns.where((c) => c['status'] == 'RESOLVED').toList();
  
  List<dynamic> get _archivedConcerns => 
      _concerns.where((c) => c['status'] == 'ARCHIVED').toList();

  Future<void> _loadConcerns() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getConcerns();
      
      // API returns { active: [...], resolved: [...], archived: [...] }
      final data = response.data;
      
      List<dynamic> allConcerns = [];
      
      if (data is Map) {
        // Merge all concerns into one list with their status
        if (data['active'] is List) {
          for (final c in data['active']) {
            if (c is Map) {
              c['status'] = 'ACTIVE';
              allConcerns.add(c);
            }
          }
        }
        if (data['resolved'] is List) {
          for (final c in data['resolved']) {
            if (c is Map) {
              c['status'] = 'RESOLVED';
              allConcerns.add(c);
            }
          }
        }
        if (data['archived'] is List) {
          for (final c in data['archived']) {
            if (c is Map) {
              c['status'] = 'ARCHIVED';
              allConcerns.add(c);
            }
          }
        }
      } else if (data is List) {
        allConcerns = data;
      }
      
      debugPrint('Concerns loaded: ${allConcerns.length} total');
      
      setState(() {
        _concerns = allConcerns;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Concerns load error: $e');
      setState(() {
        _error = 'Failed to load concerns';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.concernsTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.concernsSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Add button
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => context.push('/add-concern'),
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: l10n.concernsTabActive(_activeConcerns.length)),
                Tab(text: l10n.concernsTabResolved(_resolvedConcerns.length)),
                Tab(text: l10n.concernsTabArchived(_archivedConcerns.length)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _error != null
                    ? _buildErrorState()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildConcernsList(_activeConcerns),
                          _buildConcernsList(_resolvedConcerns),
                          _buildConcernsList(_archivedConcerns),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadConcerns,
            child: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildConcernsList(List<dynamic> concerns) {
    final l10n = AppLocalizations.of(context)!;
    if (concerns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 64,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.concernsEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.concernsEmptySubtitle,
              style: const TextStyle(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadConcerns,
      color: AppColors.accent,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: concerns.length,
        itemBuilder: (context, index) {
          final concern = concerns[index];
          return _buildConcernItem(concern);
        },
      ),
    );
  }

  Widget _buildConcernItem(Map<String, dynamic> concern) {
    final category = concern['category'] as String;
    final text = concern['textOriginal'] as String;
    final status = concern['status'] as String;
    final createdAt = DateTime.parse(concern['createdAt']);

    final categoryConfig = _getCategoryConfig(
      category,
      AppLocalizations.of(context)!,
    );
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: status == 'ACTIVE'
            ? Border.all(color: categoryConfig.color.withOpacity(0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: categoryConfig.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  categoryConfig.icon,
                  color: categoryConfig.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryConfig.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: categoryConfig.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d, yyyy', locale).format(createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (status == 'ACTIVE')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        size: 12,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.commonActive,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _CategoryConfig _getCategoryConfig(String category, AppLocalizations l10n) {
    switch (category) {
      case 'JOB':
        return _CategoryConfig(
          icon: Icons.work_rounded,
          label: l10n.concernsCategoryCareer,
          color: Colors.blue,
        );
      case 'HEALTH':
        return _CategoryConfig(
          icon: Icons.favorite_rounded,
          label: l10n.concernsCategoryHealth,
          color: Colors.red,
        );
      case 'COUPLE':
        return _CategoryConfig(
          icon: Icons.favorite_border_rounded,
          label: l10n.concernsCategoryRelationship,
          color: Colors.pink,
        );
      case 'FAMILY':
        return _CategoryConfig(
          icon: Icons.family_restroom_rounded,
          label: l10n.concernsCategoryFamily,
          color: Colors.orange,
        );
      case 'MONEY':
        return _CategoryConfig(
          icon: Icons.attach_money_rounded,
          label: l10n.concernsCategoryMoney,
          color: Colors.green,
        );
      case 'BUSINESS_DECISION':
        return _CategoryConfig(
          icon: Icons.business_center_rounded,
          label: l10n.concernsCategoryBusiness,
          color: Colors.teal,
        );
      case 'PARTNERSHIP':
        return _CategoryConfig(
          icon: Icons.handshake_rounded,
          label: l10n.concernsCategoryPartnership,
          color: Colors.amber,
        );
      case 'PERSONAL_GROWTH':
        return _CategoryConfig(
          icon: Icons.self_improvement_rounded,
          label: l10n.concernsCategoryGrowth,
          color: Colors.purple,
        );
      default:
        return _CategoryConfig(
          icon: Icons.help_outline_rounded,
          label: category,
          color: AppColors.accent,
        );
    }
  }
}

class _CategoryConfig {
  final IconData icon;
  final String label;
  final Color color;

  _CategoryConfig({
    required this.icon,
    required this.label,
    required this.color,
  });
}

