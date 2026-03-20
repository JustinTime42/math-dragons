import 'dart:math';

import '../../dragon_eggs/models/egg_data.dart';
import '../../shared/difficulty_config.dart';
import '../../shared/math_problem.dart';
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

  const AnswerGemData({
    required this.position,
    required this.value,
    required this.isCorrect,
  });
}

/// Generates math problems and places answer gems on the grid.
class ProblemManager {
  final FireTrailConfig config;
  final Random _random = Random();
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
    if (difficultyEngine != null && _eligibleFacts != null && _eligibleFacts!.isNotEmpty) {
      final suggested = difficultyEngine!.selectNext(_eligibleFacts!);
      if (suggested != null) {
        currentProblem = MathProblem(
          left: suggested.left,
          op: suggested.op,
          right: suggested.right,
          answer: suggested.result,
        );
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
    } while (attempts < 10 && answer < 0);

    currentProblem = MathProblem(left: a, op: op, right: b, answer: answer);
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
      gems.add(AnswerGemData(
        position: correctPos,
        value: currentProblem!.answer,
        isCorrect: true,
      ));
      occupied.add(correctPos);
      usedValues.add(currentProblem!.answer);
    }

    // Place distractors
    int placed = 0;
    int placeAttempts = 0;
    while (placed < config.distractorCount && placeAttempts < 200) {
      final value = _generateDistractor(currentProblem!);
      if (usedValues.contains(value)) {
        placeAttempts++;
        continue;
      }

      final pos = _findFreeCell(occupied, gridSize);
      if (pos != null) {
        gems.add(AnswerGemData(
          position: pos,
          value: value,
          isCorrect: false,
        ));
        occupied.add(pos);
        usedValues.add(value);
        placed++;
      }
      placeAttempts++;
    }

    return gems;
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
    } while ((result == correct || result < 0) && tries < 20);

    return result == correct ? correct + 1 : result;
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
