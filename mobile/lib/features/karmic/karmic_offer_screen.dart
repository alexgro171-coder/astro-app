import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/universe_loading_overlay.dart';
import '../../core/services/jobs_service.dart';
import 'services/karmic_service.dart';

class KarmicOfferScreen extends ConsumerStatefulWidget {
  const KarmicOfferScreen({super.key});

  @override
  ConsumerState<KarmicOfferScreen> createState() => _KarmicOfferScreenState();
}

class _KarmicOfferScreenState extends ConsumerState<KarmicOfferScreen> {
  bool _isGenerating = false;
  String? _progressHint;

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(karmicStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _isGenerating ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          statusAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to load: $err',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(karmicStatusProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (status) {
          // If reading is already ready, navigate to result
          if (status.isReady) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacement('/karmic-result');
            });
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF7C4DFF).withOpacity(0.3),
                        const Color(0xFF9C27B0).withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  '🔮 Karmic Astrology – Messages of the Soul',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7C4DFF).withOpacity(0.2),
                    ),
                  ),
                  child: const Text(
                    'Karmic Astrology reveals the deep patterns shaping your life, beyond everyday events.\n\n'
                    'It offers an interpretation that speaks about unresolved lessons, karmic connections, and the soul\'s path of growth.\n\n'
                    'This is not about what comes next,\nbut about why you are experiencing what you experience.\n\n'
                    '✨ Activate Karmic Astrology and discover the deeper meaning of your journey.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // Price info
                if (status.betaFree)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.celebration_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Beta Testers – FREE Access!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : () => _handleActivate(status),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isGenerating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            status.betaFree
                                ? '\$${status.priceUsd} – Beta Testers Free'
                                : 'Unlock for \$${status.priceUsd}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Hint text
                Text(
                  status.betaFree
                      ? 'Your reading will be generated instantly'
                      : 'One-time purchase, no subscription',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
          // Universe loading overlay for async generation
          if (_isGenerating)
            UniverseLoadingOverlay(
              progressHint: _progressHint ?? "Exploring your soul's journey…\nYour karmic reading is being prepared.",
              onCancel: () {
                // User can leave - job continues in background
                setState(() => _isGenerating = false);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _handleActivate(KarmicStatus status) async {
    if (status.betaFree || status.isUnlocked) {
      // Use job system for generation
      setState(() {
        _isGenerating = true;
        _progressHint = "Connecting to your karmic path…";
      });

      try {
        final jobsService = ref.read(jobsServiceProvider);
        
        // Start the job
        final startResponse = await jobsService.startJob(
          jobType: JobType.karmicAstrology,
        );

        // If already ready, navigate directly
        if (startResponse.isSuccess) {
          ref.invalidate(karmicStatusProvider);
          if (mounted) {
            context.pushReplacement('/karmic-result');
          }
          return;
        }

        // Poll for completion
        await _pollForCompletion(startResponse.jobId);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Navigate to checkout (placeholder for now)
      context.push('/placeholder', extra: {
        'title': 'Karmic Astrology Checkout',
        'subtitle': 'Purchase flow coming soon',
        'icon': Icons.shopping_cart_rounded,
      });
    }
  }

  Future<void> _pollForCompletion(String jobId) async {
    final jobsService = ref.read(jobsServiceProvider);
    const pollInterval = Duration(milliseconds: 2500);
    const maxPolls = 36; // ~90 seconds

    for (int i = 0; i < maxPolls && mounted; i++) {
      await Future.delayed(pollInterval);

      try {
        final status = await jobsService.getJobStatus(jobId);

        if (mounted) {
          setState(() {
            _progressHint = status.progressHint ?? _progressHint;
          });
        }

        if (status.isSuccess) {
          ref.invalidate(karmicStatusProvider);
          if (mounted) {
            context.pushReplacement('/karmic-result');
          }
          return;
        } else if (status.isFailed) {
          if (mounted) {
            setState(() => _isGenerating = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Generation failed: ${status.errorMsg ?? "Unknown error"}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      } catch (e) {
        debugPrint('Error polling job status: $e');
        // Continue polling on network errors
      }
    }

    // Timeout
    if (mounted) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Taking longer than expected. Please try again.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

