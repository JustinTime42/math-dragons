import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

/// Score calculation logic extracted for testing.
/// Mirrors the implementation in DragonEggsFlameGame.
int difficultyPoints(int a, int b, MathOp op) {
  switch (op) {
    case MathOp.multiply:
      if (min(a, b) <= 2) return 5;
      if (a <= 5 && b <= 5) return 10;
      if (min(a, b) <= 5) return 15;
      return 20;
    case MathOp.divide:
      if (b <= 2) return 5;
      if (b <= 5) return 10;
      return 15;
    case MathOp.add:
    case MathOp.subtract:
      if (max(a, b) <= 5) return 5;
      if (max(a, b) <= 10 && min(a, b) <= 5) return 8;
      return 12;
  }
}

(int, String) calculateScore({
  required int a,
  required int b,
  required MathOp op,
  required int comboMultiplier,
  required bool isNewFact,
}) {
  final base = difficultyPoints(a, b, op);
  final newFactBonus = isNewFact ? 5 : 0;
  final earned = base * comboMultiplier + newFactBonus;

  String breakdown;
  if (comboMultiplier > 1 && isNewFact) {
    breakdown = '($base x $comboMultiplier + $newFactBonus)';
  } else if (comboMultiplier > 1) {
    breakdown = '($base x $comboMultiplier)';
  } else if (isNewFact) {
    breakdown = '($base + $newFactBonus)';
  } else {
    breakdown = '+$earned';
  }

  return (earned, breakdown);
}

void main() {
  group('Difficulty points', () {
    test('easy addition (max <= 5): 5 points', () {
      expect(difficultyPoints(2, 3, MathOp.add), 5);
      expect(difficultyPoints(1, 5, MathOp.add), 5);
    });

    test('medium addition (max <= 10, min <= 5): 8 points', () {
      expect(difficultyPoints(3, 8, MathOp.add), 8);
      expect(difficultyPoints(5, 10, MathOp.add), 8);
    });

    test('hard addition: 12 points', () {
      expect(difficultyPoints(7, 8, MathOp.add), 12);
      expect(difficultyPoints(11, 12, MathOp.add), 12);
    });

    test('easy multiplication (min <= 2): 5 points', () {
      expect(difficultyPoints(2, 9, MathOp.multiply), 5);
      expect(difficultyPoints(1, 12, MathOp.multiply), 5);
    });

    test('medium multiplication (both <= 5): 10 points', () {
      expect(difficultyPoints(3, 5, MathOp.multiply), 10);
      expect(difficultyPoints(4, 4, MathOp.multiply), 10);
    });

    test('hard multiplication (min <= 5): 15 points', () {
      expect(difficultyPoints(5, 7, MathOp.multiply), 15);
      expect(difficultyPoints(3, 9, MathOp.multiply), 15);
    });

    test('tricky multiplication (both > 5): 20 points', () {
      expect(difficultyPoints(6, 7, MathOp.multiply), 20);
      expect(difficultyPoints(12, 12, MathOp.multiply), 20);
    });

    test('division points scale with divisor', () {
      expect(difficultyPoints(4, 2, MathOp.divide), 5);
      expect(difficultyPoints(15, 5, MathOp.divide), 10);
      expect(difficultyPoints(42, 7, MathOp.divide), 15);
    });
  });

  group('Score calculation', () {
    test('base score with no combo or new fact', () {
      final (earned, breakdown) = calculateScore(
        a: 2,
        b: 3,
        op: MathOp.add,
        comboMultiplier: 1,
        isNewFact: false,
      );
      expect(earned, 5); // easy addition
      expect(breakdown, '+5');
    });

    test('score with combo multiplier', () {
      final (earned, breakdown) = calculateScore(
        a: 2,
        b: 3,
        op: MathOp.add,
        comboMultiplier: 3,
        isNewFact: false,
      );
      expect(earned, 15); // 5 * 3
      expect(breakdown, '(5 x 3)');
    });

    test('score with new fact bonus', () {
      final (earned, breakdown) = calculateScore(
        a: 2,
        b: 3,
        op: MathOp.add,
        comboMultiplier: 1,
        isNewFact: true,
      );
      expect(earned, 10); // 5 * 1 + 5
      expect(breakdown, '(5 + 5)');
    });

    test('score with combo and new fact bonus', () {
      final (earned, breakdown) = calculateScore(
        a: 2,
        b: 3,
        op: MathOp.add,
        comboMultiplier: 3,
        isNewFact: true,
      );
      expect(earned, 20); // 5 * 3 + 5
      expect(breakdown, '(5 x 3 + 5)');
    });
  });
}
