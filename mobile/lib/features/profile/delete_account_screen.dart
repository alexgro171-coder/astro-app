import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/services/social_auth_service.dart';
import '../natal_chart/services/natal_chart_service.dart';
import '../karmic/services/karmic_service.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  bool get _canDelete => _confirmController.text.toUpperCase() == 'DELETE';

  Future<void> _deleteAccount() async {
    if (!_canDelete) {
      setState(() {
        _errorMessage = 'Please type DELETE to confirm';
      });
      return;
    }

    // Show final confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
            SizedBox(width: 12),
            Text('Final Warning', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: const Text(
          'This action cannot be undone. All your data, including:\n\n'
          '• Your profile and birth data\n'
          '• Natal chart and interpretations\n'
          '• Daily guidance history\n'
          '• Personal context and preferences\n'
          '• All purchased content\n\n'
          'Will be permanently deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.deleteAccount();

      // Clear all local data
      await apiClient.clearTokens();
      
      // Sign out from social providers
      final socialAuth = SocialAuthService();
      await socialAuth.signOut();

      // Clear cached data
      ref.invalidate(natalChartDataProvider);
      ref.invalidate(natalChartWheelProvider);
      ref.invalidate(karmicStatusProvider);

      if (!mounted) return;

      // Show success and navigate to onboarding
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account has been deleted'),
          backgroundColor: AppColors.success,
        ),
      );

      context.go('/onboarding');
    } catch (e) {
      debugPrint('Delete account error: $e');
      setState(() {
        _errorMessage = 'Failed to delete account. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                        'Delete Account',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Warning icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          size: 40,
                          color: AppColors.error,
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Delete Your Account?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: AppColors.error),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'This action is permanent and cannot be undone',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'All your personal data, including your natal chart, guidance history, and any purchases will be permanently deleted.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // What will be deleted
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'What will be deleted:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDeleteItem('Your profile and account'),
                            _buildDeleteItem('Birth data and natal chart'),
                            _buildDeleteItem('All daily guidance history'),
                            _buildDeleteItem('Personal context & preferences'),
                            _buildDeleteItem('Karmic astrology readings'),
                            _buildDeleteItem('All purchased content'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Confirmation input
                      const Text(
                        'Type DELETE to confirm',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmController,
                        textCapitalization: TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'DELETE',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Delete button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading || !_canDelete ? null : _deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _canDelete ? AppColors.error : AppColors.surface,
                            foregroundColor: AppColors.textPrimary,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.textPrimary,
                                  ),
                                )
                              : const Text('Delete My Account'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cancel button
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel, keep my account'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.close, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

