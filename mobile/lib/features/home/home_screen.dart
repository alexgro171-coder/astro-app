import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/zodiac_utils.dart';
import '../../core/widgets/universe_loading_overlay.dart';
import '../../core/services/jobs_service.dart';
import '../shell/main_shell.dart';
import '../context/services/context_service.dart';
import '../context/widgets/context_review_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, dynamic>? _guidance;
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  bool _isGenerating = false; // For async job generation
  String? _progressHint;
  String? _error;
  bool _isDailySummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    // Set navigation index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentNavIndexProvider.notifier).state = 0;
      // Check for 90-day context review
      _checkContextReview();
    });
    _loadData();
  }

  /// Check if user needs to review their personal context (90-day check)
  Future<void> _checkContextReview() async {
    try {
      final status = await ref.read(contextStatusProvider.future);
      
      if (status.hasProfile && status.needsReview && mounted) {
        // Show review modal
        final wantsToUpdate = await ContextReviewModal.show(context);
        
        if (wantsToUpdate == true && mounted) {
          // Navigate to context wizard for editing
          final profileResponse = await ref.read(contextServiceProvider).getProfile();
          if (profileResponse.profile != null && mounted) {
            context.push('/context-wizard', extra: {
              'isOnboarding': false,
              'existingAnswers': profileResponse.profile!.answers,
            });
          }
        }
      }
    } catch (e) {
      // Silently fail - don't block the main app flow
      debugPrint('Error checking context review: $e');
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Load user profile first
      final profileResponse = await apiClient.getProfile();
      setState(() {
        _user = profileResponse.data;
      });

      // Try to get existing guidance first (fast path)
      final guidanceResponse = await apiClient.getTodayGuidance();
      final guidanceData = guidanceResponse.data;
      
      // Check if guidance is still generating
      if (guidanceData['status'] == 'PENDING') {
        // Start async job and show loading overlay
        await _startGuidanceJob();
      } else {
        setState(() {
          _guidance = guidanceData;
          _isLoading = false;
          _isGenerating = false;
        });
      }
    } catch (e) {
      debugPrint('HomeScreen error: $e');
      // On error, try starting a job
      await _startGuidanceJob();
    }
  }

  /// Start async job for guidance generation with polling.
  Future<void> _startGuidanceJob() async {
    setState(() {
      _isLoading = false;
      _isGenerating = true;
      _progressHint = "Reading the stars and asking the Universe about you…";
    });

    try {
      final jobsService = ref.read(jobsServiceProvider);
      
      // Start the job
      final startResponse = await jobsService.startJob(jobType: JobType.dailyGuidance);
      
      // If already ready, fetch guidance directly
      if (startResponse.isSuccess) {
        await _fetchGuidance();
        return;
      }
      
      // Poll for completion
      await _pollForCompletion(startResponse.jobId);
    } catch (e) {
      debugPrint('Error starting guidance job: $e');
      setState(() {
        _isGenerating = false;
        _error = 'Failed to generate guidance. Please try again.';
      });
    }
  }

  /// Poll job status until complete.
  Future<void> _pollForCompletion(String jobId) async {
    final jobsService = ref.read(jobsServiceProvider);
    const pollInterval = Duration(milliseconds: 2500);
    const maxPolls = 36; // ~90 seconds
    int pollCount = 0;

    while (pollCount < maxPolls && mounted) {
      await Future.delayed(pollInterval);
      pollCount++;

      try {
        final status = await jobsService.getJobStatus(jobId);
        
        if (mounted) {
          setState(() {
            _progressHint = status.progressHint ?? _progressHint;
          });
        }

        if (status.isSuccess) {
          await _fetchGuidance();
          return;
        } else if (status.isFailed) {
          if (mounted) {
            setState(() {
              _isGenerating = false;
              _error = status.errorMsg ?? 'Generation failed. Please try again.';
            });
          }
          return;
        }
      } catch (e) {
        debugPrint('Error polling job status: $e');
        // Continue polling on network errors
      }
    }

    // Timeout - but job may still complete in background
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _error = 'Taking longer than expected. Tap Retry or check back in a moment.';
      });
    }
  }

  /// Fetch the guidance data after job completes.
  Future<void> _fetchGuidance() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final guidanceResponse = await apiClient.getTodayGuidance();

      if (mounted) {
        setState(() {
          _guidance = guidanceResponse.data;
          _isGenerating = false;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      debugPrint('Error fetching guidance: $e');
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _error = 'Failed to load guidance';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea only on top (status bar/notch), bottom is handled by MainShell's bottomNavigationBar
    return SafeArea(
      bottom: false, // Don't apply SafeArea to bottom - Scaffold handles it
      child: Stack(
        children: [
          // Main content
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.accent))
          else if (_error != null && _guidance == null)
            _buildErrorState()
          else
            _buildContent(),
          
          // Universe loading overlay for async generation
          if (_isGenerating)
            UniverseLoadingOverlay(
              progressHint: _progressHint,
              onCancel: () {
                // User can leave and come back - job continues in background
                setState(() {
                  _isGenerating = false;
                });
              },
            ),
        ],
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
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final sections = _guidance?['sections'] as Map<String, dynamic>?;
    final dailySummary = _guidance?['dailySummary'] as Map<String, dynamic>?;
    
    // Get sun sign from user's natal chart
    final sunSign = _user?['natalChart']?['sunSign'] as String?;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.accent,
      child: CustomScrollView(
        slivers: [
          // Header with zodiac
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(sunSign),
                  
                  const SizedBox(height: 24),
                  
                  // Daily Summary Card
                  if (dailySummary != null)
                    _buildDailySummaryCard(dailySummary),
                  
                  const SizedBox(height: 16),
                  
                  // Active concern card
                  if (_guidance?['activeConcern'] != null)
                    _buildActiveConcernCard(),
                ],
              ),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Guidance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_guidance != null && _guidance!['id'] != null) {
                        context.push('/guidance/${_guidance!['id']}');
                      }
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Grid of guidance cards
          if (sections != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildListDelegate([
                  _buildGridCard(
                    icon: Icons.favorite_rounded,
                    title: 'Health',
                    score: sections['health']?['score'] ?? 5,
                    color: const Color(0xFFE53935),
                    sectionKey: 'health',
                  ),
                  _buildGridCard(
                    icon: Icons.work_rounded,
                    title: 'Career',
                    score: sections['job']?['score'] ?? 5,
                    color: const Color(0xFF1E88E5),
                    sectionKey: 'job',
                  ),
                  _buildGridCard(
                    icon: Icons.attach_money_rounded,
                    title: 'Money',
                    score: sections['business_money']?['score'] ?? 5,
                    color: const Color(0xFF43A047),
                    sectionKey: 'business_money',
                  ),
                  _buildGridCard(
                    icon: Icons.favorite_border_rounded,
                    title: 'Love',
                    score: sections['love']?['score'] ?? 5,
                    color: const Color(0xFFE91E63),
                    sectionKey: 'love',
                  ),
                  _buildGridCard(
                    icon: Icons.handshake_rounded,
                    title: 'Partners',
                    score: sections['partnerships']?['score'] ?? 5,
                    color: const Color(0xFFFF9800),
                    sectionKey: 'partnerships',
                  ),
                  _buildGridCard(
                    icon: Icons.self_improvement_rounded,
                    title: 'Growth',
                    score: sections['personal_growth']?['score'] ?? 5,
                    color: const Color(0xFF9C27B0),
                    sectionKey: 'personal_growth',
                  ),
                ]),
              ),
            ),

          // My Natal Chart button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildNatalChartButton(),
            ),
          ),

          // Add padding at bottom to account for bottom navigation bar
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String? sunSign) {
    final zodiac = ZodiacUtils.getZodiacData(sunSign);
    final firstName = _user?['name']?.split(' ').first ?? 'Traveler';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $firstName',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (zodiac != null) ...[
                    Text(
                      zodiac.symbol,
                      style: TextStyle(
                        fontSize: 16,
                        color: zodiac.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      zodiac.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: zodiac.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                  Text(
                    _getFormattedDate(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Animated zodiac symbol
        if (zodiac != null)
          AnimatedZodiacSymbol(
            signName: sunSign,
            size: 56,
          ),
      ],
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required int score,
    required Color color,
    required String sectionKey,
  }) {
    return InkWell(
      onTap: () {
        if (_guidance != null && _guidance!['id'] != null) {
          context.push('/guidance/${_guidance!['id']}');
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with glow
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            
            const Spacer(),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Score bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 10,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveConcernCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withOpacity(0.15),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Focus',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _guidance!['activeConcern']['text'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummaryCard(Map<String, dynamic> summary) {
    final mood = summary['mood'] as String? ?? 'Balanced';
    final focusArea = summary['focusArea'] as String? ?? 'Personal Growth';
    final content = summary['content'] as String? ?? '';

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
            AppColors.surface.withOpacity(0.9),
            moodColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: moodColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: moodColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: moodColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getMoodIcon(mood),
                      size: 16,
                      color: moodColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mood,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: moodColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.gps_fixed,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                focusArea,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 20,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              const Text(
                'Your Daily Message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content - expandable
          AnimatedCrossFade(
            firstChild: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState: _isDailySummaryExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          
          const SizedBox(height: 12),
          
          // View more / View less button
          InkWell(
            onTap: () {
              setState(() {
                _isDailySummaryExpanded = !_isDailySummaryExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isDailySummaryExpanded ? 'View less' : 'View more',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: moodColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _isDailySummaryExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: moodColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'transformative':
        return Icons.change_circle;
      case 'dynamic':
        return Icons.flash_on;
      case 'harmonious':
        return Icons.balance;
      case 'reflective':
        return Icons.self_improvement;
      case 'challenging':
        return Icons.fitness_center;
      case 'energetic':
        return Icons.bolt;
      case 'peaceful':
        return Icons.spa;
      case 'creative':
        return Icons.palette;
      case 'focused':
        return Icons.center_focus_strong;
      default:
        return Icons.stars;
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  Widget _buildNatalChartButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/natal-chart'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF9C27B0).withOpacity(0.2),
                const Color(0xFFE91E63).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF9C27B0).withOpacity(0.3),
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
                      const Color(0xFF9C27B0).withOpacity(0.4),
                      const Color(0xFFE91E63).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Natal Chart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Explore your birth chart & interpretations',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
