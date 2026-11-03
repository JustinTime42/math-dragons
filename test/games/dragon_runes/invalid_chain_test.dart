// RUT-4 (docs/specs/adaptive-practice.md section 9.3, rule RU-e, interface
// I-9): an invalid chain of exactly `a op b = c` with a valid fact on the left
// carries the attempted fact, and Runes records it as a miss on that fact.
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart' as egg;
import 'package:math_dragons/games/dragon_runes/dragon_runes_game.dart';
import 'package:math_dragons/games/dragon_runes/models/rune_node_data.dart';
import 'package:math_dragons/games/dragon_runes/systems/equation_validator.dart';

import '../../support/fake_storage.dart';

List<RuneNodeData> _nodes(List<String> values) => values.map((v) {
      if (v == '=') return RuneNodeData(type: RuneNodeType.equals, value: v);
      final n = int.tryParse(v);
      if (n != null) {
        return RuneNodeData(
          type: RuneNodeType.number,
          value: v,
          numericValue: n,
        );
      }
      return RuneNodeData(type: RuneNodeType.operator, value: v);
    }).toList();

/// Validates the chain written as space-separated tokens, in order.
EquationResult _validate(String chain) {
  final values = chain.split(' ');
  return EquationValidator(
    nodes: _nodes(values),
    targets: const [],
    solvedTargets: {},
    foundCanonicals: {},
  ).validate(List.generate(values.length, (i) => i));
}

InvalidEquation _invalid(String chain) {
  final result = _validate(chain);
  expect(result, isA<InvalidEquation>(), reason: chain);
  return result as InvalidEquation;
}

void main() {
  group('RUT-4 InvalidEquation carries the attempted fact', () {
    test('3 + 5 = 9 -> attemptedFact 3+5, attemptedAnswer 9', () {
      final result = _invalid('3 + 5 = 9');
      expect(result.attemptedFact, isNotNull);
      expect(result.attemptedFact!.left, 3);
      expect(result.attemptedFact!.op, egg.MathOp.add);
      expect(result.attemptedFact!.right, 5);
      expect(result.attemptedFact!.factKey, '3+5');
      expect(result.attemptedAnswer, 9);
    });

    test('3 + = 5 -> no attempted fact', () {
      final result = _invalid('3 + = 5');
      expect(result.attemptedFact, isNull);
      expect(result.attemptedAnswer, isNull);
    });

    // Every operator, written with the glyphs the rune circle uses.
    const keyed = {
      '5 + 3 = 9': ('3+5', 9), // commutative: canonical order
      '13 − 4 = 8': ('13-4', 8),
      '4 × 3 = 13': ('3x4', 13),
      '12 ÷ 3 = 5': ('12/3', 5),
    };
    for (final MapEntry(key: chain, value: (key, answer)) in keyed.entries) {
      test('"$chain" -> "$key", answer $answer', () {
        final result = _invalid(chain);
        expect(result.attemptedFact?.factKey, key);
        expect(result.attemptedAnswer, answer);
      });
    }

    for (final chain in [
      '9 = 3 + 5', // reversed: I-9 requires the fact on the left
      '1 + 2 + 3 = 7', // multi-operator left side
      '3 + 5 = 4 + 5', // multi-operator right side
      '7 ÷ 2 = 3', // non-integral division: "7/2" fails PracticeKey
      '3 − 7 = 4', // negative result: "3-7" fails PracticeKey
      '5 − 5 = 1', // zero result: "5-5" fails PracticeKey
      '6 ÷ 0 = 1', // division by zero
      '3 + 5', // no equals sign
      '3 5 = 9', // no operator
    ]) {
      test('"$chain" -> no attempted fact', () {
        final result = _invalid(chain);
        expect(result.attemptedFact, isNull);
        expect(result.attemptedAnswer, isNull);
      });
    }
  });

  group('RUT-4 invalid chain AnswerGiven', () {
    test('3 + 5 = 9 emits a first-attempt miss on "3+5"', () {
      final event = DragonRunesScreen.invalidAnswerEvent(
        _invalid('3 + 5 = 9'),
        responseTimeMs: 1500,
      );
      expect(event.gameId, 'dragon_runes');
      expect(event.correct, isFalse);
      expect(event.factKey, '3+5');
      expect(event.firstAttempt, isTrue);
      expect(event.playerAnswer, '9');
      expect(event.correctAnswer, '8');
      expect(event.responseTimeMs, 1500);
    });

    test('3 + = 5 emits factKey: null', () {
      final event = DragonRunesScreen.invalidAnswerEvent(
        _invalid('3 + = 5'),
        responseTimeMs: 1500,
      );
      expect(event.correct, isFalse);
      expect(event.factKey, isNull);
    });

    group('through FactTracker', () {
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

      Future<void> emitInvalid(String chain) async {
        bus.emit(
          DragonRunesScreen.invalidAnswerEvent(
            _invalid(chain),
            responseTimeMs: 1500,
          ),
        );
        await pumpEventQueue();
      }

      test('3 + 5 = 9 records a miss on "3+5" and nothing else', () async {
        await emitInvalid('3 + 5 = 9');
        expect(storage.getAllFacts().map((r) => r.factKey), ['3+5']);
        final record = tracker.getFact('3+5')!;
        expect(record.timesPresented, 1);
        expect(record.timesCorrect, 0);
        expect(record.lastIncorrect, isNotNull);
      });

      // Without a factKey FactTracker normalizes `problem`; none of these may
      // leak a grammatical key such as "93+5" from "9 = 3 + 5".
      for (final chain in ['3 + = 5', '9 = 3 + 5', '1 + 2 + 3 = 7']) {
        test('"$chain" records nothing', () async {
          await emitInvalid(chain);
          expect(storage.getAllFacts(), isEmpty);
        });
      }
    });
  });
}
