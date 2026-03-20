import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/shared/result_screen.dart';

void main() {
  group('GameResults', () {
    test('required fields are set correctly', () {
      const results = GameResults(
        gameId: 'dragon_runes',
        score: 1250,
        accuracy: 0.87,
        streak: 8,
        scalesEarned: 35,
        stars: 2,
        levelNumber: 3,
      );

      expect(results.gameId, 'dragon_runes');
      expect(results.score, 1250);
      expect(results.accuracy, 0.87);
      expect(results.streak, 8);
      expect(results.scalesEarned, 35);
      expect(results.stars, 2);
      expect(results.levelNumber, 3);
    });

    test('optional fields default to 0', () {
      const results = GameResults(
        gameId: 'fire_trail',
        score: 100,
        accuracy: 0.5,
        streak: 1,
        scalesEarned: 10,
        stars: 1,
        levelNumber: 1,
      );

      expect(results.problemsAttempted, 0);
      expect(results.problemsCorrect, 0);
    });

    test('perfect score values work correctly', () {
      const results = GameResults(
        gameId: 'dragon_eggs',
        score: 9999,
        accuracy: 1.0,
        streak: 50,
        scalesEarned: 200,
        stars: 3,
        levelNumber: 10,
        problemsAttempted: 50,
        problemsCorrect: 50,
      );

      expect(results.accuracy, 1.0);
      expect(results.stars, 3);
      expect(results.problemsAttempted, results.problemsCorrect);
      expect((results.accuracy * 100).round(), 100);
    });

    test('zero values do not cause errors', () {
      const results = GameResults(
        gameId: 'dragons_feast',
        score: 0,
        accuracy: 0.0,
        streak: 0,
        scalesEarned: 0,
        stars: 0,
        levelNumber: 1,
        problemsAttempted: 0,
        problemsCorrect: 0,
      );

      expect(results.score, 0);
      expect(results.accuracy, 0.0);
      expect(results.stars, 0);
      expect(results.scalesEarned, 0);
      // Verify display calculations don't crash with zero values
      expect((results.accuracy * 100).round(), 0);
    });
  });
}
