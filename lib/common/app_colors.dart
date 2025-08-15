// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  // UGO 2 Theme - Metallic Blue Color Scheme
  // Primary metallic blue gradient colors
  static const Color primary =
      Color(0xFF00B4D8); // Bright cyan-blue (top of gradient)
  static const Color primaryDark =
      Color(0xFF0077B6); // Deep blue (bottom of gradient)
  static const Color primaryAccent =
      Color(0xFF48CAE4); // Light blue glow/outline

  // Secondary colors
  static const Color secondary = Color(0xFF023E8A); // Dark blue for contrast
  static const Color secondaryLight =
      Color(0xFF90E0EF); // Light blue for highlights

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey =
      Color(0xFF1A1A1A); // Very dark grey for dark theme
  static const Color lightGrey =
      Color(0xFFF8F9FA); // Very light grey for light theme

  // Light theme specific colors
  static const Color errorLight = Color(0xFFE63946); // Modern red
  static const Color onErrorLight =
      Color(0xFFFF6B6B); // Lighter red for contrast
  static const Color shadowColorLight = Color(0xFFE0E0E0); // Subtle shadow
  static const Color surfaceLight = Color(0xFFFFFFFF); // White surface
  static const Color onSurfaceLight =
      Color(0xFF1A1A1A); // Dark text on light surface

  // Dark theme specific colors
  static const Color secondaryDark =
      Color(0xFF48CAE4); // Bright blue for dark theme
  static const Color disabledColorDark = Color(0xFF6C757D); // Muted grey
  static const Color shadowColorDark = Color(0xFF2D2D2D); // Dark shadow
  static const Color surfaceDark = Color(0xFF121212); // Dark surface
  static const Color onSurfaceDark =
      Color(0xFFFFFFFF); // White text on dark surface

  // Common colors
  static const int primaryValue = 0xFF00B4D8;
  static const Color grey = Color(0xFF6C757D); // Neutral grey
  static const Color green = Color(0xFF52C41A); // Modern green
  static const Color lightGreen = Color(0xFF73D13D); // Light green
  static const Color greyHeader = Color(0xFF8E9AAF); // Muted blue-grey
  static const Color yellowColor = Color(0xFFFFD23F); // Modern yellow

  static const Color red = Color(0xFFE63946); // Modern red
  static const Color greyContainerColor = Color(0xFFF8F9FA); // Light container

  // Text colors
  static const Color greyHintColor = Color(0xFF6C757D);
  static Color textSelectionColor = primaryAccent.withOpacity(0.3);

  static const Color whiteText = Color(0xFFFFFFFF);
  static const Color blackText = Color(0xFF1A1A1A);
  static const Color commonColor = Color(0xFFE9ECEF); // Light neutral

  // Material colors
  static const MaterialColor blue = Colors.blue;
  static const MaterialColor orange = Colors.orange;

  // Button colors
  static const Color buttonColor = Color(0xFF00B4D8); // Primary blue
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color goldenColor = Color(0xFFFFD700);

  // Additional UGO 2 theme colors
  static const Color metallicBlue = Color(0xFF0096C7); // Metallic blue
  static const Color techBlue = Color(0xFF023E8A); // Technology blue
  static const Color glowBlue = Color(0xFF48CAE4); // Glow effect blue
  static const Color accentBlue = Color(0xFF90E0EF); // Accent blue
}
