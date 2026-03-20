import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show LinearGradient, StrokeCap, StrokeJoin;

/// A glowing line connecting nodes in the chain.
class ConnectionLine extends PositionComponent {
  List<Vector2> points; // node centers in chain order
  Vector2? pointerPos; // current pointer during active drag

  ConnectionLine({
    this.points = const [],
    this.pointerPos,
  });

  @override
  void render(Canvas canvas) {
    final allPoints = [...points];
    if (pointerPos != null) allPoints.add(pointerPos!);
    if (allPoints.length < 2) return;

    // Glow line (wider, semi-transparent)
    final glowPaint = Paint()
      ..color = const Color(0xFF66E3FF).withValues(alpha: 0.2)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Main line (thinner, gradient)
    final mainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFBB8FCE), Color(0xFFF7C08A)], // purple -> gold
      ).createShader(Rect.fromLTRB(
        allPoints.first.x,
        allPoints.first.y,
        allPoints.last.x,
        allPoints.last.y,
      ))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(allPoints[0].x, allPoints[0].y);
    for (int i = 1; i < allPoints.length; i++) {
      path.lineTo(allPoints[i].x, allPoints[i].y);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, mainPaint);
  }
}
