import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/difficulty_engine.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/fire_trail/models/fire_trail_config.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';
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
        expect(
          p.left % p.right,
          0,
          reason: '${p.left} / ${p.right} should be integer',
        );
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
      expect(
        seenOps,
        containsAll([
          MathOp.add,
          MathOp.subtract,
          MathOp.multiply,
          MathOp.divide,
        ]),
      );
    });

    test(
      'uses blueprint-selected correction fact when difficulty engine is present',
      () {
        final tracker = FakeFactTracker();
        tracker.addFact(
          '2+3',
          FactRecord(
            factKey: '2+3',
            timesPresented: 4,
            timesCorrect: 2,
            currentStreak: 0,
            lastPresented: DateTime(2026),
            lastIncorrect: DateTime(2026),
          ),
        );
        final manager =
            ProblemManager(
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
              )
              ..difficultyEngine = DifficultyEngine(factTracker: tracker)
              ..initFactPool();

        manager.generateProblem();

        expect(manager.currentProblem!.factKey, '2+3');
        expect(manager.currentProblem!.answer, 5);
      },
    );

    test(
      'answer gems contain exactly one correct value and positive unique distractors',
      () {
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
        final gems = manager.placeGems(
          head: const GridPosition(0, 0),
          trail: const [],
          gridSize: 5,
        );
        final values = gems.map((g) => g.value).toList();

        expect(gems.where((g) => g.isCorrect), hasLength(1));
        expect(values.toSet(), hasLength(values.length));
        expect(values.every((value) => value > 0), isTrue);
        for (final gem in gems.where((g) => !g.isCorrect)) {
          expect(gem.value, isNot(manager.currentProblem!.answer));
        }
      },
    );
  });
}

class FakeFactTracker implements FactTracker {
  final Map<String, FactRecord> _records = {};

  void addFact(String key, FactRecord record) {
    _records[key] = record;
  }

  @override
  FactRecord? getFact(String factKey) => _records[factKey];

  @override
  List<FactRecord> getAllFacts() => _records.values.toList();

  @override
  List<FactRecord> getFactsByStatus(FactStatus status) {
    return _records.values.where((record) => record.status == status).toList();
  }

  @override
  Map<FactStatus, int> getStatusCounts() {
    final counts = <FactStatus, int>{};
    for (final record in _records.values) {
      counts[record.status] = (counts[record.status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  int get masteredFactCount => _records.values
      .where((record) => record.status == FactStatus.mastered)
      .length;

  @override
  List<FactRecord> factsNotSeenSince(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _records.values
        .where(
          (record) =>
              record.lastPresented != null &&
              record.lastPresented!.isBefore(cutoff),
        )
        .toList();
  }

  @override
  void dispose() {}
}
