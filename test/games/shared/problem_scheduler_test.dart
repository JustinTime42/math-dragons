import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/shared/math_problem.dart';
import 'package:math_dragons/games/shared/problem_generation.dart';

void main() {
  group('ProblemScheduler', () {
    test('selects only facts from the eligible level scope', () {
      final records = <String, FactRecord>{};
      final facts = [
        MathFact(left: 2, op: MathOp.add, right: 3),
        MathFact(left: 4, op: MathOp.add, right: 5),
      ];
      final scheduler = ProblemScheduler(
        getFact: (key) => records[key],
        random: Random(1),
      );

      for (int i = 0; i < 10; i++) {
        final selected = scheduler.select(facts);
        expect(selected, isNotNull);
        expect(facts.map((f) => f.factKey), contains(selected!.fact.factKey));
      }
    });

    test('avoids repeats inside the repeat window when alternatives exist', () {
      final records = <String, FactRecord>{};
      final facts = List.generate(
        8,
        (i) => MathFact(left: i + 1, op: MathOp.add, right: 1),
      );
      final scheduler = ProblemScheduler(
        getFact: (key) => records[key],
        random: Random(2),
        constraints: const GenerationConstraints(repeatWindow: 3),
      );

      final selected = <String>[];
      for (int i = 0; i < 12; i++) {
        selected.add(scheduler.select(facts)!.fact.factKey);
      }

      for (int i = 0; i < selected.length; i++) {
        final windowStart = max(0, i - 3);
        final recent = selected.sublist(windowStart, i);
        expect(recent, isNot(contains(selected[i])));
      }
    });

    test('prioritizes a fact that needs correction', () {
      final now = DateTime(2026, 1, 1);
      final correctionFact = MathFact(left: 2, op: MathOp.add, right: 3);
      final records = <String, FactRecord>{
        correctionFact.factKey: FactRecord(
          factKey: correctionFact.factKey,
          timesPresented: 4,
          timesCorrect: 2,
          currentStreak: 0,
          lastPresented: now,
          lastIncorrect: now,
        ),
      };
      final scheduler = ProblemScheduler(
        getFact: (key) => records[key],
        random: Random(3),
        now: () => now,
      );

      final selected = scheduler.select([
        correctionFact,
        MathFact(left: 4, op: MathOp.add, right: 5),
      ]);

      expect(selected!.fact.factKey, correctionFact.factKey);
      expect(selected.dueReason, ProblemDueReason.correction);
    });

    test('enforces needs-practice cap when alternatives exist', () {
      final records = <String, FactRecord>{};
      final facts = <MathFact>[];

      for (int i = 1; i <= 6; i++) {
        final fact = MathFact(left: i, op: MathOp.add, right: 1);
        facts.add(fact);
        records[fact.factKey] = FactRecord(
          factKey: fact.factKey,
          timesPresented: 10,
          timesCorrect: 4,
        );
      }
      for (int i = 10; i <= 15; i++) {
        final fact = MathFact(left: i, op: MathOp.add, right: 1);
        facts.add(fact);
        records[fact.factKey] = FactRecord(
          factKey: fact.factKey,
          timesPresented: 10,
          timesCorrect: 8,
        );
      }

      final scheduler = ProblemScheduler(
        getFact: (key) => records[key],
        random: Random(4),
        constraints: const GenerationConstraints(
          repeatWindow: 3,
          needsPracticeSessionCap: 0.40,
        ),
      );

      var needsPractice = 0;
      const selections = 20;
      for (int i = 0; i < selections; i++) {
        final selected = scheduler.select(facts)!;
        if (selected.dueReason == ProblemDueReason.needsPractice ||
            selected.dueReason == ProblemDueReason.correction) {
          needsPractice++;
        }
      }

      expect(needsPractice / selections, lessThanOrEqualTo(0.45));
    });
  });
}
