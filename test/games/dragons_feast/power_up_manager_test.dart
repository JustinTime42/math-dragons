import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/models/power_up_type.dart';
import 'package:math_dragons/games/dragons_feast/systems/power_up_manager.dart';

void main() {
  group('PowerUpManager', () {
    test('level 1 has no power-up', () {
      expect(PowerUpManager.powerUpForLevel(1), isNull);
    });

    test('level 2 has a power-up (freeze)', () {
      expect(PowerUpManager.powerUpForLevel(2), PowerUpType.freeze);
    });

    test('level 4 has a power-up (wings)', () {
      expect(PowerUpManager.powerUpForLevel(4), PowerUpType.wings);
    });

    test('level 6 has a power-up (shield)', () {
      expect(PowerUpManager.powerUpForLevel(6), PowerUpType.shield);
    });

    test('level 8 cycles back to freeze', () {
      expect(PowerUpManager.powerUpForLevel(8), PowerUpType.freeze);
    });

    test('odd levels have no power-up', () {
      for (final level in [1, 3, 5, 7, 9, 11, 13, 15]) {
        expect(PowerUpManager.powerUpForLevel(level), isNull,
            reason: 'Level $level should not have a power-up');
      }
    });

    test('power-up types cycle: freeze, wings, shield', () {
      expect(PowerUpManager.powerUpForLevel(2), PowerUpType.freeze);
      expect(PowerUpManager.powerUpForLevel(4), PowerUpType.wings);
      expect(PowerUpManager.powerUpForLevel(6), PowerUpType.shield);
      expect(PowerUpManager.powerUpForLevel(8), PowerUpType.freeze);
      expect(PowerUpManager.powerUpForLevel(10), PowerUpType.wings);
      expect(PowerUpManager.powerUpForLevel(12), PowerUpType.shield);
    });
  });
}
