import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';

class GuidanceDetailScreen extends ConsumerStatefulWidget {
  final String guidanceId;

  const GuidanceDetailScreen({super.key, required this.guidanceId});

  @override
  ConsumerState<GuidanceDetailScreen> createState() => _GuidanceDetailScreenState();
}

class _GuidanceDetailScreenState extends ConsumerState<GuidanceDetailScreen> {
  Map<String, dynamic>? _guidance;
  bool _isLoading = true;
  String? _error;
  String? _expandedSection;

  @override
  void initState() {
    super.initState();
    _loadGuidance();
  }

  Future<void> _loadGuidance() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use the guidanceId parameter to fetch the specific guidance
      // If guidanceId is 'today' or empty, it will fetch today's guidance
      final response = await apiClient.getGuidanceById(widget.guidanceId);
      
      setState(() {
        _guidance = response.data;
        _isLoading = false;
      });
    } catch (e) {
      print('GuidanceDetailScreen error: $e');
      setState(() {
        _error = 'Failed to load guidance';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Expanded(
                      child: Text(
                        'Daily Guidance',
                        style: TextStyle(
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.accent),
                      )
                    : _error != null
                        ? _buildErrorState()
                        : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadGuidance,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final sections = _guidance?['sections'] as Map<String, dynamic>?;
    final dailySummary = _guidance?['dailySummary'] as Map<String, dynamic>?;
    
    if (sections == null) {
      return const Center(
        child: Text(
          'No guidance available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGuidance,
      color: AppColors.accent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Summary Header
            if (dailySummary != null) ...[
              _buildSummaryHeader(dailySummary),
              const SizedBox(height: 24),
            ],

            // Section Cards
            _buildSectionCard(
              sectionKey: 'health',
              section: sections['health'],
              icon: Icons.favorite,
              color: Colors.red,
            ),
            _buildSectionCard(
              sectionKey: 'job',
              section: sections['job'],
              icon: Icons.work,
              color: Colors.blue,
            ),
            _buildSectionCard(
              sectionKey: 'business_money',
              section: sections['business_money'],
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            _buildSectionCard(
              sectionKey: 'love',
              section: sections['love'],
              icon: Icons.favorite_border,
              color: Colors.pink,
            ),
            _buildSectionCard(
              sectionKey: 'partnerships',
              section: sections['partnerships'],
              icon: Icons.handshake,
              color: Colors.orange,
            ),
            _buildSectionCard(
              sectionKey: 'personal_growth',
              section: sections['personal_growth'],
              icon: Icons.self_improvement,
              color: Colors.purple,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(Map<String, dynamic> summary) {
    final mood = summary['mood'] as String? ?? 'Balanced';
    final focusArea = summary['focusArea'] as String? ?? 'Personal Growth';

    final moodColors = {
      'Transformative': Colors.purple,
      'Dynamic': Colors.orange,
      'Harmonious': Colors.green,
      'Reflective': Colors.blue,
      'Challenging': Colors.red,
      'Balanced': AppColors.accent,
      'Energetic': Colors.amber,
      'Peaceful': Colors.teal,
      'Creative': Colors.pink,
      'Focused': Colors.indigo,
    };

    final moodColor = moodColors[mood] ?? AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            moodColor.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: moodColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: moodColor, size: 24),
              const SizedBox(width: 8),
              Text(
                "Today's Cosmic Energy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                icon: Icons.mood,
                label: 'Mood',
                value: mood,
                color: moodColor,
              ),
              _buildInfoChip(
                icon: Icons.gps_fixed,
                label: 'Focus',
                value: focusArea,
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String sectionKey,
    required Map<String, dynamic>? section,
    required IconData icon,
    required Color color,
  }) {
    if (section == null) return const SizedBox.shrink();

    final title = section['title'] as String? ?? sectionKey;
    final score = section['score'] as int? ?? 5;
    final content = section['content'] as String? ?? 'No content available';
    final isExpanded = _expandedSection == sectionKey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isExpanded 
            ? Border.all(color: color.withOpacity(0.5), width: 2)
            : null,
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedSection = isExpanded ? null : sectionKey;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withOpacity(0.2),
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
                          Text(
                            title.replaceAll(' ⭐', ''),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Score indicator
                          Row(
                            children: [
                              ...List.generate(10, (index) {
                                return Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index < score
                                        ? color
                                        : AppColors.surfaceLight,
                                    boxShadow: index < score
                                        ? [
                                            BoxShadow(
                                              color: color.withOpacity(0.4),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '$score/10',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textMuted,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                // Expanded Content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                color.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Content with styling
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: color.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 16,
                                    color: color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your Guidance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                content,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Action hint
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tap to collapse',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
