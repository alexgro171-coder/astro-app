import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../services/context_service.dart';
import '../widgets/step_relationships.dart';
import '../widgets/step_professional.dart';
import '../widgets/step_self_assessment.dart';
import '../widgets/step_priorities.dart';

// Context wizard colors (matching onboarding)
class ContextColors {
  static const Color purple = Color(0xFF6B4B8A);
  static const Color purpleDark = Color(0xFF5A3D7A);
  static const Color purpleLight = Color(0xFF7D5C9C);
  static const Color gold = Color(0xFFC9A86C);
  static const Color goldLight = Color(0xFFD4BC8A);
}

/// Context Wizard Screen
/// 
/// A 4-step wizard for collecting personal context (V1 Questionnaire):
/// 1. Relationships & Family
/// 2. Professional Life
/// 3. Self-Assessment (Likert scales)
/// 4. Priorities & Tone
/// 
/// Used in:
/// - Onboarding (after birth data)
/// - Settings (edit existing profile)
/// - 90-day review modal
class ContextWizardScreen extends ConsumerStatefulWidget {
  /// If true, this is a new profile creation (onboarding)
  final bool isOnboarding;
  
  /// Pre-filled answers (for editing existing profile)
  final ContextAnswers? existingAnswers;

  const ContextWizardScreen({
    super.key,
    this.isOnboarding = false,
    this.existingAnswers,
  });

  @override
  ConsumerState<ContextWizardScreen> createState() => _ContextWizardScreenState();
}

class _ContextWizardScreenState extends ConsumerState<ContextWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;
  String? _error;

  late ContextAnswers _answers;

  @override
  void initState() {
    super.initState();
    _answers = widget.existingAnswers ?? ContextAnswers.empty();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
        _error = null;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
        _error = null;
      });
    }
  }

  void _updateAnswers(ContextAnswers updated) {
    setState(() {
      _answers = updated;
    });
  }

  Future<void> _submit() async {
    // Validate priorities (required, max 2)
    if (_answers.priorities.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.contextPriorityRequired;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final contextService = ref.read(contextServiceProvider);
      
      if (widget.isOnboarding || widget.existingAnswers == null) {
        // Create new profile
        await contextService.createProfile(_answers);
      } else {
        // Update existing profile
        await contextService.updateProfile(_answers);
      }

      // Refresh profile state
      ref.read(contextProfileProvider.notifier).loadProfile();

      if (mounted) {
        if (widget.isOnboarding) {
          // Go to home after onboarding
          context.go('/home');
        } else {
          // Pop back to settings
          context.pop(true);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Context save error: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _error = AppLocalizations.of(context)!.contextSaveFailed(e.toString());
        _isSubmitting = false;
      });
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: // Relationships
        return _answers.relationshipStatus != RelationshipStatus.preferNotToSay;
      case 1: // Professional
        return true; // All fields optional except workStatus which has default
      case 2: // Self-assessment
        return true; // All have defaults
      case 3: // Priorities
        return _answers.priorities.isNotEmpty && _answers.priorities.length <= 2;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepTitles = [
      l10n.contextStep1Title,
      l10n.contextStep2Title,
      l10n.contextStep3Title,
      l10n.contextStep4Title,
    ];
    final stepSubtitles = [
      l10n.contextStep1Subtitle,
      l10n.contextStep2Subtitle,
      l10n.contextStep3Subtitle,
      l10n.contextStep4Subtitle,
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ContextColors.purpleLight,
              ContextColors.purple,
              ContextColors.purpleDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    if (_currentStep > 0 || !widget.isOnboarding)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _currentStep > 0 ? _previousStep : () => context.pop(),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        l10n.contextTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (!widget.isOnboarding)
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          l10n.commonCancel,
                          style: TextStyle(color: ContextColors.goldLight),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),

              // Progress indicator
              _buildProgressIndicator(),

              // Step title and subtitle
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.contextStepOf(
                        _currentStep + 1,
                        4,
                      ),
                      style: TextStyle(
                        color: ContextColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stepTitles[_currentStep],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stepSubtitles[_currentStep],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (_error != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StepRelationships(
                      answers: _answers,
                      onUpdate: _updateAnswers,
                    ),
                    StepProfessional(
                      answers: _answers,
                      onUpdate: _updateAnswers,
                    ),
                    StepSelfAssessment(
                      answers: _answers,
                      onUpdate: _updateAnswers,
                    ),
                    StepPriorities(
                      answers: _answers,
                      onUpdate: _updateAnswers,
                    ),
                  ],
                ),
              ),

              // Navigation buttons
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? ContextColors.gold : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ContextColors.purpleDark.withOpacity(0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ContextColors.gold),
                  foregroundColor: ContextColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.commonBack),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentStep == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : (_currentStep < 3 ? (_canProceed() ? _nextStep : null) : _submit),
              style: ElevatedButton.styleFrom(
                backgroundColor: ContextColors.gold,
                disabledBackgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: ContextColors.purpleDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _currentStep < 3
                          ? l10n.commonContinue
                          : l10n.contextSaveContinue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

