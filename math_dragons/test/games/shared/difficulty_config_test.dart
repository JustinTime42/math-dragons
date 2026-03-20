import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/shared/difficulty_config.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

void main() {
  group('LevelThresholds.calculateStars', () {
    test('returns 0 stars when problemsAttempted < minimum', () {
      // Level 1 requires 8 problems minimum
      final stars = LevelThresholds.calculateStars(
        accuracy: 1.0, // Perfect accuracy
        score: 1000,
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 7, // Below minimum
        levelNumber: 1,
      );
      expect(stars, 0);
    });

    test('returns 0 stars when accuracy < 60%', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.59,
        score: 1000,
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 0);
    });

    test('returns 1 star at 60% accuracy with enough problems', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.60,
        score: 50, // Below median
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 8,
        levelNumber: 1,
      );
      expect(stars, 1);
    });

    test('returns 2 stars at 75%+ accuracy AND score >= medianScore', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.75,
        score: 100, // Exactly at median
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 2);
    });

    test('returns 3 stars at 90%+ accuracy AND score >= highScore', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.90,
        score: 150, // Exactly at high score
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 3);
    });

    test('returns 2 stars NOT granted if score below median (even with 75% accuracy)', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.75,
        score: 99, // Below median
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 1); // Not 2
    });

    test('returns 3 stars NOT granted if accuracy below 90% (even with high score)', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.89, // Below 90%
        score: 200, // Above high score
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 2); // Not 3
    });

    test('returns 1 star at exactly 60% accuracy', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.60,
        score: 50,
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 1);
    });

    test('returns 1 star just below 75% accuracy', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.74,
        score: 120, // Above median
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 1);
    });

    test('returns 2 stars just below 90% accuracy', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 0.89,
        score: 120, // Above median
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 2);
    });

    test('returns 3 stars at 100% accuracy and high score', () {
      final stars = LevelThresholds.calculateStars(
        accuracy: 1.0,
        score: 200,
        medianScore: 100,
        highScore: 150,
        problemsAttempted: 10,
        levelNumber: 1,
      );
      expect(stars, 3);
    });
  });

  group('LevelThresholds.minProblemsForLevel', () {
    test('returns 8 for levels 1-5', () {
      expect(LevelThresholds.minProblemsForLevel(1), 8);
      expect(LevelThresholds.minProblemsForLevel(3), 8);
      expect(LevelThresholds.minProblemsForLevel(5), 8);
    });

    test('returns 10 for levels 6-15', () {
      expect(LevelThresholds.minProblemsForLevel(6), 10);
      expect(LevelThresholds.minProblemsForLevel(10), 10);
      expect(LevelThresholds.minProblemsForLevel(15), 10);
    });

    test('returns 12 for levels 16-30', () {
      expect(LevelThresholds.minProblemsForLevel(16), 12);
      expect(LevelThresholds.minProblemsForLevel(20), 12);
      expect(LevelThresholds.minProblemsForLevel(30), 12);
    });

    test('returns 15 for levels 31+', () {
      expect(LevelThresholds.minProblemsForLevel(31), 15);
      expect(LevelThresholds.minProblemsForLevel(40), 15);
      expect(LevelThresholds.minProblemsForLevel(100), 15);
    });
  });

  group('FactPool.forLevel', () {
    test('generates correct fact pool for addition-only level', () {
      final facts = FactPool.forLevel(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.add],
        resultMax: 144,
      );

      // Should have 1+1 to 5+5 (only canonical forms where left >= right)
      expect(facts.isNotEmpty, true);

      // All facts should be addition
      expect(facts.every((f) => f.op == MathOp.add), true);

      // All operands should be in range
      expect(facts.every((f) => f.left >= 1 && f.left <= 5), true);
      expect(facts.every((f) => f.right >= 1 && f.right <= 5), true);

      // All results should be <= resultMax
      expect(facts.every((f) => f.result <= 144), true);

      // For addition, should only have canonical forms (a >= b)
      expect(facts.every((f) => f.left >= f.right), true);

      // Check specific count: 1+1, 2+1, 2+2, 3+1, 3+2, 3+3, 4+1, 4+2, 4+3, 4+4, 5+1, 5+2, 5+3, 5+4, 5+5
      // That's 15 facts (sum from 1 to 5)
      expect(facts.length, 15);
    });

    test('generates correct pool for all-operations level', () {
      final facts = FactPool.forLevel(
        numberMin: 2,
        numberMax: 4,
        operations: [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide],
        resultMax: 144,
      );

      expect(facts.isNotEmpty, true);

      // Should contain all four operations
      expect(facts.any((f) => f.op == MathOp.add), true);
      expect(facts.any((f) => f.op == MathOp.subtract), true);
      expect(facts.any((f) => f.op == MathOp.multiply), true);
      expect(facts.any((f) => f.op == MathOp.divide), true);

      // All operands should be in range
      expect(facts.every((f) => f.left >= 2 && f.left <= 4), true);
      expect(facts.every((f) => f.right >= 2 && f.right <= 4), true);

      // All results should be positive and <= resultMax
      expect(facts.every((f) => f.result > 0 && f.result <= 144), true);

      // For subtraction, left should always be > right
      final subtracts = facts.where((f) => f.op == MathOp.subtract);
      expect(subtracts.every((f) => f.left > f.right), true);

      // For division, should divide evenly
      final divides = facts.where((f) => f.op == MathOp.divide);
      expect(divides.every((f) => f.left % f.right == 0), true);
    });

    test('respects numberMin/numberMax ranges', () {
      final facts = FactPool.forLevel(
        numberMin: 10,
        numberMax: 12,
        operations: [MathOp.add],
        resultMax: 144,
      );

      expect(facts.every((f) => f.left >= 10 && f.left <= 12), true);
      expect(facts.every((f) => f.right >= 10 && f.right <= 12), true);
    });

    test('no facts with result > resultMax', () {
      final facts = FactPool.forLevel(
        numberMin: 1,
        numberMax: 10,
        operations: [MathOp.add, MathOp.multiply],
        resultMax: 20, // Restrict results
      );

      expect(facts.every((f) => f.result <= 20), true);

      // Should exclude things like 10+10=20+1 and large multiplications
      expect(facts.any((f) => f.result > 20), false);
    });

    test('handles subtraction correctly', () {
      final facts = FactPool.forLevel(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.subtract],
        resultMax: 144,
      );

      // All should be subtractions where left > right
      expect(facts.every((f) => f.op == MathOp.subtract), true);
      expect(facts.every((f) => f.left > f.right), true);
      expect(facts.every((f) => f.result > 0), true);

      // Should have 2-1, 3-1, 3-2, 4-1, 4-2, 4-3, 5-1, 5-2, 5-3, 5-4
      // That's 10 facts
      expect(facts.length, 10);
    });

    test('handles division correctly', () {
      final facts = FactPool.forLevel(
        numberMin: 2,
        numberMax: 12,
        operations: [MathOp.divide],
        resultMax: 144,
      );

      // All should divide evenly
      expect(facts.every((f) => f.op == MathOp.divide), true);
      expect(facts.every((f) => f.left % f.right == 0), true);
      expect(facts.every((f) => f.right >= 2), true); // No division by 0 or 1
      expect(facts.every((f) => f.result > 0), true);
    });

    test('handles multiplication correctly', () {
      final facts = FactPool.forLevel(
        numberMin: 2,
        numberMax: 4,
        operations: [MathOp.multiply],
        resultMax: 144,
      );

      // All should be multiplications in canonical form (a >= b)
      expect(facts.every((f) => f.op == MathOp.multiply), true);
      expect(facts.every((f) => f.left >= f.right), true);

      // Should have 2×2, 3×2, 3×3, 4×2, 4×3, 4×4
      // That's 6 facts
      expect(facts.length, 6);
    });

    test('empty pool when no valid facts exist', () {
      // resultMax too low to allow any facts
      final facts = FactPool.forLevel(
        numberMin: 10,
        numberMax: 12,
        operations: [MathOp.add],
        resultMax: 10, // Impossible: 10+10=20 > 10
      );

      expect(facts.isEmpty, true);
    });
  });

  group('GameScoreThresholds', () {
    group('fireTrail', () {
      test('returns increasing thresholds per level', () {
        final level1 = GameScoreThresholds.fireTrail(1);
        final level5 = GameScoreThresholds.fireTrail(5);
        final level10 = GameScoreThresholds.fireTrail(10);

        // Level 1 is world 1: base = 6 + 1*3 = 9
        expect(level1.medianScore, 90);
        expect(level1.highScore, 135);

        // Level 5 is world 1: base = 6 + 1*3 = 9
        expect(level5.medianScore, 90);
        expect(level5.highScore, 135);

        // Level 10 is world 2: base = 6 + 2*3 = 12
        expect(level10.medianScore, 120);
        expect(level10.highScore, 180);

        // Verify increasing trend
        expect(level10.medianScore > level1.medianScore, true);
        expect(level10.highScore > level1.highScore, true);
      });

      test('correctly calculates world-based thresholds', () {
        // World 1 (levels 1-8): base = 9
        final world1 = GameScoreThresholds.fireTrail(1);
        expect(world1.medianScore, 90);
        expect(world1.highScore, 135);

        // World 2 (levels 9-16): base = 12
        final world2 = GameScoreThresholds.fireTrail(9);
        expect(world2.medianScore, 120);
        expect(world2.highScore, 180);

        // World 3 (levels 17-24): base = 15
        final world3 = GameScoreThresholds.fireTrail(17);
        expect(world3.medianScore, 150);
        expect(world3.highScore, 225);

        // World 4 (levels 25-32): base = 18
        final world4 = GameScoreThresholds.fireTrail(25);
        expect(world4.medianScore, 180);
        expect(world4.highScore, 270);

        // World 5 (levels 33-40): base = 21
        final world5 = GameScoreThresholds.fireTrail(33);
        expect(world5.medianScore, 210);
        expect(world5.highScore, 315);
      });
    });

    group('dragonRunes', () {
      test('returns thresholds based on world', () {
        final level1 = GameScoreThresholds.dragonRunes(1);
        final level11 = GameScoreThresholds.dragonRunes(11);
        final level21 = GameScoreThresholds.dragonRunes(21);

        // Level 1 is world 1: targets = 2 + 1*2 = 4
        expect(level1.medianScore, 400); // 4 * 100
        expect(level1.highScore, 600); // 4 * 100 + 4 * 50

        // Level 11 is world 2: targets = 2 + 2*2 = 6
        expect(level11.medianScore, 600); // 6 * 100
        expect(level11.highScore, 900); // 6 * 100 + 6 * 50

        // Level 21 is world 3: targets = 2 + 3*2 = 8
        expect(level21.medianScore, 800); // 8 * 100
        expect(level21.highScore, 1200); // 8 * 100 + 8 * 50
      });

      test('correctly calculates world-based thresholds', () {
        // World 1 (levels 1-10): targets = 4
        final world1 = GameScoreThresholds.dragonRunes(5);
        expect(world1.medianScore, 400);
        expect(world1.highScore, 600);

        // World 2 (levels 11-20): targets = 6
        final world2 = GameScoreThresholds.dragonRunes(15);
        expect(world2.medianScore, 600);
        expect(world2.highScore, 900);

        // World 3 (levels 21-30): targets = 8
        final world3 = GameScoreThresholds.dragonRunes(25);
        expect(world3.medianScore, 800);
        expect(world3.highScore, 1200);

        // World 4 (levels 31-40): targets = 10
        final world4 = GameScoreThresholds.dragonRunes(35);
        expect(world4.medianScore, 1000);
        expect(world4.highScore, 1500);

        // World 5 (levels 41-50): targets = 12
        final world5 = GameScoreThresholds.dragonRunes(45);
        expect(world5.medianScore, 1200);
        expect(world5.highScore, 1800);
      });
    });

    group('dragonsFeast', () {
      test('returns increasing thresholds', () {
        final level1 = GameScoreThresholds.dragonsFeast(1);
        final level10 = GameScoreThresholds.dragonsFeast(10);
        final level20 = GameScoreThresholds.dragonsFeast(20);

        // Level 1: median = 500 + 1*30 = 530, high = 800 + 1*50 = 850
        expect(level1.medianScore, 530);
        expect(level1.highScore, 850);

        // Level 10: median = 500 + 10*30 = 800, high = 800 + 10*50 = 1300
        expect(level10.medianScore, 800);
        expect(level10.highScore, 1300);

        // Level 20: median = 500 + 20*30 = 1100, high = 800 + 20*50 = 1800
        expect(level20.medianScore, 1100);
        expect(level20.highScore, 1800);

        // Verify increasing trend
        expect(level10.medianScore > level1.medianScore, true);
        expect(level20.medianScore > level10.medianScore, true);
        expect(level10.highScore > level1.highScore, true);
        expect(level20.highScore > level10.highScore, true);
      });
    });

    group('dragonEggs', () {
      test('returns increasing thresholds per level', () {
        final level1 = GameScoreThresholds.dragonEggs(1);
        final level10 = GameScoreThresholds.dragonEggs(10);
        final level20 = GameScoreThresholds.dragonEggs(20);

        // Level 1: base = 50 + 1*15 = 65
        expect(level1.medianScore, 65);
        expect(level1.highScore, 98); // 65 * 1.5 rounded

        // Level 10: base = 50 + 10*15 = 200
        expect(level10.medianScore, 200);
        expect(level10.highScore, 300); // 200 * 1.5

        // Level 20: base = 50 + 20*15 = 350
        expect(level20.medianScore, 350);
        expect(level20.highScore, 525); // 350 * 1.5

        // Verify increasing trend
        expect(level10.medianScore > level1.medianScore, true);
        expect(level20.medianScore > level10.medianScore, true);
      });
    });
  });
}
