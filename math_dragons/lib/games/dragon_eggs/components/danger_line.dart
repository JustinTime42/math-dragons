import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Visual danger line at the top of the play field.
class DangerLine extends PositionComponent {
  final double lineWidth;

  DangerLine({required double y, required this.lineWidth})
      : super(
          position: Vector2(0, y),
          size: Vector2(lineWidth, 4),
        );

  @override
  void render(Canvas canvas) {
    // Semi-transparent red gradient line
    final gradient = LinearGradient(
      colors: [
        const Color(0x00E74C3C),
        const Color(0x88E74C3C),
        const Color(0x00E74C3C),
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, lineWidth, 4),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, lineWidth, 4), paint);

    // Dashed line effect
    final dashPaint = Paint()
      ..color = const Color(0x44E74C3C)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const gapWidth = 6.0;
    double x = 0;
    while (x < lineWidth) {
      canvas.drawLine(
        Offset(x, 2),
        Offset(x + dashWidth, 2),
        dashPaint,
      );
      x += dashWidth + gapWidth;
    }
  }
}
