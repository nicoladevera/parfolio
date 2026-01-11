import 'package:flutter/material.dart';

/// Simple wavy line decoration for auth screen backgrounds
class WavyLineDecoration extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const WavyLineDecoration({
    Key? key,
    required this.color,
    this.width = 120,
    this.height = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: WavyLinePainter(color: color),
      ),
    );
  }
}

/// Custom painter for wavy lines
class WavyLinePainter extends CustomPainter {
  final Color color;

  WavyLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw smooth wave
    path.moveTo(0, size.height / 2);

    // Create wave using quadratic bezier curves
    double waveWidth = size.width / 3;
    double amplitude = size.height / 4;

    for (int i = 0; i < 3; i++) {
      double startX = i * waveWidth;
      double controlX = startX + waveWidth / 2;
      double endX = startX + waveWidth;

      // Alternate wave direction
      double controlY = i % 2 == 0
        ? size.height / 2 - amplitude
        : size.height / 2 + amplitude;

      path.quadraticBezierTo(
        controlX, controlY,
        endX, size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
