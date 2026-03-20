# Step 4: Game Port — Dragon Eggs (Bubble Pop)

> **Goal:** Port the HTML5 Bubble Pop game to Flutter/Flame as "Dragon Eggs" — the first
> fully playable game in Math Dragons. This is the most physics-heavy game and serves as
> the proof-of-concept for the Flame engine integration. The game must be genuinely fun,
> with satisfying egg physics, a clear equation-building mechanic, adaptive fact selection,
> and full integration with the app's event bus, reward system, and fact tracker.
>
> **Estimated effort:** Single session (largest step so far)
>
> **Prerequisite:** Step 3 complete. Hub screen polished with game cards, game shell with
> pause overlay, result screen with animations. `flutter analyze` clean. `flutter test`
> green. `flutter build apk --debug` succeeds.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [Original Game Mechanics Reference](#4-original-game-mechanics-reference)
5. [File Structure](#5-file-structure)
6. [MathDragonsGame Implementation](#6-mathdragonsgame-implementation)
7. [Flame Game Setup](#7-flame-game-setup)
8. [Physics Engine](#8-physics-engine)
9. [Egg Components](#9-egg-components)
10. [Egg Spawning System](#10-egg-spawning-system)
11. [Equation Building State Machine](#11-equation-building-state-machine)
12. [Equation Validation](#12-equation-validation)
13. [Combo System](#13-combo-system)
14. [Scoring System](#14-scoring-system)
15. [Difficulty Tiers & World Progression](#15-difficulty-tiers--world-progression)
16. [Division Support](#16-division-support)
17. [Fact Tracking & Adaptive Selection](#17-fact-tracking--adaptive-selection)
18. [Event Bus Integration](#18-event-bus-integration)
19. [Game Flow & State Machine](#19-game-flow--state-machine)
20. [Visual Design & Rendering](#20-visual-design--rendering)
21. [Touch Interaction](#21-touch-interaction)
22. [Game Over & Results](#22-game-over--results)
23. [HUD & Equation Display](#23-hud--equation-display)
24. [Math Problem Generation](#24-math-problem-generation)
25. [Localization Updates](#25-localization-updates)
26. [Unit Tests](#26-unit-tests)
27. [Verification Checklist](#27-verification-checklist)

---

## 1. User Stories

### US-4.1: Play Dragon Eggs
**As a** player,
**I want** to tap falling dragon eggs to build math equations,
**so that** I can practice arithmetic in a fun, physics-based game.

### US-4.2: Satisfying Physics
**As a** player,
**I want** eggs to fall with realistic gravity, bounce off walls and each other, and settle naturally,
**so that** the game feels physical and satisfying to interact with.

### US-4.3: Equation Building
**As a** player,
**I want** to tap 4 eggs in sequence (number, operator, number, then answer) to form equations,
**so that** I'm actively constructing math rather than just picking answers.

### US-4.4: Combo Rewards
**As a** player,
**I want** consecutive correct equations to build a combo multiplier,
**so that** I'm rewarded for sustained accuracy with more points and scales.

### US-4.5: Adaptive Difficulty
**As a** player,
**I want** the game to automatically introduce harder math as I improve,
**so that** the challenge grows with me and I'm always learning.

### US-4.6: Division at Higher Levels
**As a** player,
**I want** division problems to appear at higher difficulty levels (World 4+),
**so that** I can practice all four operations as I advance.

### US-4.7: Earn Scales
**As a** player,
**I want** to earn Dragon Scales for correct answers, streaks, and level completion,
**so that** my Dragon Eggs sessions contribute to my overall progression.

### US-4.8: See My Results
**As a** player,
**I want** a results screen after each round showing my score, accuracy, streak, and scales earned,
**so that** every session ends with a satisfying summary.

---

## 2. Acceptance Criteria

- [ ] Dragon Eggs is fully playable from the hub screen
- [ ] Eggs fall with gravity, bounce off walls and floor, collide with each other, and settle
- [ ] Tapping 4 eggs builds an equation: `number op number = answer`
- [ ] Correct equations pop the eggs with a satisfying animation
- [ ] Wrong equations show error feedback and penalize the player
- [ ] Combo counter increments on consecutive correct answers
- [ ] Combo resets to 0 on a wrong answer
- [ ] 6 difficulty tiers auto-level every 10 correct answers
- [ ] Division eggs appear at World 4+ (level 31+) with integer results only
- [ ] Division eggs are visually distinct (purple tint)
- [ ] Game over triggers when eggs stack above the danger line
- [ ] Result screen shows score, accuracy, best streak, stars, and scales earned
- [ ] "Play Again" and "Back to Hub" buttons work correctly
- [ ] Event bus emits: `GameStarted`, `AnswerGiven`, `StreakAchieved`, `LevelCompleted`, `GameEnded`
- [ ] FactTracker records every equation attempt with timing data
- [ ] RewardService awards scales based on correct answers, streaks, and completion
- [ ] Pause overlay pauses physics and hides egg values
- [ ] Game registers with `GameRegistry` and appears correctly on the hub
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] Game is genuinely fun to play

---

## 3. Architecture Overview

### How Flame Integrates with Flutter

Dragon Eggs uses Flame's `FlameGame` embedded in a Flutter widget via `GameWidget`.
The game shell wraps the Flame game; Flutter handles the HUD, pause overlay, and
result screen, while Flame handles the game loop, physics, and rendering.

```
┌──────────────────────────────────────────────────────┐
│                   GameShell (Flutter)                   │
│  ┌──────────────────────────────────────────────────┐  │
│  │  HUD Bar: Pause | Title | Scales                 │  │
│  ├──────────────────────────────────────────────────┤  │
│  │                                                    │  │
│  │  ┌────────────────────────────────────────────┐   │  │
│  │  │         Equation Display (Flutter)          │   │  │
│  │  │         "3 + ? = ?"                         │   │  │
│  │  ├────────────────────────────────────────────┤   │  │
│  │  │                                              │   │  │
│  │  │        FlameGame (GameWidget)                │   │  │
│  │  │   ┌──────────────────────────────────┐      │   │  │
│  │  │   │  Danger Line ──────────────────  │      │   │  │
│  │  │   │                                    │      │   │  │
│  │  │   │    (o) 7    (o) +    (o) 3        │      │   │  │
│  │  │   │        (o) 5                       │      │   │  │
│  │  │   │   (o) 2    (o) ×    (o) 10        │      │   │  │
│  │  │   │      (o) 8     (o) 4    (o) -     │      │   │  │
│  │  │   │  (o) 1   (o) 6   (o) 9   (o) 12  │      │   │  │
│  │  │   └──────────────────────────────────┘      │   │  │
│  │  │                                              │   │  │
│  │  └────────────────────────────────────────────┘   │  │
│  │                                                    │  │
│  │  ┌────────────────────────────────────────────┐   │  │
│  │  │    Score: 1,250    Combo: x3    🔥 Streak  │   │  │
│  │  └────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  [Pause Overlay — shown when paused]                    │
│  [Result Screen — shown on game over/level complete]    │
└──────────────────────────────────────────────────────┘
```

### Key Design Decisions

1. **Flame for physics and rendering.** Eggs are Flame `PositionComponent`s with
   custom physics. The game loop handles gravity, collision, and rendering.

2. **Flutter for UI overlays.** The equation display, score/combo indicators, and
   feedback toasts are Flutter widgets overlaid on the Flame game. This avoids
   reimplementing text layout and animation in Flame.

3. **Communication via callbacks.** The Flame game exposes callbacks that the
   wrapping Flutter widget listens to (e.g., `onEquationResult`, `onGameOver`,
   `onScoreChanged`). The Flutter widget then emits events to the EventBus.

4. **Custom painting over sprites.** For v1, eggs are custom-painted circles with
   gradient fills and text overlays. Real sprite assets come in Step 12.

---

## 4. Original Game Mechanics Reference

The original Bubble Pop (`BubblePop/bubble-pop.html`) is a DOM-based HTML5 game.
Key constants and mechanics to port:

### Physics Constants (from original)

| Constant | Original Value | Flame Equivalent | Notes |
|----------|---------------|------------------|-------|
| `GRAVITY` | 550 px/s² | 550 (scale to game units) | Base gravitational acceleration |
| `RESTITUTION` | 0.25 | 0.25 | Bounce retention on walls/floor |
| `DAMPING` | 0.45 | 0.45 | Collision impulse factor |
| `FRICTION` | 0.96 | 0.96 | Per-frame velocity decay (at 60fps) |
| `SETTLE_VEL` | 8 px/s | 8 | Below this, bubble is "settled" |
| `MAX_VELOCITY` | 400 px/s | 400 | Terminal velocity cap |
| `BUBBLE_BASE_SIZE` | 64 px | Scale to screen | Base egg diameter |
| `BUBBLE_SIZE_VARIANCE` | 0.1 (±10%) | 0.1 | Random size variation |
| `MIN_TOUCH_SIZE` | 44 px | 44 dp | Accessibility minimum |
| `TOP_BOUNDARY` | 105 px | Scale to screen | Danger line position |
| `OP_SPAWN_CHANCE` | 0.35 | 0.35 | Chance of operator spawn |
| `MAX_OP_BUBBLES` | 8 | 8 | Max operators on screen |

### Equation Building (from original)

5-step state machine:
1. Step 0: Tap a number egg (left operand)
2. Step 1: Tap an operator egg
3. Step 2: Tap a number egg (right operand)
4. Step 3: Press the equals button (UI button, not an egg)
5. Step 4: Tap a number egg (answer) → auto-evaluates

### Key Behaviors to Preserve

- **Deselection:** Tapping a selected egg deselects it and everything after it
- **Empty tap:** Tapping empty space deselects all
- **Focus fact:** 30% of spawned numbers are components of the current focus fact
- **Solvability guarantee:** Game checks every frame that at least one valid equation
  can be formed; spawns missing pieces if not
- **Penalty spawning:** Wrong answers double spawn rate for 2 seconds
- **Pause hides values:** Anti-cheat: egg values are hidden during pause
- **Settled eggs skip physics:** Performance optimization
- **4-pass collision resolution:** Stability for tight packing

---

## 5. File Structure

### New Files

```
lib/games/
├── dragon_eggs/
│   ├── dragon_eggs_game.dart          ← Flutter widget wrapping the Flame game
│   ├── dragon_eggs_flame_game.dart    ← Flame FlameGame subclass
│   ├── dragon_eggs_registration.dart  ← MathDragonsGame implementation
│   ├── components/
│   │   ├── egg_component.dart         ← Individual egg (Flame PositionComponent)
│   │   ├── danger_line.dart           ← Visual danger line at top
│   │   └── egg_pop_effect.dart        ← Pop/sparkle particle effect
│   ├── systems/
│   │   ├── egg_physics.dart           ← Gravity, collision, bounce, settling
│   │   ├── egg_spawner.dart           ← Spawn timing, type selection, positioning
│   │   ├── equation_builder.dart      ← 5-step equation state machine
│   │   └── solvability_checker.dart   ← Ensures valid equations exist on screen
│   ├── models/
│   │   ├── egg_data.dart              ← Egg type, value, state enums
│   │   ├── difficulty_config.dart     ← 6 difficulty tier definitions
│   │   └── equation.dart              ← Equation data model + validation
│   └── widgets/
│       ├── equation_display.dart      ← Flutter overlay showing equation being built
│       ├── score_display.dart         ← Score, combo, streak display
│       └── feedback_overlay.dart      ← Correct/wrong feedback toast
├── shared/
│   ├── math_problem.dart              ← Shared math fact generation utilities
│   └── ...
```

### Modified Files

| File | Change |
|------|--------|
| `lib/games/dragon_eggs/dragon_eggs_game.dart` | **Replace** placeholder with real game |
| `lib/games/shared/math_problem.dart` | **Replace** stub with math generation utilities |
| `lib/core/game_registry.dart` | Register DragonEggs on app startup |
| `lib/app.dart` | Import and register DragonEggs game |
| `lib/l10n/app_en.arb` | Add Dragon Eggs localization strings |

---

## 6. MathDragonsGame Implementation

### `lib/games/dragon_eggs/dragon_eggs_registration.dart`

This class implements the `MathDragonsGame` interface so Dragon Eggs integrates
with the game registry, hub screen, and reward system.

```dart
import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragon_eggs_game.dart';

class DragonEggsRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragon_eggs';

  @override
  String get displayName => 'Dragon Eggs';

  @override
  String get description => 'Hatch dragon eggs with math equations';

  @override
  String get iconAsset => 'assets/images/games/dragon_eggs/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragon_eggs/env.png';

  @override
  Color get accentColor => DragonColors.dragonEggsAccent;

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
    levelCompletionBonus: 15,
    threeStarBonus: 15,
  );

  @override
  List<MathSkill> get mathSkills => [
    MathSkill.addition,
    MathSkill.subtraction,
    MathSkill.multiplication,
    MathSkill.division,
    MathSkill.equationBuilding,
  ];

  @override
  Widget buildGame(GameContext context) {
    return DragonEggsScreen(context: context);
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
    minAccuracyForAdvance: 0.6,
    minProblemsPerLevel: 10,
  );

  /// Generate all levels across 5 worlds.
  /// See section 15 for the full world/level breakdown.
  static List<GameLevel> _generateLevels() {
    // Implementation in section 15
    return [];
  }
}
```

### Registration in `main.dart` or `app.dart`

```dart
// In app.dart initState or main.dart:
final registry = GameRegistry(storage);
registry.register(DragonEggsRegistration());
```

---

## 7. Flame Game Setup

### `lib/games/dragon_eggs/dragon_eggs_flame_game.dart`

The core Flame game class. Manages the game loop, holds all egg components,
and coordinates the physics and spawning systems.

```dart
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DragonEggsFlameGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  // ── Configuration ──
  final int startingLevel;
  final void Function(EggTapResult) onEggTapped;
  final void Function() onGameOver;
  final void Function(int score, int combo) onScoreChanged;
  final void Function(bool isPaused) onPauseChanged;

  // ── Systems ──
  late EggPhysics physics;
  late EggSpawner spawner;
  late SolvabilityChecker solvabilityChecker;

  // ── State ──
  List<EggComponent> eggs = [];
  bool isPaused = false;
  bool isGameOver = false;
  double dangerLineY = 0;
  double fieldWidth = 0;
  double fieldHeight = 0;

  // ── Difficulty ──
  int currentLevel = 1;
  DifficultyTier currentTier;

  DragonEggsFlameGame({
    required this.startingLevel,
    required this.onEggTapped,
    required this.onGameOver,
    required this.onScoreChanged,
    required this.onPauseChanged,
  }) : currentLevel = startingLevel,
       currentTier = DifficultyTier.forLevel(startingLevel);

  @override
  Future<void> onLoad() async {
    // Calculate field dimensions from game size
    fieldWidth = size.x;
    fieldHeight = size.y;
    dangerLineY = fieldHeight * 0.12; // ~12% from top for danger line

    // Initialize systems
    physics = EggPhysics(
      fieldWidth: fieldWidth,
      fieldHeight: fieldHeight,
    );
    spawner = EggSpawner(
      fieldWidth: fieldWidth,
      dangerLineY: dangerLineY,
      tier: currentTier,
    );
    solvabilityChecker = SolvabilityChecker();

    // Add danger line visual
    add(DangerLine(y: dangerLineY, width: fieldWidth));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPaused || isGameOver) return;

    // Cap delta time to prevent physics explosions
    final cappedDt = dt.clamp(0.0, 0.05);

    // Update physics for all eggs
    physics.update(eggs, cappedDt, currentTier.gravityMultiplier);

    // Spawn new eggs on schedule
    spawner.update(cappedDt, eggs, (egg) {
      eggs.add(egg);
      add(egg);
    });

    // Check solvability — ensure at least one valid equation exists
    solvabilityChecker.check(eggs, spawner, currentTier);

    // Check game over — any entered egg above danger line
    _checkGameOver();
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

  // ... tap handling, egg removal, level advancement
}
```

### Embedding in Flutter

```dart
// In dragon_eggs_game.dart (the Flutter widget):
GameWidget(
  game: _flameGame,
  overlayBuilderMap: {
    'equation': (context, game) => EquationDisplay(...),
    'score': (context, game) => ScoreDisplay(...),
    'feedback': (context, game) => FeedbackOverlay(...),
  },
  initialActiveOverlays: const ['equation', 'score'],
)
```

---

## 8. Physics Engine

### `lib/games/dragon_eggs/systems/egg_physics.dart`

Port the original physics directly. The original game loop is well-tuned; preserve
the constants and behavior.

### Constants

```dart
class EggPhysicsConstants {
  static const double gravity = 550.0;         // px/s² base
  static const double restitution = 0.25;      // bounce retention
  static const double damping = 0.45;          // collision impulse factor
  static const double friction = 0.96;         // velocity decay per frame @60fps
  static const double settleVelocity = 8.0;    // below this = settled
  static const double maxVelocity = 400.0;     // terminal velocity cap
  static const int collisionPasses = 4;        // stability passes per frame
  static const double wakeOverlap = 1.5;       // px overlap to wake settled egg
}
```

### Per-Frame Update

For each active (non-selected, non-settled) egg:

```
1. Apply gravity:  vy += GRAVITY * gravityMultiplier * dt
2. Cap velocity:   if (speed > MAX_VELOCITY) scale both vx, vy down
3. Integrate:      x += vx * dt,  y += vy * dt
4. Apply friction: vx *= pow(FRICTION, dt * 60)  (framerate-independent)
                   vy *= pow(FRICTION, dt * 60)
5. Selected eggs:  freeze (vx = 0, vy = 0), skip physics
6. Settled eggs:   skip physics until woken by collision
```

### Collision Resolution

Run **4 passes** per frame for positional stability:

**Floor collision (pass-dependent):**
```dart
if (egg.y + egg.radius > fieldHeight) {
  egg.y = fieldHeight - egg.radius;  // snap
  if (pass == 0) {
    if (egg.vy.abs() > settleVelocity) {
      egg.vy = -egg.vy * restitution;  // bounce
    } else {
      egg.vy = 0;  // settle
    }
  }
}
```

**Wall collisions:** Same pattern for left (`x - radius < 0`) and right
(`x + radius > fieldWidth`) walls.

**Egg-egg collision:**
```dart
for each pair (a, b):
  dist = distance(a, b)
  overlap = (a.radius + b.radius) - dist
  if (overlap > 0):
    // Positional separation (every pass)
    normal = normalize(b.pos - a.pos)
    if (one is selected): push only the unselected by full overlap
    if (neither selected): push each by half overlap
    if (both selected): no push

    // Velocity impulse (pass 0 only)
    if (pass == 0):
      relVel = dot(a.vel - b.vel, normal)
      if (relVel > 0):  // approaching
        impulse = relVel * damping
        apply -impulse * normal to unselected eggs

    // Wake settled eggs if overlap > 1.5
    if (overlap > wakeOverlap):
      wake any settled eggs involved
```

### Settling

After collision resolution, check each active egg:
```dart
bool onFloor = (egg.y + egg.radius >= fieldHeight - 1);
bool lowVel = (egg.vy.abs() < settleVelocity && egg.vx.abs() < settleVelocity);
if (onFloor && lowVel) {
  egg.settled = true;
  egg.vx = 0;
  egg.vy = 0;
  egg.y = fieldHeight - egg.radius;  // snap
}
```

### Coordinate System

Flame uses top-left origin with Y increasing downward — same as the original HTML
game. No coordinate transformation needed.

---

## 9. Egg Components

### `lib/games/dragon_eggs/components/egg_component.dart`

Each egg is a Flame `PositionComponent` with custom rendering.

### Egg Data Model

```dart
/// Types of eggs.
enum EggType { number, operator }

/// Visual/physics state of an egg.
enum EggState { active, selected, popping, dead }

/// Operator symbols.
enum MathOp {
  add,       // +
  subtract,  // −
  multiply,  // ×
  divide,    // ÷
}
```

### EggComponent Properties

```dart
class EggComponent extends PositionComponent with TapCallbacks {
  final EggType type;
  final dynamic value;         // int for numbers, MathOp for operators
  final double radius;
  final Color baseColor;

  double vx = 0;
  double vy = 0;
  EggState state = EggState.active;
  bool settled = false;
  bool hasEnteredField = false;  // true once center passes below danger line

  // Selection order index (0-3 in equation)
  int? selectionIndex;
}
```

### Rendering (Custom Paint)

For v1, eggs are rendered with `Canvas` operations, not sprites:

```dart
@override
void render(Canvas canvas) {
  // 1. Draw egg shape (circle with slight oval for egg feel)
  final paint = Paint()
    ..shader = RadialGradient(
      colors: [baseColor.withValues(alpha: 0.9), baseColor.withValues(alpha: 0.6)],
      stops: [0.3, 1.0],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  canvas.drawCircle(Offset.zero, radius, paint);

  // 2. Draw highlight/shine (small white ellipse, top-left)
  final shinePaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
  canvas.drawOval(
    Rect.fromLTWH(-radius * 0.3, -radius * 0.5, radius * 0.5, radius * 0.3),
    shinePaint,
  );

  // 3. Draw border (gold when selected, subtle when active)
  final borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = state == EggState.selected ? 3 : 1
    ..color = state == EggState.selected
        ? DragonColors.dragonGold
        : baseColor.withValues(alpha: 0.4);
  canvas.drawCircle(Offset.zero, radius, borderPaint);

  // 4. Draw value text
  final text = type == EggType.number
      ? '$value'
      : _opSymbol(value as MathOp);
  // Use TextPainter with Nunito Bold, size scaled to egg radius
  _drawText(canvas, text);
}
```

### Egg Colors (from Visual Design Guide section 9.3)

**Number eggs by range:**

| Range | Color Name | Hex | Usage |
|-------|-----------|-----|-------|
| 1-3 | Warm Cream | `#F5E6CA` | Low numbers |
| 4-6 | Soft Blue | `#AED6F1` | Medium-low |
| 7-9 | Soft Green | `#A9DFBF` | Medium-high |
| 10-12 | Soft Orange | `#F5CBA7` | High numbers |

**Operator eggs:** Gold tint `#F4D03F` border, amber background.

**Division eggs (level 31+):** Purple `#8E44AD` — visually distinct.

### Egg Sizing

```dart
static const double baseSize = 64.0;      // base diameter
static const double sizeVariance = 0.1;   // ±10%
static const double minTouchSize = 44.0;  // accessibility minimum

double generateEggRadius() {
  final variance = (random.nextDouble() * 2 - 1) * sizeVariance;
  final diameter = baseSize * (1 + variance);
  return max(diameter, minTouchSize) / 2;
}
```

### Font Scaling

```dart
double fontSizeForEgg(String text, double radius) {
  final diameter = radius * 2;
  if (text.length == 1) return diameter * 0.42;
  if (text.length == 2) return diameter * 0.36;
  return diameter * 0.28;  // 3+ chars
}
// Operators: 50% of diameter
```

---

## 10. Egg Spawning System

### `lib/games/dragon_eggs/systems/egg_spawner.dart`

Controls when and what type of eggs appear.

### Spawn Timing

Each difficulty tier defines a base `spawnIntervalMs`. A timer counts down;
when it reaches 0, a new egg spawns and the timer resets.

```dart
double _spawnTimer = 0;
bool _penaltyActive = false;
double _penaltyEndTime = 0;

void update(double dt, List<EggComponent> eggs, void Function(EggComponent) onSpawn) {
  _spawnTimer -= dt * 1000;  // convert to ms
  if (_spawnTimer <= 0) {
    final interval = _penaltyActive
        ? tier.spawnIntervalMs / 2   // doubled rate during penalty
        : tier.spawnIntervalMs;
    _spawnTimer = interval;
    onSpawn(_createEgg(eggs));
  }

  // Check if penalty period ended
  if (_penaltyActive && _now > _penaltyEndTime) {
    _penaltyActive = false;
  }
}

void activatePenalty() {
  _penaltyActive = true;
  _penaltyEndTime = _now + 2000;  // 2 seconds
}
```

### Type Selection (number vs. operator)

Maintain a healthy ratio of operators to numbers on screen:

```dart
EggType _selectType(List<EggComponent> eggs) {
  final numCount = eggs.where((e) => e.type == EggType.number && e.state == EggState.active).length;
  final opCount = eggs.where((e) => e.type == EggType.operator && e.state == EggState.active).length;
  final ratio = opCount / max(numCount, 1);

  if (ratio < 0.4) return EggType.operator;     // operator-starved
  if (ratio > 0.6) return EggType.number;        // too many operators
  if (opCount >= 8) return EggType.number;        // hard cap on operators

  return random.nextDouble() < 0.35 ? EggType.operator : EggType.number;
}
```

### Number Value Selection (biased toward focus fact)

```dart
int _selectNumberValue() {
  // 30% chance: spawn a component of the current focus fact
  if (focusFact != null && random.nextDouble() < 0.30) {
    final components = [focusFact!.left, focusFact!.right, focusFact!.result];
    return components[random.nextInt(components.length)];
  }

  // 70% chance: random number from current tier's range
  return tier.numberMin + random.nextInt(tier.numberMax - tier.numberMin + 1);
}
```

### Positioning

```dart
EggComponent _createEgg(List<EggComponent> eggs) {
  final type = _selectType(eggs);
  final radius = generateEggRadius();

  // x: random within field, keeping edges clear
  final x = radius + random.nextDouble() * (fieldWidth - radius * 2);

  // y: just above danger line (spawns off-screen or at top)
  final y = dangerLineY - radius * 2;

  // Initial velocity: slight horizontal drift
  final vx = (random.nextDouble() - 0.5) * 60;  // [-30, 30]

  return EggComponent(
    type: type,
    value: type == EggType.number ? _selectNumberValue() : _selectOperator(),
    position: Vector2(x, y),
    radius: radius,
    vx: vx,
    vy: 0,
    baseColor: _colorForValue(type, value),
  );
}
```

---

## 11. Equation Building State Machine

### `lib/games/dragon_eggs/systems/equation_builder.dart`

A 5-step state machine that tracks the player's equation-building progress.
This is the core interaction mechanic.

### States

```dart
enum EquationStep {
  selectLeft,      // Step 0: tap a number (left operand)
  selectOperator,  // Step 1: tap an operator
  selectRight,     // Step 2: tap a number (right operand)
  pressEquals,     // Step 3: press the = button (no egg tap accepted)
  selectAnswer,    // Step 4: tap a number (answer) → auto-evaluate
}
```

### State Machine

```dart
class EquationBuilder {
  EquationStep step = EquationStep.selectLeft;
  final List<EggComponent> parts = [];   // 0-4 selected eggs

  /// Attempt to select an egg. Returns true if accepted.
  bool trySelect(EggComponent egg) {
    // If egg is already selected, deselect it and everything after it
    final idx = parts.indexOf(egg);
    if (idx >= 0) {
      _deselectFrom(idx);
      return true;
    }

    // Step 3 doesn't accept egg taps (must press = button)
    if (step == EquationStep.pressEquals) return false;

    // Validate egg type for current step
    switch (step) {
      case EquationStep.selectLeft:
      case EquationStep.selectRight:
      case EquationStep.selectAnswer:
        if (egg.type != EggType.number) return false;
        break;
      case EquationStep.selectOperator:
        if (egg.type != EggType.operator) return false;
        break;
      case EquationStep.pressEquals:
        return false;
    }

    // Accept selection
    egg.state = EggState.selected;
    egg.selectionIndex = parts.length;
    parts.add(egg);

    // Advance step
    step = EquationStep.values[parts.length];

    // If we just selected the answer (step 4 → parts.length == 4), auto-evaluate
    if (parts.length == 4) {
      return true;  // caller should call evaluate()
    }

    return true;
  }

  /// Called when the = button is pressed (only valid at step 3).
  bool pressEquals() {
    if (step != EquationStep.pressEquals) return false;
    step = EquationStep.selectAnswer;
    return true;
  }

  /// Deselect from index onward.
  void _deselectFrom(int fromIndex) {
    for (int i = parts.length - 1; i >= fromIndex; i--) {
      parts[i].state = EggState.active;
      parts[i].selectionIndex = null;
      parts.removeAt(i);
    }
    step = EquationStep.values[parts.length];
  }

  /// Deselect all.
  void deselectAll() => _deselectFrom(0);

  /// Get the current equation display string.
  String get displayString {
    // "? _ ? = ?" with filled-in parts
    final left = parts.isNotEmpty ? '${parts[0].value}' : '?';
    final op = parts.length > 1 ? _opSymbol(parts[1].value as MathOp) : '_';
    final right = parts.length > 2 ? '${parts[2].value}' : '?';
    final answer = parts.length > 3 ? '${parts[3].value}' : '?';
    return '$left $op $right = $answer';
  }

  /// Reset for next equation.
  void reset() {
    parts.clear();
    step = EquationStep.selectLeft;
  }
}
```

---

## 12. Equation Validation

### `lib/games/dragon_eggs/models/equation.dart`

```dart
class EquationResult {
  final int left;
  final MathOp op;
  final int right;
  final int playerAnswer;
  final int correctAnswer;
  final bool isCorrect;
  final String factKey;

  EquationResult({
    required this.left,
    required this.op,
    required this.right,
    required this.playerAnswer,
  })  : correctAnswer = _compute(left, op, right),
        isCorrect = playerAnswer == _compute(left, op, right) && _compute(left, op, right) > 0,
        factKey = _buildFactKey(left, op, right);

  static int _compute(int a, MathOp op, int b) {
    switch (op) {
      case MathOp.add: return a + b;
      case MathOp.subtract: return a - b;
      case MathOp.multiply: return a * b;
      case MathOp.divide: return b != 0 ? a ~/ b : 0;  // integer division
    }
  }

  static String _buildFactKey(int a, MathOp op, int b) {
    // Normalize: for commutative ops, put smaller number first
    final opChar = {
      MathOp.add: '+', MathOp.subtract: '-',
      MathOp.multiply: 'x', MathOp.divide: '/',
    }[op]!;

    if (op == MathOp.add || op == MathOp.multiply) {
      final lo = min(a, b), hi = max(a, b);
      return '$lo$opChar$hi';
    }
    return '$a$opChar$b';
  }
}
```

### Validation Rules

1. Compute expected result from `left op right`
2. Check `playerAnswer == expected`
3. Check `expected > 0` (no zero or negative results)
4. For division: only integer results (already enforced in fact generation)

---

## 13. Combo System

### Mechanics (ported from original)

```dart
class ComboTracker {
  int combo = 0;

  /// Call on correct answer. Returns the multiplier used.
  int onCorrect() {
    combo++;
    return combo;  // first correct = 1x, second = 2x, etc.
  }

  /// Call on wrong answer. Resets combo to 0.
  void onWrong() {
    combo = 0;
  }

  bool get isActive => combo > 1;

  String get displayText => isActive ? 'Combo x$combo' : '';
}
```

### Visual Feedback

- When `combo > 1`, show "Combo x[N]" in gold with pulsing animation
- On each combo increment, pulse the counter (scale 1.0 → 1.1, spring curve)
- Combo display positioned below the equation display

---

## 14. Scoring System

### Score Calculation (ported from original)

```dart
class ScoreCalculator {
  /// Calculate difficulty-based points for a fact.
  static int difficultyPoints(int a, int b, MathOp op) {
    switch (op) {
      case MathOp.multiply:
        if (min(a, b) <= 2) return 5;     // Easy
        if (a <= 5 && b <= 5) return 10;   // Medium
        if (min(a, b) <= 5) return 15;     // Hard
        return 20;                          // Tricky
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

  /// Calculate total score for an answer.
  /// Returns (earned, breakdown) for display.
  static (int earned, String breakdown) calculate({
    required int a,
    required int b,
    required MathOp op,
    required int comboMultiplier,
    required bool isNewFact,
  }) {
    final base = difficultyPoints(a, b, op);
    final newFactBonus = isNewFact ? 5 : 0;
    final earned = base * comboMultiplier + newFactBonus;

    // Build display string
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
}
```

### New Fact Detection

Track which facts have been solved this session using a `Set<String>`:

```dart
final Set<String> _solvedFactsThisSession = {};

bool isNewFact(String factKey) {
  if (_solvedFactsThisSession.contains(factKey)) return false;
  _solvedFactsThisSession.add(factKey);
  return true;
}
```

New fact bonus = 5 points, shown as "NEW FACT! +5" in teal/cyan.

---

## 15. Difficulty Tiers & World Progression

### 6 Difficulty Tiers (ported from original)

```dart
class DifficultyTier {
  final int level;
  final int numberMin;
  final int numberMax;
  final List<MathOp> operations;
  final double gravityMultiplier;  // multiplied against base gravity (550)
  final int spawnIntervalMs;
  final int resultMax;

  // Tier definitions matching the original exactly
  static const tiers = [
    DifficultyTier(level: 1, numberMin: 1, numberMax: 5,
      operations: [MathOp.add],
      gravityMultiplier: 1.0, spawnIntervalMs: 2000, resultMax: 10),
    DifficultyTier(level: 2, numberMin: 1, numberMax: 8,
      operations: [MathOp.add, MathOp.subtract],
      gravityMultiplier: 1.05, spawnIntervalMs: 1800, resultMax: 16),
    DifficultyTier(level: 3, numberMin: 1, numberMax: 10,
      operations: [MathOp.add, MathOp.subtract, MathOp.multiply],
      gravityMultiplier: 1.1, spawnIntervalMs: 1500, resultMax: 50),
    DifficultyTier(level: 4, numberMin: 2, numberMax: 12,
      operations: [MathOp.add, MathOp.subtract, MathOp.multiply],
      gravityMultiplier: 1.2, spawnIntervalMs: 1300, resultMax: 100),
    DifficultyTier(level: 5, numberMin: 2, numberMax: 12,
      operations: [MathOp.add, MathOp.subtract, MathOp.multiply],
      gravityMultiplier: 1.3, spawnIntervalMs: 1100, resultMax: 144),
    DifficultyTier(level: 6, numberMin: 2, numberMax: 12,
      operations: [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide],
      gravityMultiplier: 1.4, spawnIntervalMs: 900, resultMax: 144),
  ];
}
```

### Auto-Leveling

Difficulty tier increases by 1 every **10 correct answers**:

```dart
void _checkLevelUp() {
  if (correctCount > 0 && correctCount % 10 == 0) {
    final newTierIndex = min(
      (correctCount ~/ 10),
      DifficultyTier.tiers.length - 1,
    );
    currentTier = DifficultyTier.tiers[newTierIndex];
    spawner.updateTier(currentTier);
    // Notify UI of level change
  }
}
```

### 5-World Mapping

The 6 difficulty tiers map to the 5-world structure from the plan:

| World | Name | Levels | Tiers Used | Math Content |
|-------|------|--------|------------|--------------|
| 1 | Nest of Addition | 1-10 | Tier 1 | Addition 1-5 |
| 2 | Cracking Subtraction | 11-20 | Tier 2 | Add + subtract 1-8 |
| 3 | Multiplication Roost | 21-30 | Tiers 3-4 | Add + sub + multiply 1-12 |
| 4 | Division Den | 31-40 | Tier 5 + division | All operations, integers only |
| 5 | Ancient Hatchery | 41-50 | Tier 6 | All ops 2-12, fast, complex |

Within each world, levels progress by adjusting parameters within the tier range:
- Levels 1-3 of a world: lower end of tier
- Levels 4-7: middle of tier
- Levels 8-10: upper end (more facts needed for completion, higher score thresholds)

### Level Definitions

```dart
static List<GameLevel> _generateLevels() {
  return [
    // World 1: Nest of Addition (Levels 1-10)
    for (int i = 1; i <= 10; i++)
      GameLevel(
        levelNumber: i,
        name: 'Nest ${i}',
        worldName: 'Nest of Addition',
        params: DifficultyParams(
          numberMin: 1,
          numberMax: (3 + (i * 0.2)).round().clamp(3, 5),
          operations: {MathOperation.addition},
          speedMultiplier: 1.0,
        ),
        starsRequired: i > 1 ? 1 : 0,
      ),

    // World 2: Cracking Subtraction (Levels 11-20)
    // ... similar pattern with add + subtract

    // World 3: Multiplication Roost (Levels 21-30)
    // ... add + sub + multiply

    // World 4: Division Den (Levels 31-40)
    // ... all operations including division (integer results only)

    // World 5: Ancient Hatchery (Levels 41-50)
    // ... all ops, max difficulty, fast spawning
  ];
}
```

---

## 16. Division Support

Division is introduced at **World 4** (Level 31+).

### Fact Generation Rules

- Only generate division problems with **integer results**: `a / b = c` where `a % b == 0`
- Example valid problems: `12 ÷ 3 = 4`, `20 ÷ 5 = 4`, `9 ÷ 3 = 3`
- Example invalid (never generated): `7 ÷ 3`, `10 ÷ 4`
- Divisor range: 2-12 (never divide by 0 or 1, as those are trivial)
- Result must be > 0

### Division Fact Generator

```dart
List<MathFact> _generateDivisionFacts(int numMin, int numMax, int resultMax) {
  final facts = <MathFact>[];
  for (int b = max(2, numMin); b <= numMax; b++) {  // divisor
    for (int c = 1; c <= resultMax; c++) {            // result
      final a = b * c;                                 // dividend
      if (a >= numMin && a <= numMax * numMax && a <= resultMax * 2) {
        facts.add(MathFact(left: a, op: MathOp.divide, right: b, result: c));
      }
    }
  }
  return facts;
}
```

### Visual Distinction

Division eggs are rendered with the distinct purple color from the Visual Design Guide:

```dart
Color _colorForDivisionEgg() => const Color(0xFF8E44AD);  // Purple
```

Division operator eggs (`÷`) also get the purple tint so players can see at a glance
that division is available.

---

## 17. Fact Tracking & Adaptive Selection

### Integration with FactTracker

On every equation attempt (correct or wrong), record the fact:

```dart
void _recordFact(EquationResult result, int responseTimeMs) {
  // Emit to event bus — FactTracker is listening
  eventBus.emit(AnswerGiven(
    gameId: 'dragon_eggs',
    problem: result.factKey,
    playerAnswer: '${result.playerAnswer}',
    correctAnswer: '${result.correctAnswer}',
    correct: result.isCorrect,
    responseTimeMs: responseTimeMs,
  ));
}
```

### Focus Fact Selection (ported from original)

The focus fact determines which numbers are biased in spawning (30% of number spawns
are components of the focus fact).

```dart
class FocusFactSelector {
  MathFact? currentFact;
  final List<String> recentFacts = [];  // last 20 fact keys
  static const int recentQueueSize = 20;

  /// Pick a new focus fact using weighted random selection.
  MathFact pickFocusFact(List<MathFact> pool, FactTracker tracker) {
    // Weight each fact based on player history
    final weights = pool.map((fact) {
      final key = fact.factKey;
      final record = tracker.getFact(key);

      if (record == null) return 5.0;  // never seen

      double weight;
      final avgTime = record.averageResponseTimeMs;
      if (avgTime > 3000) {
        weight = 8.0;   // struggling
      } else if (avgTime > 1500) {
        weight = 3.0;   // moderate
      } else {
        weight = 1.0;   // fast/mastered
      }

      // Accuracy penalty
      if (record.timesPresented >= 3 && record.accuracy < 0.7) {
        weight *= 2;
      }

      // Staleness bonus — not in recent queue
      if (recentFacts.length >= recentQueueSize && !recentFacts.contains(key)) {
        weight *= 1.5;
      }

      return weight;
    }).toList();

    // Weighted random selection
    final totalWeight = weights.fold(0.0, (a, b) => a + b);
    var roll = random.nextDouble() * totalWeight;
    for (int i = 0; i < pool.length; i++) {
      roll -= weights[i];
      if (roll <= 0) {
        currentFact = pool[i];
        _addToRecent(pool[i].factKey);
        return pool[i];
      }
    }

    currentFact = pool.last;
    return pool.last;
  }

  void _addToRecent(String key) {
    recentFacts.add(key);
    if (recentFacts.length > recentQueueSize) {
      recentFacts.removeAt(0);
    }
  }
}
```

### Fact Key Normalization

Games emit fact keys in a normalized format the FactTracker understands:
- Addition: `"3+5"` (smaller number first for commutative ops)
- Subtraction: `"8-3"` (left operand first, non-commutative)
- Multiplication: `"3x7"` (smaller number first)
- Division: `"12/3"` (dividend first, non-commutative)

---

## 18. Event Bus Integration

### Events Emitted

The Dragon Eggs game emits these events at the appropriate times:

```dart
// On game start (GameShell handles this via initState)
eventBus.emit(GameStarted(gameId: 'dragon_eggs', levelNumber: currentLevel));

// On every answer attempt
eventBus.emit(AnswerGiven(
  gameId: 'dragon_eggs',
  problem: equation.factKey,          // e.g., "3+5"
  playerAnswer: '${equation.playerAnswer}',
  correctAnswer: '${equation.correctAnswer}',
  correct: equation.isCorrect,
  responseTimeMs: solveTimeMs,
));

// On streak milestones (5, 10, 15, ...)
if (streak > 0 && streak % 5 == 0) {
  eventBus.emit(StreakAchieved(gameId: 'dragon_eggs', streakLength: streak));
}

// On level completion (if using level-based progression)
eventBus.emit(LevelCompleted(
  gameId: 'dragon_eggs',
  levelNumber: currentLevel,
  score: totalScore,
  stars: calculateStars(),
  accuracy: correctCount / totalAttempts,
));

// On game end (game over or player quits)
eventBus.emit(GameEnded(
  gameId: 'dragon_eggs',
  finalScore: totalScore,
  duration: gameDuration,
));
```

### Response Time Tracking

Track the time between when the focus fact is picked and when the equation is
completed. This feeds into the adaptive selection weights.

```dart
DateTime? _equationStartTime;

void _onNewFocusFact() {
  _equationStartTime = DateTime.now();
}

int _getResponseTimeMs() {
  if (_equationStartTime == null) return 0;
  return DateTime.now().difference(_equationStartTime!).inMilliseconds;
}
```

---

## 19. Game Flow & State Machine

### Game Phases

```dart
enum GamePhase { ready, playing, paused, gameOver }
```

### Flow

```
App Start
  │
  ▼
Hub → Tap Dragon Eggs card
  │
  ▼
DragonEggsScreen mounts (Flutter)
  │
  ▼
GameShell wraps, emits GameStarted
  │
  ▼
FlameGame loads, begins spawning eggs
  │
  ▼
PLAYING LOOP:
  │
  ├── Eggs fall with physics
  ├── Player taps eggs to build equations
  ├── Correct → pop eggs, score, combo++, check level-up
  ├── Wrong → shake, penalty spawn, combo reset
  ├── Spawn new eggs on timer
  ├── Ensure solvability
  ├── Check game over (eggs above danger line)
  │
  ▼ (on game over)
GamePhase.gameOver
  │
  ├── Stop physics, stop spawning
  ├── Emit GameEnded event
  ├── Calculate stars, scales
  │
  ▼
Show ResultScreen (Flutter bottom sheet)
  │
  ├── "Play Again" → reset game state, restart
  └── "Back to Hub" → Navigator.pop twice
```

### Star Calculation

```dart
int calculateStars(double accuracy, int score, int levelNumber) {
  // Minimum thresholds
  final scoreThresholdMedium = 200 + levelNumber * 20;
  final scoreThresholdHigh = 400 + levelNumber * 30;

  if (accuracy >= 0.9 && score >= scoreThresholdHigh) return 3;
  if (accuracy >= 0.75 && score >= scoreThresholdMedium) return 2;
  if (accuracy >= 0.6) return 1;
  return 0;
}
```

---

## 20. Visual Design & Rendering

### Color Palette (from Visual Design Guide section 9.3)

| Role | Hex | Usage |
|------|-----|-------|
| Accent | `#3498DB` | Card border, UI accents |
| Accent Light | `#85C1E9` | Egg highlights |
| Accent Dark | `#2471A3` | Pressed states |
| Environment | Cliff-side nests, morning sky | Background theme |
| Division eggs | `#8E44AD` | Purple for visual distinction |

### Pop Animation

When eggs are "popped" (correct equation), 4 eggs pop simultaneously:

```dart
void popEgg(EggComponent egg) {
  egg.state = EggState.popping;

  // 1. Scale up to 1.4x over 160ms, then shrink to 0 over 240ms (400ms total)
  // 2. Spawn 8-14 sparkle particles flying outward radially
  // 3. Particles are gold/light-gold, fade over 600ms
  // 4. After 400ms, mark egg as dead and remove

  add(EggPopEffect(position: egg.position, color: egg.baseColor));

  Future.delayed(const Duration(milliseconds: 400), () {
    egg.state = EggState.dead;
    remove(egg);
    eggs.remove(egg);
  });
}
```

### Wrong Answer Animation

```dart
void shakeEgg(EggComponent egg) {
  // CSS shake equivalent: horizontal jitter ±6px over 400ms
  // Use a sequence of position offsets:
  // 0ms: 0, 50ms: +6, 100ms: -6, 150ms: +4, 200ms: -4, 250ms: +2, 300ms: -2, 400ms: 0
  egg.addEffect(ShakeEffect(duration: 0.4, intensity: 6));
}
```

### Background

For v1, use a simple gradient background matching the Visual Design Guide:
- Night Sky gradient (`#0D0D1A` → `#1A1A2E` → `#16213E`)
- Danger line at top: semi-transparent red gradient line

---

## 21. Touch Interaction

### Tap Handling

Flame's `TapCallbacks` mixin handles taps on egg components:

```dart
// On EggComponent:
@override
bool onTapDown(TapDownEvent event) {
  if (state != EggState.active && state != EggState.selected) return false;
  _onEggTapped(this);
  return true;  // consume the event
}
```

### Empty Space Taps

Tapping empty space (no egg hit) deselects all:

```dart
// On DragonEggsFlameGame:
@override
void onTapDown(TapDownEvent event) {
  // If no component consumed the tap, it reaches the game
  equationBuilder.deselectAll();
}
```

### Equals Button

The equals button is a **Flutter widget** overlaid on the Flame game (not a Flame
component). It appears when `equationStep == pressEquals` and pulses with a gold
glow animation.

```dart
// In the equation display overlay:
if (equationBuilder.step == EquationStep.pressEquals)
  AnimatedContainer(
    // Gold pulsing button
    child: ElevatedButton(
      onPressed: () => equationBuilder.pressEquals(),
      child: Text('='),
    ),
  )
```

---

## 22. Game Over & Results

### Game Over Trigger

A bubble is pushed above the danger line:

```dart
if (egg.state == EggState.active &&
    egg.hasEnteredField &&
    egg.position.y - egg.radius <= dangerLineY) {
  _triggerGameOver();
}
```

`hasEnteredField` is set to `true` once the egg's center passes below
`dangerLineY + egg.radius`. This prevents newly spawned eggs from immediately
triggering game over.

### Result Screen Integration

When the game ends, the Flutter wrapper shows the `ResultScreen` from Step 3:

```dart
void _onGameOver() {
  // Emit GameEnded
  eventBus.emit(GameEnded(
    gameId: 'dragon_eggs',
    finalScore: score,
    duration: gameDuration,
  ));

  // Calculate results
  final results = GameResults(
    gameId: 'dragon_eggs',
    score: score,
    accuracy: totalAttempts > 0 ? correctCount / totalAttempts : 0,
    streak: bestStreak,
    scalesEarned: scalesThisRound,
    stars: calculateStars(...),
    levelNumber: currentLevel,
    problemsAttempted: totalAttempts,
    problemsCorrect: correctCount,
  );

  // Show result screen
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (_) => ResultScreen(
      results: results,
      accentColor: DragonColors.dragonEggsAccent,
      onPlayAgain: _restartGame,
      onBackToHub: () {
        Navigator.pop(context); // sheet
        Navigator.pop(context); // game
      },
      encouragement: _getEncouragement(),
      gameSuggestion: _getGameSuggestion(),
    ),
  );
}
```

### Encouragement Logic

```dart
String? _getEncouragement() {
  if (stars == 0 && accuracy >= 0.5) {
    return 'Keep going! You\'re getting closer.';
  }
  if (stars == 2 && accuracy >= 0.85) {
    return 'So close to 3 stars! Just a bit more accuracy.';
  }
  return null;
}
```

### Game Suggestion

```dart
String? _getGameSuggestion() {
  final session = context.read<SessionManager>();
  if (session.shouldSuggestDifferentGame) {
    return 'Your dragon is hungry! Try Dragon\'s Feast for bonus scales.';
  }
  return null;
}
```

---

## 23. HUD & Equation Display

### Equation Display (Flutter Overlay)

Positioned at the top of the game area, below the GameShell HUD:

```dart
class EquationDisplay extends StatelessWidget {
  final String equationText;    // "3 + ? = ?"
  final bool showEqualsButton;
  final VoidCallback onEquals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Equation text with gold operators
          _buildEquationText(equationText),

          if (showEqualsButton) ...[
            SizedBox(width: 8),
            _buildEqualsButton(onEquals),
          ],
        ],
      ),
    );
  }
}
```

### Score Display (Flutter Overlay)

Positioned at the bottom of the game area:

```dart
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int combo;
  final int streak;
  final bool isNewFact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score (JetBrains Mono, gold)
        Text('Score: $score', style: _scoreStyle),

        // Combo (if active, pulsing gold)
        if (combo > 1)
          Text('Combo x$combo', style: _comboStyle),

        // NEW FACT badge (teal, temporary)
        if (isNewFact)
          Text('NEW FACT! +5', style: _newFactStyle),

        // Streak fire
        if (streak > 0)
          Row(children: [
            Icon(Icons.local_fire_department, color: DragonColors.fireOrange, size: 16),
            Text('$streak', style: _streakStyle),
          ]),
      ],
    );
  }
}
```

### Feedback Toast

Floating text that appears briefly on correct/wrong answers:

```dart
class FeedbackOverlay extends StatelessWidget {
  final String? feedbackText;     // "+15 (5 x 3)" or "Nope!"
  final bool isCorrect;
  final bool isNewFact;

  @override
  Widget build(BuildContext context) {
    if (feedbackText == null) return SizedBox.shrink();

    return AnimatedOpacity(
      opacity: feedbackText != null ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Text(
        feedbackText!,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isCorrect ? DragonColors.emeraldFlame : DragonColors.fireOrange,
        ),
      ),
    );
  }
}
```

---

## 24. Math Problem Generation

### `lib/games/shared/math_problem.dart`

Replace the stub. This file provides shared utilities for generating valid math
facts that multiple games can use.

```dart
/// A single math fact with its components.
class MathFact {
  final int left;
  final MathOp op;
  final int right;
  final int result;

  MathFact({required this.left, required this.op, required this.right})
    : result = _compute(left, op, right);

  String get factKey => EquationResult._buildFactKey(left, op, right);

  static int _compute(int a, MathOp op, int b) { /* same as EquationResult */ }
}

/// Generate all valid math facts for a given difficulty configuration.
List<MathFact> generateFacts({
  required int numberMin,
  required int numberMax,
  required List<MathOp> operations,
  required int resultMax,
}) {
  final facts = <MathFact>[];

  for (final op in operations) {
    for (int a = numberMin; a <= numberMax; a++) {
      for (int b = numberMin; b <= numberMax; b++) {
        // Subtraction: a must be > b (positive results only)
        if (op == MathOp.subtract && a <= b) continue;

        // Division: must divide evenly
        if (op == MathOp.divide) {
          if (b < 2) continue;        // don't divide by 0 or 1
          if (a % b != 0) continue;   // integer results only
        }

        final result = MathFact._compute(a, op, b);
        if (result <= 0 || result > resultMax) continue;

        // For commutative ops: only store canonical form (a >= b)
        if ((op == MathOp.add || op == MathOp.multiply) && a < b) continue;

        facts.add(MathFact(left: a, op: op, right: b));
      }
    }
  }

  return facts;
}
```

---

## 25. Localization Updates

### Add to `lib/l10n/app_en.arb`

```json
{
  "eggsHatched": "{count} eggs hatched",
  "@eggsHatched": {
    "description": "Counter showing total eggs hatched",
    "placeholders": { "count": { "type": "int" } }
  },

  "comboMultiplier": "Combo x{count}",
  "@comboMultiplier": {
    "description": "Combo multiplier display",
    "placeholders": { "count": { "type": "int" } }
  },

  "newFactBonus": "NEW FACT! +5",
  "@newFactBonus": { "description": "New fact bonus notification" },

  "nope": "Nope!",
  "@nope": { "description": "Wrong answer feedback" },

  "equalsButtonLabel": "=",
  "@equalsButtonLabel": { "description": "Equals button in equation builder" },

  "nestOfAddition": "Nest of Addition",
  "@nestOfAddition": { "description": "Dragon Eggs World 1 name" },

  "crackingSubtraction": "Cracking Subtraction",
  "@crackingSubtraction": { "description": "Dragon Eggs World 2 name" },

  "multiplicationRoost": "Multiplication Roost",
  "@multiplicationRoost": { "description": "Dragon Eggs World 3 name" },

  "divisionDen": "Division Den",
  "@divisionDen": { "description": "Dragon Eggs World 4 name" },

  "ancientHatchery": "Ancient Hatchery",
  "@ancientHatchery": { "description": "Dragon Eggs World 5 name" },

  "dangerWarning": "Eggs rising!",
  "@dangerWarning": { "description": "Warning when eggs approach the danger line" },

  "opsHint": "Ops: {ops}",
  "@opsHint": {
    "description": "Available operations hint",
    "placeholders": { "ops": { "type": "String" } }
  },

  "levelUp": "Level Up!",
  "@levelUp": { "description": "Shown when auto-leveling to next tier" },

  "highScore": "High Score",
  "@highScore": { "description": "High score label" },

  "newHighScore": "New High Score!",
  "@newHighScore": { "description": "Shown when player beats their high score" },

  "factsThisSession": "{count} facts practiced",
  "@factsThisSession": {
    "description": "Number of unique facts practiced in this session",
    "placeholders": { "count": { "type": "int" } }
  }
}
```

---

## 26. Unit Tests

### Test Files

```
test/
├── games/
│   └── dragon_eggs/
│       ├── equation_test.dart
│       ├── combo_test.dart
│       ├── score_test.dart
│       ├── difficulty_test.dart
│       ├── math_problem_test.dart
│       ├── equation_builder_test.dart
│       └── solvability_test.dart
```

### `test/games/dragon_eggs/equation_test.dart`

```dart
// Test cases:
// 1. Correct addition: 3 + 5 = 8 → isCorrect: true
// 2. Correct subtraction: 8 - 3 = 5 → isCorrect: true
// 3. Correct multiplication: 4 × 3 = 12 → isCorrect: true
// 4. Correct division: 12 ÷ 3 = 4 → isCorrect: true
// 5. Wrong answer: 3 + 5 = 9 → isCorrect: false
// 6. Zero result rejected: 5 - 5 = 0 → isCorrect: false
// 7. Negative result rejected: 3 - 5 = -2 → isCorrect: false
// 8. Division by zero handled: 5 ÷ 0 → isCorrect: false
// 9. Non-integer division rejected: 7 ÷ 3 = 2 → isCorrect: false
// 10. Fact key normalization:
//     - 5 + 3 → "3+5" (commutative, smaller first)
//     - 3 + 5 → "3+5"
//     - 8 - 3 → "8-3" (non-commutative, left first)
//     - 3 × 7 → "3x7" (commutative)
//     - 12 ÷ 3 → "12/3" (non-commutative)
```

### `test/games/dragon_eggs/combo_test.dart`

```dart
// Test cases:
// 1. Initial combo is 0
// 2. First correct → combo 1, multiplier 1
// 3. Second consecutive correct → combo 2, multiplier 2
// 4. Wrong answer resets combo to 0
// 5. Combo after reset starts at 1 again
// 6. isActive is false when combo <= 1
// 7. isActive is true when combo >= 2
```

### `test/games/dragon_eggs/score_test.dart`

```dart
// Test cases:
// 1. Easy addition (max <= 5): 5 points
// 2. Medium addition (max <= 10, min <= 5): 8 points
// 3. Hard addition: 12 points
// 4. Easy multiplication (min <= 2): 5 points
// 5. Medium multiplication (both <= 5): 10 points
// 6. Hard multiplication (min <= 5): 15 points
// 7. Tricky multiplication (both > 5): 20 points
// 8. Score with combo: base * combo
// 9. Score with new fact bonus: base * combo + 5
// 10. Score with combo=1 and no new fact: just base points
```

### `test/games/dragon_eggs/difficulty_test.dart`

```dart
// Test cases:
// 1. Tier 1 has correct parameters (add only, range 1-5, speed 1.0)
// 2. Tier 6 has correct parameters (all ops, range 2-12, speed 1.4)
// 3. Auto-level triggers at 10 correct answers
// 4. Auto-level doesn't exceed tier 6
// 5. Level 31+ includes division
// 6. Each tier's operations are a superset of the previous tier's
```

### `test/games/dragon_eggs/math_problem_test.dart`

```dart
// Test cases:
// 1. Addition facts: all results > 0 and <= resultMax
// 2. Subtraction facts: left > right always (positive results)
// 3. Multiplication facts: all results <= resultMax
// 4. Division facts: all results are integers (a % b == 0)
// 5. Division facts: divisor >= 2 (no divide by 0 or 1)
// 6. Commutative dedup: (3,5,+) and (5,3,+) produce only one fact
// 7. Non-commutative preserved: (8,3,-) and (3,8,-) are distinct (but 3-8 is filtered)
// 8. Empty operations list → empty facts list
// 9. Tier 1 params produce only addition facts
// 10. Tier 6 params produce facts for all 4 operations
```

### `test/games/dragon_eggs/equation_builder_test.dart`

```dart
// Test cases:
// 1. Initial state is selectLeft
// 2. Selecting a number at step 0 → advances to selectOperator
// 3. Selecting an operator at step 0 → rejected (returns false)
// 4. Selecting a number at step 1 → rejected
// 5. Full valid sequence: number → operator → number → equals → number → auto-evaluates
// 6. Tapping a selected egg deselects it and everything after
// 7. deselectAll resets to step 0 with empty parts
// 8. pressEquals only works at step 3
// 9. Display string updates correctly at each step
// 10. After auto-evaluate, parts has 4 entries
```

### `test/games/dragon_eggs/solvability_test.dart`

```dart
// Test cases:
// 1. Empty field → solvability check triggers spawn of 4 eggs
// 2. Field with all numbers but no operators → spawns an operator
// 3. Field with valid equation components → check passes (no spawn)
// 4. Spawned eggs form a valid equation for the current focus fact
```

---

## 27. Verification Checklist

After completing this step, verify:

### Gameplay

- [ ] **Eggs fall** — gravity pulls eggs down at the correct rate
- [ ] **Eggs bounce** — off floor, walls, and each other with visible bounce
- [ ] **Eggs settle** — stop moving when velocity is low and on the floor
- [ ] **Eggs collide** — push each other apart, don't overlap permanently
- [ ] **Tap to select** — tapping an egg highlights it with gold border
- [ ] **Equation building** — 4 taps build a valid equation step by step
- [ ] **Equals button** — appears at step 3, pulses with gold glow
- [ ] **Correct answer** — eggs pop with sparkle effect, score increases
- [ ] **Wrong answer** — eggs shake red, combo resets, penalty spawn activates
- [ ] **Combo counter** — increments on consecutive correct, resets on wrong
- [ ] **Deselection** — tapping a selected egg deselects it and later parts
- [ ] **Empty tap** — tapping empty space deselects all
- [ ] **Game over** — triggers when eggs stack above the danger line
- [ ] **Difficulty auto-levels** — tier changes every 10 correct answers
- [ ] **Division appears** — at tier 6 / World 4+ with integer results only
- [ ] **Division eggs** — visually purple, clearly distinct from other eggs
- [ ] **Focus fact biasing** — 30% of number spawns are focus fact components
- [ ] **Solvability** — at least one valid equation always exists on screen

### Integration

- [ ] **Hub card** — Dragon Eggs card on hub navigates to the game
- [ ] **GameShell wraps** — pause overlay works (Resume/Settings/Quit)
- [ ] **Pause hides values** — egg text is hidden during pause (anti-cheat)
- [ ] **Result screen** — appears on game over with correct stats
- [ ] **Play Again** — restarts the game from the same starting level
- [ ] **Back to Hub** — returns to hub cleanly
- [ ] **Event bus** — emits GameStarted, AnswerGiven, StreakAchieved, GameEnded
- [ ] **FactTracker** — records every attempt with timing data
- [ ] **RewardService** — awards scales for correct answers and streaks
- [ ] **Profile updates** — totalScales, totalCorrectAnswers, gameStats change

### Technical

- [ ] **`flutter analyze`** — passes clean
- [ ] **`flutter test`** — all tests pass (existing + new)
- [ ] **`flutter build apk --debug`** — succeeds
- [ ] **Performance** — smooth 60fps on emulator, no frame drops during physics
- [ ] **No memory leaks** — eggs are properly removed when popped or dead
- [ ] **All strings localized** — no hardcoded English text

### Fun Factor

- [ ] **Physics feel good** — eggs are weighty and satisfying, not floaty
- [ ] **Correct answers feel rewarding** — pop effect + score + combo
- [ ] **Wrong answers sting but don't punish** — game continues, brief penalty
- [ ] **Difficulty curve is smooth** — tier 1 feels easy, tier 6 feels challenging
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
1. Hub → tap Dragon Eggs → game loads with eggs falling
2. Tap: number → operator → number → press = → tap answer
3. Correct equation → eggs pop, score increases, combo starts
4. Get 3 correct in a row → verify combo display shows "Combo x3"
5. Get a wrong answer → verify shake animation, combo reset
6. Get 10 correct → verify auto-level (tier change notification)
7. Let eggs stack up → verify game over triggers at danger line
8. Result screen → verify score, accuracy, streak are correct
9. Tap "Play Again" → verify game restarts
10. Tap "Back to Hub" → verify return to hub
11. Pause mid-game → verify egg values are hidden
12. Resume → verify values reappear, physics continue normally
```

---

## Files Modified in This Step

| File | Action | Description |
|------|--------|-------------|
| `lib/games/dragon_eggs/dragon_eggs_game.dart` | **Replace** | Full game screen wrapping FlameGame |
| `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | **Create** | Flame FlameGame subclass |
| `lib/games/dragon_eggs/dragon_eggs_registration.dart` | **Create** | MathDragonsGame implementation |
| `lib/games/dragon_eggs/components/egg_component.dart` | **Create** | Individual egg component |
| `lib/games/dragon_eggs/components/danger_line.dart` | **Create** | Visual danger line |
| `lib/games/dragon_eggs/components/egg_pop_effect.dart` | **Create** | Pop/sparkle particle effect |
| `lib/games/dragon_eggs/systems/egg_physics.dart` | **Create** | Physics engine |
| `lib/games/dragon_eggs/systems/egg_spawner.dart` | **Create** | Spawn timing and selection |
| `lib/games/dragon_eggs/systems/equation_builder.dart` | **Create** | 5-step equation state machine |
| `lib/games/dragon_eggs/systems/solvability_checker.dart` | **Create** | Ensures valid equations exist |
| `lib/games/dragon_eggs/models/egg_data.dart` | **Create** | Egg type, state enums |
| `lib/games/dragon_eggs/models/difficulty_config.dart` | **Create** | 6 difficulty tier definitions |
| `lib/games/dragon_eggs/models/equation.dart` | **Create** | Equation data model + validation |
| `lib/games/dragon_eggs/widgets/equation_display.dart` | **Create** | Flutter overlay for equation |
| `lib/games/dragon_eggs/widgets/score_display.dart` | **Create** | Score/combo/streak display |
| `lib/games/dragon_eggs/widgets/feedback_overlay.dart` | **Create** | Correct/wrong feedback toast |
| `lib/games/shared/math_problem.dart` | **Replace** | Shared math fact generation |
| `lib/app.dart` | **Modify** | Register DragonEggs game |
| `lib/l10n/app_en.arb` | **Modify** | Add Dragon Eggs strings |

---

## What This Step Does NOT Include

These are explicitly out of scope for Step 4:

- **Real sprite art for eggs** — Step 12 (using custom-painted circles for v1)
- **Sound effects** — Step 12 (no audio in v1 games)
- **Hatch animation with baby dragon** — Step 12 (simplified pop effect for now)
- **Adaptive problem selection algorithm** — Step 8 (using the original's weight-based
  focus fact selection as a simpler alternative for now)
- **Level select screen** — Step 8
- **Achievement checking** — Step 9
- **Daily challenge integration** — Step 9
- **Cloud sync** — Step 10

Step 4 delivers the first fully playable game. It must be **fun** above all else.
The physics must feel satisfying, the equation building must be intuitive, and
the difficulty must be well-paced. Prioritize gameplay feel over visual polish —
the polish comes in Steps 8, 9, and 12.

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
