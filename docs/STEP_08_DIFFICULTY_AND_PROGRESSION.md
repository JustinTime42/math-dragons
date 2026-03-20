# Step 8: Adaptive Difficulty & Progression System

> **Goal:** Implement the educational backbone of Math Dragons — an adaptive difficulty
> engine that selects problems based on individual player mastery, a progression system
> with star ratings and level advancement criteria, a level select screen for all 4 games,
> and the dragon evolution meta-progression system. After this step, all 4 games present
> intelligently-selected problems, players earn 1-3 stars per level, and the dragon
> companion evolves based on cross-game achievement.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Steps 4-7 complete. All 4 games fully playable and integrated. `flutter analyze`
> clean. `flutter test` green. `flutter build apk --debug` succeeds.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [File Structure](#4-file-structure)
5. [DifficultyEngine — Problem Selection Algorithm](#5-difficultyengine--problem-selection-algorithm)
6. [FactPool — Eligible Fact Generation](#6-factpool--eligible-fact-generation)
7. [Level Advancement & Star Ratings](#7-level-advancement--star-ratings)
8. [ProgressionManager — Cross-Game Tracking](#8-progressionmanager--cross-game-tracking)
9. [Dragon Evolution System](#9-dragon-evolution-system)
10. [Level Select Screen](#10-level-select-screen)
11. [Game Integration — Dragon Eggs](#11-game-integration--dragon-eggs)
12. [Game Integration — Fire Trail](#12-game-integration--fire-trail)
13. [Game Integration — Dragon Runes](#13-game-integration--dragon-runes)
14. [Game Integration — Dragon's Feast](#14-game-integration--dragons-feast)
15. [Evolution Progress UI — Hub Updates](#15-evolution-progress-ui--hub-updates)
16. [Difficulty Rebalancing](#16-difficulty-rebalancing)
17. [Localization Updates](#17-localization-updates)
18. [Unit Tests](#18-unit-tests)
19. [Verification Checklist](#19-verification-checklist)

---

## 1. User Stories

### US-8.1: Adaptive Problem Selection
**As a** player,
**I want** the game to give me more practice on math facts I struggle with and fewer
repeats of facts I've mastered,
**so that** I improve efficiently without the game feeling like a drill.

### US-8.2: Level Advancement
**As a** player,
**I want** clear criteria for advancing to the next level (score + accuracy + attempts),
**so that** I feel a sense of accomplishment and know what I need to do to progress.

### US-8.3: Star Ratings
**As a** player,
**I want** to earn 1-3 stars per level based on how well I performed,
**so that** I have a reason to replay levels and improve my rating.

### US-8.4: Level Select
**As a** player,
**I want** to see all levels in a world with their star ratings and locked/unlocked state,
**so that** I can choose which level to play and see my overall progress.

### US-8.5: Dragon Evolution
**As a** player,
**I want** my dragon companion to evolve into more impressive forms as I achieve milestones
across all games,
**so that** I have a long-term goal motivating me to try every game and keep improving.

### US-8.6: Evolution Progress
**As a** player,
**I want** to see what requirements remain before my dragon evolves to the next stage,
**so that** I know exactly what to work toward.

### US-8.7: Balanced Difficulty
**As a** player,
**I want** World 1 of every game to start easy enough for a 7-year-old and World 5 to
challenge a 14-year-old,
**so that** the game is accessible to its full target audience.

### US-8.8: Fun First
**As a** player,
**I want** the adaptive system to be invisible — I should just feel like the game is always
at the right challenge level,
**so that** learning happens naturally without feeling forced or punishing.

---

## 2. Acceptance Criteria

- [ ] DifficultyEngine implemented with weighted bucket selection algorithm
- [ ] 4 buckets: Needs Practice (40%), Reinforcing (30%), Mastered (15%), New (15%)
- [ ] Spacing rules: no repeat within 3 problems, re-present incorrect within 5, boost 7+ day stale facts
- [ ] 40% cap on "Needs Practice" problems enforced (rest drawn from other buckets)
- [ ] All 4 games call DifficultyEngine for problem selection instead of pure random
- [ ] Dragon Eggs: EggSpawner uses engine-selected focus facts
- [ ] Fire Trail: ProblemManager consults engine for next problem
- [ ] Dragon Runes: LevelGenerator receives engine-influenced number families
- [ ] Dragon's Feast: BoardGenerator uses engine to bias tile number selection
- [ ] Level advancement requires: minimum score + 60% accuracy + minimum problems attempted
- [ ] Star rating: 1★ = completed, 2★ = 75%+ accuracy AND above-median score, 3★ = 90%+ accuracy AND above-high score
- [ ] Stars persisted per level per game in PlayerProfile.gameStats.levelStars
- [ ] Next level unlocks at 1 star on current level
- [ ] Level select screen shows all levels per world with star ratings
- [ ] Locked levels dimmed, unlocked levels show stars, tapping a level launches it
- [ ] Dragon evolution 6-stage system checks requirements against real player data
- [ ] Evolution stage stored in PlayerProfile.dragonEvolution
- [ ] Evolution check runs on every profile update (level complete, scales earned)
- [ ] Hub profile bar shows current stage + progress bar toward next stage
- [ ] Evolution progress tooltip shows remaining requirements
- [ ] World 1 of all games accessible to a 7-year-old (addition 1-5, slow, forgiving)
- [ ] World 5 of all games challenges a 14-year-old (all ops, fast, complex)
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds

---

## 3. Architecture Overview

### Two Layers of Difficulty

The adaptive difficulty system has two layers that operate independently:

```
┌──────────────────────────────────────────────────────┐
│                  LAYER 1: Level Progression           │
│  (Visible to player — fixed checkpoints)              │
│                                                        │
│  World 1 Lv1 → Lv2 → ... → Lv8 → World 2 Lv1 → ... │
│                                                        │
│  • Determines WHAT content is available               │
│  • Gates operations, number ranges, speed             │
│  • Star ratings track mastery per level               │
│  • Player sees and controls this progression          │
├──────────────────────────────────────────────────────┤
│                  LAYER 2: Adaptive Selection           │
│  (Invisible to player — smart problem picking)         │
│                                                        │
│  Within a level → DifficultyEngine selects facts      │
│                                                        │
│  • Determines WHICH specific problems appear          │
│  • Surfaces weak facts more often                     │
│  • Introduces new facts at a steady pace              │
│  • Keeps mastered facts in rotation (spaced rep)      │
│  • Player never sees this — just feels "right"        │
└──────────────────────────────────────────────────────┘
```

### Data Flow

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  FactTracker  │────>│ DifficultyEngine │────>│  Game Problem    │
│  (Step 2)     │     │  (NEW)           │     │  Generators      │
│               │     │                  │     │  (existing)      │
│  Per-fact     │     │  Bucket sort     │     │                  │
│  accuracy,    │     │  + weight pick   │     │  EggSpawner      │
│  streaks,     │     │  + spacing       │     │  ProblemManager  │
│  last seen    │     │  + 40% cap       │     │  LevelGenerator  │
└──────────────┘     └──────────────────┘     │  BoardGenerator  │
                                               └──────────────────┘

┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ LevelCompleted│────>│ ProgressionMgr   │────>│  PlayerProfile   │
│ GameEvent     │     │  (NEW)           │     │  (Step 2)        │
│               │     │                  │     │                  │
│  score, acc,  │     │  Star calc       │     │  levelStars      │
│  stars        │     │  Level unlock    │     │  dragonEvolution │
│               │     │  Evolution check │     │  gameStats       │
└──────────────┘     └──────────────────┘     └──────────────────┘
```

### Key Design Decisions

1. **DifficultyEngine is stateless per-call.** It reads FactTracker data and produces a
   selection. No persistent state of its own — all data lives in FactTracker/LocalStorage.

2. **Games keep their existing config systems.** The engine doesn't replace
   `FireTrailConfig` or `DragonRunesConfig`. Instead, it provides a `MathFact` suggestion
   that the game's existing generator incorporates. Each game's integration is different
   because each game uses math facts differently.

3. **ProgressionManager is an EventBus listener.** It subscribes to `LevelCompleted`
   events, calculates stars, checks evolution, and updates the profile. Games don't
   need to know about progression — they just emit events.

4. **Level select is a shared screen.** All 4 games use the same `LevelSelectScreen`
   widget, parameterized by game ID and world/level definitions.

---

## 4. File Structure

```
math_dragons/lib/
├── core/
│   ├── difficulty_engine.dart        ← REPLACE stub — full algorithm
│   └── progression_manager.dart      ← CREATE — star calc, evolution checks
├── games/
│   ├── shared/
│   │   ├── difficulty_config.dart    ← REPLACE stub — shared thresholds
│   │   ├── level_select_screen.dart  ← CREATE — world/level picker UI
│   │   └── math_problem.dart         (existing — add engine-aware generation)
│   ├── dragon_eggs/
│   │   ├── systems/egg_spawner.dart  ← MODIFY — add engine integration
│   │   └── dragon_eggs_flame_game.dart ← MODIFY — pass engine to spawner
│   ├── fire_trail/
│   │   ├── systems/problem_manager.dart ← MODIFY — consult engine
│   │   └── fire_trail_flame_game.dart   ← MODIFY — pass engine
│   ├── dragon_runes/
│   │   ├── systems/level_generator.dart ← MODIFY — engine-influenced families
│   │   └── dragon_runes_screen.dart     ← MODIFY — pass engine to generator
│   └── dragons_feast/
│       ├── systems/board_generator.dart ← MODIFY — engine tile bias
│       └── dragons_feast_flame_game.dart ← MODIFY — pass engine
├── hub/
│   ├── hub_screen.dart               ← MODIFY — evolution progress, level nav
│   └── profile_bar.dart              ← MODIFY — evolution progress bar
└── l10n/
    └── app_en.arb                    ← MODIFY — new strings

math_dragons/test/
├── core/
│   ├── difficulty_engine_test.dart   ← CREATE
│   └── progression_manager_test.dart ← CREATE
└── games/shared/
    └── level_select_screen_test.dart ← CREATE
```

---

## 5. DifficultyEngine — Problem Selection Algorithm

### `lib/core/difficulty_engine.dart`

Replace the stub. This is the educational core of the app. It reads from FactTracker
and returns which math fact to present next.

```dart
import 'dart:math';
import 'fact_tracker.dart';
import '../games/shared/math_problem.dart';

/// Adaptive difficulty engine that selects math facts based on player mastery.
///
/// The engine categorizes all eligible facts into 4 weighted buckets and uses
/// weighted random selection with spacing rules to pick the next problem.
class DifficultyEngine {
  final FactTracker _factTracker;
  final Random _random;

  /// Recent fact keys to enforce spacing rules.
  final List<String> _recentFacts = [];

  /// Facts answered incorrectly recently, for re-presentation.
  final List<String> _recentIncorrect = [];

  static const int _noRepeatWindow = 3;
  static const int _rePresentIncorrectWindow = 5;
  static const int _staleDays = 7;
  static const double _needsPracticeCap = 0.40;

  DifficultyEngine({
    required FactTracker factTracker,
    Random? random,
  })  : _factTracker = factTracker,
        _random = random ?? Random();

  /// Select the next math fact from the eligible pool for a given level's parameters.
  ///
  /// [eligibleFacts] — all facts valid for this level (from FactPool.forLevel)
  ///
  /// Returns a [MathFact], or null if pool is empty.
  MathFact? selectNext(List<MathFact> eligibleFacts) {
    if (eligibleFacts.isEmpty) return null;

    // 1. Check if we must re-present a recent incorrect fact
    final rePresent = _checkRePresentIncorrect(eligibleFacts);
    if (rePresent != null) return _recordSelection(rePresent);

    // 2. Categorize into buckets
    final buckets = _categorizeFacts(eligibleFacts);

    // 3. Apply 40% cap on needs-practice
    final weights = _calculateWeights(buckets);

    // 4. Weighted random selection from non-empty buckets
    final bucket = _selectBucket(weights);
    final candidates = buckets[bucket]!;

    // 5. Filter out recently-seen facts
    final filtered = candidates
        .where((f) => !_recentFacts.contains(f.factKey))
        .toList();

    // Fall back to unfiltered if all were recently seen
    final pool = filtered.isNotEmpty ? filtered : candidates;

    // 6. Within the bucket, boost stale facts
    final selected = _selectFromPool(pool);
    return _recordSelection(selected);
  }

  /// Record a fact that was answered incorrectly, for re-presentation scheduling.
  void recordIncorrect(String factKey) {
    _recentIncorrect.add(factKey);
    // Keep window bounded
    if (_recentIncorrect.length > _rePresentIncorrectWindow * 2) {
      _recentIncorrect.removeRange(
          0, _recentIncorrect.length - _rePresentIncorrectWindow * 2);
    }
  }

  /// Reset recent-fact tracking (call between game sessions).
  void resetSession() {
    _recentFacts.clear();
    _recentIncorrect.clear();
  }

  // ── Private ──

  MathFact _recordSelection(MathFact fact) {
    _recentFacts.add(fact.factKey);
    if (_recentFacts.length > _noRepeatWindow * 2) {
      _recentFacts.removeRange(0, _recentFacts.length - _noRepeatWindow * 2);
    }
    // Remove from re-present queue if present
    _recentIncorrect.remove(fact.factKey);
    return fact;
  }

  /// Check if a recently-incorrect fact needs re-presentation.
  MathFact? _checkRePresentIncorrect(List<MathFact> eligible) {
    if (_recentIncorrect.isEmpty) return null;

    // Find the oldest incorrect fact that hasn't been re-presented yet
    // and is within the re-presentation window
    for (final factKey in _recentIncorrect) {
      // Don't re-present if it was just shown
      if (_recentFacts.length >= _noRepeatWindow &&
          _recentFacts
              .sublist(_recentFacts.length - _noRepeatWindow)
              .contains(factKey)) {
        continue;
      }

      final match = eligible.where((f) => f.factKey == factKey).firstOrNull;
      if (match != null) return match;
    }
    return null;
  }

  /// Sort eligible facts into the 4 mastery buckets.
  Map<FactBucket, List<MathFact>> _categorizeFacts(List<MathFact> facts) {
    final buckets = <FactBucket, List<MathFact>>{
      FactBucket.needsPractice: [],
      FactBucket.reinforcing: [],
      FactBucket.mastered: [],
      FactBucket.newFact: [],
    };

    for (final fact in facts) {
      final record = _factTracker.getFact(fact.factKey);
      if (record == null || record.timesPresented < 3) {
        buckets[FactBucket.newFact]!.add(fact);
      } else if (record.accuracy < 0.70) {
        buckets[FactBucket.needsPractice]!.add(fact);
      } else if (record.accuracy < 0.90) {
        buckets[FactBucket.reinforcing]!.add(fact);
      } else {
        buckets[FactBucket.mastered]!.add(fact);
      }
    }

    return buckets;
  }

  /// Calculate actual weights, applying the 40% cap on needs-practice.
  Map<FactBucket, double> _calculateWeights(
      Map<FactBucket, List<MathFact>> buckets) {
    // Base weights from the plan
    var weights = <FactBucket, double>{
      FactBucket.needsPractice: 0.40,
      FactBucket.reinforcing: 0.30,
      FactBucket.mastered: 0.15,
      FactBucket.newFact: 0.15,
    };

    // Zero out empty buckets and redistribute
    final emptyBuckets =
        weights.keys.where((b) => buckets[b]!.isEmpty).toList();
    if (emptyBuckets.isNotEmpty) {
      double freed = 0;
      for (final empty in emptyBuckets) {
        freed += weights[empty]!;
        weights[empty] = 0;
      }

      final nonEmpty =
          weights.keys.where((b) => buckets[b]!.isNotEmpty).toList();
      if (nonEmpty.isNotEmpty) {
        final share = freed / nonEmpty.length;
        for (final b in nonEmpty) {
          weights[b] = weights[b]! + share;
        }
      }
    }

    // Enforce 40% cap: if needs-practice weight exceeds cap after
    // redistribution and there are other non-empty buckets, clamp it
    if (weights[FactBucket.needsPractice]! > _needsPracticeCap) {
      final excess = weights[FactBucket.needsPractice]! - _needsPracticeCap;
      weights[FactBucket.needsPractice] = _needsPracticeCap;

      final others = weights.keys
          .where(
              (b) => b != FactBucket.needsPractice && buckets[b]!.isNotEmpty)
          .toList();
      if (others.isNotEmpty) {
        final share = excess / others.length;
        for (final b in others) {
          weights[b] = weights[b]! + share;
        }
      }
    }

    return weights;
  }

  /// Weighted random bucket selection.
  FactBucket _selectBucket(Map<FactBucket, double> weights) {
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return FactBucket.newFact;

    var roll = _random.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return weights.keys.last;
  }

  /// Select from pool, boosting facts not seen in 7+ days.
  MathFact _selectFromPool(List<MathFact> pool) {
    if (pool.length == 1) return pool.first;

    final now = DateTime.now();
    final staleCutoff = now.subtract(const Duration(days: _staleDays));

    // Build weighted list: stale facts get 3x weight
    final weighted = <(MathFact, double)>[];
    for (final fact in pool) {
      final record = _factTracker.getFact(fact.factKey);
      double weight = 1.0;
      if (record != null &&
          record.lastPresented != null &&
          record.lastPresented!.isBefore(staleCutoff)) {
        weight = 3.0;
      }
      weighted.add((fact, weight));
    }

    final total = weighted.fold<double>(0, (a, b) => a + b.$2);
    var roll = _random.nextDouble() * total;
    for (final (fact, w) in weighted) {
      roll -= w;
      if (roll <= 0) return fact;
    }
    return pool.last;
  }
}

/// The 4 mastery buckets for problem selection.
enum FactBucket {
  needsPractice, // accuracy < 70%
  reinforcing,   // accuracy 70-89%
  mastered,      // accuracy 90%+
  newFact,       // seen < 3 times
}
```

### Cardinal Rules (enforced in code)

1. **Never interrupt flow for drill.** The engine influences selection, never pauses games.
2. **40% cap on needs-practice.** Even if many facts are weak, more than half the
   problems are things the player can succeed at.
3. **No repeat within 3 problems.** Prevents the "same question twice in a row" feel.
4. **Re-present incorrect within 5.** Gives a quick second chance while memory is fresh.
5. **Stale boost at 7+ days.** Spaced repetition for long-term retention.

---

## 6. FactPool — Eligible Fact Generation

### `lib/games/shared/difficulty_config.dart`

Replace the stub. Provides the eligible fact pool for any level, and shared thresholds
for star ratings and level advancement.

```dart
import 'math_problem.dart';
import '../../games/dragon_eggs/models/egg_data.dart';

/// Generates the pool of eligible math facts for a given level's parameters.
class FactPool {
  /// Generate all facts eligible for a level based on its difficulty parameters.
  ///
  /// This produces the universe of facts the DifficultyEngine can select from.
  /// The level's config determines number ranges and operations.
  static List<MathFact> forLevel({
    required int numberMin,
    required int numberMax,
    required List<MathOp> operations,
    int resultMax = 144,
  }) {
    return generateFacts(
      numberMin: numberMin,
      numberMax: numberMax,
      operations: operations,
      resultMax: resultMax,
    );
  }
}

/// Shared thresholds for level advancement and star ratings.
/// All games use the same criteria (per MOBILE_APP_PLAN.md section 8).
class LevelThresholds {
  /// Minimum accuracy to complete a level (1 star).
  static const double minAccuracy = 0.60;

  /// Accuracy threshold for 2 stars.
  static const double twoStarAccuracy = 0.75;

  /// Accuracy threshold for 3 stars.
  static const double threeStarAccuracy = 0.90;

  /// Minimum problems attempted before level can be "completed."
  /// Prevents cheesing a level by answering 1 question correctly.
  static int minProblemsForLevel(int levelNumber) {
    if (levelNumber <= 5) return 8;
    if (levelNumber <= 15) return 10;
    if (levelNumber <= 30) return 12;
    return 15;
  }

  /// Calculate star rating for a game result.
  ///
  /// [accuracy] — 0.0 to 1.0
  /// [score] — the player's score
  /// [medianScore] — the score threshold for 2 stars
  /// [highScore] — the score threshold for 3 stars
  /// [problemsAttempted] — how many problems the player answered
  /// [levelNumber] — for minimum-problems check
  static int calculateStars({
    required double accuracy,
    required int score,
    required int medianScore,
    required int highScore,
    required int problemsAttempted,
    required int levelNumber,
  }) {
    // Must meet minimum problems attempted
    if (problemsAttempted < minProblemsForLevel(levelNumber)) return 0;

    // Must meet minimum accuracy for any stars
    if (accuracy < minAccuracy) return 0;

    // 3 stars: 90%+ accuracy AND score above high threshold
    if (accuracy >= threeStarAccuracy && score >= highScore) return 3;

    // 2 stars: 75%+ accuracy AND score above median threshold
    if (accuracy >= twoStarAccuracy && score >= medianScore) return 2;

    // 1 star: completed (met minimum requirements)
    return 1;
  }
}

/// Score thresholds per game for star calculations.
/// Each game defines what constitutes a "median" and "high" score per level.
class GameScoreThresholds {
  final int medianScore;
  final int highScore;

  const GameScoreThresholds({
    required this.medianScore,
    required this.highScore,
  });

  /// Dragon Eggs: score-based (points from correct equations).
  static GameScoreThresholds dragonEggs(int levelNumber) {
    final base = 50 + (levelNumber * 15);
    return GameScoreThresholds(
      medianScore: base,
      highScore: (base * 1.5).round(),
    );
  }

  /// Fire Trail: correctToAdvance is the base; score = correct answers * multiplier.
  static GameScoreThresholds fireTrail(int levelNumber) {
    final world = ((levelNumber - 1) ~/ 8) + 1;
    final base = 6 + world * 3;
    return GameScoreThresholds(
      medianScore: base * 10,
      highScore: base * 15,
    );
  }

  /// Dragon Runes: score = equations found * 100 + streak bonuses.
  static GameScoreThresholds dragonRunes(int levelNumber) {
    final world = ((levelNumber - 1) ~/ 10) + 1;
    final targets = 2 + world * 2;
    return GameScoreThresholds(
      medianScore: targets * 100,
      highScore: (targets * 100 + targets * 50), // all targets + all streaks
    );
  }

  /// Dragon's Feast: score = correct eats * 100 + level bonuses.
  static GameScoreThresholds dragonsFeast(int levelNumber) {
    return GameScoreThresholds(
      medianScore: 500 + (levelNumber * 30),
      highScore: 800 + (levelNumber * 50),
    );
  }
}
```

---

## 7. Level Advancement & Star Ratings

### Star Rating System

Stars are calculated at the end of each level attempt using `LevelThresholds.calculateStars()`.
The result is passed in the `LevelCompleted` event (which already has a `stars` field).

```
Level Completion Requirements:
  - Minimum problems attempted (varies by level, 8-15)
  - Minimum accuracy: 60% (generous — forward progress feels achievable)

Star Rating:
  ★☆☆  = Completed (met minimum requirements: 60%+ accuracy, enough problems)
  ★★☆  = Good (75%+ accuracy AND score above median threshold)
  ★★★  = Excellent (90%+ accuracy AND score above high threshold)

Level Unlocking:
  - Next level unlocks at 1 star on current level
  - No hard gates beyond the 1-star requirement
```

### How Games Calculate Stars

Each game already emits `LevelCompleted` events. Currently the `stars` field is set
simply by the game. After this step, games call `LevelThresholds.calculateStars()` to
compute stars consistently:

```dart
// In any game's level-complete handler:
final thresholds = GameScoreThresholds.fireTrail(currentLevelNumber);
final stars = LevelThresholds.calculateStars(
  accuracy: correctCount / totalAttempted,
  score: score,
  medianScore: thresholds.medianScore,
  highScore: thresholds.highScore,
  problemsAttempted: totalAttempted,
  levelNumber: currentLevelNumber,
);

eventBus.emit(LevelCompleted(
  gameId: 'fire_trail',
  levelNumber: currentLevelNumber,
  score: score,
  stars: stars,
  accuracy: correctCount / totalAttempted,
));
```

### Star Persistence

Stars are already persisted by `RewardService._onLevelCompleted()` which updates
`gameStats.levelStars[levelNumber]`. It already implements "only save if better than
existing stars." No changes needed to the persistence logic.

---

## 8. ProgressionManager — Cross-Game Tracking

### `lib/core/progression_manager.dart`

New service. Listens to EventBus events and manages cross-game progression: dragon
evolution checks and the "try another game" suggestion logic.

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'event_bus.dart';
import 'game_events.dart';
import 'fact_tracker.dart';
import 'player_profile.dart';
import '../storage/local_storage.dart';

/// Manages cross-game progression: dragon evolution and game variety suggestions.
class ProgressionManager {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final FactTracker _factTracker;
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

  /// Fires when dragon evolution stage changes.
  final ValueNotifier<int> evolutionStage = ValueNotifier(0);

  ProgressionManager({
    required EventBus eventBus,
    required LocalStorage storage,
    required FactTracker factTracker,
  })  : _eventBus = eventBus,
        _storage = storage,
        _factTracker = factTracker {
    evolutionStage.value = _storage.getProfile().dragonEvolution;
    _subscribe();
  }

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen((_) => checkEvolution()),
    );
    _subscriptions.add(
      _eventBus.on<GameEnded>().listen((_) => checkEvolution()),
    );
  }

  /// Check if the player qualifies for the next evolution stage.
  /// Updates the profile if a new stage is reached.
  void checkEvolution() {
    final profile = _storage.getProfile();
    final currentStage = profile.dragonEvolution;

    // Check next stage only (no skipping stages)
    final nextStage = currentStage + 1;
    if (nextStage > 5) return; // Already at max

    final req = EvolutionRequirements.forStage(nextStage);
    if (req.isMet(profile, _factTracker)) {
      _storage.updateProfile(
          (p) => p.copyWith(dragonEvolution: nextStage));
      evolutionStage.value = nextStage;
    }
  }

  /// Get progress toward the next evolution stage as a map of requirement → progress.
  EvolutionProgress getEvolutionProgress() {
    final profile = _storage.getProfile();
    final nextStage = profile.dragonEvolution + 1;
    if (nextStage > 5) {
      return EvolutionProgress(
        currentStage: 5,
        nextStage: null,
        requirements: [],
      );
    }

    final req = EvolutionRequirements.forStage(nextStage);
    return EvolutionProgress(
      currentStage: profile.dragonEvolution,
      nextStage: nextStage,
      requirements: req.progressItems(profile, _factTracker),
    );
  }

  /// Suggest a game the player should try next (variety encouragement).
  String? suggestGame(String currentGameId) {
    final profile = _storage.getProfile();
    const allGames = ['dragon_runes', 'fire_trail', 'dragon_eggs', 'dragons_feast'];

    // Find least-played game that isn't the current one
    String? suggestion;
    int minPlays = 999999;

    for (final gameId in allGames) {
      if (gameId == currentGameId) continue;
      final plays = profile.gameStats[gameId]?.timesPlayed ?? 0;
      if (plays < minPlays) {
        minPlays = plays;
        suggestion = gameId;
      }
    }

    return suggestion;
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    evolutionStage.dispose();
  }
}

/// Progress toward the next evolution stage.
class EvolutionProgress {
  final int currentStage;
  final int? nextStage;
  final List<EvolutionProgressItem> requirements;

  const EvolutionProgress({
    required this.currentStage,
    required this.nextStage,
    required this.requirements,
  });

  /// Overall progress as 0.0 to 1.0 (average of all requirement progress).
  double get overallProgress {
    if (requirements.isEmpty) return 1.0;
    final total =
        requirements.fold<double>(0, (sum, r) => sum + r.progress);
    return total / requirements.length;
  }
}

/// A single requirement's progress.
class EvolutionProgressItem {
  final String label;       // e.g., "Reach level 8 in 2 games"
  final int current;
  final int required_;
  final bool isMet;

  const EvolutionProgressItem({
    required this.label,
    required this.current,
    required this.required_,
    required this.isMet,
  });

  double get progress =>
      required_ > 0 ? (current / required_).clamp(0.0, 1.0) : 1.0;
}
```

---

## 9. Dragon Evolution System

### Evolution Requirements

Six stages (0-5) with requirements from MOBILE_APP_PLAN.md section 9:

```dart
/// Evolution requirements for each dragon stage.
class EvolutionRequirements {
  final int stage;
  final int minLevelInGames;   // must reach this level...
  final int gamesRequired;      // ...in this many different games
  final int totalScales;
  final int achievements;        // placeholder until Step 9
  final int threeStarLevels;
  final int dailyChallenges;     // placeholder until Step 9
  final int masteredFacts;

  const EvolutionRequirements({
    required this.stage,
    this.minLevelInGames = 0,
    this.gamesRequired = 0,
    this.totalScales = 0,
    this.achievements = 0,
    this.threeStarLevels = 0,
    this.dailyChallenges = 0,
    this.masteredFacts = 0,
  });

  static EvolutionRequirements forStage(int stage) {
    switch (stage) {
      case 1: // Hatchling
        return const EvolutionRequirements(
          stage: 1,
          minLevelInGames: 3,
          gamesRequired: 1,
          totalScales: 100,
        );
      case 2: // Fledgling
        return const EvolutionRequirements(
          stage: 2,
          minLevelInGames: 8,
          gamesRequired: 2,
          totalScales: 750,
          achievements: 5,
        );
      case 3: // Young Dragon
        return const EvolutionRequirements(
          stage: 3,
          minLevelInGames: 15,
          gamesRequired: 3,
          totalScales: 3000,
          achievements: 15,
          threeStarLevels: 10,
        );
      case 4: // Adult Dragon
        return const EvolutionRequirements(
          stage: 4,
          minLevelInGames: 25,
          gamesRequired: 4,
          totalScales: 10000,
          achievements: 30,
          threeStarLevels: 30,
          dailyChallenges: 10,
        );
      case 5: // Elder Dragon
        return const EvolutionRequirements(
          stage: 5,
          minLevelInGames: 35,
          gamesRequired: 4,
          totalScales: 25000,
          achievements: 50,
          threeStarLevels: 60,
          dailyChallenges: 30,
          masteredFacts: 100,
        );
      default:
        return const EvolutionRequirements(stage: 0);
    }
  }

  /// Check if all requirements are met.
  bool isMet(PlayerProfile profile, FactTracker factTracker) {
    // Check level requirement across N games
    final gamesAtLevel = _gamesAtMinLevel(profile);
    if (gamesAtLevel < gamesRequired) return false;

    // Check scales
    if (profile.totalScales < totalScales) return false;

    // Check 3-star levels (count across all games)
    if (threeStarLevels > 0) {
      final total3Stars = _countThreeStarLevels(profile);
      if (total3Stars < threeStarLevels) return false;
    }

    // Check mastered facts
    if (masteredFacts > 0) {
      if (factTracker.masteredFactCount < masteredFacts) return false;
    }

    // Achievements and daily challenges are checked when they exist (Steps 9).
    // For now, these checks pass if the requirement is 0.
    // When Step 9 is implemented, wire in actual achievement counts.

    return true;
  }

  /// Build progress items for UI display.
  List<EvolutionProgressItem> progressItems(
      PlayerProfile profile, FactTracker factTracker) {
    final items = <EvolutionProgressItem>[];

    if (gamesRequired > 0) {
      final current = _gamesAtMinLevel(profile);
      items.add(EvolutionProgressItem(
        label: 'Reach level $minLevelInGames in $gamesRequired game${gamesRequired > 1 ? 's' : ''}',
        current: current,
        required_: gamesRequired,
        isMet: current >= gamesRequired,
      ));
    }

    if (totalScales > 0) {
      items.add(EvolutionProgressItem(
        label: 'Earn $totalScales scales',
        current: profile.totalScales,
        required_: totalScales,
        isMet: profile.totalScales >= totalScales,
      ));
    }

    if (threeStarLevels > 0) {
      final current = _countThreeStarLevels(profile);
      items.add(EvolutionProgressItem(
        label: '3-star $threeStarLevels levels',
        current: current,
        required_: threeStarLevels,
        isMet: current >= threeStarLevels,
      ));
    }

    if (masteredFacts > 0) {
      final current = factTracker.masteredFactCount;
      items.add(EvolutionProgressItem(
        label: 'Master $masteredFacts facts',
        current: current,
        required_: masteredFacts,
        isMet: current >= masteredFacts,
      ));
    }

    if (achievements > 0) {
      // Placeholder until Step 9
      items.add(EvolutionProgressItem(
        label: 'Unlock $achievements achievements',
        current: 0, // TODO: Step 9
        required_: achievements,
        isMet: false,
      ));
    }

    if (dailyChallenges > 0) {
      // Placeholder until Step 9
      items.add(EvolutionProgressItem(
        label: 'Complete $dailyChallenges daily challenges',
        current: 0, // TODO: Step 9
        required_: dailyChallenges,
        isMet: false,
      ));
    }

    return items;
  }

  int _gamesAtMinLevel(PlayerProfile profile) {
    const allGames = ['dragon_runes', 'fire_trail', 'dragon_eggs', 'dragons_feast'];
    return allGames.where((id) {
      final stats = profile.gameStats[id];
      return stats != null && stats.currentLevel >= minLevelInGames;
    }).length;
  }

  int _countThreeStarLevels(PlayerProfile profile) {
    int count = 0;
    for (final stats in profile.gameStats.values) {
      count += stats.levelStars.values.where((s) => s >= 3).length;
    }
    return count;
  }
}
```

### Evolution Stage Names

Already defined in `profile_bar.dart` as `evolutionNames`. No changes needed:

```
Stage 0: Egg
Stage 1: Hatchling       — fast unlock (20-30 min play)
Stage 2: Fledgling       — requires 2 games
Stage 3: Young Dragon    — requires 3 games
Stage 4: Adult Dragon    — requires all 4 games
Stage 5: Elder Dragon    — aspirational (weeks/months)
```

---

## 10. Level Select Screen

### `lib/games/shared/level_select_screen.dart`

New screen inserted between the hub and game launch. Shows all levels organized by
world, with star ratings and locked/unlocked state.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/player_profile.dart';
import '../../storage/local_storage.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';

/// Level select screen shared by all 4 games.
///
/// Shows worlds as horizontal sections with level tiles in a grid.
/// Each tile shows its level number and star rating (0-3).
/// Locked levels are dimmed and non-interactive.
class LevelSelectScreen extends StatelessWidget {
  final String gameId;
  final String gameTitle;
  final Color accentColor;
  final List<WorldDefinition> worlds;
  final void Function(int levelNumber) onLevelSelected;

  const LevelSelectScreen({
    super.key,
    required this.gameId,
    required this.gameTitle,
    required this.accentColor,
    required this.worlds,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();
    final gameStats = profile.gameStats[gameId] ?? const GameStats();

    return Scaffold(
      backgroundColor: DragonColors.nightSky,
      appBar: AppBar(
        title: Text(gameTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(DragonSpacing.md),
        itemCount: worlds.length,
        itemBuilder: (context, worldIndex) {
          final world = worlds[worldIndex];
          return _WorldSection(
            world: world,
            gameStats: gameStats,
            accentColor: accentColor,
            onLevelSelected: onLevelSelected,
          );
        },
      ),
    );
  }
}

class _WorldSection extends StatelessWidget {
  final WorldDefinition world;
  final GameStats gameStats;
  final Color accentColor;
  final void Function(int) onLevelSelected;

  const _WorldSection({
    required this.world,
    required this.gameStats,
    required this.accentColor,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: DragonSpacing.sm),
          child: Text(
            world.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: DragonSpacing.sm,
            crossAxisSpacing: DragonSpacing.sm,
            childAspectRatio: 0.85,
          ),
          itemCount: world.levelCount,
          itemBuilder: (context, index) {
            final levelNumber = world.firstLevel + index;
            final stars = gameStats.levelStars[levelNumber] ?? 0;
            final isUnlocked = _isUnlocked(levelNumber);

            return _LevelTile(
              levelNumber: levelNumber,
              stars: stars,
              isUnlocked: isUnlocked,
              accentColor: accentColor,
              onTap: isUnlocked ? () => onLevelSelected(levelNumber) : null,
            );
          },
        ),
        const SizedBox(height: DragonSpacing.lg),
      ],
    );
  }

  bool _isUnlocked(int levelNumber) {
    if (levelNumber == 1) return true; // First level always unlocked
    // Unlocked if previous level has at least 1 star
    final prevStars = gameStats.levelStars[levelNumber - 1] ?? 0;
    return prevStars >= 1;
  }
}

class _LevelTile extends StatelessWidget {
  final int levelNumber;
  final int stars;
  final bool isUnlocked;
  final Color accentColor;
  final VoidCallback? onTap;

  const _LevelTile({
    required this.levelNumber,
    required this.stars,
    required this.isUnlocked,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked
              ? DragonColors.surface
              : DragonColors.surface.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUnlocked
                ? (stars > 0 ? accentColor : DragonColors.surface)
                : DragonColors.surface.withAlpha(50),
            width: stars >= 3 ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$levelNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isUnlocked ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            if (isUnlocked) _StarRow(stars: stars),
            if (!isUnlocked)
              Icon(
                Icons.lock_outline,
                size: 16,
                color: Colors.white24,
              ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int stars;
  const _StarRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Icon(
          i < stars ? Icons.star : Icons.star_border,
          size: 12,
          color: i < stars ? DragonColors.gold : Colors.white24,
        );
      }),
    );
  }
}

/// Definition of a world's levels for the level select screen.
class WorldDefinition {
  final String name;
  final int firstLevel;
  final int levelCount;

  const WorldDefinition({
    required this.name,
    required this.firstLevel,
    required this.levelCount,
  });
}
```

### World Definitions Per Game

Each game provides its world definitions. These are added as static constants on
each game's `MathDragonsGame` implementation:

```dart
// Dragon Runes: 5 worlds × 10 levels = 50
static const worlds = [
  WorldDefinition(name: 'Ember Equations', firstLevel: 1, levelCount: 10),
  WorldDefinition(name: 'Flame Formulas', firstLevel: 11, levelCount: 10),
  WorldDefinition(name: 'Inferno Algebra', firstLevel: 21, levelCount: 10),
  WorldDefinition(name: "Dragon's Calculus", firstLevel: 31, levelCount: 10),
  WorldDefinition(name: 'Elder Runes', firstLevel: 41, levelCount: 10),
];

// Fire Trail: 5 worlds × 8 levels = 40
static const worlds = [
  WorldDefinition(name: 'First Flight', firstLevel: 1, levelCount: 8),
  WorldDefinition(name: 'Thermal Currents', firstLevel: 9, levelCount: 8),
  WorldDefinition(name: 'Firestorm', firstLevel: 17, levelCount: 8),
  WorldDefinition(name: 'Inferno', firstLevel: 25, levelCount: 8),
  WorldDefinition(name: 'Dragon Master', firstLevel: 33, levelCount: 8),
];

// Dragon Eggs: 5 worlds × 10 levels = 50
static const worlds = [
  WorldDefinition(name: 'Nest of Addition', firstLevel: 1, levelCount: 10),
  WorldDefinition(name: 'Cracking Subtraction', firstLevel: 11, levelCount: 10),
  WorldDefinition(name: 'Multiplication Roost', firstLevel: 21, levelCount: 10),
  WorldDefinition(name: 'Division Den', firstLevel: 31, levelCount: 10),
  WorldDefinition(name: 'Ancient Hatchery', firstLevel: 41, levelCount: 10),
];

// Dragon's Feast: 5 worlds × 8 levels = 40
static const worlds = [
  WorldDefinition(name: 'Easy Pickings', firstLevel: 1, levelCount: 8),
  WorldDefinition(name: 'Growing Appetite', firstLevel: 9, levelCount: 8),
  WorldDefinition(name: 'Refined Palate', firstLevel: 17, levelCount: 8),
  WorldDefinition(name: 'Gourmet Dragon', firstLevel: 25, levelCount: 8),
  WorldDefinition(name: "Dragon King's Feast", firstLevel: 33, levelCount: 8),
];
```

### Navigation Flow

```
Hub → Tap Game Card → Level Select Screen → Tap Level → Game Shell → Game
                     ← Back              ← Back / Results → Play Again (same level)
                                                          → Next Level (if unlocked)
                                                          → Back to Hub
```

The game card on the hub now navigates to LevelSelectScreen instead of directly
to the game. The level select screen handles launching the game at the chosen level.

---

## 11. Game Integration — Dragon Eggs

### How It Works Today

Dragon Eggs uses `EggSpawner` which generates individual number/operator eggs. The
spawner has a `focusFact` field and tier-based number ranges. Every 10 correct answers,
the tier advances (1-6). The `focusFact` is drawn from a random fact pool with 30%
bias toward spawning its components.

### What Changes

1. **Pass DifficultyEngine to the spawner.** The spawner calls `engine.selectNext()`
   to get the next focus fact instead of picking randomly from the fact pool.
2. **Report incorrect answers** to the engine via `engine.recordIncorrect()`.
3. **Star calculation** at game-over uses `LevelThresholds.calculateStars()`.

### Integration Points

**`dragon_eggs_flame_game.dart`** — Add engine field, pass to spawner:

```dart
class DragonEggsFlameGame extends FlameGame {
  final DifficultyEngine? difficultyEngine;
  // ... existing fields

  DragonEggsFlameGame({
    this.difficultyEngine,
    // ... existing params
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // ... existing setup
    // Provide engine to spawner
    spawner.difficultyEngine = difficultyEngine;
  }
}
```

**`egg_spawner.dart`** — Use engine to select focus facts:

```dart
class EggSpawner {
  DifficultyEngine? difficultyEngine;
  // ... existing fields

  /// Called periodically to update the focus fact.
  void _updateFocusFact() {
    if (difficultyEngine != null && _factPool.isNotEmpty) {
      focusFact = difficultyEngine!.selectNext(_factPool);
    } else if (_factPool.isNotEmpty) {
      // Fallback: random selection (existing behavior)
      focusFact = _factPool[_random.nextInt(_factPool.length)];
    }
  }
}
```

Dragon Eggs' tier system (1-6 based on correct count) is **preserved**. The engine
only influences **which numbers appear**, not the overall difficulty progression.

---

## 12. Game Integration — Fire Trail

### How It Works Today

Fire Trail uses `ProblemManager.generateProblem()` which picks a random operation
from the level's allowed list and random numbers within the level's range. One problem
at a time, with distractor gems.

### What Changes

1. **Consult engine before generating a problem.** If the engine returns a `MathFact`,
   use its operands and operation instead of random selection.
2. **Report incorrect answers** to the engine.
3. **Star calculation** at level-complete.

### Integration Points

**`problem_manager.dart`** — Add engine-aware generation:

```dart
class ProblemManager {
  DifficultyEngine? difficultyEngine;
  List<MathFact>? _eligibleFacts;
  // ... existing fields

  /// Initialize the eligible fact pool for the current level config.
  void initFactPool() {
    _eligibleFacts = FactPool.forLevel(
      numberMin: config.numberMin,
      numberMax: config.numberMax,
      operations: config.allowedOperations,
    );
  }

  /// Generate the next problem, consulting the engine if available.
  void generateProblem() {
    if (difficultyEngine != null && _eligibleFacts != null) {
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
}
```

Fire Trail's world/level config (speed, grid size, operations) is **preserved**. The
engine only influences **which specific numbers** appear in each problem.

---

## 13. Game Integration — Dragon Runes

### How It Works Today

Dragon Runes uses `LevelGenerator.generate()` which creates number families (pairs of
numbers), generates all possible equations from those families, and selects target
equations. The entire puzzle is pre-generated before the game starts.

### What Changes

Dragon Runes is the least granular integration because puzzles are holistic — you can't
swap individual facts mid-level. Instead, the engine influences **which number families
are generated** by biasing toward numbers the player needs practice on.

1. **Before level generation, query the engine** for a few suggested facts.
2. **Seed the number family generator** with operands from those suggested facts.
3. **Star calculation** at level-complete.

### Integration Points

**`level_generator.dart`** — Add engine-influenced family generation:

```dart
class LevelGenerator {
  // ... existing fields

  /// Generate a level, optionally seeded with engine-suggested facts.
  GeneratedLevel generate(
    DragonRunesConfig config, {
    List<MathFact>? suggestedFacts,
  }) {
    // 1. Generate families, biased toward suggested operands
    final families = _generateFamilies(config, suggestedFacts: suggestedFacts);

    // ... rest of generation unchanged
  }

  List<NumberFamily> _generateFamilies(
    DragonRunesConfig config, {
    List<MathFact>? suggestedFacts,
  }) {
    final families = <NumberFamily>[];
    final usedPairs = <String>{};
    final usedNumbers = <int>{};

    // Seed first family from engine suggestion if available
    if (suggestedFacts != null && suggestedFacts.isNotEmpty) {
      final fact = suggestedFacts.first;
      final a = fact.left.clamp(config.numberMin, config.numberMax);
      final b = fact.right.clamp(config.numberMin, config.numberMax);
      final lo = a < b ? a : b;
      final hi = a < b ? b : a;

      if (lo != hi || config.numberOfFamilies > 1) {
        usedPairs.add('$lo,$hi');
        usedNumbers.add(lo);
        usedNumbers.add(hi);
        families.add(NumberFamily(a: lo, b: hi));
      }
    }

    // Fill remaining families using existing logic
    // ... existing _generateFamilies code for remaining slots
  }
}
```

The caller (the screen that creates the flame game) queries the engine for 1-3
suggested facts and passes them to `generate()`.

---

## 14. Game Integration — Dragon's Feast

### How It Works Today

Dragon's Feast uses `BoardGenerator.generate()` which creates a 5x5 grid where ~40%
of tiles match a math category predicate. Categories are number-property based (even,
odd, multiples, primes, etc.), not arithmetic-fact based.

### What Changes

Dragon's Feast is the most different because it tests **number properties**, not
arithmetic facts. The engine integration focuses on biasing the **number range** toward
values the player has less experience with.

1. **Query engine for weak fact operands.** Extract the numbers involved in weak facts
   to bias tile generation toward those values.
2. **Tile respawning bias.** When tiles respawn (enemy movement), bias toward numbers
   from the engine's weak pool.
3. **Star calculation** at game-over.

### Integration Points

**`board_generator.dart`** — Add number bias:

```dart
class BoardGenerator {
  List<int>? biasNumbers; // Numbers the engine wants the player to see more
  // ... existing fields

  /// Set number bias from the difficulty engine.
  void setBias(List<int> numbers) {
    biasNumbers = numbers;
  }

  /// Generate a correct number, biased toward engine-suggested values.
  int generateSingleCorrect() {
    // 30% chance: use a biased number if it matches the category
    if (biasNumbers != null &&
        biasNumbers!.isNotEmpty &&
        random.nextDouble() < 0.30) {
      final candidates =
          biasNumbers!.where((n) => category.predicate(n)).toList();
      if (candidates.isNotEmpty) {
        return candidates[random.nextInt(candidates.length)];
      }
    }
    // Fallback: existing random generation within category range
    return _randomCorrect();
  }
}
```

Since Dragon's Feast categories test properties (not equations), the engine influence
is lighter — it biases which specific numbers appear, not the category itself.

---

## 15. Evolution Progress UI — Hub Updates

### Profile Bar Changes

Update `profile_bar.dart` to show evolution progress toward the next stage.

**Current layout:**
```
[🐲 emoji]  [Dragon Name]  [Stage Name]     [💎 1,234]  [⚙]
```

**Updated layout:**
```
[🐲 emoji]  [Dragon Name]                   [💎 1,234]  [⚙]
            [Stage Name]
            [▓▓▓▓▓▓▓░░░░ → Next Stage]
```

Add a gold shimmer progress bar (per Visual Design Guide section 8.5):

```dart
/// Evolution progress bar in the profile bar.
class EvolutionProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;    // e.g., "Young Dragon — 450/750 scales"

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A4A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [DragonColors.gold, Color(0xFFF1C40F)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
```

### Hub Game Cards

Update game cards to show star progress per game:

```
Currently:   [Game Title]  Level 12
Updated:     [Game Title]  Level 12 • ★★☆  (28/40 stars)
```

The game card already reads `totalStars` from `gameStats`. Add a display of total
stars out of maximum possible.

### Evolution Progress Tooltip

Tapping on the evolution stage name or progress bar shows a tooltip/dialog with the
detailed requirements and current progress:

```
┌──────────────────────────────────────┐
│  🐲 Young Dragon (Stage 3)          │
│                                      │
│  ✅ Reach level 15 in 3 games  3/3  │
│  ✅ Earn 3,000 scales      3,450/3K │
│  ▶  3-star 10 levels           7/10 │
│  ▶  Unlock 15 achievements    9/15  │
│                                      │
│  [▓▓▓▓▓▓▓▓░░] 78%                  │
└──────────────────────────────────────┘
```

---

## 16. Difficulty Rebalancing

Review all 4 games' level configurations to ensure the difficulty curve spans the
full 7-14 age range appropriately.

### Guiding Principles

| World | Target Age | Content | Speed/Complexity |
|-------|-----------|---------|-----------------|
| 1 | 7-8 | Addition 1-5 only | Slow, forgiving, few enemies/tiles |
| 2 | 8-9 | Add + subtract 1-10 | Medium pace |
| 3 | 10-11 | Add + sub + multiply 2-10 | Moderate challenge |
| 4 | 12-13 | All 4 operations, 2-12 | Fast, complex |
| 5 | 13-14 | All ops expanded, special modes | Maximum challenge |

### Per-Game Review

**Dragon Eggs:**
- Current 6-tier system advances every 10 correct. This may be too fast for World 1
  (a 7-year-old hits tier 2 after just 10 answers).
- Change: Tier 1 lasts longer (first 15 correct), tier 2 lasts 12 correct, then 10 each.
- Change: Tier 1 `numberMax` reduced from 5 to 4 (simpler sums).
- Dragon Eggs currently doesn't have a world/level structure — it uses the 6-tier
  progression. For the level select screen, map tiers to worlds:
  - World 1: Tiers 1-2 (Levels 1-10, based on score milestones)
  - World 2: Tiers 2-3 (Levels 11-20)
  - World 3: Tiers 3-4 (Levels 21-30)
  - World 4: Tiers 4-5 (Levels 31-40)
  - World 5: Tiers 5-6 (Levels 41-50)

**Fire Trail:**
- Current config looks well-balanced. World 1 starts at 3.5 steps/sec with addition
  1-5, World 5 is 10.5+ steps/sec with all ops.
- Minor tweak: World 1 `correctToAdvance` reduced from 6-8 to 5-7 (shorter sessions
  for young players).

**Dragon Runes:**
- Current config looks appropriate. World 1 has 1 family, addition only, 2-4 targets.
- No changes needed — the `forLevel()` factory already interpolates well.

**Dragon's Feast:**
- Current config is well-structured with 26+ categories across 5 worlds.
- Minor tweak: World 1 enemy speed increased (slower): `(4.5, 6.5)` instead of
  `(4.0, 6.0)` to give younger players more time.
- Minor tweak: World 1 `enemyCount` start at 1 instead of 2 for level 1 only.

---

## 17. Localization Updates

### New l10n Strings (`app_en.arb`)

```json
{
  "levelSelect": "Level Select",
  "worldLabel": "World {number}",
  "@worldLabel": {
    "placeholders": { "number": { "type": "int" } }
  },
  "levelLabel": "Level {number}",
  "@levelLabel": {
    "placeholders": { "number": { "type": "int" } }
  },
  "levelLocked": "Locked",
  "starsEarned": "{count} stars",
  "@starsEarned": {
    "placeholders": { "count": { "type": "int" } }
  },
  "evolutionProgress": "{current} → {next}",
  "@evolutionProgress": {
    "placeholders": {
      "current": { "type": "String" },
      "next": { "type": "String" }
    }
  },
  "evolutionMaxed": "Elder Dragon — Maximum Evolution!",
  "requirementMet": "Complete!",
  "requirementProgress": "{current}/{required}",
  "@requirementProgress": {
    "placeholders": {
      "current": { "type": "int" },
      "required": { "type": "int" }
    }
  },
  "reachLevelInGames": "Reach level {level} in {count} game(s)",
  "@reachLevelInGames": {
    "placeholders": {
      "level": { "type": "int" },
      "count": { "type": "int" }
    }
  },
  "earnScales": "Earn {count} scales",
  "@earnScales": {
    "placeholders": { "count": { "type": "int" } }
  },
  "threeStarLevels": "3-star {count} levels",
  "@threeStarLevels": {
    "placeholders": { "count": { "type": "int" } }
  },
  "masterFacts": "Master {count} facts",
  "@masterFacts": {
    "placeholders": { "count": { "type": "int" } }
  },
  "trySuggestion": "Try {game} for bonus scales!",
  "@trySuggestion": {
    "placeholders": { "game": { "type": "String" } }
  }
}
```

---

## 18. Unit Tests

### `test/core/difficulty_engine_test.dart`

```dart
// Test: selectNext returns a fact from the eligible pool
// Test: no repeat within 3 problems (call selectNext 4+ times, verify spacing)
// Test: recently incorrect fact re-presented within 5 problems
// Test: bucket categorization matches FactTracker accuracy thresholds
// Test: 40% cap on needs-practice (mock a player with many weak facts,
//       verify no more than 40% of 100 selections are from needs-practice)
// Test: stale facts (7+ days) are boosted in selection frequency
// Test: empty buckets redistribute weight correctly
// Test: all buckets empty except newFact — still works
// Test: single eligible fact — always returns it (after spacing window)
// Test: resetSession clears recent history
```

### `test/core/progression_manager_test.dart`

```dart
// Test: Stage 1 evolution triggers at level 3 in 1 game + 100 scales
// Test: Stage 2 requires level 8 in 2 different games
// Test: Stage 3 requires level 15 in 3 different games + 3000 scales + 10 3-star levels
// Test: Stage 4 requires all 4 games at level 25
// Test: Stage 5 requires 100 mastered facts
// Test: Evolution doesn't skip stages (stage 2 must be earned before 3)
// Test: progressItems returns correct current/required values
// Test: overallProgress calculation is average of all requirements
// Test: suggestGame returns least-played game that isn't current
// Test: checkEvolution updates profile when requirements met
// Test: checkEvolution does NOT update when requirements not met
```

### `test/games/shared/difficulty_config_test.dart`

```dart
// Test: LevelThresholds.calculateStars — 0 stars when problems < minimum
// Test: LevelThresholds.calculateStars — 0 stars when accuracy < 60%
// Test: LevelThresholds.calculateStars — 1 star at 60% accuracy, enough problems
// Test: LevelThresholds.calculateStars — 2 stars at 75%+ accuracy AND median score
// Test: LevelThresholds.calculateStars — 3 stars at 90%+ accuracy AND high score
// Test: LevelThresholds.calculateStars — 2 stars NOT granted if score below median
// Test: FactPool.forLevel generates correct fact pool for addition-only level
// Test: FactPool.forLevel generates correct pool for all-operations level
// Test: GameScoreThresholds.fireTrail returns increasing thresholds per level
```

### `test/games/shared/level_select_screen_test.dart`

```dart
// Test: Level 1 is always unlocked
// Test: Level 2 locked when level 1 has 0 stars
// Test: Level 2 unlocked when level 1 has >= 1 star
// Test: Star display matches gameStats.levelStars
// Test: Tapping unlocked level calls onLevelSelected
// Test: Tapping locked level does NOT call onLevelSelected
// Test: All worlds rendered with correct level counts
// Test: World names displayed correctly
```

---

## 19. Verification Checklist

### Core Engine
- [ ] **DifficultyEngine selects facts** — verified with unit tests
- [ ] **4 buckets categorize correctly** — needs-practice/reinforcing/mastered/new
- [ ] **40% cap enforced** — no more than 40% from needs-practice in a session
- [ ] **Spacing rules work** — no repeat in 3, re-present incorrect in 5, stale boost
- [ ] **Engine is stateless** — all persistent data lives in FactTracker

### Game Integration
- [ ] **Dragon Eggs** — spawner uses engine for focus fact selection
- [ ] **Fire Trail** — problem manager consults engine before random generation
- [ ] **Dragon Runes** — level generator receives engine-suggested families
- [ ] **Dragon's Feast** — board generator biases numbers toward engine suggestions
- [ ] **All 4 games fallback gracefully** — if engine returns null, existing random works

### Stars & Levels
- [ ] **Star calculation correct** — 0/1/2/3 stars per LevelThresholds rules
- [ ] **Stars persisted** — levelStars map updated in profile (best-only)
- [ ] **Level unlocking** — next level unlocks at 1 star
- [ ] **Level select screen** — shows all worlds/levels with stars and lock state
- [ ] **Navigation flow** — hub → level select → game → results → play again/next/hub

### Dragon Evolution
- [ ] **Stage 1 (Hatchling)** — triggers at level 3 in 1 game + 100 scales
- [ ] **Stage 2 (Fledgling)** — triggers at level 8 in 2 games + 750 scales
- [ ] **Evolution stored** — dragonEvolution updated in PlayerProfile
- [ ] **Progress bar** — shows in profile bar with gold shimmer
- [ ] **Progress details** — tapping shows remaining requirements

### Difficulty Balance
- [ ] **World 1 accessible to 7-year-old** — addition 1-5, slow, forgiving
- [ ] **World 5 challenges a 14-year-old** — all ops, fast, complex
- [ ] **Games feel fun** — adaptive system is invisible, not punishing

### Quality
- [ ] **`flutter analyze`** passes clean
- [ ] **`flutter test`** passes (all existing + new tests)
- [ ] **`flutter build apk --debug`** succeeds
- [ ] **No regressions** — all 4 games still fully playable
- [ ] **Performance** — engine selection is fast (< 1ms per call)

---

## What Comes Next (Out of Scope)

These are explicitly out of scope for Step 8:

- **Achievement definitions/checking** — Step 9
- **Daily challenge generation** — Step 9
- **Currency spending UI (cosmetics store)** — Step 9
- **Cloud sync / Firebase** — Step 10
- **IAP** — Step 11
- **Sound / art / polish** — Step 12

Step 8 builds the **educational engine and progression skeleton**. After this step,
the app is a genuinely adaptive math tutor that knows what each player needs to
practice, rewards improvement with stars, and motivates variety through dragon
evolution. The games will feel noticeably smarter — always challenging but never
frustrating.
