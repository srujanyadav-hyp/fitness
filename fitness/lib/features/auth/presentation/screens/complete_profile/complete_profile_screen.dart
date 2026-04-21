import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

import 'profile_components.dart';
import 'shared_profile_section.dart';
import 'customer_profile_section.dart';
import 'owner_profile_section.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Root screen scaffold
// ─────────────────────────────────────────────────────────────────────────────
class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({
    super.key,
    required this.phone,
    required this.name,
    required this.role,
  });

  final String phone;
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.surface,
          resizeToAvoidBottomInset: true,
          body: _ProfileBody(phone: phone, name: name, role: role),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main stateful body
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileBody extends StatefulWidget {
  const _ProfileBody({
    required this.phone,
    required this.name,
    required this.role,
  });
  final String phone;
  final String name;
  final String role;

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody>
    with TickerProviderStateMixin {
  // ── Personal controllers ──
  late final TextEditingController _nameCtrl;
  final _cityCtrl  = TextEditingController();
  final _gymNameCtrl       = TextEditingController();
  final _gymAddressCtrl    = TextEditingController();
  final _pincodeCtrl       = TextEditingController();
  final _gymCityCtrl       = TextEditingController();
  final _gymPhoneCtrl      = TextEditingController();
  final _estYearCtrl       = TextEditingController();
  final _capacityCtrl      = TextEditingController();
  final _gstCtrl           = TextEditingController();
  final _upiCtrl           = TextEditingController();

  // ── Selection state — customer ──
  String? _selectedDob;
  String _selectedGender = '';
  String _fitnessGoal    = '';
  String _fitnessLevel   = '';
  String _workoutTime    = '';
  String _monthlyBudget  = '';
  final Set<String> _interests = {};

  // ── Selection state — owner ──
  String _facilityType = '';
  final Set<String> _specialisations = {};
  final Set<String> _facilities      = {};

  // ── Animation ──
  late final AnimationController _entryCtrl;
  late final Animation<Offset>   _slideAnim;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _entryCtrl.forward());
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _gymNameCtrl.dispose();
    _gymAddressCtrl.dispose();
    _pincodeCtrl.dispose();
    _gymCityCtrl.dispose();
    _gymPhoneCtrl.dispose();
    _estYearCtrl.dispose();
    _capacityCtrl.dispose();
    _gstCtrl.dispose();
    _upiCtrl.dispose();
    super.dispose();
  }

  // ── Progress calculation ──
  double get _progress {
    int filled = 0;
    int total = 0;

    // Always: name + city
    total += 2;
    if (_nameCtrl.text.trim().isNotEmpty) { filled++; }
    if (_cityCtrl.text.trim().isNotEmpty) { filled++; }

    if (widget.role == 'customer' || widget.role == 'both') {
      total += 4;
      if (_fitnessGoal.isNotEmpty) { filled++; }
      if (_fitnessLevel.isNotEmpty) { filled++; }
      if (_workoutTime.isNotEmpty) { filled++; }
      if (_interests.isNotEmpty) { filled++; }
    }

    if (widget.role == 'owner' || widget.role == 'both') {
      total += 4;
      if (_gymNameCtrl.text.trim().isNotEmpty) { filled++; }
      if (_gymAddressCtrl.text.trim().isNotEmpty) { filled++; }
      if (_facilityType.isNotEmpty) { filled++; }
      if (_specialisations.isNotEmpty) { filled++; }
    }

    return total == 0 ? 0 : (filled / total).clamp(0.0, 1.0);
  }

  String get _roleBadgeLabel {
    switch (widget.role) {
      case 'owner': return 'Gym Owner';
      case 'both':  return 'Member + Owner';
      default:      return 'Member';
    }
  }

  IconData get _roleBadgeIcon {
    switch (widget.role) {
      case 'owner': return Icons.storefront_rounded;
      case 'both':  return Icons.all_inclusive_rounded;
      default:      return Icons.fitness_center_rounded;
    }
  }

  // ── Submit ──
  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      _showError('Please enter your full name.');
      return;
    }

    final profileData = <String, dynamic>{
      'city':          _cityCtrl.text.trim(),
      'dob':           _selectedDob ?? '',
      'gender':        _selectedGender,
    };

    if (widget.role == 'customer' || widget.role == 'both') {
      profileData.addAll({
        'fitnessGoal':  _fitnessGoal,
        'fitnessLevel': _fitnessLevel,
        'workoutTime':  _workoutTime,
        'monthlyBudget': _monthlyBudget,
        'interests':    _interests.toList(),
      });
    }

    if (widget.role == 'owner' || widget.role == 'both') {
      profileData.addAll({
        'gymName':       _gymNameCtrl.text.trim(),
        'gymAddress':    _gymAddressCtrl.text.trim(),
        'gymPincode':    _pincodeCtrl.text.trim(),
        'gymCity':       _gymCityCtrl.text.trim(),
        'gymPhone':      _gymPhoneCtrl.text.trim(),
        'estYear':       _estYearCtrl.text.trim(),
        'capacity':      _capacityCtrl.text.trim(),
        'facilityType':  _facilityType,
        'specialisations': _specialisations.toList(),
        'facilities':    _facilities.toList(),
        'gstNumber':     _gstCtrl.text.trim(),
        'upiId':         _upiCtrl.text.trim(),
      });
    }

    context.read<AuthCubit>().createAccount(
      name: _nameCtrl.text.trim(),
      phone: widget.phone,
      role: widget.role,
      profileData: profileData,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.manrope()),
      backgroundColor: const Color(0xFF93000A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroHeight = size.height * 0.36;
    final isCustomer = widget.role == 'customer' || widget.role == 'both';
    final isOwner = widget.role == 'owner' || widget.role == 'both';
    final isBoth = widget.role == 'both';

    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (state is AuthFailure) { _showError(state.message); }
        else if (state is AuthSuccess) {
          ctx.go(state.role == 'owner' ? '/owner' : '/customer');
        }
      },
      child: Stack(
        children: [
          // ── Fixed hero background ────────────────────────────────────────
          SizedBox(
            height: heroHeight,
            width: double.infinity,
            child: const _HeroBackground(),
          ),

          // ── Top bar (back + logo + role badge) ──────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _TopBar(
                  role: _roleBadgeLabel,
                  icon: _roleBadgeIcon,
                  progress: _progress,
                ),
              ),
            ),
          ),

          // ── Scrollable glassmorphic card panel ──────────────────────────
          Positioned(
            top: heroHeight - 32,
            left: 0, right: 0, bottom: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.85),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        border: Border(
                          top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 140),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Panel header ─────────────────────────────────────────
                            _PanelHeader(isBoth: isBoth, isOwner: isOwner && !isBoth),
                            const SizedBox(height: 28),

                            // ── Shared Section (About You) ──────────────────────────────
                            SharedProfileSection(
                              isOwner: isOwner,
                              isBoth: isBoth,
                              nameCtrl: _nameCtrl,
                              cityCtrl: _cityCtrl,
                              selectedGender: _selectedGender,
                              onDobSelected: (v) => setState(() => _selectedDob = v),
                              onGenderChanged: (v) => setState(() => _selectedGender = v),
                              onRebuild: () => setState(() {}),
                            ),

                            // ── CUSTOMER SECTIONS ──
                            if (isCustomer) ...[
                              const SizedBox(height: 32),
                              CustomerProfileSection(
                                fitnessGoal: _fitnessGoal,
                                fitnessLevel: _fitnessLevel,
                                workoutTime: _workoutTime,
                                monthlyBudget: _monthlyBudget,
                                interests: _interests,
                                onGoalChanged: (v) => setState(() => _fitnessGoal = v),
                                onLevelChanged: (v) => setState(() => _fitnessLevel = v),
                                onTimeChanged: (v) => setState(() => _workoutTime = v),
                                onBudgetChanged: (v) => setState(() => _monthlyBudget = v),
                                onInterestToggled: (v) => setState(() {
                                  _interests.contains(v) ? _interests.remove(v) : _interests.add(v);
                                }),
                              ),
                            ],

                            // ── TRANSITION DIVIDER (both) ──────────────────────────────
                            if (isBoth) ...[
                              const SizedBox(height: 40),
                              const TransitionDivider(),
                              const SizedBox(height: 40),
                            ],

                            // ── OWNER SECTIONS ──
                            if (isOwner) ...[
                              OwnerProfileSection(
                                isBoth: isBoth,
                                gymNameCtrl: _gymNameCtrl,
                                gymAddressCtrl: _gymAddressCtrl,
                                pincodeCtrl: _pincodeCtrl,
                                gymCityCtrl: _gymCityCtrl,
                                estYearCtrl: _estYearCtrl,
                                capacityCtrl: _capacityCtrl,
                                gymPhoneCtrl: _gymPhoneCtrl,
                                gstCtrl: _gstCtrl,
                                upiCtrl: _upiCtrl,
                                facilityType: _facilityType,
                                specialisations: _specialisations,
                                facilities: _facilities,
                                onFacilityTypeChanged: (v) => setState(() => _facilityType = v),
                                onSpecialisationToggled: (v) => setState(() {
                                  _specialisations.contains(v) ? _specialisations.remove(v) : _specialisations.add(v);
                                }),
                                onFacilityToggled: (v) => setState(() {
                                  _facilities.contains(v) ? _facilities.remove(v) : _facilities.add(v);
                                }),
                                onRebuild: () => setState(() {}),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Sticky bottom CTA ────────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _StickyCtaBar(onTap: _submit),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Background
// ─────────────────────────────────────────────────────────────────────────────
class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, AppColors.surface],
        stops: [0.35, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.srcOver,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.45),
          BlendMode.darken,
        ),
        child: Image.network(
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=900&q=85',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: const Alignment(0, -0.3),
          errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.role,
    required this.icon,
    required this.progress,
  });
  final String role;
  final IconData icon;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
              ),
            ),
            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.25), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.tertiary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    role.toUpperCase(),
                    style: GoogleFonts.manrope(
                      color: AppColors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Progress label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SETUP PROGRESS',
              style: GoogleFonts.manrope(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.lexend(
                color: AppColors.tertiary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Glowing progress bar
        Stack(
          children: [
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              widthFactor: progress,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tertiary.withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Panel Header
// ─────────────────────────────────────────────────────────────────────────────
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.isBoth, required this.isOwner});
  final bool isBoth;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final subtitle = isOwner
        ? 'Set up your personal profile, then tell us about your facility.'
        : isBoth
            ? "Let's build your complete identity — member and owner."
            : "Let's build your fitness identity.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Complete Profile',
          style: GoogleFonts.lexend(
            color: AppColors.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.75),
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky Bottom CTA
// ─────────────────────────────────────────────────────────────────────────────
class _StickyCtaBar extends StatelessWidget {
  const _StickyCtaBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottomPadding),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.15))),
          ),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final loading = state is AuthLoading;
              return GestureDetector(
                onTap: loading ? null : onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: loading
                        ? null
                        : const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryContainer],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    color: loading ? AppColors.surfaceContainerHigh : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: loading
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 28,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: loading
                      ? const Center(
                          child: SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Complete Setup',
                              style: GoogleFonts.lexend(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
