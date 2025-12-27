import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../services/context_service.dart';
import '../widgets/step_relationships.dart';
import '../widgets/step_professional.dart';
import '../widgets/step_self_assessment.dart';
import '../widgets/step_priorities.dart';

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

  final List<String> _stepTitles = [
    'Relationships & Family',
    'Professional Life',
    'Self-Assessment',
    'Priorities & Tone',
  ];

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
        _error = 'Please select at least one priority area.';
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
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile. Please try again.';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0 || !widget.isOnboarding
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: _currentStep > 0 ? _previousStep : () => context.pop(),
              )
            : null,
        title: Text(
          'Personal Context',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.isOnboarding)
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            // Step title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of 4',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _stepTitles[_currentStep],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
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
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 20),
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
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
              child: isCompleted
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.accent),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
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
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.surfaceLight,
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
                      _currentStep < 3 ? 'Continue' : 'Save & Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

