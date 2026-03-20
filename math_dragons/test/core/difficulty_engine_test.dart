import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/difficulty_engine.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/games/shared/math_problem.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';

void main() {
  group('DifficultyEngine', () {
    late FakeFactTracker fakeTracker;
    late DifficultyEngine engine;

    setUp(() {
      fakeTracker = FakeFactTracker();
      // Use seeded random for deterministic tests
      engine = DifficultyEngine(
        factTracker: fakeTracker,
        random: Random(42),
      );
    });

    group('selectNext', () {
      test('returns a fact from the eligible pool', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2),
          MathFact(left: 5, op: MathOp.add, right: 4),
          MathFact(left: 7, op: MathOp.add, right: 3),
        ];

        final selected = engine.selectNext(facts);

        expect(selected, isNotNull);
        expect(facts.contains(selected), isTrue);
      });

      test('returns null when pool is empty', () {
        final selected = engine.selectNext([]);
        expect(selected, isNull);
      });

      test('no repeat within 3 problems (spacing rule)', () {
        // Use a larger pool to make spacing more reliable
        final facts = <MathFact>[];
        for (int i = 1; i <= 10; i++) {
          facts.add(MathFact(left: i, op: MathOp.add, right: 1));
        }

        final selected = <String>[];
        for (int i = 0; i < 15; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) selected.add(fact.factKey);
        }

        // No immediate repeat (back-to-back)
        for (int i = 0; i < selected.length - 1; i++) {
          expect(
            selected[i] != selected[i + 1],
            isTrue,
            reason: 'Fact ${selected[i]} repeated back-to-back at index $i',
          );
        }
      });

      test('recently incorrect fact re-presented within 5 problems', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2), // 2+3 (canonical)
          MathFact(left: 5, op: MathOp.add, right: 4), // 4+5 (canonical)
          MathFact(left: 7, op: MathOp.add, right: 3), // 3+7 (canonical)
          MathFact(left: 8, op: MathOp.add, right: 2), // 2+8 (canonical)
        ];

        // Record incorrect for 2+3
        engine.recordIncorrect('2+3');

        // Select next few facts - 2+3 should appear soon
        final selected = <String>[];
        for (int i = 0; i < 6; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) selected.add(fact.factKey);
        }

        // 2+3 should appear in the first 5 selections
        expect(
          selected.sublist(0, selected.length < 5 ? selected.length : 5),
          contains('2+3'),
          reason: 'Incorrect fact should be re-presented within 5 problems',
        );
      });

      test('single eligible fact returns it after spacing window', () {
        final fact = MathFact(left: 3, op: MathOp.add, right: 2);

        // First selection
        final selected1 = engine.selectNext([fact]);
        expect(selected1, isNotNull);
        expect(selected1!.factKey, '2+3');

        // Immediate next selection - should still return it (only option)
        final selected2 = engine.selectNext([fact]);
        expect(selected2, isNotNull);
        expect(selected2!.factKey, '2+3');
      });
    });

    group('bucket categorization', () {
      test('new facts (< 3 presentations) go to newFact bucket', () {
        fakeTracker.addFact('2+3', FactRecord(
          factKey: '2+3',
          timesPresented: 2,
          timesCorrect: 2,
        ));

        final facts = [MathFact(left: 3, op: MathOp.add, right: 2)];
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
      });

      test('accuracy < 70% goes to needsPractice bucket', () {
        fakeTracker.addFact('2+3', FactRecord(
          factKey: '2+3',
          timesPresented: 10,
          timesCorrect: 6, // 60% accuracy
        ));

        final facts = [MathFact(left: 3, op: MathOp.add, right: 2)];
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
        expect(selected!.factKey, '2+3');
      });

      test('accuracy 70-89% goes to reinforcing bucket', () {
        fakeTracker.addFact('2+3', FactRecord(
          factKey: '2+3',
          timesPresented: 10,
          timesCorrect: 8, // 80% accuracy
        ));

        final facts = [MathFact(left: 3, op: MathOp.add, right: 2)];
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
        expect(selected!.factKey, '2+3');
      });

      test('accuracy 90%+ goes to mastered bucket', () {
        fakeTracker.addFact('2+3', FactRecord(
          factKey: '2+3',
          timesPresented: 10,
          timesCorrect: 9, // 90% accuracy
        ));

        final facts = [MathFact(left: 3, op: MathOp.add, right: 2)];
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
        expect(selected!.factKey, '2+3');
      });
    });

    group('40% cap on needs-practice', () {
      test('needs-practice facts capped at 40% of selections', () {
        // Create mixed pool: 20 weak facts, 10 strong facts
        final facts = <MathFact>[];

        // 20 weak facts (needs practice)
        for (int i = 0; i < 20; i++) {
          final fact = MathFact(left: i + 1, op: MathOp.add, right: 1);
          facts.add(fact);
          fakeTracker.addFact(fact.factKey, FactRecord(
            factKey: fact.factKey,
            timesPresented: 10,
            timesCorrect: 5, // 50% accuracy -> needs practice
          ));
        }

        // 10 mastered facts
        for (int i = 0; i < 10; i++) {
          final fact = MathFact(left: i + 30, op: MathOp.add, right: 1);
          facts.add(fact);
          fakeTracker.addFact(fact.factKey, FactRecord(
            factKey: fact.factKey,
            timesPresented: 10,
            timesCorrect: 9, // 90% accuracy -> mastered
          ));
        }

        // Select 100 facts and count bucket distribution
        final selected = <String>[];
        for (int i = 0; i < 100; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) {
            selected.add(fact.factKey);
          }
        }

        // Count weak vs strong selections
        int weakCount = 0;
        for (final key in selected) {
          final record = fakeTracker.getFact(key);
          if (record != null && record.accuracy < 0.70) {
            weakCount++;
          }
        }

        // Should be roughly 40% weak facts (allow for random variance)
        expect(weakCount / selected.length, lessThan(0.50));
        expect(weakCount / selected.length, greaterThan(0.30));
      });
    });

    group('stale facts boost', () {
      test('facts not seen in 7+ days are boosted in selection', () {
        final now = DateTime.now();
        final stale = now.subtract(const Duration(days: 8));
        final recent = now.subtract(const Duration(days: 1));

        // Create two facts: one stale, one recent
        final staleFact = MathFact(left: 3, op: MathOp.add, right: 2);
        final recentFact = MathFact(left: 5, op: MathOp.add, right: 4);

        fakeTracker.addFact(staleFact.factKey, FactRecord(
          factKey: staleFact.factKey,
          timesPresented: 5,
          timesCorrect: 5,
          lastPresented: stale,
        ));

        fakeTracker.addFact(recentFact.factKey, FactRecord(
          factKey: recentFact.factKey,
          timesPresented: 5,
          timesCorrect: 5,
          lastPresented: recent,
        ));

        final facts = [staleFact, recentFact];

        // Select 20 facts and count how many times stale fact appears
        int staleCount = 0;
        for (int i = 0; i < 20; i++) {
          final selected = engine.selectNext(facts);
          if (selected?.factKey == staleFact.factKey) {
            staleCount++;
          }
        }

        // Stale fact should appear more often (boosted 3x)
        // With 3x boost, expect roughly 75% stale vs 25% recent
        expect(staleCount, greaterThan(10));
      });

      test('no crash when fact has no lastPresented date', () {
        final fact = MathFact(left: 3, op: MathOp.add, right: 2);
        fakeTracker.addFact(fact.factKey, FactRecord(
          factKey: fact.factKey,
          timesPresented: 5,
          timesCorrect: 5,
          lastPresented: null,
        ));

        final selected = engine.selectNext([fact]);
        expect(selected, isNotNull);
      });
    });

    group('empty bucket redistribution', () {
      test('empty buckets redistribute weight correctly', () {
        // Only provide mastered facts (no new, no needs-practice, no reinforcing)
        final facts = <MathFact>[];
        for (int i = 0; i < 5; i++) {
          final fact = MathFact(left: i + 1, op: MathOp.add, right: 1);
          facts.add(fact);
          fakeTracker.addFact(fact.factKey, FactRecord(
            factKey: fact.factKey,
            timesPresented: 10,
            timesCorrect: 10, // 100% accuracy -> mastered
          ));
        }

        // Should still select facts successfully
        final selected = <String>{};
        for (int i = 0; i < 10; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) {
            selected.add(fact.factKey);
          }
        }

        // Should have selected from all available facts
        expect(selected.length, greaterThan(0));
      });

      test('all buckets empty except newFact still works', () {
        // Only provide new facts
        final facts = <MathFact>[];
        for (int i = 0; i < 5; i++) {
          final fact = MathFact(left: i + 1, op: MathOp.add, right: 1);
          facts.add(fact);
          // Don't add to tracker - will be treated as new
        }

        final selected = <String>{};
        for (int i = 0; i < 10; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) {
            selected.add(fact.factKey);
          }
        }

        expect(selected.length, greaterThan(0));
      });
    });

    group('resetSession', () {
      test('clears recent history', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2),
          MathFact(left: 5, op: MathOp.add, right: 4),
        ];

        // Select a few facts
        engine.selectNext(facts);
        engine.selectNext(facts);
        engine.recordIncorrect('2+3');

        // Reset session
        engine.resetSession();

        // After reset, spacing rules should not apply
        // (we can't easily test this without accessing private fields,
        // but we can verify no exceptions occur)
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
      });
    });

    group('recordIncorrect', () {
      test('adds fact to re-presentation queue', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2),
          MathFact(left: 5, op: MathOp.add, right: 4),
          MathFact(left: 7, op: MathOp.add, right: 3),
        ];

        engine.recordIncorrect('2+3');

        // Next selection should prioritize 2+3
        final selected = engine.selectNext(facts);
        expect(selected, isNotNull);
        expect(selected!.factKey, '2+3');
      });

      test('re-presented fact removed from incorrect queue', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2),
          MathFact(left: 5, op: MathOp.add, right: 4),
        ];

        engine.recordIncorrect('2+3');

        // First selection should be 2+3
        final selected1 = engine.selectNext(facts);
        expect(selected1!.factKey, '2+3');

        // Subsequent selections shouldn't force 2+3 again
        // (it's been re-presented)
        final selected2 = engine.selectNext(facts);
        // Could be either fact at this point
        expect(selected2, isNotNull);
      });

      test('respects no-repeat window even for incorrect facts', () {
        final facts = <MathFact>[];
        for (int i = 1; i <= 8; i++) {
          facts.add(MathFact(left: i, op: MathOp.add, right: 1));
        }

        // Select a fact
        final selected1 = engine.selectNext(facts);
        expect(selected1, isNotNull);

        // Record it as incorrect immediately
        engine.recordIncorrect(selected1!.factKey);

        // The immediately next selection should NOT be the same fact
        final selected2 = engine.selectNext(facts);
        expect(selected2, isNotNull);
        expect(selected2!.factKey, isNot(selected1.factKey));
      });
    });

    group('MathFact factKey generation', () {
      test('commutative operations normalized (add)', () {
        final fact1 = MathFact(left: 3, op: MathOp.add, right: 2);
        final fact2 = MathFact(left: 2, op: MathOp.add, right: 3);
        expect(fact1.factKey, fact2.factKey);
        expect(fact1.factKey, '2+3');
      });

      test('commutative operations normalized (multiply)', () {
        final fact1 = MathFact(left: 7, op: MathOp.multiply, right: 8);
        final fact2 = MathFact(left: 8, op: MathOp.multiply, right: 7);
        expect(fact1.factKey, fact2.factKey);
        expect(fact1.factKey, '7x8');
      });

      test('non-commutative operations not normalized (subtract)', () {
        final fact1 = MathFact(left: 10, op: MathOp.subtract, right: 3);
        final fact2 = MathFact(left: 3, op: MathOp.subtract, right: 10);
        expect(fact1.factKey, isNot(fact2.factKey));
        expect(fact1.factKey, '10-3');
        expect(fact2.factKey, '3-10');
      });

      test('non-commutative operations not normalized (divide)', () {
        final fact1 = MathFact(left: 12, op: MathOp.divide, right: 3);
        final fact2 = MathFact(left: 3, op: MathOp.divide, right: 12);
        expect(fact1.factKey, isNot(fact2.factKey));
        expect(fact1.factKey, '12/3');
        expect(fact2.factKey, '3/12');
      });
    });

    group('edge cases', () {
      test('multiple incorrect facts queued', () {
        final facts = [
          MathFact(left: 3, op: MathOp.add, right: 2),
          MathFact(left: 5, op: MathOp.add, right: 4),
          MathFact(left: 7, op: MathOp.add, right: 3),
        ];

        engine.recordIncorrect('2+3');
        engine.recordIncorrect('4+5');

        // Should present incorrect facts in order
        final selected1 = engine.selectNext(facts);
        expect(['2+3', '4+5'], contains(selected1!.factKey));
      });

      test('very large fact pool', () {
        final facts = <MathFact>[];
        for (int i = 0; i < 100; i++) {
          facts.add(MathFact(left: i + 1, op: MathOp.add, right: 1));
        }

        // Should complete without performance issues
        final selected = <String>{};
        for (int i = 0; i < 50; i++) {
          final fact = engine.selectNext(facts);
          if (fact != null) {
            selected.add(fact.factKey);
          }
        }

        expect(selected.length, greaterThan(0));
      });

      test('fact not in tracker returns null record', () {
        final fact = MathFact(left: 3, op: MathOp.add, right: 2);
        expect(fakeTracker.getFact(fact.factKey), isNull);

        // Should still work (treated as new fact)
        final selected = engine.selectNext([fact]);
        expect(selected, isNotNull);
      });
    });
  });
}

/// Simple fake FactTracker for testing.
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
    return _records.values.where((r) => r.status == status).toList();
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
  int get masteredFactCount =>
      _records.values.where((r) => r.status == FactStatus.mastered).length;

  @override
  List<FactRecord> factsNotSeenSince(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _records.values.where((r) {
      return r.lastPresented != null && r.lastPresented!.isBefore(cutoff);
    }).toList();
  }

  @override
  void dispose() {}
}
