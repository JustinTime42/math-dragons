import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/fire_trail/models/fire_trail_config.dart';

void main() {
  group('FireTrailConfig', () {
    test('World 1 level 1 has addition only', () {
      final config = FireTrailConfig.forLevel(1, 1);
      expect(config.allowedOperations, [MathOp.add]);
      expect(config.wrapMode, isFalse);
    });

    test('World 2 has addition and subtraction', () {
      final config = FireTrailConfig.forLevel(2, 1);
      expect(config.allowedOperations, contains(MathOp.add));
      expect(config.allowedOperations, contains(MathOp.subtract));
    });

    test('World 3 adds multiplication', () {
      final config = FireTrailConfig.forLevel(3, 1);
      expect(config.allowedOperations, contains(MathOp.multiply));
    });

    test('World 4 has all 4 operations', () {
      final config = FireTrailConfig.forLevel(4, 1);
      expect(config.allowedOperations.length, 4);
      expect(config.allowedOperations, contains(MathOp.divide));
    });

    test('World 5 has wrap mode enabled', () {
      final config = FireTrailConfig.forLevel(5, 1);
      expect(config.wrapMode, isTrue);
    });

    test('World 1-4 have wrap mode disabled', () {
      for (int w = 1; w <= 4; w++) {
        final config = FireTrailConfig.forLevel(w, 1);
        expect(config.wrapMode, isFalse, reason: 'World $w should not have wrap');
      }
    });

    test('speed increases across worlds', () {
      final speed1 = FireTrailConfig.speedForLevel(1, 1);
      final speed3 = FireTrailConfig.speedForLevel(3, 1);
      final speed5 = FireTrailConfig.speedForLevel(5, 1);
      expect(speed3, greaterThan(speed1));
      expect(speed5, greaterThan(speed3));
    });

    test('speed increases within a world', () {
      final speedLow = FireTrailConfig.speedForLevel(1, 1);
      final speedHigh = FireTrailConfig.speedForLevel(1, 8);
      expect(speedHigh, greaterThan(speedLow));
    });

    test('correctToAdvance increases across worlds', () {
      final target1 = FireTrailConfig.correctToAdvanceForLevel(1, 1);
      final target5 = FireTrailConfig.correctToAdvanceForLevel(5, 1);
      expect(target5, greaterThan(target1));
    });

    test('World 1 speed range is approximately 3.5 to 4.5', () {
      final speedMin = FireTrailConfig.speedForLevel(1, 1);
      final speedMax = FireTrailConfig.speedForLevel(1, 8);
      expect(speedMin, closeTo(3.5, 0.01));
      expect(speedMax, closeTo(4.5, 0.01));
    });

    test('World 5 speed range is approximately 10.5 to 12.0', () {
      final speedMin = FireTrailConfig.speedForLevel(5, 1);
      final speedMax = FireTrailConfig.speedForLevel(5, 8);
      expect(speedMin, closeTo(10.5, 0.01));
      expect(speedMax, closeTo(12.0, 0.01));
    });

    test('distractor count increases with world', () {
      final config1 = FireTrailConfig.forLevel(1, 1);
      final config5 = FireTrailConfig.forLevel(5, 1);
      expect(config5.distractorCount, greaterThanOrEqualTo(config1.distractorCount));
    });
  });
}
