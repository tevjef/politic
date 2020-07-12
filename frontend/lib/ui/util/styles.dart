import 'package:flutter/material.dart';

class Styles {

  static TextStyle headline5(ThemeData themeData) {
    return new TextStyle(
      color: themeData.colorScheme.onSurface, fontSize: 20.0, fontWeight: FontWeight.w700, fontFamily: "Poppins");
  }

  static TextStyle headline6(ThemeData themeData) {
    return new TextStyle(
      color: themeData.colorScheme.onSurface, fontSize: 14.0, fontWeight: FontWeight.w700, fontFamily: "Poppins");
  }

  static TextStyle body2(ThemeData themeData) {
    return new TextStyle(
      height: 1.6,
      color: themeData.colorScheme.onSurface, fontSize: 14.0, fontWeight: FontWeight.w400, fontFamily: "Poppins");
  }

  static TextStyle subtitle2(ThemeData themeData) {
    return new TextStyle(
      height: 1.7,
      color: themeData.colorScheme.onSurface, fontSize: 14.0, fontWeight: FontWeight.w400, fontFamily: "Poppins");
  }

  static TextStyle body1Primary = new TextStyle(
      color: Colors.black, fontSize: 12.0, fontFamily: "ProductSans");

  static TextStyle body1PrimaryInverse = new TextStyle(
      color: Colors.white, fontSize: 12.0, fontFamily: "ProductSans");

  static TextStyle body2Primary = new TextStyle(
      color: Colors.black, fontSize: 14.0, fontFamily: "ProductSans");

  static TextStyle body2PrimaryInverse = new TextStyle(
      color: Colors.white, fontSize: 14.0, fontFamily: "ProductSans");

  static TextStyle body1Secondary = new TextStyle(
      color: Colors.black54,
      fontSize: 10.0,
      fontStyle: FontStyle.italic,
      fontFamily: "ProductSans");

  static TextStyle body1SecondaryInverse = new TextStyle(
      color: Colors.white,
      fontSize: 10.0,
      fontStyle: FontStyle.italic,
      fontFamily: "ProductSans");

  static TextStyle caption =
      new TextStyle(fontFamily: "ProductSans", fontWeight: FontWeight.bold);

  static TextStyle sectionHeader = new TextStyle(
      color: Colors.black,
      letterSpacing: 0.6,
      fontSize: 12.toDouble(),
      fontFamily: "ProductSans",
      fontWeight: FontWeight.bold);

  static TextStyle sectionHeaderLight = new TextStyle(
      color: Colors.black,
      letterSpacing: 0.6,
      fontSize: 12.toDouble(),
      fontFamily: "ProductSans",
      fontWeight: FontWeight.normal);

  static TextStyle sectionLargeHeader = new TextStyle(
      color: Colors.black,
      letterSpacing: 0.6,
      fontSize: 26.toDouble(),
      fontFamily: "ProductSans",
      fontWeight: FontWeight.bold);
}

class AppColors {
  static Color uctGreen = const Color(0x4CAF50);
  static Color uctRed = const Color(0xF44336);

  static MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{
    50: const Color(0xFFFAFAFA),
    100: const Color(0xFFF5F5F5),
    200: const Color(0xFFEEEEEE),
    300: const Color(0xFFE0E0E0),
    350: const Color(
        0xFFD6D6D6), // only for raised button while pressed in light theme
    400: const Color(0xFFBDBDBD),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFF757575),
    700: const Color(0xFF616161),
    800: const Color(0xFF424242),
    850: const Color(0xFF303030), // only for background color in dark theme
    900: const Color(0xFF212121),
  });
}

class Dimens {
  static const double spacingNone = 0.0;
  static const double spacingXthin = 1.0;
  static const double spacingThin = 2.0;
  static const double spacingXsmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingStandard = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXlarge = 24.0;
  static const double spacingXxlarge = 36.0;
  static const double spacingXxxlarge = 48.0;
}
