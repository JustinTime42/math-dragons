import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/fact_tracker.dart';

void main() {
  group('FactRecord', () {
    test('new fact starts as FactStatus.newFact', () {
      final record = FactRecord(factKey: '7x8');
      expect(record.status, FactStatus.newFact);
      expect(record.timesPresented, 0);
      expect(record.accuracy, 0.0);
    });

    test('status transitions: new -> learning (low accuracy after 3+ presentations)', () {
      // 3 presentations, 1 correct (33%) -> learning
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 3,
        timesCorrect: 1,
      );
      expect(record.accuracy, closeTo(0.333, 0.01));
      expect(record.status, FactStatus.learning);
    });

    test('status transitions: learning -> familiar (70-89%)', () {
      // 10 presentations, 8 correct (80%) -> familiar
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 10,
        timesCorrect: 8,
      );
      expect(record.accuracy, 0.8);
      expect(record.status, FactStatus.familiar);
    });

    test('status transitions: familiar -> mastered (90%+ with 5+ presentations)', () {
      // 10 presentations, 9 correct (90%) -> mastered
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 10,
        timesCorrect: 9,
      );
      expect(record.accuracy, 0.9);
      expect(record.status, FactStatus.mastered);
    });

    test('familiar with fewer than 5 presentations even at 90%', () {
      // 4 presentations, 4 correct (100%) but < 5 presentations -> familiar
      final record = FactRecord(
        factKey: '3+2',
        timesPresented: 4,
        timesCorrect: 4,
      );
      expect(record.accuracy, 1.0);
      expect(record.status, FactStatus.familiar);
    });

    test('accuracy calculation', () {
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 10,
        timesCorrect: 7,
      );
      expect(record.accuracy, 0.7);
    });

    test('accuracy is 0.0 when no presentations', () {
      final record = FactRecord(factKey: '7x8');
      expect(record.accuracy, 0.0);
    });

    test('recordCorrect updates all fields correctly', () {
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 5,
        timesCorrect: 3,
        currentStreak: 2,
        totalResponseTimeMs: 2500,
      );

      final updated = record.recordCorrect(600);

      expect(updated.factKey, '7x8');
      expect(updated.timesPresented, 6);
      expect(updated.timesCorrect, 4);
      expect(updated.currentStreak, 3);
      expect(updated.lastPresented, isNotNull);
      expect(updated.totalResponseTimeMs, 3100);
      expect(updated.averageResponseTimeMs, closeTo(516.67, 0.1));
    });

    test('recordIncorrect resets streak to 0', () {
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 5,
        timesCorrect: 5,
        currentStreak: 5,
        totalResponseTimeMs: 2500,
      );

      final updated = record.recordIncorrect(800);

      expect(updated.timesPresented, 6);
      expect(updated.timesCorrect, 5); // unchanged
      expect(updated.currentStreak, 0); // reset
      expect(updated.lastPresented, isNotNull);
      expect(updated.lastIncorrect, isNotNull);
      expect(updated.totalResponseTimeMs, 3300);
    });

    test('copyWith works correctly', () {
      final record = FactRecord(
        factKey: '7x8',
        timesPresented: 5,
        timesCorrect: 4,
      );

      final updated = record.copyWith(timesPresented: 10, timesCorrect: 8);

      expect(updated.factKey, '7x8');
      expect(updated.timesPresented, 10);
      expect(updated.timesCorrect, 8);
    });
  });

  group('FactStatus', () {
    test('enum has all expected values', () {
      expect(FactStatus.values, hasLength(4));
      expect(FactStatus.values, contains(FactStatus.newFact));
      expect(FactStatus.values, contains(FactStatus.learning));
      expect(FactStatus.values, contains(FactStatus.familiar));
      expect(FactStatus.values, contains(FactStatus.mastered));
    });
  });
}
