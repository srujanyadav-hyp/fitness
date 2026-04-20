import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// ═══════════════════════════════════════════════════════════════════════════
// THEME EXTENSION — custom FitHub tokens accessible via Theme.of(context)
// ═══════════════════════════════════════════════════════════════════════════

/// Custom design tokens that Material3 ColorScheme does not cover.
/// Access anywhere via: Theme.of(context).extension<FitHubTheme>()!
@immutable
final class FitHubTheme extends ThemeExtension<FitHubTheme> {
  const FitHubTheme({
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceVariant,
    required this.surfaceBright,
    required this.textMuted,
    required this.textDisabled,
    required this.divider,
    required this.track,
    required this.shimmer,
    required this.shimmerHighlight,
    required this.navBar,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.crowdLow,
    required this.crowdModerate,
    required this.crowdHigh,
    required this.star,
    required this.starEmpty,
    required this.tertiary,
    required this.tertiaryContainer,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceVariant;
  final Color surfaceBright;
  final Color textMuted;
  final Color textDisabled;
  final Color divider;
  final Color track;
  final Color shimmer;
  final Color shimmerHighlight;
  final Color navBar;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color crowdLow;
  final Color crowdModerate;
  final Color crowdHigh;
  final Color star;
  final Color starEmpty;
  final Color tertiary;
  final Color tertiaryContainer;

  // ── Dark mode extension values ───────────────────────────────────────────
  static const FitHubTheme dark = FitHubTheme(
    surfaceContainer:     Color(0xFF1E1E32),
    surfaceContainerHigh: Color(0xFF28283D),
    surfaceVariant:       Color(0xFF333348),
    surfaceBright:        Color(0xFF37374D),
    textMuted:            Color(0xFF888899),
    textDisabled:         Color(0xFF555566),
    divider:              Color(0xFF1E1E32),
    track:                Color(0xFF2A2B38),
    shimmer:              Color(0xFF2A2B38),
    shimmerHighlight:     Color(0xFF37374D),
    navBar:               Color(0xFF111125),
    success:              Color(0xFF22C55E),
    successContainer:     Color(0xFF14532D),
    warning:              Color(0xFFF59E0B),
    warningContainer:     Color(0xFF451A03),
    crowdLow:             Color(0xFF22C55E),
    crowdModerate:        Color(0xFFF59E0B),
    crowdHigh:            Color(0xFFEF4444),
    star:                 Color(0xFFF59E0B),
    starEmpty:            Color(0xFF37374D),
    tertiary:             Color(0xFF64D4FC),
    tertiaryContainer:    Color(0xFF0E3D4A),
  );

  // ── Light mode extension values ──────────────────────────────────────────
  static const FitHubTheme light = FitHubTheme(
    surfaceContainer:     Color(0xFFF0F0F8),
    surfaceContainerHigh: Color(0xFFE8E8F4),
    surfaceVariant:       Color(0xFFDCDCEC),
    surfaceBright:        Color(0xFFD4D4E8),
    textMuted:            Color(0xFF888899),
    textDisabled:         Color(0xFFAAAAAB),
    divider:              Color(0xFFECECF4),
    track:                Color(0xFFE0E0EC),
    shimmer:              Color(0xFFE8E8F0),
    shimmerHighlight:     Color(0xFFF4F4FC),
    navBar:               Color(0xFFFFFFFF),
    success:              Color(0xFF16A34A),
    successContainer:     Color(0xFFDCFCE7),
    warning:              Color(0xFFD97706),
    warningContainer:     Color(0xFFFEF3C7),
    crowdLow:             Color(0xFF16A34A),
    crowdModerate:        Color(0xFFD97706),
    crowdHigh:            Color(0xFFDC2626),
    star:                 Color(0xFFD97706),
    starEmpty:            Color(0xFFDCDCEC),
    tertiary:             Color(0xFF0077A8),
    tertiaryContainer:    Color(0xFFCEF2FF),
  );

  @override
  FitHubTheme copyWith({
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceVariant,
    Color? surfaceBright,
    Color? textMuted,
    Color? textDisabled,
    Color? divider,
    Color? track,
    Color? shimmer,
    Color? shimmerHighlight,
    Color? navBar,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? crowdLow,
    Color? crowdModerate,
    Color? crowdHigh,
    Color? star,
    Color? starEmpty,
    Color? tertiary,
    Color? tertiaryContainer,
  }) {
    return FitHubTheme(
      surfaceContainer:     surfaceContainer     ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceVariant:       surfaceVariant       ?? this.surfaceVariant,
      surfaceBright:        surfaceBright        ?? this.surfaceBright,
      textMuted:            textMuted            ?? this.textMuted,
      textDisabled:         textDisabled         ?? this.textDisabled,
      divider:              divider              ?? this.divider,
      track:                track                ?? this.track,
      shimmer:              shimmer              ?? this.shimmer,
      shimmerHighlight:     shimmerHighlight     ?? this.shimmerHighlight,
      navBar:               navBar               ?? this.navBar,
      success:              success              ?? this.success,
      successContainer:     successContainer     ?? this.successContainer,
      warning:              warning              ?? this.warning,
      warningContainer:     warningContainer     ?? this.warningContainer,
      crowdLow:             crowdLow             ?? this.crowdLow,
      crowdModerate:        crowdModerate        ?? this.crowdModerate,
      crowdHigh:            crowdHigh            ?? this.crowdHigh,
      star:                 star                 ?? this.star,
      starEmpty:            starEmpty            ?? this.starEmpty,
      tertiary:             tertiary             ?? this.tertiary,
      tertiaryContainer:    tertiaryContainer    ?? this.tertiaryContainer,
    );
  }

  @override
  FitHubTheme lerp(FitHubTheme? other, double t) {
    if (other is! FitHubTheme) return this;
    return FitHubTheme(
      surfaceContainer:     Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceVariant:       Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceBright:        Color.lerp(surfaceBright, other.surfaceBright, t)!,
      textMuted:            Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled:         Color.lerp(textDisabled, other.textDisabled, t)!,
      divider:              Color.lerp(divider, other.divider, t)!,
      track:                Color.lerp(track, other.track, t)!,
      shimmer:              Color.lerp(shimmer, other.shimmer, t)!,
      shimmerHighlight:     Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      navBar:               Color.lerp(navBar, other.navBar, t)!,
      success:              Color.lerp(success, other.success, t)!,
      successContainer:     Color.lerp(successContainer, other.successContainer, t)!,
      warning:              Color.lerp(warning, other.warning, t)!,
      warningContainer:     Color.lerp(warningContainer, other.warningContainer, t)!,
      crowdLow:             Color.lerp(crowdLow, other.crowdLow, t)!,
      crowdModerate:        Color.lerp(crowdModerate, other.crowdModerate, t)!,
      crowdHigh:            Color.lerp(crowdHigh, other.crowdHigh, t)!,
      star:                 Color.lerp(star, other.star, t)!,
      starEmpty:            Color.lerp(starEmpty, other.starEmpty, t)!,
      tertiary:             Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer:    Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP THEME
// ═══════════════════════════════════════════════════════════════════════════

/// Global [ThemeData] for FitHub — dark and light.
///
/// Usage in MaterialApp:
///   theme:      AppTheme.light,
///   darkTheme:  AppTheme.dark,
///   themeMode:  ThemeMode.system,   // or ThemeMode.dark to force
///
/// Access custom tokens anywhere:
///   final fh = Theme.of(context).extension<FitHubTheme>()!;
///   fh.crowdLow  → correct color for current mode
final class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppColors.dark.background,

      colorScheme: ColorScheme.dark(
        surface:            AppColors.dark.surface,
        onSurface:          AppColors.dark.onSurface,
        primary:            AppColors.primary,
        onPrimary:          AppColors.white,
        primaryContainer:   AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary:          AppColors.dark.surfaceContainer,
        onSecondary:        AppColors.dark.onSurfaceVariant,
        error:              AppColors.darkSemantic.error,
        onError:            AppColors.white,
        outline:            AppColors.dark.outline,
        outlineVariant:     AppColors.dark.outlineVariant,
      ),

      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor:    AppColors.dark.background,
        surfaceTintColor:   Colors.transparent,
        elevation:          0,
        centerTitle:        true,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.dark.onSurface,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:             Colors.transparent,
          statusBarIconBrightness:    Brightness.light,
          statusBarBrightness:        Brightness.dark,
          systemNavigationBarColor:   Color(0xFF111125),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:       AppColors.dark.navBar,
        selectedItemColor:     AppColors.primary,
        unselectedItemColor:   AppColors.dark.textMuted,
        selectedLabelStyle:    GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:  GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:      AppColors.dark.navBar,
        indicatorColor:       AppColors.primaryContainer.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(color: AppColors.dark.textMuted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.dark.textMuted,
          );
        }),
      ),

      cardTheme: CardThemeData(
        color:         AppColors.dark.surface,
        surfaceTintColor: Colors.transparent,
        elevation:     0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.dark.outlineVariant, width: 0.5),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:          true,
        fillColor:       AppColors.dark.surfaceContainer,
        hintStyle:       GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.dark.textMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.dark.outlineVariant, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkSemantic.error, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:   AppColors.primary,
          foregroundColor:   AppColors.white,
          elevation:         0,
          minimumSize:       const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:  AppColors.primary,
          minimumSize:      const Size.fromHeight(48),
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor:    AppColors.dark.surfaceVariant,
        selectedColor:      AppColors.primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500),
        side: BorderSide(color: AppColors.dark.outlineVariant, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      dividerTheme: DividerThemeData(
        color:     AppColors.dark.divider,
        thickness: 0.5,
        space:     1,
      ),

      extensions: const [FitHubTheme.dark],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppColors.light.background,

      colorScheme: ColorScheme.light(
        surface:            AppColors.light.surface,
        onSurface:          AppColors.light.onSurface,
        primary:            AppColors.primaryDark,
        onPrimary:          AppColors.white,
        primaryContainer:   AppColors.light.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary:          AppColors.light.surfaceContainer,
        onSecondary:        AppColors.light.onSurfaceVariant,
        error:              AppColors.lightSemantic.error,
        onError:            AppColors.white,
        outline:            AppColors.light.outline,
        outlineVariant:     AppColors.light.outlineVariant,
      ),

      textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor:    AppColors.light.surface,
        surfaceTintColor:   Colors.transparent,
        elevation:          0,
        centerTitle:        true,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.light.onSurface,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:             Colors.transparent,
          statusBarIconBrightness:    Brightness.dark,
          statusBarBrightness:        Brightness.light,
          systemNavigationBarColor:   Color(0xFFFFFFFF),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:       AppColors.light.navBar,
        selectedItemColor:     AppColors.primaryDark,
        unselectedItemColor:   AppColors.light.textMuted,
        selectedLabelStyle:    GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:  GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:      AppColors.light.navBar,
        indicatorColor:       AppColors.primaryDark.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primaryDark, size: 24);
          }
          return IconThemeData(color: AppColors.light.textMuted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            );
          }
          return GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.light.textMuted,
          );
        }),
      ),

      cardTheme: CardThemeData(
        color:            AppColors.light.surface,
        surfaceTintColor: Colors.transparent,
        elevation:        0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.light.outlineVariant, width: 0.5),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:          true,
        fillColor:       AppColors.light.surfaceContainer,
        hintStyle:       GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.light.textMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.light.outlineVariant, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightSemantic.error, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:  AppColors.primaryDark,
          foregroundColor:  AppColors.white,
          elevation:        0,
          minimumSize:      const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:  AppColors.primaryDark,
          minimumSize:      const Size.fromHeight(48),
          side: BorderSide(color: AppColors.primaryDark, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor:    AppColors.light.surfaceVariant,
        selectedColor:      AppColors.primaryDark.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500),
        side: BorderSide(color: AppColors.light.outlineVariant, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      dividerTheme: DividerThemeData(
        color:     AppColors.light.divider,
        thickness: 0.5,
        space:     1,
      ),

      extensions: const [FitHubTheme.light],
    );
  }
}
