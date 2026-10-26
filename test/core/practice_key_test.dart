import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/practice_key.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/shared/math_problem.dart';

void main() {
  group('PracticeKey.isValid', () {
    test('accepts canonical arithmetic facts', () {
      for (final key in ['7x8', '13-4', '12/3', '3+5', '3+3', '1x1', '144/12']) {
        expect(PracticeKey.isValid(key), isTrue, reason: key);
        expect(PracticeKey.isArithmetic(key), isTrue, reason: key);
        expect(PracticeKey.isProperty(key), isFalse, reason: key);
      }
    });

    test('accepts property items', () {
      for (final key in ['mult_3:12', 'prime:17', 'range_10_20:15', 'gt_5:9']) {
        expect(PracticeKey.isValid(key), isTrue, reason: key);
        expect(PracticeKey.isProperty(key), isTrue, reason: key);
        expect(PracticeKey.isArithmetic(key), isFalse, reason: key);
      }
    });

    test('rejects non-canonical commutative order', () {
      expect(PracticeKey.isValid('4x3'), isFalse);
      expect(PracticeKey.isValid('5+3'), isFalse);
    });

    test('rejects non-positive results', () {
      expect(PracticeKey.isValid('3-7'), isFalse);
      expect(PracticeKey.isValid('5-5'), isFalse);
      expect(PracticeKey.isValid('0x5'), isFalse);
      expect(PracticeKey.isValid('0+0'), isFalse);
      expect(PracticeKey.isValid('0/3'), isFalse);
    });

    test('rejects uneven division and divisors below 2', () {
      expect(PracticeKey.isValid('7/2'), isFalse);
      expect(PracticeKey.isValid('7/1'), isFalse);
      expect(PracticeKey.isValid('7/0'), isFalse);
    });

    test('rejects anything outside both grammars', () {
      for (final key in [
        '',
        'invalid',
        'even:correct',
        'mult3:wrong',
        '7−34',
        '7 x 8',
        '7x8=56',
        '1234+1',
        'Prime:17',
        ':17',
        '-3+5',
      ]) {
        expect(PracticeKey.isValid(key), isFalse, reason: key);
      }
    });
  });

  test('forFact and forProperty build valid keys', () {
    final fact = MathFact(left: 8, op: MathOp.multiply, right: 7);
    expect(PracticeKey.forFact(fact), '7x8');
    expect(PracticeKey.isValid(PracticeKey.forFact(fact)), isTrue);
    expect(PracticeKey.forProperty('mult_3', 12), 'mult_3:12');
  });
}
