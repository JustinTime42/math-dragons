import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/models/equation_target.dart';
import 'package:math_dragons/games/dragon_runes/systems/equation_validator.dart';
import 'package:math_dragons/games/dragon_runes/systems/scoring_manager.dart';

void main() {
  group('ScoringManager', () {
    late ScoringManager scoring;

    setUp(() {
      scoring = ScoringManager();
    });

    test('target match adds 100 points', () {
      final result = scoring.handleResult(TargetMatchEquation(
        target: const EquationTarget(
            canonical: '2+3=5', displayText: '2 + 3 = 5'),
      ));
      expect(result.type, ScoringOutcomeType.correct);
      expect(result.points, 100);
      expect(scoring.score, 100);
    });

    test('target match with streak >= 3 adds 150 points', () {
      // Build streak to 3
      for (int i = 0; i < 2; i++) {
        scoring.handleResult(TargetMatchEquation(
          target: EquationTarget(
              canonical: '$i+1=2', displayText: '$i + 1 = 2'),
        ));
      }
      // Third hit
      final result = scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '3+1=4', displayText: '3 + 1 = 4'),
      ));
      expect(result.points, 150);
      expect(result.hadStreakBonus, true);
    });

    test('streak increments on correct target match', () {
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '1+2=3', displayText: '1 + 2 = 3'),
      ));
      expect(scoring.streak, 1);
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
      ));
      expect(scoring.streak, 2);
    });

    test('streak resets to 0 on invalid equation', () {
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '1+2=3', displayText: '1 + 2 = 3'),
      ));
      expect(scoring.streak, 1);
      scoring.handleResult(const InvalidEquation());
      expect(scoring.streak, 0);
    });

    test('streak does NOT reset on already-found', () {
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '1+2=3', displayText: '1 + 2 = 3'),
      ));
      expect(scoring.streak, 1);
      scoring.handleResult(const AlreadyFoundEquation());
      expect(scoring.streak, 1);
    });

    test('bonus equation increments streak and awards 50 points', () {
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '1+2=3', displayText: '1 + 2 = 3'),
      ));
      expect(scoring.streak, 1);
      final result =
          scoring.handleResult(const BonusEquation(displayText: '3 + 2 = 5', canonical: '3+2=5'));
      expect(scoring.streak, 2);
      expect(result.type, ScoringOutcomeType.bonus);
      expect(result.points, 50);
      expect(scoring.score, 150); // 100 + 50
      expect(scoring.bonusFound, 1);
    });

    test('level complete bonus adds 500 points', () {
      final bonus = scoring.completeLevelBonus();
      expect(bonus, 500);
      expect(scoring.score, 500);
    });

    test('best streak tracks the maximum streak achieved', () {
      for (int i = 0; i < 5; i++) {
        scoring.handleResult(TargetMatchEquation(
          target: EquationTarget(
              canonical: '$i+1=2', displayText: '$i + 1 = 2'),
        ));
      }
      expect(scoring.bestStreak, 5);
      scoring.handleResult(const InvalidEquation());
      expect(scoring.streak, 0);
      expect(scoring.bestStreak, 5);
    });

    test('total attempts increments on every result', () {
      scoring.handleResult(const InvalidEquation());
      scoring.handleResult(const BonusEquation(displayText: '1 + 1 = 2', canonical: '1+1=2'));
      scoring.handleResult(const AlreadyFoundEquation());
      expect(scoring.totalAttempts, 3);
    });

    test('equationsFound increments only on target match', () {
      scoring.handleResult(const InvalidEquation());
      scoring.handleResult(const BonusEquation(displayText: '1 + 1 = 2', canonical: '1+1=2'));
      scoring.handleResult(TargetMatchEquation(
        target:
            const EquationTarget(canonical: '1+2=3', displayText: '1 + 2 = 3'),
      ));
      expect(scoring.equationsFound, 1);
      expect(scoring.bonusFound, 1);
    });
  });
}
