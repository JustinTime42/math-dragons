import 'dart:async';
import 'package:hive/hive.dart';
import 'event_bus.dart';
import 'game_events.dart';
import '../storage/local_storage.dart';

part 'fact_tracker.g.dart';

/// Status of a math fact based on player mastery.
@HiveType(typeId: 4)
enum FactStatus {
  @HiveField(0)
  newFact, // Never seen, or seen < 3 times

  @HiveField(1)
  learning, // Seen 3+ times, accuracy < 70%

  @HiveField(2)
  familiar, // Accuracy 70-89%

  @HiveField(3)
  mastered, // Accuracy 90%+ with 5+ presentations
}

/// A single math fact's tracking record.
/// Examples: factKey = "7x8", "15-9", "prime:17", "mult3:12"
@HiveType(typeId: 3)
class FactRecord extends HiveObject {
  @HiveField(0)
  final String factKey;

  @HiveField(1)
  final int timesPresented;

  @HiveField(2)
  final int timesCorrect;

  @HiveField(3)
  final int currentStreak;

  @HiveField(4)
  final DateTime? lastPresented;

  @HiveField(5)
  final DateTime? lastIncorrect;

  @HiveField(6)
  final double averageResponseTimeMs;

  @HiveField(7)
  final int totalResponseTimeMs;

  FactRecord({
    required this.factKey,
    this.timesPresented = 0,
    this.timesCorrect = 0,
    this.currentStreak = 0,
    this.lastPresented,
    this.lastIncorrect,
    this.averageResponseTimeMs = 0,
    this.totalResponseTimeMs = 0,
  });

  /// Accuracy as 0.0-1.0.
  double get accuracy =>
      timesPresented > 0 ? timesCorrect / timesPresented : 0.0;

  /// Derived status based on presentation count and accuracy.
  FactStatus get status {
    if (timesPresented < 3) return FactStatus.newFact;
    if (accuracy < 0.7) return FactStatus.learning;
    if (accuracy < 0.9 || timesPresented < 5) return FactStatus.familiar;
    return FactStatus.mastered;
  }

  /// Create a new record after a correct answer.
  FactRecord recordCorrect(int responseTimeMs) {
    final newPresented = timesPresented + 1;
    final newCorrect = timesCorrect + 1;
    final newTotalTime = totalResponseTimeMs + responseTimeMs;
    return FactRecord(
      factKey: factKey,
      timesPresented: newPresented,
      timesCorrect: newCorrect,
      currentStreak: currentStreak + 1,
      lastPresented: DateTime.now(),
      lastIncorrect: lastIncorrect,
      averageResponseTimeMs: newTotalTime / newPresented,
      totalResponseTimeMs: newTotalTime,
    );
  }

  /// Create a new record after an incorrect answer.
  FactRecord recordIncorrect(int responseTimeMs) {
    final newPresented = timesPresented + 1;
    final newTotalTime = totalResponseTimeMs + responseTimeMs;
    return FactRecord(
      factKey: factKey,
      timesPresented: newPresented,
      timesCorrect: timesCorrect,
      currentStreak: 0,
      lastPresented: DateTime.now(),
      lastIncorrect: DateTime.now(),
      averageResponseTimeMs: newTotalTime / newPresented,
      totalResponseTimeMs: newTotalTime,
    );
  }

  FactRecord copyWith({
    String? factKey,
    int? timesPresented,
    int? timesCorrect,
    int? currentStreak,
    DateTime? lastPresented,
    DateTime? lastIncorrect,
    double? averageResponseTimeMs,
    int? totalResponseTimeMs,
  }) {
    return FactRecord(
      factKey: factKey ?? this.factKey,
      timesPresented: timesPresented ?? this.timesPresented,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      lastPresented: lastPresented ?? this.lastPresented,
      lastIncorrect: lastIncorrect ?? this.lastIncorrect,
      averageResponseTimeMs:
          averageResponseTimeMs ?? this.averageResponseTimeMs,
      totalResponseTimeMs: totalResponseTimeMs ?? this.totalResponseTimeMs,
    );
  }
}

/// Tracks math fact accuracy and mastery by listening to game events.
class FactTracker {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final List<StreamSubscription<AnswerGiven>> _subscriptions = [];

  FactTracker({
    required EventBus eventBus,
    required LocalStorage storage,
  })  : _eventBus = eventBus,
        _storage = storage {
    _subscribe();
  }

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<AnswerGiven>().listen(_onAnswerGiven),
    );
  }

  void _onAnswerGiven(AnswerGiven event) {
    final factKey = _normalizeFactKey(event.problem);
    final existing = _storage.getFact(factKey) ??
        FactRecord(factKey: factKey);

    final updated = event.correct
        ? existing.recordCorrect(event.responseTimeMs)
        : existing.recordIncorrect(event.responseTimeMs);

    _storage.saveFact(updated);
  }

  /// Normalize a problem string into a consistent fact key.
  String _normalizeFactKey(String problem) {
    return problem
        .replaceAll(' ', '')
        .replaceAll('\u00d7', 'x')
        .replaceAll('\u00f7', '/')
        .replaceAll('=', '');
  }

  // ---- Query Methods (for difficulty engine, Step 8) ----

  FactRecord? getFact(String factKey) => _storage.getFact(factKey);

  List<FactRecord> getAllFacts() => _storage.getAllFacts();

  List<FactRecord> getFactsByStatus(FactStatus status) =>
      _storage.getFactsByStatus(status);

  Map<FactStatus, int> getStatusCounts() => _storage.getFactStatusCounts();

  int get masteredFactCount =>
      _storage.getFactsByStatus(FactStatus.mastered).length;

  List<FactRecord> factsNotSeenSince(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _storage.getAllFacts().where((f) {
      return f.lastPresented != null && f.lastPresented!.isBefore(cutoff);
    }).toList();
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
