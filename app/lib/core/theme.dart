import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF6C5CE7);      // Vibrant Purple
  static const primaryLight = Color(0xFFA29BFE); // Soft Lavender
  static const secondary = Color(0xFFFDCB6E);    // Sunflower Yellow
  static const accent = Color(0xFF00CEC9);       // Teal/Cyan
  static const background = Color(0xFFFFFFFF);   // White
  static const backgroundSoft = Color(0xFFFAF8FF); // Soft Lavender
  static const textMain = Color(0xFF2D3436);     // Dark Charcoal
  static const textMuted = Color(0xFF636E72);    // Grey
  static const inputBorder = Color(0xFFDFE6E9);  // Light Grey
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontWeight: FontWeight.w800,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
