import 'package:flutter/material.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColors.light);
  static ThemeData get dark => _build(AppColors.dark);

  static ThemeData _build(AppPalette p) {
    final scheme = ColorScheme(
      brightness: p.brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondary: p.secondary,
      onSecondary: p.onPrimary,
      error: AppColors.error,
      onError: AppColors.white,
      surface: p.surface,
      onSurface: p.textPrimary,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.surface,
      dividerColor: p.border,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.primary,
        selectionHandleColor: p.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
      ),
    );
  }
}
