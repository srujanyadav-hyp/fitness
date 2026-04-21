import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'profile_components.dart';

class CustomerProfileSection extends StatelessWidget {
  const CustomerProfileSection({
    super.key,
    required this.fitnessGoal,
    required this.fitnessLevel,
    required this.workoutTime,
    required this.monthlyBudget,
    required this.interests,
    required this.onGoalChanged,
    required this.onLevelChanged,
    required this.onTimeChanged,
    required this.onBudgetChanged,
    required this.onInterestToggled,
  });

  final String fitnessGoal;
  final String fitnessLevel;
  final String workoutTime;
  final String monthlyBudget;
  final Set<String> interests;

  final ValueChanged<String> onGoalChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onTimeChanged;
  final ValueChanged<String> onBudgetChanged;
  final ValueChanged<String> onInterestToggled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(
          icon: Icons.monitor_heart_outlined,
          title: 'Fitness Goals',
          subtitle: 'Tell us what drives you.',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChipGroupLabel(label: 'MAIN GOAL'),
              const SizedBox(height: 12),
              ChipSelector(
                options: const ['Weight Loss', 'Build Muscle', 'Endurance', 'Flexibility'],
                selected: fitnessGoal,
                onSelect: onGoalChanged,
              ),
              const SizedBox(height: 20),
              const ChipGroupLabel(label: 'FITNESS LEVEL'),
              const SizedBox(height: 12),
              ChipSelector(
                options: const ['Beginner', 'Intermediate', 'Advanced'],
                selected: fitnessLevel,
                onSelect: onLevelChanged,
              ),
              const SizedBox(height: 20),
              const ChipGroupLabel(label: 'BEST WORKOUT TIME'),
              const SizedBox(height: 12),
              ChipSelectorWithIcons(
                options: const [
                  ('Morning', Icons.wb_twilight_rounded),
                  ('Afternoon', Icons.light_mode_rounded),
                  ('Evening', Icons.dark_mode_rounded),
                ],
                selected: workoutTime,
                onSelect: onTimeChanged,
              ),
              const SizedBox(height: 20),
              const ChipGroupLabel(label: 'MONTHLY BUDGET (₹)'),
              const SizedBox(height: 12),
              ChipSelector(
                options: const ['< ₹500', '₹500–1500', '₹1500–3000', '₹3000+'],
                selected: monthlyBudget,
                onSelect: onBudgetChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const SectionLabel(
          icon: Icons.favorite_outline_rounded,
          title: 'Interests',
          subtitle: 'Pick everything that excites you.',
          accentColor: AppColors.tertiary,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.tertiary,
          child: MultiChipSelectorWithIcons(
            options: const [
              ('Yoga', Icons.self_improvement_rounded),
              ('Weightlifting', Icons.fitness_center_rounded),
              ('CrossFit', Icons.directions_run_rounded),
              ('Swimming', Icons.pool_rounded),
              ('Boxing', Icons.sports_mma_rounded),
              ('Cycling', Icons.pedal_bike_rounded),
              ('HIIT', Icons.flash_on_rounded),
              ('Nutrition', Icons.restaurant_outlined),
            ],
            selectedSet: interests,
            onToggle: onInterestToggled,
          ),
        ),
      ],
    );
  }
}
