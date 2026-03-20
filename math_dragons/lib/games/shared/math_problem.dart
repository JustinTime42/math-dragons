import '../dragon_eggs/models/egg_data.dart';

/// A single math fact with its components.
class MathFact {
  final int left;
  final MathOp op;
  final int right;
  final int result;

  MathFact({required this.left, required this.op, required this.right})
      : result = _compute(left, op, right);

  String get factKey {
    final opChar = op.keyChar;
    // For commutative ops, put smaller number first
    if (op == MathOp.add || op == MathOp.multiply) {
      final lo = left < right ? left : right;
      final hi = left < right ? right : left;
      return '$lo$opChar$hi';
    }
    return '$left$opChar$right';
  }

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
}

/// Generate all valid math facts for a given difficulty configuration.
List<MathFact> generateFacts({
  required int numberMin,
  required int numberMax,
  required List<MathOp> operations,
  required int resultMax,
}) {
  final facts = <MathFact>[];

  for (final op in operations) {
    for (int a = numberMin; a <= numberMax; a++) {
      for (int b = numberMin; b <= numberMax; b++) {
        // Subtraction: a must be > b (positive results only)
        if (op == MathOp.subtract && a <= b) continue;

        // Division: must divide evenly
        if (op == MathOp.divide) {
          if (b < 2) continue; // don't divide by 0 or 1
          if (a % b != 0) continue; // integer results only
        }

        final result = MathFact._compute(a, op, b);
        if (result <= 0 || result > resultMax) continue;

        // For commutative ops: only store canonical form (a >= b)
        if ((op == MathOp.add || op == MathOp.multiply) && a < b) continue;

        facts.add(MathFact(left: a, op: op, right: b));
      }
    }
  }

  return facts;
}
