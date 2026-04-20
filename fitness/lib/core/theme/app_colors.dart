import 'package:flutter/material.dart';

/// FitHub design-system color tokens — complete dark + light system.
///
/// Usage pattern:
///   AppColors.dark.background   → dark mode scaffold
///   AppColors.light.background  → light mode scaffold
///   AppColors.brand.primary     → always orange-red regardless of mode
///   AppColors.semantic.success  → resolved by mode at widget level
///
/// In your ThemeData, wire these via ColorScheme and ThemeExtensions.
abstract final class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────────────────────────────────
  // BRAND — fixed, never changes between modes
  // ─────────────────────────────────────────────────────────────────────────
  static const Color primary          = Color(0xFFFF4D2E); // energetic orange-red
  static const Color primaryDark      = Color(0xFFE83B1E); // slightly deeper for light mode
  static const Color primaryContainer = Color(0xFFFF5637); // button bg tint (dark)
  static const Color primaryContainerLight = Color(0xFFFFE8E4); // button bg tint (light)
  static const Color onPrimaryContainer = Color(0xFF590800); // text on primary bg — same both modes
  static const Color white            = Colors.white;
  static const Color transparent      = Colors.transparent;
  static const Color starRating       = Color(0xFFF59E0B); // gold stars — both modes

  // ─────────────────────────────────────────────────────────────────────────
  // DARK MODE TOKENS
  // ─────────────────────────────────────────────────────────────────────────
  static const _DarkColors dark = _DarkColors();

  // ─────────────────────────────────────────────────────────────────────────
  // LIGHT MODE TOKENS
  // ─────────────────────────────────────────────────────────────────────────
  static const _LightColors light = _LightColors();

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC — mode-aware status colors
  // Access via AppColors.darkSemantic / AppColors.lightSemantic
  // or resolve in your ThemeExtension
  // ─────────────────────────────────────────────────────────────────────────
  static const _SemanticDark darkSemantic   = _SemanticDark();
  static const _SemanticLight lightSemantic = _SemanticLight();

  // ─────────────────────────────────────────────────────────────────────────
  // LEGACY FLAT ACCESS — kept for backward compat with splash + onboarding
  // that already reference AppColors.background, AppColors.surface etc.
  // ─────────────────────────────────────────────────────────────────────────

  // Splash
  static const Color background   = Color(0xFF12131F);
  static const Color textBody     = Color(0xFFC8C8D0);
  static const Color track        = Color(0xFF2A2B38);

  // Onboarding (dark)
  static const Color surface              = Color(0xFF111125);
  static const Color surfaceContainer     = Color(0xFF1E1E32);
  static const Color surfaceContainerHigh = Color(0xFF28283D);
  static const Color surfaceVariant       = Color(0xFF333348);
  static const Color surfaceBright        = Color(0xFF37374D);
  static const Color onSurface           = Color(0xFFE2E0FC);
  static const Color onSurfaceVariant    = Color(0xFFE5BEB6);
  static const Color tertiary            = Color(0xFF64D4FC);
  static const Color tertiaryContainer   = Color(0xFF0E9DC3);
  static const Color outlineVariant      = Color(0xFF5C403A);
  static const Color outline             = Color(0xFFAC8982);
}

// ───────────────────────────────────────────────────────────────────────────
// DARK MODE COLOR SET
// ───────────────────────────────────────────────────────────────────────────
final class _DarkColors {
  const _DarkColors();

  // Backgrounds
  Color get background            => const Color(0xFF12131F); // scaffold
  Color get surface               => const Color(0xFF111125); // card base, modal
  Color get surfaceContainer      => const Color(0xFF1E1E32); // list items, input bg
  Color get surfaceContainerHigh  => const Color(0xFF28283D); // elevated cards
  Color get surfaceVariant        => const Color(0xFF333348); // filter chips, tags
  Color get surfaceBright         => const Color(0xFF37374D); // hover states
  Color get navBar                => const Color(0xFF111125); // bottom nav

  // Text
  Color get onSurface             => const Color(0xFFE2E0FC); // H1, H2 headlines
  Color get onSurfaceVariant      => const Color(0xFFE5BEB6); // body, secondary text
  Color get textBody              => const Color(0xFFC8C8D0); // body copy, taglines
  Color get textMuted             => const Color(0xFF888899); // timestamps, hints
  Color get textDisabled          => const Color(0xFF555566); // disabled labels

  // Borders / Dividers
  Color get outline               => const Color(0xFFAC8982); // card borders
  Color get outlineVariant        => const Color(0xFF5C403A); // subtle dividers
  Color get divider               => const Color(0xFF1E1E32); // HR lines

  // Track / Progress
  Color get track                 => const Color(0xFF2A2B38); // progress bar track
  Color get shimmer               => const Color(0xFF2A2B38); // skeleton base
  Color get shimmerHighlight      => const Color(0xFF37374D); // skeleton sweep

  // Tertiary (info / crowd level blue)
  Color get tertiary              => const Color(0xFF64D4FC);
  Color get tertiaryContainer     => const Color(0xFF0E9DC3);
  Color get onTertiary            => const Color(0xFF003544);
}

// ───────────────────────────────────────────────────────────────────────────
// LIGHT MODE COLOR SET
// ───────────────────────────────────────────────────────────────────────────
final class _LightColors {
  const _LightColors();

  // Backgrounds
  Color get background            => const Color(0xFFF4F4F8); // scaffold
  Color get surface               => const Color(0xFFFFFFFF); // card base, modal
  Color get surfaceContainer      => const Color(0xFFF0F0F8); // list items, input bg
  Color get surfaceContainerHigh  => const Color(0xFFE8E8F4); // elevated cards
  Color get surfaceVariant        => const Color(0xFFDCDCEC); // filter chips, tags
  Color get surfaceBright         => const Color(0xFFD4D4E8); // hover states
  Color get navBar                => const Color(0xFFFFFFFF); // bottom nav

  // Text
  Color get onSurface             => const Color(0xFF12121E); // H1, H2 headlines
  Color get onSurfaceVariant      => const Color(0xFF5C3D36); // body, secondary text
  Color get textBody              => const Color(0xFF4A4A5A); // body copy
  Color get textMuted             => const Color(0xFF888899); // timestamps, hints
  Color get textDisabled          => const Color(0xFFAAAAAB); // disabled labels

  // Borders / Dividers
  Color get outline               => const Color(0xFF8A5E58); // card borders
  Color get outlineVariant        => const Color(0xFFE8D8D5); // subtle dividers
  Color get divider               => const Color(0xFFECECF4); // HR lines

  // Track / Progress
  Color get track                 => const Color(0xFFE0E0EC); // progress bar track
  Color get shimmer               => const Color(0xFFE8E8F0); // skeleton base
  Color get shimmerHighlight      => const Color(0xFFF4F4FC); // skeleton sweep

  // Primary container (light tint bg for buttons)
  Color get primaryContainer      => const Color(0xFFFFE8E4);

  // Tertiary (info / crowd level blue)
  Color get tertiary              => const Color(0xFF0077A8);
  Color get tertiaryContainer     => const Color(0xFFCEF2FF);
  Color get onTertiary            => const Color(0xFFFFFFFF);
}

// ───────────────────────────────────────────────────────────────────────────
// SEMANTIC COLORS — DARK
// ───────────────────────────────────────────────────────────────────────────
final class _SemanticDark {
  const _SemanticDark();

  // Success — confirmed bookings, verified badge, "Open" status
  Color get success          => const Color(0xFF22C55E);
  Color get successContainer => const Color(0xFF14532D);
  Color get onSuccess        => const Color(0xFFFFFFFF);

  // Warning — moderate crowd, pending booking, expiring session
  Color get warning          => const Color(0xFFF59E0B);
  Color get warningContainer => const Color(0xFF451A03);
  Color get onWarning        => const Color(0xFF000000);

  // Error — cancelled, full capacity, high crowd, payment failure
  Color get error            => const Color(0xFFEF4444);
  Color get errorContainer   => const Color(0xFF450A0A);
  Color get onError          => const Color(0xFFFFFFFF);

  // Info — informational chips, "Promoted" label bg
  Color get info             => const Color(0xFF64D4FC);
  Color get infoContainer    => const Color(0xFF0E3D4A);
  Color get onInfo           => const Color(0xFF000000);

  // Crowd levels — used on crowd indicator pill
  Color get crowdLow         => const Color(0xFF22C55E);  // low crowd
  Color get crowdModerate    => const Color(0xFFF59E0B);  // moderate crowd
  Color get crowdHigh        => const Color(0xFFEF4444);  // high crowd

  // Star rating
  Color get star             => const Color(0xFFF59E0B);
  Color get starEmpty        => const Color(0xFF37374D);
}

// ───────────────────────────────────────────────────────────────────────────
// SEMANTIC COLORS — LIGHT
// ───────────────────────────────────────────────────────────────────────────
final class _SemanticLight {
  const _SemanticLight();

  // Success
  Color get success          => const Color(0xFF16A34A);
  Color get successContainer => const Color(0xFFDCFCE7);
  Color get onSuccess        => const Color(0xFFFFFFFF);

  // Warning
  Color get warning          => const Color(0xFFD97706);
  Color get warningContainer => const Color(0xFFFEF3C7);
  Color get onWarning        => const Color(0xFF000000);

  // Error
  Color get error            => const Color(0xFFDC2626);
  Color get errorContainer   => const Color(0xFFFEE2E2);
  Color get onError          => const Color(0xFFFFFFFF);

  // Info
  Color get info             => const Color(0xFF0077A8);
  Color get infoContainer    => const Color(0xFFCEF2FF);
  Color get onInfo           => const Color(0xFF000000);

  // Crowd levels
  Color get crowdLow         => const Color(0xFF16A34A);
  Color get crowdModerate    => const Color(0xFFD97706);
  Color get crowdHigh        => const Color(0xFFDC2626);

  // Star rating
  Color get star             => const Color(0xFFD97706);
  Color get starEmpty        => const Color(0xFFDCDCEC);
}
