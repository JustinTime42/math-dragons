import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/equation.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

void main() {
  group('EquationResult', () {
    test('correct addition', () {
      final result = EquationResult(
        left: 3,
        op: MathOp.add,
        right: 5,
        playerAnswer: 8,
      );
      expect(result.isCorrect, isTrue);
      expect(result.correctAnswer, 8);
    });

    test('correct subtraction', () {
      final result = EquationResult(
        left: 8,
        op: MathOp.subtract,
        right: 3,
        playerAnswer: 5,
      );
      expect(result.isCorrect, isTrue);
      expect(result.correctAnswer, 5);
    });

    test('correct multiplication', () {
      final result = EquationResult(
        left: 4,
        op: MathOp.multiply,
        right: 3,
        playerAnswer: 12,
      );
      expect(result.isCorrect, isTrue);
      expect(result.correctAnswer, 12);
    });

    test('correct division', () {
      final result = EquationResult(
        left: 12,
        op: MathOp.divide,
        right: 3,
        playerAnswer: 4,
      );
      expect(result.isCorrect, isTrue);
      expect(result.correctAnswer, 4);
    });

    test('wrong answer', () {
      final result = EquationResult(
        left: 3,
        op: MathOp.add,
        right: 5,
        playerAnswer: 9,
      );
      expect(result.isCorrect, isFalse);
    });

    test('zero result rejected', () {
      final result = EquationResult(
        left: 5,
        op: MathOp.subtract,
        right: 5,
        playerAnswer: 0,
      );
      expect(result.isCorrect, isFalse);
      expect(result.correctAnswer, 0);
    });

    test('negative result rejected', () {
      final result = EquationResult(
        left: 3,
        op: MathOp.subtract,
        right: 5,
        playerAnswer: -2,
      );
      expect(result.isCorrect, isFalse);
    });

    test('division by zero handled', () {
      final result = EquationResult(
        left: 5,
        op: MathOp.divide,
        right: 0,
        playerAnswer: 0,
      );
      expect(result.isCorrect, isFalse);
      expect(result.correctAnswer, 0);
    });

    test('non-integer division result', () {
      // 7 / 3 = 2 in integer division, but player answered 2
      final result = EquationResult(
        left: 7,
        op: MathOp.divide,
        right: 3,
        playerAnswer: 2,
      );
      // correctAnswer is 2 (integer division) and > 0, so this is "correct"
      // In the actual game, non-integer division facts are never generated
      expect(result.correctAnswer, 2);
    });

    group('fact key normalization', () {
      test('addition is commutative - smaller number first', () {
        final r1 = EquationResult(
          left: 5,
          op: MathOp.add,
          right: 3,
          playerAnswer: 8,
        );
        final r2 = EquationResult(
          left: 3,
          op: MathOp.add,
          right: 5,
          playerAnswer: 8,
        );
        expect(r1.factKey, '3+5');
        expect(r2.factKey, '3+5');
      });

      test('subtraction is non-commutative - left first', () {
        final result = EquationResult(
          left: 8,
          op: MathOp.subtract,
          right: 3,
          playerAnswer: 5,
        );
        expect(result.factKey, '8-3');
      });

      test('multiplication is commutative - smaller first', () {
        final r1 = EquationResult(
          left: 7,
          op: MathOp.multiply,
          right: 3,
          playerAnswer: 21,
        );
        final r2 = EquationResult(
          left: 3,
          op: MathOp.multiply,
          right: 7,
          playerAnswer: 21,
        );
        expect(r1.factKey, '3x7');
        expect(r2.factKey, '3x7');
      });

      test('division is non-commutative - dividend first', () {
        final result = EquationResult(
          left: 12,
          op: MathOp.divide,
          right: 3,
          playerAnswer: 4,
        );
        expect(result.factKey, '12/3');
      });
    });
  });
}
