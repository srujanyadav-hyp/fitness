import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/use_cases/determine_initial_route_use_case.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/loading_bar.dart';
import '../widgets/pulse_rings.dart';
import '../widgets/spark_particles.dart';

/// Entry-point screen. Provides [SplashCubit] and reacts to its states.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(
        determineInitialRoute: const DetermineInitialRouteUseCase(),
      )..start(),
      child: const _SplashView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal stateful view that owns the animation controllers.
// ---------------------------------------------------------------------------

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  // ── Icon drop-bounce ──────────────────────────────────────────────────────
  late final AnimationController _iconCtrl;
  late final Animation<double> _iconSlide;
  late final Animation<double> _iconOpacity;

  // ── Brand text slide-in ───────────────────────────────────────────────────
  late final AnimationController _textCtrl;
  late final Animation<double> _textSlide;
  late final Animation<double> _textOpacity;

  // ── Tagline fade-up ───────────────────────────────────────────────────────
  late final AnimationController _taglineCtrl;
  late final Animation<double> _taglineSlide;
  late final Animation<double> _taglineOpacity;

  // ── Glow pulse (runs once after icon settles) ─────────────────────────────
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowRadius;

  // ── Loading bar shimmer ───────────────────────────────────────────────────
  late final AnimationController _loadCtrl;
  late final Animation<double> _loadPos;

  @override
  void initState() {
    super.initState();

    // 1. Icon drop-bounce (0 → 800 ms)
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _iconSlide = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: 10)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 10, end: -6)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -6, end: 0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_iconCtrl);
    _iconOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconCtrl, curve: const Interval(0, 0.3)),
    );

    // 2. Brand text slide-in (300 ms delay → 800 ms duration)
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textSlide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutBack),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0, 0.5)),
    );

    // 3. Tagline fade-up (1 500 ms delay → 1 000 ms duration)
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _taglineSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );

    // 4. Glow pulse (1 200 ms delay, runs once)
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _glowRadius = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: 30), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 30, end: 0), weight: 50),
    ]).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // 5. Loading bar (loops for the duration of the splash)
    _loadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _loadPos = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _loadCtrl, curve: Curves.easeInOut),
    );

    // Trigger sequence
    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), _textCtrl.forward);
    Future.delayed(
        const Duration(milliseconds: 1200), _glowCtrl.forward);
    Future.delayed(const Duration(milliseconds: 1500), _taglineCtrl.forward);
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _textCtrl.dispose();
    _taglineCtrl.dispose();
    _glowCtrl.dispose();
    _loadCtrl.dispose();
    super.dispose();
  }

  // ── Navigation listener ───────────────────────────────────────────────────

  void _handleState(BuildContext context, SplashState state) {
    switch (state) {
      case SplashNavigateToAuth():
        context.go(AppRoutes.onboarding);
      case SplashNavigateToHome():
        _routeToHome(context);
      case SplashAnimating():
        break;
    }
  }

  Future<void> _routeToHome(BuildContext context) async {
    // Capture router before the async gap.
    final router = GoRouter.of(context);
    const storage = _PrefReader();
    final role = await storage.role();
    if (!mounted) return;
    router.go(role == 'owner' ? '/owner' : '/customer');
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Force dark theme: splash is a brand cinematic screen — always dark
    // regardless of the device's system light/dark setting.
    return Theme(
      data: AppTheme.dark,
      child: BlocListener<SplashCubit, SplashState>(
        listener: _handleState,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // 1. Radial vignette overlay
              const _VignetteOverlay(),

              // 2. Floating spark particles
              const SparkParticles(),

              // 3. Pulsing rings (centered behind logo)
              const Center(child: PulseRings()),

              // 4. Main content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo row: bolt icon + wordmark
                    _buildLogoRow(),

                    const SizedBox(height: 24),

                    // Tagline
                    _buildTagline(),
                  ],
                ),
              ),

              // 5. Bottom loading bar
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: LoadingBar(positionAnimation: _loadPos),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoRow() {
    return AnimatedBuilder(
      animation: Listenable.merge([_iconCtrl, _textCtrl, _glowCtrl]),
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bolt icon — drop-bounce
            Transform.translate(
              offset: Offset(0, _iconSlide.value),
              child: Opacity(
                opacity: _iconOpacity.value,
                child: ShaderMask(
                  shaderCallback: (rect) => RadialGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85),
                    ],
                  ).createShader(rect),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: AppColors.white,
                    size: 88,
                    shadows: [
                      Shadow(
                        color: AppColors.primary
                            .withValues(alpha: _glowRadius.value / 30 * 0.5),
                        blurRadius: _glowRadius.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Wordmark — slide-in from right
            Transform.translate(
              offset: Offset(_textSlide.value, 0),
              child: Opacity(
                opacity: _textOpacity.value,
                child: Text('FitHub', style: AppTextStyles.headline),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _taglineCtrl,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _taglineSlide.value),
          child: Opacity(
            opacity: _taglineOpacity.value,
            child: Text(
              'FIND YOUR GYM. OWN YOUR FITNESS.',
              style: AppTextStyles.tagline,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Vignette overlay
// ---------------------------------------------------------------------------

class _VignetteOverlay extends StatelessWidget {
  const _VignetteOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
              stops: const [0.2, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Thin SharedPreferences reader (keeps the splash screen self-contained) ─

class _PrefReader {
  const _PrefReader();

  Future<String> role() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_role') ?? 'customer';
  }
}
