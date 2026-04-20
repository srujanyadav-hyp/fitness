import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Shorthand accessors for FitHub design tokens on any [BuildContext].
///
/// Usage:
///   ```dart
///   Container(color: context.cs.surface)           // Material ColorScheme
///   Text('…', style: TextStyle(color: context.fh.textMuted)) // FitHub tokens
///   if (context.isDark) { … }                       // mode guard
///   ```
extension AppThemeContext on BuildContext {
  /// The current Material [ColorScheme] (light or dark per system setting).
  ColorScheme get cs => Theme.of(this).colorScheme;

  /// The current [FitHubTheme] extension — custom tokens not in ColorScheme.
  FitHubTheme get fh => Theme.of(this).extension<FitHubTheme>()!;

  /// `true` when the device is in dark mode.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// `true` when the device is in light mode.
  bool get isLight => Theme.of(this).brightness == Brightness.light;
}
