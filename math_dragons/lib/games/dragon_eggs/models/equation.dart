import 'dart:math';
import 'egg_data.dart';

/// Result of evaluating a player-built equation.
class EquationResult {
  final int left;
  final MathOp op;
  final int right;
  final int playerAnswer;
  final int correctAnswer;
  final bool isCorrect;
  final String factKey;

  EquationResult({
    required this.left,
    required this.op,
    required this.right,
    required this.playerAnswer,
  })  : correctAnswer = _compute(left, op, right),
        isCorrect = playerAnswer == _compute(left, op, right) &&
            _compute(left, op, right) > 0,
        factKey = _buildFactKey(left, op, right);

  static int _compute(int a, MathOp op, int b) {
    switch (op) {
      case MathOp.add:
        return a + b;
      case MathOp.subtract:
        return a - b;
      case MathOp.multiply:
        return a * b;
      case MathOp.divide:
        return b != 0 ? a ~/ b : 0;
    }
  }

  static String _buildFactKey(int a, MathOp op, int b) {
    final opChar = op.keyChar;

    // For commutative ops, put smaller number first
    if (op == MathOp.add || op == MathOp.multiply) {
      final lo = min(a, b);
      final hi = max(a, b);
      return '$lo$opChar$hi';
    }
    return '$a$opChar$b';
  }
}
