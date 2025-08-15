import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemes {
  static ThemeData applicationDefaultTheme(BuildContext context) {
    ThemeData originalTheme = ThemeData.light();
    const String fontFamily = 'NotoSans';
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      primaryColorLight: AppColors.primaryAccent,
      primaryColorDark: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.surfaceLight,
      disabledColor: AppColors.greyHintColor,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      shadowColor: AppColors.shadowColorLight,
      hintColor: AppColors.grey,
      dividerColor: AppColors.grey,
      splashColor: AppColors.primaryAccent.withOpacity(0.1),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.textSelectionColor,
        selectionHandleColor: AppColors.primaryAccent,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.onSurfaceLight,
        onError: AppColors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        surfaceTintColor: AppColors.primary,
        elevation: 0,
        shadowColor: AppColors.primaryAccent.withOpacity(0.3),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 8,
        shadowColor: AppColors.primaryAccent.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      buttonTheme: originalTheme.buttonTheme.copyWith(
        textTheme: ButtonTextTheme.primary,
        minWidth: 30,
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primaryAccent.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: const TextStyle(color: AppColors.white),
        actionTextColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: GoogleFonts.notoSansTextTheme(originalTheme.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        bodyLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        bodyMedium: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: fontFamily,
            color: AppColors.onSurfaceLight),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        displayLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        displayMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        displaySmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: '$fontFamily-Bold',
          color: AppColors.primary,
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        labelMedium: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
        labelSmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceLight,
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        filled: true,
        fillColor: AppColors.greyContainerColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 4,
        shadowColor: AppColors.primaryAccent.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // DARK THEME
  static ThemeData darkTheme(BuildContext context) {
    ThemeData originalTheme = ThemeData.dark();
    const String fontFamily = 'NotoSans';
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      brightness: Brightness.dark,
      primaryColorLight: AppColors.primaryAccent,
      primaryColorDark: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      disabledColor: AppColors.disabledColorDark,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      shadowColor: AppColors.shadowColorDark,
      hintColor: AppColors.grey,
      dividerColor: AppColors.grey,
      splashColor: AppColors.primaryAccent.withOpacity(0.1),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.textSelectionColor,
        selectionHandleColor: AppColors.primaryAccent,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorLight,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.onSurfaceDark,
        onError: AppColors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.surfaceDark,
        surfaceTintColor: AppColors.primary,
        elevation: 0,
        shadowColor: AppColors.primaryAccent.withOpacity(0.3),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 8,
        shadowColor: AppColors.primaryAccent.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      buttonTheme: originalTheme.buttonTheme.copyWith(
        textTheme: ButtonTextTheme.primary,
        minWidth: 30,
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primaryAccent.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: const TextStyle(color: AppColors.white),
        actionTextColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: GoogleFonts.notoSansTextTheme(originalTheme.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        bodyLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        bodyMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        displayLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        displayMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        displaySmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.primary,
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: '$fontFamily-Bold',
          color: AppColors.primary,
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        labelMedium: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
        labelSmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          fontFamily: fontFamily,
          color: AppColors.onSurfaceDark,
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        filled: true,
        fillColor: AppColors.darkGrey,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkGrey,
        elevation: 4,
        shadowColor: AppColors.primaryAccent.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
