import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show RadialGradient;

import '../../fire_trail/models/grid_position.dart';

/// The player's dragon character on the grid.
class DragonCharacter extends PositionComponent {
  Direction facing = Direction.right;
  bool isInvulnerable = false;
  bool hasWings = false;
  bool hasShield = false;

  final double cellSize;
  final Image? dragonImage;

  DragonCharacter({required this.cellSize, this.dragonImage})
      : super(priority: 10) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset.zero;
    final radius = cellSize * 0.35;

    // Invulnerability flicker
    final alpha = isInvulnerable
        ? (0.4 +
            0.6 *
                ((DateTime.now().millisecondsSinceEpoch % 200) > 100
                    ? 1.0
                    : 0.0))
        : 1.0;

    if (dragonImage != null) {
      _renderImage(canvas, center, radius, alpha);
    } else {
      _renderPlaceholder(canvas, center, radius, alpha);
    }

    // Power-up effects layered on top
    if (hasWings) {
      // Golden tint overlay
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = Color.fromRGBO(244, 162, 97, alpha * 0.3),
      );
    }

    if (hasShield) {
      canvas.drawCircle(
        center,
        radius * 1.2,
        Paint()
          ..color = Color.fromRGBO(93, 173, 226, alpha * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  void _renderImage(
      Canvas canvas, Offset center, double radius, double alpha) {
    final img = dragonImage!;
    final srcRect = Rect.fromLTWH(
      0,
      0,
      img.width.toDouble(),
      img.height.toDouble(),
    );
    // Draw the image scaled to fit within the cell (diameter = cellSize * 0.7)
    final diameter = cellSize * 0.7;
    final dstRect = Rect.fromCenter(
      center: center,
      width: diameter,
      height: diameter,
    );
    final paint = Paint();
    if (alpha < 1.0) {
      paint.color = Color.fromRGBO(255, 255, 255, alpha);
    }
    canvas.drawImageRect(img, srcRect, dstRect, paint);
  }

  void _renderPlaceholder(
      Canvas canvas, Offset center, double radius, double alpha) {
    // Body color depends on power-up state
    final Color bodyColor;
    if (hasWings) {
      bodyColor = const Color(0xFFF4A261); // gold shimmer
    } else if (hasShield) {
      bodyColor = const Color(0xFF5DADE2); // blue
    } else {
      bodyColor = const Color(0xFF27AE60); // treasure green
    }

    // Body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          bodyColor.withAlpha((alpha * 255).round()),
          bodyColor.withAlpha((alpha * 0.7 * 255).round()),
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Eye
    final eyeOffset = Offset(
      center.dx + facing.dx * radius * 0.35,
      center.dy + facing.dy * radius * 0.35,
    );
    canvas.drawCircle(
      eyeOffset,
      radius * 0.12,
      Paint()..color = Color.fromRGBO(255, 255, 255, alpha),
    );
    canvas.drawCircle(
      eyeOffset,
      radius * 0.06,
      Paint()..color = Color.fromRGBO(0, 0, 0, alpha),
    );

    // Horns
    _drawHorns(canvas, center, radius, alpha);
  }

  void _drawHorns(Canvas canvas, Offset center, double radius, double alpha) {
    final hornPaint = Paint()
      ..color = Color.fromRGBO(212, 132, 58, alpha)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.6),
      Offset(center.dx - radius * 0.5, center.dy - radius * 1.0),
      hornPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.6),
      Offset(center.dx + radius * 0.5, center.dy - radius * 1.0),
      hornPaint,
    );
  }
}
