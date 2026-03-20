# Step 7: Game Port — Dragon's Feast (Merged Muncher)

> **Goal:** Port the HTML5 Muncher games (SuperMooseMan + MooseMuncher) to Flutter/Flame
> as "Dragon's Feast" — a grid-based game where the player navigates a dragon through a
> 5x5 grid of numbered tiles, eating those that match the current math category (e.g.,
> "Multiples of 7", "Prime Numbers") while avoiding enemy guardians. **All word categories
> are dropped** — only math-related categories are used. The SuperMooseMan architecture is
> the primary base, with select improvements from MooseMuncher (animated movement, variable
> enemy timing, dynamic tile respawning).
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 6 complete. Dragon Runes fully playable and integrated. `flutter analyze`
> clean. `flutter test` green. `flutter build apk --debug` succeeds.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [Original Game Mechanics Reference](#4-original-game-mechanics-reference)
5. [File Structure](#5-file-structure)
6. [MathDragonsGame Implementation](#6-mathdragonsgame-implementation)
7. [Flame Game Setup](#7-flame-game-setup)
8. [Grid System & Tile Rendering](#8-grid-system--tile-rendering)
9. [Dragon Character & Movement](#9-dragon-character--movement)
10. [Math Category System](#10-math-category-system)
11. [Board Generation](#11-board-generation)
12. [Tile Eating Mechanics](#12-tile-eating-mechanics)
13. [Enemy AI System](#13-enemy-ai-system)
14. [Power-Up System](#14-power-up-system)
15. [Scoring & Lives](#15-scoring--lives)
16. [Touch Controls](#16-touch-controls)
17. [Difficulty & World Progression](#17-difficulty--world-progression)
18. [Fact Tracking & Adaptive Selection](#18-fact-tracking--adaptive-selection)
19. [Event Bus Integration](#19-event-bus-integration)
20. [Game Flow & State Machine](#20-game-flow--state-machine)
21. [Game Over & Results](#21-game-over--results)
22. [HUD Elements](#22-hud-elements)
23. [Visual Effects](#23-visual-effects)
24. [Localization Updates](#24-localization-updates)
25. [Unit Tests](#25-unit-tests)
26. [Verification Checklist](#26-verification-checklist)

---

## 1. User Stories

### US-7.1: Play Dragon's Feast
**As a** player,
**I want** to navigate a dragon across a grid of numbered tiles and eat the ones matching
the current math category,
**so that** I can practice number properties (multiples, primes, even/odd) in a fast-paced,
Pac-Man-style game.

### US-7.2: Learn Number Properties
**As a** player,
**I want** the game to teach me about multiples, primes, composites, even/odd, perfect
squares, and factors,
**so that** I build fluency with number properties, not just arithmetic operations.

### US-7.3: Avoid Enemies
**As a** player,
**I want** enemy guardians patrolling the grid that I must avoid while eating correct tiles,
**so that** the game has real stakes and requires strategic movement.

### US-7.4: Use Power-Ups
**As a** player,
**I want** dragon abilities (fire breath freeze, wings fly-over, shield) that appear as
special tiles on the grid,
**so that** I have tactical tools for dealing with enemies.

### US-7.5: Clear Levels
**As a** player,
**I want** to advance to the next level by eating all tiles matching the current category,
**so that** I have clear goals and a sense of accomplishment.

### US-7.6: Progressive Difficulty
**As a** player,
**I want** categories to start simple (even/odd) and progress to harder ones (primes,
factors of N),
**so that** the challenge grows naturally as I improve.

### US-7.7: Earn Scales
**As a** player,
**I want** to earn Dragon Scales for correct eats, level completion, and streaks,
**so that** my Dragon's Feast sessions contribute to my overall progression.

### US-7.8: See My Results
**As a** player,
**I want** a results screen after each game showing my score, accuracy, levels cleared,
and scales earned,
**so that** every session ends with a satisfying summary.

---

## 2. Acceptance Criteria

- [ ] Dragon's Feast is fully playable from the hub screen
- [ ] 5x5 grid of numbered tiles displayed with the game's treasure cavern theme
- [ ] Dragon character navigates the grid with D-pad or swipe controls
- [ ] Current math category displayed prominently at top of screen
- [ ] Eating a correct tile: +100 score, green glow, gem shatter particles, munch haptic
- [ ] Eating a wrong tile: -50 score (min 0), red flash, wrong answer haptic
- [ ] Level completes when all matching tiles are eaten
- [ ] Level completion awards +500 bonus and celebration effects
- [ ] New board generates with a new category on level advance
- [ ] 3 lives system — lose a life when caught by an enemy
- [ ] Player respawns at (0,0) after being caught, brief invulnerability period
- [ ] Enemy count increases with level: 2 at level 1, up to 6 at high levels
- [ ] Two enemy types: Chaser (pursues player) and Wanderer (random movement)
- [ ] Enemies move on independent timers (3-6 seconds per step)
- [ ] Power-up tiles spawn on the grid: Freeze, Wings, Shield
- [ ] Freeze: stops all enemies for 5 seconds
- [ ] Wings: player can safely pass through enemies for 3 seconds
- [ ] Shield: invulnerability for 3 seconds
- [ ] Dynamic tile respawning: when an enemy steps on an empty cell, a new number appears
- [ ] 20+ math-only categories across 5 worlds
- [ ] 5 worlds with 8 levels each (40 levels total)
- [ ] Event bus emits: `GameStarted`, `AnswerGiven`, `StreakAchieved`, `LevelCompleted`, `GameEnded`
- [ ] FactTracker records every eat attempt with timing data
- [ ] RewardService awards scales based on correct eats, streaks, and completion
- [ ] Pause overlay pauses enemy movement and hides tile values
- [ ] Game registers with `GameRegistry` and appears correctly on the hub
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] Game is genuinely fun and requires real math thinking

---

## 3. Architecture Overview

### How Flame Integrates with Flutter

Dragon's Feast uses a Flame `FlameGame` embedded in Flutter via `GameWidget`, following
the same pattern as the other three games. The grid, dragon, enemies, tiles, and power-up
effects are Flame components. The HUD (category display, score, lives, progress), D-pad
controls, and overlays are Flutter widgets.

```
+------------------------------------------------------+
|                 GameShell (Flutter)                    |
|  +--------------------------------------------------+|
|  |  HUD Bar: Pause | Title | Scales                 ||
|  +--------------------------------------------------+|
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |   Category Display (Flutter)               |   ||
|  |  |   "Multiples of 7"                         |   ||
|  |  +--------------------------------------------+   ||
|  |  |                                              |   ||
|  |  |       FlameGame (GameWidget)                 |   ||
|  |  |   +--------------------------------------+   |   ||
|  |  |   |  [14] [23] [ 7] [49] [35]           |   |   ||
|  |  |   |  [10] [28] [11] [42] [ 3]           |   |   ||
|  |  |   |  [21] [🐉] [56] [15] [16]           |   |   ||
|  |  |   |  [63] [18] [ 9] [👹] [77]           |   |   ||
|  |  |   |  [ 5] [70] [🧊] [22] [84]           |   |   ||
|  |  |   +--------------------------------------+   |   ||
|  |  |                                              |   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |  Score: 450  |  Lives: ♥♥♥  |  Lvl: 5     |   ||
|  |  |  Streak: x3  |  Progress: [======----] 7/10|   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |           D-Pad Controls (Flutter)          |   ||
|  |  |              [ UP ]                         |   ||
|  |  |         [LEFT]   [RIGHT]                    |   ||
|  |  |              [DOWN]                         |   ||
|  |  +--------------------------------------------+   ||
|  +--------------------------------------------------+|
+------------------------------------------------------+
```

### Key Design Decisions

1. **Flame for grid, dragon, enemies, tiles, and effects.** The 5x5 grid, dragon character,
   enemy sprites, numbered tiles, and particle effects are Flame `PositionComponent`s. The
   game loop handles enemy movement timers and collision detection.

2. **Flutter for HUD and controls.** The category display, score/lives/progress, D-pad, and
   overlays are Flutter widgets. This provides better text layout and consistent control
   sizing across devices.

3. **Step-based grid movement (not continuous).** Like Fire Trail, movement is discrete —
   the dragon moves one grid cell at a time. Player movement is instant (tap D-pad → move
   one cell). Enemy movement is animated (220ms slide between cells).

4. **Communication via callbacks.** Same pattern as all other games — the Flame game exposes
   callbacks (`onTileEaten`, `onEnemyCaught`, `onLevelComplete`, `onGameOver`) that the
   Flutter wrapper listens to and relays to the EventBus.

5. **Math-only categories.** The original games had word categories (animals, colors, etc.)
   — these are ALL dropped. Only number-property categories remain, keeping the app's
   math brand clean.

6. **Merged architecture.** SuperMooseMan provides the base game structure, category system,
   and enemy types. MooseMuncher contributes animated movement, variable enemy timing, and
   dynamic tile respawning.

---

## 4. Original Game Mechanics Reference

The original games (SuperMooseMan + MooseMuncher) are canvas-based HTML5 games. Key
constants and mechanics to port:

### Core Constants (from original)

| Constant | Original Value | Dragon's Feast Equivalent | Notes |
|----------|---------------|--------------------------|-------|
| Grid size | 5x5 | 5x5 | Same — core to the gameplay |
| Tile gap | 12px | 8dp | Slightly tighter for mobile |
| Board margin | 32px | Scale to screen | Dynamic based on available space |
| Player movement | Instant (SMM) / 120ms (MM) | 120ms animated | Smoother feel from MooseMuncher |
| Enemy step interval | 3000ms (SMM) / 3000-6000ms (MM) | 3000-6000ms per enemy | Variable from MooseMuncher |
| Enemy movement anim | Instant (SMM) / 220ms (MM) | 220ms animated | Smoother from MooseMuncher |
| Freeze duration | 3500ms | 5000ms | Extended for younger players |
| Invulnerability | 1200ms | 1500ms | Slightly extended |
| Caught anim | 900ms | 900ms | Same teleport animation |
| Correct score | +100 | +100 | Same |
| Wrong score | -50 (min 0) | -50 (min 0) | Same |
| Level complete bonus | +500 | +500 | Same |
| Lives | 3 | 3 | Same |
| Required correct (lvl 1-4) | 4 tiles | 8-10 matching tiles | Scaled to grid content ratio |
| Enemies per level | 2 + floor(level/3), max 6 | min(2 + floor(level/3), 6) | Same formula |
| Dynamic respawn | Yes (MM only) | Yes | When enemy steps on empty cell |
| Respawn bias | 50-100% correct | 60-80% correct | Tuned for balance |

### Key Behaviors to Preserve

- **Grid navigation:** Dragon moves one cell at a time on a 5x5 grid. Cannot move outside
  the grid boundaries.
- **Category-based tile identification:** Player must eat all tiles matching the current
  category. Eating wrong tiles costs score.
- **Enemy movement on timers:** Enemies move independently at random intervals. Two AI
  types: chaser (pursues player) and wanderer (random/forager movement).
- **Collision = caught:** If enemy and player occupy the same cell (and player is not
  invulnerable), player loses a life and respawns at (0,0).
- **Level progression:** Eat all matching tiles to advance. Category changes each level.
- **Dynamic tile respawning:** When an enemy steps on an empty/eaten cell, a new number
  can appear (biased toward correct answers).

### Mechanics Changed from Original

| Original (Muncher) | Dragon's Feast (Adaptation) | Rationale |
|---------------------|---------------------------|-----------|
| Word + math categories | Math-only categories | Clean math brand |
| Moose character | Dragon character | Theme consistency |
| Freeze power-up only | Freeze + Wings + Shield | More variety, dragon-themed |
| Fixed enemy step (3s) | Variable per-enemy (3-6s) | More unpredictable, per MooseMuncher |
| Instant player move (SMM) | 120ms animated move | Smoother, per MooseMuncher |
| 64+ levels uncapped | 40 levels across 5 worlds | Clearer progression structure |
| Mode selection menu | Categories locked to level/world | Progression-driven |
| localStorage score | Full profile integration with scales | Part of the progression system |
| Single continuous session | Level-based with results on game over | Fits the app's session design |
| ~40% board is correct | ~40% board is correct (10/25 tiles) | Same proportion |

---

## 5. File Structure

### New Files

```
lib/games/
+-- dragons_feast/
|   +-- dragons_feast_game.dart            <- Replace placeholder with real game widget
|   +-- dragons_feast_flame_game.dart      <- Flame FlameGame subclass
|   +-- dragons_feast_registration.dart    <- MathDragonsGame implementation
|   +-- components/
|   |   +-- feast_grid.dart                <- Grid background and cell rendering
|   |   +-- feast_tile.dart                <- Individual numbered tile component
|   |   +-- dragon_character.dart          <- Player dragon sprite on grid
|   |   +-- enemy_guardian.dart            <- Enemy component (chaser/wanderer)
|   |   +-- power_up_tile.dart             <- Power-up tile component (freeze/wings/shield)
|   |   +-- munch_effect.dart              <- Correct-eat particle burst effect
|   |   +-- wrong_eat_flash.dart           <- Wrong-eat red flash overlay
|   |   +-- caught_effect.dart             <- Caught-by-enemy teleport animation
|   +-- systems/
|   |   +-- category_system.dart           <- Math category definitions and predicates
|   |   +-- board_generator.dart           <- Tile generation for a given category
|   |   +-- enemy_ai.dart                  <- Enemy movement AI (chaser + wanderer)
|   |   +-- power_up_manager.dart          <- Power-up spawning, timers, and effects
|   |   +-- collision_system.dart          <- Player-enemy collision detection
|   +-- models/
|   |   +-- grid_cell.dart                 <- Cell data (number, eaten, powerup, etc.)
|   |   +-- feast_config.dart              <- Per-level difficulty configuration
|   |   +-- math_category.dart             <- Category definition model
|   |   +-- enemy_type.dart                <- Enemy type enum and properties
|   +-- widgets/
|       +-- category_display.dart          <- Current category label (Flutter)
|       +-- lives_display.dart             <- Hearts display (Flutter)
|       +-- feast_score_display.dart       <- Score, streak, and level HUD
|       +-- progress_bar.dart              <- Level progress (correct tiles eaten / needed)
|       +-- category_transition.dart       <- Category announcement overlay between levels
```

### Modified Files

| File | Change |
|------|--------|
| `lib/games/dragons_feast/dragons_feast_game.dart` | **Replace** placeholder with real game |
| `lib/app.dart` | Import and register DragonsFeast game |
| `lib/l10n/app_en.arb` | Add Dragon's Feast localization strings |

---

## 6. MathDragonsGame Implementation

### `lib/games/dragons_feast/dragons_feast_registration.dart`

```dart
import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragons_feast_game.dart';

class DragonsFeastRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragons_feast';

  @override
  String get displayName => "Dragon's Feast";

  @override
  String get description => 'Feast on the right numbers';

  @override
  String get iconAsset => 'assets/images/games/dragons_feast/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragons_feast/env.png';

  @override
  Color get accentColor => DragonColors.dragonsFeastAccent;

  @override
  List<GameLevel> get levels => _generateLevels();

  @override
  GameLevel currentLevel(PlayerGameStats stats) {
    final levelNum = stats.currentLevel.clamp(1, levels.length);
    return levels[levelNum - 1];
  }

  @override
  RewardConfig get rewardConfig => const RewardConfig(
    baseScalesPerCorrect: 2,
    streakBonusCap: 5,
    levelCompletionBonus: 20,
    threeStarBonus: 15,
  );

  @override
  List<MathSkill> get mathSkills => [
    MathSkill.numberProperties,
    MathSkill.categorization,
  ];

  @override
  Widget buildGame(GameContext context) {
    return DragonsFeastScreen(context: context);
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
    minAccuracyForAdvance: 0.6,
    minProblemsPerLevel: 6,
  );

  /// Generate all levels across 5 worlds.
  /// See section 17 for the full world/level breakdown.
  static List<GameLevel> _generateLevels() {
    // Implementation in section 17
    return [];
  }
}
```

### Registration in `app.dart`

```dart
final registry = GameRegistry(storage);
registry.register(DragonEggsRegistration());
registry.register(FireTrailRegistration());
registry.register(DragonRunesRegistration());
registry.register(DragonsFeastRegistration());
```

---

## 7. Flame Game Setup

### `lib/games/dragons_feast/dragons_feast_flame_game.dart`

The core Flame game class. Manages the grid, dragon, enemies, tiles, power-ups, and
coordinates all game systems.

```dart
import 'package:flame/game.dart';
import 'package:flame/events.dart';

class DragonsFeastFlameGame extends FlameGame {
  // -- Configuration --
  static const int gridSize = 5;
  final DragonsFeastConfig config;
  final MathCategory category;

  // -- Callbacks to Flutter --
  final void Function(bool isCorrect, int score, int streak) onTileEaten;
  final void Function() onGameOver;
  final void Function() onLevelComplete;
  final void Function(int lives) onLivesChanged;
  final void Function(int score) onScoreChanged;
  final void Function(int eaten, int needed) onProgressChanged;
  final void Function(String powerUp) onPowerUpCollected;

  // -- Game State --
  late List<List<GridCell>> board;   // 5x5 grid
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
  bool isRunning = false;
  bool isPaused = false;
  bool isGameOver = false;

  // -- Enemy State --
  List<EnemyGuardian> enemies = [];

  // -- Power-Up State --
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
  late PowerUpManager powerUpManager;
  late CollisionSystem collisionSystem;

  // -- Components --
  late DragonCharacter dragonComponent;
  List<FeastTile> tileComponents = [];
  List<EnemyGuardian> enemyComponents = [];

  DragonsFeastFlameGame({
    required this.config,
    required this.category,
    required this.onTileEaten,
    required this.onGameOver,
    required this.onLevelComplete,
    required this.onLivesChanged,
    required this.onScoreChanged,
    required this.onProgressChanged,
    required this.onPowerUpCollected,
  });

  @override
  Color backgroundColor() => const Color(0xFF0A174E);

  @override
  Future<void> onLoad() async {
    // Calculate cell size to fill available width
    final margin = 16.0;
    final gap = 8.0;
    boardSize = size.x - margin * 2;
    cellSize = (boardSize - gap * (gridSize - 1)) / gridSize;
    boardOffsetX = margin;
    boardOffsetY = (size.y - boardSize) / 2;

    // Initialize sub-systems
    enemyAI = EnemyAI(gridSize: gridSize);
    boardGen = BoardGenerator(category: category, gridSize: gridSize);
    powerUpManager = PowerUpManager();
    collisionSystem = CollisionSystem();

    // Generate initial board
    _generateBoard();

    // Add grid background
    add(FeastGrid(
      gridSize: gridSize,
      cellSize: cellSize,
      gap: 8.0,
      offsetX: boardOffsetX,
      offsetY: boardOffsetY,
    ));

    // Add dragon character at (0, 0)
    dragonComponent = DragonCharacter(cellSize: cellSize)
      ..position = _cellToPixel(0, 0);
    add(dragonComponent);

    // Add tiles
    _addTileComponents();

    // Add enemies
    _spawnEnemies();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning || isPaused || isGameOver) return;

    // Update player movement animation
    if (playerMoving) {
      playerMoveTimer += dt;
      if (playerMoveTimer >= 0.12) {  // 120ms
        playerMoving = false;
        playerX = playerTargetX;
        playerY = playerTargetY;
        dragonComponent.position = _cellToPixel(playerX, playerY);
        _checkTileAtPosition();
      } else {
        // Interpolate position
        final t = playerMoveTimer / 0.12;
        final x = playerFromX + (playerTargetX - playerFromX) * t;
        final y = playerFromY + (playerTargetY - playerFromY) * t;
        dragonComponent.position = _cellToPixelInterp(x, y);
      }
    }

    // Update enemy timers and movement
    _updateEnemies(dt);

    // Update power-up timers
    _updatePowerUpTimers(dt);

    // Update invulnerability and caught animation
    _updateInvulnerability(dt);

    // Check collision
    _checkCollision();
  }

  Vector2 _cellToPixel(int cx, int cy) {
    return Vector2(
      boardOffsetX + cx * (cellSize + 8.0) + cellSize / 2,
      boardOffsetY + cy * (cellSize + 8.0) + cellSize / 2,
    );
  }

  Vector2 _cellToPixelInterp(double cx, double cy) {
    return Vector2(
      boardOffsetX + cx * (cellSize + 8.0) + cellSize / 2,
      boardOffsetY + cy * (cellSize + 8.0) + cellSize / 2,
    );
  }

  void movePlayer(Direction dir) {
    if (!isRunning || isPaused || isGameOver || playerMoving || isCaughtAnimating) return;

    final nx = playerX + dir.dx;
    final ny = playerY + dir.dy;

    // Boundary check
    if (nx < 0 || ny < 0 || nx >= gridSize || ny >= gridSize) return;

    playerFromX = playerX;
    playerFromY = playerY;
    playerTargetX = nx;
    playerTargetY = ny;
    playerMoving = true;
    playerMoveTimer = 0;
    dragonComponent.facing = dir;
  }

  // ... tile eating, enemy updates, power-ups, collision
}
```

---

## 8. Grid System & Tile Rendering

### Grid Dimensions

The grid is **5x5** — the same as the original. This is fundamental to the gameplay
balance (enemy avoidance, category density, power-up placement).

```dart
class FeastGrid extends PositionComponent {
  final int gridSize;
  final double cellSize;
  final double gap;
  final double offsetX;
  final double offsetY;

  @override
  void render(Canvas canvas) {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final rect = Rect.fromLTWH(
          offsetX + x * (cellSize + gap),
          offsetY + y * (cellSize + gap),
          cellSize,
          cellSize,
        );

        // Cell background with gem-studded cavern feel
        final cellPaint = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2744), Color(0xFF16213E)],
          ).createShader(rect);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          cellPaint,
        );

        // Subtle border
        final borderPaint = Paint()
          ..color = const Color(0xFF2A3A5A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          borderPaint,
        );
      }
    }
  }
}
```

### Grid Cell Model

```dart
class GridCell {
  final int x;
  final int y;
  int number;              // the displayed number value
  bool isCorrect;          // matches current category?
  bool isEaten;            // has player eaten this tile?
  PowerUpType? powerUp;    // null if normal tile, else a power-up

  GridCell({
    required this.x,
    required this.y,
    required this.number,
    required this.isCorrect,
    this.isEaten = false,
    this.powerUp,
  });
}
```

### Tile Component

```dart
class FeastTile extends PositionComponent {
  final GridCell cell;
  final double cellSize;
  TileState state;  // normal, eaten, correct_flash, wrong_flash

  @override
  void render(Canvas canvas) {
    if (cell.isEaten) {
      // Eaten tile: dim green background
      final rect = Rect.fromLTWH(0, 0, cellSize, cellSize);
      final paint = Paint()
        ..color = const Color(0xFF1A3D2A).withValues(alpha: 0.5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      return;
    }

    final rect = Rect.fromLTWH(0, 0, cellSize, cellSize);

    // Normal tile background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E2744), Color(0xFF16213E)],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      bgPaint,
    );

    // Draw number text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${cell.number}',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: _fitFontSize(cellSize, '${cell.number}'),
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF0E6D3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (cellSize - textPainter.width) / 2,
        (cellSize - textPainter.height) / 2,
      ),
    );
  }

  double _fitFontSize(double cellSize, String text) {
    // Start at 32% of cell size, shrink if text is wide
    double size = cellSize * 0.32;
    if (text.length >= 3) size *= 0.8;
    return size.clamp(14.0, 28.0);
  }
}
```

### Eaten Tile Visual

When a tile is eaten, it shows a dimmed green background (correct) or stays dim (wrong).
The green tint matches the original's eaten-tile styling.

---

## 9. Dragon Character & Movement

### Dragon Character Component

The dragon is rendered facing the direction of movement. For v1 it's custom-painted;
real sprites come in Step 12.

```dart
class DragonCharacter extends PositionComponent {
  Direction facing = Direction.right;
  bool isInvulnerable = false;
  bool hasWings = false;
  bool hasShield = false;

  final double cellSize;

  DragonCharacter({required this.cellSize});

  @override
  void render(Canvas canvas) {
    final center = Offset(0, 0);
    final radius = cellSize * 0.35;

    // Body — green dragon with gold accents
    final bodyColor = hasWings
        ? const Color(0xFFF4A261)   // gold shimmer when wings active
        : hasShield
            ? const Color(0xFF5DADE2) // blue when shield active
            : const Color(0xFF27AE60); // treasure green

    // Invulnerability flicker
    final alpha = isInvulnerable
        ? (0.4 + 0.6 * ((DateTime.now().millisecondsSinceEpoch % 200) > 100 ? 1.0 : 0.0))
        : 1.0;

    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          bodyColor.withValues(alpha: alpha),
          bodyColor.withValues(alpha: alpha * 0.7),
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Eye (positioned based on facing direction)
    final eyeOffset = Offset(
      center.dx + facing.dx * radius * 0.35,
      center.dy + facing.dy * radius * 0.35,
    );
    canvas.drawCircle(
      eyeOffset,
      radius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      eyeOffset,
      radius * 0.06,
      Paint()..color = Colors.black.withValues(alpha: alpha),
    );

    // Crown/horns indicator
    _drawHorns(canvas, center, radius, alpha);
  }

  void _drawHorns(Canvas canvas, Offset center, double radius, double alpha) {
    final hornPaint = Paint()
      ..color = Color.fromRGBO(212, 132, 58, alpha)  // aged gold
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Left horn
    canvas.drawLine(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.6),
      Offset(center.dx - radius * 0.5, center.dy - radius * 1.0),
      hornPaint,
    );
    // Right horn
    canvas.drawLine(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.6),
      Offset(center.dx + radius * 0.5, center.dy - radius * 1.0),
      hornPaint,
    );
  }
}
```

### Movement Animation

Player movement uses linear interpolation over 120ms (matching MooseMuncher):

```dart
// In the game's update():
if (playerMoving) {
  playerMoveTimer += dt;
  final duration = 0.12;  // 120ms

  if (playerMoveTimer >= duration) {
    // Snap to target
    playerMoving = false;
    playerX = playerTargetX;
    playerY = playerTargetY;
    dragonComponent.position = _cellToPixel(playerX, playerY);

    // Check what's at the new position
    _checkTileAtPosition();
  } else {
    // Interpolate
    final t = (playerMoveTimer / duration).clamp(0.0, 1.0);
    final easedT = Curves.easeOut.transform(t);
    final x = playerFromX + (playerTargetX - playerFromX) * easedT;
    final y = playerFromY + (playerTargetY - playerFromY) * easedT;
    dragonComponent.position = _cellToPixelInterp(x, y);
  }
}
```

### Movement Constraints

- Cannot move outside the 5x5 grid boundaries
- Cannot move while already moving (previous move must complete)
- Cannot move while caught animation is playing
- Cannot move while paused or game over

---

## 10. Math Category System

### Category Model

```dart
class MathCategory {
  final String id;
  final String displayName;     // "Multiples of 7"
  final String description;     // "Numbers divisible by 7"
  final bool Function(int n) predicate;  // Test if n matches
  final int rangeMin;           // Min number on board
  final int rangeMax;           // Max number on board

  const MathCategory({
    required this.id,
    required this.displayName,
    required this.description,
    required this.predicate,
    this.rangeMin = 1,
    this.rangeMax = 99,
  });
}
```

### Category Definitions

All categories are math-only. Implement every category from the plan:

```dart
class CategorySystem {
  static bool _isPrime(int n) {
    if (n < 2) return false;
    if (n < 4) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }

  static bool _isPerfectSquare(int n) {
    if (n < 0) return false;
    final root = sqrt(n.toDouble()).round();
    return root * root == n;
  }

  static final List<MathCategory> allCategories = [
    // -- Even/Odd --
    MathCategory(
      id: 'even',
      displayName: 'Even Numbers',
      description: 'Numbers divisible by 2',
      predicate: (n) => n % 2 == 0,
    ),
    MathCategory(
      id: 'odd',
      displayName: 'Odd Numbers',
      description: 'Numbers not divisible by 2',
      predicate: (n) => n % 2 == 1,
    ),

    // -- Multiples --
    for (final m in [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
      MathCategory(
        id: 'mult_$m',
        displayName: 'Multiples of $m',
        description: 'Numbers divisible by $m',
        predicate: (n) => n > 0 && n % m == 0,
      ),

    // -- Primes & Composites --
    MathCategory(
      id: 'prime',
      displayName: 'Prime Numbers',
      description: 'Numbers with exactly 2 factors',
      predicate: _isPrime,
    ),
    MathCategory(
      id: 'composite',
      displayName: 'Composite Numbers',
      description: 'Numbers with more than 2 factors',
      predicate: (n) => n > 1 && !_isPrime(n),
    ),

    // -- Perfect Squares --
    MathCategory(
      id: 'squares',
      displayName: 'Perfect Squares',
      description: 'Numbers that are perfect squares',
      predicate: _isPerfectSquare,
      rangeMax: 144,  // up to 12²
    ),

    // -- Factors of N (generated dynamically per level) --
    // These are created by factorsOfCategory(n) below

    // -- Greater/Less Than (generated dynamically per level) --
    // These are created by greaterThanCategory(n) / lessThanCategory(n) below

    // -- Numbers in Range (generated dynamically per level) --
    // These are created by inRangeCategory(lo, hi) below
  ];

  /// Create a "Factors of N" category.
  static MathCategory factorsOfCategory(int n) {
    return MathCategory(
      id: 'factors_$n',
      displayName: 'Factors of $n',
      description: 'Numbers that divide evenly into $n',
      predicate: (x) => x > 0 && n % x == 0,
      rangeMin: 1,
      rangeMax: n,
    );
  }

  /// Create a "Greater than N" category.
  static MathCategory greaterThanCategory(int n) {
    return MathCategory(
      id: 'gt_$n',
      displayName: 'Greater than $n',
      description: 'Numbers larger than $n',
      predicate: (x) => x > n,
    );
  }

  /// Create a "Less than N" category.
  static MathCategory lessThanCategory(int n) {
    return MathCategory(
      id: 'lt_$n',
      displayName: 'Less than $n',
      description: 'Numbers smaller than $n',
      predicate: (x) => x > 0 && x < n,
    );
  }

  /// Create a "Between A and B" range category.
  static MathCategory inRangeCategory(int lo, int hi) {
    return MathCategory(
      id: 'range_${lo}_$hi',
      displayName: 'Between $lo and $hi',
      description: 'Numbers from $lo to $hi',
      predicate: (x) => x >= lo && x <= hi,
      rangeMin: 1,
      rangeMax: hi + 20,
    );
  }

  /// Get category for a specific level.
  /// See section 17 for the world-level-category mapping.
  static MathCategory categoryForLevel(int levelNumber) {
    // Implementation in section 17
    throw UnimplementedError();
  }
}
```

### Category Count

Total unique categories: **20+**

| Category Type | Variants | Total |
|--------------|----------|-------|
| Even / Odd | 2 | 2 |
| Multiples of N (2-12) | 11 | 11 |
| Primes | 1 | 1 |
| Composites | 1 | 1 |
| Perfect Squares | 1 | 1 |
| Factors of N | 4+ (24, 36, 48, 60) | 4 |
| Greater/Less Than | 4+ | 4 |
| Numbers in Range | 2+ | 2 |
| **Total** | | **26+** |

---

## 11. Board Generation

### Generation Algorithm

```dart
class BoardGenerator {
  final MathCategory category;
  final int gridSize;
  final Random random;

  BoardGenerator({
    required this.category,
    required this.gridSize,
    Random? random,
  }) : random = random ?? Random();

  /// Generate a 5x5 board with ~40% correct tiles.
  GeneratedBoard generate({int targetCorrectCount = 10}) {
    final board = List.generate(
      gridSize,
      (y) => List.generate(gridSize, (x) => GridCell(x: x, y: y, number: 0, isCorrect: false)),
    );

    // 1. Generate correct numbers (matching category)
    final correctNumbers = _generateCorrectNumbers(targetCorrectCount);

    // 2. Generate wrong numbers (not matching category)
    final wrongCount = gridSize * gridSize - correctNumbers.length;
    final wrongNumbers = _generateWrongNumbers(wrongCount);

    // 3. Combine and shuffle
    final allNumbers = [...correctNumbers, ...wrongNumbers];
    allNumbers.shuffle(random);

    // 4. Assign to grid
    int idx = 0;
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final num = allNumbers[idx];
        board[y][x] = GridCell(
          x: x,
          y: y,
          number: num,
          isCorrect: category.predicate(num),
        );
        idx++;
      }
    }

    return GeneratedBoard(
      cells: board,
      requiredCorrect: correctNumbers.length,
      category: category,
    );
  }

  List<int> _generateCorrectNumbers(int count) {
    final numbers = <int>[];
    final usedNumbers = <int>{};
    int attempts = 0;

    while (numbers.length < count && attempts < 500) {
      final n = category.rangeMin +
          random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (category.predicate(n) && !usedNumbers.contains(n)) {
        numbers.add(n);
        usedNumbers.add(n);
      }
      attempts++;
    }

    // If not enough unique numbers, allow repeats
    while (numbers.length < count) {
      final n = category.rangeMin +
          random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (category.predicate(n)) {
        numbers.add(n);
      }
    }

    return numbers;
  }

  List<int> _generateWrongNumbers(int count) {
    final numbers = <int>[];
    final usedNumbers = <int>{};
    int attempts = 0;

    while (numbers.length < count && attempts < 500) {
      final n = category.rangeMin +
          random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (!category.predicate(n) && !usedNumbers.contains(n)) {
        numbers.add(n);
        usedNumbers.add(n);
      }
      attempts++;
    }

    // Fallback: if not enough wrong numbers, generate from wider range
    while (numbers.length < count) {
      final n = 1 + random.nextInt(99);
      if (!category.predicate(n)) {
        numbers.add(n);
      }
    }

    return numbers;
  }
}

class GeneratedBoard {
  final List<List<GridCell>> cells;
  final int requiredCorrect;
  final MathCategory category;

  const GeneratedBoard({
    required this.cells,
    required this.requiredCorrect,
    required this.category,
  });
}
```

### Board Density

- **~40% correct tiles** (10 out of 25): same ratio as the original
- **~60% wrong tiles** (15 out of 25): plausible non-matches that require thinking
- Wrong numbers should be "tricky" — e.g., for "Multiples of 7", include 14, 21, 28 as
  correct, but also 15, 22, 27 as distractors (close but not multiples)

### Dynamic Tile Respawning

When an enemy steps on an eaten/empty cell, a new number can appear:

```dart
void _respawnTileAtCell(int x, int y) {
  if (!board[y][x].isEaten) return;

  // Bias toward correct answers: higher early, lower later
  final correctBias = (0.6 + 0.2 * (1.0 - correctEaten / requiredCorrect))
      .clamp(0.3, 0.8);

  final shouldBeCorrect = random.nextDouble() < correctBias;
  int newNumber;

  if (shouldBeCorrect) {
    newNumber = _generateSingleCorrect();
  } else {
    newNumber = _generateSingleWrong();
  }

  board[y][x] = GridCell(
    x: x,
    y: y,
    number: newNumber,
    isCorrect: category.predicate(newNumber),
  );

  // Update visual
  _updateTileComponent(x, y);

  // Recalculate required correct if a new correct tile appeared
  if (board[y][x].isCorrect) {
    requiredCorrect++;
    onProgressChanged(correctEaten, requiredCorrect);
  }
}
```

---

## 12. Tile Eating Mechanics

### Eating a Tile

When the player moves onto a tile, the tile is "eaten" automatically:

```dart
void _checkTileAtPosition() {
  final cell = board[playerY][playerX];

  if (cell.isEaten) return;  // already eaten, nothing to do

  // Check for power-up
  if (cell.powerUp != null) {
    _activatePowerUp(cell.powerUp!);
    cell.isEaten = true;
    _updateTileComponent(playerX, playerY);
    return;
  }

  // Normal tile
  cell.isEaten = true;
  final isCorrect = cell.isCorrect;

  if (isCorrect) {
    // Correct eat
    score += 100;
    streak++;
    bestStreak = max(bestStreak, streak);
    correctEaten++;

    // Streak bonus check
    if (streak >= 3) {
      score += 50;
    }

    onTileEaten(true, score, streak);
    onScoreChanged(score);
    onProgressChanged(correctEaten, requiredCorrect);

    // Visual: green glow + munch particles
    _triggerMunchEffect(playerX, playerY, true);

    // Check level complete
    _checkLevelComplete();
  } else {
    // Wrong eat
    score = max(0, score - 50);
    streak = 0;

    onTileEaten(false, score, streak);
    onScoreChanged(score);

    // Visual: red flash
    _triggerMunchEffect(playerX, playerY, false);
  }

  _updateTileComponent(playerX, playerY);
}
```

### Level Completion Check

```dart
void _checkLevelComplete() {
  // Count remaining uneaten correct tiles
  int remaining = 0;
  for (int y = 0; y < gridSize; y++) {
    for (int x = 0; x < gridSize; x++) {
      if (board[y][x].isCorrect && !board[y][x].isEaten) {
        remaining++;
      }
    }
  }

  if (remaining == 0) {
    // All correct tiles eaten — level complete!
    score += 500;  // Level complete bonus
    onScoreChanged(score);
    onLevelComplete();
  }
}
```

---

## 13. Enemy AI System

### Enemy Properties

```dart
enum EnemyType {
  chaser,    // Pursues the player (slime in original)
  wanderer,  // Random/foraging movement (owl in original)
}

class EnemyData {
  int x, y;
  EnemyType type;
  double nextMoveTimer;      // countdown to next step
  double moveInterval;        // 3.0-6.0 seconds between steps
  bool isMoving = false;
  double moveAnimTimer = 0;
  int fromX, fromY;
  int toX, toY;
  bool isFrozen = false;

  EnemyData({
    required this.x,
    required this.y,
    required this.type,
    required this.moveInterval,
  }) : nextMoveTimer = moveInterval,
       fromX = x, fromY = y, toX = x, toY = y;
}
```

### Enemy Spawning

```dart
void _spawnEnemies() {
  final count = min(2 + (config.levelNumber ~/ 3), 6);
  final occupied = <String>{'0,0'};  // player starts at (0,0)

  for (int i = 0; i < count; i++) {
    int ex, ey;
    do {
      ex = random.nextInt(gridSize);
      ey = random.nextInt(gridSize);
    } while (occupied.contains('$ex,$ey'));
    occupied.add('$ex,$ey');

    final type = i % 2 == 0 ? EnemyType.chaser : EnemyType.wanderer;
    final interval = 3.0 + random.nextDouble() * 3.0;  // 3-6 seconds

    final enemy = EnemyGuardian(
      data: EnemyData(x: ex, y: ey, type: type, moveInterval: interval),
      cellSize: cellSize,
    )..position = _cellToPixel(ex, ey);

    enemies.add(enemy);
    add(enemy);
  }
}
```

### Enemy AI Movement

```dart
class EnemyAI {
  final int gridSize;
  final Random random;

  EnemyAI({required this.gridSize, Random? random})
      : random = random ?? Random();

  /// Calculate next move for an enemy.
  (int dx, int dy) nextMove(EnemyData enemy, int playerX, int playerY) {
    switch (enemy.type) {
      case EnemyType.chaser:
        return _chaserMove(enemy, playerX, playerY);
      case EnemyType.wanderer:
        return _wandererMove(enemy);
    }
  }

  /// Chaser AI: 60% chance to move toward player, 40% random.
  (int, int) _chaserMove(EnemyData enemy, int playerX, int playerY) {
    if (random.nextDouble() < 0.6) {
      // Move toward player
      final dx = playerX - enemy.x;
      final dy = playerY - enemy.y;
      final adx = dx.abs();
      final ady = dy.abs();

      int mx = 0, my = 0;
      if (adx > ady) {
        mx = dx > 0 ? 1 : -1;
      } else if (ady > 0) {
        my = dy > 0 ? 1 : -1;
      } else {
        // Same row, move horizontally
        mx = dx > 0 ? 1 : -1;
      }

      final nx = enemy.x + mx;
      final ny = enemy.y + my;
      if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
        return (mx, my);
      }
    }

    // Fallback: random move
    return _randomMove(enemy);
  }

  /// Wanderer AI: purely random movement, 4 cardinal directions.
  (int, int) _wandererMove(EnemyData enemy) {
    return _randomMove(enemy);
  }

  (int, int) _randomMove(EnemyData enemy) {
    final dirs = [(0, -1), (0, 1), (-1, 0), (1, 0)];
    dirs.shuffle(random);
    for (final (dx, dy) in dirs) {
      final nx = enemy.x + dx;
      final ny = enemy.y + dy;
      if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
        return (dx, dy);
      }
    }
    return (0, 0);  // stuck (shouldn't happen on 5x5)
  }
}
```

### Enemy Update Loop

```dart
void _updateEnemies(double dt) {
  for (final enemy in enemies) {
    final data = enemy.data;

    // Skip if frozen
    if (freezeTimer > 0) continue;

    // Handle movement animation
    if (data.isMoving) {
      data.moveAnimTimer += dt;
      if (data.moveAnimTimer >= 0.22) {  // 220ms
        data.isMoving = false;
        data.x = data.toX;
        data.y = data.toY;
        enemy.position = _cellToPixel(data.x, data.y);

        // Dynamic tile respawn: if enemy lands on eaten cell
        _respawnTileAtCell(data.x, data.y);
      } else {
        // Interpolate
        final t = data.moveAnimTimer / 0.22;
        final x = data.fromX + (data.toX - data.fromX) * t;
        final y = data.fromY + (data.toY - data.fromY) * t;
        enemy.position = _cellToPixelInterp(x, y);
      }
      continue;
    }

    // Countdown to next move
    data.nextMoveTimer -= dt;
    if (data.nextMoveTimer <= 0) {
      // Calculate and execute move
      final (dx, dy) = enemyAI.nextMove(data, playerX, playerY);

      if (dx != 0 || dy != 0) {
        data.fromX = data.x;
        data.fromY = data.y;
        data.toX = data.x + dx;
        data.toY = data.y + dy;
        data.isMoving = true;
        data.moveAnimTimer = 0;
      }

      // Reset timer with slight randomness
      data.nextMoveTimer = data.moveInterval + (random.nextDouble() - 0.5) * 1.0;
    }
  }
}
```

### Enemy Rendering

```dart
class EnemyGuardian extends PositionComponent {
  final EnemyData data;
  final double cellSize;

  @override
  void render(Canvas canvas) {
    final center = Offset(0, 0);
    final radius = cellSize * 0.3;

    final Color bodyColor;
    switch (data.type) {
      case EnemyType.chaser:
        bodyColor = freezeTimer > 0
            ? const Color(0xFFAED6F1)     // frozen: ice blue
            : const Color(0xFFC0392B);    // dark red
        break;
      case EnemyType.wanderer:
        bodyColor = freezeTimer > 0
            ? const Color(0xFFD7BDE2)     // frozen: light purple
            : const Color(0xFF8E44AD);    // purple
        break;
    }

    // Body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [bodyColor, bodyColor.withValues(alpha: 0.7)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Eyes
    final eyeRadius = radius * 0.18;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.15),
      eyeRadius,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.15),
      eyeRadius,
      Paint()..color = Colors.white,
    );

    // Pupils
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.15),
      eyeRadius * 0.5,
      Paint()..color = Colors.black,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.15),
      eyeRadius * 0.5,
      Paint()..color = Colors.black,
    );

    // Type indicator
    if (data.type == EnemyType.chaser) {
      // Fangs/teeth for chasers
      _drawFangs(canvas, center, radius);
    } else {
      // Glasses for wanderers (homage to the owl)
      _drawGlasses(canvas, center, radius);
    }
  }
}
```

---

## 14. Power-Up System

### Power-Up Types

```dart
enum PowerUpType {
  freeze,   // Fire breath — freeze all enemies for 5 seconds
  wings,    // Wings — fly over enemies safely for 3 seconds
  shield,   // Shield — invulnerability for 3 seconds
}
```

### Power-Up Spawning

Power-ups spawn on random empty grid cells. One power-up appears every 2 levels
(starting from level 2), and at most one power-up exists on the board at a time.

```dart
class PowerUpManager {
  final Random random;

  PowerUpManager({Random? random}) : random = random ?? Random();

  /// Determine if and what power-up to place for this level.
  PowerUpType? powerUpForLevel(int levelNumber) {
    if (levelNumber < 2) return null;
    if (levelNumber % 2 != 0) return null;

    // Cycle through power-up types
    const types = [PowerUpType.freeze, PowerUpType.wings, PowerUpType.shield];
    return types[(levelNumber ~/ 2 - 1) % types.length];
  }
}
```

### Power-Up Tile Rendering

```dart
class PowerUpTile extends PositionComponent {
  final PowerUpType type;
  final double cellSize;
  double pulseTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    pulseTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, cellSize, cellSize);
    final pulse = 0.8 + 0.2 * sin(pulseTimer * 4);

    // Background with pulsing glow
    final Color glowColor;
    final String icon;
    switch (type) {
      case PowerUpType.freeze:
        glowColor = const Color(0xFFAED6F1);  // ice blue
        icon = '❄';
        break;
      case PowerUpType.wings:
        glowColor = const Color(0xFFF4A261);  // gold
        icon = '🪽';
        break;
      case PowerUpType.shield:
        glowColor = const Color(0xFF5DADE2);  // blue
        icon = '🛡';
        break;
    }

    // Glow
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.3 * pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      glowPaint,
    );

    // Draw icon text
    _drawText(canvas, icon, cellSize);
  }
}
```

### Power-Up Activation

```dart
void _activatePowerUp(PowerUpType type) {
  onPowerUpCollected(type.name);

  switch (type) {
    case PowerUpType.freeze:
      freezeTimer = 5.0;  // 5 seconds
      // Visual: all enemies turn ice blue
      for (final enemy in enemies) {
        enemy.data.isFrozen = true;
      }
      break;

    case PowerUpType.wings:
      wingsTimer = 3.0;  // 3 seconds
      dragonComponent.hasWings = true;
      // Visual: dragon turns gold
      break;

    case PowerUpType.shield:
      shieldTimer = 3.0;  // 3 seconds
      dragonComponent.hasShield = true;
      // Visual: dragon turns blue with shield effect
      break;
  }
}

void _updatePowerUpTimers(double dt) {
  if (freezeTimer > 0) {
    freezeTimer -= dt;
    if (freezeTimer <= 0) {
      freezeTimer = 0;
      for (final enemy in enemies) {
        enemy.data.isFrozen = false;
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
```

---

## 15. Scoring & Lives

### Scoring System

| Action | Score Change |
|--------|-------------|
| Correct eat | +100 |
| Wrong eat | -50 (minimum 0) |
| Streak bonus (streak >= 3) | +50 per correct eat |
| Level complete | +500 |

### Lives System

- Start with **3 lives**
- Lose a life when caught by an enemy (same grid cell)
- On caught: player teleports to (0,0), enemy teleports to (4,4)
- Brief invulnerability period (1500ms) after being caught
- Game over when lives reach 0

### Collision Detection

```dart
void _checkCollision() {
  if (invulnTimer > 0 || isCaughtAnimating) return;
  if (wingsTimer > 0 || shieldTimer > 0) return;  // power-up immunity

  for (final enemy in enemies) {
    final data = enemy.data;
    // Use rounded positions for interpolated movement
    final ex = data.isMoving ? data.toX : data.x;
    final ey = data.isMoving ? data.toY : data.y;

    if (ex == playerX && ey == playerY) {
      _handleCaught(enemy);
      return;
    }
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

  // Caught animation
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
  invulnTimer = 1.5;  // 1500ms
  dragonComponent.isInvulnerable = true;
}

void _updateInvulnerability(double dt) {
  if (isCaughtAnimating) {
    caughtAnimTimer += dt;
    if (caughtAnimTimer >= 0.9) {  // 900ms caught animation
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
```

---

## 16. Touch Controls

### D-Pad Overlay

Same D-pad implementation as Fire Trail — 4 directional buttons in a cross layout.
Each button is 64dp.

```dart
class FeastDPadControls extends StatelessWidget {
  final void Function(Direction) onDirection;

  static const double _buttonSize = 64.0;
  static const double _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonSize * 3 + _gap * 2,
      height: _buttonSize * 3 + _gap * 2,
      child: Stack(
        children: [
          // Up
          Positioned(
            left: _buttonSize + _gap,
            top: 0,
            child: _DPadButton(
              icon: Icons.arrow_drop_up,
              onPressed: () => onDirection(Direction.up),
              size: _buttonSize,
            ),
          ),
          // Down
          Positioned(
            left: _buttonSize + _gap,
            bottom: 0,
            child: _DPadButton(
              icon: Icons.arrow_drop_down,
              onPressed: () => onDirection(Direction.down),
              size: _buttonSize,
            ),
          ),
          // Left
          Positioned(
            left: 0,
            top: _buttonSize + _gap,
            child: _DPadButton(
              icon: Icons.arrow_left,
              onPressed: () => onDirection(Direction.left),
              size: _buttonSize,
            ),
          ),
          // Right
          Positioned(
            right: 0,
            top: _buttonSize + _gap,
            child: _DPadButton(
              icon: Icons.arrow_right,
              onPressed: () => onDirection(Direction.right),
              size: _buttonSize,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Swipe Gesture Support

Swipe gestures on the game area as an alternative to the D-pad. Uses the same
`SwipeDetector` class from Fire Trail (18dp threshold).

### Auto-Eat

Unlike the original (which requires Space/Enter to eat), Dragon's Feast eats automatically
when the player moves onto a tile. This simplifies the mobile experience — one less
action to perform.

---

## 17. Difficulty & World Progression

### 5-World Level Structure

Each world has 8 levels. Categories progress from simple to complex across worlds.

```dart
class DragonsFeastConfig {
  final int levelNumber;
  final int worldNumber;
  final int levelInWorld;        // 1-8
  final MathCategory category;
  final int enemyCount;          // 2-6
  final double enemySpeedMin;    // minimum step interval (seconds)
  final double enemySpeedMax;    // maximum step interval (seconds)
  final int correctTileCount;    // how many correct tiles on board
  final bool hasPowerUp;
  final PowerUpType? powerUpType;
}
```

### World Definitions

| World | Name | Levels | Categories | Enemies | Number Range |
|-------|------|--------|-----------|---------|-------------|
| 1 | Easy Pickings | 1-8 | Even, Odd, Mult 2, Mult 5, Mult 10, Mult 3, Mult 4, Greater than N | 2-3 | 1-50 |
| 2 | Growing Appetite | 9-16 | Mult 6, Mult 7, Mult 8, Mult 9, Less than N, Mult 11, Mult 12, Range | 3-4 | 1-80 |
| 3 | Refined Palate | 17-24 | Primes, Composites, Perfect Squares, Factors of 24, Even+large, Odd+large, Mult 7+large, Primes+large | 4-5 | 1-99 |
| 4 | Gourmet Dragon | 25-32 | Factors of 36, Factors of 48, Factors of 60, Mult 11+hard, Primes+hard, Composites+hard, Squares+hard, Mixed | 5-6 | 1-99 |
| 5 | Dragon King's Feast | 33-40 | Mixed hard categories, faster enemies, all category types rotated | 6 | 1-99 |

### Category Assignment Per Level

```dart
static MathCategory categoryForLevel(int levelNumber) {
  switch (levelNumber) {
    // World 1: Easy Pickings
    case 1: return allCategories.firstWhere((c) => c.id == 'even');
    case 2: return allCategories.firstWhere((c) => c.id == 'odd');
    case 3: return allCategories.firstWhere((c) => c.id == 'mult_2');
    case 4: return allCategories.firstWhere((c) => c.id == 'mult_5');
    case 5: return allCategories.firstWhere((c) => c.id == 'mult_10');
    case 6: return allCategories.firstWhere((c) => c.id == 'mult_3');
    case 7: return allCategories.firstWhere((c) => c.id == 'mult_4');
    case 8: return greaterThanCategory(25);

    // World 2: Growing Appetite
    case 9: return allCategories.firstWhere((c) => c.id == 'mult_6');
    case 10: return allCategories.firstWhere((c) => c.id == 'mult_7');
    case 11: return allCategories.firstWhere((c) => c.id == 'mult_8');
    case 12: return allCategories.firstWhere((c) => c.id == 'mult_9');
    case 13: return lessThanCategory(30);
    case 14: return allCategories.firstWhere((c) => c.id == 'mult_11');
    case 15: return allCategories.firstWhere((c) => c.id == 'mult_12');
    case 16: return inRangeCategory(20, 50);

    // World 3: Refined Palate
    case 17: return allCategories.firstWhere((c) => c.id == 'prime');
    case 18: return allCategories.firstWhere((c) => c.id == 'composite');
    case 19: return allCategories.firstWhere((c) => c.id == 'squares');
    case 20: return factorsOfCategory(24);
    case 21: return allCategories.firstWhere((c) => c.id == 'even');  // larger range
    case 22: return allCategories.firstWhere((c) => c.id == 'odd');   // larger range
    case 23: return allCategories.firstWhere((c) => c.id == 'mult_7');// larger range
    case 24: return allCategories.firstWhere((c) => c.id == 'prime'); // larger range

    // World 4: Gourmet Dragon
    case 25: return factorsOfCategory(36);
    case 26: return factorsOfCategory(48);
    case 27: return factorsOfCategory(60);
    case 28: return allCategories.firstWhere((c) => c.id == 'mult_11');
    case 29: return allCategories.firstWhere((c) => c.id == 'prime');
    case 30: return allCategories.firstWhere((c) => c.id == 'composite');
    case 31: return allCategories.firstWhere((c) => c.id == 'squares');
    case 32: return greaterThanCategory(50);

    // World 5: Dragon King's Feast — rotate through hard categories
    case 33: return allCategories.firstWhere((c) => c.id == 'prime');
    case 34: return factorsOfCategory(72);
    case 35: return allCategories.firstWhere((c) => c.id == 'mult_7');
    case 36: return allCategories.firstWhere((c) => c.id == 'squares');
    case 37: return factorsOfCategory(96);
    case 38: return allCategories.firstWhere((c) => c.id == 'composite');
    case 39: return inRangeCategory(30, 70);
    case 40: return allCategories.firstWhere((c) => c.id == 'prime');

    default: return allCategories.firstWhere((c) => c.id == 'even');
  }
}
```

### Enemy Speed by World

```dart
(double min, double max) enemySpeedForWorld(int worldNumber) {
  switch (worldNumber) {
    case 1: return (4.0, 6.0);   // Slow: 4-6 seconds per step
    case 2: return (3.5, 5.5);   // Medium-slow
    case 3: return (3.0, 5.0);   // Medium
    case 4: return (2.5, 4.5);   // Medium-fast
    case 5: return (2.0, 4.0);   // Fast
    default: return (3.0, 6.0);
  }
}
```

### Per-Level Config Factory

```dart
static DragonsFeastConfig configForLevel(int levelNumber) {
  final world = ((levelNumber - 1) ~/ 8) + 1;
  final levelInWorld = ((levelNumber - 1) % 8) + 1;

  final category = CategorySystem.categoryForLevel(levelNumber);
  final enemyCount = min(2 + (levelNumber ~/ 3), 6);
  final (speedMin, speedMax) = enemySpeedForWorld(world);

  // Correct tile count: ~40% of 25 = 10, with slight variation
  final correctCount = (8 + levelInWorld * 0.5).round().clamp(8, 12);

  // Power-up on even-numbered levels starting from level 2
  final powerUpType = PowerUpManager().powerUpForLevel(levelNumber);

  return DragonsFeastConfig(
    levelNumber: levelNumber,
    worldNumber: world,
    levelInWorld: levelInWorld,
    category: category,
    enemyCount: enemyCount,
    enemySpeedMin: speedMin,
    enemySpeedMax: speedMax,
    correctTileCount: correctCount,
    hasPowerUp: powerUpType != null,
    powerUpType: powerUpType,
  );
}
```

### Level Generation

```dart
static List<GameLevel> _generateLevels() {
  final levels = <GameLevel>[];

  // World 1: Easy Pickings (Levels 1-8)
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: i,
      name: 'Easy Pickings $i',
      worldName: 'Easy Pickings',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 50,
        operations: {},  // N/A for Dragon's Feast
        speedMultiplier: 1.0,
      ),
      starsRequired: i > 1 ? 1 : 0,
    ));
  }

  // World 2: Growing Appetite (Levels 9-16)
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 8 + i,
      name: 'Growing Appetite $i',
      worldName: 'Growing Appetite',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 80,
        operations: {},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 3: Refined Palate (Levels 17-24)
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 16 + i,
      name: 'Refined Palate $i',
      worldName: 'Refined Palate',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 99,
        operations: {},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 4: Gourmet Dragon (Levels 25-32)
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 24 + i,
      name: 'Gourmet Dragon $i',
      worldName: 'Gourmet Dragon',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 99,
        operations: {},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 5: Dragon King's Feast (Levels 33-40)
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 32 + i,
      name: "Dragon King's Feast $i",
      worldName: "Dragon King's Feast",
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 99,
        operations: {},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  return levels;
}
```

---

## 18. Fact Tracking & Adaptive Selection

### Integration with FactTracker

On every tile eaten (correct or wrong), record via the event bus:

```dart
void _recordAnswer(int number, bool isCorrect, int responseTimeMs) {
  // Fact key format: "category_id:number" (e.g., "mult_7:28")
  final factKey = '${category.id}:$number';

  eventBus.emit(AnswerGiven(
    gameId: 'dragons_feast',
    problem: factKey,
    playerAnswer: isCorrect ? 'correct' : 'wrong',
    correctAnswer: isCorrect ? 'correct' : 'should_skip',
    correct: isCorrect,
    responseTimeMs: responseTimeMs,
  ));
}
```

### Response Time Tracking

For Dragon's Feast, response time is measured from when the player last ate a tile (or
the level started) to the next tile eaten. This captures decision-making time between
eats.

```dart
DateTime? _lastEatTime;

void _onLevelStart() {
  _lastEatTime = DateTime.now();
}

int _getResponseTimeMs() {
  if (_lastEatTime == null) return 0;
  final ms = DateTime.now().difference(_lastEatTime!).inMilliseconds;
  _lastEatTime = DateTime.now();
  return ms;
}
```

### Fact Key Format

For Dragon's Feast, fact keys are category-based rather than operation-based:
- `"mult_7:28"` — correctly identified 28 as a multiple of 7
- `"prime:17"` — correctly identified 17 as prime
- `"factors_24:8"` — correctly identified 8 as a factor of 24

---

## 19. Event Bus Integration

### Events Emitted

```dart
// On game start (entering a level)
eventBus.emit(GameStarted(gameId: 'dragons_feast', levelNumber: currentLevel));

// On every tile eaten (correct or wrong)
eventBus.emit(AnswerGiven(
  gameId: 'dragons_feast',
  problem: factKey,
  playerAnswer: isCorrect ? 'correct' : 'wrong',
  correctAnswer: isCorrect ? 'correct' : 'should_skip',
  correct: isCorrect,
  responseTimeMs: responseTimeMs,
));

// On streak milestones (5, 10, 15, ...)
if (streak > 0 && streak % 5 == 0) {
  eventBus.emit(StreakAchieved(gameId: 'dragons_feast', streakLength: streak));
}

// On level completion (all correct tiles eaten)
eventBus.emit(LevelCompleted(
  gameId: 'dragons_feast',
  levelNumber: currentLevel,
  score: totalScore,
  stars: calculateStars(),
  accuracy: correctEaten / (correctEaten + wrongEaten),
));

// On game over (lives = 0) or leaving the game
eventBus.emit(GameEnded(
  gameId: 'dragons_feast',
  finalScore: totalScore,
  duration: gameDuration,
));
```

---

## 20. Game Flow & State Machine

### Game Phases

```dart
enum FeastGamePhase { loading, categoryTransition, playing, paused, levelComplete, gameOver }
```

### Flow

```
App Start
  |
  v
Hub -> Tap Dragon's Feast card
  |
  v
DragonsFeastScreen mounts (Flutter)
  |
  v
GameShell wraps, emits GameStarted
  |
  v
Category transition overlay (1.2 seconds)
  |  Shows category name in large Cinzel text, fades out
  v
FeastGamePhase.playing
  |
  v
PLAYING LOOP:
  |
  +-- Player moves via D-pad or swipe (one cell at a time)
  +-- Movement animates over 120ms
  +-- On arriving at cell:
  |     +-- If tile not eaten:
  |     |     +-- If CORRECT: +100, streak++, green glow, munch particles
  |     |     +-- If WRONG: -50, streak=0, red flash
  |     |     +-- If POWER-UP: activate power-up ability
  |     +-- If tile eaten: no action (walk through)
  +-- Enemies move on independent timers (3-6 sec intervals)
  +-- Enemy movement animates over 220ms
  +-- When enemy lands on eaten cell: may respawn a new number tile
  +-- Collision check each frame:
  |     +-- If player and enemy on same cell (no immunity):
  |     |     Lives -= 1
  |     |     Player teleports to (0,0), caught enemy to (4,4)
  |     |     1500ms invulnerability
  |     |     If lives == 0 → game over
  +-- Power-up timers count down (freeze, wings, shield)
  +-- Level complete when all correct tiles eaten
  +-- Pause → overlay with Resume / Settings / Quit
  |
  v (all correct tiles eaten)
FeastGamePhase.levelComplete
  |
  +-- Score += 500 bonus
  +-- Celebration particles
  +-- Emit LevelCompleted event
  +-- Show category transition for next category
  |
  v
Start next level with new category, fresh board, enemies respawned
  |
  v (lives == 0)
FeastGamePhase.gameOver
  |
  +-- Emit GameEnded event
  +-- Show ResultScreen with final stats
  +-- "Play Again" (restart from level 1) or "Back to Hub"
```

### Star Calculation

Stars are based on accuracy and lives remaining:

```dart
int calculateStars(double accuracy, int livesRemaining) {
  // 3 stars: 90%+ accuracy with all 3 lives remaining
  if (accuracy >= 0.9 && livesRemaining == 3) return 3;
  // 2 stars: 75%+ accuracy with at least 2 lives
  if (accuracy >= 0.75 && livesRemaining >= 2) return 2;
  // 1 star: completed level (always earned)
  return 1;
}
```

### Category Transition Overlay

Between levels, briefly show the new category name:

```dart
class CategoryTransition extends StatefulWidget {
  final String categoryName;
  final VoidCallback onComplete;

  @override
  State<CategoryTransition> createState() => _CategoryTransitionState();
}

class _CategoryTransitionState extends State<CategoryTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward().then((_) => widget.onComplete());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final opacity = _controller.value < 0.7
            ? 1.0
            : 1.0 - (_controller.value - 0.7) / 0.3;

        return Center(
          child: Opacity(
            opacity: opacity,
            child: Text(
              widget.categoryName,
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0E6D3),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 21. Game Over & Results

### Game Over Handling

Unlike Dragon Runes (no game over), Dragon's Feast ends when all 3 lives are lost.
The game also tracks the highest level reached in the session.

```dart
void _triggerGameOver() {
  isGameOver = true;

  eventBus.emit(GameEnded(
    gameId: 'dragons_feast',
    finalScore: score,
    duration: gameDuration,
  ));

  onGameOver();
}
```

### Result Screen Data

```dart
void _showResults() {
  final accuracy = (correctEaten + wrongEaten) > 0
      ? correctEaten / (correctEaten + wrongEaten)
      : 0.0;

  final results = GameResults(
    gameId: 'dragons_feast',
    score: score,
    accuracy: accuracy,
    streak: bestStreak,
    scalesEarned: scalesThisSession,
    stars: calculateStars(accuracy, lives),
    levelNumber: currentLevel,
    problemsAttempted: correctEaten + wrongEaten,
    problemsCorrect: correctEaten,
  );

  showResultScreen(results);
}
```

### Continuous Level Progression

Dragon's Feast plays continuously — clearing a level immediately generates the next
one with a new category and fresh board. The session continues until the player either:
1. Loses all 3 lives (game over → results)
2. Quits via pause menu (session ends → results for current session)

This "arcade run" design creates natural "just one more level" hooks and rewards
sustained play.

---

## 22. HUD Elements

### Category Display (Flutter Widget)

Positioned prominently above the game grid:

```dart
class CategoryDisplay extends StatelessWidget {
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F3D).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.dragonsFeastAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF0E6D3),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
```

### Lives Display

```dart
class LivesDisplay extends StatelessWidget {
  final int lives;
  final int maxLives;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            i < lives ? Icons.favorite : Icons.favorite_border,
            color: i < lives
                ? const Color(0xFFE74C3C)
                : const Color(0xFF4A4A6A),
            size: 20,
          ),
        );
      }),
    );
  }
}
```

### Score & Progress Display

```dart
class FeastScoreDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int correctEaten;
  final int requiredCorrect;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score
        Text(
          'Score: $score',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: DragonColors.dragonGold,
          ),
        ),

        // Streak (if active)
        if (streak > 0)
          Row(children: [
            const Icon(Icons.local_fire_department,
                color: Color(0xFFE76F51), size: 18),
            Text(
              'x$streak',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE76F51),
              ),
            ),
          ]),

        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$correctEaten / $requiredCorrect',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: Color(0xFFA89DB8),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 80,
              height: 4,
              child: LinearProgressIndicator(
                value: requiredCorrect > 0
                    ? (correctEaten / requiredCorrect).clamp(0.0, 1.0)
                    : 0.0,
                backgroundColor: const Color(0xFF2A2A4A),
                valueColor: const AlwaysStoppedAnimation(
                  DragonColors.dragonsFeastAccent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Recent Answers Panel (Optional)

A scrollable panel on the side showing recent eat results. Correct answers in green,
wrong in red. Mimics the original's recent answers buffer.

---

## 23. Visual Effects

### Correct Eat — Munch Effect

Green gem-shatter particles burst from the eaten tile:

```dart
class MunchEffect extends PositionComponent {
  static const int particleCount = 15;

  final bool isCorrect;
  final List<_MunchParticle> particles = [];

  @override
  void onLoad() {
    final color = isCorrect
        ? const Color(0xFF27AE60)  // treasure green
        : const Color(0xFFE74C3C); // red

    for (int i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 40 + random.nextDouble() * 100;
      particles.add(_MunchParticle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        life: 0.3 + random.nextDouble() * 0.3,
        color: color.withValues(
          alpha: 0.5 + random.nextDouble() * 0.5,
        ),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 30 * dt;  // slight gravity
      p.t += dt;
    }
    particles.removeWhere((p) => p.t >= p.life);
    if (particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in particles) {
      final alpha = (1.0 - p.t / p.life).clamp(0.0, 1.0);
      final size = 3.0 * (1.0 - p.t / p.life * 0.5);
      canvas.drawCircle(
        Offset(p.x, p.y),
        size,
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }
}
```

### Wrong Eat — Red Flash

Red tint overlay on the game area for 400ms:

```dart
// Same WrongAnswerFlash pattern as Fire Trail
```

### Caught Animation — Teleport Effect

When caught by an enemy, brief flash and the dragon teleports to (0,0):

```dart
class CaughtEffect extends PositionComponent {
  double elapsed = 0;
  static const double duration = 0.9;  // 900ms

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;
    if (elapsed >= duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    // Expanding ring effect at caught position
    final progress = elapsed / duration;
    final radius = 20.0 + progress * 40.0;
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = const Color(0xFFE74C3C).withValues(alpha: alpha * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }
}
```

### Freeze Visual

When freeze power-up is active, all enemies render in ice blue and a subtle blue
tint covers the grid:

```dart
// Enemies check freezeTimer > 0 and render in ice blue colors
// Grid overlay: faint blue tint at 10% opacity
```

### Level Complete Celebration

Same celebration pattern as other games — particle bursts + score tally:

```dart
void _triggerLevelCompleteCelebration() {
  for (int burst = 0; burst < 3; burst++) {
    Future.delayed(Duration(milliseconds: burst * 300), () {
      final x = random.nextDouble() * boardSize + boardOffsetX;
      final y = random.nextDouble() * boardSize + boardOffsetY;
      add(MunchEffect(isCorrect: true)..position = Vector2(x, y));
    });
  }
}
```

---

## 24. Localization Updates

### Add to `lib/l10n/app_en.arb`

```json
{
  "dragonsFeastTitle": "Dragon's Feast",
  "@dragonsFeastTitle": { "description": "Game title for hub and HUD" },

  "currentCategory": "Category: {category}",
  "@currentCategory": {
    "description": "Current math category display",
    "placeholders": { "category": { "type": "String" } }
  },

  "correctEat": "Delicious!",
  "@correctEat": { "description": "Feedback on eating a correct tile" },

  "wrongEat": "Yuck!",
  "@wrongEat": { "description": "Feedback on eating a wrong tile" },

  "caughtByEnemy": "Caught!",
  "@caughtByEnemy": { "description": "Feedback when caught by an enemy" },

  "livesRemaining": "{count} lives left",
  "@livesRemaining": {
    "description": "Lives counter",
    "placeholders": { "count": { "type": "int" } }
  },

  "levelCleared": "Level cleared!",
  "@levelCleared": { "description": "Shown when all correct tiles are eaten" },

  "freezeActivated": "Fire Breath! Enemies frozen!",
  "@freezeActivated": { "description": "Freeze power-up activation" },

  "wingsActivated": "Wings! Fly over enemies!",
  "@wingsActivated": { "description": "Wings power-up activation" },

  "shieldActivated": "Shield! Invulnerable!",
  "@shieldActivated": { "description": "Shield power-up activation" },

  "tilesEaten": "{count} tiles eaten",
  "@tilesEaten": {
    "description": "Total tiles eaten stat",
    "placeholders": { "count": { "type": "int" } }
  },

  "levelsCleared": "{count} levels cleared",
  "@levelsCleared": {
    "description": "Levels cleared in session",
    "placeholders": { "count": { "type": "int" } }
  },

  "easyPickings": "Easy Pickings",
  "@easyPickings": { "description": "Dragon's Feast World 1 name" },

  "growingAppetite": "Growing Appetite",
  "@growingAppetite": { "description": "Dragon's Feast World 2 name" },

  "refinedPalate": "Refined Palate",
  "@refinedPalate": { "description": "Dragon's Feast World 3 name" },

  "gourmetDragon": "Gourmet Dragon",
  "@gourmetDragon": { "description": "Dragon's Feast World 4 name" },

  "dragonKingsFeast": "Dragon King's Feast",
  "@dragonKingsFeast": { "description": "Dragon's Feast World 5 name" },

  "evenNumbers": "Even Numbers",
  "@evenNumbers": { "description": "Category name" },

  "oddNumbers": "Odd Numbers",
  "@oddNumbers": { "description": "Category name" },

  "multiplesOf": "Multiples of {n}",
  "@multiplesOf": {
    "description": "Multiples category name",
    "placeholders": { "n": { "type": "int" } }
  },

  "primeNumbers": "Prime Numbers",
  "@primeNumbers": { "description": "Category name" },

  "compositeNumbers": "Composite Numbers",
  "@compositeNumbers": { "description": "Category name" },

  "perfectSquares": "Perfect Squares",
  "@perfectSquares": { "description": "Category name" },

  "factorsOf": "Factors of {n}",
  "@factorsOf": {
    "description": "Factors category name",
    "placeholders": { "n": { "type": "int" } }
  },

  "greaterThan": "Greater than {n}",
  "@greaterThan": {
    "description": "Greater than category name",
    "placeholders": { "n": { "type": "int" } }
  },

  "lessThan": "Less than {n}",
  "@lessThan": {
    "description": "Less than category name",
    "placeholders": { "n": { "type": "int" } }
  },

  "between": "Between {lo} and {hi}",
  "@between": {
    "description": "Range category name",
    "placeholders": {
      "lo": { "type": "int" },
      "hi": { "type": "int" }
    }
  }
}
```

---

## 25. Unit Tests

### Test Files

```
test/
+-- games/
    +-- dragons_feast/
        +-- category_system_test.dart
        +-- board_generator_test.dart
        +-- enemy_ai_test.dart
        +-- power_up_manager_test.dart
        +-- scoring_test.dart
        +-- collision_test.dart
        +-- difficulty_config_test.dart
```

### `test/games/dragons_feast/category_system_test.dart`

```dart
// Test cases:
// 1. Even: 2, 4, 6 → true; 1, 3, 5 → false
// 2. Odd: 1, 3, 5 → true; 2, 4, 6 → false
// 3. Multiples of 7: 7, 14, 21, 49 → true; 8, 15, 20 → false
// 4. Multiples of 12: 12, 24, 36 → true; 11, 13, 25 → false
// 5. Prime: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 → true
// 6. Prime: 1, 4, 6, 8, 9, 10, 12, 15 → false
// 7. Composite: 4, 6, 8, 9, 10, 12, 15 → true; 1, 2, 3, 5, 7 → false
// 8. Perfect squares: 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144 → true
// 9. Perfect squares: 2, 3, 5, 10, 50 → false
// 10. Factors of 24: 1, 2, 3, 4, 6, 8, 12, 24 → true; 5, 7, 9, 10, 11 → false
// 11. Factors of 36: 1, 2, 3, 4, 6, 9, 12, 18, 36 → true
// 12. Greater than 25: 26, 30, 50, 99 → true; 1, 25 → false
// 13. Less than 30: 1, 15, 29 → true; 30, 31, 50 → false
// 14. In range 20-50: 20, 35, 50 → true; 19, 51 → false
// 15. Edge cases: 0, negative numbers handled gracefully
// 16. All categories have unique IDs
// 17. categoryForLevel returns valid categories for levels 1-40
```

### `test/games/dragons_feast/board_generator_test.dart`

```dart
// Test cases:
// 1. Board is 5x5 (25 cells)
// 2. Board has approximately 40% correct tiles (8-12)
// 3. All correct tiles pass the category predicate
// 4. All wrong tiles fail the category predicate
// 5. No empty tiles on initial generation
// 6. Numbers are within category's range (rangeMin to rangeMax)
// 7. For "Even" category: all correct tiles are even, all wrong are odd
// 8. For "Primes": all correct tiles are prime
// 9. For "Multiples of 7": all correct tiles are divisible by 7
// 10. For "Factors of 24": all correct tiles divide evenly into 24
// 11. Board has reasonable number diversity (not all the same number)
// 12. Generate with different categories produces different boards
// 13. requiredCorrect equals the actual count of correct tiles
// 14. Fallback: generates board even with restrictive category (e.g., perfect squares)
```

### `test/games/dragons_feast/enemy_ai_test.dart`

```dart
// Test cases:
// 1. Chaser moves toward player when bias triggers (60% of the time on average)
// 2. Chaser reduces Manhattan distance to player
// 3. Wanderer moves in a valid direction
// 4. All moves stay within 5x5 grid bounds
// 5. No move returns an out-of-bounds position
// 6. Enemy at (0,0), player at (4,4): chaser moves right or down
// 7. Enemy at same position as player: any valid move
// 8. Enemy in corner: only valid moves returned (no out-of-bounds)
// 9. Random seeded AI produces deterministic results
```

### `test/games/dragons_feast/power_up_manager_test.dart`

```dart
// Test cases:
// 1. Level 1 has no power-up
// 2. Level 2 has a power-up (freeze)
// 3. Level 4 has a power-up (wings)
// 4. Level 6 has a power-up (shield)
// 5. Level 8 cycles back to freeze
// 6. Odd levels have no power-up
// 7. Power-up types cycle: freeze → wings → shield → freeze
```

### `test/games/dragons_feast/scoring_test.dart`

```dart
// Test cases:
// 1. Correct eat adds 100 points
// 2. Wrong eat subtracts 50 points
// 3. Score never goes below 0
// 4. Streak >= 3 adds 50 bonus per correct eat
// 5. Streak resets to 0 on wrong eat
// 6. Level complete adds 500 bonus
// 7. Best streak tracks maximum across session
// 8. correctEaten increments only on correct eats
// 9. wrongEaten increments only on wrong eats
// 10. Accuracy calculation: correct / (correct + wrong)
```

### `test/games/dragons_feast/collision_test.dart`

```dart
// Test cases:
// 1. Player and enemy at same cell → caught
// 2. Player and enemy at different cells → not caught
// 3. Player invulnerable → no caught even at same cell
// 4. Wings active → no caught even at same cell
// 5. Shield active → no caught even at same cell
// 6. Caught reduces lives by 1
// 7. Caught teleports player to (0,0)
// 8. Caught teleports enemy to (4,4)
// 9. Caught starts invulnerability timer (1500ms)
// 10. Lives reaching 0 triggers game over
```

### `test/games/dragons_feast/difficulty_config_test.dart`

```dart
// Test cases:
// 1. Level 1: Easy Pickings, 2 enemies, Even Numbers
// 2. Level 8: Easy Pickings, 4 enemies, Greater than 25
// 3. Level 9: Growing Appetite, 5 enemies, Mult of 6
// 4. Level 17: Refined Palate, Prime Numbers
// 5. Level 25: Gourmet Dragon, Factors of 36
// 6. Level 33: Dragon King's Feast, 6 enemies, Prime Numbers
// 7. World 5 enemies are fastest (2-4 sec intervals)
// 8. Total levels = 40
// 9. All level numbers are unique and sequential
// 10. Enemy count formula: min(2 + level/3, 6)
// 11. Every level has a valid MathCategory assigned
```

---

## 26. Verification Checklist

After completing this step, verify:

### Gameplay

- [ ] **5x5 grid renders** — treasure cavern themed cells with proper spacing
- [ ] **Numbers display** — all 25 tiles show numbers, sized to fit
- [ ] **Dragon navigates** — D-pad and swipe move one cell at a time
- [ ] **Movement animates** — 120ms slide, eased, no teleporting
- [ ] **Cannot leave grid** — movement at boundaries is blocked
- [ ] **Cannot move while moving** — no double-step on fast taps
- [ ] **Correct eat** — +100, green munch effect, haptic feedback
- [ ] **Wrong eat** — -50 (min 0), red flash, wrong haptic
- [ ] **Auto-eat on move** — no separate eat button needed
- [ ] **Streak tracking** — increments on correct, resets on wrong
- [ ] **Streak bonus** — +50 at streak >= 3
- [ ] **Level completes** — when all correct tiles eaten
- [ ] **Level complete bonus** — +500 points
- [ ] **New level starts** — new category, fresh board, enemies respawned
- [ ] **Category transition** — name displayed between levels (1.2s)

### Enemies

- [ ] **Enemies spawn** — 2-6 per level based on formula
- [ ] **Two types** — chasers (red, pursues player) and wanderers (purple, random)
- [ ] **Independent timers** — each enemy moves on its own 3-6 second interval
- [ ] **Movement animates** — 220ms slide per step
- [ ] **Chaser AI** — generally moves toward player
- [ ] **Wanderer AI** — random movement
- [ ] **Collision = caught** — lose life, teleport, invulnerability starts
- [ ] **Game over** — at 0 lives, show results
- [ ] **Dynamic respawn** — new tiles appear when enemies step on eaten cells

### Power-Ups

- [ ] **Spawn on even levels** — freeze, wings, shield rotate
- [ ] **Freeze** — enemies stop for 5 seconds, visual ice blue
- [ ] **Wings** — pass through enemies for 3 seconds, gold visual
- [ ] **Shield** — invulnerability for 3 seconds, blue visual
- [ ] **Collected on move** — auto-pick up when player enters cell

### Categories

- [ ] **Even/Odd** — correctly identifies all even and odd numbers
- [ ] **Multiples** — correct for all multiples 2-12
- [ ] **Primes** — correctly identifies primes (2, 3, 5, 7, 11, 13, ...)
- [ ] **Composites** — correctly identifies composites
- [ ] **Perfect squares** — 1, 4, 9, 16, 25, ...
- [ ] **Factors of N** — correct factor sets for 24, 36, 48, 60
- [ ] **Greater/Less than** — correct boundary behavior
- [ ] **In range** — correct inclusive range behavior
- [ ] **Board has ~40% correct** — reasonable density, not too easy or hard

### Integration

- [ ] **Hub card** — Dragon's Feast card on hub navigates to the game
- [ ] **GameShell wraps** — pause overlay works (Resume/Settings/Quit)
- [ ] **Result screen** — appears on game over with correct stats
- [ ] **Play Again** — restarts from level 1
- [ ] **Back to Hub** — returns to hub cleanly
- [ ] **Event bus** — emits GameStarted, AnswerGiven, StreakAchieved, LevelCompleted, GameEnded
- [ ] **FactTracker** — records every eat attempt with timing data
- [ ] **RewardService** — awards scales for correct eats and streaks
- [ ] **Profile updates** — totalScales, totalCorrectAnswers, gameStats change

### Technical

- [ ] **`flutter analyze`** — passes clean
- [ ] **`flutter test`** — all tests pass (existing + new)
- [ ] **`flutter build apk --debug`** — succeeds
- [ ] **No memory leaks** — particle effects and old components are cleaned up
- [ ] **Enemy timers cleaned up** — no orphaned timers on game exit
- [ ] **Performance** — smooth on emulator with 6 enemies active

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
