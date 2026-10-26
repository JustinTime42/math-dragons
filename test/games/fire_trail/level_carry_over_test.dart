// FTT-3 (docs/specs/adaptive-practice.md section 9.3) plus Phase 1 unit tests
// for ProblemManager filling a level through selectBlueprint (section 10,
// Phase 1 step 3).
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/difficulty_engine.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/game_events.dart';
import 'package:math_dragons/games/fire_trail/models/fire_trail_config.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';
import 'package:math_dragons/games/fire_trail/systems/problem_manager.dart';
import 'package:math_dragons/games/shared/difficulty_config.dart';
import 'package:math_dragons/games/shared/math_problem.dart';
import 'package:math_dragons/games/shared/problem_generation.dart';

import '../../support/fake_storage.dart';

/// Records every selectBlueprint call and its result.
class RecordingEngine extends DifficultyEngine {
  final bool alwaysExhausted;
  final List<String?> results = [];

  RecordingEngine({
    required super.factTracker,
    super.random,
    this.alwaysExhausted = false,
  });

  @override
  ProblemBlueprint? selectBlueprint(
    List<MathFact> eligibleFacts, {
    bool Function(MathFact fact)? accept,
  }) {
    final result = alwaysExhausted
        ? null
        : super.selectBlueprint(eligibleFacts, accept: accept);
    results.add(result?.fact.factKey);
    return result;
  }
}

List<AnswerGemData> placeLevel(ProblemManager manager) {
  return manager.placeLevelAnswerGems(
    head: const GridPosition(7, 7),
    trail: const [GridPosition(6, 7), GridPosition(5, 7)],
    gridSize: 15,
  );
}

void main() {
  // Real world 1 level 1 config: addition 1-5, 4 answer gems.
  final config = FireTrailConfig.forLevel(1, 1);

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

  test('config precondition: 4 gems from the addition 1-5 pool', () {
    expect(config.answerGemCount, 4);
    expect(config.numberMin, 1);
    expect(config.numberMax, 5);
  });

  test('FTT-3 a fact missed in level L is in level L+1', () async {
    final now = DateTime.now();
    for (int seed = 0; seed < 50; seed++) {
      // 2+3 is known and due for review, so level L presents it first.
      // Every other fact in the pool is new.
      storage.facts
        ..clear()
        ..['2+3'] = FactRecord(
          factKey: '2+3',
          timesPresented: 10,
          timesCorrect: 9,
          currentStreak: 3,
          lastPresented: now.subtract(const Duration(days: 10)),
        );
      final engine = DifficultyEngine(
        factTracker: tracker,
        random: Random(seed),
      );

      // Level L.
      final levelL = ProblemManager(config: config)
        ..difficultyEngine = engine
        ..initFactPool();
      final gemsL = placeLevel(levelL);
      expect(gemsL.first.problem.factKey, '2+3', reason: 'seed $seed');

      // Miss on the first attempt, then the correct retry on the same prompt.
      for (final (correct, firstAttempt) in [(false, true), (true, false)]) {
        bus.emit(
          AnswerGiven(
            gameId: 'fire_trail',
            problem: '2+3',
            playerAnswer: correct ? '5' : 'wrong',
            correctAnswer: '5',
            correct: correct,
            responseTimeMs: 2000,
            factKey: '2+3',
            firstAttempt: firstAttempt,
          ),
        );
      }
      await pumpEventQueue();

      // Level L+1: the screen builds a new flame game (and ProblemManager)
      // with the same engine.
      final levelL1 = ProblemManager(config: config)
        ..difficultyEngine = engine
        ..initFactPool();
      final keysL1 = placeLevel(levelL1).map((g) => g.problem.factKey);
      expect(keysL1, contains('2+3'), reason: 'seed $seed: got $keysL1');
    }
  });

  group('ProblemManager fills a level through selectBlueprint', () {
    test('every gem comes from the engine when the pool has enough distinct '
        'answers', () {
      final pool = FactPool.forLevel(
        numberMin: config.numberMin,
        numberMax: config.numberMax,
        operations: config.allowedOperations,
      ).map((f) => f.factKey);
      for (int seed = 0; seed < 50; seed++) {
        final engine = RecordingEngine(
          factTracker: tracker,
          random: Random(seed),
        );
        final manager = ProblemManager(config: config)
          ..difficultyEngine = engine
          ..initFactPool();
        final gems = placeLevel(manager);
        final keys = gems.map((g) => g.problem.factKey).toList();
        final answers = gems.map((g) => g.value).toList();

        expect(gems, hasLength(config.answerGemCount));
        expect(answers.toSet(), hasLength(answers.length));
        expect(answers.every((a) => a > 0), isTrue);
        expect(pool, containsAll(keys));
        expect(engine.results, keys, reason: 'no random fallback, no vetoes');
        expect(manager.currentProblem!.factKey, keys.first);
      }
    });

    test('falls back to random generation only when the engine is '
        'exhausted', () {
      final engine = RecordingEngine(
        factTracker: tracker,
        alwaysExhausted: true,
      );
      final manager = ProblemManager(config: config)
        ..difficultyEngine = engine
        ..initFactPool();
      final gems = placeLevel(manager);
      final answers = gems.map((g) => g.value).toList();

      expect(engine.results, isNotEmpty);
      expect(gems, hasLength(config.answerGemCount));
      expect(answers.toSet(), hasLength(answers.length));
    });
  });
}
