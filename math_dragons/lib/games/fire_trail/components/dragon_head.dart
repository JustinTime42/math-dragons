import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors, RadialGradient;

import '../models/grid_position.dart';

class DragonHeadComponent extends PositionComponent {
  Direction facing;
  double flameIntensity;

  DragonHeadComponent({
    required this.facing,
    required this.flameIntensity,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.4;
    final brightness = 0.5 + flameIntensity * 0.5;

    final headColor = Color.lerp(
      const Color(0xFF8B2500),
      const Color(0xFFE74C3C),
      brightness,
    )!;

    _drawGlow(canvas, center, radius, headColor);

    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(headColor, Colors.white, 0.15)!,
          headColor,
          headColor.withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    _drawHorns(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawSnout(canvas, center, radius);
  }

  void _drawGlow(Canvas canvas, Offset center, double radius, Color color) {
    final glowRadius = radius * 1.6;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.3 * flameIntensity),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);
  }

  void _drawHorns(Canvas canvas, Offset center, double radius) {
    final hornColor = Color.lerp(
      const Color(0xFF5C1A00),
      const Color(0xFFD4843A),
      flameIntensity,
    )!;
    final hornPaint = Paint()
      ..color = hornColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final angle = atan2(facing.dy.toDouble(), facing.dx.toDouble());
    final perpAngle = angle + pi / 2;

    final hornBase1 = Offset(
      center.dx + cos(perpAngle) * radius * 0.35,
      center.dy + sin(perpAngle) * radius * 0.35,
    );
    final hornTip1 = Offset(
      hornBase1.dx + cos(perpAngle + 0.3) * radius * 0.5,
      hornBase1.dy + sin(perpAngle + 0.3) * radius * 0.5,
    );
    canvas.drawLine(hornBase1, hornTip1, hornPaint);

    final hornBase2 = Offset(
      center.dx - cos(perpAngle) * radius * 0.35,
      center.dy - sin(perpAngle) * radius * 0.35,
    );
    final hornTip2 = Offset(
      hornBase2.dx - cos(perpAngle + 0.3) * radius * 0.5,
      hornBase2.dy - sin(perpAngle + 0.3) * radius * 0.5,
    );
    canvas.drawLine(hornBase2, hornTip2, hornPaint);
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final angle = atan2(facing.dy.toDouble(), facing.dx.toDouble());
    final perpAngle = angle + pi / 2;

    for (final side in [-1.0, 1.0]) {
      final eyeCenter = Offset(
        center.dx + cos(angle) * radius * 0.2 + cos(perpAngle) * radius * 0.22 * side,
        center.dy + sin(angle) * radius * 0.2 + sin(perpAngle) * radius * 0.22 * side,
      );

      canvas.drawCircle(
        eyeCenter,
        radius * 0.13,
        Paint()..color = const Color(0xFFFFF9C4),
      );

      final pupilOffset = Offset(
        eyeCenter.dx + cos(angle) * radius * 0.04,
        eyeCenter.dy + sin(angle) * radius * 0.04,
      );
      canvas.drawCircle(
        pupilOffset,
        radius * 0.06,
        Paint()..color = const Color(0xFF1A0F3D),
      );
    }
  }

  void _drawSnout(Canvas canvas, Offset center, double radius) {
    final tipDist = radius * 0.75;
    final tipX = center.dx + facing.dx * tipDist;
    final tipY = center.dy + facing.dy * tipDist;

    final perpDx = -facing.dy.toDouble();
    final perpDy = facing.dx.toDouble();
    final baseOffset = radius * 0.25;

    final path = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(
        center.dx + facing.dx * radius * 0.35 + perpDx * baseOffset,
        center.dy + facing.dy * radius * 0.35 + perpDy * baseOffset,
      )
      ..lineTo(
        center.dx + facing.dx * radius * 0.35 - perpDx * baseOffset,
        center.dy + facing.dy * radius * 0.35 - perpDy * baseOffset,
      )
      ..close();

    final snoutColor = Color.lerp(
      const Color(0xFF5C1A00),
      const Color(0xFFF4A261),
      flameIntensity,
    )!;

    canvas.drawPath(
      path,
      Paint()..color = snoutColor.withValues(alpha: 0.9),
    );

    if (flameIntensity > 0.5) {
      final nostrilOffset = radius * 0.08;
      final nostrilPaint = Paint()..color = const Color(0xFFFF6B35).withValues(alpha: 0.7);
      for (final side in [-1.0, 1.0]) {
        canvas.drawCircle(
          Offset(
            tipX - facing.dx * radius * 0.1 + perpDx * nostrilOffset * side,
            tipY - facing.dy * radius * 0.1 + perpDy * nostrilOffset * side,
          ),
          radius * 0.05,
          nostrilPaint,
        );
      }
    }
  }
}
