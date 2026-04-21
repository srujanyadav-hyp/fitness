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

/// Entry point for the auth flow.
/// [AuthCubit] is provided by the router via [BlocProvider.value].
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.darkSemantic.error,
              ),
            );
          } else if (state is AuthOtpSent) {
            context.push(
              '/login/otp',
              extra: context.read<AuthCubit>(),
            );
          } else if (state is AuthSignUpRequired) {
            context.push('/login/signup?phone=${Uri.encodeComponent(state.phone)}');
          } else if (state is AuthSuccess) {
            // TODO: route to customer/owner home based on state.role
            // context.go(AppRoutes.customerHome);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          // Universal fix: we handle keyboard offset ourselves via
          // viewInsets.bottom so the hero image is never clipped.
          resizeToAvoidBottomInset: false,
          body: const _LoginBody(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // viewInsets.bottom == keyboard height (0 when hidden).
    // AnimatedContainer.margin shifts the card up by exactly that amount.
    // Because the card is Positioned (not inside a Column with a Spacer),
    // RenderFlex overflow is structurally impossible on any screen size.
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // StackFit.expand forces the Stack to fill the full Scaffold body
    // (tight constraints from parent).
    // Without this, Stack sizes to non-positioned children (the SafeArea logo),
    // making its width ~logo-width, which then leaks as an 88.9px constraint
    // deep into the PhoneCard Row — causing the overflow.
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Full-screen hero ──────────────────────────────────────────────
        _HeroImage(),

        // ── Logo — top-left, inside safe area ────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _FitHubLogo(),
            ),
          ),
        ),

        // ── Phone card slides up as keyboard appears ──────────────────────
        // left:0 + right:0 + StackFit.expand = always exact screen width.
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          bottom: keyboardHeight,
          child: _PhoneCard(
            phoneCtrl: _phoneCtrl,
            phoneFocus: _phoneFocus,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero background image + gradient fade
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.background.withValues(alpha: 0.7),
          AppColors.background,
        ],
        stops: const [0.0, 0.55, 0.82],
      ).createShader(bounds),
      blendMode: BlendMode.srcOver,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.45),
          BlendMode.darken,
        ),
        child: Image.network(
          // Striking heavy rope/training shot — high clarity and energy
          'https://images.unsplash.com/photo-1594381898411-846e7d193883?q=85&w=900',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: const Alignment(0, -0.2), // Shifts subject up into view
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceContainer,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FitHub logo mark
// ─────────────────────────────────────────────────────────────────────────────

class _FitHubLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glassmorphism phone-entry card
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneCard extends StatelessWidget {
  const _PhoneCard({
    required this.phoneCtrl,
    required this.phoneFocus,
  });

  final TextEditingController phoneCtrl;
  final FocusNode phoneFocus;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.60),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, -20),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Welcome to FitHub',
                style: GoogleFonts.lexend(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your mobile number to continue.',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),

              // Phone input
              _PhoneInput(ctrl: phoneCtrl, focus: phoneFocus),
              const SizedBox(height: 18),

              // Send OTP button
              _SendOtpButton(phoneCtrl: phoneCtrl),
              const SizedBox(height: 22),

              // Divider
              _OrDivider(),
              const SizedBox(height: 16),

              // Google button
              _GoogleButton(),
              const SizedBox(height: 20),

              // ── Animated looping signup link ──────────────────────────
              const Center(child: _LoopingSignupLink()),
              const SizedBox(height: 20),

              // Footer
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant
                          .withValues(alpha: 0.60),
                      fontSize: 11,
                    ),
                    children: const [
                      TextSpan(text: 'By continuing you agree to our '),
                      TextSpan(
                        text: 'Terms',
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

              // Safe-area bottom padding
              SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone input field
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneInput extends StatefulWidget {
  const _PhoneInput({required this.ctrl, required this.focus});
  final TextEditingController ctrl;
  final FocusNode focus;

  @override
  State<_PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<_PhoneInput> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() {
      setState(() => _focused = widget.focus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
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
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // Country code pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
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
              ],
            ),
          ),
          // Separator
          Container(
            width: 1,
            height: 24,
            color: AppColors.outlineVariant.withValues(alpha: 0.30),
          ),
          // Number input
          Expanded(
            child: TextField(
              controller: widget.ctrl,
              focusNode: widget.focus,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: '00000 00000',
                hintStyle: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant
                      .withValues(alpha: 0.50),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Send OTP button with loading state
// ─────────────────────────────────────────────────────────────────────────────

class _SendOtpButton extends StatelessWidget {
  const _SendOtpButton({required this.phoneCtrl});
  final TextEditingController phoneCtrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return GestureDetector(
          onTap: loading
              ? null
              : () => context
                  .read<AuthCubit>()
                  .sendOtp(phoneCtrl.text),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
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
                      color: AppColors.onPrimaryContainer,
                    ),
                  )
                : Text(
                    'Send OTP',
                    style: GoogleFonts.lexend(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "or continue with" divider
// ─────────────────────────────────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.40),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
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
            color: AppColors.outlineVariant.withValues(alpha: 0.40),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Google sign-in button
// ─────────────────────────────────────────────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: wire Google Sign-In
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Official Google 'G' Logo from Wikimedia
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 12),
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

// ─────────────────────────────────────────────────────────────────────────────
// Animated Looping Signup Link
// ─────────────────────────────────────────────────────────────────────────────

class _LoopingSignupLink extends StatefulWidget {
  const _LoopingSignupLink();

  @override
  State<_LoopingSignupLink> createState() => _LoopingSignupLinkState();
}

class _LoopingSignupLinkState extends State<_LoopingSignupLink> {
  int _currentIndex = 0;
  
  final List<List<TextSpan>> _pitches = [
    [
      const TextSpan(text: 'Looking for the perfect workout? '),
      const TextSpan(text: 'Join as Member'),
    ],
    [
      const TextSpan(text: 'Are you a gym owner? '),
      const TextSpan(text: 'Partner with us'),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _pitches.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/login/signup'),
      child: Container(
        color: Colors.transparent, // Ensures the entire area is clickable
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: RichText(
            key: ValueKey<int>(_currentIndex),
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.manrope(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                _pitches[_currentIndex][0],
                TextSpan(
                  text: _pitches[_currentIndex][1].text,
                  style: GoogleFonts.manrope(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
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
