import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../screens/context_wizard_screen.dart';

/// Step 2: Professional Life
class StepProfessional extends StatelessWidget {
  final ContextAnswers answers;
  final Function(ContextAnswers) onUpdate;

  const StepProfessional({
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
          // B1: Work Status
          _buildSectionTitle('Current professional status'),
          const SizedBox(height: 12),
          _buildWorkStatusDropdown(),

          // Other work status text field
          if (answers.workStatus == WorkStatus.other) ...[
            const SizedBox(height: 12),
            _buildTextField(
              hint: 'Please specify your work status',
              value: answers.workStatusOther ?? '',
              onChanged: (value) {
                onUpdate(answers.copyWith(workStatusOther: value));
              },
            ),
          ],

          const SizedBox(height: 24),

          // B2: Industry (optional)
          _buildSectionTitle('Main industry/domain'),
          const SizedBox(height: 4),
          Text(
            'Optional',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          _buildIndustryGrid(),

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

  Widget _buildWorkStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: DropdownButton<WorkStatus>(
        value: answers.workStatus,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        items: WorkStatus.values
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status.label,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onUpdate(answers.copyWith(
              workStatus: value,
              workStatusOther: value == WorkStatus.other ? answers.workStatusOther : null,
            ));
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.surfaceLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.surfaceLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }

  Widget _buildIndustryGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // "None selected" option
        _buildIndustryChip(null, 'Not specified'),
        // Industry options
        ...Industry.values.map((industry) {
          return _buildIndustryChip(industry, industry.label);
        }),
      ],
    );
  }

  Widget _buildIndustryChip(Industry? industry, String label) {
    final isSelected = answers.industry == industry;
    
    return GestureDetector(
      onTap: () {
        onUpdate(answers.copyWith(industry: industry));
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
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

