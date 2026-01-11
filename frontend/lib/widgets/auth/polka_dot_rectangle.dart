import 'package:flutter/material.dart';
import 'dart:math';

/// Decorative polka dot rectangle component for auth screens
class PolkaDotRectangle extends StatelessWidget {
  final Color bgColor;
  final Color dotColor;
  final double width;
  final double height;
  final double rotation;

  const PolkaDotRectangle({
    Key? key,
    required this.bgColor,
    required this.dotColor,
    required this.width,
    required this.height,
    this.rotation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * pi / 180, // Convert degrees to radians
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomPaint(
          painter: PolkaDotPainter(dotColor: dotColor),
        ),
      ),
    );
  }
}

/// Custom painter for polka dots pattern
class PolkaDotPainter extends CustomPainter {
  final Color dotColor;

  PolkaDotPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const dotRadius = 4.0;
    const spacing = 16.0;

    // Draw grid of dots
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
