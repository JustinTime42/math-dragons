import 'dart:math';

import '../../dragon_eggs/models/egg_data.dart';
import '../../shared/difficulty_config.dart';
import '../../shared/math_problem.dart';
import '../../shared/problem_generation.dart';
import '../../../core/difficulty_engine.dart';
import '../models/fire_trail_config.dart';
import '../models/grid_position.dart';

/// A math problem with its display and answer.
class MathProblem {
  final int left;
  final MathOp op;
  final int right;
  final int answer;

  const MathProblem({
    required this.left,
    required this.op,
    required this.right,
    required this.answer,
  });

  factory MathProblem.fromFact(MathFact fact) {
    return MathProblem(
      left: fact.left,
      op: fact.op,
      right: fact.right,
      answer: fact.result,
    );
  }

  String get displayText {
    return '$left ${op.symbol} $right';
  }

  String get factKey {
    final opChar = op.keyChar;
    if (op == MathOp.add || op == MathOp.multiply) {
      final lo = left < right ? left : right;
      final hi = left < right ? right : left;
      return '$lo$opChar$hi';
    }
    return '$left$opChar$right';
  }
}

/// An answer gem placed on the grid.
class AnswerGemData {
  final GridPosition position;
  final int value;
  final bool isCorrect;
  final MathProblem problem;

  const AnswerGemData({
    required this.position,
    required this.value,
    required this.isCorrect,
    required this.problem,
  });
}

/// Generates math problems and places answer gems on the grid.
class ProblemManager {
  final FireTrailConfig config;
  final Random _random = Random();
  final ArithmeticProblemValidator _validator =
      const ArithmeticProblemValidator();
  MathProblem? currentProblem;

  /// Optional difficulty engine for adaptive problem selection.
  DifficultyEngine? difficultyEngine;
  List<MathFact>? _eligibleFacts;

  ProblemManager({required this.config});

  /// Initialize the eligible fact pool for the current level config.
  void initFactPool() {
    _eligibleFacts = FactPool.forLevel(
      numberMin: config.numberMin,
      numberMax: config.numberMax,
      operations: config.allowedOperations,
    );
  }

  /// Generate a new math problem, consulting the engine if available.
  void generateProblem() {
    if (difficultyEngine != null &&
        _eligibleFacts != null &&
        _eligibleFacts!.isNotEmpty) {
      final blueprint = difficultyEngine!.selectBlueprint(_eligibleFacts!);
      if (blueprint != null && _isValidFact(blueprint.fact)) {
        currentProblem = MathProblem.fromFact(blueprint.fact);
        return;
      }
    }
    // Fallback: existing random generation
    _generateRandom();
  }

  void _generateRandom() {
    final ops = config.allowedOperations;
    int attempts = 0;
    MathOp op;
    int a, b, answer;
    MathProblem? validProblem;

    do {
      op = ops[_random.nextInt(ops.length)];

      switch (op) {
        case MathOp.add:
          a = _randRange(config.numberMin, config.numberMax);
          b = _randRange(config.numberMin, config.numberMax);
          answer = a + b;
        case MathOp.subtract:
          a = _randRange(config.numberMin, config.numberMax);
          b = _randRange(config.numberMin, config.numberMax);
          if (a < b) {
            final t = a;
            a = b;
            b = t;
          }
          answer = a - b;
        case MathOp.multiply:
          a = _randRange(config.numberMin, config.numberMax);
          b = _randRange(config.numberMin, config.numberMax);
          answer = a * b;
        case MathOp.divide:
          b = _randRange(max(2, config.numberMin), config.numberMax);
          final q = _randRange(1, config.numberMax);
          a = b * q;
          answer = q;
      }
      attempts++;
      final fact = MathFact(left: a, op: op, right: b);
      if (_isValidFact(fact)) {
        validProblem = MathProblem(left: a, op: op, right: b, answer: answer);
      }
    } while (attempts < 40 && validProblem == null);

    currentProblem = validProblem ?? _firstValidFallback();
  }

  /// Place answer gems on the grid. Returns 1 correct + N distractor gems.
  List<AnswerGemData> placeGems({
    required GridPosition head,
    required List<GridPosition> trail,
    required int gridSize,
  }) {
    if (currentProblem == null) return [];

    final gems = <AnswerGemData>[];
    final occupied = <GridPosition>{head, ...trail};
    final usedValues = <int>{};

    // Place correct answer
    final correctPos = _findFreeCell(occupied, gridSize);
    if (correctPos != null) {
      gems.add(
        AnswerGemData(
          position: correctPos,
          value: currentProblem!.answer,
          isCorrect: true,
          problem: currentProblem!,
        ),
      );
      occupied.add(correctPos);
      usedValues.add(currentProblem!.answer);
    }

    // Place distractors
    int placed = 0;
    int placeAttempts = 0;
    while (placed < config.distractorCount && placeAttempts < 200) {
      final value = _generateDistractor(currentProblem!);
      if (usedValues.contains(value) || value <= 0) {
        placeAttempts++;
        continue;
      }

      final pos = _findFreeCell(occupied, gridSize);
      if (pos != null) {
        gems.add(
          AnswerGemData(
            position: pos,
            value: value,
            isCorrect: false,
            problem: currentProblem!,
          ),
        );
        occupied.add(pos);
        usedValues.add(value);
        placed++;
      }
      placeAttempts++;
    }

    return gems;
  }

  /// Place one pre-generated answer per visible gem for the whole level.
  ///
  /// The first gem's problem becomes the active prompt. Eating that gem is
  /// correct; eating any other preplaced answer first is wrong.
  List<AnswerGemData> placeLevelAnswerGems({
    required GridPosition head,
    required List<GridPosition> trail,
    required int gridSize,
    Set<GridPosition> reserved = const {},
  }) {
    final gems = <AnswerGemData>[];
    final occupied = <GridPosition>{head, ...trail, ...reserved};
    final usedValues = <int>{};
    final targetCount = config.answerGemCount;

    int attempts = 0;
    while (gems.length < targetCount && attempts < targetCount * 100) {
      final problem = _generateUniqueProblem(usedValues);
      attempts++;
      if (problem == null) continue;

      final pos = _findFreeCell(occupied, gridSize);
      if (pos == null) break;

      gems.add(
        AnswerGemData(
          position: pos,
          value: problem.answer,
          isCorrect: gems.isEmpty,
          problem: problem,
        ),
      );
      occupied.add(pos);
      usedValues.add(problem.answer);
    }

    currentProblem = gems.isEmpty ? null : gems.first.problem;
    return gems;
  }

  void setCurrentProblem(MathProblem? problem) {
    currentProblem = problem;
  }

  MathProblem? _generateUniqueProblem(Set<int> usedValues) {
    for (int i = 0; i < 40; i++) {
      if (i == 0) {
        generateProblem();
      } else {
        _generateRandom();
      }
      final problem = currentProblem;
      if (problem != null && !usedValues.contains(problem.answer)) {
        return problem;
      }
    }
    return null;
  }

  int _generateDistractor(MathProblem problem) {
    final correct = problem.answer;
    final strategies = <int Function()>[
      () => correct + _randRange(-3, 3),
      () => problem.left + problem.right,
      () => problem.left * problem.right,
      () => (problem.left - problem.right).abs(),
    ];

    int result;
    int tries = 0;
    do {
      result = strategies[_random.nextInt(strategies.length)]();
      tries++;
    } while ((result == correct || result <= 0) && tries < 20);

    return result == correct || result <= 0 ? correct + 1 : result;
  }

  bool _isValidFact(MathFact fact) {
    return _validator
        .validateFact(
          fact: fact,
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          allowedOperations: config.allowedOperations,
          resultMax: 144,
        )
        .isValid;
  }

  MathProblem? _firstValidFallback() {
    final facts =
        _eligibleFacts ??
        FactPool.forLevel(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: config.allowedOperations,
        );
    if (facts.isEmpty) return null;
    return MathProblem.fromFact(facts.first);
  }

  GridPosition? _findFreeCell(Set<GridPosition> occupied, int gridSize) {
    for (int i = 0; i < 100; i++) {
      final pos = GridPosition(
        _random.nextInt(gridSize),
        _random.nextInt(gridSize),
      );
      if (!occupied.contains(pos)) return pos;
    }
    return null;
  }

  int _randRange(int min, int max) {
    if (min >= max) return min;
    return min + _random.nextInt(max - min + 1);
  }
}
