import 'package:flutter/material.dart';

/// Ripple/Flower decoration for auth screens (Option 1)
class RippleDecoration extends StatelessWidget {
  final Color color;
  final double size;

  const RippleDecoration({
    Key? key,
    required this.color,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: RipplePainter(color: color),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Color color;

  RipplePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw 3 concentric organic rings (ripples)
    // We'll use circles for simplicity but could make them slightly irregular
    // to look more organic if desired later.
    
    // Inner ripple
    canvas.drawCircle(center, size.width * 0.15, paint);
    
    // Middle ripple
    canvas.drawCircle(center, size.width * 0.3, paint);
    
    // Outer ripple
    canvas.drawCircle(center, size.width * 0.45, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
