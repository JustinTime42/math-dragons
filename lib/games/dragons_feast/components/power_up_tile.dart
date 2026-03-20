import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show FontWeight, TextDirection, TextPainter, TextSpan, TextStyle;

import '../models/power_up_type.dart';

/// A power-up tile with pulsing glow effect.
/// Renders a sprite icon when available, falling back to text symbols.
class PowerUpTileComponent extends PositionComponent
    with HasGameReference<FlameGame> {
  final PowerUpType type;
  final double cellSize;
  double pulseTimer = 0;
  ui.Image? _image;

  PowerUpTileComponent({
    required this.type,
    required this.cellSize,
  }) : super(priority: 1);

  /// Flame image path (relative to assets/images/).
  String get _imagePath => switch (type) {
        PowerUpType.freeze => 'games/dragons_feast/feast_powerup_freeze.png',
        PowerUpType.wings => 'games/dragons_feast/feast_powerup_wings.png',
        PowerUpType.shield => 'games/dragons_feast/feast_powerup_shield.png',
      };

  @override
  Future<void> onLoad() async {
    try {
      _image = await game.images.load(_imagePath);
    } catch (_) {
      // Fallback to text rendering if image fails to load.
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    pulseTimer += dt;
  }

  @override
  void render(ui.Canvas canvas) {
    final rect = ui.Rect.fromLTWH(0, 0, cellSize, cellSize);
    final pulse = 0.8 + 0.2 * sin(pulseTimer * 4);

    final ui.Color glowColor;
    switch (type) {
      case PowerUpType.freeze:
        glowColor = const ui.Color(0xFFAED6F1);
      case PowerUpType.wings:
        glowColor = const ui.Color(0xFFF4A261);
      case PowerUpType.shield:
        glowColor = const ui.Color(0xFF5DADE2);
    }

    // Glow
    final glowPaint = ui.Paint()
      ..color = glowColor.withAlpha((0.3 * pulse * 255).round())
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(rect, const ui.Radius.circular(4)),
      glowPaint,
    );

    // Background
    final bgPaint = ui.Paint()
      ..color = glowColor.withAlpha((0.2 * 255).round());
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(rect, const ui.Radius.circular(4)),
      bgPaint,
    );

    // Sprite or fallback text
    if (_image != null) {
      _renderSprite(canvas);
    } else {
      _renderTextFallback(canvas, glowColor);
    }
  }

  void _renderSprite(ui.Canvas canvas) {
    final img = _image!;
    final srcRect = ui.Rect.fromLTWH(
      0,
      0,
      img.width.toDouble(),
      img.height.toDouble(),
    );
    // Inset slightly so the icon doesn't fill the entire cell
    final inset = cellSize * 0.15;
    final dstRect = ui.Rect.fromLTWH(inset, inset, cellSize - inset * 2, cellSize - inset * 2);
    canvas.drawImageRect(img, srcRect, dstRect, ui.Paint());
  }

  void _renderTextFallback(ui.Canvas canvas, ui.Color glowColor) {
    final String icon = switch (type) {
      PowerUpType.freeze => '*',
      PowerUpType.wings => 'W',
      PowerUpType.shield => 'S',
    };
    final textPainter = TextPainter(
      text: TextSpan(
        text: icon,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: cellSize * 0.35,
          fontWeight: FontWeight.bold,
          color: glowColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      ui.Offset(
        (cellSize - textPainter.width) / 2,
        (cellSize - textPainter.height) / 2,
      ),
    );
  }
}
