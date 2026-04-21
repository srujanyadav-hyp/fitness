import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// OTP verification screen.
/// Expects [AuthCubit] to already be provided by [LoginScreen].
class OtpScreen extends StatelessWidget {
  /// The formatted phone number to display, e.g. "+91 98765 43210".
  const OtpScreen({super.key, required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        // OTP uses a custom numeric keypad — system keyboard never appears.
        resizeToAvoidBottomInset: false,
        body: _OtpBody(phone: phone),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _OtpBody extends StatefulWidget {
  const _OtpBody({required this.phone});
  final String phone;

  @override
  State<_OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<_OtpBody> {
  // 4 digit controllers + focus nodes
  final _ctrls = List.generate(4, (_) => TextEditingController());
  final _foci = List.generate(4, (_) => FocusNode());

  // Resend countdown
  static const _resendSeconds = 30;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _foci) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  void _onDigit(String digit) {
    for (int i = 0; i < 4; i++) {
      if (_ctrls[i].text.isEmpty) {
        _ctrls[i].text = digit;
        setState(() {});
        if (i < 3) _foci[i + 1].requestFocus();
        if (i == 3) _submit();
        return;
      }
    }
  }

  void _onBackspace() {
    for (int i = 3; i >= 0; i--) {
      if (_ctrls[i].text.isNotEmpty) {
        _ctrls[i].text = '';
        setState(() {});
        if (i > 0) _foci[i - 1].requestFocus();
        return;
      }
    }
  }

  void _submit() {
    if (_otp.length == 4) {
      context.read<AuthCubit>().verifyOtp(_otp);
    }
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
        // AuthSuccess / AuthSignUpRequired → handled by GoRouter redirect
      },
      child: SafeArea(
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────────────────
            _AppBar(),

            // ── Content ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Headline
                    Text(
                      'Verify your\nnumber',
                      style: GoogleFonts.lexend(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 34,
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Subheading + edit
                    _PhoneSubtitle(phone: widget.phone),
                    const SizedBox(height: 36),

                    // OTP boxes
                    _OtpBoxRow(ctrls: _ctrls, foci: _foci),
                    const SizedBox(height: 24),

                    // Resend
                    _ResendRow(
                      secondsLeft: _secondsLeft,
                      onResend: () {
                        context.read<AuthCubit>().sendOtp(widget.phone
                            .replaceAll(RegExp(r'\D'), '')
                            .substring(2));
                        _startTimer();
                      },
                    ),

                    const Spacer(),

                    // Verify button
                    _VerifyButton(onTap: _submit),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Custom keypad ───────────────────────────────────────────
            _NumericKeypad(
              onDigit: _onDigit,
              onBackspace: _onBackspace,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().reset();
              Navigator.of(context).maybePop();
            },
            icon: Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PhoneSubtitle extends StatelessWidget {
  const _PhoneSubtitle({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.manrope(
                color: AppColors.onSurfaceVariant, fontSize: 15),
            children: [
              const TextSpan(text: "We've sent a 4-digit code to\n"),
              TextSpan(
                text: phone,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<AuthCubit>().reset();
            Navigator.of(context).maybePop();
          },
          child: Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// The four OTP digit boxes
// ─────────────────────────────────────────────────────────────────────────────

class _OtpBoxRow extends StatelessWidget {
  const _OtpBoxRow({required this.ctrls, required this.foci});
  final List<TextEditingController> ctrls;
  final List<FocusNode> foci;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          List.generate(4, (i) => _OtpBox(ctrl: ctrls[i], focus: foci[i])),
    );
  }
}

class _OtpBox extends StatefulWidget {
  const _OtpBox({required this.ctrl, required this.focus});
  final TextEditingController ctrl;
  final FocusNode focus;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() {
      if (mounted) setState(() => _focused = widget.focus.hasFocus);
    });
    widget.ctrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.ctrl.text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 72,
      height: 84,
      decoration: BoxDecoration(
        color: _focused
            ? AppColors.surfaceContainerHigh
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focused ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 15,
                )
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        filled ? widget.ctrl.text : '',
        style: GoogleFonts.lexend(
          color: _focused ? AppColors.primary : AppColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.secondsLeft, required this.onResend});
  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final canResend = secondsLeft == 0;
    return Text.rich(
      TextSpan(
        style: GoogleFonts.manrope(
            color: AppColors.onSurfaceVariant, fontSize: 13),
        children: [
          const TextSpan(text: "Didn't receive the code?  "),
          TextSpan(
            text: canResend
                ? 'Resend Code'
                : 'Resend in ${secondsLeft.toString().padLeft(2, '0')}s',
            style: GoogleFonts.manrope(
              color: canResend ? AppColors.primary : AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return GestureDetector(
          onTap: loading ? null : onTap,
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
                      color: AppColors.onPrimaryContainer,
                    ),
                  )
                : Text(
                    'Verify & Proceed',
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
// Custom numeric keypad matching reference UI
// ─────────────────────────────────────────────────────────────────────────────

class _NumericKeypad extends StatelessWidget {
  const _NumericKeypad({
    required this.onDigit,
    required this.onBackspace,
  });

  final void Function(String) onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.10),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.50),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...'123456789'
              .split('')
              .map((d) => _Key(label: d, onTap: () => onDigit(d))),
          const SizedBox.shrink(), // empty cell
          _Key(label: '0', onTap: () => onDigit('0')),
          _BackspaceKey(onTap: onBackspace),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.lexend(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  const _BackspaceKey({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.backspace_outlined,
            color: AppColors.onSurfaceVariant, size: 26),
      ),
    );
  }
}
