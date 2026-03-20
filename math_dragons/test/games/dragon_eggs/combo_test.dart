import 'package:flutter_test/flutter_test.dart';

/// Tests for the combo system logic (inline in DragonEggsFlameGame).
/// The combo logic is:
///   correct: combo++
///   wrong: combo = 0
///   combo > 1 = active (multiplier applied)
void main() {
  group('Combo system', () {
    late int combo;

    setUp(() {
      combo = 0;
    });

    void onCorrect() {
      combo++;
    }

    void onWrong() {
      combo = 0;
    }

    bool isActive() => combo > 1;

    test('initial combo is 0', () {
      expect(combo, 0);
    });

    test('first correct increments combo to 1', () {
      onCorrect();
      expect(combo, 1);
    });

    test('second consecutive correct increments combo to 2', () {
      onCorrect();
      onCorrect();
      expect(combo, 2);
    });

    test('wrong answer resets combo to 0', () {
      onCorrect();
      onCorrect();
      onCorrect();
      expect(combo, 3);
      onWrong();
      expect(combo, 0);
    });

    test('combo after reset starts at 1 again', () {
      onCorrect();
      onCorrect();
      onWrong();
      onCorrect();
      expect(combo, 1);
    });

    test('isActive is false when combo <= 1', () {
      expect(isActive(), isFalse);
      onCorrect();
      expect(isActive(), isFalse); // combo == 1
    });

    test('isActive is true when combo >= 2', () {
      onCorrect();
      onCorrect();
      expect(isActive(), isTrue); // combo == 2
    });

    test('high combo builds correctly', () {
      for (int i = 0; i < 10; i++) {
        onCorrect();
      }
      expect(combo, 10);
    });
  });
}
