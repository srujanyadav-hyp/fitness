import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'profile_components.dart';

class SharedProfileSection extends StatelessWidget {
  const SharedProfileSection({
    super.key,
    required this.isOwner,
    required this.isBoth,
    required this.nameCtrl,
    required this.cityCtrl,
    required this.selectedGender,
    required this.onDobSelected,
    required this.onGenderChanged,
    required this.onRebuild,
  });

  final bool isOwner;
  final bool isBoth;
  final TextEditingController nameCtrl;
  final TextEditingController cityCtrl;
  final String selectedGender;
  final ValueChanged<String?> onDobSelected;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onRebuild;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          icon: Icons.person_outline_rounded,
          title: 'About You',
          subtitle: isOwner && !isBoth
              ? 'The visionary behind the space.'
              : 'Build your fitness identity.',
          accentColor: AppColors.onSurface,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.primary,
          child: Column(
            children: [
              // Photo upload
              const _PhotoAvatar(),
              const SizedBox(height: 24),
              // Name
              KineticInput(
                label: 'FULL NAME',
                hint: 'e.g. Rahul Sharma',
                icon: Icons.person_outline_rounded,
                ctrl: nameCtrl,
                onChanged: (_) => onRebuild(),
              ),
              const SizedBox(height: 16),
              // DOB + Gender row
              Row(
                children: [
                  Expanded(
                    child: DobPicker(onChanged: onDobSelected),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownField(
                      label: 'GENDER',
                      options: const ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
                      value: selectedGender.isEmpty ? null : selectedGender,
                      onChanged: onGenderChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              KineticInput(
                label: 'YOUR CITY',
                hint: 'e.g. Mumbai',
                icon: Icons.location_on_outlined,
                ctrl: cityCtrl,
                onChanged: (_) => onRebuild(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoAvatar extends StatelessWidget {
  const _PhotoAvatar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              size: 40,
            ),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
