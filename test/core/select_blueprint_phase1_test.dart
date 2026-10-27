// Phase 1 selection tests against DifficultyEngine.selectBlueprint (I-8):
// the accept veto, and the Phase 1 version of SP-3 (return after miss) from
// docs/specs/adaptive-practice.md sections 9.2 and 9.5 (claim C2-FT).
//
// Determinism: Random is seeded per run. DifficultyEngine has no injectable
// clock until I-7 (Phase 2), so "now" is captured once and every fixture time
// is relative to it; all scheduling thresholds are in days, so the result does
// not depend on the exact wall-clock time.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/difficulty_engine.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/game_events.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/shared/math_problem.dart';
import 'package:math_dragons/games/shared/problem_generation.dart';

import '../support/fake_storage.dart';

/// Spec section 5 "Weak": open miss (lastIncorrect != null and fewer than
/// cleanAnswersToCloseMiss = 2 consecutive correct first attempts since) or
/// mastery band needsPractice.
bool isWeak(FactRecord? record) {
  if (record == null) return false;
  final openMiss = record.lastIncorrect != null && record.currentStreak < 2;
  final band = MasteryEstimate.fromRecord(record).band;
  return openMiss || band == MasteryBand.needsPractice;
}

void main() {
  late EventBus bus;
  late FakeStorage storage;
  late FactTracker tracker;

  setUp(() {
    bus = EventBus();
    storage = FakeStorage();
    tracker = FactTracker(eventBus: bus, storage: storage);
  });

  tearDown(() {
    tracker.dispose();
    bus.dispose();
  });

  Future<void> answer(
    String key, {
    required bool correct,
    bool firstAttempt = true,
  }) async {
    bus.emit(
      AnswerGiven(
        gameId: 'fire_trail',
        problem: key,
        playerAnswer: correct ? 'right' : 'wrong',
        correctAnswer: 'right',
        correct: correct,
        responseTimeMs: 1500,
        factKey: key,
        firstAttempt: firstAttempt,
      ),
    );
    await pumpEventQueue();
  }

  group('selectBlueprint accept (I-8)', () {
    test('restricts the choice and does not record vetoed facts', () {
      final pool = [
        MathFact(left: 1, op: MathOp.add, right: 1),
        MathFact(left: 2, op: MathOp.add, right: 1),
        MathFact(left: 2, op: MathOp.add, right: 2),
        MathFact(left: 3, op: MathOp.add, right: 1),
      ];
      for (int seed = 0; seed < 50; seed++) {
        final engine = DifficultyEngine(
          factTracker: tracker,
          random: Random(seed),
        );
        for (final key in ['1+1', '1+2', '2+2']) {
          final picked = engine.selectBlueprint(
            pool,
            accept: (f) => f.factKey == key,
          );
          expect(picked?.fact.factKey, key, reason: 'seed $seed');
        }

        expect(engine.selectBlueprint(pool, accept: (_) => false), isNull);

        // Only 1+1, 1+2 and 2+2 were selections, so the repeat window (3)
        // leaves exactly one candidate.
        expect(engine.selectBlueprint(pool)!.fact.factKey, '1+3');
      }
    });
  });

  group('SP-3 (Phase 1 version) return after miss', () {
    // Fixture A: multiplication 2-9 x 2-9 canonical (36 facts), all known.
    final pool = generateFacts(
      numberMin: 2,
      numberMax: 9,
      operations: [MathOp.multiply],
      resultMax: 81,
    );

    void seedFixtureA(DateTime now) {
      storage.facts.clear();
      for (final fact in pool) {
        storage.facts[fact.factKey] = FactRecord(
          factKey: fact.factKey,
          timesPresented: 10,
          timesCorrect: 9,
          currentStreak: 3,
          lastPresented: now.subtract(const Duration(hours: 1)),
        );
      }
    }

    test('fixture A has 36 facts including 7x8', () {
      expect(pool, hasLength(36));
      expect(pool.map((f) => f.factKey), contains('7x8'));
    });

    test('a missed fact returns after 3 to 5 other selections, then closes '
        'after two clean first attempts', () async {
      final now = DateTime.now();
      for (int seed = 0; seed < 50; seed++) {
        seedFixtureA(now);
        final engine = DifficultyEngine(
          factTracker: tracker,
          random: Random(seed),
        );

        // Selection 1 is 7x8.
        final first = engine.selectBlueprint(
          pool,
          accept: (f) => f.factKey == '7x8',
        );
        expect(first!.fact.factKey, '7x8');

        // Fire Trail pattern: a miss on the first attempt, then the forced
        // correct retry on the same prompt.
        await answer('7x8', correct: false);
        await answer('7x8', correct: true, firstAttempt: false);
        expect(isWeak(storage.facts['7x8']), isTrue, reason: 'seed $seed');

        int? returnedAt;
        for (int index = 2; index <= 12; index++) {
          final blueprint = engine.selectBlueprint(pool)!;
          final key = blueprint.fact.factKey;
          if (key == '7x8') {
            returnedAt = index;
            break;
          }
          await answer(key, correct: true);
        }

        expect(returnedAt, isNotNull, reason: 'seed $seed: 7x8 never returned');
        expect(
          returnedAt,
          inInclusiveRange(5, 7),
          reason: 'seed $seed: 7x8 returned at selection $returnedAt',
        );

        // Two clean first attempts close the miss.
        await answer('7x8', correct: true);
        await answer('7x8', correct: true);
        final record = storage.facts['7x8']!;
        expect(record.currentStreak, 2, reason: 'seed $seed');
        expect(isWeak(record), isFalse, reason: 'seed $seed');

        final again = engine.selectBlueprint(
          pool,
          accept: (f) => f.factKey == '7x8',
        )!;
        expect(again.dueReason, isNot(ProblemDueReason.correction));
        expect(again.dueReason, isNot(ProblemDueReason.needsPractice));
      }
    });
  });
}
