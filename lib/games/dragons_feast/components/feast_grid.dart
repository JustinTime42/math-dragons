import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Alignment, LinearGradient;

/// Renders the 5x5 grid background for Dragon's Feast.
class FeastGrid extends PositionComponent {
  final int gridSize;
  final double cellSize;
  final double gap;
  final double offsetX;
  final double offsetY;

  FeastGrid({
    required this.gridSize,
    required this.cellSize,
    required this.gap,
    required this.offsetX,
    required this.offsetY,
  }) : super(priority: 0);

  @override
  void render(Canvas canvas) {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final rect = Rect.fromLTWH(
          offsetX + x * (cellSize + gap),
          offsetY + y * (cellSize + gap),
          cellSize,
          cellSize,
        );

        // Cell background
        final cellPaint = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2744), Color(0xFF16213E)],
          ).createShader(rect);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          cellPaint,
        );

        // Subtle border
        final borderPaint = Paint()
          ..color = const Color(0xFF2A3A5A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          borderPaint,
        );
      }
    }
  }
}
