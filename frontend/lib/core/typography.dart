import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme get parfolioTextTheme {
  return TextTheme(
    // Display: Large hero headlines
    displayLarge: GoogleFonts.libreBaskerville(
      fontSize: 56,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -1.0,
      color: const Color(0xFF111827), // Gray 900
    ),
    displayMedium: GoogleFonts.libreBaskerville(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
      color: const Color(0xFF111827),
    ),
    displaySmall: GoogleFonts.libreBaskerville(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.25,
      color: const Color(0xFF111827),
    ),

    // Headline: Section headers
    headlineLarge: GoogleFonts.libreBaskerville(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    headlineMedium: GoogleFonts.libreBaskerville(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    headlineSmall: GoogleFonts.libreBaskerville(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.35,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),

    // Title: Card titles, dialog headers
    titleLarge: GoogleFonts.libreBaskerville(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),

    // Body: Paragraph text
    bodyLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0,
      color: const Color(0xFF374151), // Gray 700
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0,
      color: const Color(0xFF374151),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF4B5563), // Gray 600
    ),

    // Label: Buttons, labels, small UI text
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.15,
      color: const Color(0xFF111827),
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.15,
      color: const Color(0xFF4B5563),
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.2,
      color: const Color(0xFF4B5563),
    ),
  );
}
