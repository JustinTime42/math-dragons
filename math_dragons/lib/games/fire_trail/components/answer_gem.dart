import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class AnswerGemComponent extends PositionComponent {
  final int value;
  final bool isCorrect;

  AnswerGemComponent({
    required this.value,
    required this.isCorrect,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final gemRadius = size.x * 0.38;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2A9D8F).withValues(alpha: 0.25),
          const Color(0xFF2A9D8F).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: gemRadius * 1.5));
    canvas.drawCircle(center, gemRadius * 1.5, glowPaint);

    final path = _gemPath(center, gemRadius);

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3AAFA9), Color(0xFF2D6E74), Color(0xFF1A4A4F)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: gemRadius));
    canvas.drawPath(path, fillPaint);

    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - gemRadius * 0.85);
    highlightPath.lineTo(center.dx - gemRadius * 0.3, center.dy - gemRadius * 0.2);
    highlightPath.lineTo(center.dx + gemRadius * 0.15, center.dy - gemRadius * 0.25);
    highlightPath.close();
    canvas.drawPath(
      highlightPath,
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF2A9D8F).withValues(alpha: 0.6);
    canvas.drawPath(path, borderPaint);

    _drawText(canvas, '$value');
  }

  Path _gemPath(Offset center, double r) {
    return Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r * 0.7, center.dy - r * 0.3)
      ..lineTo(center.dx + r * 0.55, center.dy + r * 0.7)
      ..lineTo(center.dx - r * 0.55, center.dy + r * 0.7)
      ..lineTo(center.dx - r * 0.7, center.dy - r * 0.3)
      ..close();
  }

  void _drawText(Canvas canvas, String text) {
    final fontSize = text.length <= 2 ? size.x * 0.36 : size.x * 0.28;

    final shadowBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: fontSize,
      fontFamily: 'Nunito',
    ))
      ..pushStyle(ui.TextStyle(
        color: const Color(0xFF0A2A2A),
        fontWeight: FontWeight.bold,
      ))
      ..addText(text);
    final shadowParagraph = shadowBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));
    final textY = (size.y - shadowParagraph.height) / 2;
    canvas.drawParagraph(shadowParagraph, Offset(1, textY + 1));

    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: fontSize,
      fontFamily: 'Nunito',
    ))
      ..pushStyle(ui.TextStyle(
        color: const Color(0xFFF0E6D3),
        fontWeight: FontWeight.bold,
      ))
      ..addText(text);
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));
    canvas.drawParagraph(paragraph, Offset(0, textY));
  }
}
