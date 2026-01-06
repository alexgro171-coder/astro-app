import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';

class ServiceOfferScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> serviceData;

  const ServiceOfferScreen({super.key, required this.serviceData});

  @override
  ConsumerState<ServiceOfferScreen> createState() => _ServiceOfferScreenState();
}

class _ServiceOfferScreenState extends ConsumerState<ServiceOfferScreen> {
  bool _isLoading = false;
  String? _error;

  String get serviceType => widget.serviceData['serviceType'] as String;
  String get title => widget.serviceData['title'] as String;
  String get description => widget.serviceData['description'] as String;
  int get priceUsd => widget.serviceData['priceUsd'] as int;
  bool get requiresPartner => widget.serviceData['requiresPartner'] as bool;
  bool get isUnlocked => widget.serviceData['isUnlocked'] as bool;
  bool get betaFree => widget.serviceData['betaFree'] as bool;

  @override
  Widget build(BuildContext context) {
    final priceDisplay = '\$${(priceUsd / 100).toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
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
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.accent,
                    size: 48,
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Requires partner birth data',
                          style: TextStyle(
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
                              child: const Text(
                                'FREE',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Beta testers get free access!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        Text(
                          isUnlocked ? 'Unlocked' : priceDisplay,
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

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onGeneratePressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: betaFree || isUnlocked
                          ? Colors.green
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
                            betaFree
                                ? '$priceDisplay – Beta Testers FREE'
                                : isUnlocked
                                    ? 'Generate Report'
                                    : 'Unlock for $priceDisplay',
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
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      
      final response = await apiClient.dio.post(
        '/for-you/reports/$serviceType/generate',
        data: {
          if (partnerData != null) 'partnerProfile': partnerData,
        },
      );

      if (!mounted) return;

      final status = response.data['status'];
      
      if (status == 'READY') {
        // Navigate to result screen
        context.pushReplacement(
          '/service-result',
          extra: {
            'title': title,
            'content': response.data['content'],
            'serviceType': serviceType,
          },
        );
      } else if (status == 'FAILED') {
        setState(() {
          _error = response.data['errorMsg'] ?? 'Generation failed';
        });
      } else if (status == 'PENDING') {
        setState(() {
          _error = 'Report is being generated. Please try again in a moment.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

