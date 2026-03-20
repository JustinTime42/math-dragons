import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// Tests for Dragon's Feast scoring logic.
/// These test the pure scoring rules independently of the Flame game.
void main() {
  group('Scoring Rules', () {
    late int score;
    late int streak;
    late int bestStreak;
    late int correctEaten;
    late int wrongEaten;

    setUp(() {
      score = 0;
      streak = 0;
      bestStreak = 0;
      correctEaten = 0;
      wrongEaten = 0;
    });

    void eatCorrect() {
      score += 100;
      streak++;
      bestStreak = max(bestStreak, streak);
      correctEaten++;
      if (streak >= 3) score += 50;
    }

    void eatWrong() {
      score = max(0, score - 50);
      streak = 0;
      wrongEaten++;
    }

    test('correct eat adds 100 points', () {
      eatCorrect();
      expect(score, 100);
    });

    test('wrong eat subtracts 50 points', () {
      eatCorrect(); // 100
      eatWrong(); // 100 - 50 = 50
      expect(score, 50);
    });

    test('score never goes below 0', () {
      eatWrong();
      expect(score, 0);
    });

    test('streak >= 3 adds 50 bonus per correct eat', () {
      eatCorrect(); // 100, streak 1
      eatCorrect(); // 200, streak 2
      eatCorrect(); // 300 + 50 = 350, streak 3
      expect(score, 350);
    });

    test('streak resets to 0 on wrong eat', () {
      eatCorrect(); // streak 1
      eatCorrect(); // streak 2
      eatWrong(); // streak 0
      expect(streak, 0);
    });

    test('level complete adds 500 bonus', () {
      eatCorrect(); // 100
      score += 500; // level complete
      expect(score, 600);
    });

    test('best streak tracks maximum across session', () {
      eatCorrect(); // streak 1
      eatCorrect(); // streak 2
      eatCorrect(); // streak 3
      eatWrong(); // streak 0, bestStreak 3
      eatCorrect(); // streak 1
      expect(bestStreak, 3);
    });

    test('correctEaten increments only on correct eats', () {
      eatCorrect();
      eatWrong();
      eatCorrect();
      expect(correctEaten, 2);
    });

    test('wrongEaten increments only on wrong eats', () {
      eatCorrect();
      eatWrong();
      eatWrong();
      expect(wrongEaten, 2);
    });

    test('accuracy calculation', () {
      eatCorrect();
      eatCorrect();
      eatWrong();
      final accuracy = correctEaten / (correctEaten + wrongEaten);
      expect(accuracy, closeTo(0.667, 0.01));
    });
  });

  group('Star Calculation', () {
    int calculateStars(double accuracy, int livesRemaining, int levelsCleared) {
      if (accuracy >= 0.9 && livesRemaining == 3) return 3;
      if (accuracy >= 0.75 && livesRemaining >= 2) return 2;
      if (levelsCleared > 0) return 1;
      return 0;
    }

    test('3 stars: 90%+ accuracy with 3 lives', () {
      expect(calculateStars(0.95, 3, 1), 3);
    });

    test('2 stars: 75%+ accuracy with 2+ lives', () {
      expect(calculateStars(0.80, 2, 1), 2);
    });

    test('1 star: completed at least one level', () {
      expect(calculateStars(0.50, 1, 1), 1);
    });

    test('0 stars: no levels cleared', () {
      expect(calculateStars(0.50, 1, 0), 0);
    });
  });
}
