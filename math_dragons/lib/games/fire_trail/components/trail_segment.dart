import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show RadialGradient;

class TrailSegmentComponent extends PositionComponent {
  final int indexFromHead;
  final int totalLength;
  final double flameIntensity;

  TrailSegmentComponent({
    required this.indexFromHead,
    required this.totalLength,
    required this.flameIntensity,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final progress =
        totalLength > 0 ? indexFromHead / totalLength : 0.0;
    final intensity = flameIntensity;

    final coreColor = Color.lerp(
      Color.lerp(
        const Color(0xFFE74C3C),
        const Color(0xFFFFF3B0),
        progress,
      ),
      const Color(0xFF3D1F00),
      1.0 - intensity,
    )!;

    final rect = Rect.fromLTWH(1, 1, size.x - 2, size.y - 2);
    final borderRadius = size.x * 0.15;
    final center = Offset(size.x / 2, size.y / 2);
    final glowRadius = size.x * 0.6;

    if (progress < 0.5 && intensity > 0.3) {
      final glowAlpha = (0.25 * intensity * (1.0 - progress * 2)).clamp(0.0, 1.0);
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            coreColor.withValues(alpha: glowAlpha),
            coreColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
      canvas.drawCircle(center, glowRadius, glowPaint);
    }

    final baseAlpha = (0.7 + intensity * 0.3).clamp(0.0, 1.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      Paint()..color = coreColor.withValues(alpha: baseAlpha),
    );

    if (intensity > 0.4 && progress < 0.7) {
      final innerRect = Rect.fromLTWH(
        size.x * 0.25,
        size.y * 0.25,
        size.x * 0.5,
        size.y * 0.5,
      );
      final innerColor = Color.lerp(coreColor, const Color(0xFFFFF9C4), 0.3)!;
      final innerAlpha = (0.4 * intensity * (1.0 - progress)).clamp(0.0, 1.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius * 0.5)),
        Paint()..color = innerColor.withValues(alpha: innerAlpha),
      );
    }
  }
}
