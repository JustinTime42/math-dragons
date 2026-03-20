import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';

import '../../core/difficulty_engine.dart';
import '../shared/difficulty_config.dart';
import 'components/answer_gem.dart';
import 'components/dragon_head.dart';
import 'components/gem_sparkle_effect.dart';
import 'components/grid_renderer.dart';
import 'components/trail_segment.dart';
import 'models/fire_trail_config.dart';
import 'models/flame_intensity.dart';
import 'models/grid_position.dart';
import 'systems/movement_system.dart';
import 'systems/problem_manager.dart';
import 'systems/trail_manager.dart';

/// Game phase state machine.
enum GamePhase { countdown, playing, paused, levelComplete, gameOver }

/// The core Flame game class for Fire Trail.
class FireTrailFlameGame extends FlameGame {
  // -- Configuration --
  final int gridSize;
  FireTrailConfig config;
  final DifficultyEngine? difficultyEngine;

  // -- Callbacks to Flutter --
  final void Function(bool isCorrect, int score, int streak) onAnswerEaten;
  final void Function(String reason) onGameOver;
  final void Function(double flamePercent) onFlameChanged;
  final void Function(int score) onScoreChanged;
  final void Function(String problemText) onProblemChanged;
  final void Function() onWrongFlash;
  final void Function() onLevelComplete;

  // -- Game State --
  late GridPosition headPosition;
  late Direction currentDirection;
  late Direction nextDirection;
  bool dirLocked = false;
  List<GridPosition> trail = [];
  List<AnswerGemData> gemData = [];
  GamePhase phase = GamePhase.countdown;

  // -- Scoring --
  int score = 0;
  int correctCount = 0;
  int wrongCount = 0;
  int streak = 0;
  int bestStreak = 0;
  int scalesEarned = 0;

  // -- Timing --
  double _stepAccumulator = 0;
  double _stepIntervalMs = 0;
  DateTime? _problemShownAt;
  DateTime _gameStartedAt = DateTime.now();

  // -- Flame --
  final FlameIntensity flameIntensity = FlameIntensity();

  // -- Sub-systems --
  late MovementSystem movement;
  late ProblemManager problems;
  late TrailManager trailManager;

  // -- Rendering --
  late double cellSize;

  FireTrailFlameGame({
    this.gridSize = 15,
    required this.config,
    this.difficultyEngine,
    required this.onAnswerEaten,
    required this.onGameOver,
    required this.onFlameChanged,
    required this.onScoreChanged,
    required this.onProblemChanged,
    required this.onWrongFlash,
    required this.onLevelComplete,
  });

  int get totalAttempts => correctCount + wrongCount;

  Duration get gameDuration => DateTime.now().difference(_gameStartedAt);

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    cellSize = size.x / gridSize;
    _stepIntervalMs = 1000.0 / config.stepsPerSecond;

    // Grid background
    add(GridRenderer(gridSize: gridSize, cellSize: cellSize));

    // Initialize sub-systems
    movement =
        MovementSystem(gridSize: gridSize, wrap: config.wrapMode);
    problems = ProblemManager(config: config);
    problems.difficultyEngine = difficultyEngine;
    problems.initFactPool();
    trailManager = TrailManager(initialLength: 5);

    _seedDragon();

    // Generate first problem
    problems.generateProblem();
    _problemShownAt = DateTime.now();
    _placeGems();

    // Notify Flutter after the current build frame to avoid setState during build.
    final initialProblemText = problems.currentProblem?.displayText ?? '';
    Future.microtask(() => onProblemChanged(initialProblemText));
    _rebuildVisuals();
  }

  void _seedDragon() {
    final mid = gridSize ~/ 2;
    headPosition = GridPosition(mid, mid);
    currentDirection = Direction.right;
    nextDirection = Direction.right;
    trail = [];
    for (int i = 1; i <= 5; i++) {
      trail.add(GridPosition(mid - i, mid));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (phase != GamePhase.playing) return;

    _stepAccumulator += dt * 1000;

    int steps = 0;
    while (_stepAccumulator >= _stepIntervalMs && steps < 3) {
      _step();
      _stepAccumulator -= _stepIntervalMs;
      steps++;
      if (phase != GamePhase.playing) break;
    }
  }

  void _step() {
    // Apply queued direction
    currentDirection = nextDirection;
    dirLocked = false;

    // Calculate new head position
    final newHead = movement.nextPosition(headPosition, currentDirection);

    // Wall collision (no-wrap mode)
    if (newHead == null) {
      flameIntensity.onWrongAnswer();
      onFlameChanged(flameIntensity.value);
      onWrongFlash();
      if (!flameIntensity.isAlive) {
        _triggerGameOver('flameExtinguished');
      }
      return;
    }

    // Self-collision
    if (trail.any((s) => s == newHead)) {
      _triggerGameOver('selfCollision');
      return;
    }

    // Move: old head becomes first trail segment
    trail.insert(0, headPosition);
    headPosition = newHead;

    // Check gem collision
    AnswerGemData? hitGem;
    for (final g in gemData) {
      if (g.position == newHead) {
        hitGem = g;
        break;
      }
    }

    if (hitGem != null) {
      _handleGemEaten(hitGem);
    } else {
      // Normal movement: remove tail (or grow if pending)
      trailManager.handleNormalStep(trail);
    }

    _rebuildVisuals();
  }

  void _handleGemEaten(AnswerGemData gem) {
    if (gem.isCorrect) {
      // Correct answer
      score += _calculateScore();
      correctCount++;
      streak++;
      bestStreak = max(bestStreak, streak);
      flameIntensity.onCorrectAnswer();

      // Trail shrinks if longer than initial
      if (trail.length > 5) {
        trail.removeLast();
        if (trail.isNotEmpty) trail.removeLast();
      } else if (trail.isNotEmpty) {
        trail.removeLast();
      }

      // Celebration effect
      add(GemSparkleEffect(
        position: Vector2(
          gem.position.x * cellSize + cellSize / 2,
          gem.position.y * cellSize + cellSize / 2,
        ),
      ));

      // New problem + re-place gems
      problems.generateProblem();
      _problemShownAt = DateTime.now();
      onProblemChanged(problems.currentProblem?.displayText ?? '');
      _placeGems();

      // Check level completion
      if (correctCount >= config.correctToAdvance) {
        phase = GamePhase.levelComplete;
        onLevelComplete();
        return;
      }
    } else {
      // Wrong answer
      wrongCount++;
      streak = 0;
      flameIntensity.onWrongAnswer();

      // Trail grows by 2
      trailManager.pendingGrowth += 2;

      // Re-place gems but keep the same problem
      _placeGems();

      onWrongFlash();

      // Check game over
      if (!flameIntensity.isAlive) {
        _triggerGameOver('flameExtinguished');
        return;
      }
    }

    onAnswerEaten(gem.isCorrect, score, streak);
    onFlameChanged(flameIntensity.value);
    onScoreChanged(score);
  }

  int _calculateScore() {
    // Base score scaled by difficulty
    final base = 10 + (config.worldNumber - 1) * 2;
    final streakMultiplier = streak > 0 ? 1 + (streak - 1) * 0.1 : 1.0;
    return (base * streakMultiplier).round();
  }

  void _placeGems() {
    gemData = problems.placeGems(
      head: headPosition,
      trail: trail,
      gridSize: gridSize,
    );
  }

  void _triggerGameOver(String reason) {
    phase = GamePhase.gameOver;
    onGameOver(reason);
  }

  void setDirection(Direction dir) {
    if (phase != GamePhase.playing) return;
    if (dirLocked) return;
    if (dir.isOpposite(currentDirection)) return;
    nextDirection = dir;
    dirLocked = true;
  }

  void startPlaying() {
    phase = GamePhase.playing;
    _stepAccumulator = 0;
    _gameStartedAt = DateTime.now();
  }

  void setPaused(bool paused) {
    if (paused && phase == GamePhase.playing) {
      phase = GamePhase.paused;
    } else if (!paused && phase == GamePhase.paused) {
      phase = GamePhase.playing;
      _stepAccumulator = 0;
    }
  }

  void resetGame() {
    // Clear old components except grid
    children
        .whereType<DragonHeadComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());
    children
        .whereType<TrailSegmentComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());
    children
        .whereType<AnswerGemComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());

    phase = GamePhase.countdown;
    score = 0;
    correctCount = 0;
    wrongCount = 0;
    streak = 0;
    bestStreak = 0;
    scalesEarned = 0;
    _stepAccumulator = 0;
    flameIntensity.reset();
    trailManager.reset();

    _seedDragon();
    problems.generateProblem();
    _problemShownAt = DateTime.now();
    onProblemChanged(problems.currentProblem?.displayText ?? '');
    _placeGems();
    _rebuildVisuals();
    onFlameChanged(flameIntensity.value);
    onScoreChanged(score);
  }

  void updateConfig(FireTrailConfig newConfig) {
    config = newConfig;
    _stepIntervalMs = 1000.0 / config.stepsPerSecond;
    movement = MovementSystem(gridSize: gridSize, wrap: config.wrapMode);
    problems = ProblemManager(config: config);
    problems.difficultyEngine = difficultyEngine;
    problems.initFactPool();
  }

  int getResponseTimeMs() {
    if (_problemShownAt == null) return 0;
    return DateTime.now().difference(_problemShownAt!).inMilliseconds;
  }

  int calculateStars() {
    if (totalAttempts == 0) return 0;
    final accuracy = correctCount / totalAttempts;
    final levelNumber =
        (config.worldNumber - 1) * 8 + config.levelInWorld;
    final thresholds = GameScoreThresholds.fireTrail(levelNumber);

    final raw = LevelThresholds.calculateStars(
      accuracy: accuracy,
      score: score,
      medianScore: thresholds.medianScore,
      highScore: thresholds.highScore,
      problemsAttempted: totalAttempts,
      levelNumber: levelNumber,
    );

    if (phase == GamePhase.levelComplete && raw < 1) return 1;
    return raw;
  }

  // -- Visual Rendering --

  void _rebuildVisuals() {
    // Remove old head/trail/gems
    children
        .whereType<DragonHeadComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());
    children
        .whereType<TrailSegmentComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());
    children
        .whereType<AnswerGemComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());

    // Draw trail segments (tail to head so head is on top)
    for (int i = trail.length - 1; i >= 0; i--) {
      final seg = trail[i];
      add(TrailSegmentComponent(
        indexFromHead: i,
        totalLength: trail.length,
        flameIntensity: flameIntensity.value,
        position: Vector2(seg.x * cellSize, seg.y * cellSize),
        size: Vector2.all(cellSize),
      ));
    }

    // Draw dragon head
    add(DragonHeadComponent(
      facing: currentDirection,
      flameIntensity: flameIntensity.value,
      position: Vector2(headPosition.x * cellSize, headPosition.y * cellSize),
      size: Vector2.all(cellSize),
    ));

    // Draw answer gems
    for (final gem in gemData) {
      add(AnswerGemComponent(
        value: gem.value,
        isCorrect: gem.isCorrect,
        position:
            Vector2(gem.position.x * cellSize, gem.position.y * cellSize),
        size: Vector2.all(cellSize),
      ));
    }
  }
}
