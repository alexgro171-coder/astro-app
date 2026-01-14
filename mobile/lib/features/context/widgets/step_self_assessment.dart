import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/context_answers.dart';
import '../screens/context_wizard_screen.dart';

/// Step 3: Self-Assessment (Likert 1-5 scales)
class StepSelfAssessment extends StatelessWidget {
  final ContextAnswers answers;
  final Function(ContextAnswers) onUpdate;

  const StepSelfAssessment({
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
          Text(
            'Rate your current situation in each area (1 = struggling, 5 = thriving)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 24),

          // Health & Energy
          _buildLikertScale(
            title: 'Health & Energy',
            subtitle: '1 = serious issues/low energy, 5 = excellent vitality',
            icon: Icons.favorite_rounded,
            color: const Color(0xFFE53935),
            value: answers.healthScore,
            onChanged: (v) => onUpdate(answers.copyWith(healthScore: v)),
          ),
          const SizedBox(height: 20),

          // Social Life
          _buildLikertScale(
            title: 'Social Life',
            subtitle: '1 = isolated, 5 = thriving social connections',
            icon: Icons.groups_rounded,
            color: const Color(0xFF43A047),
            value: answers.socialScore,
            onChanged: (v) => onUpdate(answers.copyWith(socialScore: v)),
          ),
          const SizedBox(height: 20),

          // Romantic Life
          _buildLikertScale(
            title: 'Romantic Life',
            subtitle: '1 = absent/challenging, 5 = fulfilled',
            icon: Icons.favorite_border_rounded,
            color: const Color(0xFFE91E63),
            value: answers.romanceScore,
            onChanged: (v) => onUpdate(answers.copyWith(romanceScore: v)),
          ),
          const SizedBox(height: 20),

          // Financial Stability
          _buildLikertScale(
            title: 'Financial Stability',
            subtitle: '1 = major hardship, 5 = excellent',
            icon: Icons.attach_money_rounded,
            color: const Color(0xFF2E7D32),
            value: answers.financeScore,
            onChanged: (v) => onUpdate(answers.copyWith(financeScore: v)),
          ),
          const SizedBox(height: 20),

          // Career Satisfaction
          _buildLikertScale(
            title: 'Career Satisfaction',
            subtitle: '1 = stuck/stressed, 5 = progress/clarity',
            icon: Icons.work_rounded,
            color: const Color(0xFF1E88E5),
            value: answers.careerScore,
            onChanged: (v) => onUpdate(answers.copyWith(careerScore: v)),
          ),
          const SizedBox(height: 20),

          // Personal Growth Interest
          _buildLikertScale(
            title: 'Personal Growth Interest',
            subtitle: '1 = low interest, 5 = very high',
            icon: Icons.self_improvement_rounded,
            color: const Color(0xFF9C27B0),
            value: answers.growthScore,
            onChanged: (v) => onUpdate(answers.copyWith(growthScore: v)),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLikertScale({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int value,
    required Function(int) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Current value
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ContextColors.gold.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ContextColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Likert buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final score = index + 1;
              final isSelected = value == score;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(score),
                  child: Container(
                    margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? ContextColors.gold : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? ContextColors.gold : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          // Labels
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Struggling',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  'Thriving',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

