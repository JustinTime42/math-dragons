import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/difficulty_config.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

void main() {
  group('DifficultyTier', () {
    test('level 1 starts with small numbers', () {
      final tier = DifficultyTier.forLevel(1);
      expect(tier.level, 1);
      expect(tier.numberMin, 1);
      expect(tier.numberMax, 4);
      expect(tier.operations, [MathOp.add]);
      expect(tier.gravityMultiplier, 1.0);
      expect(tier.spawnIntervalMs, 2000);
      expect(tier.requiredSolves, 3);
    });

    test('level 50 has full difficulty', () {
      final tier = DifficultyTier.forLevel(50);
      expect(tier.level, 50);
      expect(tier.numberMax, 12);
      expect(tier.operations, contains(MathOp.add));
      expect(tier.operations, contains(MathOp.subtract));
      expect(tier.operations, contains(MathOp.multiply));
      expect(tier.operations, contains(MathOp.divide));
    });

    test('there are 50 tiers', () {
      expect(DifficultyTier.tiers.length, 50);
    });

    test('forLevel clamps to valid range', () {
      final low = DifficultyTier.forLevel(0);
      expect(low.level, 1);

      final high = DifficultyTier.forLevel(100);
      expect(high.level, 50);
    });

    test('numberMax increases with level', () {
      final tier1 = DifficultyTier.forLevel(1);
      final tier10 = DifficultyTier.forLevel(10);
      final tier30 = DifficultyTier.forLevel(30);
      expect(tier10.numberMax, greaterThan(tier1.numberMax));
      expect(tier30.numberMax, greaterThan(tier10.numberMax));
    });

    test('division only appears after level 35', () {
      for (int i = 1; i <= 35; i++) {
        final tier = DifficultyTier.forLevel(i);
        expect(tier.operations, isNot(contains(MathOp.divide)),
            reason: 'Level $i should not include division');
      }
      final tier36 = DifficultyTier.forLevel(36);
      expect(tier36.operations, contains(MathOp.divide));
    });

    test('operations grow with level', () {
      for (int i = 2; i <= 50; i++) {
        final prev = DifficultyTier.forLevel(i - 1).operations;
        final curr = DifficultyTier.forLevel(i).operations;
        for (final op in prev) {
          expect(curr, contains(op),
              reason:
                  'Level $i should contain all ops from level ${i - 1} ($op)');
        }
      }
    });

    test('spawn interval decreases with level', () {
      final first = DifficultyTier.forLevel(1).spawnIntervalMs;
      final last = DifficultyTier.forLevel(50).spawnIntervalMs;
      expect(last, lessThan(first));
    });

    test('gravity multiplier increases with level', () {
      for (int i = 2; i <= 50; i++) {
        final prev = DifficultyTier.forLevel(i - 1).gravityMultiplier;
        final curr = DifficultyTier.forLevel(i).gravityMultiplier;
        expect(curr, greaterThanOrEqualTo(prev),
            reason: 'Level $i gravity should be >= level ${i - 1} gravity');
      }
    });

    test('requiredSolves increases with level', () {
      final first = DifficultyTier.forLevel(1).requiredSolves;
      final last = DifficultyTier.forLevel(50).requiredSolves;
      expect(first, 3);
      expect(last, greaterThan(first));
    });
  });
}
