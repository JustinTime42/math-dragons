import 'dart:math';

import '../../core/fact_tracker.dart';
import '../dragon_eggs/models/egg_data.dart';
import 'math_problem.dart';

/// A curriculum-level skill target used by the adaptive scheduler.
class KnowledgeComponent {
  final String id;

  const KnowledgeComponent(this.id);

  factory KnowledgeComponent.forFact(MathFact fact) {
    return switch (fact.op) {
      MathOp.add => KnowledgeComponent(_additionComponent(fact)),
      MathOp.subtract => KnowledgeComponent(_subtractionComponent(fact)),
      MathOp.multiply => KnowledgeComponent(_multiplicationComponent(fact)),
      MathOp.divide => const KnowledgeComponent('div.fact_family'),
    };
  }

  static String _additionComponent(MathFact fact) {
    if (fact.result <= 10) return 'add.within_10';
    if (fact.result <= 20) return 'add.within_20';
    return 'add.multi_digit';
  }

  static String _subtractionComponent(MathFact fact) {
    if (fact.left <= 10) return 'sub.within_10';
    if (fact.left <= 20) return 'sub.within_20';
    return 'sub.multi_digit';
  }

  static String _multiplicationComponent(MathFact fact) {
    final factor = min(fact.left, fact.right);
    if (factor == 2 || factor == 5 || factor == 10) {
      return 'mul.$factor';
    }
    if (factor <= 4) return 'mul.3_4';
    if (factor <= 6) return 'mul.6';
    if (factor <= 9) return 'mul.7_9';
    return 'mul.10_12';
  }

  @override
  String toString() => id;
}

enum MasteryBand { newFact, needsPractice, reinforcing, mastered }

enum ProblemDueReason {
  correction,
  dueReview,
  newFact,
  needsPractice,
  reinforcement,
  maintenance,
}

/// Conservative evidence summary derived from a fact record.
class MasteryEstimate {
  final int attempts;
  final int correct;
  final double accuracy;
  final double confidenceLowerBound;
  final int currentStreak;
  final int averageResponseTimeMs;
  final DateTime? lastPresented;
  final DateTime? lastIncorrect;
  final MasteryBand band;

  const MasteryEstimate({
    required this.attempts,
    required this.correct,
    required this.accuracy,
    required this.confidenceLowerBound,
    required this.currentStreak,
    required this.averageResponseTimeMs,
    required this.lastPresented,
    required this.lastIncorrect,
    required this.band,
  });

  factory MasteryEstimate.fromRecord(FactRecord? record) {
    if (record == null || record.timesPresented == 0) {
      return const MasteryEstimate(
        attempts: 0,
        correct: 0,
        accuracy: 0,
        confidenceLowerBound: 0,
        currentStreak: 0,
        averageResponseTimeMs: 0,
        lastPresented: null,
        lastIncorrect: null,
        band: MasteryBand.newFact,
      );
    }

    final accuracy = record.accuracy;
    final lower = _wilsonLowerBound(
      successes: record.timesCorrect,
      attempts: record.timesPresented,
    );
    final band = _bandFor(
      attempts: record.timesPresented,
      accuracy: accuracy,
      lowerBound: lower,
    );

    return MasteryEstimate(
      attempts: record.timesPresented,
      correct: record.timesCorrect,
      accuracy: accuracy,
      confidenceLowerBound: lower,
      currentStreak: record.currentStreak,
      averageResponseTimeMs: record.averageResponseTimeMs.round(),
      lastPresented: record.lastPresented,
      lastIncorrect: record.lastIncorrect,
      band: band,
    );
  }

  bool get needsCorrection {
    if (lastIncorrect == null) return false;
    if (currentStreak > 0) return false;
    return true;
  }

  bool isDueForReview(DateTime now) {
    if (lastPresented == null) return false;
    final elapsed = now.difference(lastPresented!);
    return switch (band) {
      MasteryBand.newFact => false,
      MasteryBand.needsPractice => elapsed >= const Duration(days: 1),
      MasteryBand.reinforcing => elapsed >= const Duration(days: 3),
      MasteryBand.mastered => elapsed >= const Duration(days: 7),
    };
  }

  static MasteryBand _bandFor({
    required int attempts,
    required double accuracy,
    required double lowerBound,
  }) {
    if (attempts < 3) return MasteryBand.newFact;
    if (accuracy < 0.70) return MasteryBand.needsPractice;
    if (attempts >= 8 && accuracy >= 0.90 && lowerBound >= 0.60) {
      return MasteryBand.mastered;
    }
    return MasteryBand.reinforcing;
  }

  static double _wilsonLowerBound({
    required int successes,
    required int attempts,
  }) {
    if (attempts == 0) return 0;
    const z = 1.64; // ~90% one-sided confidence.
    final n = attempts.toDouble();
    final p = successes / n;
    final z2 = z * z;
    final center = p + z2 / (2 * n);
    final margin = z * sqrt((p * (1 - p) + z2 / (4 * n)) / n);
    return (center - margin) / (1 + z2 / n);
  }
}

/// Game-neutral description of the next learning target.
class ProblemBlueprint {
  final MathFact fact;
  final KnowledgeComponent component;
  final MasteryEstimate mastery;
  final ProblemDueReason dueReason;

  const ProblemBlueprint({
    required this.fact,
    required this.component,
    required this.mastery,
    required this.dueReason,
  });
}

class GenerationConstraints {
  final int repeatWindow;
  final double needsPracticeSessionCap;

  const GenerationConstraints({
    this.repeatWindow = 3,
    this.needsPracticeSessionCap = 0.40,
  });
}

/// Stateful session scheduler that turns eligible facts into validated
/// problem blueprints.
class ProblemScheduler {
  final FactRecord? Function(String factKey) getFact;
  final Random random;
  final GenerationConstraints constraints;
  final DateTime Function() now;

  final List<String> _recentFactKeys = [];
  int _selections = 0;
  int _needsPracticeSelections = 0;

  ProblemScheduler({
    required this.getFact,
    Random? random,
    this.constraints = const GenerationConstraints(),
    DateTime Function()? now,
  }) : random = random ?? Random(),
       now = now ?? DateTime.now;

  ProblemBlueprint? select(List<MathFact> eligibleFacts) {
    if (eligibleFacts.isEmpty) return null;

    final candidates = _applyRepeatWindow(
      eligibleFacts,
    ).map(_blueprintFor).toList();
    final allowNeedsPractice = _canUseNeedsPractice(candidates);

    final correction = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.correction,
      allowNeedsPractice: allowNeedsPractice,
    );
    final dueReview = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.dueReview,
      allowNeedsPractice: allowNeedsPractice,
    );
    final needsPractice = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.needsPractice,
      allowNeedsPractice: allowNeedsPractice,
    );
    final newFacts = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.newFact,
      allowNeedsPractice: allowNeedsPractice,
    );
    final reinforcement = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.reinforcement,
      allowNeedsPractice: allowNeedsPractice,
    );
    final maintenance = _lane(
      candidates,
      (b) => b.dueReason == ProblemDueReason.maintenance,
      allowNeedsPractice: allowNeedsPractice,
    );

    final selected = _pickFromFirstNonEmpty([
      correction,
      dueReview,
      needsPractice,
      newFacts,
      reinforcement,
      maintenance,
      candidates,
    ]);
    if (selected == null) return null;

    _recordSelection(selected);
    return selected;
  }

  void resetSession() {
    _recentFactKeys.clear();
    _selections = 0;
    _needsPracticeSelections = 0;
  }

  List<MathFact> _applyRepeatWindow(List<MathFact> eligibleFacts) {
    final recent = _recentFactKeys
        .skip(max(0, _recentFactKeys.length - constraints.repeatWindow))
        .toSet();
    final filtered = eligibleFacts
        .where((f) => !recent.contains(f.factKey))
        .toList();
    return filtered.isNotEmpty ? filtered : eligibleFacts;
  }

  ProblemBlueprint _blueprintFor(MathFact fact) {
    final mastery = MasteryEstimate.fromRecord(getFact(fact.factKey));
    return ProblemBlueprint(
      fact: fact,
      component: KnowledgeComponent.forFact(fact),
      mastery: mastery,
      dueReason: _dueReasonFor(mastery),
    );
  }

  ProblemDueReason _dueReasonFor(MasteryEstimate mastery) {
    if (mastery.needsCorrection) return ProblemDueReason.correction;
    if (mastery.isDueForReview(now())) return ProblemDueReason.dueReview;
    return switch (mastery.band) {
      MasteryBand.newFact => ProblemDueReason.newFact,
      MasteryBand.needsPractice => ProblemDueReason.needsPractice,
      MasteryBand.reinforcing => ProblemDueReason.reinforcement,
      MasteryBand.mastered => ProblemDueReason.maintenance,
    };
  }

  bool _canUseNeedsPractice(List<ProblemBlueprint> candidates) {
    final hasAlternative = candidates.any(
      (b) =>
          b.dueReason != ProblemDueReason.correction &&
          b.dueReason != ProblemDueReason.needsPractice,
    );
    if (!hasAlternative) return true;
    if (_selections == 0) return true;
    return _needsPracticeSelections / _selections <
        constraints.needsPracticeSessionCap;
  }

  List<ProblemBlueprint> _lane(
    List<ProblemBlueprint> candidates,
    bool Function(ProblemBlueprint blueprint) predicate, {
    required bool allowNeedsPractice,
  }) {
    return candidates.where((candidate) {
      if (!allowNeedsPractice &&
          (candidate.dueReason == ProblemDueReason.correction ||
              candidate.dueReason == ProblemDueReason.needsPractice)) {
        return false;
      }
      return predicate(candidate);
    }).toList();
  }

  ProblemBlueprint? _pickFromFirstNonEmpty(List<List<ProblemBlueprint>> lanes) {
    for (final lane in lanes) {
      if (lane.isNotEmpty) {
        lane.sort(_compareBlueprints);
        final topScore = _priorityScore(lane.first);
        final top = lane
            .where((b) => (_priorityScore(b) - topScore).abs() < 0.001)
            .toList();
        return top[random.nextInt(top.length)];
      }
    }
    return null;
  }

  int _compareBlueprints(ProblemBlueprint a, ProblemBlueprint b) {
    final priority = _priorityScore(b).compareTo(_priorityScore(a));
    if (priority != 0) return priority;
    return a.fact.factKey.compareTo(b.fact.factKey);
  }

  double _priorityScore(ProblemBlueprint blueprint) {
    final mastery = blueprint.mastery;
    final staleDays = mastery.lastPresented == null
        ? 0.0
        : now()
              .difference(mastery.lastPresented!)
              .inDays
              .clamp(0, 30)
              .toDouble();
    final responsePenalty = mastery.averageResponseTimeMs <= 0
        ? 0.0
        : (mastery.averageResponseTimeMs / 5000).clamp(0, 1).toDouble();

    return switch (blueprint.dueReason) {
      ProblemDueReason.correction => 100,
      ProblemDueReason.dueReview => 80 + staleDays,
      ProblemDueReason.needsPractice => 70 + (1 - mastery.accuracy) * 10,
      ProblemDueReason.newFact => 55,
      ProblemDueReason.reinforcement => 40 + responsePenalty * 10,
      ProblemDueReason.maintenance => 20 + staleDays,
    };
  }

  void _recordSelection(ProblemBlueprint blueprint) {
    _recentFactKeys.add(blueprint.fact.factKey);
    if (_recentFactKeys.length > constraints.repeatWindow * 2) {
      _recentFactKeys.removeRange(
        0,
        _recentFactKeys.length - constraints.repeatWindow * 2,
      );
    }
    _selections++;
    if (blueprint.dueReason == ProblemDueReason.correction ||
        blueprint.dueReason == ProblemDueReason.needsPractice) {
      _needsPracticeSelections++;
    }
  }
}

class ProblemValidationResult {
  final bool isValid;
  final List<String> errors;

  const ProblemValidationResult._(this.isValid, this.errors);

  const ProblemValidationResult.valid() : this._(true, const []);

  const ProblemValidationResult.invalid(List<String> errors)
    : this._(false, errors);
}

/// Shared arithmetic validator used by direct equation games.
class ArithmeticProblemValidator {
  const ArithmeticProblemValidator();

  ProblemValidationResult validateFact({
    required MathFact fact,
    required int numberMin,
    required int numberMax,
    required List<MathOp> allowedOperations,
    required int resultMax,
  }) {
    final errors = <String>[];
    if (!allowedOperations.contains(fact.op)) {
      errors.add('operation_not_allowed');
    }
    if (fact.left < numberMin || fact.left > numberMax) {
      errors.add('left_out_of_range');
    }
    if (fact.right < numberMin || fact.right > numberMax) {
      errors.add('right_out_of_range');
    }
    if (fact.result <= 0 || fact.result > resultMax) {
      errors.add('result_out_of_range');
    }
    if (fact.op == MathOp.subtract && fact.left <= fact.right) {
      errors.add('subtraction_not_positive');
    }
    if (fact.op == MathOp.divide &&
        (fact.right < 2 || fact.left % fact.right != 0)) {
      errors.add('division_not_integral');
    }
    return errors.isEmpty
        ? const ProblemValidationResult.valid()
        : ProblemValidationResult.invalid(errors);
  }
}
