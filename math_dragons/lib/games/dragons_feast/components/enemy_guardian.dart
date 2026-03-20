import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show RadialGradient;

import '../models/enemy_type.dart';

/// An enemy guardian on the Dragon's Feast grid.
class EnemyGuardian extends PositionComponent {
  final EnemyData data;
  final double cellSize;
  bool isFrozen;

  EnemyGuardian({
    required this.data,
    required this.cellSize,
    this.isFrozen = false,
  }) : super(priority: 10) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset.zero;
    final radius = cellSize * 0.3;

    final Color bodyColor;
    switch (data.type) {
      case EnemyType.chaser:
        bodyColor = isFrozen
            ? const Color(0xFFAED6F1) // frozen: ice blue
            : const Color(0xFFC0392B); // dark red
      case EnemyType.wanderer:
        bodyColor = isFrozen
            ? const Color(0xFFD7BDE2) // frozen: light purple
            : const Color(0xFF8E44AD); // purple
    }

    // Body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [bodyColor, bodyColor.withAlpha(180)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Eyes
    final eyeRadius = radius * 0.18;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.15),
      eyeRadius,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.15),
      eyeRadius,
      Paint()..color = const Color(0xFFFFFFFF),
    );

    // Pupils
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.15),
      eyeRadius * 0.5,
      Paint()..color = const Color(0xFF000000),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.15),
      eyeRadius * 0.5,
      Paint()..color = const Color(0xFF000000),
    );

    // Type indicator
    if (data.type == EnemyType.chaser) {
      _drawFangs(canvas, center, radius);
    } else {
      _drawGlasses(canvas, center, radius);
    }
  }

  void _drawFangs(Canvas canvas, Offset center, double radius) {
    final fangPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    // Left fang
    final leftPath = Path()
      ..moveTo(center.dx - radius * 0.2, center.dy + radius * 0.2)
      ..lineTo(center.dx - radius * 0.1, center.dy + radius * 0.5)
      ..lineTo(center.dx, center.dy + radius * 0.2)
      ..close();
    canvas.drawPath(leftPath, fangPaint);

    // Right fang
    final rightPath = Path()
      ..moveTo(center.dx, center.dy + radius * 0.2)
      ..lineTo(center.dx + radius * 0.1, center.dy + radius * 0.5)
      ..lineTo(center.dx + radius * 0.2, center.dy + radius * 0.2)
      ..close();
    canvas.drawPath(rightPath, fangPaint);
  }

  void _drawGlasses(Canvas canvas, Offset center, double radius) {
    final glassPaint = Paint()
      ..color = const Color(0xFFAED6F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left lens
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.15),
      radius * 0.22,
      glassPaint,
    );
    // Right lens
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.15),
      radius * 0.22,
      glassPaint,
    );
    // Bridge
    canvas.drawLine(
      Offset(center.dx - radius * 0.03, center.dy - radius * 0.15),
      Offset(center.dx + radius * 0.03, center.dy - radius * 0.15),
      glassPaint,
    );
  }
}
