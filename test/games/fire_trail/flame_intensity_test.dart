import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/fire_trail/models/flame_intensity.dart';

void main() {
  group('FlameIntensity', () {
    late FlameIntensity flame;

    setUp(() {
      flame = FlameIntensity();
    });

    test('initial intensity is 1.0 (100%)', () {
      expect(flame.value, 1.0);
      expect(flame.percent, 100);
    });

    test('onWrongAnswer reduces by 0.20 to 0.80', () {
      flame.onWrongAnswer();
      expect(flame.value, closeTo(0.80, 0.001));
      expect(flame.percent, 80);
    });

    test('onCorrectAnswer from 1.0 stays at 1.0 (capped)', () {
      flame.onCorrectAnswer();
      expect(flame.value, 1.0);
    });

    test('after 3 wrong answers: 0.40', () {
      flame.onWrongAnswer();
      flame.onWrongAnswer();
      flame.onWrongAnswer();
      expect(flame.value, closeTo(0.40, 0.001));
    });

    test('after 5 wrong answers: 0.0 and isAlive is false', () {
      for (int i = 0; i < 5; i++) {
        flame.onWrongAnswer();
      }
      expect(flame.value, 0.0);
      expect(flame.isAlive, isFalse);
    });

    test('cannot go below 0.0 (clamped)', () {
      for (int i = 0; i < 10; i++) {
        flame.onWrongAnswer();
      }
      expect(flame.value, 0.0);
    });

    test('cannot go above 1.0 (clamped)', () {
      for (int i = 0; i < 10; i++) {
        flame.onCorrectAnswer();
      }
      expect(flame.value, 1.0);
    });

    test('recovery: 2 wrong (0.6) + 1 correct (0.7) + 1 wrong (0.5)', () {
      flame.onWrongAnswer(); // 0.8
      flame.onWrongAnswer(); // 0.6
      expect(flame.value, closeTo(0.60, 0.001));

      flame.onCorrectAnswer(); // 0.7
      expect(flame.value, closeTo(0.70, 0.001));

      flame.onWrongAnswer(); // 0.5
      expect(flame.value, closeTo(0.50, 0.001));
    });

    test('reset() returns to 1.0', () {
      flame.onWrongAnswer();
      flame.onWrongAnswer();
      flame.reset();
      expect(flame.value, 1.0);
      expect(flame.isAlive, isTrue);
    });

    test('flame color is danger red when <= 0.2', () {
      // Set to 0.2
      for (int i = 0; i < 4; i++) {
        flame.onWrongAnswer();
      }
      expect(flame.value, closeTo(0.20, 0.001));
      // The danger color is 0xFF8B2500
      expect(flame.flameColor, const Color(0xFF8B2500));
    });

    test('flame color is bright when >= 0.7 (> 0.7 check)', () {
      // Initially 1.0 which is > 0.7
      expect(flame.flameColor, const Color(0xFFE74C3C));
    });
  });
}
