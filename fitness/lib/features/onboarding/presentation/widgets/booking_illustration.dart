import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Screen 2 illustration.
///
/// The image is shown as a **rounded rectangle** (not clipped to a circle).
/// Two thin orbit rings spin around it:
///   - Inner : border-tertiary/20,          clockwise,         10 s
///   - Outer : border-primary-container/10, counter-clockwise, 15 s
///
/// The rings are also rounded-rectangle shaped to complement the image,
/// expanding 16 px (inner) and 32 px (outer) beyond the image on each side.
class BookingIllustration extends StatefulWidget {
  const BookingIllustration({super.key});

  @override
  State<BookingIllustration> createState() => _BookingIllustrationState();
}

class _BookingIllustrationState extends State<BookingIllustration>
    with TickerProviderStateMixin {
  // Inner ring — CW, 10 s
  late final AnimationController _innerCtrl;
  // Outer ring — CCW, 15 s
  late final AnimationController _outerCtrl;

  // Image size and corner radius
  static const double _imgSize = 240;
  static const double _imgRadius = 24;

  // Ring bleeds: how many px beyond the image each ring extends per side
  static const double _innerBleed = 16;
  static const double _outerBleed = 32;

  @override
  void initState() {
    super.initState();

    _innerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _outerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _innerCtrl.dispose();
    _outerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outerSize = _imgSize + _outerBleed * 2; // 240 + 64 = 304
    final innerSize = _imgSize + _innerBleed * 2; // 240 + 32 = 272

    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ambient glow behind image ────────────────────────────────
              Container(
                width: _imgSize,
                height: _imgSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_imgRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.20),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),

              // ── Outer ring (CCW, 15 s, primaryContainer / 10 %) ──────────
              AnimatedBuilder(
                animation: _outerCtrl,
                builder: (_, child) => Transform.rotate(
                  angle: -_outerCtrl.value * 2 * math.pi,
                  child: child,
                ),
                child: Container(
                  width: outerSize,
                  height: outerSize,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(_imgRadius + _outerBleed),
                    border: Border.all(
                      color:
                          AppColors.primaryContainer.withValues(alpha: 0.10),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // ── Inner ring (CW, 10 s, tertiary / 20 %) ───────────────────
              AnimatedBuilder(
                animation: _innerCtrl,
                builder: (_, child) => Transform.rotate(
                  angle: _innerCtrl.value * 2 * math.pi,
                  child: child,
                ),
                child: Container(
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(_imgRadius + _innerBleed),
                    border: Border.all(
                      color: AppColors.tertiary.withValues(alpha: 0.20),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // ── Image (rounded rectangle, NOT circular) ───────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(_imgRadius),
                child: Image.asset(
                  'assets/onboarding_2.png',
                  width: _imgSize,
                  height: _imgSize,
                  fit: BoxFit.cover,
                  // mix-blend-luminosity + opacity-80 from HTML reference
                  color: Colors.white.withValues(alpha: 0.82),
                  colorBlendMode: BlendMode.modulate,
                  errorBuilder: (_, __, ___) => Container(
                    width: _imgSize,
                    height: _imgSize,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(_imgRadius),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      size: 72,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
