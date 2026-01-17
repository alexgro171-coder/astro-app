import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../screens/context_wizard_screen.dart';
import 'package:astro_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // B1: Work Status
          _buildSectionTitle(l10n.contextProfessionalStatusTitle),
          const SizedBox(height: 12),
          _buildWorkStatusDropdown(l10n),

          // Other work status text field
          if (answers.workStatus == WorkStatus.other) ...[
            const SizedBox(height: 12),
            _buildTextField(
              hint: l10n.contextProfessionalStatusOtherHint,
              value: answers.workStatusOther ?? '',
              onChanged: (value) {
                onUpdate(answers.copyWith(workStatusOther: value));
              },
            ),
          ],

          const SizedBox(height: 24),

          // B2: Industry (optional)
          _buildSectionTitle(l10n.contextIndustryTitle),
          const SizedBox(height: 4),
          Text(
            l10n.commonOptional,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          _buildIndustryGrid(l10n),

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

  Widget _buildWorkStatusDropdown(AppLocalizations l10n) {
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
                    _workStatusLabel(status, l10n),
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

  Widget _buildIndustryGrid(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // "None selected" option
        _buildIndustryChip(null, l10n.commonNotSpecified),
        // Industry options
        ...Industry.values.map((industry) {
          return _buildIndustryChip(industry, _industryLabel(industry, l10n));
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

  String _workStatusLabel(WorkStatus status, AppLocalizations l10n) {
    switch (status) {
      case WorkStatus.student:
        return l10n.contextWorkStatusStudent;
      case WorkStatus.unemployed:
        return l10n.contextWorkStatusUnemployed;
      case WorkStatus.employedIc:
        return l10n.contextWorkStatusEmployedIc;
      case WorkStatus.employedManagement:
        return l10n.contextWorkStatusEmployedManagement;
      case WorkStatus.executive:
        return l10n.contextWorkStatusExecutive;
      case WorkStatus.selfEmployed:
        return l10n.contextWorkStatusSelfEmployed;
      case WorkStatus.entrepreneur:
        return l10n.contextWorkStatusEntrepreneur;
      case WorkStatus.investor:
        return l10n.contextWorkStatusInvestor;
      case WorkStatus.retired:
        return l10n.contextWorkStatusRetired;
      case WorkStatus.homemaker:
        return l10n.contextWorkStatusHomemaker;
      case WorkStatus.careerBreak:
        return l10n.contextWorkStatusCareerBreak;
      case WorkStatus.other:
        return l10n.contextWorkStatusOther;
    }
  }

  String _industryLabel(Industry industry, AppLocalizations l10n) {
    switch (industry) {
      case Industry.techIt:
        return l10n.contextIndustryTech;
      case Industry.finance:
        return l10n.contextIndustryFinance;
      case Industry.healthcare:
        return l10n.contextIndustryHealthcare;
      case Industry.education:
        return l10n.contextIndustryEducation;
      case Industry.salesMarketing:
        return l10n.contextIndustrySalesMarketing;
      case Industry.realEstate:
        return l10n.contextIndustryRealEstate;
      case Industry.hospitality:
        return l10n.contextIndustryHospitality;
      case Industry.government:
        return l10n.contextIndustryGovernment;
      case Industry.creative:
        return l10n.contextIndustryCreative;
      case Industry.other:
        return l10n.contextIndustryOther;
    }
  }
}

