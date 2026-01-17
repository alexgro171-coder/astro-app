import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../screens/context_wizard_screen.dart';
import 'package:astro_app/l10n/app_localizations.dart';

/// Step 1: Relationships & Family
class StepRelationships extends StatelessWidget {
  final ContextAnswers answers;
  final Function(ContextAnswers) onUpdate;

  const StepRelationships({
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
          // A1: Relationship Status
          _buildSectionTitle(l10n.contextRelationshipStatusTitle),
          const SizedBox(height: 12),
          _buildRelationshipOptions(l10n),

          const SizedBox(height: 24),

          // A2: Seeking relationship (conditional)
          if (answers.shouldShowSeekingRelationship) ...[
            _buildSectionTitle(l10n.contextSeekingRelationshipTitle),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              value: answers.seekingRelationship,
              onChanged: (value) {
                onUpdate(answers.copyWith(seekingRelationship: value));
              },
              l10n: l10n,
            ),
            const SizedBox(height: 24),
          ],

          // A3: Children
          _buildSectionTitle(l10n.contextHasChildrenTitle),
          const SizedBox(height: 12),
          _buildYesNoToggle(
            value: answers.hasChildren,
            onChanged: (value) {
              onUpdate(answers.copyWith(
                hasChildren: value,
                children: value ? answers.children : [],
              ));
            },
            l10n: l10n,
          ),

          // Children list (conditional)
          if (answers.hasChildren) ...[
            const SizedBox(height: 16),
          _buildChildrenList(context),
          ],

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

  Widget _buildRelationshipOptions(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: RelationshipStatus.values.map((status) {
        final isSelected = answers.relationshipStatus == status;
        return GestureDetector(
          onTap: () {
            onUpdate(answers.copyWith(
              relationshipStatus: status,
              // Clear seeking relationship if not applicable
              seekingRelationship: answers.shouldShowSeekingRelationship
                  ? answers.seekingRelationship
                  : null,
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? ContextColors.gold : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? ContextColors.gold : AppColors.surfaceLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Text(
                  _relationshipLabel(status, l10n),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYesNoToggle({
    required bool? value,
    required Function(bool) onChanged,
    required AppLocalizations l10n,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            label: l10n.commonYes,
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleButton(
            label: l10n.commonNo,
            isSelected: value == false,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? ContextColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ContextColors.gold : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.contextChildrenDetailsOptional,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        
        // List of children
        ...answers.children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return _buildChildCard(context, child, index);
        }),

        // Add child button
        if (answers.children.length < 10)
          TextButton.icon(
            onPressed: () {
              final newChildren = List<ChildInfo>.from(answers.children)
                ..add(ChildInfo(age: 0, gender: ChildGender.preferNotToSay));
              onUpdate(answers.copyWith(children: newChildren));
            },
            icon: Icon(Icons.add_circle_outline, color: ContextColors.gold),
            label: Text(l10n.contextAddChild, style: TextStyle(color: ContextColors.gold)),
          ),
      ],
    );
  }

  Widget _buildChildCard(BuildContext context, ChildInfo child, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          // Age
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.contextChildAgeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<int>(
                  value: child.age,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: List.generate(51, (i) => i)
                      .map((age) => DropdownMenuItem(
                            value: age,
                            child: Text(
                              AppLocalizations.of(context)!.contextChildAgeYears(age),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final newChildren = List<ChildInfo>.from(answers.children);
                      newChildren[index] = ChildInfo(
                        age: value,
                        gender: child.gender,
                      );
                      onUpdate(answers.copyWith(children: newChildren));
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Gender
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.contextChildGenderLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<ChildGender>(
                  value: child.gender,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ChildGender.values
                      .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(_childGenderLabel(g, AppLocalizations.of(context)!)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final newChildren = List<ChildInfo>.from(answers.children);
                      newChildren[index] = ChildInfo(
                        age: child.age,
                        gender: value,
                      );
                      onUpdate(answers.copyWith(children: newChildren));
                    }
                  },
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
            onPressed: () {
              final newChildren = List<ChildInfo>.from(answers.children)
                ..removeAt(index);
              onUpdate(answers.copyWith(children: newChildren));
            },
          ),
        ],
      ),
    );
  }

  String _relationshipLabel(RelationshipStatus status, AppLocalizations l10n) {
    switch (status) {
      case RelationshipStatus.single:
        return l10n.contextRelationshipSingle;
      case RelationshipStatus.inRelationship:
        return l10n.contextRelationshipInRelationship;
      case RelationshipStatus.married:
        return l10n.contextRelationshipMarried;
      case RelationshipStatus.separated:
        return l10n.contextRelationshipSeparated;
      case RelationshipStatus.widowed:
        return l10n.contextRelationshipWidowed;
      case RelationshipStatus.preferNotToSay:
        return l10n.contextRelationshipPreferNotToSay;
    }
  }

  String _childGenderLabel(ChildGender gender, AppLocalizations l10n) {
    switch (gender) {
      case ChildGender.male:
        return l10n.genderMale;
      case ChildGender.female:
        return l10n.genderFemale;
      case ChildGender.preferNotToSay:
        return l10n.genderPreferNotToSay;
    }
  }
}

