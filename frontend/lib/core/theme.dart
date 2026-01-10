import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color secondary = Color(0xFFFDCB6E);
  static const Color accent = Color(0xFF00CEC9);
  static const Color bg = Color(0xFFFFFFFF);
  static const Color bgAlt = Color(0xFFF8F9FA);
  static const Color bgSoft = Color(0xFFFAF8FF);
  static const Color textMain = Color(0xFF2D3436);
  static const Color textMuted = Color(0xFF636E72);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.bg,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontWeight: FontWeight.w800,
          fontSize: 56,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontWeight: FontWeight.w800,
          fontSize: 40,
        ),
        titleMedium: GoogleFonts.outfit(
          color: AppColors.textMain,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.textMuted,
          fontSize: 18,
        ),
      ),
    );
  }

  static TextStyle get scriptStyle => GoogleFonts.patrickHand(
        fontSize: 1.15 * 18, // 1.15em
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      );
}
