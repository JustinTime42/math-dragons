import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/shared/math_problem.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

void main() {
  group('generateFacts', () {
    test('addition facts: all results > 0 and <= resultMax', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.add],
        resultMax: 10,
      );

      expect(facts, isNotEmpty);
      for (final fact in facts) {
        expect(fact.result, greaterThan(0));
        expect(fact.result, lessThanOrEqualTo(10));
        expect(fact.op, MathOp.add);
      }
    });

    test('subtraction facts: left > right always', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 10,
        operations: [MathOp.subtract],
        resultMax: 10,
      );

      expect(facts, isNotEmpty);
      for (final fact in facts) {
        expect(fact.left, greaterThan(fact.right),
            reason: '${fact.left} - ${fact.right} should have left > right');
        expect(fact.result, greaterThan(0));
      }
    });

    test('multiplication facts: all results <= resultMax', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 12,
        operations: [MathOp.multiply],
        resultMax: 144,
      );

      expect(facts, isNotEmpty);
      for (final fact in facts) {
        expect(fact.result, lessThanOrEqualTo(144));
        expect(fact.result, greaterThan(0));
      }
    });

    test('division facts: all results are integers', () {
      final facts = generateFacts(
        numberMin: 2,
        numberMax: 12,
        operations: [MathOp.divide],
        resultMax: 144,
      );

      expect(facts, isNotEmpty);
      for (final fact in facts) {
        expect(fact.left % fact.right, 0,
            reason: '${fact.left} / ${fact.right} should be evenly divisible');
        expect(fact.result, greaterThan(0));
      }
    });

    test('division facts: divisor >= 2', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 12,
        operations: [MathOp.divide],
        resultMax: 144,
      );

      for (final fact in facts) {
        expect(fact.right, greaterThanOrEqualTo(2),
            reason: 'Divisor should be >= 2, got ${fact.right}');
      }
    });

    test('commutative dedup: addition', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.add],
        resultMax: 10,
      );

      // Check for canonical form: left >= right for commutative ops
      for (final fact in facts) {
        expect(fact.left, greaterThanOrEqualTo(fact.right),
            reason:
                'Addition fact ${fact.left}+${fact.right} should have left >= right');
      }
    });

    test('commutative dedup: multiplication', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.multiply],
        resultMax: 25,
      );

      for (final fact in facts) {
        expect(fact.left, greaterThanOrEqualTo(fact.right),
            reason:
                'Mult fact ${fact.left}x${fact.right} should have left >= right');
      }
    });

    test('empty operations list produces empty facts', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 5,
        operations: [],
        resultMax: 10,
      );
      expect(facts, isEmpty);
    });

    test('tier 1 params produce only addition facts', () {
      final facts = generateFacts(
        numberMin: 1,
        numberMax: 5,
        operations: [MathOp.add],
        resultMax: 10,
      );

      for (final fact in facts) {
        expect(fact.op, MathOp.add);
      }
    });

    test('tier 6 params produce facts for all 4 operations', () {
      final facts = generateFacts(
        numberMin: 2,
        numberMax: 12,
        operations: [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide],
        resultMax: 144,
      );

      final ops = facts.map((f) => f.op).toSet();
      expect(ops, contains(MathOp.add));
      expect(ops, contains(MathOp.subtract));
      expect(ops, contains(MathOp.multiply));
      expect(ops, contains(MathOp.divide));
    });
  });

  group('MathFact', () {
    test('factKey is normalized for commutative ops', () {
      final fact = MathFact(left: 5, op: MathOp.add, right: 3);
      expect(fact.factKey, '3+5'); // smaller first
    });

    test('factKey preserves order for non-commutative ops', () {
      final fact = MathFact(left: 8, op: MathOp.subtract, right: 3);
      expect(fact.factKey, '8-3');
    });

    test('result is computed correctly', () {
      expect(MathFact(left: 3, op: MathOp.add, right: 5).result, 8);
      expect(MathFact(left: 10, op: MathOp.subtract, right: 3).result, 7);
      expect(MathFact(left: 4, op: MathOp.multiply, right: 6).result, 24);
      expect(MathFact(left: 12, op: MathOp.divide, right: 4).result, 3);
    });
  });
}
