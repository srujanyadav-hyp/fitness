import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated loading bar at the bottom of the splash screen.
///
/// Replicates the HTML reference exactly:
///   - 180 × 3 px dark track, fully rounded
///   - Primary-colour bar sweeps left → right (translateX −100% → +100%)
///   - Glowing white leading edge: 20 px soft blur + 2 px hard white stripe
///
/// Uses [CustomPainter] so the blur glow, clipping and translation are all
/// done on the [Canvas] — no widget layout quirks.
class LoadingBar extends StatelessWidget {
  const LoadingBar({super.key, required this.positionAnimation});

  /// Drives the sweep: value goes from −1.0 (bar fully off-screen left)
  /// to +1.0 (bar fully off-screen right), looping continuously.
  final Animation<double> positionAnimation;

  static const double _trackWidth = 180;
  static const double _trackHeight = 3;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: positionAnimation,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(_trackWidth, _trackHeight),
          painter: _LoadingBarPainter(progress: positionAnimation.value),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _LoadingBarPainter extends CustomPainter {
  const _LoadingBarPainter({required this.progress});

  /// −1.0 → bar is fully left of the track
  ///  0.0 → bar is centred (fully visible)
  /// +1.0 → bar is fully right of the track
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;   // 180
    final h = size.height;  // 3

    final radius = Radius.circular(h / 2);
    final trackRRect = RRect.fromRectAndRadius(Offset.zero & size, radius);

    // 1 ── Draw the dark track background ────────────────────────────────────
    canvas.drawRRect(
      trackRRect,
      Paint()..color = AppColors.track,
    );

    // 2 ── Clip everything to the track shape ────────────────────────────────
    canvas.save();
    canvas.clipRRect(trackRRect);

    // 3 ── Compute bar position ───────────────────────────────────────────────
    // The bar is exactly as wide as the track (w).
    // progress = −1 → barLeft = −w (fully off left)
    // progress =  0 → barLeft =  0 (fully visible)
    // progress = +1 → barLeft = +w (fully off right)
    final barLeft = w * progress;

    // 4 ── Draw the primary-colour fill bar ──────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(barLeft, 0, w, h),
      Paint()..color = AppColors.primary,
    );

    // 5 ── Soft glow on the leading (right) edge ─────────────────────────────
    // Mimics:  bg-white opacity-80 blur-[2px]   (width: 20 px)
    final glowLeft = barLeft + w - 20;
    canvas.drawRect(
      Rect.fromLTWH(glowLeft, 0, 20, h),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // 6 ── Hard white stripe on the very leading edge ─────────────────────────
    // Mimics:  bg-white   (width: 2 px)
    final stripeLeft = barLeft + w - 2;
    canvas.drawRect(
      Rect.fromLTWH(stripeLeft, 0, 2, h),
      Paint()..color = Colors.white,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoadingBarPainter old) => old.progress != progress;
}
