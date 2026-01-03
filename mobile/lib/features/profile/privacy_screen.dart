import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const String _privacyUrl = 'https://innerwisdomapp.com/privacy';

  Future<void> _openInBrowser(BuildContext context) async {
    final uri = Uri.parse(_privacyUrl);
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
                        'Privacy Policy',
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
                          'Inner Wisdom Privacy Policy',
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

                        _SectionTitle('1. Information We Collect'),
                        _SectionContent(
                          'We collect information you provide directly:\n'
                          '• Account information (email, name)\n'
                          '• Birth data (date, time, location)\n'
                          '• Personal context (optional lifestyle information)\n'
                          '• Usage data and preferences',
                        ),

                        _SectionTitle('2. How We Use Your Information'),
                        _SectionContent(
                          'Your information is used to:\n'
                          '• Generate personalized astrological readings\n'
                          '• Improve and customize your experience\n'
                          '• Send notifications (with your consent)\n'
                          '• Process payments and subscriptions\n'
                          '• Analyze usage patterns to improve the App',
                        ),

                        _SectionTitle('3. Data Security'),
                        _SectionContent(
                          'We implement industry-standard security measures including:\n'
                          '• Encryption of sensitive data in transit and at rest\n'
                          '• Secure authentication systems\n'
                          '• Regular security audits\n'
                          '• Access controls for our team members',
                        ),

                        _SectionTitle('4. Data Sharing'),
                        _SectionContent(
                          'We do not sell your personal data. We only share data:\n'
                          '• With service providers who help operate the App\n'
                          '• When required by law\n'
                          '• To protect our rights or safety',
                        ),

                        _SectionTitle('5. Your Rights (GDPR/CCPA)'),
                        _SectionContent(
                          'You have the right to:\n'
                          '• Access your personal data\n'
                          '• Correct inaccurate data\n'
                          '• Delete your account and data\n'
                          '• Export your data\n'
                          '• Opt out of marketing communications',
                        ),

                        _SectionTitle('6. Data Retention'),
                        _SectionContent(
                          'We retain your data as long as your account is active. When you delete your account, all personal data is permanently removed within 30 days.',
                        ),

                        _SectionTitle('7. Cookies and Analytics'),
                        _SectionContent(
                          'We use analytics to understand how users interact with the App. This data is aggregated and does not identify individual users.',
                        ),

                        _SectionTitle('8. Children\'s Privacy'),
                        _SectionContent(
                          'Inner Wisdom is not intended for children under 13. We do not knowingly collect information from children.',
                        ),

                        _SectionTitle('9. International Users'),
                        _SectionContent(
                          'Data may be processed in countries other than your own. We ensure appropriate safeguards are in place for international data transfers.',
                        ),

                        _SectionTitle('10. Contact Us'),
                        _SectionContent(
                          'For privacy-related questions or to exercise your rights:\n\n'
                          'Email: privacy@innerwisdomapp.com\n'
                          'Address: Inner Wisdom Ltd.\n'
                          'Data Protection Officer: dpo@innerwisdomapp.com',
                        ),

                        _SectionTitle('11. Changes to This Policy'),
                        _SectionContent(
                          'We may update this policy periodically. We will notify you of significant changes through the App or by email.',
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

