/// Types of eggs.
enum EggType { number, operator }

/// Visual/physics state of an egg.
enum EggState { active, selected, popping, dead }

/// Operator symbols used in equations.
enum MathOp {
  add,
  subtract,
  multiply,
  divide;

  String get symbol {
    switch (this) {
      case MathOp.add:
        return '+';
      case MathOp.subtract:
        return '\u2212'; // minus sign
      case MathOp.multiply:
        return '\u00D7'; // multiplication sign
      case MathOp.divide:
        return '\u00F7'; // division sign
    }
  }

  /// Key character for fact key normalization.
  String get keyChar {
    switch (this) {
      case MathOp.add:
        return '+';
      case MathOp.subtract:
        return '-';
      case MathOp.multiply:
        return 'x';
      case MathOp.divide:
        return '/';
    }
  }
}
