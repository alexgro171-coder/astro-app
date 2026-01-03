import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const String _termsUrl = 'https://innerwisdomapp.com/terms';

  Future<void> _openInBrowser(BuildContext context) async {
    final uri = Uri.parse(_termsUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch URL: $e');
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
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _openInBrowser(context),
                      icon: const Icon(Icons.open_in_new, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inner Wisdom Terms of Service',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Last updated: January 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        SizedBox(height: 24),

                        _SectionTitle('1. Acceptance of Terms'),
                        _SectionContent(
                          'By accessing and using Inner Wisdom ("the App"), you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
                        ),

                        _SectionTitle('2. Description of Service'),
                        _SectionContent(
                          'Inner Wisdom provides personalized astrological guidance and insights based on your birth chart and current planetary positions. The service is for entertainment and self-reflection purposes only.',
                        ),

                        _SectionTitle('3. User Account'),
                        _SectionContent(
                          'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must provide accurate birth information for proper service delivery.',
                        ),

                        _SectionTitle('4. Subscription and Payments'),
                        _SectionContent(
                          'Premium features require a paid subscription. Subscriptions auto-renew unless cancelled before the renewal date. Refunds are handled according to Apple App Store and Google Play Store policies.',
                        ),

                        _SectionTitle('5. Content Disclaimer'),
                        _SectionContent(
                          'Astrological readings are for entertainment purposes and should not replace professional medical, legal, financial, or psychological advice. We make no guarantees about the accuracy or applicability of any reading.',
                        ),

                        _SectionTitle('6. Intellectual Property'),
                        _SectionContent(
                          'All content, features, and functionality of the App are owned by Inner Wisdom and are protected by intellectual property laws. You may not copy, modify, or distribute our content without permission.',
                        ),

                        _SectionTitle('7. User Conduct'),
                        _SectionContent(
                          'You agree not to misuse the service, attempt to access unauthorized areas, or use the service for any illegal purpose. We reserve the right to terminate accounts that violate these terms.',
                        ),

                        _SectionTitle('8. Limitation of Liability'),
                        _SectionContent(
                          'Inner Wisdom is provided "as is" without warranties. We are not liable for any damages arising from your use of the service or reliance on astrological content.',
                        ),

                        _SectionTitle('9. Changes to Terms'),
                        _SectionContent(
                          'We may update these terms from time to time. Continued use of the App after changes constitutes acceptance of the new terms.',
                        ),

                        _SectionTitle('10. Contact'),
                        _SectionContent(
                          'For questions about these terms, contact us at legal@innerwisdomapp.com',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String text;
  const _SectionContent(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
    );
  }
}

