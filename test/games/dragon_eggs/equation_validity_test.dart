// EGT-5 (docs/specs/adaptive-practice.md section 9.3, rule EG-f).
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/dragon_eggs_game.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/dragon_eggs/models/equation.dart';

void main() {
  group('EGT-5 invalid equations are wrong and carry no fact key', () {
    test('7 ÷ 2 = 3 is incorrect and its AnswerGiven has factKey null', () {
      final result = EquationResult(
        left: 7,
        op: MathOp.divide,
        right: 2,
        playerAnswer: 3,
      );
      expect(result.isCorrect, isFalse);

      final event = answerEventForEquation(result, 900);
      expect(event.correct, isFalse);
      expect(event.factKey, isNull);
      expect(event.gameId, 'dragon_eggs');
    });

    test('3 − 7 is incorrect and its AnswerGiven has factKey null', () {
      for (final answer in [-4, 4, 0]) {
        final result = EquationResult(
          left: 3,
          op: MathOp.subtract,
          right: 7,
          playerAnswer: answer,
        );
        expect(result.isCorrect, isFalse, reason: 'answer $answer');

        final event = answerEventForEquation(result, 900);
        expect(event.correct, isFalse);
        expect(event.factKey, isNull, reason: 'answer $answer');
      }
    });

    test('division by zero and zero results carry no fact key', () {
      for (final result in [
        EquationResult(left: 5, op: MathOp.divide, right: 0, playerAnswer: 0),
        EquationResult(left: 5, op: MathOp.subtract, right: 5, playerAnswer: 0),
      ]) {
        expect(result.isCorrect, isFalse);
        expect(answerEventForEquation(result, 900).factKey, isNull);
      }
    });
  });

  group('valid equations carry their canonical fact key', () {
    test('a correct even division', () {
      final result = EquationResult(
        left: 12,
        op: MathOp.divide,
        right: 3,
        playerAnswer: 4,
      );
      final event = answerEventForEquation(result, 900);
      expect(event.correct, isTrue);
      expect(event.factKey, '12/3');
      expect(event.firstAttempt, isTrue);
      expect(event.responseTimeMs, 900);
    });

    test('a wrong answer to a valid fact is a miss on that fact', () {
      final result = EquationResult(
        left: 8,
        op: MathOp.multiply,
        right: 7,
        playerAnswer: 54,
      );
      final event = answerEventForEquation(result, 900);
      expect(event.correct, isFalse);
      expect(event.factKey, '7x8');
      expect(event.firstAttempt, isTrue);
    });
  });
}
