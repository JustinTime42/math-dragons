import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Alignment, LinearGradient;

class GridRenderer extends PositionComponent {
  final int gridSize;
  final double cellSize;
  late final List<_Star> _stars;

  GridRenderer({required this.gridSize, required this.cellSize})
      : super(size: Vector2.all(gridSize * cellSize)) {
    final rng = Random(42);
    final fieldSize = gridSize * cellSize;
    _stars = List.generate(30, (_) => _Star(
      x: rng.nextDouble() * fieldSize,
      y: rng.nextDouble() * fieldSize * 0.6,
      radius: 0.5 + rng.nextDouble() * 1.0,
      alpha: 0.2 + rng.nextDouble() * 0.4,
    ));
  }

  @override
  void render(Canvas canvas) {
    final fieldSize = gridSize * cellSize;

    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
      ).createShader(Rect.fromLTWH(0, 0, fieldSize, fieldSize));
    canvas.drawRect(Rect.fromLTWH(0, 0, fieldSize, fieldSize), bgPaint);

    for (final star in _stars) {
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.radius,
        Paint()..color = Color.fromRGBO(255, 255, 255, star.alpha),
      );
    }

    final lavaGlowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [
          const Color(0xFFE74C3C).withValues(alpha: 0.06),
          const Color(0xFFE74C3C).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, fieldSize, fieldSize));
    canvas.drawRect(Rect.fromLTWH(0, 0, fieldSize, fieldSize), lavaGlowPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF2A2A4A).withValues(alpha: 0.25)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= gridSize; i++) {
      final pos = i * cellSize;
      canvas.drawLine(Offset(pos, 0), Offset(pos, fieldSize), linePaint);
      canvas.drawLine(Offset(0, pos), Offset(fieldSize, pos), linePaint);
    }

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF2A2A4A).withValues(alpha: 0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, fieldSize, fieldSize), borderPaint);
  }
}

class _Star {
  final double x;
  final double y;
  final double radius;
  final double alpha;

  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.alpha,
  });
}
