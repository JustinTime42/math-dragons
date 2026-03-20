import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/models/feast_config.dart';

void main() {
  group('DragonsFeastConfig', () {
    test('level 1: Easy Pickings, Even Numbers', () {
      final config = DragonsFeastConfig.configForLevel(1);
      expect(config.worldNumber, 1);
      expect(config.levelInWorld, 1);
      expect(config.category.id, 'even');
    });

    test('level 8: Easy Pickings, Greater than 25', () {
      final config = DragonsFeastConfig.configForLevel(8);
      expect(config.worldNumber, 1);
      expect(config.levelInWorld, 8);
      expect(config.category.id, 'gt_25');
    });

    test('level 9: Growing Appetite, Multiples of 6', () {
      final config = DragonsFeastConfig.configForLevel(9);
      expect(config.worldNumber, 2);
      expect(config.levelInWorld, 1);
      expect(config.category.id, 'mult_6');
    });

    test('level 17: Refined Palate, Prime Numbers', () {
      final config = DragonsFeastConfig.configForLevel(17);
      expect(config.worldNumber, 3);
      expect(config.category.id, 'prime');
    });

    test('level 25: Gourmet Dragon, Factors of 36', () {
      final config = DragonsFeastConfig.configForLevel(25);
      expect(config.worldNumber, 4);
      expect(config.category.id, 'factors_36');
    });

    test('level 33: Dragon King\'s Feast, Prime Numbers, 6 enemies', () {
      final config = DragonsFeastConfig.configForLevel(33);
      expect(config.worldNumber, 5);
      expect(config.category.id, 'prime');
      expect(config.enemyCount, 6);
    });

    test('world 5 enemies are fastest (2-4 sec intervals)', () {
      final config = DragonsFeastConfig.configForLevel(33);
      expect(config.enemySpeedMin, 2.0);
      expect(config.enemySpeedMax, 4.0);
    });

    test('total levels = 40', () {
      // All 40 levels should produce valid configs
      for (int i = 1; i <= 40; i++) {
        final config = DragonsFeastConfig.configForLevel(i);
        expect(config.levelNumber, i);
        expect(config.worldNumber, inInclusiveRange(1, 5));
        expect(config.levelInWorld, inInclusiveRange(1, 8));
      }
    });

    test('all level numbers are unique and sequential', () {
      final levelNumbers = <int>{};
      for (int i = 1; i <= 40; i++) {
        final config = DragonsFeastConfig.configForLevel(i);
        levelNumbers.add(config.levelNumber);
      }
      expect(levelNumbers.length, 40);
    });

    test('enemy count formula: min(2 + level/3, 6)', () {
      final config1 = DragonsFeastConfig.configForLevel(1);
      expect(config1.enemyCount, 2); // 2 + 0 = 2

      final config3 = DragonsFeastConfig.configForLevel(3);
      expect(config3.enemyCount, 3); // 2 + 1 = 3

      final config12 = DragonsFeastConfig.configForLevel(12);
      expect(config12.enemyCount, 6); // 2 + 4 = 6, capped at 6
    });

    test('every level has a valid MathCategory assigned', () {
      for (int i = 1; i <= 40; i++) {
        final config = DragonsFeastConfig.configForLevel(i);
        expect(config.category.id, isNotEmpty,
            reason: 'Level $i missing category');
        expect(config.category.displayName, isNotEmpty);
      }
    });

    test('correct tile count is reasonable (8-12)', () {
      for (int i = 1; i <= 40; i++) {
        final config = DragonsFeastConfig.configForLevel(i);
        expect(config.correctTileCount, inInclusiveRange(8, 12),
            reason: 'Level $i correct count out of range');
      }
    });

    test('enemy speed ranges are valid per world', () {
      for (int world = 1; world <= 5; world++) {
        final (minSpeed, maxSpeed) = DragonsFeastConfig.enemySpeedForWorld(world);
        expect(minSpeed, lessThan(maxSpeed));
        expect(minSpeed, greaterThan(0));
      }
    });
  });
}
