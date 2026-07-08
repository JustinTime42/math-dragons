import 'dart:math';

import '../../shared/math_problem.dart';
import '../models/difficulty_config.dart';
import '../models/egg_data.dart';

class VisibleEggValue {
  final EggType type;
  final Object value;

  const VisibleEggValue.number(int number)
    : type = EggType.number,
      value = number;

  const VisibleEggValue.operator(MathOp op)
    : type = EggType.operator,
      value = op;
}

class EggValuePlan {
  final EggType type;
  final Object value;
  final bool isHelper;

  const EggValuePlan({
    required this.type,
    required this.value,
    this.isHelper = false,
  });
}

class EquationCandidate {
  final MathFact fact;

  const EquationCandidate(this.fact);

  int get left => fact.left;
  MathOp get op => fact.op;
  int get right => fact.right;
  int get result => fact.result;
  String get factKey => fact.factKey;

  List<int> get numbers => [left, right, result];
}

class EggFieldPlanner {
  final Random random;
  final List<String> _recentFactKeys = [];

  EggFieldPlanner({Random? random}) : random = random ?? Random();

  EggValuePlan planNormalSpawn({
    required List<VisibleEggValue> visibleValues,
    required DifficultyTier tier,
    required List<MathFact> factPool,
  }) {
    if (findSolvableEquation(visibleValues) == null) {
      return planHelperSpawn(
        visibleValues: visibleValues,
        tier: tier,
        factPool: factPool,
      );
    }

    final numberCount = _numbers(visibleValues).length;
    final operatorCount = _operators(visibleValues).length;
    final operatorRatio = operatorCount / max(numberCount, 1);

    if (operatorCount == 0 || operatorRatio < 0.22) {
      return EggValuePlan(
        type: EggType.operator,
        value: _selectOperator(tier.operations),
      );
    }
    if (operatorRatio > 0.45) {
      return EggValuePlan(
        type: EggType.number,
        value: _selectVariedNumber(visibleValues, tier, factPool),
      );
    }

    if (random.nextDouble() < 0.28) {
      return EggValuePlan(
        type: EggType.operator,
        value: _selectOperator(tier.operations),
      );
    }
    return EggValuePlan(
      type: EggType.number,
      value: _selectVariedNumber(visibleValues, tier, factPool),
    );
  }

  EggValuePlan planHelperSpawn({
    required List<VisibleEggValue> visibleValues,
    required DifficultyTier tier,
    required List<MathFact> factPool,
  }) {
    final numbers = _numbers(visibleValues);
    final operators = _operators(visibleValues);

    if (operators.isEmpty) {
      return EggValuePlan(
        type: EggType.operator,
        value: _selectOperator(tier.operations),
        isHelper: true,
      );
    }

    final candidate = _bestCompletionCandidate(
      visibleValues: visibleValues,
      tier: tier,
      factPool: factPool,
    );
    if (candidate == null) {
      return EggValuePlan(
        type: EggType.number,
        value: _selectVariedNumber(visibleValues, tier, factPool),
        isHelper: true,
      );
    }

    final missing = _missingNumbers(candidate, numbers);
    if (missing.isNotEmpty) {
      return EggValuePlan(
        type: EggType.number,
        value: _leastCrowded(missing, visibleValues),
        isHelper: true,
      );
    }
    if (!operators.contains(candidate.op)) {
      return EggValuePlan(
        type: EggType.operator,
        value: candidate.op,
        isHelper: true,
      );
    }

    return EggValuePlan(
      type: EggType.number,
      value: _selectVariedNumber(visibleValues, tier, factPool),
      isHelper: true,
    );
  }

  EquationCandidate? findSolvableEquation(List<VisibleEggValue> visibleValues) {
    final numbers = _numbers(visibleValues);
    final operators = _operators(visibleValues).toSet();
    if (numbers.length < 3 || operators.isEmpty) return null;

    final counts = _numberCounts(numbers);
    for (final op in operators) {
      for (final a in counts.keys) {
        for (final b in counts.keys) {
          final result = _compute(a, op, b);
          if (result <= 0 || !counts.containsKey(result)) continue;
          final needed = _numberCounts([a, b, result]);
          if (_hasCounts(counts, needed)) {
            return EquationCandidate(MathFact(left: a, op: op, right: b));
          }
        }
      }
    }
    return null;
  }

  void recordSolvedFact(String factKey) {
    _recentFactKeys.add(factKey);
    if (_recentFactKeys.length > 12) {
      _recentFactKeys.removeRange(0, _recentFactKeys.length - 12);
    }
  }

  void resetSession() {
    _recentFactKeys.clear();
  }

  EquationCandidate? _bestCompletionCandidate({
    required List<VisibleEggValue> visibleValues,
    required DifficultyTier tier,
    required List<MathFact> factPool,
  }) {
    final pool = factPool.isNotEmpty
        ? factPool
        : generateFacts(
            numberMin: tier.numberMin,
            numberMax: tier.numberMax,
            operations: tier.operations,
            resultMax: tier.resultMax,
          );
    if (pool.isEmpty) return null;

    final numbers = _numbers(visibleValues);
    final operators = _operators(visibleValues);
    final numberCounts = _numberCounts(numbers);

    final candidates = pool
        .map(EquationCandidate.new)
        .where((c) => !_recentFactKeys.contains(c.factKey))
        .toList();
    final searchPool = candidates.isNotEmpty
        ? candidates
        : pool.map(EquationCandidate.new).toList();

    searchPool.sort((a, b) {
      final scoreA = _completionScore(
        a,
        numberCounts,
        operators,
        visibleValues,
      );
      final scoreB = _completionScore(
        b,
        numberCounts,
        operators,
        visibleValues,
      );
      final scoreCompare = scoreB.compareTo(scoreA);
      if (scoreCompare != 0) return scoreCompare;
      return a.factKey.compareTo(b.factKey);
    });

    final topScore = _completionScore(
      searchPool.first,
      numberCounts,
      operators,
      visibleValues,
    );
    final top = searchPool
        .where(
          (c) =>
              _completionScore(c, numberCounts, operators, visibleValues) ==
              topScore,
        )
        .take(8)
        .toList();
    return top[random.nextInt(top.length)];
  }

  int _completionScore(
    EquationCandidate candidate,
    Map<int, int> numberCounts,
    List<MathOp> operators,
    List<VisibleEggValue> visibleValues,
  ) {
    final needed = _numberCounts(candidate.numbers);
    var present = 0;
    var missing = 0;
    for (final entry in needed.entries) {
      final have = numberCounts[entry.key] ?? 0;
      present += min(have, entry.value);
      missing += max(0, entry.value - have);
    }
    final opPresent = operators.contains(candidate.op) ? 1 : 0;
    final crowdPenalty = candidate.numbers
        .map((n) => _visibleCount(n, visibleValues))
        .fold<int>(0, (sum, count) => sum + max(0, count - 2));
    return present * 10 + opPresent * 4 - missing * 6 - crowdPenalty * 2;
  }

  List<int> _missingNumbers(EquationCandidate candidate, List<int> numbers) {
    final counts = _numberCounts(numbers);
    final needed = _numberCounts(candidate.numbers);
    final missing = <int>[];
    for (final entry in needed.entries) {
      final have = counts[entry.key] ?? 0;
      for (int i = have; i < entry.value; i++) {
        missing.add(entry.key);
      }
    }
    return missing;
  }

  int _selectVariedNumber(
    List<VisibleEggValue> visibleValues,
    DifficultyTier tier,
    List<MathFact> factPool,
  ) {
    if (factPool.isNotEmpty && random.nextDouble() < 0.20) {
      final fact = factPool[random.nextInt(factPool.length)];
      final components = [
        fact.left,
        fact.right,
        fact.result,
      ].where((n) => n > 0 && n <= tier.resultMax).toList();
      if (components.isNotEmpty) {
        return _leastCrowded(components, visibleValues);
      }
    }

    final maxPerturbation = max(1, tier.level ~/ 8);
    final upper = random.nextDouble() < 0.18
        ? min(tier.resultMax, tier.numberMax + maxPerturbation)
        : tier.numberMax;
    final lower = tier.numberMin;

    final candidates = <int>[];
    for (int i = 0; i < 8; i++) {
      candidates.add(lower + random.nextInt(max(1, upper - lower + 1)));
    }
    return _leastCrowded(candidates, visibleValues);
  }

  MathOp _selectOperator(List<MathOp> operations) {
    return operations[random.nextInt(operations.length)];
  }

  int _leastCrowded(List<int> candidates, List<VisibleEggValue> visibleValues) {
    candidates.shuffle(random);
    candidates.sort(
      (a, b) => _visibleCount(
        a,
        visibleValues,
      ).compareTo(_visibleCount(b, visibleValues)),
    );
    return candidates.first;
  }

  int _visibleCount(int number, List<VisibleEggValue> visibleValues) {
    return visibleValues
        .where((v) => v.type == EggType.number && v.value == number)
        .length;
  }

  List<int> _numbers(List<VisibleEggValue> visibleValues) {
    return visibleValues
        .where((v) => v.type == EggType.number)
        .map((v) => v.value as int)
        .toList();
  }

  List<MathOp> _operators(List<VisibleEggValue> visibleValues) {
    return visibleValues
        .where((v) => v.type == EggType.operator)
        .map((v) => v.value as MathOp)
        .toList();
  }

  Map<int, int> _numberCounts(List<int> numbers) {
    final counts = <int, int>{};
    for (final number in numbers) {
      counts[number] = (counts[number] ?? 0) + 1;
    }
    return counts;
  }

  bool _hasCounts(Map<int, int> available, Map<int, int> needed) {
    for (final entry in needed.entries) {
      if ((available[entry.key] ?? 0) < entry.value) return false;
    }
    return true;
  }

  int _compute(int a, MathOp op, int b) {
    return switch (op) {
      MathOp.add => a + b,
      MathOp.subtract => a - b,
      MathOp.multiply => a * b,
      MathOp.divide => b >= 2 && a % b == 0 ? a ~/ b : -1,
    };
  }
}
