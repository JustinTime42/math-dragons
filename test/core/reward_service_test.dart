import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/reward_service.dart';

void main() {
  group('ScaleRates', () {
    test('basePerCorrect returns correct values by level', () {
      // Easy levels (1-10): 1 scale
      expect(ScaleRates.basePerCorrect(1), 1);
      expect(ScaleRates.basePerCorrect(5), 1);
      expect(ScaleRates.basePerCorrect(10), 1);

      // Medium levels (11-25): 2 scales
      expect(ScaleRates.basePerCorrect(11), 2);
      expect(ScaleRates.basePerCorrect(20), 2);
      expect(ScaleRates.basePerCorrect(25), 2);

      // Hard levels (26+): 3 scales
      expect(ScaleRates.basePerCorrect(26), 3);
      expect(ScaleRates.basePerCorrect(50), 3);
    });

    test('streakBonus is capped at 5', () {
      expect(ScaleRates.streakBonus(0), 0);
      expect(ScaleRates.streakBonus(3), 3);
      expect(ScaleRates.streakBonus(5), 5);
      expect(ScaleRates.streakBonus(10), 5); // capped
      expect(ScaleRates.streakBonus(100), 5); // capped
    });

    test('levelCompletion awards correct amount by level range', () {
      // Levels 1-10: 10 scales
      expect(ScaleRates.levelCompletion(1), 10);
      expect(ScaleRates.levelCompletion(5), 10);
      expect(ScaleRates.levelCompletion(10), 10);

      // Levels 11-20: 15 scales
      expect(ScaleRates.levelCompletion(15), 15);
      expect(ScaleRates.levelCompletion(20), 15);

      // Levels 21-30: 20 scales
      expect(ScaleRates.levelCompletion(25), 20);
      expect(ScaleRates.levelCompletion(30), 20);

      // Levels 31-40: 25 scales
      expect(ScaleRates.levelCompletion(35), 25);
      expect(ScaleRates.levelCompletion(40), 25);

      // Levels 41+: 30 scales
      expect(ScaleRates.levelCompletion(45), 30);
      expect(ScaleRates.levelCompletion(100), 30);
    });

    test('threeStarBonus is 15', () {
      expect(ScaleRates.threeStarBonus, 15);
    });

    test('firstPlayBonus is 50', () {
      expect(ScaleRates.firstPlayBonus, 50);
    });

    test('dailyChallengeBase is 25', () {
      expect(ScaleRates.dailyChallengeBase, 25);
    });

    test('dailyChallengeStreakBonus caps at 25', () {
      expect(ScaleRates.dailyChallengeStreakBonus(1), 5);
      expect(ScaleRates.dailyChallengeStreakBonus(3), 15);
      expect(ScaleRates.dailyChallengeStreakBonus(5), 25); // cap
      expect(ScaleRates.dailyChallengeStreakBonus(10), 25); // capped
    });

    test('bonusSession is 10', () {
      expect(ScaleRates.bonusSession, 10);
    });
  });
}
