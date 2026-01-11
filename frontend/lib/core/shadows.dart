import 'package:flutter/material.dart';

class Shadows {
  // Subtle shadow for cards
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  // Default shadow for elevated elements
  static List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // Strong shadow for hover/focus states
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Extra large shadow for modals
  static List<BoxShadow> get xl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Dramatic shadow for special effects
  static List<BoxShadow> get xxl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
