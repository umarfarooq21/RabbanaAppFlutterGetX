import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme-aware colors for 40 Rabbana. Read with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentText,
    required this.surface,
    required this.surfaceHigh,
    required this.surfaceLow,
    required this.orbCenter,
    required this.orbEdge,
    required this.playerGradient,
  });

  /// Top-to-bottom page gradient.
  final List<Color> background;
  final Color textPrimary;
  final Color textSecondary;

  /// Gold used for borders, icons and highlights.
  final Color accent;

  /// Gold that is readable as text on [background].
  final Color accentText;

  /// Translucent fills for chips, fields and cards.
  final Color surface;
  final Color surfaceHigh;
  final Color surfaceLow;

  final Color orbCenter;
  final Color orbEdge;
  final List<Color> playerGradient;

  static final dark = AppPalette(
    background: const [Color(0xFF0E3B30), AppColors.night, AppColors.nightDeep],
    textPrimary: AppColors.ivory,
    textSecondary: AppColors.mist,
    accent: AppColors.gold,
    accentText: AppColors.goldSoft,
    surface: Colors.white.withValues(alpha: 0.05),
    surfaceHigh: Colors.white.withValues(alpha: 0.075),
    surfaceLow: Colors.white.withValues(alpha: 0.035),
    orbCenter: AppColors.emeraldSoft.withValues(alpha: 0.55),
    orbEdge: AppColors.night,
    playerGradient: [
      AppColors.emerald.withValues(alpha: 0.45),
      Colors.white.withValues(alpha: 0.05),
      AppColors.night.withValues(alpha: 0.9),
    ],
  );

  static final light = AppPalette(
    background: const [Color(0xFFFBF7EC), Color(0xFFF5EEDC), Color(0xFFEDE3CA)],
    textPrimary: AppColors.night,
    textSecondary: const Color(0xC70B2A22),
    accent: const Color(0xFF9A7820),
    accentText: const Color(0xFF7E6110),
    surface: Colors.white.withValues(alpha: 0.6),
    surfaceHigh: Colors.white.withValues(alpha: 0.85),
    surfaceLow: Colors.white.withValues(alpha: 0.5),
    orbCenter: AppColors.goldSoft.withValues(alpha: 0.45),
    orbEdge: const Color(0xFFFBF7EC),
    playerGradient: [
      AppColors.emerald.withValues(alpha: 0.16),
      Colors.white.withValues(alpha: 0.7),
      AppColors.goldSoft.withValues(alpha: 0.35),
    ],
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> l(List<Color> a, List<Color> b) => [
      for (var i = 0; i < a.length; i++) c(a[i], b[i]),
    ];
    return AppPalette(
      background: l(background, other.background),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      accent: c(accent, other.accent),
      accentText: c(accentText, other.accentText),
      surface: c(surface, other.surface),
      surfaceHigh: c(surfaceHigh, other.surfaceHigh),
      surfaceLow: c(surfaceLow, other.surfaceLow),
      orbCenter: c(orbCenter, other.orbCenter),
      orbEdge: c(orbEdge, other.orbEdge),
      playerGradient: l(playerGradient, other.playerGradient),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}
