// Contract tests for FactTracker <-> AnswerGiven (spec
// docs/specs/adaptive-practice.md section 9.1, TR-1..TR-5; interfaces I-1, I-2).
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/game_events.dart';

import '../support/fake_storage.dart';

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

  Future<void> emit({
    String problem = 'ignored',
    String? factKey,
    bool correct = true,
    bool firstAttempt = true,
    int responseTimeMs = 1200,
  }) async {
    bus.emit(
      AnswerGiven(
        gameId: 'test_game',
        problem: problem,
        playerAnswer: correct ? 'right' : 'wrong',
        correctAnswer: 'right',
        correct: correct,
        responseTimeMs: responseTimeMs,
        factKey: factKey,
        firstAttempt: firstAttempt,
      ),
    );
    await pumpEventQueue();
  }

  test('TR-1 factKey is stored verbatim, regardless of problem', () async {
    await emit(problem: '4 × 3 = 12', factKey: '3x4');

    expect(storage.facts.keys, ['3x4']);
    expect(storage.facts['3x4']!.timesPresented, 1);
    expect(storage.facts['3x4']!.timesCorrect, 1);
  });

  test('TR-2 firstAttempt: false changes no record', () async {
    await emit(factKey: '3x4', correct: false, firstAttempt: false);
    expect(storage.facts, isEmpty);

    await emit(factKey: '3x4', correct: true);
    final before = storage.facts['3x4']!;
    await emit(factKey: '3x4', correct: false, firstAttempt: false);
    await emit(factKey: '3x4', correct: true, firstAttempt: false);
    final after = storage.facts['3x4']!;

    expect(after.timesPresented, before.timesPresented);
    expect(after.timesCorrect, before.timesCorrect);
    expect(after.currentStreak, before.currentStreak);
    expect(after.lastPresented, before.lastPresented);
    expect(after.lastIncorrect, before.lastIncorrect);
    expect(after.totalResponseTimeMs, before.totalResponseTimeMs);
  });

  test(
    'TR-3 a miss then a non-first-attempt correct retry keeps the miss open',
    () async {
      await emit(factKey: '7x8', correct: false);
      await emit(factKey: '7x8', correct: true, firstAttempt: false);

      final record = storage.facts['7x8']!;
      expect(record.currentStreak, 0);
      expect(record.lastIncorrect, isNotNull);
      expect(record.timesPresented, 1);
      expect(record.timesCorrect, 0);
    },
  );

  group('TR-4 keys failing PracticeKey.isValid create no record', () {
    const invalid = {
      'invalid': 'Runes invalid chain',
      'even:correct': 'old Feast outcome key',
      '7−34': 'U+2212 minus from old Runes display text',
      '7/2': 'non-integral division',
      '3-7': 'result <= 0',
      '4x3': 'non-canonical operand order',
    };
    for (final entry in invalid.entries) {
      test('"${entry.key}" (${entry.value})', () async {
        await emit(problem: entry.key, correct: false);
        await emit(problem: entry.key, correct: true);
        expect(storage.facts, isEmpty);
      });
    }

    test('a grammatical but corrupt key such as "2+35" still passes', () async {
      await emit(problem: '2+35', correct: true);
      expect(storage.facts.keys, ['2+35']);
    });
  });

  test('TR-5 legacy event without factKey still records "7x8"', () async {
    await emit(problem: '7 × 8', correct: true);

    expect(storage.facts.keys, ['7x8']);
    expect(storage.facts['7x8']!.timesCorrect, 1);
  });
}
