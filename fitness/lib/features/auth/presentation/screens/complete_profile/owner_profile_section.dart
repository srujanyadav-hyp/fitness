import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'profile_components.dart';

class OwnerProfileSection extends StatelessWidget {
  const OwnerProfileSection({
    super.key,
    required this.isBoth,
    required this.gymNameCtrl,
    required this.gymAddressCtrl,
    required this.pincodeCtrl,
    required this.gymCityCtrl,
    required this.estYearCtrl,
    required this.capacityCtrl,
    required this.gymPhoneCtrl,
    required this.gstCtrl,
    required this.upiCtrl,
    required this.facilityType,
    required this.specialisations,
    required this.facilities,
    required this.onFacilityTypeChanged,
    required this.onSpecialisationToggled,
    required this.onFacilityToggled,
    required this.onRebuild,
  });

  final bool isBoth;
  final TextEditingController gymNameCtrl;
  final TextEditingController gymAddressCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController gymCityCtrl;
  final TextEditingController estYearCtrl;
  final TextEditingController capacityCtrl;
  final TextEditingController gymPhoneCtrl;
  final TextEditingController gstCtrl;
  final TextEditingController upiCtrl;

  final String facilityType;
  final Set<String> specialisations;
  final Set<String> facilities;

  final ValueChanged<String> onFacilityTypeChanged;
  final ValueChanged<String> onSpecialisationToggled;
  final ValueChanged<String> onFacilityToggled;
  final VoidCallback onRebuild;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isBoth) const SizedBox(height: 32),
        const SectionLabel(
          icon: Icons.storefront_rounded,
          title: 'Gym Details',
          subtitle: 'The core identity of your facility.',
          accentColor: AppColors.primaryContainer,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.primaryContainer,
          child: Column(
            children: [
              KineticInput(
                label: 'GYM NAME',
                hint: 'e.g. Iron Forge Athletics',
                icon: Icons.storefront_rounded,
                ctrl: gymNameCtrl,
                onChanged: (_) => onRebuild(),
              ),
              const SizedBox(height: 16),
              KineticInput(
                label: 'FULL STREET ADDRESS',
                hint: 'Building, street, neighbourhood',
                icon: Icons.location_city_rounded,
                ctrl: gymAddressCtrl,
                onChanged: (_) => onRebuild(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: KineticInput(
                      label: 'PINCODE',
                      hint: '400050',
                      icon: Icons.pin_drop_outlined,
                      ctrl: pincodeCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KineticInput(
                      label: 'CITY',
                      hint: 'Mumbai',
                      icon: Icons.apartment_rounded,
                      ctrl: gymCityCtrl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: KineticInput(
                      label: 'EST. YEAR',
                      hint: '2018',
                      icon: Icons.calendar_today_outlined,
                      ctrl: estYearCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KineticInput(
                      label: 'SIZE (SQ FT)',
                      hint: '2500',
                      icon: Icons.square_foot_rounded,
                      ctrl: capacityCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              KineticInput(
                label: 'CONTACT NUMBER',
                hint: '+91 98765 43210',
                icon: Icons.phone_outlined,
                ctrl: gymPhoneCtrl,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const SectionLabel(
          icon: Icons.category_outlined,
          title: 'Classification',
          subtitle: 'Define what makes your space unique.',
          accentColor: AppColors.tertiary,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.tertiary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClassificationSubCard(
                icon: Icons.domain_outlined,
                label: 'FACILITY TYPE',
                accentColor: AppColors.primary,
                child: ChipSelector(
                  options: const ['Standalone', 'Franchise', 'Boutique Studio'],
                  selected: facilityType,
                  onSelect: onFacilityTypeChanged,
                ),
              ),
              const SizedBox(height: 16),
              ClassificationSubCard(
                icon: Icons.fitness_center_rounded,
                label: 'CORE SPECIALISATIONS',
                accentColor: AppColors.tertiary,
                child: MultiChipSelector(
                  options: const ['Weight Training', 'Personal Training', 'CrossFit', 'Yoga', 'Zumba', 'Martial Arts'],
                  selectedSet: specialisations,
                  onToggle: onSpecialisationToggled,
                  accentColor: AppColors.tertiary,
                ),
              ),
              const SizedBox(height: 16),
              ClassificationSubCard(
                icon: Icons.verified_outlined,
                label: 'AVAILABLE FACILITIES',
                accentColor: AppColors.primary,
                child: MultiChipSelector(
                  options: const ['AC', 'Parking', 'Lockers', 'Showers', 'Steam Room', 'Cafeteria', 'Pool', 'Sauna'],
                  selectedSet: facilities,
                  onToggle: onFacilityToggled,
                  accentColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const SectionLabel(
          icon: Icons.account_balance_outlined,
          title: 'Business & Payout',
          subtitle: 'Taxation and settlement details.',
          accentColor: AppColors.tertiary,
        ),
        const SizedBox(height: 16),
        AtmosphericCard(
          glowColor: AppColors.tertiary,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: AppColors.tertiary, size: 12),
                        const SizedBox(width: 5),
                        Text(
                          'SECURE DATA',
                          style: GoogleFonts.manrope(
                            color: AppColors.tertiary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              KineticInput(
                label: 'GST NUMBER (OPTIONAL)',
                hint: '22AAAAA0000A1Z5',
                icon: Icons.receipt_long_outlined,
                ctrl: gstCtrl,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              KineticInput(
                label: 'UPI ID FOR SETTLEMENTS',
                hint: 'merchantname@bank',
                icon: Icons.currency_rupee_rounded,
                ctrl: upiCtrl,
              ),
              const SizedBox(height: 8),
              Text(
                'Earnings will be transferred to this UPI ID weekly.',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
