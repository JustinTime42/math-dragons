import 'dart:ui';
import 'package:flame/components.dart';

/// Background decorative ring behind the rune nodes.
class CircleRing extends PositionComponent {
  final double cx;
  final double cy;
  final double radius;

  CircleRing({required this.cx, required this.cy, required this.radius});

  @override
  void render(Canvas canvas) {
    // Subtle ring outline
    final ringPaint = Paint()
      ..color = const Color(0xFF9B59B6).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // Inner glow ring
    final glowPaint = Paint()
      ..color = const Color(0xFF9B59B6).withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawCircle(Offset(cx, cy), radius, glowPaint);
  }
}
