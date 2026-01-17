import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../services/context_service.dart';

/// Modal shown when user's context profile is due for review (90 days)
/// 
/// Shows: "Has anything important changed in your life recently?"
/// Options:
/// - Yes → Navigate to context wizard for editing
/// - No → Defer review by 90 more days
class ContextReviewModal extends ConsumerStatefulWidget {
  const ContextReviewModal({super.key});

  @override
  ConsumerState<ContextReviewModal> createState() => _ContextReviewModalState();

  /// Show the modal and return true if user selected "Yes" (wants to update)
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ContextReviewModal(),
    );
  }
}

class _ContextReviewModalState extends ConsumerState<ContextReviewModal> {
  bool _isLoading = false;

  Future<void> _handleYes() async {
    Navigator.of(context).pop(true);
  }

  Future<void> _handleNo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(contextServiceProvider).deferReview();
      // Refresh status
      ref.invalidate(contextStatusProvider);
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.contextReviewFailed),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.update_rounded,
                  color: AppColors.accent,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                l10n.contextReviewTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                l10n.contextReviewBody,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                l10n.contextReviewHint,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  // No, nothing changed
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleNo,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.surfaceLight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.contextReviewNoChanges,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Yes, update
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleYes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.contextReviewYesUpdate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

