import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Sunburst/Spark decoration for auth screens (Option 1)
class SunburstDecoration extends StatelessWidget {
  final Color color;
  final double size;

  const SunburstDecoration({
    Key? key,
    required this.color,
    this.size = 140,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SunburstPainter(color: color),
      ),
    );
  }
}

class SunburstPainter extends CustomPainter {
  final Color color;

  SunburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw 8 rays/sparks
    for (int i = 0; i < 8; i++) {
        final angle = (i * 2 * math.pi) / 8;
        // Inner point (start of ray)
        final innerX = center.dx + (radius * 0.5) * math.cos(angle);
        final innerY = center.dy + (radius * 0.5) * math.sin(angle);
        
        // Outer point (end of ray)
        final outerX = center.dx + radius * math.cos(angle);
        final outerY = center.dy + radius * math.sin(angle);
        
        canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), paint);
    }

    // Draw a small central circle/ring
    canvas.drawCircle(center, radius * 0.25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
