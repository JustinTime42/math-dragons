import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';

import '../../core/difficulty_engine.dart';
import '../shared/math_problem.dart';
import '../dragon_eggs/models/egg_data.dart';
import '../fire_trail/models/grid_position.dart';
import 'components/caught_effect.dart';
import 'components/dragon_character.dart';
import 'components/enemy_guardian.dart';
import 'components/feast_grid.dart';
import 'components/feast_tile.dart';
import 'components/munch_effect.dart';
import 'components/power_up_tile.dart';
import 'models/enemy_type.dart';
import 'models/feast_config.dart';
import 'models/grid_cell.dart';
import 'models/math_category.dart';
import 'models/power_up_type.dart';
import 'systems/board_generator.dart';
import 'systems/collision_system.dart';
import 'systems/enemy_ai.dart';

/// The core Flame game for Dragon's Feast.
class DragonsFeastFlameGame extends FlameGame {
  static const int gridSize = 5;

  // -- Configuration --
  DragonsFeastConfig config;
  MathCategory category;

  /// Optional difficulty engine for biasing tile numbers.
  final DifficultyEngine? difficultyEngine;

  // -- Callbacks to Flutter --
  final void Function(bool isCorrect, int score, int streak) onTileEaten;
  final void Function() onGameOver;
  final void Function() onLevelComplete;
  final void Function(int lives) onLivesChanged;
  final void Function(int score) onScoreChanged;
  final void Function(int eaten, int needed) onProgressChanged;
  final void Function(String powerUp) onPowerUpCollected;
  final void Function() onWrongFlash;

  // -- Game State --
  late List<List<GridCell>> board;
  int playerX = 0;
  int playerY = 0;
  bool playerMoving = false;
  double playerMoveTimer = 0;
  int playerTargetX = 0;
  int playerTargetY = 0;
  int playerFromX = 0;
  int playerFromY = 0;
  int score = 0;
  int lives = 3;
  int streak = 0;
  int bestStreak = 0;
  int correctEaten = 0;
  int wrongEaten = 0;
  int requiredCorrect = 0;
  int levelsCleared = 0;
  int currentLevel = 1;
  bool isRunning = false;
  bool isPaused = false;
  bool isGameOver = false;
  int scalesEarned = 0;
  DateTime _gameStartTime = DateTime.now();
  DateTime? _lastEatTime;

  // -- Power-Up Timers --
  double freezeTimer = 0;
  double wingsTimer = 0;
  double shieldTimer = 0;
  double invulnTimer = 0;
  bool isCaughtAnimating = false;
  double caughtAnimTimer = 0;

  // -- Rendering --
  late double cellSize;
  late double boardSize;
  late double boardOffsetX;
  late double boardOffsetY;

  // -- Sub-systems --
  late EnemyAI enemyAI;
  late BoardGenerator boardGen;
  late CollisionSystem collisionSystem;
  final Random random = Random();

  // -- Components --
  late DragonCharacter dragonComponent;
  List<FeastTile> tileComponents = [];
  List<PowerUpTileComponent> powerUpComponents = [];
  List<EnemyGuardian> enemyComponents = [];

  /// Asset path for the player's dragon image (full path with assets/images/ prefix).
  /// Flame's images.load() expects paths relative to assets/images/, so this
  /// is stripped before loading.
  final String? dragonImagePath;
  Image? _dragonImage;

  DragonsFeastFlameGame({
    required this.config,
    required this.category,
    this.difficultyEngine,
    this.dragonImagePath,
    required this.onTileEaten,
    required this.onGameOver,
    required this.onLevelComplete,
    required this.onLivesChanged,
    required this.onScoreChanged,
    required this.onProgressChanged,
    required this.onPowerUpCollected,
    required this.onWrongFlash,
  });

  Duration get gameDuration => DateTime.now().difference(_gameStartTime);

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    final margin = 16.0;
    final gap = 8.0;
    boardSize = size.x - margin * 2;
    cellSize = (boardSize - gap * (gridSize - 1)) / gridSize;
    boardOffsetX = margin;
    boardOffsetY = (size.y - boardSize) / 2;

    // Load the player's dragon image if a path was provided.
    if (dragonImagePath != null) {
      try {
        // Flame expects paths relative to assets/images/
        final flamePath = dragonImagePath!.replaceFirst('assets/images/', '');
        _dragonImage = await images.load(flamePath);
      } catch (_) {
        // Fallback to placeholder rendering.
      }
    }

    enemyAI = EnemyAI(gridSize: gridSize);
    collisionSystem = const CollisionSystem();

    _initLevel();
  }

  void _initLevel() {
    // Generate board
    boardGen = BoardGenerator(category: category, gridSize: gridSize);

    // Bias tile numbers using the difficulty engine
    if (difficultyEngine != null) {
      final biasNums = <int>{};
      // Query engine for a few facts and extract operands
      for (int i = 0; i < 5; i++) {
        final fact = difficultyEngine!.selectNext(
          _buildSimpleFactPool(),
        );
        if (fact != null) {
          biasNums.add(fact.left);
          biasNums.add(fact.right);
          biasNums.add(fact.result);
        }
      }
      if (biasNums.isNotEmpty) {
        boardGen.setBias(biasNums.toList());
      }
      difficultyEngine!.resetSession();
    }

    final generated = boardGen.generate(
      targetCorrectCount: config.correctTileCount,
      powerUp: config.powerUpType,
    );
    board = generated.cells;
    requiredCorrect = generated.requiredCorrect;
    correctEaten = 0;

    // Clear old components
    for (final t in tileComponents) {
      t.removeFromParent();
    }
    for (final p in powerUpComponents) {
      p.removeFromParent();
    }
    for (final e in enemyComponents) {
      e.removeFromParent();
    }
    tileComponents.clear();
    powerUpComponents.clear();
    enemyComponents.clear();
    children.whereType<FeastGrid>().forEach((g) => g.removeFromParent());
    children.whereType<DragonCharacter>().forEach((d) => d.removeFromParent());

    // Add grid background
    add(FeastGrid(
      gridSize: gridSize,
      cellSize: cellSize,
      gap: 8.0,
      offsetX: boardOffsetX,
      offsetY: boardOffsetY,
    ));

    // Add tiles
    _addTileComponents();

    // Add dragon at (0,0)
    playerX = 0;
    playerY = 0;
    playerMoving = false;
    dragonComponent = DragonCharacter(cellSize: cellSize, dragonImage: _dragonImage)
      ..position = _cellToPixel(0, 0);
    add(dragonComponent);

    // Add enemies
    _spawnEnemies();

    // Reset power-up state
    freezeTimer = 0;
    wingsTimer = 0;
    shieldTimer = 0;
    invulnTimer = 0;
    isCaughtAnimating = false;
    dragonComponent.hasWings = false;
    dragonComponent.hasShield = false;
    dragonComponent.isInvulnerable = false;

    _lastEatTime = DateTime.now();

    // Notify Flutter after the current build frame to avoid setState during build.
    final eaten = correctEaten;
    final needed = requiredCorrect;
    Future.microtask(() => onProgressChanged(eaten, needed));
  }

  void _addTileComponents() {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final cell = board[y][x];

        if (cell.powerUp != null) {
          final puc = PowerUpTileComponent(
            type: cell.powerUp!,
            cellSize: cellSize,
          )..position = _cellToPixelTopLeft(x, y);
          powerUpComponents.add(puc);
          add(puc);
        } else {
          final tile = FeastTile(cell: cell, cellSize: cellSize)
            ..position = _cellToPixelTopLeft(x, y);
          tileComponents.add(tile);
          add(tile);
        }
      }
    }
  }

  void _spawnEnemies() {
    final count = config.enemyCount;
    final occupied = <String>{'0,0'};

    for (int i = 0; i < count; i++) {
      int ex, ey;
      do {
        ex = random.nextInt(gridSize);
        ey = random.nextInt(gridSize);
      } while (occupied.contains('$ex,$ey'));
      occupied.add('$ex,$ey');

      final type = i % 2 == 0 ? EnemyType.chaser : EnemyType.wanderer;
      final interval = config.enemySpeedMin +
          random.nextDouble() * (config.enemySpeedMax - config.enemySpeedMin);

      final enemy = EnemyGuardian(
        data: EnemyData(x: ex, y: ey, type: type, moveInterval: interval),
        cellSize: cellSize,
      )..position = _cellToPixel(ex, ey);

      enemyComponents.add(enemy);
      add(enemy);
    }
  }

  Vector2 _cellToPixel(int cx, int cy) {
    return Vector2(
      boardOffsetX + cx * (cellSize + 8.0) + cellSize / 2,
      boardOffsetY + cy * (cellSize + 8.0) + cellSize / 2,
    );
  }

  Vector2 _cellToPixelTopLeft(int cx, int cy) {
    return Vector2(
      boardOffsetX + cx * (cellSize + 8.0),
      boardOffsetY + cy * (cellSize + 8.0),
    );
  }

  Vector2 _cellToPixelInterp(double cx, double cy) {
    return Vector2(
      boardOffsetX + cx * (cellSize + 8.0) + cellSize / 2,
      boardOffsetY + cy * (cellSize + 8.0) + cellSize / 2,
    );
  }

  // -- Public API --

  void startPlaying() {
    isRunning = true;
    _gameStartTime = DateTime.now();
    _lastEatTime = DateTime.now();
  }

  void setPaused(bool paused) {
    isPaused = paused;
  }

  void movePlayer(Direction dir) {
    if (!isRunning || isPaused || isGameOver || playerMoving || isCaughtAnimating) {
      return;
    }

    final nx = playerX + dir.dx;
    final ny = playerY + dir.dy;

    if (nx < 0 || ny < 0 || nx >= gridSize || ny >= gridSize) return;

    playerFromX = playerX;
    playerFromY = playerY;
    playerTargetX = nx;
    playerTargetY = ny;
    playerMoving = true;
    playerMoveTimer = 0;
    dragonComponent.facing = dir;
  }

  void resetGame() {
    score = 0;
    lives = 3;
    streak = 0;
    bestStreak = 0;
    correctEaten = 0;
    wrongEaten = 0;
    levelsCleared = 0;
    currentLevel = 1;
    isGameOver = false;
    isRunning = false;
    scalesEarned = 0;

    config = DragonsFeastConfig.configForLevel(currentLevel);
    category = config.category;
    _initLevel();
  }

  int getResponseTimeMs() {
    if (_lastEatTime == null) return 0;
    final ms = DateTime.now().difference(_lastEatTime!).inMilliseconds;
    _lastEatTime = DateTime.now();
    return ms;
  }

  int calculateStars() {
    final totalEats = correctEaten + wrongEaten;
    final accuracy = totalEats > 0 ? correctEaten / totalEats : 0.0;
    if (accuracy >= 0.9 && lives == 3) return 3;
    if (accuracy >= 0.75 && lives >= 2) return 2;
    if (levelsCleared > 0) return 1;
    return 0;
  }

  // -- Update Loop --

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning || isPaused || isGameOver) return;

    _updatePlayerMovement(dt);
    _updateEnemies(dt);
    _updatePowerUpTimers(dt);
    _updateInvulnerability(dt);
    _checkCollision();
  }

  void _updatePlayerMovement(double dt) {
    if (!playerMoving) return;

    playerMoveTimer += dt;
    const duration = 0.12; // 120ms

    if (playerMoveTimer >= duration) {
      playerMoving = false;
      playerX = playerTargetX;
      playerY = playerTargetY;
      dragonComponent.position = _cellToPixel(playerX, playerY);
      _collectPowerUpAtPosition();
    } else {
      final t = (playerMoveTimer / duration).clamp(0.0, 1.0);
      // Ease out
      final easedT = 1.0 - (1.0 - t) * (1.0 - t);
      final x = playerFromX + (playerTargetX - playerFromX) * easedT;
      final y = playerFromY + (playerTargetY - playerFromY) * easedT;
      dragonComponent.position = _cellToPixelInterp(x, y);
    }
  }

  void _collectPowerUpAtPosition() {
    final cell = board[playerY][playerX];
    if (cell.isEaten || cell.powerUp == null) return;

    _activatePowerUp(cell.powerUp!);
    cell.isEaten = true;
    powerUpComponents
        .where((p) =>
            p.position.x == boardOffsetX + playerX * (cellSize + 8.0) &&
            p.position.y == boardOffsetY + playerY * (cellSize + 8.0))
        .toList()
        .forEach((p) {
      p.removeFromParent();
      powerUpComponents.remove(p);
    });
  }

  void munchTile() {
    if (!isRunning || isPaused || isGameOver || playerMoving || isCaughtAnimating) {
      return;
    }

    final cell = board[playerY][playerX];
    if (cell.isEaten || cell.powerUp != null) return;

    cell.isEaten = true;
    final isCorrect = cell.isCorrect;

    if (isCorrect) {
      score += 100;
      streak++;
      bestStreak = max(bestStreak, streak);
      correctEaten++;

      if (streak >= 3) {
        score += 50;
      }

      scalesEarned += 2;

      onTileEaten(true, score, streak);
      onScoreChanged(score);
      onProgressChanged(correctEaten, requiredCorrect);

      _triggerMunchEffect(playerX, playerY, true);
      _checkLevelComplete();
    } else {
      score = max(0, score - 50);
      streak = 0;
      wrongEaten++;

      onTileEaten(false, score, streak);
      onScoreChanged(score);
      onWrongFlash();

      _triggerMunchEffect(playerX, playerY, false);
    }

    _updateTileVisual(playerX, playerY, isCorrect);
  }

  void _updateTileVisual(int x, int y, bool isCorrect) {
    for (final tile in tileComponents) {
      if (tile.cell.x == x && tile.cell.y == y) {
        tile.triggerFlash(isCorrect);
        break;
      }
    }
  }

  void _triggerMunchEffect(int x, int y, bool isCorrect) {
    add(MunchEffect(isCorrect: isCorrect)..position = _cellToPixel(x, y));
  }

  void _checkLevelComplete() {
    int remaining = 0;
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (board[y][x].isCorrect && !board[y][x].isEaten) {
          remaining++;
        }
      }
    }

    if (remaining == 0) {
      score += 500;
      scalesEarned += 20; // level completion bonus
      levelsCleared++;
      onScoreChanged(score);
      _triggerLevelCompleteCelebration();
      onLevelComplete();
    }
  }

  void _triggerLevelCompleteCelebration() {
    for (int burst = 0; burst < 3; burst++) {
      final x = random.nextDouble() * boardSize + boardOffsetX;
      final y = random.nextDouble() * boardSize + boardOffsetY;
      add(MunchEffect(isCorrect: true)..position = Vector2(x, y));
    }
  }

  /// Advance to the next level after a brief transition.
  void advanceLevel() {
    currentLevel++;
    if (currentLevel > 40) currentLevel = 40;

    config = DragonsFeastConfig.configForLevel(currentLevel);
    category = config.category;
    _initLevel();
  }

  // -- Enemy Logic --

  void _updateEnemies(double dt) {
    for (final enemy in enemyComponents) {
      final data = enemy.data;

      if (freezeTimer > 0) continue;

      if (data.isMoving) {
        data.moveAnimTimer += dt;
        if (data.moveAnimTimer >= 0.22) {
          data.isMoving = false;
          data.x = data.toX;
          data.y = data.toY;
          enemy.position = _cellToPixel(data.x, data.y);

          _respawnTileAtCell(data.x, data.y);
        } else {
          final t = data.moveAnimTimer / 0.22;
          final x = data.fromX + (data.toX - data.fromX) * t;
          final y = data.fromY + (data.toY - data.fromY) * t;
          enemy.position = _cellToPixelInterp(x, y);
        }
        continue;
      }

      data.nextMoveTimer -= dt;
      if (data.nextMoveTimer <= 0) {
        final (dx, dy) = enemyAI.nextMove(data, playerX, playerY);

        if (dx != 0 || dy != 0) {
          data.fromX = data.x;
          data.fromY = data.y;
          data.toX = data.x + dx;
          data.toY = data.y + dy;
          data.isMoving = true;
          data.moveAnimTimer = 0;
        }

        data.nextMoveTimer =
            data.moveInterval + (random.nextDouble() - 0.5) * 1.0;
      }
    }
  }

  void _respawnTileAtCell(int x, int y) {
    if (!board[y][x].isEaten) return;

    final correctBias =
        (0.6 + 0.2 * (1.0 - correctEaten / max(requiredCorrect, 1)))
            .clamp(0.3, 0.8);

    final shouldBeCorrect = random.nextDouble() < correctBias;
    int newNumber;

    if (shouldBeCorrect) {
      newNumber = boardGen.generateSingleCorrect();
    } else {
      newNumber = boardGen.generateSingleWrong();
    }

    final isCorrectTile = category.predicate(newNumber);
    board[y][x] = GridCell(
      x: x,
      y: y,
      number: newNumber,
      isCorrect: isCorrectTile,
    );

    // Remove old tile component and add new one
    tileComponents
        .where((t) => t.cell.x == x && t.cell.y == y)
        .toList()
        .forEach((t) {
      t.removeFromParent();
      tileComponents.remove(t);
    });

    final newTile = FeastTile(cell: board[y][x], cellSize: cellSize)
      ..position = _cellToPixelTopLeft(x, y);
    tileComponents.add(newTile);
    add(newTile);

    if (isCorrectTile) {
      requiredCorrect++;
      onProgressChanged(correctEaten, requiredCorrect);
    }
  }

  // -- Power-Ups --

  void _activatePowerUp(PowerUpType type) {
    onPowerUpCollected(type.name);

    switch (type) {
      case PowerUpType.freeze:
        freezeTimer = 5.0;
        for (final enemy in enemyComponents) {
          enemy.isFrozen = true;
        }
      case PowerUpType.wings:
        wingsTimer = 3.0;
        dragonComponent.hasWings = true;
      case PowerUpType.shield:
        shieldTimer = 3.0;
        dragonComponent.hasShield = true;
    }
  }

  void _updatePowerUpTimers(double dt) {
    if (freezeTimer > 0) {
      freezeTimer -= dt;
      if (freezeTimer <= 0) {
        freezeTimer = 0;
        for (final enemy in enemyComponents) {
          enemy.isFrozen = false;
        }
      }
    }

    if (wingsTimer > 0) {
      wingsTimer -= dt;
      if (wingsTimer <= 0) {
        wingsTimer = 0;
        dragonComponent.hasWings = false;
      }
    }

    if (shieldTimer > 0) {
      shieldTimer -= dt;
      if (shieldTimer <= 0) {
        shieldTimer = 0;
        dragonComponent.hasShield = false;
      }
    }
  }

  // -- Collision --

  void _checkCollision() {
    if (invulnTimer > 0 || isCaughtAnimating) return;
    if (wingsTimer > 0 || shieldTimer > 0) return;

    final enemyDatas = enemyComponents.map((e) => e.data).toList();
    final idx = collisionSystem.checkCollision(
      playerX: playerX,
      playerY: playerY,
      enemies: enemyDatas,
      isInvulnerable: invulnTimer > 0,
      hasWings: wingsTimer > 0,
      hasShield: shieldTimer > 0,
    );

    if (idx >= 0) {
      _handleCaught(enemyComponents[idx]);
    }
  }

  void _handleCaught(EnemyGuardian caughtBy) {
    lives--;
    onLivesChanged(lives);

    if (lives <= 0) {
      isGameOver = true;
      onGameOver();
      return;
    }

    // Caught effect at current position
    add(CaughtEffect()..position = _cellToPixel(playerX, playerY));

    isCaughtAnimating = true;
    caughtAnimTimer = 0;

    // Teleport player to (0,0)
    playerX = 0;
    playerY = 0;
    playerMoving = false;
    dragonComponent.position = _cellToPixel(0, 0);

    // Teleport catching enemy to (4,4)
    caughtBy.data.x = 4;
    caughtBy.data.y = 4;
    caughtBy.data.isMoving = false;
    caughtBy.position = _cellToPixel(4, 4);

    // Start invulnerability
    invulnTimer = 1.5;
    dragonComponent.isInvulnerable = true;
  }

  void _updateInvulnerability(double dt) {
    if (isCaughtAnimating) {
      caughtAnimTimer += dt;
      if (caughtAnimTimer >= 0.9) {
        isCaughtAnimating = false;
      }
    }

    if (invulnTimer > 0) {
      invulnTimer -= dt;
      if (invulnTimer <= 0) {
        invulnTimer = 0;
        dragonComponent.isInvulnerable = false;
      }
    }
  }

  /// Build a simple fact pool from the category's number range for engine queries.
  List<MathFact> _buildSimpleFactPool() {
    return generateFacts(
      numberMin: category.rangeMin.clamp(1, 12),
      numberMax: category.rangeMax.clamp(2, 12),
      operations: [MathOp.add, MathOp.multiply],
      resultMax: 144,
    );
  }
}
