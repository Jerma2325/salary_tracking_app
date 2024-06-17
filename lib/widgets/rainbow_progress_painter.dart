import 'package:flutter/material.dart';

class RainbowProgressPainter extends CustomPainter {
  final double progress;

  RainbowProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 10.0;
    final double radius = (size.width / 2.5) - (strokeWidth / 2);

    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.deepPurple,
      ],
      stops: [0.0, 0.14, 0.28, 0.42, 0.57, 0.71, 0.85],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = size.center(Offset.zero);

    // Draw the background arc (gray)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14, // Start angle (bottom of the circle)
      3.14, // Sweep angle (half of the circle)
      false,
      backgroundPaint,
    );

    // Draw the progress arc (rainbow)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14, // Start angle (bottom of the circle)
      3.14 * progress, // Sweep angle (half of the circle, scaled by progress)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
