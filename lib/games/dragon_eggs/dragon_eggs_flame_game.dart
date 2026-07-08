import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../core/difficulty_engine.dart';
import '../shared/difficulty_config.dart';
import 'models/egg_data.dart';
import 'models/equation.dart';
import 'models/difficulty_config.dart';
import 'components/egg_component.dart';
import 'components/danger_line.dart';
import 'components/egg_pop_effect.dart';
import 'systems/egg_physics.dart';
import 'systems/egg_spawner.dart';
import 'systems/equation_builder.dart';
import 'systems/solvability_checker.dart';
import '../shared/math_problem.dart';

typedef OnEquationResult =
    void Function(EquationResult result, int responseTimeMs);
typedef OnGameOver = void Function();
typedef OnScoreChanged = void Function(int score, int combo, int streak);
typedef OnEquationChanged =
    void Function(String displayString, EquationStep step);
typedef OnLevelComplete = void Function();
typedef OnProgressChanged = void Function(int solved, int required);

class DragonEggsFlameGame extends FlameGame with TapCallbacks {
  final OnEquationResult onEquationResult;
  final OnGameOver onGameOver;
  final OnScoreChanged onScoreChanged;
  final OnEquationChanged onEquationChanged;
  final OnLevelComplete onLevelComplete;
  final OnProgressChanged onProgressChanged;
  final DifficultyEngine? difficultyEngine;

  late EggPhysics physics;
  late EggSpawner spawner;
  late EquationBuilder equationBuilder;
  late SolvabilityChecker solvabilityChecker;

  final List<EggComponent> eggs = [];
  bool isPaused = false;
  bool isGameOver = false;
  bool isLevelComplete = false;
  double dangerLineY = 0;
  double fieldWidth = 0;
  double fieldHeight = 0;

  int score = 0;
  int correctCount = 0;
  int levelCorrectCount = 0;
  int totalAttempts = 0;
  int combo = 0;
  int streak = 0;
  int bestStreak = 0;
  int scalesEarned = 0;
  final Set<String> _solvedFactsThisSession = {};

  int currentLevel;
  late DifficultyTier currentTier;

  int lastEarnedPoints = 0;
  bool lastWasNewFact = false;

  DateTime? _equationStartTime;
  DateTime? _gameStartTime;

  List<MathFact>? _factPool;

  // ignore: unused_field
  bool _valuesHidden = false;

  DragonEggsFlameGame({
    required this.onEquationResult,
    required this.onGameOver,
    required this.onScoreChanged,
    required this.onEquationChanged,
    required this.onLevelComplete,
    required this.onProgressChanged,
    this.difficultyEngine,
    this.currentLevel = 1,
  }) {
    currentTier = DifficultyTier.forLevel(currentLevel);
  }

  @override
  Future<void> onLoad() async {
    fieldWidth = size.x;
    fieldHeight = size.y;
    dangerLineY = fieldHeight * 0.12;

    physics = EggPhysics(fieldWidth: fieldWidth, fieldHeight: fieldHeight);
    spawner = EggSpawner(
      fieldWidth: fieldWidth,
      dangerLineY: dangerLineY,
      tier: currentTier,
    );
    equationBuilder = EquationBuilder();
    solvabilityChecker = SolvabilityChecker();

    _regenerateFactPool();

    add(DangerLine(y: dangerLineY, lineWidth: fieldWidth));

    _gameStartTime = DateTime.now();
    _equationStartTime = DateTime.now();

    Future.microtask(() => onProgressChanged(0, currentTier.requiredSolves));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPaused || isGameOver || isLevelComplete) return;

    final cappedDt = dt.clamp(0.0, 0.05);

    final intensity = _levelIntensity;
    physics.update(
      eggs,
      cappedDt,
      currentTier.gravityMultiplier * (1.0 + intensity * 0.40),
    );
    spawner.update(cappedDt, eggs, _onEggSpawned, intensity);
    solvabilityChecker.check(cappedDt, eggs, spawner, _onEggSpawned);

    for (final egg in eggs) {
      if (!egg.hasEnteredField && egg.position.y > dangerLineY + egg.radius) {
        egg.hasEnteredField = true;
      }
    }

    eggs.removeWhere((e) {
      if (e.state == EggState.dead) {
        e.removeFromParent();
        return true;
      }
      return false;
    });

    _checkGameOver();
  }

  void _onEggSpawned(EggComponent egg) {
    egg.onTapped = _onEggTapped;
    eggs.add(egg);
    add(egg);
  }

  void _onEggTapped(EggComponent egg) {
    if (isPaused || isGameOver || isLevelComplete) return;

    final accepted = equationBuilder.trySelect(egg);
    if (!accepted) return;

    onEquationChanged(equationBuilder.displayString, equationBuilder.step);

    if (equationBuilder.shouldEvaluate) {
      _evaluateEquation();
    }
  }

  void pressEquals() {
    if (equationBuilder.pressEquals()) {
      onEquationChanged(equationBuilder.displayString, equationBuilder.step);
    }
  }

  void deselectAll() {
    equationBuilder.deselectAll();
    onEquationChanged(equationBuilder.displayString, equationBuilder.step);
  }

  void _evaluateEquation() {
    final parts = equationBuilder.parts;
    if (parts.length != 4) return;

    final left = parts[0].value as int;
    final op = parts[1].value as MathOp;
    final right = parts[2].value as int;
    final answer = parts[3].value as int;

    final responseTimeMs = _equationStartTime != null
        ? DateTime.now().difference(_equationStartTime!).inMilliseconds
        : 0;

    final result = EquationResult(
      left: left,
      op: op,
      right: right,
      playerAnswer: answer,
    );

    totalAttempts++;

    if (result.isCorrect) {
      _onCorrectAnswer(result, responseTimeMs);
    } else {
      _onWrongAnswer(result, responseTimeMs);
    }

    onEquationResult(result, responseTimeMs);

    equationBuilder.reset();
    onEquationChanged(equationBuilder.displayString, equationBuilder.step);

    if (result.isCorrect) {
      spawner.recordSolvedFact(result.factKey);
    }
    _equationStartTime = DateTime.now();
  }

  void _onCorrectAnswer(EquationResult result, int responseTimeMs) {
    correctCount++;
    levelCorrectCount++;
    combo++;
    streak++;
    if (streak > bestStreak) bestStreak = streak;

    for (final egg in equationBuilder.parts) {
      egg.startPop();
      add(
        EggPopEffect(
          effectPosition: egg.position.clone(),
          color: egg.baseColor,
        ),
      );
    }

    final isNew = _isNewFact(result.factKey);
    final (earned, _) = _calculateScore(
      result.left,
      result.right,
      result.op,
      combo,
      isNew,
    );
    score += earned;
    lastEarnedPoints = earned;
    lastWasNewFact = isNew;
    scalesEarned += 2;

    onScoreChanged(score, combo, streak);
    onProgressChanged(levelCorrectCount, currentTier.requiredSolves);

    _checkLevelComplete();
  }

  void _onWrongAnswer(EquationResult result, int responseTimeMs) {
    combo = 0;
    streak = 0;

    for (final egg in equationBuilder.parts) {
      egg.state = EggState.active;
      egg.selectionIndex = null;
    }

    spawner.activatePenalty();

    onScoreChanged(score, combo, streak);
  }

  bool _isNewFact(String factKey) {
    if (_solvedFactsThisSession.contains(factKey)) return false;
    _solvedFactsThisSession.add(factKey);
    return true;
  }

  (int, String) _calculateScore(
    int a,
    int b,
    MathOp op,
    int comboMultiplier,
    bool isNewFact,
  ) {
    final base = _difficultyPoints(a, b, op);
    final newFactBonus = isNewFact ? 5 : 0;
    final earned = base * comboMultiplier + newFactBonus;

    String breakdown;
    if (comboMultiplier > 1 && isNewFact) {
      breakdown = '($base x $comboMultiplier + $newFactBonus)';
    } else if (comboMultiplier > 1) {
      breakdown = '($base x $comboMultiplier)';
    } else if (isNewFact) {
      breakdown = '($base + $newFactBonus)';
    } else {
      breakdown = '+$earned';
    }

    return (earned, breakdown);
  }

  int _difficultyPoints(int a, int b, MathOp op) {
    switch (op) {
      case MathOp.multiply:
        if (min(a, b) <= 2) return 5;
        if (a <= 5 && b <= 5) return 10;
        if (min(a, b) <= 5) return 15;
        return 20;
      case MathOp.divide:
        if (b <= 2) return 5;
        if (b <= 5) return 10;
        return 15;
      case MathOp.add:
      case MathOp.subtract:
        if (max(a, b) <= 5) return 5;
        if (max(a, b) <= 10 && min(a, b) <= 5) return 8;
        return 12;
    }
  }

  void _checkLevelComplete() {
    if (levelCorrectCount >= currentTier.requiredSolves) {
      isLevelComplete = true;
      score += 500;
      scalesEarned += 20;
      onScoreChanged(score, combo, streak);
      onLevelComplete();
    }
  }

  void _checkGameOver() {
    for (final egg in eggs) {
      if (egg.state == EggState.active &&
          egg.hasEnteredField &&
          egg.position.y - egg.radius <= dangerLineY) {
        isGameOver = true;
        onGameOver();
        return;
      }
    }
  }

  void advanceLevel() {
    currentLevel++;
    if (currentLevel > 50) currentLevel = 50;
    currentTier = DifficultyTier.forLevel(currentLevel);

    for (final egg in eggs) {
      egg.removeFromParent();
    }
    eggs.clear();

    levelCorrectCount = 0;
    isLevelComplete = false;
    combo = 0;

    equationBuilder.reset();
    spawner.updateTier(currentTier);
    _regenerateFactPool();

    _equationStartTime = DateTime.now();

    onScoreChanged(score, combo, streak);
    onEquationChanged(equationBuilder.displayString, equationBuilder.step);
    onProgressChanged(0, currentTier.requiredSolves);
  }

  void _regenerateFactPool() {
    _factPool = generateFacts(
      numberMin: currentTier.numberMin,
      numberMax: currentTier.numberMax,
      operations: currentTier.operations,
      resultMax: currentTier.resultMax,
    );
    spawner.factPool = _factPool ?? const [];
  }

  double get _levelIntensity {
    if (currentTier.requiredSolves <= 0) return 0;
    return (levelCorrectCount / currentTier.requiredSolves).clamp(0.0, 1.0);
  }

  void setPaused(bool paused) {
    isPaused = paused;
    _valuesHidden = paused;
  }

  Duration get gameDuration => _gameStartTime != null
      ? DateTime.now().difference(_gameStartTime!)
      : Duration.zero;

  int calculateStars() {
    if (totalAttempts == 0) return 0;
    final accuracy = correctCount / totalAttempts;
    final levelNumber = currentLevel;
    final thresholds = GameScoreThresholds.dragonEggs(levelNumber);

    final raw = LevelThresholds.calculateStars(
      accuracy: accuracy,
      score: score,
      medianScore: thresholds.medianScore,
      highScore: thresholds.highScore,
      problemsAttempted: totalAttempts,
      levelNumber: levelNumber,
    );

    if (isLevelComplete && raw < 1) return 1;
    return raw;
  }

  void resetGame() {
    for (final egg in eggs) {
      egg.removeFromParent();
    }
    eggs.clear();

    score = 0;
    correctCount = 0;
    levelCorrectCount = 0;
    totalAttempts = 0;
    combo = 0;
    streak = 0;
    bestStreak = 0;
    scalesEarned = 0;
    lastEarnedPoints = 0;
    lastWasNewFact = false;
    _solvedFactsThisSession.clear();
    currentTier = DifficultyTier.forLevel(currentLevel);
    isGameOver = false;
    isLevelComplete = false;
    isPaused = false;
    _valuesHidden = false;

    equationBuilder.reset();
    spawner.updateTier(currentTier);
    spawner.resetSession();
    _regenerateFactPool();

    _gameStartTime = DateTime.now();
    _equationStartTime = DateTime.now();

    onScoreChanged(0, 0, 0);
    onEquationChanged(equationBuilder.displayString, equationBuilder.step);
    onProgressChanged(0, currentTier.requiredSolves);
  }

  @override
  void onTapDown(TapDownEvent event) {
    deselectAll();
  }

  @override
  Color backgroundColor() => const Color(0x00000000);
}
