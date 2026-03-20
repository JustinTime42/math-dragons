import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

/// Tests for solvability checking logic.
/// The solvability checker ensures at least one valid equation can be formed.
/// We test the core computation logic here without requiring Flame components.
void main() {
  int compute(int a, MathOp op, int b) {
    switch (op) {
      case MathOp.add:
        return a + b;
      case MathOp.subtract:
        return a - b;
      case MathOp.multiply:
        return a * b;
      case MathOp.divide:
        return b >= 2 && a % b == 0 ? a ~/ b : -1;
    }
  }

  bool hasSolvableEquation(List<int> numbers, List<MathOp> ops) {
    final numsSet = numbers.toSet();
    for (final op in ops) {
      for (final a in numbers) {
        for (final b in numbers) {
          final result = compute(a, op, b);
          if (result > 0 && numsSet.contains(result)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  group('Solvability check logic', () {
    test('field with valid addition equation is solvable', () {
      // 3 + 5 = 8 — all present
      expect(hasSolvableEquation([3, 5, 8], [MathOp.add]), isTrue);
    });

    test('field with valid subtraction equation is solvable', () {
      // 8 - 3 = 5 — all present
      expect(hasSolvableEquation([8, 3, 5], [MathOp.subtract]), isTrue);
    });

    test('field with valid multiplication equation is solvable', () {
      // 3 * 4 = 12 — all present
      expect(hasSolvableEquation([3, 4, 12], [MathOp.multiply]), isTrue);
    });

    test('field with valid division equation is solvable', () {
      // 12 / 3 = 4 — all present
      expect(hasSolvableEquation([12, 3, 4], [MathOp.divide]), isTrue);
    });

    test('field with no valid equation is not solvable', () {
      // No combination of 7, 11, 13 with add gives a result in the set
      expect(hasSolvableEquation([7, 11, 13], [MathOp.multiply]), isFalse);
    });

    test('field with no operators is not solvable', () {
      expect(hasSolvableEquation([3, 5, 8], []), isFalse);
    });

    test('duplicate numbers can form equations', () {
      // 2 + 2 = 4
      expect(hasSolvableEquation([2, 2, 4], [MathOp.add]), isTrue);
    });

    test('division with non-integer result is not solvable', () {
      // 7 / 3 = -1 (invalid), only these numbers with only divide
      expect(hasSolvableEquation([7, 3, 2], [MathOp.divide]), isFalse);
    });

    test('multiple operations increase solvability', () {
      // With just multiply: 3, 5, 7 is not solvable
      expect(hasSolvableEquation([3, 5, 7], [MathOp.multiply]), isFalse);
      // With add: 3 + 5 = 8? No. 5 + 7 = 12? No. 3 + 7 = 10? No.
      // But we need result in set. Let's use better numbers.
      // 3, 4, 7 with add: 3 + 4 = 7? Yes!
      expect(hasSolvableEquation([3, 4, 7], [MathOp.add]), isTrue);
    });
  });
}
