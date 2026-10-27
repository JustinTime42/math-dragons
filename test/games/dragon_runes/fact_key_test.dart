// RUT-1 (docs/specs/adaptive-practice.md section 9.3, rule RU-d).
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/systems/equation_validator.dart';

void main() {
  group('RUT-1 target text maps to the canonical fact key', () {
    const cases = {
      '4 × 3 = 12': '3x4',
      '13 − 4 = 9': '13-4',
      '12 ÷ 3 = 4': '12/3',
      '2 + 3 = 5': '2+3',
    };
    for (final entry in cases.entries) {
      test('"${entry.key}" -> "${entry.value}"', () {
        expect(EquationValidator.factKeyForEquation(entry.key), entry.value);
      });
    }
  });

  group('equations that are not one valid fact map to null', () {
    for (final text in [
      '2 + 3 = 1 + 4', // multi-operator bonus chain
      '1 + 2 + 3 = 6', // multi-operator bonus chain
      '2 + 3 = 6', // false equation
      '7 ÷ 2 = 3', // uneven division
      '5 − 5 = 0', // non-positive result
      'invalid',
      '',
    ]) {
      test('"$text"', () {
        expect(EquationValidator.factKeyForEquation(text), isNull);
      });
    }
  });

  test('a reversed single-operator chain maps to the same fact', () {
    expect(EquationValidator.factKeyForEquation('12 = 3 × 4'), '3x4');
    expect(EquationValidator.factKeyForEquation('9 = 13 − 4'), '13-4');
  });
}
