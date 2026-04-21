import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lexend(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Atmospheric Card — glassmorphic container with ambient glow
// ─────────────────────────────────────────────────────────────────────────────
class AtmosphericCard extends StatelessWidget {
  const AtmosphericCard({super.key, required this.child, required this.glowColor});
  final Widget child;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.06),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40, right: -40,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor.withValues(alpha: 0.05),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kinetic Input
// ─────────────────────────────────────────────────────────────────────────────
class KineticInput extends StatefulWidget {
  const KineticInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.ctrl,
    this.onChanged,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.words,
  });
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController ctrl;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  State<KineticInput> createState() => _KineticInputState();
}

class _KineticInputState extends State<KineticInput> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (mounted) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutQuart,
      decoration: BoxDecoration(
        color: _focused ? AppColors.surfaceBright : AppColors.surfaceVariant.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _focused
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.outlineVariant.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: _focused
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 16)]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                size: 13,
                color: _focused ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: _focused ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          TextField(
            controller: widget.ctrl,
            focusNode: _focus,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textCapitalization: widget.textCapitalization,
            onChanged: widget.onChanged,
            style: GoogleFonts.lexend(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.lexend(
                color: AppColors.outline.withValues(alpha: 0.4),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 4, bottom: 2),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOB Picker
// ─────────────────────────────────────────────────────────────────────────────
class DobPicker extends StatefulWidget {
  const DobPicker({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<DobPicker> createState() => _DobPickerState();
}

class _DobPickerState extends State<DobPicker> {
  String? _dob;

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surfaceContainerHigh,
            onSurface: AppColors.onSurface,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.surfaceContainerHigh,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted = '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() => _dob = formatted);
      widget.onChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cake_outlined, size: 13, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                const SizedBox(width: 6),
                Text(
                  'DATE OF BIRTH',
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _dob ?? 'DD/MM/YYYY',
              style: GoogleFonts.lexend(
                color: _dob != null ? AppColors.onSurface : AppColors.outline.withValues(alpha: 0.4),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dropdown Field
// ─────────────────────────────────────────────────────────────────────────────
class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wc_rounded, size: 13, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select',
                style: GoogleFonts.lexend(
                  color: AppColors.outline.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
              dropdownColor: AppColors.surfaceContainerHigh,
              isExpanded: true,
              icon: Icon(Icons.expand_more_rounded, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4), size: 18),
              style: GoogleFonts.lexend(color: AppColors.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
              items: options.map((o) => DropdownMenuItem(
                value: o,
                child: Text(o),
              )).toList(),
              onChanged: (v) { if (v != null) onChanged(v); },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single-select chip selector
// ─────────────────────────────────────────────────────────────────────────────
class ChipSelector extends StatelessWidget {
  const ChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutQuart,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : AppColors.surfaceVariant.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryContainer.withValues(alpha: 0.4)
                    : AppColors.outlineVariant.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Text(
              opt,
              style: GoogleFonts.manrope(
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single-select with icons
// ─────────────────────────────────────────────────────────────────────────────
class ChipSelectorWithIcons extends StatelessWidget {
  const ChipSelectorWithIcons({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final List<(String, IconData)> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.asMap().entries.map((entry) {
        final opt = entry.value;
        final isSelected = selected == opt.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: entry.key < options.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelect(opt.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : AppColors.surfaceVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryContainer.withValues(alpha: 0.4)
                        : AppColors.outlineVariant.withValues(alpha: 0.2),
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        opt.$2,
                        color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      opt.$1,
                      style: GoogleFonts.manrope(
                        color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Multi-select chip selector with icons
// ─────────────────────────────────────────────────────────────────────────────
class MultiChipSelectorWithIcons extends StatelessWidget {
  const MultiChipSelectorWithIcons({
    super.key,
    required this.options,
    required this.selectedSet,
    required this.onToggle,
  });
  final List<(String, IconData)> options;
  final Set<String> selectedSet;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selectedSet.contains(opt.$1);
        return GestureDetector(
          onTap: () => onToggle(opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.45)
                    : AppColors.outlineVariant.withValues(alpha: 0.2),
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 10)]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(opt.$2, size: 14, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  opt.$1,
                  style: GoogleFonts.manrope(
                    color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Multi-select plain chip
// ─────────────────────────────────────────────────────────────────────────────
class MultiChipSelector extends StatelessWidget {
  const MultiChipSelector({
    super.key,
    required this.options,
    required this.selectedSet,
    required this.onToggle,
    required this.accentColor,
  });
  final List<String> options;
  final Set<String> selectedSet;
  final ValueChanged<String> onToggle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selectedSet.contains(opt);
        return GestureDetector(
          onTap: () => onToggle(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.45)
                    : AppColors.outlineVariant.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Text(
              opt,
              style: GoogleFonts.manrope(
                color: isSelected ? accentColor : AppColors.onSurfaceVariant,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-card inside Classification card
// ─────────────────────────────────────────────────────────────────────────────
class ClassificationSubCard extends StatelessWidget {
  const ClassificationSubCard({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.child,
  });
  final IconData icon;
  final String label;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip group label helper
// ─────────────────────────────────────────────────────────────────────────────
class ChipGroupLabel extends StatelessWidget {
  const ChipGroupLabel({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transition Divider (for "both" role)
// ─────────────────────────────────────────────────────────────────────────────
class TransitionDivider extends StatelessWidget {
  const TransitionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_rounded, color: AppColors.primaryContainer, size: 14),
              const SizedBox(width: 8),
              Text(
                'NOW, YOUR GYM',
                style: GoogleFonts.lexend(
                  color: AppColors.primaryContainer,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
