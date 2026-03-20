import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/fire_trail/models/fire_trail_config.dart';
import 'package:math_dragons/games/fire_trail/systems/problem_manager.dart';

void main() {
  group('ProblemManager', () {
    test('generates addition problems with correct answer', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 1,
          levelInWorld: 1,
          numberMin: 1,
          numberMax: 5,
          allowedOperations: [MathOp.add],
          stepsPerSecond: 4.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 6,
        ),
      );

      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final p = manager.currentProblem!;
        expect(p.op, MathOp.add);
        expect(p.answer, p.left + p.right);
      }
    });

    test('subtraction has left >= right (no negative results)', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 2,
          levelInWorld: 1,
          numberMin: 1,
          numberMax: 10,
          allowedOperations: [MathOp.subtract],
          stepsPerSecond: 5.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 8,
        ),
      );

      for (int i = 0; i < 50; i++) {
        manager.generateProblem();
        final p = manager.currentProblem!;
        expect(p.left, greaterThanOrEqualTo(p.right));
        expect(p.answer, greaterThanOrEqualTo(0));
      }
    });

    test('multiplication has correct answer', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 3,
          levelInWorld: 1,
          numberMin: 2,
          numberMax: 10,
          allowedOperations: [MathOp.multiply],
          stepsPerSecond: 7.0,
          distractorCount: 4,
          wrapMode: false,
          correctToAdvance: 10,
        ),
      );

      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final p = manager.currentProblem!;
        expect(p.answer, p.left * p.right);
      }
    });

    test('division produces integer results', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 4,
          levelInWorld: 1,
          numberMin: 2,
          numberMax: 12,
          allowedOperations: [MathOp.divide],
          stepsPerSecond: 9.0,
          distractorCount: 4,
          wrapMode: false,
          correctToAdvance: 12,
        ),
      );

      for (int i = 0; i < 50; i++) {
        manager.generateProblem();
        final p = manager.currentProblem!;
        expect(p.left % p.right, 0, reason: '${p.left} / ${p.right} should be integer');
        expect(p.answer, p.left ~/ p.right);
      }
    });

    test('problem display format is "a op b"', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 1,
          levelInWorld: 1,
          numberMin: 1,
          numberMax: 5,
          allowedOperations: [MathOp.add],
          stepsPerSecond: 4.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 6,
        ),
      );

      manager.generateProblem();
      final p = manager.currentProblem!;
      expect(p.displayText, contains('+'));
      expect(p.displayText, isNot(contains('=')));
    });

    test('respects numberMin/numberMax constraints', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 1,
          levelInWorld: 1,
          numberMin: 3,
          numberMax: 7,
          allowedOperations: [MathOp.add],
          stepsPerSecond: 4.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 6,
        ),
      );

      for (int i = 0; i < 50; i++) {
        manager.generateProblem();
        final p = manager.currentProblem!;
        expect(p.left, inInclusiveRange(3, 7));
        expect(p.right, inInclusiveRange(3, 7));
      }
    });

    test('only uses allowed operations', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 1,
          levelInWorld: 1,
          numberMin: 1,
          numberMax: 5,
          allowedOperations: [MathOp.add],
          stepsPerSecond: 4.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 6,
        ),
      );

      for (int i = 0; i < 30; i++) {
        manager.generateProblem();
        expect(manager.currentProblem!.op, MathOp.add);
      }
    });

    test('all 4 ops can appear when all allowed', () {
      final manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 4,
          levelInWorld: 1,
          numberMin: 2,
          numberMax: 12,
          allowedOperations: [
            MathOp.add,
            MathOp.subtract,
            MathOp.multiply,
            MathOp.divide,
          ],
          stepsPerSecond: 9.0,
          distractorCount: 4,
          wrapMode: false,
          correctToAdvance: 12,
        ),
      );

      final seenOps = <MathOp>{};
      for (int i = 0; i < 200; i++) {
        manager.generateProblem();
        seenOps.add(manager.currentProblem!.op);
      }
      expect(seenOps, containsAll([MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide]));
    });
  });
}
