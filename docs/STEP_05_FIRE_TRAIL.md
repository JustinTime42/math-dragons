# Step 5: Game Port — Fire Trail (Math Snake)

> **Goal:** Port the HTML5 Math Snake game to Flutter/Flame as "Fire Trail" — a grid-based
> dragon movement game where the player navigates a fire-breathing dragon head through a
> grid, eating gems that contain the correct answer to the displayed math problem. The
> flame trail replaces the snake body, and a flame intensity meter replaces the lives system.
> The game must feel fast, responsive, and satisfying with tight touch controls.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 4 complete. Dragon Eggs fully playable and integrated. `flutter analyze`
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
8. [Grid System & Rendering](#8-grid-system--rendering)
9. [Dragon Head & Flame Trail](#9-dragon-head--flame-trail)
10. [Movement & Direction](#10-movement--direction)
11. [Math Problem Generation](#11-math-problem-generation)
12. [Answer Gem Placement](#12-answer-gem-placement)
13. [Flame Intensity Mechanic](#13-flame-intensity-mechanic)
14. [Touch Controls](#14-touch-controls)
15. [Speed & Difficulty Progression](#15-speed--difficulty-progression)
16. [Wrap Mode](#16-wrap-mode)
17. [Visual Effects](#17-visual-effects)
18. [Fact Tracking & Adaptive Selection](#18-fact-tracking--adaptive-selection)
19. [Event Bus Integration](#19-event-bus-integration)
20. [Game Flow & State Machine](#20-game-flow--state-machine)
21. [Game Over & Results](#21-game-over--results)
22. [HUD Elements](#22-hud-elements)
23. [Localization Updates](#23-localization-updates)
24. [Unit Tests](#24-unit-tests)
25. [Verification Checklist](#25-verification-checklist)

---

## 1. User Stories

### US-5.1: Play Fire Trail
**As a** player,
**I want** to guide a fire dragon across a grid to eat the correct answer gem,
**so that** I can practice mental math under time pressure in a fast-paced game.

### US-5.2: Flame Intensity
**As a** player,
**I want** my dragon's flame to dim when I eat wrong answers and brighten on correct ones,
**so that** I feel the stakes without a harsh "lives" system.

### US-5.3: Responsive Touch Controls
**As a** player,
**I want** a D-pad and swipe controls that respond instantly to my input,
**so that** I can navigate accurately at high speeds without frustration.

### US-5.4: Speed Progression
**As a** player,
**I want** the game to start slow and get faster as I advance through worlds,
**so that** the challenge ramps up gradually and I build skill over time.

### US-5.5: Flame Trail Visual
**As a** player,
**I want** my dragon to leave a glowing flame trail as it moves,
**so that** the game looks and feels like a dragon soaring through the sky.

### US-5.6: Earn Scales
**As a** player,
**I want** to earn Dragon Scales for correct answers and streaks,
**so that** my Fire Trail sessions contribute to my overall progression.

### US-5.7: See My Results
**As a** player,
**I want** a results screen after each round showing my score, accuracy, streak, and scales earned,
**so that** every session ends with a satisfying summary.

### US-5.8: Wrap Mode Challenge
**As a** player,
**I want** wrap mode at higher levels where I can go off one edge and appear on the other,
**so that** advanced play introduces new strategic possibilities.

---

## 2. Acceptance Criteria

- [ ] Fire Trail is fully playable from the hub screen
- [ ] Dragon head moves on a grid in 4 directions at a step-based speed
- [ ] Flame trail follows the dragon head, rendering with a fire gradient
- [ ] Math problem displays prominently on screen
- [ ] 4-6 answer gems are placed once when the level loads, one per generated problem
- [ ] Eating the answer for the displayed problem: score increases, celebration effect, next remaining problem displays
- [ ] Eating a wrong gem: flame intensity drops by 20%, red flash, trail dims
- [ ] Correct answer restores 10% flame intensity (capped at 100%)
- [ ] Game over when flame intensity reaches 0%
- [ ] Game over on self-collision (eating own flame trail)
- [ ] Walls kill without wrap mode; wrap mode enabled at World 5
- [ ] D-pad overlay with 4 directional buttons (min 60dp each)
- [ ] Swipe gestures work as an alternative input method
- [ ] Speed increases across levels (World 1: ~4 steps/sec, World 5: ~12 steps/sec)
- [ ] 5 worlds with 8 levels each (40 levels total)
- [ ] Streak tracking with fire visual indicator
- [ ] Event bus emits: `GameStarted`, `AnswerGiven`, `StreakAchieved`, `LevelCompleted`, `GameEnded`
- [ ] FactTracker records every answer attempt with timing data
- [ ] RewardService awards scales based on correct answers, streaks, and completion
- [ ] Pause overlay pauses movement and hides answer values
- [ ] Game registers with `GameRegistry` and appears correctly on the hub
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] Game is genuinely fun and responsive to play

---

## 3. Architecture Overview

### How Flame Integrates with Flutter

Fire Trail uses a Flame `FlameGame` embedded in Flutter via `GameWidget`, following the
same pattern established in Dragon Eggs. The grid, dragon, trail, and gems are Flame
components. The HUD (problem display, score, flame meter), D-pad controls, and pause
overlay are Flutter widgets overlaid on the game.

```
+------------------------------------------------------+
|                 GameShell (Flutter)                    |
|  +--------------------------------------------------+|
|  |  HUD Bar: Pause | Title | Scales                 ||
|  +--------------------------------------------------+|
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |     Problem Display (Flutter)               |   ||
|  |  |     "7 x 8"                                 |   ||
|  |  +--------------------------------------------+   ||
|  |  |                                              |   ||
|  |  |       FlameGame (GameWidget)                 |   ||
|  |  |   +--------------------------------------+   |   ||
|  |  |   |  . . . . . . . . . . . . . . . . . . |   |   ||
|  |  |   |  . . . [56] . . . . . . . [48] . . . |   |   ||
|  |  |   |  . . . . . . . . . . . . . . . . . . |   |   ||
|  |  |   |  . . . . . .>D~~~~~~~. . . . . . . . |   |   ||
|  |  |   |  . . . . . . . . . . . . . . . . . . |   |   ||
|  |  |   |  . [63] . . . . . . . [42] . . . . . |   |   ||
|  |  |   |  . . . . . . . . . . . . . . . . . . |   |   ||
|  |  |   +--------------------------------------+   |   ||
|  |  |                                              |   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |  Score: 230  |  Flame: [========--] 80%    |   ||
|  |  |  Streak: x5  |  Level: World 2-3           |   ||
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

1. **Flame for grid and game objects.** The grid, dragon head, flame trail segments,
   and answer gems are Flame `PositionComponent`s. The game loop handles step-based
   movement and collision detection.

2. **Flutter for controls and HUD.** The D-pad, problem display, score/flame meter,
   and overlays are Flutter widgets. This provides better accessibility and layout
   flexibility than implementing them in Flame.

3. **Step-based movement (not continuous).** Unlike Dragon Eggs' continuous physics,
   Fire Trail uses discrete grid steps. The dragon moves one cell per step at a
   frequency determined by the current speed setting.

4. **Communication via callbacks.** Same pattern as Dragon Eggs — the Flame game
   exposes callbacks (`onAnswerEaten`, `onGameOver`, `onScoreChanged`) that the
   Flutter wrapper listens to and relays to the EventBus.

---

## 4. Original Game Mechanics Reference

The original Math Snake (`snakeGame.html`) is a canvas-based HTML5 game. Key constants
and mechanics to port:

### Core Constants (from original)

| Constant | Original Value | Fire Trail Equivalent | Notes |
|----------|---------------|----------------------|-------|
| Grid size | 21x21 | 15x15 (phone-friendly) | Smaller grid for mobile touch targets |
| Cell size | 30px | Scale to screen | Dynamic based on available width |
| Initial length | 7 segments | 5 segments | Slightly shorter for mobile |
| Speed range | 3-20 steps/sec | 4-12 steps/sec | Tighter range, per-level |
| Lives | 5 | N/A (flame intensity) | Replaced with flame mechanic |
| Correct score | +10 | +10 base (scaled by difficulty) | Same base, with multipliers |
| Wrong penalty | -1 life, +3 growth | -20% flame, +2 growth | Slightly gentler growth |
| Answer tiles | 4 (1 correct + 3 distractors) | 4-6 (1 correct + 3-5 distractors) | More distractors at higher levels |
| Direction lock | Per-step | Per-step | Prevents 180-degree reversal |
| Wrap mode | Player toggle | World 5 only | Automatic at high levels |

### Key Behaviors to Preserve

- **Direction locking:** Only one direction change per step. Prevents 180-degree
  reversal (can't go right if currently going left).
- **Step timing:** Movement is Hz-based. At 8 Hz, the dragon moves 8 cells per
  second. Accumulator-based timing ensures consistent speed regardless of frame rate.
- **Self-collision:** Hitting any segment of the flame trail = game over.
- **Answer placement:** Level answer gems are placed on random free cells when the
  level loads (not on the dragon, trail, or immediate next step). They stay fixed
  until eaten or the level ends.
- **Problem watermark:** The original shows the problem as a large watermark in the
  center of the grid. Fire Trail shows it as a prominent Flutter widget above the grid.
- **Wrong-answer flash:** Red tint over the entire game area, fading over 400ms.
- **Celebration effect:** Star/sparkle particles burst from the correct gem position.
- **Countdown:** 3-2-1-GO before game starts.
- **Growth on wrong answer:** The trail grows longer when a wrong answer is eaten,
  making the game harder (more self-collision risk).

### Mechanics Changed from Original

| Original (Math Snake) | Fire Trail (Adaptation) | Rationale |
|----------------------|------------------------|-----------|
| 5 lives, lose 1 on wrong | Flame intensity 0-100%, lose 20% on wrong | More visual, less "counting lives" |
| Snake shrinks on correct if length > 7 | Trail shrinks on correct if length > initial | Same mechanic, different framing |
| All settings player-configurable | Settings locked to level/world | Progression-driven, not settings-driven |
| 21x21 grid | 15x15 grid | Better for mobile touch targets |
| Wrap mode is a toggle | Wrap mode only in World 5 | Progression reward |
| Speed is a slider | Speed set by level | Removes decision paralysis |

---

## 5. File Structure

### New Files

```
lib/games/
+-- fire_trail/
|   +-- fire_trail_game.dart            <- Flutter widget wrapping the Flame game
|   +-- fire_trail_flame_game.dart      <- Flame FlameGame subclass
|   +-- fire_trail_registration.dart    <- MathDragonsGame implementation
|   +-- components/
|   |   +-- grid_renderer.dart          <- Grid lines and background rendering
|   |   +-- dragon_head.dart            <- Dragon head component (directional)
|   |   +-- trail_segment.dart          <- Individual flame trail segment
|   |   +-- answer_gem.dart             <- Answer tile gem component
|   |   +-- gem_sparkle_effect.dart     <- Correct-answer celebration particles
|   +-- systems/
|   |   +-- movement_system.dart        <- Step-based movement, direction, collision
|   |   +-- problem_manager.dart        <- Problem generation and answer placement
|   |   +-- trail_manager.dart          <- Trail growth, shrink, rendering
|   +-- models/
|   |   +-- grid_position.dart          <- Grid coordinate model
|   |   +-- fire_trail_config.dart      <- Per-level difficulty configuration
|   |   +-- flame_intensity.dart        <- Flame intensity state + calculations
|   +-- widgets/
|       +-- problem_display.dart        <- Flutter overlay showing current problem
|       +-- flame_meter.dart            <- Flame intensity bar (HUD)
|       +-- dpad_controls.dart          <- Touch D-pad + swipe handler
|       +-- score_streak_display.dart   <- Score and streak HUD
|       +-- countdown_overlay.dart      <- 3-2-1-GO countdown before start
```

### Modified Files

| File | Change |
|------|--------|
| `lib/games/fire_trail/fire_trail_game.dart` | **Replace** placeholder with real game |
| `lib/core/game_registry.dart` | Register FireTrail on app startup |
| `lib/app.dart` | Import and register FireTrail game |
| `lib/l10n/app_en.arb` | Add Fire Trail localization strings |

---

## 6. MathDragonsGame Implementation

### `lib/games/fire_trail/fire_trail_registration.dart`

```dart
import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'fire_trail_game.dart';

class FireTrailRegistration implements MathDragonsGame {
  @override
  String get gameId => 'fire_trail';

  @override
  String get displayName => 'Fire Trail';

  @override
  String get description => 'Blaze a trail of correct answers';

  @override
  String get iconAsset => 'assets/images/games/fire_trail/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/fire_trail/env.png';

  @override
  Color get accentColor => DragonColors.fireTrailAccent;

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
    MathSkill.addition,
    MathSkill.subtraction,
    MathSkill.multiplication,
    MathSkill.division,
    MathSkill.mentalMathSpeed,
  ];

  @override
  Widget buildGame(GameContext context) {
    return FireTrailScreen(context: context);
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
    minAccuracyForAdvance: 0.6,
    minProblemsPerLevel: 8,
  );

  /// Generate all levels across 5 worlds.
  /// See section 15 for the full world/level breakdown.
  static List<GameLevel> _generateLevels() {
    // Implementation in section 15
    return [];
  }
}
```

### Registration in `app.dart`

```dart
final registry = GameRegistry(storage);
registry.register(DragonEggsRegistration());
registry.register(FireTrailRegistration());
```

---

## 7. Flame Game Setup

### `lib/games/fire_trail/fire_trail_flame_game.dart`

The core Flame game class. Manages the game loop, grid state, movement timing, and
coordinates all game systems.

```dart
import 'package:flame/game.dart';
import 'package:flame/events.dart';

class FireTrailFlameGame extends FlameGame {
  // -- Configuration --
  final int gridSize;         // 15 for standard
  final int startingLevel;
  final FireTrailConfig config;

  // -- Callbacks to Flutter --
  final void Function(bool isCorrect, int score, int streak) onAnswerEaten;
  final void Function() onGameOver;
  final void Function(double flamePercent) onFlameChanged;
  final void Function(int score) onScoreChanged;

  // -- Game State --
  late GridPosition headPosition;
  late Direction currentDirection;
  late Direction nextDirection;
  bool dirLocked = false;
  List<GridPosition> trail = [];
  List<AnswerGem> gems = [];
  bool isRunning = false;
  bool isPaused = false;
  bool isGameOver = false;

  // -- Timing --
  double stepAccumulator = 0;
  double stepIntervalMs = 0;  // set from config speed

  // -- Rendering --
  late double cellSize;
  late double fieldSize;

  // -- Sub-systems --
  late MovementSystem movement;
  late ProblemManager problems;
  late TrailManager trailManager;

  FireTrailFlameGame({
    this.gridSize = 15,
    required this.startingLevel,
    required this.config,
    required this.onAnswerEaten,
    required this.onGameOver,
    required this.onFlameChanged,
    required this.onScoreChanged,
  });

  @override
  Future<void> onLoad() async {
    // Calculate cell size to fit available screen width
    cellSize = size.x / gridSize;
    fieldSize = cellSize * gridSize;

    stepIntervalMs = 1000.0 / config.stepsPerSecond;

    // Initialize grid renderer
    add(GridRenderer(gridSize: gridSize, cellSize: cellSize));

    // Seed initial dragon position and trail
    _seedDragon();

    // Initialize sub-systems
    movement = MovementSystem(gridSize: gridSize, wrap: config.wrapMode);
    problems = ProblemManager(config: config);
    trailManager = TrailManager(initialLength: 5);

    // Generate all level problems and place fixed answer gems
    _placeLevelGems();
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
    if (!isRunning || isPaused || isGameOver) return;

    stepAccumulator += dt * 1000;

    int steps = 0;
    while (stepAccumulator >= stepIntervalMs && steps < 3) {
      _step();
      stepAccumulator -= stepIntervalMs;
      steps++;
    }
  }

  void _step() {
    // Apply queued direction
    currentDirection = nextDirection;
    dirLocked = false;

    // Calculate new head position
    final newHead = movement.nextPosition(headPosition, currentDirection);

    // Check wall collision (no-wrap mode)
    if (newHead == null) {
      _triggerGameOver();
      return;
    }

    // Check self-collision
    if (trail.any((s) => s == newHead)) {
      _triggerGameOver();
      return;
    }

    // Move: old head becomes first trail segment
    trail.insert(0, headPosition);
    headPosition = newHead;

    // Check gem collision
    final hitGem = gems.firstWhere(
      (g) => g.position == newHead,
      orElse: () => null,
    );

    if (hitGem != null) {
      _handleGemEaten(hitGem);
    } else {
      // Normal movement: remove tail (or grow if pending)
      trailManager.handleNormalStep(trail);
    }
  }

  void setDirection(Direction dir) {
    if (dirLocked) return;
    if (dir.isOpposite(currentDirection)) return;
    nextDirection = dir;
    dirLocked = true;
  }

  // ... gem handling, game over, restart
}
```

---

## 8. Grid System & Rendering

### Grid Dimensions

The grid is **15x15** for mobile (vs the original 21x21). This provides:
- Larger cells for touch targets on phone screens
- Less visual clutter
- A cell size of ~24dp on a 360dp-wide phone, comfortably above the 44dp minimum
  when accounting for the dragon head and gem sizes occupying the full cell

```dart
class GridRenderer extends PositionComponent {
  final int gridSize;
  final double cellSize;

  @override
  void render(Canvas canvas) {
    // 1. Fill background with Night Sky gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
      ).createShader(Rect.fromLTWH(0, 0, fieldSize, fieldSize));
    canvas.drawRect(Rect.fromLTWH(0, 0, fieldSize, fieldSize), bgPaint);

    // 2. Draw subtle grid lines
    final linePaint = Paint()
      ..color = const Color(0xFF2A2A4A).withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= gridSize; i++) {
      final pos = i * cellSize;
      canvas.drawLine(Offset(pos, 0), Offset(pos, fieldSize), linePaint);
      canvas.drawLine(Offset(0, pos), Offset(fieldSize, pos), linePaint);
    }
  }
}
```

### Grid Position Model

```dart
class GridPosition {
  final int x;
  final int y;

  const GridPosition(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is GridPosition && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ (y.hashCode * 31);

  /// Convert to pixel position (center of cell).
  Offset toPixel(double cellSize) =>
      Offset(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2);
}
```

### Direction Enum

```dart
enum Direction {
  up(0, -1),
  down(0, 1),
  left(-1, 0),
  right(1, 0);

  final int dx;
  final int dy;

  const Direction(this.dx, this.dy);

  bool isOpposite(Direction other) =>
      dx == -other.dx && dy == -other.dy;
}
```

---

## 9. Dragon Head & Flame Trail

### Dragon Head Component

The dragon head is rendered facing the current direction. For v1 it's custom-painted;
real sprites come in Step 12.

```dart
class DragonHead extends PositionComponent {
  Direction facing;
  double flameIntensity;  // 0.0 - 1.0, affects brightness

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.4;

    // Head circle (dragon-red when bright, dimmer when low flame)
    final brightness = 0.5 + flameIntensity * 0.5;
    final headColor = Color.lerp(
      const Color(0xFF8B2500),  // dim ember
      const Color(0xFFE74C3C),  // full dragon red
      brightness,
    )!;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [headColor, headColor.withValues(alpha: 0.7)],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);

    // Eye (small white dot, positioned based on facing direction)
    final eyeOffset = Offset(
      center.dx + facing.dx * radius * 0.3,
      center.dy + facing.dy * radius * 0.3,
    );
    canvas.drawCircle(eyeOffset, radius * 0.15,
        Paint()..color = Colors.white);

    // Direction indicator (small triangle pointing in movement direction)
    _drawDirectionIndicator(canvas, center, radius);
  }
}
```

### Flame Trail Segments

Each trail segment is rendered with a fire gradient that fades from hot (near the head)
to cool (at the tail). The gradient respects flame intensity — as intensity drops,
the trail dims.

```dart
class TrailSegment extends PositionComponent {
  final int indexFromHead;  // 0 = closest to head
  final int totalLength;
  final double flameIntensity;

  @override
  void render(Canvas canvas) {
    final progress = indexFromHead / totalLength;  // 0.0 (head) to 1.0 (tail)
    final intensity = flameIntensity;

    // Color gradient: orange -> gold -> light yellow, dimming with intensity
    final color = Color.lerp(
      Color.lerp(
        const Color(0xFFE74C3C),  // near head: red-orange
        const Color(0xFFFFF3B0),  // at tail: pale yellow
        progress,
      ),
      const Color(0xFF3D1F00),    // dimmed: dark ember
      1.0 - intensity,
    )!;

    final rect = Rect.fromLTWH(1, 1, size.x - 2, size.y - 2);
    final borderRadius = size.x * 0.15;

    final paint = Paint()..color = color.withValues(alpha: 0.7 + intensity * 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }
}
```

### Trail Rendering Order

Trail segments are rendered from tail to head so that segments closer to the
dragon head appear on top:

```dart
void _renderTrail(Canvas canvas) {
  for (int i = trail.length - 1; i >= 0; i--) {
    final segment = trail[i];
    _drawTrailSegment(canvas, segment, i, trail.length);
  }
}
```

---

## 10. Movement & Direction

### Step-Based Movement

Movement is Hz-based, matching the original. An accumulator tracks elapsed time;
when it exceeds the step interval, one grid step occurs.

```dart
class MovementSystem {
  final int gridSize;
  final bool wrap;

  MovementSystem({required this.gridSize, required this.wrap});

  /// Calculate the next position. Returns null if wall collision (no-wrap mode).
  GridPosition? nextPosition(GridPosition current, Direction dir) {
    int nx = current.x + dir.dx;
    int ny = current.y + dir.dy;

    if (wrap) {
      nx = (nx + gridSize) % gridSize;
      ny = (ny + gridSize) % gridSize;
    } else {
      if (nx < 0 || ny < 0 || nx >= gridSize || ny >= gridSize) {
        return null;  // wall collision
      }
    }

    return GridPosition(nx, ny);
  }
}
```

### Direction Locking

Only one direction change is allowed per step. This prevents the player from
queuing a 180-degree reversal by pressing two keys/buttons quickly:

```dart
void setDirection(Direction dir) {
  if (dirLocked) return;
  // Prevent 180-degree reversal
  if (dir.isOpposite(currentDirection)) return;
  nextDirection = dir;
  dirLocked = true;
}

// In _step():
void _step() {
  currentDirection = nextDirection;
  dirLocked = false;  // unlock for next step
  // ... rest of step logic
}
```

---

## 11. Math Problem Generation

### Problem Generation

Problems are generated based on the current level's allowed operations and number
ranges, using the shared `math_problem.dart` utilities from Step 4.

```dart
class ProblemManager {
  final FireTrailConfig config;
  MathProblem? currentProblem;

  ProblemManager({required this.config});

  void generateProblem() {
    final ops = config.allowedOperations;
    final min = config.numberMin;
    final max = config.numberMax;

    MathOp op;
    int a, b, answer;
    int attempts = 0;

    do {
      op = ops[random.nextInt(ops.length)];

      switch (op) {
        case MathOp.add:
          a = _randRange(min, max);
          b = _randRange(min, max);
          answer = a + b;
          break;
        case MathOp.subtract:
          a = _randRange(min, max);
          b = _randRange(min, max);
          if (a < b) { final t = a; a = b; b = t; }
          answer = a - b;
          break;
        case MathOp.multiply:
          a = _randRange(min, max);
          b = _randRange(min, max);
          answer = a * b;
          break;
        case MathOp.divide:
          // Integer division only: pick b and quotient, compute a = b * q
          b = _randRange(math.max(2, min), max);
          final q = _randRange(1, max);
          a = b * q;
          answer = q;
          break;
      }
      attempts++;
    } while (attempts < 10 && answer < 0);

    currentProblem = MathProblem(
      left: a,
      op: op,
      right: b,
      answer: answer,
    );
  }

  int _randRange(int min, int max) => min + random.nextInt(max - min + 1);
}
```

### Problem Display Format

The problem is displayed as `"a op b"` without showing the answer. The player must
eat the gem containing the correct answer.

```dart
String get displayText {
  if (currentProblem == null) return '';
  final p = currentProblem!;
  final opSymbol = {
    MathOp.add: '+',
    MathOp.subtract: '\u2212',  // minus sign
    MathOp.multiply: '\u00D7',  // multiplication sign
    MathOp.divide: '\u00F7',    // division sign
  }[p.op]!;
  return '${p.left} $opSymbol ${p.right}';
}
```

---

## 12. Answer Gem Placement

### Placement Rules

1. Place the correct answer gem on a random free cell
2. Place 3-5 distractor gems on random free cells
3. "Free cell" = not occupied by dragon head, trail, or another gem
4. Distractors are plausible wrong answers (off by 1-3, or result of wrong operation)

```dart
class GemPlacer {
  List<AnswerGem> placeGems({
    required MathProblem problem,
    required GridPosition head,
    required List<GridPosition> trail,
    required int gridSize,
    required int distractorCount,  // 3-5 based on level
  }) {
    final gems = <AnswerGem>[];
    final occupied = <GridPosition>{head, ...trail};

    // Place correct answer
    final correctPos = _findFreeCell(occupied, gridSize);
    if (correctPos != null) {
      gems.add(AnswerGem(
        position: correctPos,
        value: problem.answer,
        isCorrect: true,
      ));
      occupied.add(correctPos);
    }

    // Place distractors
    int placed = 0;
    int attempts = 0;
    while (placed < distractorCount && attempts < 200) {
      final value = _generateDistractor(problem);
      // Don't duplicate values
      if (gems.any((g) => g.value == value)) { attempts++; continue; }

      final pos = _findFreeCell(occupied, gridSize);
      if (pos != null) {
        gems.add(AnswerGem(
          position: pos,
          value: value,
          isCorrect: false,
        ));
        occupied.add(pos);
        placed++;
      }
      attempts++;
    }

    return gems;
  }

  int _generateDistractor(MathProblem problem) {
    final correct = problem.answer;
    // Plausible wrong answers:
    // 1. Off by 1-3
    // 2. Result of a different operation
    // 3. Transposed digits (e.g., 56 -> 65)
    final strategies = [
      () => correct + _randRange(-3, 3).clamp(-correct + 1, 999),
      () => problem.left + problem.right,  // addition result
      () => problem.left * problem.right,  // multiplication result
      () => (problem.left - problem.right).abs(),  // subtraction result
    ];

    int result;
    int tries = 0;
    do {
      result = strategies[random.nextInt(strategies.length)]();
      tries++;
    } while ((result == correct || result < 0) && tries < 20);

    return result == correct ? correct + 1 : result;
  }

  GridPosition? _findFreeCell(Set<GridPosition> occupied, int gridSize) {
    for (int i = 0; i < 100; i++) {
      final pos = GridPosition(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
      if (!occupied.contains(pos)) return pos;
    }
    return null;
  }
}
```

### Answer Gem Component

```dart
class AnswerGem extends PositionComponent {
  final GridPosition gridPos;
  final int value;
  final bool isCorrect;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(2, 2, size.x - 4, size.y - 4);
    final radius = size.x * 0.2;

    // Gem shape: rounded rectangle with gradient
    final color = isCorrect
        ? const Color(0xFF2A9D8F)   // emerald (hidden from player)
        : const Color(0xFF2A9D8F);  // same color — player can't tell!
    // All gems look the same. The player must know the answer, not guess by color.

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF2D6E74),
          const Color(0xFF1A4A4F),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );

    // Draw the number value
    _drawText(canvas, '$value');
  }
}
```

**Important:** All answer gems look identical. The player cannot distinguish correct
from incorrect by appearance — they must solve the math problem mentally.

---

## 13. Flame Intensity Mechanic

This is the primary adaptation from the original's lives system. Flame intensity is a
percentage (0-100%) that replaces discrete lives.

### Flame Intensity Model

```dart
class FlameIntensity {
  double _value = 1.0;  // 0.0 to 1.0

  double get value => _value;
  int get percent => (_value * 100).round();
  bool get isAlive => _value > 0;

  /// Penalty for wrong answer: -20%
  void onWrongAnswer() {
    _value = (_value - 0.20).clamp(0.0, 1.0);
  }

  /// Reward for correct answer: +10% (capped at 100%)
  void onCorrectAnswer() {
    _value = (_value + 0.10).clamp(0.0, 1.0);
  }

  /// Reset to full.
  void reset() {
    _value = 1.0;
  }

  /// Get the visual flame color based on current intensity.
  Color get flameColor {
    if (_value > 0.7) return const Color(0xFFE74C3C);    // bright red-orange
    if (_value > 0.4) return const Color(0xFFF4A261);    // gold-orange
    if (_value > 0.2) return const Color(0xFFE76F51);    // fire orange (warning)
    return const Color(0xFF8B2500);                       // dark ember (danger)
  }
}
```

### Balance Rationale

- **-20% per wrong answer** means 5 wrong answers without any correct = game over
  (same effective health as 5 lives in the original)
- **+10% per correct answer** allows recovery but at a slower rate than loss (must
  get 2 correct to recover from 1 wrong). This maintains tension.
- At 20% or below, the flame meter turns danger-red with a subtle pulse animation
  to communicate urgency.

### Flame Meter UI

The flame meter is a horizontal bar in the HUD:

```dart
class FlameMeter extends StatelessWidget {
  final double intensity;  // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    final color = FlameIntensity.colorForValue(intensity);
    final isDanger = intensity <= 0.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flame: ${(intensity * 100).round()}%',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDanger ? DragonColors.fireOrange : DragonColors.dragonGold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 120,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A4A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: intensity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 14. Touch Controls

### D-Pad Overlay

The D-pad is a Flutter widget overlaid below the game area. Four large directional
buttons in a cross layout. Each button is at least 60dp to ensure comfortable touch targets.

```dart
class DPadControls extends StatelessWidget {
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

class _DPadButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2F61), Color(0xFF1C2147)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Icon(icon, color: const Color(0xFFE8ECFF), size: 32),
      ),
    );
  }
}
```

### Swipe Gesture Support

In addition to the D-pad, swipe gestures on the game area provide an alternative
input method. The swipe threshold is 18px (matching the original).

```dart
class SwipeDetector {
  static const double _threshold = 18.0;

  Offset? _startPosition;

  void onPointerDown(Offset position) {
    _startPosition = position;
  }

  Direction? onPointerMove(Offset position) {
    if (_startPosition == null) return null;

    final dx = position.dx - _startPosition!.dx;
    final dy = position.dy - _startPosition!.dy;
    final adx = dx.abs();
    final ady = dy.abs();

    if (adx + ady > _threshold) {
      _startPosition = null;  // consume the gesture
      if (adx > ady) {
        return dx > 0 ? Direction.right : Direction.left;
      } else {
        return dy > 0 ? Direction.down : Direction.up;
      }
    }

    return null;
  }

  void onPointerUp() {
    _startPosition = null;
  }
}
```

### D-Pad vs. Swipe

Both control methods work simultaneously:
- **D-pad** is always visible below the game (primary for phone play)
- **Swipe** works on the game area itself (for players who prefer gesture controls)
- Both call the same `setDirection()` method on the Flame game

---

## 15. Speed & Difficulty Progression

### 5-World Level Structure

Each world has 8 levels. Speed, operations, and number ranges increase across worlds.

```dart
class FireTrailConfig {
  final int worldNumber;
  final int levelInWorld;        // 1-8
  final int numberMin;
  final int numberMax;
  final List<MathOp> allowedOperations;
  final double stepsPerSecond;   // movement speed
  final int distractorCount;     // 3-5
  final bool wrapMode;
  final int correctToAdvance;    // correct answers needed to clear level
}
```

### World Definitions

| World | Name | Levels | Ops | Number Range | Speed (steps/sec) | Wrap | Distractors | Correct to Advance |
|-------|------|--------|-----|-------------|-------------------|------|-------------|-------------------|
| 1 | First Flight | 1-8 | + | 1-5 -> 1-8 | 3.5 -> 4.5 | No | 3 | 6 -> 8 |
| 2 | Thermal Currents | 9-16 | +, - | 1-10 | 5.0 -> 6.0 | No | 3-4 | 8 -> 10 |
| 3 | Firestorm | 17-24 | +, -, x | 2-10 | 6.5 -> 8.0 | No | 4 | 10 -> 12 |
| 4 | Inferno | 25-32 | +, -, x, / | 2-12 | 8.5 -> 10.0 | No | 4-5 | 12 -> 14 |
| 5 | Dragon Master | 33-40 | +, -, x, / | 2-12 | 10.5 -> 12.0 | **Yes** | 5 | 14 -> 16 |

### Level Generation

```dart
static List<GameLevel> _generateLevels() {
  final levels = <GameLevel>[];

  // World 1: First Flight
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: i,
      name: 'First Flight ${i}',
      worldName: 'First Flight',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: (5 + (i * 0.4)).round().clamp(5, 8),
        operations: {MathOperation.addition},
        speedMultiplier: 1.0,
      ),
      starsRequired: i > 1 ? 1 : 0,
    ));
  }

  // World 2: Thermal Currents
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 8 + i,
      name: 'Thermal Currents ${i}',
      worldName: 'Thermal Currents',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: 10,
        operations: {MathOperation.addition, MathOperation.subtraction},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 3: Firestorm
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 16 + i,
      name: 'Firestorm ${i}',
      worldName: 'Firestorm',
      params: DifficultyParams(
        numberMin: 2,
        numberMax: 10,
        operations: {
          MathOperation.addition,
          MathOperation.subtraction,
          MathOperation.multiplication,
        },
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 4: Inferno
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 24 + i,
      name: 'Inferno ${i}',
      worldName: 'Inferno',
      params: DifficultyParams(
        numberMin: 2,
        numberMax: 12,
        operations: {
          MathOperation.addition,
          MathOperation.subtraction,
          MathOperation.multiplication,
          MathOperation.division,
        },
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 5: Dragon Master
  for (int i = 1; i <= 8; i++) {
    levels.add(GameLevel(
      levelNumber: 32 + i,
      name: 'Dragon Master ${i}',
      worldName: 'Dragon Master',
      params: DifficultyParams(
        numberMin: 2,
        numberMax: 12,
        operations: {
          MathOperation.addition,
          MathOperation.subtraction,
          MathOperation.multiplication,
          MathOperation.division,
        },
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  return levels;
}
```

### Per-Level Speed Interpolation

Within each world, speed ramps linearly from the world's base to its max:

```dart
double speedForLevel(int worldNumber, int levelInWorld) {
  const worldSpeeds = [
    (base: 3.5, max: 4.5),   // World 1
    (base: 5.0, max: 6.0),   // World 2
    (base: 6.5, max: 8.0),   // World 3
    (base: 8.5, max: 10.0),  // World 4
    (base: 10.5, max: 12.0), // World 5
  ];

  final world = worldSpeeds[worldNumber - 1];
  final t = (levelInWorld - 1) / 7;  // 0.0 to 1.0
  return world.base + (world.max - world.base) * t;
}
```

---

## 16. Wrap Mode

Wrap mode is **disabled** for Worlds 1-4 and **enabled** for World 5 (Dragon Master).

### Without Wrap (Worlds 1-4)

Hitting a wall triggers a flame intensity penalty of **-20%** (same as a wrong answer)
and bounces the dragon back by one cell. The game continues unless flame reaches 0%.

```dart
GridPosition? nextPosition(GridPosition current, Direction dir) {
  int nx = current.x + dir.dx;
  int ny = current.y + dir.dy;

  if (wrap) {
    return GridPosition((nx + gridSize) % gridSize, (ny + gridSize) % gridSize);
  }

  if (nx < 0 || ny < 0 || nx >= gridSize || ny >= gridSize) {
    return null;  // wall collision
  }

  return GridPosition(nx, ny);
}
```

In the game's step handler:
```dart
if (newHead == null) {
  // Wall collision in no-wrap mode
  flameIntensity.onWrongAnswer();
  onFlameChanged(flameIntensity.value);
  if (!flameIntensity.isAlive) {
    _triggerGameOver();
  }
  // Don't move — stay in place this step
  dirLocked = false;
  return;
}
```

### With Wrap (World 5)

Going off one edge appears on the opposite side. No wall collision possible. This
adds a strategic element — the player can use wrap for shortcuts but must track
where they'll appear.

---

## 17. Visual Effects

### Correct Answer Celebration

When the correct gem is eaten, burst particles fly outward from the gem's position:

```dart
class GemSparkleEffect extends PositionComponent {
  static const int particleCount = 20;
  static const double lifetime = 0.6;  // seconds

  final List<_Particle> particles = [];

  @override
  void onLoad() {
    for (int i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 80 + random.nextDouble() * 160;
      particles.add(_Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        life: 0.4 + random.nextDouble() * 0.3,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 50 * dt;  // slight gravity
      p.t += dt;
    }
    particles.removeWhere((p) => p.t >= p.life);
    if (particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in particles) {
      final alpha = (1.0 - p.t / p.life).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(p.x, p.y),
        2.0,
        Paint()..color = const Color(0xFFFFD54A).withValues(alpha: alpha),
      );
    }
  }
}
```

### Wrong Answer Flash

Red tint overlay on the game area, fading over 400ms (matching the original):

```dart
class WrongAnswerFlash extends StatefulWidget {
  @override
  State<WrongAnswerFlash> createState() => _WrongAnswerFlashState();
}

class _WrongAnswerFlashState extends State<WrongAnswerFlash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void trigger() {
    _controller.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final opacity = (1.0 - _controller.value) * 0.35;
        return IgnorePointer(
          child: Container(
            color: Colors.red.withValues(alpha: opacity),
          ),
        );
      },
    );
  }
}
```

### Flame Color Progression (Visual Reward)

At higher levels, the dragon head and trail unlock new flame colors:

| World | Flame Color | Effect |
|-------|------------|--------|
| 1 | Orange | Standard fire |
| 2 | Orange-gold | Slightly warmer |
| 3 | Blue-tipped | Blue highlights on head and first trail segments |
| 4 | Blue | Full blue flame |
| 5 | White-prismatic | White core with rainbow shimmer |

This is a purely visual reward — it doesn't affect gameplay. The flame color is
determined by the highest world the player has reached, not the current level.

```dart
Color flameColorForWorld(int highestWorldReached) {
  switch (highestWorldReached) {
    case 1: return const Color(0xFFE74C3C);    // orange-red
    case 2: return const Color(0xFFF4A261);    // gold-orange
    case 3: return const Color(0xFF5DADE2);    // blue-tipped
    case 4: return const Color(0xFF3498DB);    // full blue
    case 5: return const Color(0xFFECF0F1);    // white-prismatic
    default: return const Color(0xFFE74C3C);
  }
}
```

---

## 18. Fact Tracking & Adaptive Selection

### Integration with FactTracker

On every gem eaten (correct or wrong), record the fact via the event bus:

```dart
void _recordAnswer(MathProblem problem, int eatenValue, bool isCorrect, int responseTimeMs) {
  final factKey = _buildFactKey(problem.left, problem.op, problem.right);

  eventBus.emit(AnswerGiven(
    gameId: 'fire_trail',
    problem: factKey,
    playerAnswer: '$eatenValue',
    correctAnswer: '${problem.answer}',
    correct: isCorrect,
    responseTimeMs: responseTimeMs,
  ));
}
```

### Response Time Tracking

For Fire Trail, response time is measured from when the new problem appears to when
any answer gem is eaten. This is a looser measurement than Dragon Eggs (where the
player actively constructs equations), because the player must also navigate to the
correct gem.

```dart
DateTime? _problemShownAt;

void _onNewProblem() {
  _problemShownAt = DateTime.now();
}

int _getResponseTimeMs() {
  if (_problemShownAt == null) return 0;
  return DateTime.now().difference(_problemShownAt!).inMilliseconds;
}
```

### Fact Key Format

Same normalization as Dragon Eggs:
- `"3+5"` (commutative: smaller first)
- `"8-3"` (non-commutative: left first)
- `"3x7"` (commutative: smaller first)
- `"12/3"` (non-commutative: dividend first)

---

## 19. Event Bus Integration

### Events Emitted

```dart
// On game start
eventBus.emit(GameStarted(gameId: 'fire_trail', levelNumber: currentLevel));

// On every answer (correct or wrong)
eventBus.emit(AnswerGiven(
  gameId: 'fire_trail',
  problem: factKey,
  playerAnswer: '$eatenValue',
  correctAnswer: '${problem.answer}',
  correct: isCorrect,
  responseTimeMs: responseTimeMs,
));

// On streak milestones (5, 10, 15, ...)
if (streak > 0 && streak % 5 == 0) {
  eventBus.emit(StreakAchieved(gameId: 'fire_trail', streakLength: streak));
}

// On level completion (enough correct answers)
eventBus.emit(LevelCompleted(
  gameId: 'fire_trail',
  levelNumber: currentLevel,
  score: totalScore,
  stars: calculateStars(),
  accuracy: correctCount / totalAttempts,
));

// On game end (game over or player quits)
eventBus.emit(GameEnded(
  gameId: 'fire_trail',
  finalScore: totalScore,
  duration: gameDuration,
));
```

---

## 20. Game Flow & State Machine

### Game Phases

```dart
enum GamePhase { countdown, playing, paused, levelComplete, gameOver }
```

### Flow

```
App Start
  |
  v
Hub -> Tap Fire Trail card
  |
  v
FireTrailScreen mounts (Flutter)
  |
  v
GameShell wraps, emits GameStarted
  |
  v
Countdown: 3 -> 2 -> 1 -> GO!
  |
  v
PLAYING LOOP:
  |
  +-- Dragon moves one cell per step (Hz-based timing)
  +-- Player changes direction via D-pad or swipe
  +-- If dragon eats correct gem:
  |     +10 score, +10% flame, streak++, sparkle effect
  |     new problem generated, gems re-placed
  |     trail shrinks if longer than initial (5)
  +-- If dragon eats wrong gem:
  |     -20% flame, red flash, combo reset
  |     trail grows by 2 segments
  |     gems re-placed (same problem)
  +-- If dragon hits wall (no-wrap): -20% flame, bounce
  +-- If dragon hits own trail: game over
  +-- If flame reaches 0%: game over
  +-- If correctCount >= levelTarget: level complete
  |
  v (on game over)
GamePhase.gameOver
  |
  +-- Stop movement
  +-- Emit GameEnded event
  +-- Calculate stars, scales
  |
  v
Show ResultScreen
  |
  +-- "Play Again" -> restart same level
  +-- "Next Level" (if level complete) -> advance
  +-- "Back to Hub" -> Navigator.pop
```

### Level Completion

Unlike Dragon Eggs (which is endless until game over), Fire Trail has level-based goals:
each level preloads the same number of answer gems the board previously displayed
(4-6 depending on level). The level completes when all preplaced gems are eaten,
unless wrong answers extinguish the flame first.

```dart
void _checkLevelComplete() {
  if (gemData.isEmpty) {
    phase = GamePhase.levelComplete;
    // Show result screen with option to advance to next level
  }
}
```

### Star Calculation

```dart
int calculateStars(double accuracy, int score, int levelNumber) {
  final scoreThresholdMedium = 60 + levelNumber * 8;
  final scoreThresholdHigh = 120 + levelNumber * 12;

  if (accuracy >= 0.9 && score >= scoreThresholdHigh) return 3;
  if (accuracy >= 0.75 && score >= scoreThresholdMedium) return 2;
  if (accuracy >= 0.6) return 1;
  return 0;
}
```

---

## 21. Game Over & Results

### Game Over Triggers

1. **Flame intensity reaches 0%** — too many wrong answers/wall hits
2. **Self-collision** — dragon head enters a trail segment
3. Player quits via pause menu (not counted as game over, just ends session)

### Handling Gem Eaten

```dart
void _handleGemEaten(AnswerGem gem) {
  final responseTimeMs = _getResponseTimeMs();
  final isCorrect = identical(gem.problem, problems.currentProblem);
  gemData.remove(gem);

  if (isCorrect) {
    // Correct answer
    score += _calculateScore();
    correctCount++;
    streak++;
    bestStreak = max(bestStreak, streak);
    flameIntensity.onCorrectAnswer();

    // Trail shrinks if longer than initial
    if (trail.length > 5) {
      trail.removeLast();
      trail.removeLast();  // remove 2 (net -1 since head moved forward)
    } else {
      trail.removeLast();  // normal: remove 1 (no net growth)
    }

    // Celebration effect
    add(GemSparkleEffect(position: gem.position.toPixel(cellSize)));

    // Advance to the next remaining preplaced answer
    problems.currentProblem = gemData.isEmpty ? null : gemData.first.problem;

    // Check level completion
    _checkLevelComplete();

    // Check streak milestone
    if (streak > 0 && streak % 5 == 0) {
      eventBus.emit(StreakAchieved(gameId: 'fire_trail', streakLength: streak));
    }
  } else {
    // Wrong answer
    wrongCount++;
    streak = 0;
    flameIntensity.onWrongAnswer();

    // Trail grows by 2 (penalizing — more self-collision risk)
    trailManager.pendingGrowth += 2;

    // Red flash
    onWrongFlash();

    // Check game over
    if (!flameIntensity.isAlive) {
      _triggerGameOver();
      return;
    }
  }

  // Record in FactTracker
  _recordAnswer(gem.problem, gem.value, isCorrect, responseTimeMs);

  // Update UI
  onFlameChanged(flameIntensity.value);
  onScoreChanged(score);
}
```

### Trail Growth Manager

```dart
class TrailManager {
  final int initialLength;
  int pendingGrowth = 0;

  TrailManager({required this.initialLength});

  /// Called on a normal step (no gem eaten). Handles tail removal or growth.
  void handleNormalStep(List<GridPosition> trail) {
    if (pendingGrowth > 0) {
      pendingGrowth--;
      // Don't remove tail — trail grows by 1
    } else {
      trail.removeLast();
    }
  }
}
```

### Result Screen Integration

```dart
void _onGameOver() {
  eventBus.emit(GameEnded(
    gameId: 'fire_trail',
    finalScore: score,
    duration: gameDuration,
  ));

  final results = GameResults(
    gameId: 'fire_trail',
    score: score,
    accuracy: totalAttempts > 0 ? correctCount / totalAttempts : 0,
    streak: bestStreak,
    scalesEarned: scalesThisRound,
    stars: calculateStars(...),
    levelNumber: currentLevel,
    problemsAttempted: totalAttempts,
    problemsCorrect: correctCount,
  );

  showResultScreen(results);
}
```

---

## 22. HUD Elements

### Problem Display (Flutter Overlay)

Positioned prominently above the game grid:

```dart
class ProblemDisplay extends StatelessWidget {
  final String problemText;  // "7 x 8"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F3D).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.dragonGold.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        problemText,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0E6D3),
          letterSpacing: 2,
        ),
      ),
    );
  }
}
```

### Score & Streak Display

```dart
class ScoreStreakDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int levelNumber;
  final String worldName;

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
                color: DragonColors.fireOrange, size: 18),
            Text(
              'x$streak',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DragonColors.fireOrange,
              ),
            ),
          ]),

        // Level indicator
        Text(
          '$worldName L${levelNumber}',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: const Color(0xFFA89DB8),
          ),
        ),
      ],
    );
  }
}
```

### Countdown Overlay

Before the game starts, a 3-2-1-GO countdown displays over the grid:

```dart
class CountdownOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() => _count = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: Text(
          '$_count',
          style: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
```

---

## 23. Localization Updates

### Add to `lib/l10n/app_en.arb`

```json
{
  "fireTrailTitle": "Fire Trail",
  "@fireTrailTitle": { "description": "Game title" },

  "flameIntensity": "Flame: {percent}%",
  "@flameIntensity": {
    "description": "Flame intensity meter label",
    "placeholders": { "percent": { "type": "int" } }
  },

  "flameDanger": "Flame fading!",
  "@flameDanger": { "description": "Warning when flame intensity is critically low" },

  "flameExtinguished": "Flame extinguished!",
  "@flameExtinguished": { "description": "Game over message when flame reaches 0" },

  "selfCollision": "You hit your own trail!",
  "@selfCollision": { "description": "Game over message on self-collision" },

  "wallHit": "Ouch! The wall burns!",
  "@wallHit": { "description": "Feedback on wall collision" },

  "correctGem": "Correct!",
  "@correctGem": { "description": "Feedback when correct answer gem is eaten" },

  "wrongGem": "Not quite!",
  "@wrongGem": { "description": "Feedback when wrong answer gem is eaten" },

  "firstFlight": "First Flight",
  "@firstFlight": { "description": "Fire Trail World 1 name" },

  "thermalCurrents": "Thermal Currents",
  "@thermalCurrents": { "description": "Fire Trail World 2 name" },

  "firestorm": "Firestorm",
  "@firestorm": { "description": "Fire Trail World 3 name" },

  "inferno": "Inferno",
  "@inferno": { "description": "Fire Trail World 4 name" },

  "dragonMaster": "Dragon Master",
  "@dragonMaster": { "description": "Fire Trail World 5 name" },

  "countdownGo": "GO!",
  "@countdownGo": { "description": "Countdown completion text" },

  "wrapModeActive": "Wrap Mode Active",
  "@wrapModeActive": { "description": "Indicator that wrap mode is on" },

  "correctToAdvance": "{count} more to clear this level",
  "@correctToAdvance": {
    "description": "Remaining correct answers needed to complete level",
    "placeholders": { "count": { "type": "int" } }
  },

  "levelCleared": "Level Cleared!",
  "@levelCleared": { "description": "Shown when level target is reached" }
}
```

---

## 24. Unit Tests

### Test Files

```
test/
+-- games/
    +-- fire_trail/
        +-- movement_test.dart
        +-- flame_intensity_test.dart
        +-- problem_manager_test.dart
        +-- gem_placement_test.dart
        +-- trail_manager_test.dart
        +-- difficulty_config_test.dart
        +-- direction_test.dart
```

### `test/games/fire_trail/movement_test.dart`

```dart
// Test cases:
// 1. Moving right from (5,5) → (6,5)
// 2. Moving left from (5,5) → (4,5)
// 3. Moving up from (5,5) → (5,4)
// 4. Moving down from (5,5) → (5,6)
// 5. Wall collision (no wrap): right from (14,5) → null (grid=15)
// 6. Wall collision (no wrap): left from (0,5) → null
// 7. Wall collision (no wrap): up from (5,0) → null
// 8. Wall collision (no wrap): down from (5,14) → null
// 9. Wrap mode: right from (14,5) → (0,5)
// 10. Wrap mode: left from (0,5) → (14,5)
// 11. Wrap mode: up from (5,0) → (5,14)
// 12. Wrap mode: down from (5,14) → (5,0)
```

### `test/games/fire_trail/flame_intensity_test.dart`

```dart
// Test cases:
// 1. Initial intensity is 1.0 (100%)
// 2. onWrongAnswer reduces by 0.20 → 0.80
// 3. onCorrectAnswer increases by 0.10 → 1.0 (stays at 1.0 from initial)
// 4. After 3 wrong answers: 0.40
// 5. After 5 wrong answers: 0.0 → isAlive is false
// 6. Cannot go below 0.0 (clamped)
// 7. Cannot go above 1.0 (clamped)
// 8. Recovery: 2 wrong (0.6) + 1 correct (0.7) + 1 wrong (0.5)
// 9. reset() returns to 1.0
// 10. Flame color is danger red when <= 0.2
// 11. Flame color is bright when >= 0.7
```

### `test/games/fire_trail/problem_manager_test.dart`

```dart
// Test cases:
// 1. Generated addition problem has correct answer
// 2. Generated subtraction: left >= right (no negative results)
// 3. Generated multiplication has correct answer
// 4. Generated division: answer is integer (no remainder)
// 5. Division: divisor is never 0 or 1
// 6. Problem text format: "a op b" without answer
// 7. Respects numberMin/numberMax constraints
// 8. Only uses allowed operations
// 9. When only addition is allowed, all problems are addition
// 10. When all 4 ops allowed, all 4 types can appear
```

### `test/games/fire_trail/gem_placement_test.dart`

```dart
// Test cases:
// 1. Always produces exactly 1 correct gem
// 2. Produces the requested number of distractors
// 3. No gems placed on dragon head position
// 4. No gems placed on trail positions
// 5. No duplicate values among gems
// 6. Correct gem value matches problem answer
// 7. Distractor values are not equal to correct answer
// 8. All gem positions are within grid bounds
// 9. No two gems share the same position
// 10. Distractors are plausible (within reasonable range of answer)
```

### `test/games/fire_trail/trail_manager_test.dart`

```dart
// Test cases:
// 1. Normal step with no pending growth: trail shrinks by 1
// 2. Normal step with pending growth: trail stays same (growth consumes one)
// 3. After 2 pending growth: trail grows by 2 over 2 steps
// 4. Trail never goes below 0 length
// 5. Multiple pending growths stack correctly
```

### `test/games/fire_trail/direction_test.dart`

```dart
// Test cases:
// 1. right.isOpposite(left) → true
// 2. left.isOpposite(right) → true
// 3. up.isOpposite(down) → true
// 4. down.isOpposite(up) → true
// 5. right.isOpposite(up) → false
// 6. right.isOpposite(right) → false
// 7. Direction.right.dx == 1, dy == 0
// 8. Direction.up.dx == 0, dy == -1
```

---

## 25. Verification Checklist

After completing this step, verify:

### Gameplay

- [ ] **Dragon moves** — steps one cell per tick at the configured speed
- [ ] **Flame trail renders** — fire gradient from head (bright) to tail (dim)
- [ ] **Flame trail follows** — each head position becomes a trail segment
- [ ] **Direction input** — D-pad buttons change direction immediately
- [ ] **Swipe input** — swiping on the game area changes direction
- [ ] **Direction locking** — cannot 180-reverse, only one change per step
- [ ] **Problem displays** — current problem shown prominently (e.g., "7 x 8")
- [ ] **Gems visible** — correct + distractor gems placed on grid with numbers
- [ ] **All gems look the same** — player can't distinguish correct by color
- [ ] **Correct gem eaten** — sparkle effect, score increase, new problem, streak++
- [ ] **Wrong gem eaten** — red flash, flame drops 20%, streak resets, trail grows
- [ ] **Correct gem restores** — flame increases 10% (capped at 100%)
- [ ] **Self-collision** — hitting own trail = game over
- [ ] **Wall collision (no-wrap)** — flame drops 20%, dragon stays in place
- [ ] **Wrap mode (World 5)** — going off edge wraps to opposite side
- [ ] **Speed increases** — World 1 is slow, World 5 is fast
- [ ] **Countdown** — 3-2-1-GO before game starts
- [ ] **Pause** — pausing stops movement and hides gem values
- [ ] **Level completion** — reaching correct answer target completes the level

### Integration

- [ ] **Hub card** — Fire Trail card on hub navigates to the game
- [ ] **GameShell wraps** — pause overlay works (Resume/Settings/Quit)
- [ ] **Result screen** — appears on game over / level complete with correct stats
- [ ] **Play Again** — restarts the game
- [ ] **Next Level** — available on level complete, advances to next level
- [ ] **Back to Hub** — returns to hub cleanly
- [ ] **Event bus** — emits GameStarted, AnswerGiven, StreakAchieved, LevelCompleted, GameEnded
- [ ] **FactTracker** — records every attempt with timing data
- [ ] **RewardService** — awards scales for correct answers and streaks
- [ ] **Profile updates** — totalScales, totalCorrectAnswers, gameStats change

### Technical

- [ ] **`flutter analyze`** — passes clean
- [ ] **`flutter test`** — all tests pass (existing + new)
- [ ] **`flutter build apk --debug`** — succeeds
- [ ] **Performance** — smooth 60fps on emulator, no frame drops at high speeds
- [ ] **No memory leaks** — effects and old trail segments are properly cleaned up
- [ ] **All strings localized** — no hardcoded English text

### Fun Factor

- [ ] **Controls feel tight** — D-pad is responsive, no accidental inputs
- [ ] **Speed feels right** — World 1 is relaxed, World 5 is intense but not unfair
- [ ] **Flame mechanic creates tension** — wrong answers sting, recovery is possible
- [ ] **Trail looks cool** — fire gradient is visually appealing
- [ ] **Correct answers feel rewarding** — sparkle effect + score + flame recovery
- [ ] **Sessions are short** — a round lasts 2-5 minutes naturally
- [ ] **"Just one more" urge** — the game makes you want to play again

### Quick Smoke Test

```bash
cd math_dragons
set PATH=%USERPROFILE%\scoop\apps\flutter\current\bin;%PATH%
flutter analyze
flutter test
flutter build apk --debug
```

### Full Play Test

```
1. Hub -> tap Fire Trail -> countdown 3-2-1-GO -> game starts
2. Dragon moves right automatically, tap D-pad down -> dragon turns down
3. Navigate to a gem showing the correct answer -> eat it
4. Verify: sparkle effect, score +10, streak shows "x1", new problem appears
5. Get 3 correct in a row -> verify streak shows "x3"
6. Deliberately eat a wrong gem -> verify red flash, flame drops to 80%, streak resets
7. Eat 4 more wrong gems -> verify game over at 0% flame
8. Result screen -> verify score, accuracy, streak are correct
9. Tap "Play Again" -> verify game restarts with countdown
10. Complete a level (enough correct answers) -> verify "Level Cleared!" result
11. Tap "Next Level" -> verify advance to next level with harder settings
12. Tap "Back to Hub" -> verify clean return to hub
13. Pause mid-game -> verify gem values are hidden, movement stops
14. Resume -> verify values reappear, movement continues
15. Test swipe controls -> verify they change direction correctly
16. At World 5, verify wrap mode: go off right edge -> appear on left
```

---

## Files Modified in This Step

| File | Action | Description |
|------|--------|-------------|
| `lib/games/fire_trail/fire_trail_game.dart` | **Replace** | Full game screen wrapping FlameGame |
| `lib/games/fire_trail/fire_trail_flame_game.dart` | **Create** | Flame FlameGame subclass |
| `lib/games/fire_trail/fire_trail_registration.dart` | **Create** | MathDragonsGame implementation |
| `lib/games/fire_trail/components/grid_renderer.dart` | **Create** | Grid background rendering |
| `lib/games/fire_trail/components/dragon_head.dart` | **Create** | Dragon head component |
| `lib/games/fire_trail/components/trail_segment.dart` | **Create** | Flame trail segment |
| `lib/games/fire_trail/components/answer_gem.dart` | **Create** | Answer tile gem component |
| `lib/games/fire_trail/components/gem_sparkle_effect.dart` | **Create** | Correct-answer particle effect |
| `lib/games/fire_trail/systems/movement_system.dart` | **Create** | Step-based movement + collision |
| `lib/games/fire_trail/systems/problem_manager.dart` | **Create** | Problem generation + answer placement |
| `lib/games/fire_trail/systems/trail_manager.dart` | **Create** | Trail growth/shrink management |
| `lib/games/fire_trail/models/grid_position.dart` | **Create** | Grid coordinate model |
| `lib/games/fire_trail/models/fire_trail_config.dart` | **Create** | Per-level difficulty configuration |
| `lib/games/fire_trail/models/flame_intensity.dart` | **Create** | Flame intensity state |
| `lib/games/fire_trail/widgets/problem_display.dart` | **Create** | Flutter overlay for current problem |
| `lib/games/fire_trail/widgets/flame_meter.dart` | **Create** | Flame intensity bar HUD |
| `lib/games/fire_trail/widgets/dpad_controls.dart` | **Create** | Touch D-pad + swipe handler |
| `lib/games/fire_trail/widgets/score_streak_display.dart` | **Create** | Score and streak HUD |
| `lib/games/fire_trail/widgets/countdown_overlay.dart` | **Create** | 3-2-1-GO countdown |
| `lib/app.dart` | **Modify** | Register FireTrail game |
| `lib/l10n/app_en.arb` | **Modify** | Add Fire Trail strings |

---

## What This Step Does NOT Include

These are explicitly out of scope for Step 5:

- **Real sprite art** — Step 12 (using custom-painted shapes for v1)
- **Sound effects** — Step 12 (no audio in v1 games)
- **Dragon roar/fire breathing animations** — Step 12
- **Adaptive problem selection algorithm** — Step 8 (using random selection within
  level params for now)
- **Level select screen** — Step 8
- **Achievement checking** — Step 9
- **Daily challenge integration** — Step 9
- **Cloud sync** — Step 10

Step 5 delivers the second fully playable game. The focus is on **tight controls and
satisfying movement**. The D-pad must be responsive. The flame mechanic must create
tension without frustration. Speed progression must feel natural. Prioritize gameplay
feel over visual polish — the polish comes in Steps 8, 9, and 12.

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
