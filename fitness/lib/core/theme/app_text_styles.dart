import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// FitHub typography system — complete.
///
/// Two fonts, one clear rule:
///   Lexend   → impact: headlines, gym names, prices, screen titles, numbers
///   Manrope  → function: body copy, buttons, labels, captions, nav, inputs
///
/// Colour is ALWAYS passed in via the calling widget or resolved via Theme.
/// The only exceptions are styles that are used exclusively on the dark splash
/// or onboarding screens, where the colour is baked in by design contract.
abstract final class AppTextStyles {
  AppTextStyles._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LEXEND — headlines, wordmarks, prices, big numbers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Splash wordmark — "FITHUB" 60px ultra-bold.
  /// Color hardcoded to primary (only used on dark splash screen).
  static TextStyle get headline => GoogleFonts.lexend(
        fontSize: 60,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -2,
        height: 1,
      );

  /// Onboarding slide main headline — 32px.
  /// Color hardcoded to onSurface (dark onboarding only).
  static TextStyle get headlineLg => GoogleFonts.lexend(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
        letterSpacing: -0.5,
        height: 1.25,
      );

  /// Revenue / analytics large numbers — e.g. "₹42,800".
  /// Pass color via copyWith at call site.
  static TextStyle get displayLg => GoogleFonts.lexend(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.1,
      );

  /// Gym name on detail page hero, booking confirmed heading.
  static TextStyle get titleXl => GoogleFonts.lexend(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// Screen titles (AppBar title), section group headings.
  static TextStyle get titleLg => GoogleFonts.lexend(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.3,
      );

  /// In-card section headings — "Pricing Plans", "Our Trainers".
  static TextStyle get titleMd => GoogleFonts.lexend(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Smaller section headings — "Near You", "Gyms for You".
  static TextStyle get titleSm => GoogleFonts.lexend(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
      );

  /// Large price display on plan cards — "₹1,499".
  static TextStyle get priceLg => GoogleFonts.lexend(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1,
      );

  /// Inline price on gym list cards.
  static TextStyle get priceMd => GoogleFonts.lexend(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
      );

  // ── Onboarding gauge — kept from original ──────────────────────────────

  /// Onboarding slide 3 crowd percentage — "72".
  static TextStyle get gaugeNumber => GoogleFonts.lexend(
        fontSize: 60,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        letterSpacing: -2,
        height: 1,
      );

  /// Onboarding slide 3 "%" unit.
  static TextStyle get gaugeUnit => GoogleFonts.lexend(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // MANROPE — body copy, functional UI, buttons, inputs, navigation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Splash tagline — "FIND YOUR GYM. OWN YOUR FITNESS."
  /// Wide tracking by design. Color hardcoded (splash only).
  static TextStyle get tagline => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textBody,
        letterSpacing: 3.5,
      );

  /// Onboarding body copy — slide descriptions.
  /// Color hardcoded to onSurfaceVariant (dark onboarding only).
  static TextStyle get bodyMd => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      );

  /// General large body — gym bios, review text, long descriptions.
  /// Pass color via copyWith.
  static TextStyle get bodyLg => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  /// General small body — secondary info: distance, hours, area name.
  static TextStyle get bodySm => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Very small body — supporting text on cards, subtext under stats.
  static TextStyle get bodyXs => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Primary CTA button text — "Book Now", "Pay Now", "Get Started".
  static TextStyle get buttonLg => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  /// Secondary / outlined button text — "Cancel", "See All".
  static TextStyle get buttonSm => GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  /// Filter chips, status pills, badge text — "Open Now", "Promoted".
  static TextStyle get labelMd => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      );

  /// Smaller chips, amenity labels — "AC", "Pool".
  static TextStyle get labelSm => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      );

  /// Timestamps, review counts — "2h ago", "128 reviews".
  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.4,
      );

  /// Section category labels — "TODAY", "NEAR YOU", "THIS WEEK".
  /// Always rendered in ALL CAPS at call site via .toUpperCase().
  static TextStyle get overline => GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
      );

  /// TextField input value text.
  static TextStyle get inputText => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// TextField hint / placeholder text.
  static TextStyle get inputHint => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Bottom navigation tab labels.
  static TextStyle get navLabel => GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  /// Onboarding gauge "FULL" label.
  static TextStyle get gaugeLabel => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 2,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS — convenience methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Resolve the correct text color from the current BuildContext theme.
  /// Use this when a style needs to adapt to light/dark at runtime.
  ///
  /// Example:
  ///   Text('Gym Name', style: AppTextStyles.titleXl.themed(context))
  static TextStyleThemeHelper get _helper => const TextStyleThemeHelper();
}

/// Adds .themed(context) to any TextStyle — resolves onSurface colour
/// automatically from the active ThemeData.
extension TextStyleTheme on TextStyle {
  TextStyle themed(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.onSurface);

  TextStyle secondary(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6));

  TextStyle primary(BuildContext context) =>
      copyWith(color: Theme.of(context).colorScheme.primary);
}

class TextStyleThemeHelper {
  const TextStyleThemeHelper();
}
