import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import 'services/karmic_service.dart';

class KarmicResultScreen extends ConsumerStatefulWidget {
  const KarmicResultScreen({super.key});

  @override
  ConsumerState<KarmicResultScreen> createState() => _KarmicResultScreenState();
}

class _KarmicResultScreenState extends ConsumerState<KarmicResultScreen> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(karmicStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Karmic Astrology',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: statusAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.accent),
              SizedBox(height: 24),
              Text(
                'Loading your karmic reading...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        error: (err, _) => _buildErrorState(err.toString()),
        data: (status) {
          // If not unlocked, redirect to offer
          if (!status.isUnlocked) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacement('/karmic-astrology');
            });
            return const SizedBox();
          }

          // If pending, show generating state
          if (status.isPending) {
            return _buildGeneratingState();
          }

          // If failed, show error with retry
          if (status.isFailed) {
            return _buildErrorState(status.errorMsg ?? 'Generation failed');
          }

          // If none (no reading yet), trigger generation
          if (status.isNone) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _generateReading();
            });
            return _buildGeneratingState();
          }

          // READY - show content
          return _buildReadyState(status);
        },
      ),
    );
  }

  Widget _buildGeneratingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF7C4DFF).withOpacity(0.3),
                    const Color(0xFF9C27B0).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(
                'assets/images/InnerLogo_transp.png',
                width: 56,
                height: 56,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Color(0xFF7C4DFF)),
            const SizedBox(height: 24),
            const Text(
              'Generating Your Karmic Reading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Analyzing your natal chart for karmic patterns and soul lessons.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateReading,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Process karmic reading content for display
  /// - Replace "Introducere in Astrologia Karmica" with "Introducere in Astrologia ta Karmica"
  /// - Replace "#" markers with bullet points "•"
  String _processKarmicContent(String? content) {
    if (content == null || content.isEmpty) {
      return 'No content available.';
    }
    
    String processed = content;
    
    // Replace title
    processed = processed.replaceAll(
      'Introducere in Astrologia Karmica',
      'Introducere in Astrologia ta Karmica',
    );
    processed = processed.replaceAll(
      'Introducere în Astrologia Karmică',
      'Introducere în Astrologia ta Karmică',
    );
    
    // Replace # markers with bullets (handles ##, ###, etc.)
    // Replace "## " or "### " etc. at start of lines with "• "
    processed = processed.replaceAllMapped(
      RegExp(r'^#+\s*', multiLine: true),
      (match) => '• ',
    );
    
    return processed;
  }

  Widget _buildReadyState(KarmicStatus status) {
    final processedContent = _processKarmicContent(status.content);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF7C4DFF).withOpacity(0.2),
                  const Color(0xFF9C27B0).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/images/InnerLogo_transp.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔮 Your Karmic Reading',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Messages of the Soul',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.surfaceLight.withOpacity(0.5),
              ),
            ),
            child: SelectableText(
              processedContent,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This reading is for self-reflection and entertainment purposes. It does not constitute professional advice.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.shade800,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _generateReading() async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);

    try {
      final service = ref.read(karmicServiceProvider);
      await service.generateReading();
      ref.invalidate(karmicStatusProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}

