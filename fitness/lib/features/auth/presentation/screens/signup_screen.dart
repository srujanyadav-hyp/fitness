import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Sign-up screen shown for brand-new users after OTP verification.
/// Matches the immersive Glassmorphism sliding architecture of the Login screen.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: _SignUpBody(phone: phone),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SignUpBody extends StatefulWidget {
  const _SignUpBody({required this.phone});
  final String phone;

  @override
  State<_SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<_SignUpBody> {
  final _nameCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keyboard sliding logic (matching the login screen exactly)
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.darkSemantic.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is AuthSuccess) {
          context.go(state.role == 'owner' ? '/owner' : '/customer');
        }
      },
      child: Stack(
        fit: StackFit.expand, // Prevents row overflow by forcing full width
        children: [
          // ── Cinematic Hero background ─────────────────────────────────────
          const _HeroImage(),

          // ── Logo — top-left inside safe area ───────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _TopBar(),
              ),
            ),
          ),

          // ── Premium Signup Card — slides up with keyboard ──────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: _SignUpCard(
              phone: widget.phone,
              nameCtrl: _nameCtrl,
              nameFocus: _nameFocus,
              selectedRole: _selectedRole,
              onRoleChanged: (r) => setState(() => _selectedRole = r),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cinematic Hero Background image + gradient fade
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.background.withValues(alpha: 0.8),
          AppColors.background,
        ],
        stops: const [0.0, 0.45, 0.8],
      ).createShader(bounds),
      blendMode: BlendMode.srcOver,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.5),
          BlendMode.darken,
        ),
        child: Image.network(
          // Action-oriented gym tracking shot
          'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=900&q=85',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: const Alignment(0, -0.2), // Shifts subject up into view
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar with back button and Logo
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
          ),
        ),
        // Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: AppColors.primaryContainer, size: 28),
            const SizedBox(width: 4),
            Text(
              'FitHub',
              style: GoogleFonts.lexend(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 36), // Balance the back button
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// The Glassmorphism Card
// ─────────────────────────────────────────────────────────────────────────────

class _SignUpCard extends StatelessWidget {
  const _SignUpCard({
    required this.phone,
    required this.nameCtrl,
    required this.nameFocus,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  final String phone;
  final TextEditingController nameCtrl;
  final FocusNode nameFocus;
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 50,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Text ──
              Text(
                'Complete Profile',
                style: GoogleFonts.lexend(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Set up your account to get started.',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // ── Inputs ──
              _PremiumInput(
                label: 'YOUR NAME',
                hint: 'e.g. Rahul Sharma',
                icon: Icons.person_outline_rounded,
                ctrl: nameCtrl,
                focusNode: nameFocus,
              ),
              const SizedBox(height: 20),
              _VerifiedPhoneDisplay(phone: phone),
              const SizedBox(height: 36),

              // ── Role Selection ──
              Text(
                'HOW WILL YOU USE FITHUB?',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              _PremiumRoleSelector(
                selectedRole: selectedRole,
                onChanged: onRoleChanged,
              ),
              const SizedBox(height: 40),

              // ── CTA & Legal ──
              _CreateAccountButton(
                nameCtrl: nameCtrl,
                phone: phone,
                role: selectedRole,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                    children: const [
                      TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // SafeArea padding at bottom
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ultra-Premium Glowing Input Field
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumInput extends StatefulWidget {
  const _PremiumInput({
    required this.label,
    required this.hint,
    required this.icon,
    required this.ctrl,
    required this.focusNode,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController ctrl;
  final FocusNode focusNode;

  @override
  State<_PremiumInput> createState() => _PremiumInputState();
}

class _PremiumInputState extends State<_PremiumInput> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocus);
    super.dispose();
  }

  void _handleFocus() {
    if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isFocused 
            ? AppColors.surfaceContainerHigh.withValues(alpha: 0.6) 
            : AppColors.surfaceContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? AppColors.primary.withValues(alpha: 0.8)
              : AppColors.outlineVariant.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isFocused
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 16,
                  color: _isFocused ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: _isFocused ? AppColors.primary : AppColors.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          TextField(
            controller: widget.ctrl,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.lexend(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.lexend(
                color: AppColors.outline.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Verified Phone Display (Beautiful Non-editable field)
// ─────────────────────────────────────────────────────────────────────────────

class _VerifiedPhoneDisplay extends StatelessWidget {
  const _VerifiedPhoneDisplay({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.green, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOBILE NUMBER',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: GoogleFonts.lexend(
                  color: AppColors.onSurface.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Glassmorphic Segmented Role Selector
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumRoleSelector extends StatelessWidget {
  const _PremiumRoleSelector({
    required this.selectedRole,
    required this.onChanged,
  });

  final String selectedRole;
  final ValueChanged<String> onChanged;

  static const _roles = [
    ('customer', 'Member', Icons.fitness_center_rounded),
    ('owner', 'Owner', Icons.storefront_rounded),
    ('both', 'Both', Icons.all_inclusive_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _roles.map((role) {
        final isSelected = selectedRole == role.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: role == _roles.last ? 0 : 8),
            child: GestureDetector(
              onTap: () => onChanged(role.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuart,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected
                      ? null
                      : AppColors.surfaceContainerHigh.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryContainer.withValues(alpha: 0.5)
                        : AppColors.outlineVariant.withValues(alpha: 0.15),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        role.$3,
                        color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      role.$2,
                      style: GoogleFonts.manrope(
                        color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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
// Epic Gradient Create Engine Button
// ─────────────────────────────────────────────────────────────────────────────

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({
    required this.nameCtrl,
    required this.phone,
    required this.role,
  });

  final TextEditingController nameCtrl;
  final String phone;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return GestureDetector(
          onTap: loading
              ? null
              : () => context.read<AuthCubit>().createAccount(
                    name: nameCtrl.text.trim(),
                    phone: phone,
                    role: role,
                  ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: loading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Launch FitHub',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
