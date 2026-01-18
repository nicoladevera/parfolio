import 'package:flutter/material.dart';

extension ParfolioColors on ColorScheme {
  // Lime Scale
  Color get lime50 => const Color(0xFFF7FEE7);
  Color get lime100 => const Color(0xFFDCFCE7);
  Color get lime200 => const Color(0xFFBEF264);
  Color get lime300 => const Color(0xFFA3E635);
  Color get lime400 => const Color(0xFF84CC16);
  Color get lime500 => const Color(0xFF65A30D);
  Color get lime600 => const Color(0xFF4D7C0F);
  Color get lime700 => const Color(0xFF3F6212);
  Color get lime800 => const Color(0xFF365314);
  Color get lime900 => const Color(0xFF1A2E05);

  // Amber Scale
  Color get amber50 => const Color(0xFFFFFBEB);
  Color get amber100 => const Color(0xFFFEF3C7);
  Color get amber200 => const Color(0xFFFDE68A); // Added for completeness if needed
  Color get amber300 => const Color(0xFFFCD34D);
  Color get amber400 => const Color(0xFFFBBF24);
  Color get amber500 => const Color(0xFFF59E0B);
  Color get amber600 => const Color(0xFFD97706);
  
  // Gray Scale
  Color get gray50 => const Color(0xFFF9FAFB);
  Color get gray100 => const Color(0xFFF3F4F6);
  Color get gray200 => const Color(0xFFE5E7EB);
  Color get gray300 => const Color(0xFFD1D5DB);
  Color get gray400 => const Color(0xFF9CA3AF);
  Color get gray500 => const Color(0xFF6B7280); // Added for completeness
  Color get gray600 => const Color(0xFF4B5563);
  Color get gray700 => const Color(0xFF374151);
  Color get gray800 => const Color(0xFF1F2937); // Added for completeness
  Color get gray900 => const Color(0xFF111827);

  // Semantic Colors
  Color get success => const Color(0xFF10B981);
  Color get successBg => const Color(0xFFECFDF5);
  Color get warning => const Color(0xFFF97316);
  Color get warningBg => const Color(0xFFFFF7ED);
  Color get info => const Color(0xFF3B82F6);
  Color get infoBg => const Color(0xFFEFF6FF);

  Color get teal => const Color(0xFF00CEC9);
  Color get tealBg => const Color(0xFFE0F7F6);
  // Error is already in ColorScheme as 'error' and 'errorContainer'

  // Tag Colors
  Map<String, Color> get tagColors => {
    'Leadership': const Color(0xFF8B5CF6),
    'Communication': const Color(0xFF00CEC9),
    'Impact': const Color(0xFFF59E0B),
    'Problem-Solving': const Color(0xFFE17055),
    'Collaboration': const Color(0xFF60A5FA),
    'Strategic Thinking': const Color(0xFFA78BFA),
    'Innovation': const Color(0xFFF87171),
    'Adaptability': const Color(0xFF34D399),
  };
}
