# Step 6: Game Port — Dragon Runes (Number Links)

> **Goal:** Port the HTML5 Number Links game to Flutter/Flame as "Dragon Runes" — a
> puzzle game where the player drags across circular rune nodes to chain numbers and
> operators into valid equations (e.g., `3 + 2 = 5`). The game is level-based with
> procedurally generated puzzles, a hint system, streak bonuses, and spell-casting
> visual effects. Unlike the action-paced Fire Trail and Dragon Eggs, Dragon Runes is
> a thoughtful, untimed puzzle that rewards equation-building skill and pattern recognition.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 5 complete. Fire Trail fully playable and integrated. `flutter analyze`
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
8. [Circular Node Layout](#8-circular-node-layout)
9. [Drag-to-Connect Mechanics](#9-drag-to-connect-mechanics)
10. [Equation Validation](#10-equation-validation)
11. [Level Generation Algorithm](#11-level-generation-algorithm)
12. [Hint System](#12-hint-system)
13. [Streak & Scoring](#13-streak--scoring)
14. [Visual Effects & Spell Casting](#14-visual-effects--spell-casting)
15. [Difficulty & World Progression](#15-difficulty--world-progression)
16. [Fact Tracking & Adaptive Selection](#16-fact-tracking--adaptive-selection)
17. [Event Bus Integration](#17-event-bus-integration)
18. [Game Flow & State Machine](#18-game-flow--state-machine)
19. [Game Over & Results](#19-game-over--results)
20. [HUD Elements](#20-hud-elements)
21. [Localization Updates](#21-localization-updates)
22. [Unit Tests](#22-unit-tests)
23. [Verification Checklist](#23-verification-checklist)

---

## 1. User Stories

### US-6.1: Play Dragon Runes
**As a** player,
**I want** to drag across rune stones to connect numbers and operators into valid equations,
**so that** I can practice equation building in a puzzle format without time pressure.

### US-6.2: Spell Casting Effect
**As a** player,
**I want** a magical spell-casting visual effect when I complete a correct equation,
**so that** solving each puzzle feels rewarding and tied to the dragon fantasy theme.

### US-6.3: Hints When Stuck
**As a** player,
**I want** up to 3 hints per level that highlight nodes belonging to a valid equation,
**so that** I can get unstuck without giving up when a puzzle is hard.

### US-6.4: Streak Bonuses
**As a** player,
**I want** to earn bonus points for solving consecutive equations correctly,
**so that** I'm rewarded for sustained accuracy and careful thinking.

### US-6.5: Progressive Difficulty
**As a** player,
**I want** puzzles to start with simple addition and gradually introduce subtraction,
multiplication, and division with larger numbers,
**so that** the challenge grows naturally as I improve.

### US-6.6: Earn Scales
**As a** player,
**I want** to earn Dragon Scales for correct equations, streaks, and level completion,
**so that** my Dragon Runes sessions contribute to my overall progression.

### US-6.7: See My Results
**As a** player,
**I want** a results screen after each level showing my score, equations found, and scales earned,
**so that** every completed level ends with a satisfying summary.

### US-6.8: Level Progression
**As a** player,
**I want** to advance through themed worlds with increasingly complex puzzles,
**so that** I have long-term goals and can see my math skills growing.

---

## 2. Acceptance Criteria

- [ ] Dragon Runes is fully playable from the hub screen
- [ ] Rune nodes are arranged in a circle with numbers, operators, and an equals sign
- [ ] Dragging across nodes builds a chain displayed with a glowing connection line
- [ ] Releasing the chain validates the equation (minimum 5 tokens: `a op b = c`)
- [ ] Correct target equation: green glow, particles, score +100 (+50 if streak >= 3)
- [ ] Already-found equation: info toast, no score
- [ ] Valid but non-target equation: info toast, no score
- [ ] Invalid equation: red glow, shake animation, streak resets
- [ ] Backtracking: touching the previous node in the chain undoes the last addition
- [ ] Equation evaluation uses left-to-right order (no operator precedence)
- [ ] Commutative matching: `3 + 2 = 5` matches target `2 + 3 = 5`
- [ ] Level generation always produces solvable puzzles with guaranteed target equations
- [ ] Hint system: 3 hints per level, highlights nodes of an unsolved target equation
- [ ] Streak tracks consecutive correct target equations, resets on invalid
- [ ] Target display panel shows all required equations with progress indicators
- [ ] Level completes when all target equations are found
- [ ] Level complete awards +500 bonus points and celebration particles
- [ ] 5 worlds with 10 levels each (50 levels total)
- [ ] Event bus emits: `GameStarted`, `AnswerGiven`, `StreakAchieved`, `LevelCompleted`, `GameEnded`
- [ ] FactTracker records every equation attempt with timing data
- [ ] RewardService awards scales based on correct equations, streaks, and completion
- [ ] Pause overlay pauses and hides equation details
- [ ] Game registers with `GameRegistry` and appears correctly on the hub
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] Game feels satisfying and puzzles are fairly generated

---

## 3. Architecture Overview

### How Flame Integrates with Flutter

Dragon Runes uses a Flame `FlameGame` embedded in Flutter via `GameWidget`, following
the same pattern as Dragon Eggs and Fire Trail. The circular node layout, connection
lines, and particle effects are Flame components. The HUD (target equations, score,
hints, streak), and overlays are Flutter widgets.

```
+------------------------------------------------------+
|                 GameShell (Flutter)                    |
|  +--------------------------------------------------+|
|  |  HUD Bar: Pause | Title | Scales                 ||
|  +--------------------------------------------------+|
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |  Target Equations Panel (Flutter)           |   ||
|  |  |  [x] 2 + 3 = 5                             |   ||
|  |  |  [ ] ? + ? = ?                              |   ||
|  |  |  [ ] ? + ? = ?                              |   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |                                              |   ||
|  |  |       FlameGame (GameWidget)                 |   ||
|  |  |                                              |   ||
|  |  |          (7)   (3)   (+)                     |   ||
|  |  |       (2)               (=)                  |   ||
|  |  |          (5)   (4)   (-)                     |   ||
|  |  |                                              |   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |  Chain: [ 2 ] [ + ] [ 3 ] [ = ] [ 5 ]      |   ||
|  |  +--------------------------------------------+   ||
|  |                                                    ||
|  |  +--------------------------------------------+   ||
|  |  |  Score: 300  |  Streak: x3  | Hints: 2/3   |   ||
|  |  |  Progress: [======----] 3/5 found           |   ||
|  |  +--------------------------------------------+   ||
|  +--------------------------------------------------+|
+------------------------------------------------------+
```

### Key Design Decisions

1. **Flame for nodes, lines, and effects.** The circular node layout, drag connection
   lines, particle effects, and hint highlights are Flame `PositionComponent`s. The
   game loop handles touch detection and animation.

2. **Flutter for targets, chain display, and HUD.** The target equation panel, current
   chain display, score/streak/hints, and overlays are Flutter widgets. This provides
   better text layout and scrollability for the target list.

3. **Untimed puzzle gameplay.** Unlike Fire Trail (real-time action) and Dragon Eggs
   (physics-based), Dragon Runes is a relaxed, untimed puzzle. The player can take as
   long as they want to find equations. This makes it accessible to younger players and
   a good "wind-down" game.

4. **Communication via callbacks.** Same pattern as Fire Trail and Dragon Eggs — the
   Flame game exposes callbacks (`onEquationValidated`, `onLevelComplete`, etc.) that
   the Flutter wrapper listens to and relays to the EventBus.

5. **Left-to-right evaluation.** The original uses left-to-right evaluation without
   operator precedence (e.g., `2 + 3 * 4 = 20` because `(2+3)*4 = 20`). We preserve
   this behavior — it's simpler for young players and the level generator already
   accounts for it.

---

## 4. Original Game Mechanics Reference

The original Number Links (`numberLinks.html`) is a canvas-based HTML5 game. Key
constants and mechanics to port:

### Core Constants (from original)

| Constant | Original Value | Dragon Runes Equivalent | Notes |
|----------|---------------|------------------------|-------|
| Canvas size | 400px (responsive) | Scale to screen | Dynamic based on available space |
| Circle radius | 140px (35% of canvas) | 35% of game area | Same proportion |
| Node visual radius | 28px (responsive) | Scale proportionally | 6.5% of game area, min 24dp |
| Snap/touch radius | 44px (1.6x visual) | 1.6x visual radius | For touch detection |
| Min chain length | 5 tokens | 5 tokens | `a op b = c` |
| Correct target score | 100 points | 100 points | Base score per equation |
| Streak bonus | +50 at streak >= 3 | +50 at streak >= 3 | Same threshold |
| Level complete bonus | 500 points | 500 points | Completion reward |
| Hints per level | 3 | 3 | Reset each level |
| Hint duration | 2 seconds | 2 seconds | Highlight time |
| Feedback duration | 0.4-0.6 seconds | 0.4-0.6 seconds | Correct/incorrect flash |
| Shake duration | 0.3 seconds | 0.3 seconds | Error animation |
| Max mult product | 144 | 144 | Cap on multiplication results |
| Celebration bursts | 5 x 30 particles | 5 x 30 particles | Level complete effect |

### Key Behaviors to Preserve

- **Circular node layout:** Nodes arranged evenly around a circle perimeter. Numbers,
  operators, and one equals sign.
- **Drag-to-connect:** Touch a node, drag across others to build a chain. Visual line
  follows the chain path.
- **Backtracking:** If the user drags back to the previous node in the chain, the last
  node is removed (undo).
- **Left-to-right evaluation:** No operator precedence. `2+3*4` evaluates as `(2+3)*4=20`.
- **Commutative matching:** For `+` and `*`, both orderings match the same target
  (e.g., `3+2=5` matches target `2+3=5`).
- **Three match types:** Target match (score), already-found (info), bonus/valid but
  not target (info). Only invalid chains reset the streak.
- **Level generation guarantees:** The algorithm ensures all target equations are
  solvable from the provided nodes.
- **Target visibility:** Levels 1-10 show the operators in the target display.
  Levels 11+ hide the operators (shown as `?`).

### Mechanics Changed from Original

| Original (Number Links) | Dragon Runes (Adaptation) | Rationale |
|-------------------------|--------------------------|-----------|
| 99+ levels, uncapped | 50 levels across 5 worlds | Clearer progression structure |
| Player configures ops before game | Operations locked to world/level | Progression-driven, not settings-driven |
| Single continuous session | Level-based with results screen | Fits the app's session design |
| localStorage high score | Full profile integration with scales | Part of the progression system |
| Menu-based level start | Hub -> level select -> play | Matches app navigation |

---

## 5. File Structure

### New Files

```
lib/games/
+-- dragon_runes/
|   +-- dragon_runes_game.dart            <- Replace placeholder with real game widget
|   +-- dragon_runes_flame_game.dart      <- Flame FlameGame subclass
|   +-- dragon_runes_registration.dart    <- MathDragonsGame implementation
|   +-- components/
|   |   +-- rune_node.dart                <- Individual rune node (number/op/equals)
|   |   +-- connection_line.dart          <- Glowing line between connected nodes
|   |   +-- spell_particle_effect.dart    <- Correct-equation celebration particles
|   |   +-- hint_highlight.dart           <- Pulsing gold highlight on hinted nodes
|   |   +-- circle_ring.dart              <- Background circle ring decoration
|   +-- systems/
|   |   +-- level_generator.dart          <- Puzzle generation (families, targets, nodes)
|   |   +-- equation_validator.dart       <- Chain validation and evaluation
|   |   +-- chain_manager.dart            <- Drag chain state and backtracking
|   +-- models/
|   |   +-- rune_level.dart               <- Level definition (families, targets, nodes)
|   |   +-- equation_target.dart          <- Target equation model
|   |   +-- rune_node_data.dart           <- Node data (value, type, position)
|   |   +-- dragon_runes_config.dart      <- Per-level difficulty configuration
|   +-- widgets/
|       +-- target_panel.dart             <- Flutter widget showing target equations
|       +-- chain_display.dart            <- Current chain display bar
|       +-- hint_button.dart              <- Hint button with remaining count
|       +-- score_streak_display.dart     <- Score, streak, and progress HUD
|       +-- level_complete_overlay.dart   <- Level complete celebration overlay
```

### Modified Files

| File | Change |
|------|--------|
| `lib/games/dragon_runes/dragon_runes_game.dart` | **Replace** placeholder with real game |
| `lib/app.dart` | Import and register DragonRunes game |
| `lib/l10n/app_en.arb` | Add Dragon Runes localization strings |

---

## 6. MathDragonsGame Implementation

### `lib/games/dragon_runes/dragon_runes_registration.dart`

```dart
import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragon_runes_game.dart';

class DragonRunesRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragon_runes';

  @override
  String get displayName => 'Dragon Runes';

  @override
  String get description => 'Connect ancient runes to cast spells';

  @override
  String get iconAsset => 'assets/images/games/dragon_runes/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragon_runes/env.png';

  @override
  Color get accentColor => DragonColors.runesAccent;

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
    levelCompletionBonus: 25,
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
    return DragonRunesScreen(context: context);
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
    minAccuracyForAdvance: 0.6,
    minProblemsPerLevel: 4,
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
registry.register(DragonRunesRegistration());
```

---

## 7. Flame Game Setup

### `lib/games/dragon_runes/dragon_runes_flame_game.dart`

The core Flame game class. Manages the circular layout, drag interaction, chain
validation, and visual effects. This is a slower-paced game than Fire Trail — no
game loop timing, just event-driven interaction.

```dart
import 'package:flame/game.dart';
import 'package:flame/events.dart';

class DragonRunesFlameGame extends FlameGame
    with PanDetector {
  // -- Configuration --
  final DragonRunesConfig config;
  final List<EquationTarget> targets;
  final List<RuneNodeData> nodeData;

  // -- Callbacks to Flutter --
  final void Function(EquationResult result) onEquationValidated;
  final void Function(int score) onScoreChanged;
  final void Function() onLevelComplete;

  // -- Layout --
  late double cx, cy;         // circle center
  late double cRadius;        // circle radius
  late double nodeRadius;     // visual node radius
  late double snapRadius;     // touch detection radius

  // -- Game State --
  List<int> chain = [];       // indices into nodeData
  bool isDragging = false;
  int streak = 0;
  int score = 0;
  Set<String> solvedTargets = {};

  // -- Visual State --
  List<RuneNode> nodeComponents = [];
  ConnectionLine? activeLine;
  double feedbackTimer = 0;
  FeedbackType? feedbackType;
  double shakeTimer = 0;
  List<HintHighlight> hintHighlights = [];

  DragonRunesFlameGame({
    required this.config,
    required this.targets,
    required this.nodeData,
    required this.onEquationValidated,
    required this.onScoreChanged,
    required this.onLevelComplete,
  });

  @override
  Future<void> onLoad() async {
    // Calculate layout dimensions based on available screen space
    final minDim = size.x < size.y ? size.x : size.y;
    cx = size.x / 2;
    cy = size.y / 2;
    cRadius = minDim * 0.35;
    nodeRadius = (minDim * 0.065).clamp(24.0, 36.0);
    snapRadius = nodeRadius * 1.6;

    // Add background circle ring
    add(CircleRing(cx: cx, cy: cy, radius: cRadius));

    // Create and position nodes
    _layoutNodes();
  }

  void _layoutNodes() {
    final n = nodeData.length;
    for (int i = 0; i < n; i++) {
      final angle = (i / n) * 2 * pi - pi / 2; // start at top
      final x = cx + cos(angle) * cRadius;
      final y = cy + sin(angle) * cRadius;

      final node = RuneNode(
        data: nodeData[i],
        index: i,
        nodeRadius: nodeRadius,
      )..position = Vector2(x, y);

      nodeComponents.add(node);
      add(node);
    }
  }

  // -- Touch Handling --

  @override
  void onPanStart(DragStartInfo info) {
    final nearest = _nearestNode(info.eventPosition.global);
    if (nearest != null) {
      isDragging = true;
      chain = [nearest];
      _updateNodeStates();
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isDragging) return;

    final nearest = _nearestNode(info.eventPosition.global);
    if (nearest == null) return;

    // Backtracking: if nearest is the previous node in chain, pop
    if (chain.length >= 2 && nearest == chain[chain.length - 2]) {
      chain.removeLast();
      _updateNodeStates();
      return;
    }

    // Forward: add if not the last node and not already in chain
    if (nearest != chain.last && !chain.contains(nearest)) {
      chain.add(nearest);
      _updateNodeStates();
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    isDragging = false;

    if (chain.length >= 5) {
      _validateChain();
    } else {
      _clearChain();
    }
  }

  int? _nearestNode(Vector2 point) {
    double minDist = snapRadius;
    int? nearest;
    for (int i = 0; i < nodeComponents.length; i++) {
      final dist = nodeComponents[i].position.distanceTo(point);
      if (dist < minDist) {
        minDist = dist;
        nearest = i;
      }
    }
    return nearest;
  }

  // ... validation, effects, scoring
}
```

---

## 8. Circular Node Layout

### Layout Geometry

Nodes are arranged evenly around a circle perimeter. The circle is centered in the
game area with the layout scaling to fit the available screen space.

```dart
class CircleRing extends PositionComponent {
  final double cx, cy, radius;

  @override
  void render(Canvas canvas) {
    // Subtle ring outline
    final ringPaint = Paint()
      ..color = const Color(0xFF9B59B6).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // Inner glow ring
    final glowPaint = Paint()
      ..color = const Color(0xFF9B59B6).withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawCircle(Offset(cx, cy), radius, glowPaint);
  }
}
```

### Node Positioning Algorithm

```dart
/// Position N nodes evenly around a circle.
/// Starts at the top (12 o'clock) and proceeds clockwise.
void _layoutNodes() {
  final n = nodeData.length;
  for (int i = 0; i < n; i++) {
    final angle = (i / n) * 2 * pi - pi / 2;
    final x = cx + cos(angle) * cRadius;
    final y = cy + sin(angle) * cRadius;
    // ...
  }
}
```

### Node Types and Rendering

Three types of nodes, visually distinct:

```dart
enum RuneNodeType { number, operator, equals }

class RuneNodeData {
  final RuneNodeType type;
  final String value;     // "7", "+", "="
  final int numericValue; // 7 for numbers, -1 for ops/equals

  const RuneNodeData({
    required this.type,
    required this.value,
    this.numericValue = -1,
  });
}
```

### Rune Node Component

```dart
class RuneNode extends PositionComponent {
  final RuneNodeData data;
  final int index;
  final double nodeRadius;
  NodeState state;  // idle, inChain, correct, incorrect, hinted

  @override
  void render(Canvas canvas) {
    final center = Offset(0, 0);

    // Glow for non-idle states
    if (state == NodeState.inChain) {
      _drawGlow(canvas, center, const Color(0xFF66E3FF), 0.3);
    } else if (state == NodeState.correct) {
      _drawGlow(canvas, center, const Color(0xFF9EFF6A), 0.4);
    } else if (state == NodeState.incorrect) {
      _drawGlow(canvas, center, const Color(0xFFFF6B6B), 0.4);
    } else if (state == NodeState.hinted) {
      _drawGlow(canvas, center, const Color(0xFFFFD54A), _hintPulse());
    }

    // Node background
    final Color bgStart, bgEnd;
    switch (data.type) {
      case RuneNodeType.number:
        bgStart = const Color(0xFF1E2350);
        bgEnd = const Color(0xFF151A40);
        break;
      case RuneNodeType.operator:
        bgStart = const Color(0xFF2A2540);
        bgEnd = const Color(0xFF1A1530);
        break;
      case RuneNodeType.equals:
        bgStart = const Color(0xFF3A3520);
        bgEnd = const Color(0xFF2A2510);
        break;
    }

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [bgStart, bgEnd],
      ).createShader(Rect.fromCircle(center: center, radius: nodeRadius));
    canvas.drawCircle(center, nodeRadius, bgPaint);

    // Border
    final borderColor = state == NodeState.inChain
        ? const Color(0xFF66E3FF)
        : state == NodeState.correct
            ? const Color(0xFF9EFF6A)
            : state == NodeState.incorrect
                ? const Color(0xFFFF6B6B)
                : const Color(0xFF4A4A6A);
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, nodeRadius, borderPaint);

    // Text
    final textColor = data.type == RuneNodeType.number
        ? Colors.white
        : const Color(0xFFF4A261); // gold for operators
    _drawText(canvas, data.value, textColor);
  }

  void _drawGlow(Canvas canvas, Offset center, Color color, double alpha) {
    final glowPaint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, nodeRadius + 6, glowPaint);
  }

  double _hintPulse() {
    // Pulsing alpha for hint highlight
    return 0.3 + 0.3 * sin(hintAnimTime * 10);
  }
}

enum NodeState { idle, inChain, correct, incorrect, hinted }
```

---

## 9. Drag-to-Connect Mechanics

### Chain Building

The chain is a list of node indices. As the player drags, nodes within the snap
radius are added to the chain.

```dart
class ChainManager {
  List<int> chain = [];
  bool isDragging = false;

  /// Start a new chain at the given node index.
  void start(int nodeIndex) {
    chain = [nodeIndex];
    isDragging = true;
  }

  /// Try to extend the chain with a new node.
  /// Returns the action taken (added, backtracked, or ignored).
  ChainAction extend(int nodeIndex) {
    if (!isDragging || chain.isEmpty) return ChainAction.ignored;

    // Backtracking: touching previous node undoes last addition
    if (chain.length >= 2 && nodeIndex == chain[chain.length - 2]) {
      chain.removeLast();
      return ChainAction.backtracked;
    }

    // Prevent re-adding last node or any node already in chain
    if (nodeIndex == chain.last) return ChainAction.ignored;
    if (chain.contains(nodeIndex)) return ChainAction.ignored;

    chain.add(nodeIndex);
    return ChainAction.added;
  }

  /// End the chain. Returns the chain if long enough for validation.
  List<int>? end() {
    isDragging = false;
    if (chain.length >= 5) {
      final result = List<int>.from(chain);
      chain = [];
      return result;
    }
    chain = [];
    return null;
  }

  /// Clear without validation.
  void clear() {
    chain = [];
    isDragging = false;
  }
}

enum ChainAction { added, backtracked, ignored }
```

### Connection Line Rendering

A glowing line is drawn between connected nodes in the chain, continuing to the
current pointer position during active drags.

```dart
class ConnectionLine extends PositionComponent {
  final List<Vector2> points;  // node centers in chain order
  final Vector2? pointerPos;   // current pointer during active drag

  @override
  void render(Canvas canvas) {
    if (points.length < 2 && pointerPos == null) return;

    final allPoints = [...points];
    if (pointerPos != null) allPoints.add(pointerPos!);

    // Glow line (wider, semi-transparent)
    final glowPaint = Paint()
      ..color = const Color(0xFF66E3FF).withValues(alpha: 0.2)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Main line (thinner, full opacity)
    final mainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFBB8FCE), Color(0xFFF7C08A)],  // purple -> gold
      ).createShader(Rect.fromLTRB(
        allPoints.first.x, allPoints.first.y,
        allPoints.last.x, allPoints.last.y,
      ))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(allPoints[0].x, allPoints[0].y);
    for (int i = 1; i < allPoints.length; i++) {
      path.lineTo(allPoints[i].x, allPoints[i].y);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, mainPaint);
  }
}
```

### Touch Detection

The snap radius is 1.6x the visual node radius, matching the original. This provides
a generous touch target while preventing ambiguity between adjacent nodes.

```dart
int? _nearestNode(Vector2 point) {
  double minDist = snapRadius;
  int? nearest;
  for (int i = 0; i < nodeComponents.length; i++) {
    final dist = nodeComponents[i].position.distanceTo(point);
    if (dist < minDist) {
      minDist = dist;
      nearest = i;
    }
  }
  return nearest;
}
```

---

## 10. Equation Validation

### Validation Pipeline

The equation validator takes a chain of node indices, extracts tokens, finds the
equals sign, evaluates both sides, and matches against target equations.

```dart
class EquationValidator {
  final List<RuneNodeData> nodes;
  final List<EquationTarget> targets;
  final Set<String> solvedTargets;

  EquationValidator({
    required this.nodes,
    required this.targets,
    required this.solvedTargets,
  });

  /// Validate a chain of node indices.
  EquationResult validate(List<int> chain) {
    // 1. Extract tokens from chain
    final tokens = chain.map((i) => nodes[i].value).toList();

    // 2. Find '=' position
    final eqIndex = tokens.indexOf('=');
    if (eqIndex < 0) return EquationResult.invalid;

    // 3. Split into LHS and RHS
    final lhs = tokens.sublist(0, eqIndex);
    final rhs = tokens.sublist(eqIndex + 1);

    if (lhs.isEmpty || rhs.isEmpty) return EquationResult.invalid;

    // 4. Evaluate both sides (left-to-right, no precedence)
    final lhsValue = _evalExpr(lhs);
    final rhsValue = _evalExpr(rhs);

    if (lhsValue == null || rhsValue == null) return EquationResult.invalid;
    if (lhsValue != rhsValue) return EquationResult.invalid;

    // 5. Build canonical form and match against targets
    final canonical = _canonicalForm(lhs, rhs);
    final swapped = _commutativeSwap(canonical);

    // Check against targets
    for (final target in targets) {
      if (target.canonical == canonical || target.canonical == swapped) {
        if (solvedTargets.contains(target.canonical)) {
          return EquationResult.alreadyFound;
        }
        return EquationResult.targetMatch(target);
      }
    }

    // Valid equation but not a target
    return EquationResult.bonus;
  }

  /// Evaluate an expression left-to-right without operator precedence.
  double? _evalExpr(List<String> tokens) {
    if (tokens.isEmpty) return null;

    final first = double.tryParse(tokens[0]);
    if (first == null) return null;

    double result = first;

    for (int i = 1; i < tokens.length; i += 2) {
      if (i + 1 >= tokens.length) return null;

      final op = tokens[i];
      final b = double.tryParse(tokens[i + 1]);
      if (b == null) return null;

      switch (op) {
        case '+': result = result + b;
        case '\u2212': // minus sign
        case '-': result = result - b;
        case '\u00D7': // multiplication sign
        case '*':
        case 'x': result = result * b;
        case '\u00F7': // division sign
        case '/':
          if (b == 0) return null;
          result = result / b;
        default: return null;
      }
    }

    // Must be integer result
    if (result != result.roundToDouble()) return null;
    if (result < 0) return null;

    return result;
  }

  /// Build canonical form: longer side first, "a+b=c" format.
  String _canonicalForm(List<String> lhs, List<String> rhs) {
    final lhsStr = lhs.join('');
    final rhsStr = rhs.join('');
    if (lhs.length >= rhs.length) {
      return '$lhsStr=$rhsStr';
    }
    return '$rhsStr=$lhsStr';
  }

  /// Swap commutative operators for matching.
  /// "3+2=5" -> "2+3=5" (try both when matching)
  String? _commutativeSwap(String canonical) {
    // Match pattern: "a OP b = c" where OP is + or *
    final match = RegExp(r'^(\d+)([+*\u00D7])(\d+)=(\d+)$').firstMatch(canonical);
    if (match == null) return null;

    final a = match.group(1)!;
    final op = match.group(2)!;
    final b = match.group(3)!;
    final c = match.group(4)!;

    if (a == b) return null; // no need to swap

    return '$b$op$a=$c';
  }
}

/// Result of validating an equation chain.
sealed class EquationResult {
  static const invalid = InvalidEquation();
  static const alreadyFound = AlreadyFoundEquation();
  static const bonus = BonusEquation();
  static TargetMatchEquation targetMatch(EquationTarget t) =>
      TargetMatchEquation(target: t);
}

class InvalidEquation extends EquationResult { const InvalidEquation(); }
class AlreadyFoundEquation extends EquationResult { const AlreadyFoundEquation(); }
class BonusEquation extends EquationResult { const BonusEquation(); }
class TargetMatchEquation extends EquationResult {
  final EquationTarget target;
  const TargetMatchEquation({required this.target});
}
```

### Edge Cases

1. **Division by zero** → invalid
2. **Non-integer result** → invalid
3. **Negative result** → invalid
4. **No equals sign** → invalid
5. **Empty LHS or RHS** → invalid
6. **Chain too short (< 5)** → not validated (dropped silently)
7. **Already-solved target** → acknowledged but no score
8. **Valid non-target** → acknowledged but no score

---

## 11. Level Generation Algorithm

This is the most complex part of Dragon Runes. The algorithm must generate solvable
puzzles that guarantee all target equations can be formed from the provided nodes.

### Level Configuration Model

```dart
class DragonRunesConfig {
  final int levelNumber;
  final int worldNumber;
  final int levelInWorld;         // 1-10
  final int numberOfFamilies;     // 1-3 number families
  final int targetCount;          // number of target equations
  final int numberMin;
  final int numberMax;
  final List<MathOp> allowedOps;
  final bool showOpsInTargets;    // show operators in target panel

  const DragonRunesConfig({
    required this.levelNumber,
    required this.worldNumber,
    required this.levelInWorld,
    required this.numberOfFamilies,
    required this.targetCount,
    required this.numberMin,
    required this.numberMax,
    required this.allowedOps,
    required this.showOpsInTargets,
  });
}
```

### Generation Pipeline

```dart
class LevelGenerator {
  final Random random;

  LevelGenerator({Random? random}) : random = random ?? Random();

  /// Generate a complete level: nodes and target equations.
  GeneratedLevel generate(DragonRunesConfig config) {
    // 1. Generate number families
    final families = _generateFamilies(config);

    // 2. Generate all equations from families
    final allEquations = <Equation>[];
    final numberCounts = <int, int>{};  // track how many of each number needed

    for (final family in families) {
      final eqs = _familyEquations(family, config.allowedOps);
      allEquations.addAll(eqs);

      // Track max occurrence of each number across all equations
      for (final eq in eqs) {
        for (final num in eq.numbers) {
          numberCounts[num] = max(numberCounts[num] ?? 0,
              eq.numbers.where((n) => n == num).length);
        }
      }
    }

    // 3. Select balanced targets
    final targets = _pickTargets(allEquations, config.targetCount, config.allowedOps);

    // 4. Recalculate node counts from selected targets
    final targetNumberCounts = <int, int>{};
    for (final target in targets) {
      for (final num in target.numbers) {
        final neededInThisEq = target.numbers.where((n) => n == num).length;
        targetNumberCounts[num] = max(
            targetNumberCounts[num] ?? 0, neededInThisEq);
      }
    }

    // 5. Build node list
    final nodeList = <RuneNodeData>[];

    // Add number nodes
    for (final entry in targetNumberCounts.entries) {
      for (int i = 0; i < entry.value; i++) {
        nodeList.add(RuneNodeData(
          type: RuneNodeType.number,
          value: '${entry.key}',
          numericValue: entry.key,
        ));
      }
    }

    // Add operator nodes (all ops used in targets + all enabled ops)
    final usedOps = <String>{};
    for (final target in targets) {
      usedOps.add(target.opSymbol);
    }
    for (final op in config.allowedOps) {
      usedOps.add(_opToSymbol(op));
    }
    for (final op in usedOps) {
      nodeList.add(RuneNodeData(
        type: RuneNodeType.operator,
        value: op,
      ));
    }

    // Add equals node
    nodeList.add(const RuneNodeData(
      type: RuneNodeType.equals,
      value: '=',
    ));

    // 6. Shuffle nodes
    nodeList.shuffle(random);

    // 7. Enumerate all valid equations (for bonus detection)
    final allValid = _enumerateAllValidEquations(nodeList);

    return GeneratedLevel(
      nodes: nodeList,
      targets: targets.map((e) => EquationTarget(
        canonical: e.canonical,
        displayText: e.displayText,
      )).toList(),
      allValidEquations: allValid,
    );
  }

  /// Generate number families (pairs a, b) for the level.
  List<NumberFamily> _generateFamilies(DragonRunesConfig config) {
    final families = <NumberFamily>[];
    final usedPairs = <String>{};
    final usedNumbers = <int>{};

    for (int f = 0; f < config.numberOfFamilies; f++) {
      for (int attempt = 0; attempt < 300; attempt++) {
        int a, b;

        // After the first family, 80% chance to reuse a number
        if (f > 0 && usedNumbers.isNotEmpty && random.nextDouble() < 0.8) {
          a = usedNumbers.elementAt(random.nextInt(usedNumbers.length));
          b = config.numberMin + random.nextInt(config.numberMax - config.numberMin + 1);
        } else {
          a = config.numberMin + random.nextInt(config.numberMax - config.numberMin + 1);
          b = config.numberMin + random.nextInt(config.numberMax - config.numberMin + 1);
        }

        // Normalize: smaller first
        if (a > b) { final t = a; a = b; b = t; }

        // Skip duplicates
        final pairKey = '$a,$b';
        if (usedPairs.contains(pairKey)) continue;

        // Skip a==b for single-op single-family (too trivial)
        if (config.numberOfFamilies == 1 &&
            config.allowedOps.length == 1 &&
            a == b) continue;

        // Skip if both <= 1 and multiplication is an option
        if (a <= 1 && b <= 1 &&
            config.allowedOps.contains(MathOp.multiply)) continue;

        usedPairs.add(pairKey);
        usedNumbers.add(a);
        usedNumbers.add(b);
        families.add(NumberFamily(a: a, b: b));
        break;
      }
    }

    // Fallback: if generation failed, force simple addition family
    if (families.isEmpty) {
      families.add(const NumberFamily(a: 1, b: 2));
    }

    return families;
  }

  /// Generate all valid equations from a number family.
  List<Equation> _familyEquations(NumberFamily family, List<MathOp> ops) {
    final equations = <Equation>[];
    final a = family.a;
    final b = family.b;

    for (final op in ops) {
      switch (op) {
        case MathOp.add:
          final c = a + b;
          equations.add(Equation.fromParts(a, '+', b, c));
          if (a != b) equations.add(Equation.fromParts(b, '+', a, c));
          break;

        case MathOp.subtract:
          final c = a + b;
          equations.add(Equation.fromParts(c, '\u2212', a, b));
          if (a != b) equations.add(Equation.fromParts(c, '\u2212', b, a));
          break;

        case MathOp.multiply:
          if (a <= 1 && b <= 1) break;
          final product = a * b;
          if (product > 144) break;
          equations.add(Equation.fromParts(a, '\u00D7', b, product));
          if (a != b) equations.add(Equation.fromParts(b, '\u00D7', a, product));
          break;

        case MathOp.divide:
          final product = a * b;
          if (product > 144) break;
          if (a > 0) equations.add(Equation.fromParts(product, '\u00F7', a, b));
          if (b > 0 && a != b) {
            equations.add(Equation.fromParts(product, '\u00F7', b, a));
          }
          break;
      }
    }

    return equations;
  }

  /// Select a balanced set of target equations.
  /// Ensures at least one equation per enabled operation type.
  List<Equation> _pickTargets(
    List<Equation> pool,
    int count,
    List<MathOp> ops,
  ) {
    if (pool.length <= count) return List.from(pool);

    final selected = <Equation>[];
    final remaining = List<Equation>.from(pool);

    // Phase 1: Pick one per operation type for diversity
    for (final op in ops) {
      final opSymbol = _opToSymbol(op);
      final candidates = remaining.where((e) => e.opSymbol == opSymbol).toList();
      if (candidates.isNotEmpty && selected.length < count) {
        final pick = candidates[random.nextInt(candidates.length)];
        selected.add(pick);
        remaining.remove(pick);
      }
    }

    // Phase 2: Fill remaining slots randomly
    remaining.shuffle(random);
    while (selected.length < count && remaining.isNotEmpty) {
      selected.add(remaining.removeAt(0));
    }

    return selected;
  }
}
```

### Number Family Model

```dart
class NumberFamily {
  final int a;
  final int b;

  const NumberFamily({required this.a, required this.b});
}
```

### Equation Model

```dart
class Equation {
  final int left;
  final String op;
  final int right;
  final int result;
  final String canonical;
  final String displayText;
  final String opSymbol;

  Equation.fromParts(this.left, this.opSymbol, this.right, this.result)
      : op = opSymbol,
        displayText = '$left $opSymbol $right = $result',
        canonical = _buildCanonical(left, opSymbol, right, result);

  List<int> get numbers => [left, right, result];

  static String _buildCanonical(int l, String op, int r, int res) {
    // Commutative ops: smaller operand first
    if ((op == '+' || op == '\u00D7') && l > r) {
      return '$r$op$l=$res';
    }
    return '$l$op$r=$res';
  }
}
```

### Equation Target Model

```dart
class EquationTarget {
  final String canonical;      // normalized form for matching
  final String displayText;    // human-readable form

  const EquationTarget({
    required this.canonical,
    required this.displayText,
  });
}
```

---

## 12. Hint System

### Hint Mechanics

3 hints are available per level. Each hint highlights the nodes that form one
unsolved target equation, pulsing with a gold glow for 2 seconds.

```dart
class HintManager {
  int remaining;
  final List<EquationTarget> targets;
  final Set<String> solvedTargets;
  final List<RuneNodeData> nodes;

  HintManager({
    required this.targets,
    required this.solvedTargets,
    required this.nodes,
    this.remaining = 3,
  });

  /// Use a hint. Returns the node indices to highlight, or null if no hints left
  /// or all targets are solved.
  List<int>? useHint() {
    if (remaining <= 0) return null;

    // Find first unsolved target
    final unsolved = targets.firstWhere(
      (t) => !solvedTargets.contains(t.canonical),
      orElse: () => EquationTarget(canonical: '', displayText: ''),
    );
    if (unsolved.canonical.isEmpty) return null;

    remaining--;

    // Parse the target equation to find matching nodes
    return _findNodesForEquation(unsolved);
  }

  /// Find node indices that can form the given equation.
  List<int>? _findNodesForEquation(EquationTarget target) {
    // Parse canonical form back into tokens
    final tokens = _tokenize(target.canonical);
    if (tokens == null) return null;

    final indices = <int>[];
    final usedIndices = <int>{};

    for (final token in tokens) {
      // Find a matching unused node
      int? found;
      for (int i = 0; i < nodes.length; i++) {
        if (usedIndices.contains(i)) continue;
        if (nodes[i].value == token) {
          found = i;
          break;
        }
      }
      if (found == null) return null;
      indices.add(found);
      usedIndices.add(found);
    }

    return indices;
  }

  List<String>? _tokenize(String canonical) {
    // Split "2+3=5" into ["2", "+", "3", "=", "5"]
    final result = <String>[];
    final buffer = StringBuffer();

    for (final char in canonical.runes) {
      final c = String.fromCharCode(char);
      if (RegExp(r'[0-9]').hasMatch(c)) {
        buffer.write(c);
      } else {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
        result.add(c);
      }
    }
    if (buffer.isNotEmpty) result.add(buffer.toString());

    return result.length >= 5 ? result : null;
  }
}
```

### Hint Visual Feedback

Hinted nodes pulse with a gold circle for 2 seconds:

```dart
class HintHighlight extends PositionComponent {
  static const double duration = 2.0;
  double elapsed = 0;
  final double nodeRadius;

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;
    if (elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final alpha = 0.3 + 0.3 * sin(elapsed * 10);
    final paint = Paint()
      ..color = Color.fromRGBO(255, 213, 74, alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, nodeRadius + 12, paint);
  }
}
```

---

## 13. Streak & Scoring

### Scoring System

```dart
class ScoringManager {
  int score = 0;
  int streak = 0;
  int bestStreak = 0;
  int equationsFound = 0;
  int totalAttempts = 0;

  static const int correctBase = 100;
  static const int streakBonus = 50;
  static const int streakThreshold = 3;
  static const int levelCompleteBonus = 500;

  /// Handle a validated equation result.
  ScoringOutcome handleResult(EquationResult result) {
    totalAttempts++;

    switch (result) {
      case TargetMatchEquation(:final target):
        streak++;
        bestStreak = max(bestStreak, streak);
        equationsFound++;
        final bonus = streak >= streakThreshold ? streakBonus : 0;
        final points = correctBase + bonus;
        score += points;
        return ScoringOutcome.correct(
          points: points,
          streak: streak,
          hadStreakBonus: bonus > 0,
        );

      case InvalidEquation():
        streak = 0;
        return ScoringOutcome.incorrect();

      case AlreadyFoundEquation():
        // Don't break streak, don't add score
        return ScoringOutcome.alreadyFound();

      case BonusEquation():
        // Don't break streak, don't add score
        return ScoringOutcome.bonus();
    }
  }

  /// Add level complete bonus.
  int completeLevelBonus() {
    score += levelCompleteBonus;
    return levelCompleteBonus;
  }
}

class ScoringOutcome {
  final ScoringOutcomeType type;
  final int points;
  final int streak;
  final bool hadStreakBonus;

  const ScoringOutcome._({
    required this.type,
    this.points = 0,
    this.streak = 0,
    this.hadStreakBonus = false,
  });

  factory ScoringOutcome.correct({
    required int points,
    required int streak,
    required bool hadStreakBonus,
  }) => ScoringOutcome._(
    type: ScoringOutcomeType.correct,
    points: points,
    streak: streak,
    hadStreakBonus: hadStreakBonus,
  );

  factory ScoringOutcome.incorrect() =>
      const ScoringOutcome._(type: ScoringOutcomeType.incorrect);

  factory ScoringOutcome.alreadyFound() =>
      const ScoringOutcome._(type: ScoringOutcomeType.alreadyFound);

  factory ScoringOutcome.bonus() =>
      const ScoringOutcome._(type: ScoringOutcomeType.bonus);
}

enum ScoringOutcomeType { correct, incorrect, alreadyFound, bonus }
```

### Streak Behavior

- **Increments** on each correct target equation found
- **Resets to 0** on invalid equation
- **Does NOT reset** on already-found or bonus equations
- **Bonus** at streak >= 3: +50 points per correct equation
- **Streak milestones** at 5, 10, 15... trigger EventBus emission and celebration

---

## 14. Visual Effects & Spell Casting

### Correct Equation — Spell Cast Effect

When a target equation is completed, purple and gold particles burst from the
chain nodes. This is the signature "spell casting" effect.

```dart
class SpellParticleEffect extends PositionComponent {
  static const int particlesPerNode = 8;
  static const double lifetime = 0.8;

  final List<Vector2> nodePositions;  // centers of chain nodes
  final List<_SpellParticle> particles = [];

  @override
  void onLoad() {
    for (final pos in nodePositions) {
      for (int i = 0; i < particlesPerNode; i++) {
        final angle = random.nextDouble() * 2 * pi;
        final speed = 60 + random.nextDouble() * 180;
        final isGold = random.nextDouble() < 0.4;
        particles.add(_SpellParticle(
          x: pos.x,
          y: pos.y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          life: 0.5 + random.nextDouble() * 0.4,
          color: isGold
              ? const Color(0xFFF4A261)   // gold
              : const Color(0xFFBB8FCE),  // purple
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 40 * dt;  // slight gravity
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

### Level Complete Celebration

5 bursts of 30 particles each, staggered over 1 second:

```dart
void _triggerLevelCompleteCelebration() {
  for (int burst = 0; burst < 5; burst++) {
    Future.delayed(Duration(milliseconds: burst * 200), () {
      final x = cx + (random.nextDouble() - 0.5) * cRadius * 2;
      final y = cy + (random.nextDouble() - 0.5) * cRadius * 2;
      add(SpellParticleEffect(
        nodePositions: [Vector2(x, y)],
        particleCount: 30,
      ));
    });
  }
}
```

### Invalid Equation — Shake Effect

The entire game area shakes briefly on invalid equations:

```dart
// In update():
if (shakeTimer > 0) {
  shakeTimer -= dt;
  final shakeAmount = 6.0 * (shakeTimer / 0.3);
  final shakeX = sin(shakeTimer * 40) * shakeAmount;
  final shakeY = cos(shakeTimer * 30) * shakeAmount * 0.5;
  // Apply offset to all rendered components
}
```

### Feedback Flash

Nodes in the chain flash green (correct) or red (incorrect) for 0.4-0.6 seconds:

```dart
void _showFeedback(List<int> chainIndices, bool isCorrect) {
  final state = isCorrect ? NodeState.correct : NodeState.incorrect;
  for (final idx in chainIndices) {
    nodeComponents[idx].state = state;
  }
  feedbackTimer = isCorrect ? 0.6 : 0.4;
  feedbackType = isCorrect ? FeedbackType.correct : FeedbackType.incorrect;
}

// In update():
if (feedbackTimer > 0) {
  feedbackTimer -= dt;
  if (feedbackTimer <= 0) {
    for (final node in nodeComponents) {
      if (node.state == NodeState.correct || node.state == NodeState.incorrect) {
        node.state = NodeState.idle;
      }
    }
  }
}
```

---

## 15. Difficulty & World Progression

### 5-World Level Structure

Each world has 10 levels. Number families, operations, ranges, and target counts
increase across worlds.

```dart
class DragonRunesConfig {
  final int levelNumber;
  final int worldNumber;
  final int levelInWorld;
  final int numberOfFamilies;
  final int targetCount;
  final int numberMin;
  final int numberMax;
  final List<MathOp> allowedOps;
  final bool showOpsInTargets;
}
```

### World Definitions

| World | Name | Levels | Ops | Number Range | Families | Targets | Show Ops |
|-------|------|--------|-----|-------------|----------|---------|----------|
| 1 | Ember Equations | 1-10 | + | 1-5 -> 1-8 | 1 -> 2 | 2 -> 4 | Yes |
| 2 | Flame Formulas | 11-20 | +, - | 1-8 -> 1-10 | 2 | 4 -> 6 | Lvls 11-20: No |
| 3 | Inferno Algebra | 21-30 | +, -, x | 2-10 -> 2-12 | 2 -> 3 | 6 -> 8 | No |
| 4 | Dragon's Calculus | 31-40 | +, -, x, / | 2-12 -> 2-15 | 3 | 8 -> 10 | No |
| 5 | Elder Runes | 41-50 | +, -, x, / | 2-15 | 3 | 10 -> 12 | No |

### Level Generation Config

```dart
static List<GameLevel> _generateLevels() {
  final levels = <GameLevel>[];

  // World 1: Ember Equations (Levels 1-10)
  for (int i = 1; i <= 10; i++) {
    final t = (i - 1) / 9; // 0.0 to 1.0
    levels.add(GameLevel(
      levelNumber: i,
      name: 'Ember Equations $i',
      worldName: 'Ember Equations',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: _lerp(5, 8, t).round(),
        operations: {MathOperation.addition},
        speedMultiplier: 1.0,
      ),
      starsRequired: i > 1 ? 1 : 0,
    ));
  }

  // World 2: Flame Formulas (Levels 11-20)
  for (int i = 1; i <= 10; i++) {
    final t = (i - 1) / 9;
    levels.add(GameLevel(
      levelNumber: 10 + i,
      name: 'Flame Formulas $i',
      worldName: 'Flame Formulas',
      params: DifficultyParams(
        numberMin: 1,
        numberMax: _lerp(8, 10, t).round(),
        operations: {MathOperation.addition, MathOperation.subtraction},
        speedMultiplier: 1.0,
      ),
      starsRequired: 1,
    ));
  }

  // World 3: Inferno Algebra (Levels 21-30)
  for (int i = 1; i <= 10; i++) {
    final t = (i - 1) / 9;
    levels.add(GameLevel(
      levelNumber: 20 + i,
      name: 'Inferno Algebra $i',
      worldName: 'Inferno Algebra',
      params: DifficultyParams(
        numberMin: 2,
        numberMax: _lerp(10, 12, t).round(),
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

  // World 4: Dragon's Calculus (Levels 31-40)
  for (int i = 1; i <= 10; i++) {
    final t = (i - 1) / 9;
    levels.add(GameLevel(
      levelNumber: 30 + i,
      name: "Dragon's Calculus $i",
      worldName: "Dragon's Calculus",
      params: DifficultyParams(
        numberMin: 2,
        numberMax: _lerp(12, 15, t).round(),
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

  // World 5: Elder Runes (Levels 41-50)
  for (int i = 1; i <= 10; i++) {
    levels.add(GameLevel(
      levelNumber: 40 + i,
      name: 'Elder Runes $i',
      worldName: 'Elder Runes',
      params: DifficultyParams(
        numberMin: 2,
        numberMax: 15,
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

static double _lerp(double a, double b, double t) => a + (b - a) * t;
```

### Per-Level Config Derivation

The `DragonRunesConfig` for each level is derived from its `GameLevel` plus
world-specific parameters:

```dart
DragonRunesConfig configForLevel(int levelNumber) {
  final world = ((levelNumber - 1) ~/ 10) + 1;
  final levelInWorld = ((levelNumber - 1) % 10) + 1;
  final t = (levelInWorld - 1) / 9;

  int families;
  int targetCount;
  bool showOps;

  switch (world) {
    case 1:
      families = t < 0.5 ? 1 : 2;
      targetCount = _lerp(2, 4, t).round();
      showOps = true;
      break;
    case 2:
      families = 2;
      targetCount = _lerp(4, 6, t).round();
      showOps = false;
      break;
    case 3:
      families = t < 0.5 ? 2 : 3;
      targetCount = _lerp(6, 8, t).round();
      showOps = false;
      break;
    case 4:
      families = 3;
      targetCount = _lerp(8, 10, t).round();
      showOps = false;
      break;
    case 5:
      families = 3;
      targetCount = _lerp(10, 12, t).round();
      showOps = false;
      break;
    default:
      families = 1;
      targetCount = 2;
      showOps = true;
  }

  return DragonRunesConfig(
    levelNumber: levelNumber,
    worldNumber: world,
    levelInWorld: levelInWorld,
    numberOfFamilies: families,
    targetCount: targetCount,
    numberMin: ...,  // from GameLevel.params
    numberMax: ...,  // from GameLevel.params
    allowedOps: ..., // from GameLevel.params
    showOpsInTargets: showOps,
  );
}
```

### Target Display Visibility

- **Levels 1-10 (World 1):** Target equations show the operator: `2 + 3 = 5`
- **Levels 11+ (Worlds 2-5):** Target equations hide the operator: `2 ? 3 = 5`

This forces the player to figure out which operation is needed, adding difficulty.

---

## 16. Fact Tracking & Adaptive Selection

### Integration with FactTracker

On every equation attempt (correct target, invalid, bonus, already-found), record
the core math facts via the event bus:

```dart
void _recordAnswer(Equation equation, bool isCorrect, int responseTimeMs) {
  // Normalize the fact key: "2+3" (commutative: smaller first)
  final factKey = _buildFactKey(equation.left, equation.opSymbol, equation.right);

  eventBus.emit(AnswerGiven(
    gameId: 'dragon_runes',
    problem: factKey,
    playerAnswer: isCorrect ? '${equation.result}' : 'invalid',
    correctAnswer: '${equation.result}',
    correct: isCorrect,
    responseTimeMs: responseTimeMs,
  ));
}
```

### Response Time Tracking

For Dragon Runes, response time is measured from the last time a chain was released
(or the level started) to the next chain release. This captures "thinking time"
between equation attempts.

```dart
DateTime? _lastAttemptTime;

void _onLevelStart() {
  _lastAttemptTime = DateTime.now();
}

int _getResponseTimeMs() {
  if (_lastAttemptTime == null) return 0;
  final ms = DateTime.now().difference(_lastAttemptTime!).inMilliseconds;
  _lastAttemptTime = DateTime.now();
  return ms;
}
```

### Fact Key Format

Same normalization as other games:
- `"2+3"` (commutative: smaller first)
- `"5-2"` (non-commutative: left operand first)
- `"3x4"` (commutative: smaller first)
- `"12/3"` (non-commutative: dividend first)

---

## 17. Event Bus Integration

### Events Emitted

```dart
// On game start (entering a level)
eventBus.emit(GameStarted(gameId: 'dragon_runes', levelNumber: currentLevel));

// On every equation attempt (correct target or invalid)
eventBus.emit(AnswerGiven(
  gameId: 'dragon_runes',
  problem: factKey,
  playerAnswer: isCorrect ? '$result' : 'invalid',
  correctAnswer: '$result',
  correct: isCorrect,
  responseTimeMs: responseTimeMs,
));

// On streak milestones (5, 10, 15, ...)
if (streak > 0 && streak % 5 == 0) {
  eventBus.emit(StreakAchieved(gameId: 'dragon_runes', streakLength: streak));
}

// On level completion (all targets found)
eventBus.emit(LevelCompleted(
  gameId: 'dragon_runes',
  levelNumber: currentLevel,
  score: totalScore,
  stars: calculateStars(),
  accuracy: equationsFound / totalAttempts,
));

// On leaving the game (back to hub or session end)
eventBus.emit(GameEnded(
  gameId: 'dragon_runes',
  finalScore: totalScore,
  duration: gameDuration,
));
```

---

## 18. Game Flow & State Machine

### Game Phases

```dart
enum GamePhase { loading, playing, paused, levelComplete }
```

### Flow

```
App Start
  |
  v
Hub -> Tap Dragon Runes card
  |
  v
DragonRunesScreen mounts (Flutter)
  |
  v
GameShell wraps, emits GameStarted
  |
  v
LevelGenerator generates puzzle (nodes + targets)
  |
  v
GamePhase.playing
  |
  v
PLAYING LOOP (event-driven, not timed):
  |
  +-- Player drags across nodes to build a chain
  +-- Chain is visualized with glowing connection line
  +-- On release, if chain.length >= 5:
  |     +-- EquationValidator validates the chain
  |     +-- If TARGET MATCH:
  |     |     Score +100 (+50 if streak >= 3)
  |     |     Mark target as solved
  |     |     Streak++
  |     |     Green glow + spell particles
  |     |     Update target panel (checkmark)
  |     |     Check: all targets solved? -> level complete
  |     +-- If INVALID:
  |     |     Streak reset to 0
  |     |     Red glow + shake animation
  |     +-- If ALREADY FOUND:
  |     |     Info toast, no score change, streak unaffected
  |     +-- If BONUS (valid but not target):
  |           Info toast, no score change, streak unaffected
  +-- Player can use hints (3 per level)
  |     +-- Highlights nodes of an unsolved target
  |     +-- Gold pulsing glow for 2 seconds
  +-- Pause -> overlay with Resume / Settings / Quit
  |
  v (all targets found)
GamePhase.levelComplete
  |
  +-- Add +500 level complete bonus
  +-- 5 celebration particle bursts
  +-- Emit LevelCompleted event
  +-- 800ms delay
  |
  v
Show level complete overlay / ResultScreen
  |
  +-- "Next Level" -> generate next level puzzle
  +-- "Play Again" -> regenerate same level
  +-- "Back to Hub" -> Navigator.pop
```

### Star Calculation

Stars are based on accuracy (equations found vs total attempts) since Dragon Runes
is untimed:

```dart
int calculateStars(double accuracy, int hintsUsed) {
  // 3 stars: 90%+ accuracy with 0 hints used
  if (accuracy >= 0.9 && hintsUsed == 0) return 3;
  // 2 stars: 75%+ accuracy with <= 1 hint
  if (accuracy >= 0.75 && hintsUsed <= 1) return 2;
  // 1 star: completed (always earned on level complete)
  return 1;
}
```

---

## 19. Game Over & Results

### No Traditional "Game Over"

Unlike Fire Trail and Dragon Eggs, Dragon Runes has no game-over state. The player
can take as many attempts as they want to find all target equations. The game only
ends when:

1. **Level complete** — all target equations found (positive ending)
2. **Player quits** — via pause menu back to hub (session ends)

This design matches the puzzle nature of the game and makes it accessible to all ages.

### Level Complete Handling

```dart
void _checkLevelComplete() {
  if (solvedTargets.length >= targets.length) {
    phase = GamePhase.levelComplete;
    final bonus = scoring.completeLevelBonus();

    // Celebration effect
    _triggerLevelCompleteCelebration();

    // Emit event
    eventBus.emit(LevelCompleted(
      gameId: 'dragon_runes',
      levelNumber: currentLevel,
      score: scoring.score,
      stars: calculateStars(
        scoring.equationsFound / scoring.totalAttempts,
        3 - hintManager.remaining,
      ),
      accuracy: scoring.equationsFound / scoring.totalAttempts,
    ));

    // Show results after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      onLevelComplete();
    });
  }
}
```

### Result Screen Integration

```dart
void _showResults() {
  final results = GameResults(
    gameId: 'dragon_runes',
    score: scoring.score,
    accuracy: scoring.totalAttempts > 0
        ? scoring.equationsFound / scoring.totalAttempts
        : 0,
    streak: scoring.bestStreak,
    scalesEarned: scalesThisLevel,
    stars: calculateStars(...),
    levelNumber: currentLevel,
    problemsAttempted: scoring.totalAttempts,
    problemsCorrect: scoring.equationsFound,
  );

  showResultScreen(results);
}
```

---

## 20. HUD Elements

### Target Equations Panel (Flutter Widget)

Positioned above the game area. Shows all target equations with solved/unsolved status.

```dart
class TargetPanel extends StatelessWidget {
  final List<EquationTarget> targets;
  final Set<String> solvedTargets;
  final bool showOps;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F3D).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.runesAccent.withValues(alpha: 0.3),
        ),
      ),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: targets.map((target) {
            final solved = solvedTargets.contains(target.canonical);
            return _TargetChip(
              text: showOps ? target.displayText : _hideOps(target.displayText),
              solved: solved,
            );
          }).toList(),
        ),
      ),
    );
  }

  String _hideOps(String displayText) {
    // Replace operator with '?' for hidden-ops levels
    return displayText.replaceAll(RegExp(r'[+\-\u2212\u00D7\u00F7*/x]'), '?');
  }
}

class _TargetChip extends StatelessWidget {
  final String text;
  final bool solved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: solved
            ? const Color(0xFF2A9D8F).withValues(alpha: 0.2)
            : const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: solved
              ? const Color(0xFF2A9D8F).withValues(alpha: 0.5)
              : const Color(0xFF4A4A6A),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (solved)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.check_circle, color: Color(0xFF2A9D8F), size: 14),
            ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: solved
                  ? const Color(0xFF2A9D8F)
                  : const Color(0xFFF0E6D3),
              decoration: solved ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Chain Display (Current Chain)

Shows the current drag chain as token chips at the bottom of the screen:

```dart
class ChainDisplay extends StatelessWidget {
  final List<String> chainTokens;  // e.g., ["2", "+", "3", "=", "5"]

  @override
  Widget build(BuildContext context) {
    if (chainTokens.isEmpty) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'Drag across runes to cast a spell',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: Color(0xFFA89DB8),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: chainTokens.map((token) {
          final isOp = !RegExp(r'^\d+$').hasMatch(token);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0F3D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF66E3FF).withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              token,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isOp
                    ? const Color(0xFFF4A261) // gold for operators
                    : const Color(0xFFF0E6D3), // white for numbers
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### Hint Button

```dart
class HintButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final canUse = remaining > 0;

    return GestureDetector(
      onTap: canUse ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: canUse
              ? const Color(0xFF2A2F61)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: canUse
                ? const Color(0xFFF4A261).withValues(alpha: 0.4)
                : const Color(0xFF4A4A6A),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 18,
              color: canUse ? const Color(0xFFF4A261) : const Color(0xFF4A4A6A),
            ),
            const SizedBox(width: 4),
            Text(
              '$remaining',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: canUse ? const Color(0xFFF4A261) : const Color(0xFF4A4A6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Score & Progress Display

```dart
class ScoreProgressDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int solved;
  final int totalTargets;

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
            const Icon(Icons.auto_awesome,
                color: DragonColors.runesAccent, size: 18),
            Text(
              'x$streak',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DragonColors.runesAccent,
              ),
            ),
          ]),

        // Progress
        Text(
          '$solved / $totalTargets',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            color: Color(0xFFA89DB8),
          ),
        ),
      ],
    );
  }
}
```

---

## 21. Localization Updates

### Add to `lib/l10n/app_en.arb`

```json
{
  "dragonRunesTitle": "Dragon Runes",
  "@dragonRunesTitle": { "description": "Game title for hub and HUD" },

  "dragToConnect": "Drag across runes to cast a spell",
  "@dragToConnect": { "description": "Instruction text when no chain is active" },

  "equationFound": "Spell cast!",
  "@equationFound": { "description": "Feedback when a target equation is found" },

  "equationInvalid": "Invalid spell!",
  "@equationInvalid": { "description": "Feedback when an invalid equation is submitted" },

  "equationAlreadyFound": "Already cast!",
  "@equationAlreadyFound": { "description": "Feedback when an already-found equation is submitted" },

  "equationBonus": "Bonus spell!",
  "@equationBonus": { "description": "Feedback when a valid but non-target equation is submitted" },

  "hintsRemaining": "{count} hints left",
  "@hintsRemaining": {
    "description": "Hint counter label",
    "placeholders": { "count": { "type": "int" } }
  },

  "noHintsRemaining": "No hints left",
  "@noHintsRemaining": { "description": "Hint button when all hints used" },

  "targetsProgress": "{found} of {total} spells found",
  "@targetsProgress": {
    "description": "Progress indicator for target equations",
    "placeholders": {
      "found": { "type": "int" },
      "total": { "type": "int" }
    }
  },

  "allSpellsFound": "All spells found!",
  "@allSpellsFound": { "description": "Shown when all target equations are solved" },

  "streakBonusActive": "Streak bonus active!",
  "@streakBonusActive": { "description": "Shown when streak >= 3" },

  "emberEquations": "Ember Equations",
  "@emberEquations": { "description": "Dragon Runes World 1 name" },

  "flameFormulas": "Flame Formulas",
  "@flameFormulas": { "description": "Dragon Runes World 2 name" },

  "infernoAlgebra": "Inferno Algebra",
  "@infernoAlgebra": { "description": "Dragon Runes World 3 name" },

  "dragonsCalculus": "Dragon's Calculus",
  "@dragonsCalculus": { "description": "Dragon Runes World 4 name" },

  "elderRunes": "Elder Runes",
  "@elderRunes": { "description": "Dragon Runes World 5 name" }
}
```

---

## 22. Unit Tests

### Test Files

```
test/
+-- games/
    +-- dragon_runes/
        +-- equation_validator_test.dart
        +-- level_generator_test.dart
        +-- chain_manager_test.dart
        +-- scoring_test.dart
        +-- hint_manager_test.dart
        +-- difficulty_config_test.dart
```

### `test/games/dragon_runes/equation_validator_test.dart`

```dart
// Test cases:
// 1. Valid addition: chain [2, +, 3, =, 5] → target match
// 2. Valid subtraction: chain [5, -, 3, =, 2] → target match
// 3. Valid multiplication: chain [3, ×, 4, =, 12] → target match
// 4. Valid division: chain [12, ÷, 3, =, 4] → target match
// 5. Invalid: LHS ≠ RHS → invalid
// 6. Invalid: no equals sign → invalid
// 7. Invalid: chain too short (< 5) → not validated
// 8. Invalid: division by zero → invalid
// 9. Invalid: non-integer result → invalid
// 10. Invalid: negative result → invalid
// 11. Left-to-right evaluation: 2+3*4=20, not 14
// 12. Commutative matching: 3+2=5 matches target 2+3=5
// 13. Commutative matching: 4*3=12 matches target 3*4=12
// 14. Non-commutative: 5-3=2 does NOT match 3-5=2
// 15. Already-found target returns alreadyFound
// 16. Valid equation not in targets returns bonus
// 17. Empty LHS or RHS → invalid
// 18. Two-digit numbers validated correctly: 12+3=15
```

### `test/games/dragon_runes/level_generator_test.dart`

```dart
// Test cases:
// 1. Generated level has at least 1 target equation
// 2. Generated level has the requested number of targets (or all if fewer available)
// 3. All target equations are solvable from the provided nodes
// 4. Node list contains at least one equals sign
// 5. Node list contains operators matching the allowed operations
// 6. Number families respect min/max constraints
// 7. Families are unique (no duplicate pairs)
// 8. When only addition is enabled, all targets are addition
// 9. When all 4 ops enabled, targets include diverse operations
// 10. Multiplication products never exceed 144
// 11. Division equations have integer results
// 12. 1-family level generates valid equations
// 13. 3-family level generates valid equations
// 14. Fallback: even with difficult constraints, at least 1 family is generated
// 15. Node counts match: if a target needs two 3s, the node list has two 3s
```

### `test/games/dragon_runes/chain_manager_test.dart`

```dart
// Test cases:
// 1. Start chain at a node → chain has 1 element
// 2. Extend chain with new node → chain grows by 1
// 3. Extend chain with last node → ignored (no duplicate consecutive)
// 4. Extend chain with already-in-chain node → ignored
// 5. Backtrack: extend with previous node → chain shrinks by 1
// 6. End chain with length >= 5 → returns the chain
// 7. End chain with length < 5 → returns null
// 8. Clear chain → chain is empty
// 9. Not dragging → extend is ignored
```

### `test/games/dragon_runes/scoring_test.dart`

```dart
// Test cases:
// 1. Target match adds 100 points
// 2. Target match with streak >= 3 adds 150 points (100 + 50 bonus)
// 3. Streak increments on correct target match
// 4. Streak resets to 0 on invalid equation
// 5. Streak does NOT reset on already-found
// 6. Streak does NOT reset on bonus equation
// 7. Level complete bonus adds 500 points
// 8. Best streak tracks the maximum streak achieved
// 9. Total attempts increments on every result
// 10. Equations found increments only on target match
```

### `test/games/dragon_runes/hint_manager_test.dart`

```dart
// Test cases:
// 1. Initial hints = 3
// 2. useHint returns node indices for an unsolved target
// 3. useHint decrements remaining to 2
// 4. After 3 uses, remaining = 0, useHint returns null
// 5. When all targets solved, useHint returns null
// 6. Hint finds correct nodes matching the target equation
// 7. Hint skips already-solved targets
```

### `test/games/dragon_runes/difficulty_config_test.dart`

```dart
// Test cases:
// 1. World 1 level 1: addition only, range 1-5, 1 family, 2 targets, showOps=true
// 2. World 1 level 10: addition only, range 1-8, 2 families, 4 targets, showOps=true
// 3. World 2 level 1: add+sub, range 1-8, 2 families, 4 targets, showOps=false
// 4. World 3: includes multiplication
// 5. World 4: includes division
// 6. World 5: all ops, range 2-15, 3 families, 10-12 targets
// 7. Total levels = 50
// 8. All level numbers are unique and sequential
```

---

## 23. Verification Checklist

After completing this step, verify:

### Gameplay

- [ ] **Nodes arrange in circle** — evenly spaced around the perimeter
- [ ] **Three node types** — numbers (blue), operators (purple), equals (gold-tinted)
- [ ] **Drag starts a chain** — touching a node within snap radius begins the chain
- [ ] **Chain extends** — dragging to new nodes adds them to the chain
- [ ] **Chain backtrack** — dragging to previous node removes the last addition
- [ ] **Connection line renders** — glowing purple→gold gradient line between chain nodes
- [ ] **Line follows pointer** — line extends from last node to current pointer position
- [ ] **Chain validates on release** — chains of 5+ tokens are validated
- [ ] **Correct target: spell effect** — green glow on nodes, purple+gold particle burst
- [ ] **Invalid equation: shake** — red glow on nodes, screen shake animation
- [ ] **Already-found: info toast** — no score change, streak unaffected
- [ ] **Bonus equation: info toast** — valid but not target, streak unaffected
- [ ] **Left-to-right evaluation** — `2+3*4=20` is valid (not 14)
- [ ] **Commutative matching** — `3+2=5` matches target `2+3=5`
- [ ] **Target panel updates** — solved equations get checkmarks
- [ ] **Level completes** — when all targets found, celebration + results
- [ ] **Hints work** — 3 per level, highlights nodes of an unsolved target
- [ ] **Hint visual** — pulsing gold glow for 2 seconds
- [ ] **Streak tracking** — increments on correct, resets on invalid only
- [ ] **Streak bonus** — +50 at streak >= 3
- [ ] **Score counter** — updates in real-time with JetBrains Mono font

### Level Generation

- [ ] **Solvable puzzles** — all target equations can be formed from provided nodes
- [ ] **Diverse targets** — at least one equation per enabled operation type
- [ ] **No impossible puzzles** — node counts match equation requirements
- [ ] **World 1** — addition only, small numbers, operators visible in targets
- [ ] **World 2** — add+subtract, operators hidden
- [ ] **World 3** — add+sub+multiply
- [ ] **World 4** — all four operations including division
- [ ] **World 5** — all ops, larger numbers, many targets

### Integration

- [ ] **Hub card** — Dragon Runes card on hub navigates to the game
- [ ] **GameShell wraps** — pause overlay works (Resume/Settings/Quit)
- [ ] **Result screen** — appears on level complete with correct stats
- [ ] **Next Level** — advances to next level with new puzzle
- [ ] **Play Again** — regenerates same level with a new puzzle
- [ ] **Back to Hub** — returns to hub cleanly
- [ ] **Event bus** — emits GameStarted, AnswerGiven, StreakAchieved, LevelCompleted, GameEnded
- [ ] **FactTracker** — records every equation attempt with timing data
- [ ] **RewardService** — awards scales for correct equations and streaks
- [ ] **Profile updates** — totalScales, totalCorrectAnswers, gameStats change

### Technical

- [ ] **`flutter analyze`** — passes clean
- [ ] **`flutter test`** — all tests pass (existing + new)
- [ ] **`flutter build apk --debug`** — succeeds
- [ ] **No memory leaks** — particle effects and old highlights are cleaned up
- [ ] **All strings localized** — no hardcoded English text

### Fun Factor

- [ ] **Drag-to-connect feels smooth** — no lag, responsive snap radius
- [ ] **Spell effects are satisfying** — purple+gold particles feel magical
- [ ] **Puzzles are fair** — all levels are solvable, hints help when stuck
- [ ] **Difficulty ramp is gradual** — World 1 is easy for 7-year-olds, World 5 is challenging
- [ ] **Hidden operators add intrigue** — Worlds 2-5 require figuring out which operation works
- [ ] **No time pressure** — the puzzle nature makes it a good "thinking" game
- [ ] **"Just one more level" urge** — the game makes you want to keep solving

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
1. Hub -> tap Dragon Runes -> level loads with nodes in a circle
2. Drag across 5 nodes to form "2 + 3 = 5" (or whatever the level provides)
3. Verify: green glow, spell particles, score +100, target gets checkmark
4. Form another correct equation -> verify streak shows x2
5. Get streak to 3 -> verify +150 points (100 + 50 bonus)
6. Deliberately form an invalid chain -> verify red glow, shake, streak resets
7. Find all target equations -> verify level complete with celebration
8. Result screen -> verify score, accuracy, streak, stars are correct
9. Tap "Next Level" -> verify new puzzle generates
10. Tap "Play Again" -> verify same level regenerates with different layout
11. Tap "Back to Hub" -> verify clean return to hub
12. Use a hint -> verify gold pulsing highlight on correct nodes
13. Use all 3 hints -> verify hint button shows disabled
14. Pause mid-game -> verify overlay appears, can Resume/Quit
15. Play World 2+ -> verify operators hidden in target display (shown as ?)
16. Play World 4 -> verify division equations appear
17. Test commutative: enter 3+2=5 for target 2+3=5 -> verify it matches
```

---

## Files Modified in This Step

| File | Action | Description |
|------|--------|-------------|
| `lib/games/dragon_runes/dragon_runes_game.dart` | **Replace** | Full game screen wrapping FlameGame |
| `lib/games/dragon_runes/dragon_runes_flame_game.dart` | **Create** | Flame FlameGame subclass |
| `lib/games/dragon_runes/dragon_runes_registration.dart` | **Create** | MathDragonsGame implementation |
| `lib/games/dragon_runes/components/rune_node.dart` | **Create** | Rune node component |
| `lib/games/dragon_runes/components/connection_line.dart` | **Create** | Chain connection line |
| `lib/games/dragon_runes/components/spell_particle_effect.dart` | **Create** | Spell casting particles |
| `lib/games/dragon_runes/components/hint_highlight.dart` | **Create** | Hint gold pulse highlight |
| `lib/games/dragon_runes/components/circle_ring.dart` | **Create** | Background circle decoration |
| `lib/games/dragon_runes/systems/level_generator.dart` | **Create** | Puzzle generation algorithm |
| `lib/games/dragon_runes/systems/equation_validator.dart` | **Create** | Chain validation and evaluation |
| `lib/games/dragon_runes/systems/chain_manager.dart` | **Create** | Drag chain state management |
| `lib/games/dragon_runes/models/rune_level.dart` | **Create** | Level definition model |
| `lib/games/dragon_runes/models/equation_target.dart` | **Create** | Target equation model |
| `lib/games/dragon_runes/models/rune_node_data.dart` | **Create** | Node data model |
| `lib/games/dragon_runes/models/dragon_runes_config.dart` | **Create** | Per-level difficulty config |
| `lib/games/dragon_runes/widgets/target_panel.dart` | **Create** | Target equations Flutter widget |
| `lib/games/dragon_runes/widgets/chain_display.dart` | **Create** | Current chain display bar |
| `lib/games/dragon_runes/widgets/hint_button.dart` | **Create** | Hint button with count |
| `lib/games/dragon_runes/widgets/score_streak_display.dart` | **Create** | Score, streak, progress HUD |
| `lib/games/dragon_runes/widgets/level_complete_overlay.dart` | **Create** | Level complete celebration |
| `lib/app.dart` | **Modify** | Register DragonRunes game |
| `lib/l10n/app_en.arb` | **Modify** | Add Dragon Runes strings |

---

## What This Step Does NOT Include

These are explicitly out of scope for Step 6:

- **Real sprite art** — Step 12 (using custom-painted shapes for v1)
- **Sound effects** — Step 12 (no audio in v1 games)
- **Dragon companion reactions** — Step 12
- **Adaptive problem selection algorithm** — Step 8 (using the level generator's
  built-in family-based generation for now)
- **Level select screen** — Step 8
- **Achievement checking** — Step 9
- **Daily challenge integration** — Step 9
- **Cloud sync** — Step 10

Step 6 delivers the third fully playable game. The focus is on **satisfying
drag-to-connect interaction and fair puzzle generation**. The drag gesture must feel
smooth. The level generator must always produce solvable puzzles. The spell-casting
effect must feel magical and rewarding. Prioritize gameplay feel and puzzle quality
over visual polish — the polish comes in Steps 8, 9, and 12.

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
