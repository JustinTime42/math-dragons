import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Alignment, FontWeight, LinearGradient, TextDirection, TextPainter, TextSpan, TextStyle;

import '../models/grid_cell.dart';

/// Visual states for a tile.
enum TileState { normal, eaten, correctFlash, wrongFlash }

/// Renders a single numbered tile on the grid.
class FeastTile extends PositionComponent {
  final GridCell cell;
  final double cellSize;
  TileState state;
  double flashTimer = 0;

  FeastTile({
    required this.cell,
    required this.cellSize,
    this.state = TileState.normal,
  }) : super(priority: 1);

  @override
  void update(double dt) {
    super.update(dt);
    if (state == TileState.correctFlash || state == TileState.wrongFlash) {
      flashTimer += dt;
      if (flashTimer >= 0.4) {
        state = TileState.eaten;
      }
    }
  }

  void triggerFlash(bool isCorrect) {
    state = isCorrect ? TileState.correctFlash : TileState.wrongFlash;
    flashTimer = 0;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, cellSize, cellSize);

    if (cell.isEaten && state != TileState.correctFlash && state != TileState.wrongFlash) {
      // Eaten tile: dim background
      final paint = Paint()
        ..color = const Color(0xFF1A3D2A).withAlpha(80);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      return;
    }

    // Flash background
    if (state == TileState.correctFlash) {
      final alpha = ((1.0 - flashTimer / 0.4) * 0.6).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = Color.fromRGBO(39, 174, 96, alpha);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      return;
    }

    if (state == TileState.wrongFlash) {
      final alpha = ((1.0 - flashTimer / 0.4) * 0.6).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = Color.fromRGBO(231, 76, 60, alpha);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      return;
    }

    // Normal tile background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E2744), Color(0xFF16213E)],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      bgPaint,
    );

    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFF3A4A6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      borderPaint,
    );

    // Draw number text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${cell.number}',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: _fitFontSize(cellSize, '${cell.number}'),
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF0E6D3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (cellSize - textPainter.width) / 2,
        (cellSize - textPainter.height) / 2,
      ),
    );
  }

  double _fitFontSize(double cellSize, String text) {
    double size = cellSize * 0.32;
    if (text.length >= 3) size *= 0.8;
    return size.clamp(14.0, 28.0);
  }
}
