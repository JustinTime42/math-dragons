import '../games/shared/math_problem.dart';

/// Grammar for practice-item keys stored in fact history.
///
/// Arithmetic facts: "7x8", "13-4", "12/3", "3+5" (commutative ops have
/// left <= right). Number-property items: "mult_3:12", "prime:17",
/// "range_10_20:15". See docs/specs/adaptive-practice.md section 7, I-3.
abstract final class PracticeKey {
  /// "7x8", "13-4", "12/3", "3+5". Commutative ops have left <= right.
  static final RegExp arithmetic = RegExp(r'^(\d{1,3})([+\-x/])(\d{1,3})$');

  /// "mult_3:12", "prime:17", "range_10_20:15".
  static final RegExp property = RegExp(r'^([a-z][a-z0-9_]*):(\d{1,3})$');

  /// True when [key] matches either grammar and, for arithmetic keys, is
  /// canonical, has a positive integer result, and divides evenly with a
  /// divisor >= 2.
  static bool isValid(String key) => isArithmetic(key) || isProperty(key);

  /// True for a valid arithmetic fact key (see [isValid]).
  static bool isArithmetic(String key) {
    final match = arithmetic.firstMatch(key);
    if (match == null) return false;
    final left = int.parse(match.group(1)!);
    final op = match.group(2)!;
    final right = int.parse(match.group(3)!);
    switch (op) {
      case '+':
        return left <= right && left + right > 0;
      case 'x':
        return left <= right && left * right > 0;
      case '-':
        return left - right > 0;
      case '/':
        return right >= 2 && left % right == 0 && left ~/ right > 0;
    }
    return false;
  }

  /// True for a number-property key such as "prime:17".
  static bool isProperty(String key) => property.hasMatch(key);

  static String forFact(MathFact fact) => fact.factKey;

  static String forProperty(String categoryId, int n) => '$categoryId:$n';
}
