import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography tokens.
/// headline → Lexend (bold, all-caps wordmarks)
/// body     → Manrope (body copy, taglines)
abstract final class AppTextStyles {
  AppTextStyles._();

  /// Large wordmark — "FitHub" in the splash logo.
  static TextStyle get headline => GoogleFonts.lexend(
        fontSize: 60,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -2,
        height: 1,
      );

  /// Sub-label inside the splash (e.g. tagline).
  static TextStyle get tagline => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textBody,
        letterSpacing: 3.5,
      );

  // ── Onboarding ─────────────────────────────────────────────────────────────

  /// Large screen headline (headline-lg: 32px / 40px line-height).
  static TextStyle get headlineLg => GoogleFonts.lexend(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
        letterSpacing: -0.5,
        height: 1.25,
      );

  /// Body copy (body-md: 16px / 24px).
  static TextStyle get bodyMd => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      );

  /// Button / label (label-md: 14px, bold, wide tracking).
  static TextStyle get labelMd => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      );

  /// Screen 3 gauge big number.
  static TextStyle get gaugeNumber => GoogleFonts.lexend(
        fontSize: 60,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        letterSpacing: -2,
        height: 1,
      );

  /// Screen 3 gauge unit ("%").
  static TextStyle get gaugeUnit => GoogleFonts.lexend(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
      );

  /// Screen 3 "FULL" label under gauge.
  static TextStyle get gaugeLabel => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 2,
      );
}
