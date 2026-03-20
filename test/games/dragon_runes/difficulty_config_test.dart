import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/models/dragon_runes_config.dart';

void main() {
  group('DragonRunesConfig', () {
    test('World 1 level 1: addition only, range 1-5, 1 family, 2 targets, showOps=true', () {
      final config = DragonRunesConfig.forLevel(1);
      expect(config.worldNumber, 1);
      expect(config.levelInWorld, 1);
      expect(config.allowedOps, [MathOp.add]);
      expect(config.numberMin, 1);
      expect(config.numberMax, 5);
      expect(config.numberOfFamilies, 1);
      expect(config.targetCount, 2);
      expect(config.showOpsInTargets, true);
    });

    test('World 1 level 10: addition only, range 1-8, 2 families, 4 targets, showOps=true', () {
      final config = DragonRunesConfig.forLevel(10);
      expect(config.worldNumber, 1);
      expect(config.levelInWorld, 10);
      expect(config.allowedOps, [MathOp.add]);
      expect(config.numberMin, 1);
      expect(config.numberMax, 8);
      expect(config.numberOfFamilies, 2);
      expect(config.targetCount, 4);
      expect(config.showOpsInTargets, true);
    });

    test('World 2 level 1: add+sub, range 1-8, 2 families, showOps=false', () {
      final config = DragonRunesConfig.forLevel(11);
      expect(config.worldNumber, 2);
      expect(config.levelInWorld, 1);
      expect(config.allowedOps, [MathOp.add, MathOp.subtract]);
      expect(config.numberMin, 1);
      expect(config.numberMax, 8);
      expect(config.numberOfFamilies, 2);
      expect(config.targetCount, 4);
      expect(config.showOpsInTargets, false);
    });

    test('World 3 includes multiplication', () {
      final config = DragonRunesConfig.forLevel(21);
      expect(config.worldNumber, 3);
      expect(config.allowedOps,
          [MathOp.add, MathOp.subtract, MathOp.multiply]);
    });

    test('World 4 includes division', () {
      final config = DragonRunesConfig.forLevel(31);
      expect(config.worldNumber, 4);
      expect(config.allowedOps,
          [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide]);
    });

    test('World 5: all ops, range 2-15, 3 families, 10-12 targets', () {
      final config = DragonRunesConfig.forLevel(41);
      expect(config.worldNumber, 5);
      expect(config.allowedOps,
          [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide]);
      expect(config.numberMin, 2);
      expect(config.numberMax, 15);
      expect(config.numberOfFamilies, 3);
      expect(config.targetCount, greaterThanOrEqualTo(10));
    });

    test('total levels = 50', () {
      // Verify all 50 levels can be generated
      for (int i = 1; i <= 50; i++) {
        final config = DragonRunesConfig.forLevel(i);
        expect(config.levelNumber, i);
        expect(config.worldNumber, greaterThan(0));
        expect(config.worldNumber, lessThanOrEqualTo(5));
      }
    });

    test('all level numbers are unique and sequential', () {
      final seen = <int>{};
      for (int i = 1; i <= 50; i++) {
        final config = DragonRunesConfig.forLevel(i);
        expect(seen.contains(config.levelNumber), false,
            reason: 'Duplicate level number ${config.levelNumber}');
        seen.add(config.levelNumber);
      }
      expect(seen.length, 50);
    });
  });
}
