import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/universe_loading_overlay.dart';
import '../../core/services/jobs_service.dart';

class ServiceOfferScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> serviceData;

  const ServiceOfferScreen({super.key, required this.serviceData});

  @override
  ConsumerState<ServiceOfferScreen> createState() => _ServiceOfferScreenState();
}

class _ServiceOfferScreenState extends ConsumerState<ServiceOfferScreen> {
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _progressHint;
  String? _error;
  String? _usedLocale; // Track the locale used for generation

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String get serviceType => widget.serviceData['serviceType'] as String;
  String get title => widget.serviceData['title'] as String;
  String get description => widget.serviceData['description'] as String;
  int get priceUsd => widget.serviceData['priceUsd'] as int;
  bool get requiresPartner => widget.serviceData['requiresPartner'] as bool;
  bool get isUnlocked => widget.serviceData['isUnlocked'] as bool;
  bool get betaFree => widget.serviceData['betaFree'] as bool;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final priceDisplay = '\$${(priceUsd / 100).toStringAsFixed(2)}';

    return Scaffold(
      appBar: _isGenerating ? null : AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent.withOpacity(0.3),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/InnerLogo_transp.png',
                    width: 64,
                    height: 64,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (requiresPartner) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.serviceOfferRequiresPartner,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Price section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (betaFree) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              priceDisplay,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.commonFree,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.serviceOfferBetaFree,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        Text(
                          isUnlocked ? l10n.serviceOfferUnlocked : priceDisplay,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.green : AppColors.accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Error message
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // CTA Button - simplified, no duplicate price
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onGeneratePressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: betaFree || isUnlocked
                          ? AppColors.accent
                          : AppColors.accent,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            betaFree || isUnlocked
                                ? l10n.serviceOfferGenerate
                                : l10n.serviceOfferUnlockFor(priceDisplay),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
          // Universe loading overlay for async generation
          if (_isGenerating)
            UniverseLoadingOverlay(
              onCancel: () {
                // User can leave - job continues in background
                setState(() => _isGenerating = false);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _onGeneratePressed() async {
    if (requiresPartner) {
      // Navigate to partner input screen
      final partnerData = await context.push<Map<String, dynamic>>(
        '/partner-input',
        extra: {'title': title},
      );

      if (partnerData == null) {
        return; // User cancelled
      }

      await _generateReport(partnerData: partnerData);
    } else {
      await _generateReport();
    }
  }

  Future<void> _generateReport({Map<String, dynamic>? partnerData}) async {
    setState(() {
      _isLoading = false;
      _isGenerating = true;
      _error = null;
      _progressHint = l10n.serviceOfferPreparing;
    });

    try {
      final jobsService = ref.read(jobsServiceProvider);
      final apiClient = ref.read(apiClientProvider);
      
      // Get user's language for locale-consistent requests
      String userLocale = 'en';
      try {
        final meResponse = await apiClient.get('/me');
        userLocale = (meResponse.data['language'] as String?)?.toLowerCase() ?? 'en';
      } catch (_) {
        // Fallback to device locale
        userLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      }
      _usedLocale = userLocale;
      
      // Start the job with payload and explicit locale
      final startResponse = await jobsService.startJob(
        jobType: JobType.oneTimeReport,
        locale: userLocale,
        payload: {
          'serviceType': serviceType,
          if (partnerData != null) 'partnerProfile': partnerData,
        },
      );

      // If already ready, fetch and show
      if (startResponse.isSuccess) {
        await _fetchAndShowReport();
        return;
      }

      // Poll for completion
      await _pollForCompletion(startResponse.jobId, partnerData);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _pollForCompletion(String jobId, Map<String, dynamic>? partnerData) async {
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
          // For Love Compatibility, content is in resultRef (not stored in DB)
          if (serviceType == 'LOVE_COMPATIBILITY_REPORT' && 
              status.resultRef != null && 
              status.resultRef!['content'] != null) {
            if (mounted) {
              setState(() => _isGenerating = false);
              context.pushReplacement(
                '/service-result',
                extra: {
                  'title': title,
                  'content': status.resultRef!['content'],
                  'serviceType': serviceType,
                },
              );
            }
            return;
          }
          await _fetchAndShowReport();
          return;
        } else if (status.isFailed) {
          if (mounted) {
            setState(() {
              _isGenerating = false;
              _error = status.errorMsg ?? 'Generation failed';
            });
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
      setState(() {
        _isGenerating = false;
        _error = l10n.serviceOfferTimeout;
      });
    }
  }

  Future<void> _fetchAndShowReport() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use the same locale that was used for generation
      final locale = _usedLocale ?? 'en';
      final response = await apiClient.get('/for-you/reports/$serviceType?locale=$locale');

      if (!mounted) return;

      final status = response.data['status'];
      
      if (status == 'READY') {
        context.pushReplacement(
          '/service-result',
          extra: {
            'title': title,
            'content': response.data['content'],
            'serviceType': serviceType,
          },
        );
      } else {
        setState(() {
          _isGenerating = false;
          _error = l10n.serviceOfferNotReady;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _error = l10n.serviceOfferFetchFailed(e.toString());
      });
    }
  }
}

