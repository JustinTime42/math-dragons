import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors, FontWeight, RadialGradient;
import '../models/rune_node_data.dart';

/// Visual state of a rune node.
enum NodeState { idle, inChain, correct, incorrect, hinted }

/// A single rune node rendered as a circle with text.
class RuneNode extends PositionComponent {
  final RuneNodeData data;
  final int index;
  final double nodeRadius;
  NodeState state;
  double hintAnimTime = 0;

  RuneNode({
    required this.data,
    required this.index,
    required this.nodeRadius,
    this.state = NodeState.idle,
  }) : super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    if (state == NodeState.hinted) {
      hintAnimTime += dt;
    }
  }

  @override
  void render(Canvas canvas) {
    const center = Offset(0, 0);

    // Glow for non-idle states
    if (state == NodeState.inChain) {
      _drawGlow(canvas, center, const Color(0xFF66E3FF), 0.3);
    } else if (state == NodeState.correct) {
      _drawGlow(canvas, center, const Color(0xFF9EFF6A), 0.4);
    } else if (state == NodeState.incorrect) {
      _drawGlow(canvas, center, const Color(0xFFFF6B6B), 0.4);
    } else if (state == NodeState.hinted) {
      _drawGlow(canvas, center, const Color(0xFFFFD54A), _hintPulse());
    }

    // Node background
    final Color bgStart, bgEnd;
    switch (data.type) {
      case RuneNodeType.number:
        bgStart = const Color(0xFF1E2350);
        bgEnd = const Color(0xFF151A40);
      case RuneNodeType.operator:
        bgStart = const Color(0xFF2A2540);
        bgEnd = const Color(0xFF1A1530);
      case RuneNodeType.equals:
        bgStart = const Color(0xFF3A3520);
        bgEnd = const Color(0xFF2A2510);
    }

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [bgStart, bgEnd],
      ).createShader(Rect.fromCircle(center: center, radius: nodeRadius));
    canvas.drawCircle(center, nodeRadius, bgPaint);

    // Border
    final borderColor = switch (state) {
      NodeState.inChain => const Color(0xFF66E3FF),
      NodeState.correct => const Color(0xFF9EFF6A),
      NodeState.incorrect => const Color(0xFFFF6B6B),
      NodeState.hinted => const Color(0xFFFFD54A),
      NodeState.idle => const Color(0xFF4A4A6A),
    };
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, nodeRadius, borderPaint);

    // Text
    final textColor = data.type == RuneNodeType.number
        ? Colors.white
        : const Color(0xFFF4A261); // gold for operators
    _drawText(canvas, data.value, textColor);
  }

  void _drawGlow(Canvas canvas, Offset center, Color color, double alpha) {
    final glowPaint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, nodeRadius + 6, glowPaint);
  }

  double _hintPulse() {
    return 0.3 + 0.3 * sin(hintAnimTime * 10);
  }

  void _drawText(Canvas canvas, String text, Color color) {
    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: nodeRadius * 0.7,
      fontFamily: 'Nunito',
    ))
      ..pushStyle(TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: nodeRadius * 0.7,
      ))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: nodeRadius * 2));

    canvas.drawParagraph(
      paragraph,
      Offset(-nodeRadius, -paragraph.height / 2),
    );
  }
}
