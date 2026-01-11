import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

// Parfolio ColorScheme Definition
const ColorScheme parfolioColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary: Lime Green
  primary: Color(0xFF65A30D),           // Lime 500
  onPrimary: Color(0xFFFFFFFF),         // White
  primaryContainer: Color(0xFFDCFCE7),  // Lime 100
  onPrimaryContainer: Color(0xFF3F6212),// Lime 700

  // Secondary: Amber
  secondary: Color(0xFFF59E0B),         // Amber 500
  onSecondary: Color(0xFFFFFFFF),       // White
  secondaryContainer: Color(0xFFFEF3C7),// Amber 100
  onSecondaryContainer: Color(0xFFD97706), // Amber 600

  // Background
  // background: Color(0xFFFFFFFF),        // Deprecated
  // onBackground: Color(0xFF111827),      // Deprecated

  // Surface
  surface: Color(0xFFFFFFFF),           // White
  onSurface: Color(0xFF111827),         // Gray 900
  surfaceContainerHighest: Color(0xFFF9FAFB),    // Gray 50 (was surfaceVariant)
  onSurfaceVariant: Color(0xFF4B5563),  // Gray 600

  // Error
  error: Color(0xFFEF4444),             // Red 500
  onError: Color(0xFFFFFFFF),           // White
  errorContainer: Color(0xFFFEF2F2),    // Red 50
  onErrorContainer: Color(0xFF991B1B),  // Red 800

  // Outline
  outline: Color(0xFFD1D5DB),           // Gray 300
  outlineVariant: Color(0xFFE5E7EB),    // Gray 200

  // Shadow & Overlay
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: parfolioColorScheme,
      scaffoldBackgroundColor: parfolioColorScheme.surfaceContainerHighest, // Gray 50
      textTheme: parfolioTextTheme,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827), // Gray 900
        elevation: 0,
        centerTitle: false,
        titleTextStyle: parfolioTextTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111827),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF374151), // Gray 700
          size: 24,
        ),
        toolbarHeight: 64,
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF65A30D), // Lime 500
          foregroundColor: Colors.white,
          textStyle: parfolioTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 2,
          minimumSize: const Size(48, 48),
        ),
      ),

      // OutlinedButton Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF374151), // Gray 700
          textStyle: parfolioTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(
            color: Color(0xFFD1D5DB), // Gray 300
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: const Size(48, 48),
        ),
      ),

      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF3F6212), // Lime 700
          textStyle: parfolioTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(48, 36),
        ),
      ),
      
      // FloatingActionButton Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF65A30D), // Lime 500
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFFE5E7EB), // Gray 200
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB), // Gray 300
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF65A30D), // Lime 500
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444), // Error
            width: 2,
          ),
        ),
        labelStyle: parfolioTextTheme.labelMedium?.copyWith(
          color: const Color(0xFF374151), // Gray 700
        ),
        hintStyle: parfolioTextTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9CA3AF), // Gray 400
        ),
      ),

      // Extensions - Removed incorrect ColorScheme extension
      extensions: <ThemeExtension<dynamic>>[
        // Add custom extensions here if needed
      ],
    );
  }
}

// Preserve existing AppColors class for backward compatibility during migration
// This should be deprecated and removed once migration is complete
class AppColors {
  // Mapping old usage to new system
  static const Color primary = Color(0xFF65A30D); // New Lime 500
  static const Color secondary = Color(0xFFF59E0B); // New Amber 500
  static const Color accent = Color(0xFF00CEC9); // Teal (Keep for now)
  static const Color bg = Color(0xFFFFFFFF);
  static const Color bgAlt = Color(0xFFF9FAFB); // Gray 50
  static const Color bgSoft = Color(0xFFF3F4F6); // Gray 100
  static const Color textMain = Color(0xFF111827); // Gray 900
  static const Color textMuted = Color(0xFF4B5563); // Gray 600

  static Map<String, Color> get tagColors => parfolioColorScheme.tagColors;
}
