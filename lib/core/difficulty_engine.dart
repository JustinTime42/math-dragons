import 'dart:math';
import 'fact_tracker.dart';
import '../games/shared/math_problem.dart';

/// Adaptive difficulty engine that selects math facts based on player mastery.
///
/// The engine categorizes all eligible facts into 4 weighted buckets and uses
/// weighted random selection with spacing rules to pick the next problem.
class DifficultyEngine {
  final FactTracker _factTracker;
  final Random _random;

  /// Recent fact keys to enforce spacing rules.
  final List<String> _recentFacts = [];

  /// Facts answered incorrectly recently, for re-presentation.
  final List<String> _recentIncorrect = [];

  static const int _noRepeatWindow = 3;
  static const int _rePresentIncorrectWindow = 5;
  static const int _staleDays = 7;
  static const double _needsPracticeCap = 0.40;

  DifficultyEngine({
    required FactTracker factTracker,
    Random? random,
  })  : _factTracker = factTracker,
        _random = random ?? Random();

  /// Select the next math fact from the eligible pool for a given level's parameters.
  ///
  /// [eligibleFacts] — all facts valid for this level (from FactPool.forLevel)
  ///
  /// Returns a [MathFact], or null if pool is empty.
  MathFact? selectNext(List<MathFact> eligibleFacts) {
    if (eligibleFacts.isEmpty) return null;

    // 1. Check if we must re-present a recent incorrect fact
    final rePresent = _checkRePresentIncorrect(eligibleFacts);
    if (rePresent != null) return _recordSelection(rePresent);

    // 2. Categorize into buckets
    final buckets = _categorizeFacts(eligibleFacts);

    // 3. Apply 40% cap on needs-practice
    final weights = _calculateWeights(buckets);

    // 4. Weighted random selection from non-empty buckets
    final bucket = _selectBucket(weights);
    final candidates = buckets[bucket]!;

    if (candidates.isEmpty) {
      // Fallback: pick any eligible fact
      return _recordSelection(
          eligibleFacts[_random.nextInt(eligibleFacts.length)]);
    }

    // 5. Filter out recently-seen facts
    final filtered = candidates
        .where((f) => !_recentFacts.contains(f.factKey))
        .toList();

    // Fall back to unfiltered if all were recently seen
    final pool = filtered.isNotEmpty ? filtered : candidates;

    // 6. Within the bucket, boost stale facts
    final selected = _selectFromPool(pool);
    return _recordSelection(selected);
  }

  /// Record a fact that was answered incorrectly, for re-presentation scheduling.
  void recordIncorrect(String factKey) {
    _recentIncorrect.add(factKey);
    // Keep window bounded
    if (_recentIncorrect.length > _rePresentIncorrectWindow * 2) {
      _recentIncorrect.removeRange(
          0, _recentIncorrect.length - _rePresentIncorrectWindow * 2);
    }
  }

  /// Reset recent-fact tracking (call between game sessions).
  void resetSession() {
    _recentFacts.clear();
    _recentIncorrect.clear();
  }

  // ── Private ──

  MathFact _recordSelection(MathFact fact) {
    _recentFacts.add(fact.factKey);
    if (_recentFacts.length > _noRepeatWindow * 2) {
      _recentFacts.removeRange(0, _recentFacts.length - _noRepeatWindow * 2);
    }
    // Remove from re-present queue if present
    _recentIncorrect.remove(fact.factKey);
    return fact;
  }

  /// Check if a recently-incorrect fact needs re-presentation.
  MathFact? _checkRePresentIncorrect(List<MathFact> eligible) {
    if (_recentIncorrect.isEmpty) return null;

    // Find the oldest incorrect fact that hasn't been re-presented yet
    // and is within the re-presentation window
    for (final factKey in _recentIncorrect) {
      // Don't re-present if it was recently shown (within the no-repeat window)
      if (_recentFacts.isNotEmpty) {
        final windowStart = _recentFacts.length > _noRepeatWindow
            ? _recentFacts.length - _noRepeatWindow
            : 0;
        if (_recentFacts.sublist(windowStart).contains(factKey)) {
          continue;
        }
      }

      final match = eligible.where((f) => f.factKey == factKey).firstOrNull;
      if (match != null) return match;
    }
    return null;
  }

  /// Sort eligible facts into the 4 mastery buckets.
  Map<FactBucket, List<MathFact>> _categorizeFacts(List<MathFact> facts) {
    final buckets = <FactBucket, List<MathFact>>{
      FactBucket.needsPractice: [],
      FactBucket.reinforcing: [],
      FactBucket.mastered: [],
      FactBucket.newFact: [],
    };

    for (final fact in facts) {
      final record = _factTracker.getFact(fact.factKey);
      if (record == null || record.timesPresented < 3) {
        buckets[FactBucket.newFact]!.add(fact);
      } else if (record.accuracy < 0.70) {
        buckets[FactBucket.needsPractice]!.add(fact);
      } else if (record.accuracy < 0.90) {
        buckets[FactBucket.reinforcing]!.add(fact);
      } else {
        buckets[FactBucket.mastered]!.add(fact);
      }
    }

    return buckets;
  }

  /// Calculate actual weights, applying the 40% cap on needs-practice.
  Map<FactBucket, double> _calculateWeights(
      Map<FactBucket, List<MathFact>> buckets) {
    // Base weights from the plan
    var weights = <FactBucket, double>{
      FactBucket.needsPractice: 0.40,
      FactBucket.reinforcing: 0.30,
      FactBucket.mastered: 0.15,
      FactBucket.newFact: 0.15,
    };

    // Zero out empty buckets and redistribute
    final emptyBuckets =
        weights.keys.where((b) => buckets[b]!.isEmpty).toList();
    if (emptyBuckets.isNotEmpty) {
      double freed = 0;
      for (final empty in emptyBuckets) {
        freed += weights[empty]!;
        weights[empty] = 0;
      }

      final nonEmpty =
          weights.keys.where((b) => buckets[b]!.isNotEmpty).toList();
      if (nonEmpty.isNotEmpty) {
        final share = freed / nonEmpty.length;
        for (final b in nonEmpty) {
          weights[b] = weights[b]! + share;
        }
      }
    }

    // Enforce 40% cap: if needs-practice weight exceeds cap after
    // redistribution and there are other non-empty buckets, clamp it
    if (weights[FactBucket.needsPractice]! > _needsPracticeCap) {
      final others = weights.keys
          .where(
              (b) => b != FactBucket.needsPractice && buckets[b]!.isNotEmpty)
          .toList();
      if (others.isNotEmpty) {
        final excess =
            weights[FactBucket.needsPractice]! - _needsPracticeCap;
        weights[FactBucket.needsPractice] = _needsPracticeCap;
        final share = excess / others.length;
        for (final b in others) {
          weights[b] = weights[b]! + share;
        }
      }
    }

    return weights;
  }

  /// Weighted random bucket selection.
  FactBucket _selectBucket(Map<FactBucket, double> weights) {
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return FactBucket.newFact;

    var roll = _random.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return weights.keys.last;
  }

  /// Select from pool, boosting facts not seen in 7+ days.
  MathFact _selectFromPool(List<MathFact> pool) {
    if (pool.length == 1) return pool.first;

    final now = DateTime.now();
    final staleCutoff = now.subtract(const Duration(days: _staleDays));

    // Build weighted list: stale facts get 3x weight
    final weighted = <(MathFact, double)>[];
    for (final fact in pool) {
      final record = _factTracker.getFact(fact.factKey);
      double weight = 1.0;
      if (record != null &&
          record.lastPresented != null &&
          record.lastPresented!.isBefore(staleCutoff)) {
        weight = 3.0;
      }
      weighted.add((fact, weight));
    }

    final total = weighted.fold<double>(0, (a, b) => a + b.$2);
    var roll = _random.nextDouble() * total;
    for (final (fact, w) in weighted) {
      roll -= w;
      if (roll <= 0) return fact;
    }
    return pool.last;
  }
}

/// The 4 mastery buckets for problem selection.
enum FactBucket {
  needsPractice, // accuracy < 70%
  reinforcing, // accuracy 70-89%
  mastered, // accuracy 90%+
  newFact, // seen < 3 times
}
