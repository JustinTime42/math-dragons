import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/fire_trail/models/fire_trail_config.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';
import 'package:math_dragons/games/fire_trail/systems/problem_manager.dart';

void main() {
  group('Gem Placement', () {
    late ProblemManager manager;

    setUp(() {
      manager = ProblemManager(
        config: const FireTrailConfig(
          worldNumber: 1,
          levelInWorld: 1,
          numberMin: 1,
          numberMax: 10,
          allowedOperations: [MathOp.add],
          stepsPerSecond: 4.0,
          distractorCount: 3,
          wrapMode: false,
          correctToAdvance: 6,
        ),
      );
      manager.generateProblem();
    });

    test('always produces exactly 1 correct gem', () {
      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final gems = manager.placeGems(
          head: const GridPosition(7, 7),
          trail: const [GridPosition(6, 7), GridPosition(5, 7)],
          gridSize: 15,
        );
        final correctGems = gems.where((g) => g.isCorrect).toList();
        expect(correctGems.length, 1);
      }
    });

    test('produces the requested number of distractors', () {
      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final gems = manager.placeGems(
          head: const GridPosition(7, 7),
          trail: const [GridPosition(6, 7), GridPosition(5, 7)],
          gridSize: 15,
        );
        final distractors = gems.where((g) => !g.isCorrect).toList();
        // Should have 3 distractors (config.distractorCount)
        expect(distractors.length, 3);
      }
    });

    test('no gems placed on dragon head position', () {
      final head = const GridPosition(7, 7);
      manager.generateProblem();
      final gems = manager.placeGems(
        head: head,
        trail: const [GridPosition(6, 7)],
        gridSize: 15,
      );
      expect(gems.any((g) => g.position == head), isFalse);
    });

    test('no gems placed on trail positions', () {
      final trail = [
        const GridPosition(6, 7),
        const GridPosition(5, 7),
        const GridPosition(4, 7),
      ];
      manager.generateProblem();
      final gems = manager.placeGems(
        head: const GridPosition(7, 7),
        trail: trail,
        gridSize: 15,
      );
      for (final t in trail) {
        expect(gems.any((g) => g.position == t), isFalse);
      }
    });

    test('correct gem value matches problem answer', () {
      manager.generateProblem();
      final gems = manager.placeGems(
        head: const GridPosition(7, 7),
        trail: const [GridPosition(6, 7)],
        gridSize: 15,
      );
      final correctGem = gems.firstWhere((g) => g.isCorrect);
      expect(correctGem.value, manager.currentProblem!.answer);
    });

    test('distractor values are not equal to correct answer', () {
      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final gems = manager.placeGems(
          head: const GridPosition(7, 7),
          trail: const [GridPosition(6, 7)],
          gridSize: 15,
        );
        final distractors = gems.where((g) => !g.isCorrect);
        for (final d in distractors) {
          expect(d.value, isNot(manager.currentProblem!.answer));
        }
      }
    });

    test('all gem positions are within grid bounds', () {
      manager.generateProblem();
      final gems = manager.placeGems(
        head: const GridPosition(7, 7),
        trail: const [GridPosition(6, 7)],
        gridSize: 15,
      );
      for (final g in gems) {
        expect(g.position.x, inInclusiveRange(0, 14));
        expect(g.position.y, inInclusiveRange(0, 14));
      }
    });

    test('no two gems share the same position', () {
      manager.generateProblem();
      final gems = manager.placeGems(
        head: const GridPosition(7, 7),
        trail: const [GridPosition(6, 7)],
        gridSize: 15,
      );
      final positions = gems.map((g) => g.position).toSet();
      expect(positions.length, gems.length);
    });

    test('no duplicate values among gems', () {
      for (int i = 0; i < 20; i++) {
        manager.generateProblem();
        final gems = manager.placeGems(
          head: const GridPosition(7, 7),
          trail: const [GridPosition(6, 7)],
          gridSize: 15,
        );
        final values = gems.map((g) => g.value).toSet();
        expect(values.length, gems.length);
      }
    });
  });
}
