import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_palette.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(Brightness.dark, AppPalette.dark);
  static ThemeData get light => _build(Brightness.light, AppPalette.light);

  static ThemeData _build(Brightness brightness, AppPalette palette) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background.last,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.emerald,
        brightness: brightness,
        primary: isDark ? AppColors.emeraldSoft : AppColors.emerald,
        secondary: palette.accent,
        surface: isDark ? AppColors.night : const Color(0xFFFBF7EC),
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      extensions: [palette],
    );
  }
}

/// Status/navigation bar styling that matches the current theme.
SystemUiOverlayStyle overlayStyleFor(BuildContext context) {
  final isDark = context.isDarkTheme;
  final iconBrightness = isDark ? Brightness.light : Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: iconBrightness,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: context.palette.background.last,
    systemNavigationBarIconBrightness: iconBrightness,
  );
}

/// Full-screen themed gradient that also sets the system bar style.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.stops});

  final Widget child;
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyleFor(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: context.palette.background,
            stops: stops,
          ),
        ),
        child: child,
      ),
    );
  }
}
