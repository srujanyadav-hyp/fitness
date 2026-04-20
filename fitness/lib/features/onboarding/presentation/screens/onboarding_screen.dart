import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/use_cases/get_onboarding_pages_use_case.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/booking_illustration.dart';
import '../widgets/capacity_gauge.dart';
import '../widgets/map_illustration.dart';
import '../widgets/page_indicator.dart';

/// Top-level onboarding screen.  Provides [OnboardingCubit] and
/// renders a [PageView] with the three illustration pages.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(
        getOnboardingPages: const GetOnboardingPagesUseCase(),
      ),
      child: const _OnboardingView(),
    );
  }
}

// ---------------------------------------------------------------------------

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(BuildContext context, OnboardingState state) {
    if (state.isLastPage) {
      // TODO: navigate to auth/home once built
      // context.go(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
      context.read<OnboardingCubit>().next();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // ── Atmospheric background gradient ─────────────────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.6, -0.6),
                        radius: 1.2,
                        colors: [
                          AppColors.primaryContainer.withValues(alpha: 0.06),
                          AppColors.surface,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main layout ─────────────────────────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              state.pages.length - 1,
                              duration: const Duration(milliseconds: 420),
                              curve: Curves.easeInOutCubic,
                            );
                            context.read<OnboardingCubit>().skip();
                          },
                          child: Text(
                            'Skip',
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Page content
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: context.read<OnboardingCubit>().goToPage,
                        itemCount: state.pages.length,
                        itemBuilder: (context, index) {
                          return _OnboardingPage(
                            pageIndex: index,
                            page: state.pages[index],
                          );
                        },
                      ),
                    ),

                    // Footer
                    _Footer(
                      state: state,
                      onNext: () => _onNext(context, state),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Single page
// ---------------------------------------------------------------------------

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.pageIndex,
    required this.page,
  });

  final int pageIndex;
  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration (takes ~45 % of available height)
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _illustrationFor(pageIndex),
            ),
          ),

          const SizedBox(height: 40),

          // Text block
          Flexible(
            flex: 3,
            child: _TextBlock(page: page),
          ),
        ],
      ),
    );
  }

  Widget _illustrationFor(int index) {
    return switch (index) {
      0 => const MapIllustration(),
      1 => const BookingIllustration(),
      2 => const CapacityGauge(),
      _ => const SizedBox.shrink(),
    };
  }
}

// ---------------------------------------------------------------------------
// Text block
// ---------------------------------------------------------------------------

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.page});
  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    // Split headline on '\n' to colour the second line for screen 2
    final lines = page.headline.split('\n');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: lines[0], style: AppTextStyles.headlineLg),
              if (lines.length > 1) ...[
                const TextSpan(text: '\n'),
                TextSpan(
                  text: lines[1],
                  style: AppTextStyles.headlineLg.copyWith(
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          page.body,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd,
          maxLines: 3,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onNext});
  final OnboardingState state;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = state.isLastPage;
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withValues(alpha: 0.4),
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageIndicator(
                  count: state.pages.length,
                  current: state.currentIndex,
                ),
                _NextButton(isLast: isLast, onPressed: onNext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Next / Get Started button
// ---------------------------------------------------------------------------

class _NextButton extends StatefulWidget {
  const _NextButton({required this.isLast, required this.onPressed});
  final bool isLast;
  final VoidCallback onPressed;

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressScale = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (_, child) =>
            Transform.scale(scale: _pressScale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isLast ? 'Get Started' : 'Next',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
