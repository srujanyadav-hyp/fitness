import 'package:flutter/material.dart';

/// FitHub design-system color tokens.
/// These mirror the Tailwind config in the reference HTML:
///   brand.bg      → #12131F (dark background)
///   brand.primary → #FF4D2E (energetic red-orange)
///   brand.text    → #C8C8D0 (muted body text)
///   brand.track   → #2A2B38 (progress track / surface)
abstract final class AppColors {
  AppColors._();

  // ── Splash ────────────────────────────────────────────────────────────────
  static const Color background   = Color(0xFF12131F);
  static const Color primary      = Color(0xFFFF4D2E);
  static const Color textBody     = Color(0xFFC8C8D0);
  static const Color track        = Color(0xFF2A2B38);
  static const Color white        = Colors.white;
  static const Color transparent  = Colors.transparent;

  // ── Onboarding Design System ──────────────────────────────────────────────
  static const Color surface              = Color(0xFF111125);
  static const Color surfaceContainer     = Color(0xFF1E1E32);
  static const Color surfaceContainerHigh = Color(0xFF28283D);
  static const Color surfaceVariant       = Color(0xFF333348);
  static const Color surfaceBright        = Color(0xFF37374D);
  static const Color onSurface           = Color(0xFFE2E0FC);
  static const Color onSurfaceVariant    = Color(0xFFE5BEB6);
  static const Color primaryContainer    = Color(0xFFFF5637);
  static const Color onPrimaryContainer  = Color(0xFF590800);
  static const Color tertiary            = Color(0xFF64D4FC);
  static const Color tertiaryContainer   = Color(0xFF0E9DC3);
  static const Color outlineVariant      = Color(0xFF5C403A);
  static const Color outline             = Color(0xFFAC8982);
}
