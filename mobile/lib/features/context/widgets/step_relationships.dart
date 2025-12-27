import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A1: Relationship Status
          _buildSectionTitle('Current relationship status'),
          const SizedBox(height: 12),
          _buildRelationshipOptions(),

          const SizedBox(height: 24),

          // A2: Seeking relationship (conditional)
          if (answers.shouldShowSeekingRelationship) ...[
            _buildSectionTitle('Are you looking for a relationship?'),
            const SizedBox(height: 12),
            _buildYesNoToggle(
              value: answers.seekingRelationship,
              onChanged: (value) {
                onUpdate(answers.copyWith(seekingRelationship: value));
              },
            ),
            const SizedBox(height: 24),
          ],

          // A3: Children
          _buildSectionTitle('Do you have children?'),
          const SizedBox(height: 12),
          _buildYesNoToggle(
            value: answers.hasChildren,
            onChanged: (value) {
              onUpdate(answers.copyWith(
                hasChildren: value,
                children: value ? answers.children : [],
              ));
            },
          ),

          // Children list (conditional)
          if (answers.hasChildren) ...[
            const SizedBox(height: 16),
            _buildChildrenList(),
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
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRelationshipOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: RelationshipStatus.values.map((status) {
        final isSelected = answers.relationshipStatus == status;
        return ChoiceChip(
          label: Text(status.label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onUpdate(answers.copyWith(
                relationshipStatus: status,
                // Clear seeking relationship if not applicable
                seekingRelationship: answers.shouldShowSeekingRelationship
                    ? answers.seekingRelationship
                    : null,
              ));
            }
          },
          selectedColor: AppColors.accent.withOpacity(0.2),
          backgroundColor: AppColors.surface,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.accent : AppColors.surfaceLight,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYesNoToggle({
    required bool? value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            label: 'Yes',
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleButton(
            label: 'No',
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
          color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Children details (optional)',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        
        // List of children
        ...answers.children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return _buildChildCard(child, index);
        }),

        // Add child button
        if (answers.children.length < 10)
          TextButton.icon(
            onPressed: () {
              final newChildren = List<ChildInfo>.from(answers.children)
                ..add(ChildInfo(age: 0, gender: ChildGender.preferNotToSay));
              onUpdate(answers.copyWith(children: newChildren));
            },
            icon: const Icon(Icons.add_circle_outline, color: AppColors.accent),
            label: const Text('Add child'),
          ),
      ],
    );
  }

  Widget _buildChildCard(ChildInfo child, int index) {
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
                const Text(
                  'Age',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<int>(
                  value: child.age,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: List.generate(31, (i) => i)
                      .map((age) => DropdownMenuItem(
                            value: age,
                            child: Text('$age ${age == 1 ? 'year' : 'years'}'),
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
                const Text(
                  'Gender',
                  style: TextStyle(
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
                            child: Text(g.label),
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
}

