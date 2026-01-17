import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../screens/context_wizard_screen.dart';
import 'package:astro_app/l10n/app_localizations.dart';

/// Step 4: Priorities & Tone
class StepPriorities extends StatelessWidget {
  final ContextAnswers answers;
  final Function(ContextAnswers) onUpdate;

  const StepPriorities({
    super.key,
    required this.answers,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // D1: Priorities (max 2)
          _buildSectionTitle(l10n.contextPrioritiesTitle),
          const SizedBox(height: 4),
          Text(
            l10n.contextPrioritiesSubtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          _buildPrioritiesGrid(l10n),

          const SizedBox(height: 32),

          // D2: Guidance Style
          _buildSectionTitle(l10n.contextGuidanceStyleTitle),
          const SizedBox(height: 12),
          _buildStyleOptions(l10n),

          const SizedBox(height: 32),

          // D3: Sensitivity Mode
          _buildSensitivityToggle(l10n),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPrioritiesGrid(AppLocalizations l10n) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: Priority.values.map((priority) {
        final isSelected = answers.priorities.contains(priority);
        final canSelect = answers.priorities.length < 2 || isSelected;

        return _buildPriorityChip(
          priority: priority,
          isSelected: isSelected,
          enabled: canSelect,
          l10n: l10n,
          onTap: () {
            List<Priority> newPriorities;
            if (isSelected) {
              newPriorities = answers.priorities.where((p) => p != priority).toList();
            } else if (answers.priorities.length < 2) {
              newPriorities = [...answers.priorities, priority];
            } else {
              return; // Can't select more than 2
            }
            onUpdate(answers.copyWith(priorities: newPriorities));
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriorityChip({
    required Priority priority,
    required bool isSelected,
    required bool enabled,
    required AppLocalizations l10n,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? ContextColors.gold
              : enabled
                  ? AppColors.surface
                  : AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ContextColors.gold : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              priority.emoji,
              style: TextStyle(
                fontSize: 18,
                color: enabled ? null : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _priorityLabel(priority, l10n),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : enabled
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStyleOptions(AppLocalizations l10n) {
    return Column(
      children: GuidanceStyle.values.map((style) {
        final isSelected = answers.guidanceStyle == style;

        return InkWell(
          onTap: () => onUpdate(answers.copyWith(guidanceStyle: style)),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? ContextColors.gold
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? ContextColors.gold : AppColors.surfaceLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _guidanceStyleLabel(style, l10n),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _guidanceStyleDescription(style, l10n),
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSensitivityToggle(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: ContextColors.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.contextSensitivityTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.contextSensitivitySubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: answers.sensitivityMode,
            onChanged: (value) {
              onUpdate(answers.copyWith(sensitivityMode: value));
            },
            activeColor: ContextColors.gold,
          ),
        ],
      ),
    );
  }

  String _priorityLabel(Priority priority, AppLocalizations l10n) {
    switch (priority) {
      case Priority.healthHabits:
        return l10n.contextPriorityHealth;
      case Priority.careerGrowth:
        return l10n.contextPriorityCareer;
      case Priority.businessDecisions:
        return l10n.contextPriorityBusiness;
      case Priority.moneyStability:
        return l10n.contextPriorityMoney;
      case Priority.loveRelationship:
        return l10n.contextPriorityLove;
      case Priority.familyParenting:
        return l10n.contextPriorityFamily;
      case Priority.socialLife:
        return l10n.contextPrioritySocial;
      case Priority.personalGrowth:
        return l10n.contextPriorityGrowth;
    }
  }

  String _guidanceStyleLabel(GuidanceStyle style, AppLocalizations l10n) {
    switch (style) {
      case GuidanceStyle.direct:
        return l10n.contextGuidanceStyleDirect;
      case GuidanceStyle.empathetic:
        return l10n.contextGuidanceStyleEmpathetic;
      case GuidanceStyle.balanced:
        return l10n.contextGuidanceStyleBalanced;
    }
  }

  String _guidanceStyleDescription(GuidanceStyle style, AppLocalizations l10n) {
    switch (style) {
      case GuidanceStyle.direct:
        return l10n.contextGuidanceStyleDirectDesc;
      case GuidanceStyle.empathetic:
        return l10n.contextGuidanceStyleEmpatheticDesc;
      case GuidanceStyle.balanced:
        return l10n.contextGuidanceStyleBalancedDesc;
    }
  }
}

