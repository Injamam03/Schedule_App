import 'package:flutter/material.dart';

/// Semantic colours for one brightness. Widgets read these through
/// [AppColors.of] so every screen follows Light / Dark automatically.
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.shadow,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color shadow;
  final Color gradientStart;
  final Color gradientEnd;

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gradientStart, gradientEnd],
      );
}

/// Deep Azure / Muted Navy design palette.
class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary1 = Color(0xFF80A6D5);
  static const Color primary2 = Color(0xFF99B8DD);
  static const Color primary3 = Color(0xFFB3CAE6);
  static const Color primary4 = Color(0xFFCCDBEE);
  static const Color primary5 = Color(0xFFE6EDF7);

  // Secondary palette
  static const Color secondary1 = Color(0xFF406796);
  static const Color secondary2 = Color(0xFF4D6C91);
  static const Color secondary3 = Color(0xFF5A718D);
  static const Color secondary4 = Color(0xFF667689);
  static const Color secondary5 = Color(0xFF737B84);

  // Dark navy palette
  static const Color navy1 = Color(0xFF002756);
  static const Color navy2 = Color(0xFF001F44);
  static const Color navy3 = Color(0xFF001733);
  static const Color navy4 = Color(0xFF000F22);

  static const Color white = Color(0xFFFFFFFF);

  // Status colours (muted so they sit well on the navy palette)
  static const Color success = Color(0xFF2E9E6B);
  static const Color error = Color(0xFFD64B4B);
  static const Color cancelled = secondary5;

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    primary: secondary1,
    onPrimary: white,
    secondary: primary1,
    background: primary5,
    surface: white,
    surfaceVariant: primary5,
    textPrimary: navy3,
    textSecondary: secondary3,
    textHint: secondary5,
    border: primary4,
    shadow: Color(0x1A002756),
    gradientStart: navy1,
    gradientEnd: secondary1,
  );

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    primary: primary1,
    onPrimary: navy4,
    secondary: secondary1,
    background: navy4,
    surface: navy3,
    surfaceVariant: navy2,
    textPrimary: primary5,
    textSecondary: primary2,
    textHint: secondary5,
    border: navy1,
    shadow: Color(0x00000000),
    gradientStart: secondary1,
    gradientEnd: navy1,
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
