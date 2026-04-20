import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Sign-up screen shown for brand-new users after OTP verification.
/// Reuses [AuthCubit] provided by [LoginScreen].
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: _SignUpBody(phone: phone),
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.darkSemantic.error,
            ),
          );
        }
      },
      child: Stack(
        children: [
          // ── Hero ────────────────────────────────────────────────────
          _HeroSection(),

          // ── Scrollable form card ─────────────────────────────────────
          Column(
            children: [
              // Transparent area for the hero (45 % of screen height)
              SizedBox(height: MediaQuery.of(context).size.height * 0.38),

              Expanded(
                child: _SignUpCard(
                  phone: widget.phone,
                  nameCtrl: _nameCtrl,
                  nameFocus: _nameFocus,
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
// Hero image top section
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.45;
    return SizedBox(
      height: h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.30),
              BlendMode.darken,
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.surfaceContainer),
            ),
          ),

          // Bottom fade
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.surface.withValues(alpha: 0.70),
                    AppColors.surface,
                  ],
                  stops: const [0.30, 0.72, 1.0],
                ),
              ),
            ),
          ),

          // Logo
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded,
                      color: AppColors.primaryContainer, size: 28),
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
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glassmorphism sign-up card
// ─────────────────────────────────────────────────────────────────────────────

class _SignUpCard extends StatelessWidget {
  const _SignUpCard({
    required this.phone,
    required this.nameCtrl,
    required this.nameFocus,
  });

  final String phone;
  final TextEditingController nameCtrl;
  final FocusNode nameFocus;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.60),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.80),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              28,
              32,
              28,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Text(
                  'Join FitHub',
                  style: GoogleFonts.lexend(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create an account to start your fitness journey.',
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),

                // Full Name field
                _LabeledInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  ctrl: nameCtrl,
                  focus: nameFocus,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Mobile field (pre-filled, readonly)
                _ReadOnlyPhoneField(phone: phone),
                const SizedBox(height: 28),

                // Create Account button
                _CreateAccountButton(
                  nameCtrl: nameCtrl,
                  phone: phone,
                ),
                const SizedBox(height: 22),

                // Divider
                _Divider(),
                const SizedBox(height: 16),

                // Google button
                _GoogleSignInButton(),
                const SizedBox(height: 20),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.manrope(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Footer
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        color: AppColors.outlineVariant,
                        fontSize: 11,
                      ),
                      children: const [
                        TextSpan(
                            text: 'By creating an account, you agree to our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Labelled bottom-border input
// ─────────────────────────────────────────────────────────────────────────────

class _LabeledInput extends StatefulWidget {
  const _LabeledInput({
    required this.label,
    required this.hint,
    required this.ctrl,
    required this.focus,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.prefix,
  });

  final String label;
  final String hint;
  final TextEditingController ctrl;
  final FocusNode focus;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final Widget? prefix;

  @override
  State<_LabeledInput> createState() => _LabeledInputState();
}

class _LabeledInputState extends State<_LabeledInput> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() {
      if (mounted) setState(() => _focused = widget.focus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(
          bottom: BorderSide(
            color: _focused
                ? AppColors.primary
                : AppColors.outlineVariant,
            width: 2,
          ),
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.prefix != null)
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 12),
              child: widget.prefix,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    widget.label,
                    style: GoogleFonts.manrope(
                      color: _focused
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                TextField(
                  controller: widget.ctrl,
                  focusNode: widget.focus,
                  keyboardType: widget.keyboardType,
                  textCapitalization: widget.textCapitalization,
                  readOnly: widget.readOnly,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.manrope(
                      color: AppColors.outline,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
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

// Read-only phone field (pre-filled with verified number)
class _ReadOnlyPhoneField extends StatelessWidget {
  const _ReadOnlyPhoneField({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController(text: phone);
    final focus = FocusNode();
    return _LabeledInput(
      label: 'Mobile Number',
      hint: '',
      ctrl: ctrl,
      focus: focus,
      readOnly: true,
      prefix: Row(
        children: [
          const Text('🇮🇳', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
          Text(
            '+91',
            style: GoogleFonts.manrope(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 24,
            color: AppColors.outlineVariant.withValues(alpha: 0.30),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({
    required this.nameCtrl,
    required this.phone,
  });

  final TextEditingController nameCtrl;
  final String phone;

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
                  ),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: loading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.onPrimaryContainer),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: GoogleFonts.lexend(
                          color: AppColors.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: AppColors.onPrimaryContainer, size: 20),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.40))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or sign up with',
            style: GoogleFonts.manrope(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
            child: Container(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.40))),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {/* TODO: Google Sign-In */},
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('G', style: TextStyle(fontSize: 20, color: Color(0xFF4285F4), fontWeight: FontWeight.w700)),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
