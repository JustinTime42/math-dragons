# Step 9: Currency, Achievements & Daily Challenges

> **Goal:** Implement the full reward loop — earning scales, spending them on dragon
> cosmetics in a shop screen, unlocking achievements across per-game/cross-game/milestone
> categories with popup notifications, generating deterministic daily challenges with
> streak tracking, and enhancing the "just one more" session flow with encouraging text
> and animated scale counters. After this step, players have clear reasons to keep playing:
> earn scales, buy cosmetics, chase achievements, and maintain daily challenge streaks.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 8 complete. Adaptive difficulty engine and progression system
> working. All 4 games fully playable. `flutter analyze` clean. `flutter test` green.
> `flutter build apk --debug` succeeds.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [File Structure](#4-file-structure)
5. [Scales Earning Verification](#5-scales-earning-verification)
6. [Achievement System — Data Model](#6-achievement-system--data-model)
7. [Achievement Definitions](#7-achievement-definitions)
8. [AchievementTracker — Detection & Unlocking](#8-achievementtracker--detection--unlocking)
9. [Achievement Popup UI](#9-achievement-popup-ui)
10. [Achievement Display Screen](#10-achievement-display-screen)
11. [Daily Challenge System](#11-daily-challenge-system)
12. [Daily Challenge Card — Hub Integration](#12-daily-challenge-card--hub-integration)
13. [Cosmetics Store Screen](#13-cosmetics-store-screen)
14. [Dragon Customization](#14-dragon-customization)
15. ["Just One More" Session Flow](#15-just-one-more-session-flow)
16. [Animated Scales Counter](#16-animated-scales-counter)
17. [ProgressionManager Integration](#17-progressionmanager-integration)
18. [Localization Updates](#18-localization-updates)
19. [Unit Tests](#19-unit-tests)
20. [Verification Checklist](#20-verification-checklist)

---

## 1. User Stories

### US-9.1: Scales Earning
**As a** player,
**I want** to see my Dragon Scales increase with satisfying animations when I answer
correctly, complete levels, and achieve streaks,
**so that** I feel rewarded for every action and motivated to keep playing.

### US-9.2: Cosmetics Store
**As a** player,
**I want** to spend my Dragon Scales on color variants and accessories for my dragon,
**so that** I can personalize my dragon and have a reason to earn more scales.

### US-9.3: Dragon Customization
**As a** player,
**I want** to see my purchased cosmetics on my dragon in the hub,
**so that** my purchases feel meaningful and visible.

### US-9.4: Achievement Unlocking
**As a** player,
**I want** to unlock achievements for milestones like completing levels, building streaks,
and trying multiple games,
**so that** I have extra goals beyond level progression to work toward.

### US-9.5: Achievement Popup
**As a** player,
**I want** to see a satisfying notification when I unlock an achievement during gameplay,
**so that** the moment feels special and I know exactly what I earned.

### US-9.6: Achievement Collection
**As a** player,
**I want** to browse all achievements in categories (per-game, cross-game, milestones)
and see which I've unlocked and which are still locked with progress indicators,
**so that** I can plan what to work toward next.

### US-9.7: Daily Challenge
**As a** player,
**I want** a set of 2-3 small tasks each day that are different from yesterday's,
**so that** I have a reason to come back every day and play a variety of games.

### US-9.8: Daily Challenge Streak
**As a** player,
**I want** to see my daily challenge streak grow and earn bonus scales for consecutive days,
**so that** maintaining a daily habit feels rewarding.

### US-9.9: Session Encouragement
**As a** player,
**I want** the result screen to tell me when I'm close to beating my high score or
completing a level, and gently suggest trying other games after 3+ rounds of the same one,
**so that** I feel encouraged to play "just one more" and explore all the games.

---

## 2. Acceptance Criteria

### Scales & Store
- [ ] RewardService awards scales at correct rates per MOBILE_APP_PLAN.md section 9
- [ ] Animated scales counter in HUD: number ticks up, "+X" floats upward, gold particles
- [ ] Store screen accessible from hub (profile bar or dedicated button)
- [ ] 8 dragon color variants purchasable (50-200 scales each)
- [ ] 6 dragon accessories purchasable (100-500 scales each)
- [ ] Current scales balance displayed in store
- [ ] Purchase button disabled when insufficient scales
- [ ] Owned items show checkmark, equipped items show "Equipped" badge
- [ ] Purchased cosmetics persisted to PlayerProfile

### Achievements
- [ ] 30+ achievements defined across 3 categories: per-game, cross-game, milestone
- [ ] Achievement data model with Hive persistence (new typeId)
- [ ] AchievementTracker listens to EventBus and checks all locked achievements after events
- [ ] Unlocked achievements award bonus scales (25-100)
- [ ] Achievement popup banner: slides down from top, holds 2s, slides up (3s total)
- [ ] Achievement popup shows badge icon, name, and "+X scales"
- [ ] Achievement popup uses haptics (triple tap per Visual Design Guide)
- [ ] Achievement display screen with 3 tabs: Per-Game, Cross-Game, Milestones
- [ ] Unlocked achievements: full color, gold border
- [ ] Locked achievements: greyed out, progress indicator where applicable
- [ ] Achievement screen accessible from hub (profile bar area or bottom)

### Daily Challenges
- [ ] 2-3 tasks generated deterministically from date (same for all players on same day)
- [ ] Task templates: score thresholds, level completions, streaks, game variety
- [ ] Completion tracked locally, persisted to storage
- [ ] DailyChallengeCard in hub shows today's tasks with check/uncheck state
- [ ] 25 base scales on full completion + streak bonus (+5/day, cap +25)
- [ ] Streak count displayed with flame icon
- [ ] Streak resets if a day is missed
- [ ] Challenge refreshes at midnight local time

### Session Flow
- [ ] Result screen "Play Again" is gold/primary and larger
- [ ] Result screen "Back to Hub" is secondary/outline and smaller
- [ ] Encouraging text when near high score or level completion
- [ ] Gentle game suggestion after 3+ consecutive same-game sessions
- [ ] Never force a game switch — suggestion is dismissible

### Integration
- [ ] ProgressionManager evolution checks include real achievement count
- [ ] ProgressionManager evolution checks include real daily challenge count
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (all existing + new tests)
- [ ] `flutter build apk --debug` succeeds

---

## 3. Architecture Overview

### Reward Loop Data Flow

```
┌────────────────────────────────────────────────────────────┐
│                    PLAYER ACTIONS                            │
│  Correct answer → AnswerGiven event                         │
│  Complete level → LevelCompleted event                      │
│  Reach streak  → StreakAchieved event                       │
│  Start game    → GameStarted event                          │
└─────────────┬──────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────┐
│                    EVENT BUS                                  │
│  (existing stream-based typed pub/sub from Step 2)           │
└───────┬──────────┬─────────────┬───────────────────────────┘
        │          │             │
        ▼          ▼             ▼
┌──────────┐ ┌──────────────┐ ┌──────────────────────┐
│ Reward   │ │ Achievement  │ │ DailyChallenge       │
│ Service  │ │ Tracker      │ │ Manager              │
│(existing)│ │ (NEW)        │ │ (NEW)                │
│          │ │              │ │                      │
│ Awards   │ │ Checks all   │ │ Checks task          │
│ scales   │ │ locked       │ │ completion from      │
│ per rate │ │ achievements │ │ game results         │
│ table    │ │ → unlocks    │ │ → marks complete     │
│          │ │ → awards     │ │ → awards streak      │
│          │ │   bonus      │ │   bonus scales       │
└────┬─────┘ └───────┬──────┘ └──────────┬───────────┘
     │               │                    │
     └───────────────┼────────────────────┘
                     ▼
         ┌──────────────────────┐
         │  LocalStorage (Hive) │
         │  PlayerProfile +     │
         │  achievements box +  │
         │  daily challenge box │
         └──────────────────────┘
```

### Key Design Decisions

1. **AchievementTracker is an EventBus listener.** Like RewardService and ProgressionManager,
   it subscribes to game events and checks achievements reactively. Achievements are never
   checked by games directly — complete decoupling.

2. **Daily challenges are deterministic from date.** Using the date as a seed for a
   pseudo-random generator ensures all players get the same challenges on the same day.
   This enables potential future leaderboards without any server coordination.

3. **Cosmetics are IDs, not complex objects.** Each cosmetic is identified by a string ID
   (e.g., `"color_crimson"`, `"accessory_crown"`). The catalog of available cosmetics is
   defined in code. PlayerProfile stores owned/equipped IDs. This keeps serialization simple.

4. **Achievement popup is an overlay, not a dialog.** It doesn't pause gameplay or require
   dismissal. It slides in, shows for 2 seconds, and slides out automatically. Multiple
   achievements queue and show sequentially.

5. **Store screen is a full screen, not a dialog.** Accessible from hub via a dedicated
   route. Shows IAP products alongside scale-purchasable cosmetics (IAP products are
   placeholder until Step 11).

---

## 4. File Structure

```
math_dragons/lib/
├── core/
│   ├── achievement.dart              ← CREATE — data model + definitions
│   ├── achievement_tracker.dart      ← CREATE — event listener + unlock logic
│   ├── daily_challenge.dart          ← REPLACE stub — full implementation
│   ├── daily_challenge_manager.dart  ← CREATE — generation + tracking
│   ├── reward_service.dart           (existing — verify rates, add achievement bonus)
│   ├── progression_manager.dart      (existing — wire real achievement/daily counts)
│   └── game_events.dart              (existing — add AchievementUnlocked event)
├── hub/
│   ├── hub_screen.dart               ← MODIFY — add achievements button, wire daily card
│   ├── daily_challenge_card.dart     ← REPLACE placeholder — functional card
│   ├── profile_bar.dart              ← MODIFY — add cosmetics display, achievements access
│   └── achievement_screen.dart       ← CREATE — tabbed achievement browser
├── monetization/
│   └── store_screen.dart             ← CREATE — cosmetics store with scale purchasing
├── games/shared/
│   └── result_screen.dart            ← MODIFY — encouragement text, game suggestions
├── widgets/
│   ├── achievement_popup.dart        ← CREATE — slide-in achievement notification
│   ├── animated_scales_counter.dart  ← CREATE — animated counter with particles
│   └── cosmetic_preview.dart         ← CREATE — dragon cosmetic display widget
├── storage/
│   └── local_storage.dart            ← MODIFY — add achievements/daily challenge boxes
└── l10n/
    └── app_en.arb                    ← MODIFY — ~60 new strings

math_dragons/test/
├── core/
│   ├── achievement_tracker_test.dart  ← CREATE
│   ├── daily_challenge_manager_test.dart ← CREATE
│   └── achievement_test.dart          ← CREATE
├── hub/
│   └── daily_challenge_card_test.dart ← CREATE
└── monetization/
    └── store_screen_test.dart         ← CREATE
```

---

## 5. Scales Earning Verification

### Current State

`RewardService` and `ScaleRates` are already implemented in Step 2. Verify all rates match
MOBILE_APP_PLAN.md section 9:

| Action | Expected Scales | Implemented In |
|--------|----------------|----------------|
| Correct answer (base) | 1-3 (scales with level) | `ScaleRates.basePerCorrect(level)` |
| Streak bonus | +1 per consecutive, cap +5 | `ScaleRates.streakBonus(length)` |
| Level completion | 10-30 (scales with level) | `ScaleRates.levelCompletion(level)` |
| 3-star completion | +15 bonus | `ScaleRates.threeStarBonus` |
| First time playing new game | 50 (one-time) | `RewardService._onGameStarted()` |
| Daily challenge completion | 25 | `ScaleRates.dailyChallengeBase` |
| Daily challenge streak bonus | +5/day, cap +25 | `ScaleRates.dailyChallengeStreakBonus()` |

### What Changes

1. **Achievement bonus scales.** When an achievement unlocks, AchievementTracker calls
   `rewardService.awardExternalScales(achievement.scalesReward)` to credit the bonus.

2. **Daily challenge scales.** When DailyChallengeManager marks all tasks complete, it
   awards scales via `rewardService.awardExternalScales()`.

No changes needed to the base earning rates themselves — they're already correct.

---

## 6. Achievement System — Data Model

### `lib/core/achievement.dart`

```dart
import 'package:hive/hive.dart';

part 'achievement.g.dart';

/// A single achievement definition.
class AchievementDef {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final int scalesReward;
  final String? gameId;          // null for cross-game/milestone
  final String iconEmoji;         // placeholder until Step 12 art

  /// Function that checks if the achievement should unlock.
  /// Receives the current state snapshot and returns true if met.
  final bool Function(AchievementCheckContext) checkUnlocked;

  /// Optional: returns progress as (current, target) for progress display.
  /// Null if achievement is binary (no partial progress).
  final (int, int)? Function(AchievementCheckContext)? getProgress;

  const AchievementDef({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.scalesReward,
    this.gameId,
    required this.iconEmoji,
    required this.checkUnlocked,
    this.getProgress,
  });
}

/// Context passed to achievement check functions.
class AchievementCheckContext {
  final Map<String, dynamic> profile;   // PlayerProfile as map
  final int totalCorrectAnswers;
  final int totalScales;
  final int dragonEvolution;
  final Map<String, GameStatsSnapshot> gameStats;
  final int masteredFacts;
  final int totalThreeStarLevels;
  final int dailyChallengeStreak;
  final int totalDailyChallenges;

  /// The event that triggered this check (may be null for manual checks).
  final String? triggerEventGameId;
  final int? triggerStreakLength;
  final int? triggerLevelNumber;
  final double? triggerAccuracy;

  const AchievementCheckContext({
    required this.profile,
    required this.totalCorrectAnswers,
    required this.totalScales,
    required this.dragonEvolution,
    required this.gameStats,
    required this.masteredFacts,
    required this.totalThreeStarLevels,
    required this.dailyChallengeStreak,
    required this.totalDailyChallenges,
    this.triggerEventGameId,
    this.triggerStreakLength,
    this.triggerLevelNumber,
    this.triggerAccuracy,
  });
}

/// Snapshot of a single game's stats for achievement checking.
class GameStatsSnapshot {
  final int currentLevel;
  final int highScore;
  final int totalStars;
  final int timesPlayed;
  final int bestStreak;
  final double accuracy;
  final int totalCorrect;
  final int totalAttempted;
  final Map<int, int> levelStars;

  const GameStatsSnapshot({
    this.currentLevel = 1,
    this.highScore = 0,
    this.totalStars = 0,
    this.timesPlayed = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
    this.totalCorrect = 0,
    this.totalAttempted = 0,
    this.levelStars = const {},
  });
}

enum AchievementCategory {
  perGame,
  crossGame,
  milestone,
}

/// Persisted achievement state: which achievements have been unlocked and when.
@HiveType(typeId: 5)
class UnlockedAchievement extends HiveObject {
  @HiveField(0)
  final String achievementId;

  @HiveField(1)
  final DateTime unlockedAt;

  @HiveField(2)
  final int scalesAwarded;

  UnlockedAchievement({
    required this.achievementId,
    required this.unlockedAt,
    required this.scalesAwarded,
  });
}
```

**Hive typeId registry update:**
- 0 = PlayerProfile
- 1 = GameStats
- 2 = PlayerSettings
- 3 = FactRecord
- 4 = FactStatus
- **5 = UnlockedAchievement** (NEW)
- **6 = DailyChallengeState** (NEW — see section 11)

---

## 7. Achievement Definitions

### Per-Game Achievements (~8-10 per game, 32-40 total)

Each game has a parallel set with game-specific flavor:

#### Dragon Runes
| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `runes_first` | First Rune | Complete your first Dragon Runes level | Level 1 completed | 25 |
| `runes_10` | Rune Caster | Complete 10 Dragon Runes levels | currentLevel >= 10 | 50 |
| `runes_25` | Rune Master | Complete 25 Dragon Runes levels | currentLevel >= 25 | 75 |
| `runes_all_worlds` | Elder Runekeeper | Complete all 50 Dragon Runes levels | currentLevel >= 50 | 100 |
| `runes_perfect` | Perfect Spell | 3-star a Dragon Runes level with 100% accuracy | Any level 3-star + 100% acc trigger | 50 |
| `runes_streak_10` | Chain Lightning | Build a 10-streak in Dragon Runes | bestStreak >= 10 | 50 |
| `runes_streak_20` | Thunderstorm | Build a 20-streak in Dragon Runes | bestStreak >= 20 | 75 |
| `runes_speed` | Speed Caster | Complete a Dragon Runes level in under 60 seconds | Timed level completion | 50 |

#### Fire Trail
| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `trail_first` | First Flight | Complete your first Fire Trail level | Level 1 completed | 25 |
| `trail_10` | Thermal Rider | Complete 10 Fire Trail levels | currentLevel >= 10 | 50 |
| `trail_25` | Firestorm Pilot | Complete 25 Fire Trail levels | currentLevel >= 25 | 75 |
| `trail_all_worlds` | Dragon Master | Complete all 40 Fire Trail levels | currentLevel >= 40 | 100 |
| `trail_perfect` | Perfect Run | 3-star a Fire Trail level with 100% accuracy | Any level 3-star + 100% acc trigger | 50 |
| `trail_streak_10` | Blazing Streak | Build a 10-streak in Fire Trail | bestStreak >= 10 | 50 |
| `trail_streak_20` | Inferno Chain | Build a 20-streak in Fire Trail | bestStreak >= 20 | 75 |
| `trail_survivor` | Iron Flame | Complete a Fire Trail level without any wrong answers | Level complete with 100% accuracy | 50 |

#### Dragon Eggs
| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `eggs_first` | First Hatch | Complete your first Dragon Eggs level | Level 1 completed | 25 |
| `eggs_10` | Egg Collector | Complete 10 Dragon Eggs levels | currentLevel >= 10 | 50 |
| `eggs_25` | Hatchery Master | Complete 25 Dragon Eggs levels | currentLevel >= 25 | 75 |
| `eggs_all_worlds` | Ancient Keeper | Complete all 50 Dragon Eggs levels | currentLevel >= 50 | 100 |
| `eggs_perfect` | Perfect Hatch | 3-star a Dragon Eggs level with 100% accuracy | Any level 3-star + 100% acc trigger | 50 |
| `eggs_streak_10` | Combo Cracker | Build a 10-streak in Dragon Eggs | bestStreak >= 10 | 50 |
| `eggs_streak_20` | Hatch Storm | Build a 20-streak in Dragon Eggs | bestStreak >= 20 | 75 |
| `eggs_division` | Division Dragon | Complete a Dragon Eggs level using division | Level 31+ completed | 50 |

#### Dragon's Feast
| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `feast_first` | First Bite | Complete your first Dragon's Feast level | Level 1 completed | 25 |
| `feast_10` | Hungry Dragon | Complete 10 Dragon's Feast levels | currentLevel >= 10 | 50 |
| `feast_25` | Gourmet Dragon | Complete 25 Dragon's Feast levels | currentLevel >= 25 | 75 |
| `feast_all_worlds` | Feast King | Complete all 40 Dragon's Feast levels | currentLevel >= 40 | 100 |
| `feast_perfect` | Perfect Palate | 3-star a Dragon's Feast level with 100% accuracy | Any level 3-star + 100% acc trigger | 50 |
| `feast_streak_10` | Feeding Frenzy | Build a 10-streak in Dragon's Feast | bestStreak >= 10 | 50 |
| `feast_streak_20` | Insatiable | Build a 20-streak in Dragon's Feast | bestStreak >= 20 | 75 |
| `feast_no_catch` | Untouchable | Complete a Dragon's Feast level without being caught | Level complete, no caught events | 50 |

### Cross-Game Achievements (10)

| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `cross_explorer` | Dragon Explorer | Play all 4 games in one day | 4 unique gameIds played today | 50 |
| `cross_wellrounded` | Well-Rounded | Earn scales in 3 different games in one session | 3 unique gameIds in session | 50 |
| `cross_variety` | Variety Pack | Reach level 5 in all 4 games | All 4 games currentLevel >= 5 | 75 |
| `cross_olympian` | Math Olympian | 3-star a level in every game | Each game has at least one 3-star | 75 |
| `cross_daily_7` | Daily Devotion | Complete 7 daily challenges in a row | dailyChallengeStreak >= 7 | 75 |
| `cross_daily_14` | Two Week Warrior | Complete 14 daily challenges in a row | dailyChallengeStreak >= 14 | 100 |
| `cross_daily_30` | Monthly Master | Complete 30 daily challenges in a row | dailyChallengeStreak >= 30 | 100 |
| `cross_all_world1` | World Wanderer | Complete World 1 in all 4 games | All 4 games currentLevel >= world1 max | 75 |
| `cross_all_world3` | Realm Explorer | Complete World 3 in all 4 games | All 4 games currentLevel >= world3 max | 100 |
| `cross_total_stars_50` | Star Gatherer | Earn 50 total stars across all games | Sum of totalStars >= 50 | 75 |

### Milestone Achievements (10)

| ID | Title | Description | Requirement | Scales |
|----|-------|-------------|-------------|--------|
| `mile_century` | Century | Answer 100 problems correctly | totalCorrectAnswers >= 100 | 50 |
| `mile_thousand` | Thousand Strong | Answer 1,000 problems correctly | totalCorrectAnswers >= 1000 | 75 |
| `mile_five_thousand` | Math Machine | Answer 5,000 problems correctly | totalCorrectAnswers >= 5000 | 100 |
| `mile_facts_25` | Fact Finder | Master 25 math facts (90%+ accuracy) | masteredFacts >= 25 | 50 |
| `mile_facts_50` | Fact Scholar | Master 50 math facts | masteredFacts >= 50 | 75 |
| `mile_facts_100` | Fact Titan | Master 100 math facts | masteredFacts >= 100 | 100 |
| `mile_times_tables` | Times Table Titan | Master all multiplication facts 1-12 | All 144 mult facts mastered | 100 |
| `mile_scales_1000` | Scale Collector | Earn 1,000 total scales | totalScales >= 1000 | 50 |
| `mile_scales_5000` | Scale Hoarder | Earn 5,000 total scales | totalScales >= 5000 | 75 |
| `mile_evolution_3` | Dragon Raiser | Reach dragon evolution stage 3 | dragonEvolution >= 3 | 75 |

**Total: 52 achievements** (32 per-game + 10 cross-game + 10 milestone)

### Implementation

All achievements are defined as a static list in `achievement.dart`:

```dart
/// The complete catalog of all achievements.
class AchievementCatalog {
  static final List<AchievementDef> all = [
    ...perGameAchievements,
    ...crossGameAchievements,
    ...milestoneAchievements,
  ];

  static final List<AchievementDef> perGameAchievements = [
    // Dragon Runes
    AchievementDef(
      id: 'runes_first',
      title: 'First Rune',
      description: 'Complete your first Dragon Runes level',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 25,
      iconEmoji: '\u{1F4DC}', // scroll
      checkUnlocked: (ctx) =>
          (ctx.gameStats['dragon_runes']?.currentLevel ?? 0) >= 2,
    ),
    // ... remaining definitions follow this pattern
  ];
}
```

Each `checkUnlocked` function is a pure function that receives an `AchievementCheckContext`
snapshot and returns `true` if the requirement is met. This makes achievements trivially
testable and completely decoupled from game code.

---

## 8. AchievementTracker — Detection & Unlocking

### `lib/core/achievement_tracker.dart`

The AchievementTracker subscribes to EventBus events and runs achievement checks after
each relevant event.

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'achievement.dart';
import 'event_bus.dart';
import 'game_events.dart';
import 'fact_tracker.dart';
import 'player_profile.dart';
import 'reward_service.dart';
import '../storage/local_storage.dart';

/// Listens to game events and unlocks achievements when requirements are met.
class AchievementTracker {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final FactTracker _factTracker;
  final RewardService _rewardService;
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

  /// Fires when an achievement is unlocked. UI listens to show popup.
  final ValueNotifier<AchievementDef?> lastUnlocked = ValueNotifier(null);

  /// Queue of newly unlocked achievements (for sequential popup display).
  final List<AchievementDef> _unlockQueue = [];

  /// Callback for when achievements are unlocked (for popup display).
  void Function(AchievementDef)? onAchievementUnlocked;

  AchievementTracker({
    required EventBus eventBus,
    required LocalStorage storage,
    required FactTracker factTracker,
    required RewardService rewardService,
  })  : _eventBus = eventBus,
        _storage = storage,
        _factTracker = factTracker,
        _rewardService = rewardService {
    _subscribe();
  }

  void _subscribe() {
    // Check after every significant game event
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen((e) => _checkAll(
            triggerGameId: e.gameId,
            triggerLevel: e.levelNumber,
            triggerAccuracy: e.accuracy,
          )),
    );
    _subscriptions.add(
      _eventBus.on<StreakAchieved>().listen((e) => _checkAll(
            triggerGameId: e.gameId,
            triggerStreak: e.streakLength,
          )),
    );
    _subscriptions.add(
      _eventBus.on<GameEnded>().listen((e) => _checkAll(
            triggerGameId: e.gameId,
          )),
    );
  }

  /// Check all locked achievements against current state.
  void _checkAll({
    String? triggerGameId,
    int? triggerStreak,
    int? triggerLevel,
    double? triggerAccuracy,
  }) {
    final unlockedIds = _storage.getUnlockedAchievementIds();
    final context = _buildContext(
      triggerGameId: triggerGameId,
      triggerStreak: triggerStreak,
      triggerLevel: triggerLevel,
      triggerAccuracy: triggerAccuracy,
    );

    for (final achievement in AchievementCatalog.all) {
      if (unlockedIds.contains(achievement.id)) continue;

      if (achievement.checkUnlocked(context)) {
        _unlock(achievement);
      }
    }
  }

  void _unlock(AchievementDef achievement) {
    final unlocked = UnlockedAchievement(
      achievementId: achievement.id,
      unlockedAt: DateTime.now(),
      scalesAwarded: achievement.scalesReward,
    );

    _storage.saveUnlockedAchievement(unlocked);
    _rewardService.awardExternalScales(achievement.scalesReward);

    // Notify UI for popup
    onAchievementUnlocked?.call(achievement);
    lastUnlocked.value = achievement;
  }

  AchievementCheckContext _buildContext({
    String? triggerGameId,
    int? triggerStreak,
    int? triggerLevel,
    double? triggerAccuracy,
  }) {
    final profile = _storage.getProfile();

    final gameStatsMap = <String, GameStatsSnapshot>{};
    for (final entry in profile.gameStats.entries) {
      final s = entry.value;
      gameStatsMap[entry.key] = GameStatsSnapshot(
        currentLevel: s.currentLevel,
        highScore: s.highScore,
        totalStars: s.totalStars,
        timesPlayed: s.timesPlayed,
        bestStreak: s.bestStreak,
        accuracy: s.accuracy,
        totalCorrect: s.totalCorrect,
        totalAttempted: s.totalAttempted,
        levelStars: Map.of(s.levelStars),
      );
    }

    return AchievementCheckContext(
      profile: {},
      totalCorrectAnswers: profile.totalCorrectAnswers,
      totalScales: profile.totalScales,
      dragonEvolution: profile.dragonEvolution,
      gameStats: gameStatsMap,
      masteredFacts: _factTracker.masteredFactCount,
      totalThreeStarLevels: _countThreeStarLevels(profile),
      dailyChallengeStreak: profile.dailyChallengeStreak,
      totalDailyChallenges: _storage.getTotalDailyChallengesCompleted(),
      triggerEventGameId: triggerGameId,
      triggerStreakLength: triggerStreak,
      triggerLevelNumber: triggerLevel,
      triggerAccuracy: triggerAccuracy,
    );
  }

  int _countThreeStarLevels(PlayerProfile profile) {
    int count = 0;
    for (final stats in profile.gameStats.values) {
      count += stats.levelStars.values.where((s) => s >= 3).length;
    }
    return count;
  }

  /// Get the total number of unlocked achievements.
  int get unlockedCount => _storage.getUnlockedAchievementIds().length;

  /// Check if a specific achievement is unlocked.
  bool isUnlocked(String achievementId) =>
      _storage.getUnlockedAchievementIds().contains(achievementId);

  /// Get progress for a specific achievement (returns null if no progress tracking).
  (int, int)? getProgress(String achievementId) {
    final def = AchievementCatalog.all
        .where((a) => a.id == achievementId)
        .firstOrNull;
    if (def == null || def.getProgress == null) return null;
    return def.getProgress!(_buildContext());
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    lastUnlocked.dispose();
  }
}
```

### Performance Consideration

Checking 52 achievements after every game event might seem expensive, but each check is:
- A simple field comparison (e.g., `currentLevel >= 10`)
- Against already-loaded in-memory data
- Skipping already-unlocked achievements

In practice, this takes < 1ms and is invisible to the player.

---

## 9. Achievement Popup UI

### `lib/widgets/achievement_popup.dart`

A banner notification that slides down from the top when an achievement unlocks.

```dart
import 'package:flutter/material.dart';
import '../core/achievement.dart';
import '../core/haptics_service.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Overlay widget that manages achievement popup display.
///
/// Wrap this around the main app scaffold. When an achievement unlocks,
/// the popup slides down from the top, holds for 2 seconds, and slides up.
class AchievementPopupOverlay extends StatefulWidget {
  final Widget child;

  const AchievementPopupOverlay({super.key, required this.child});

  /// Show an achievement popup from anywhere in the widget tree.
  static void show(BuildContext context, AchievementDef achievement) {
    final state = context.findAncestorStateOfType<_AchievementPopupOverlayState>();
    state?._enqueue(achievement);
  }

  @override
  State<AchievementPopupOverlay> createState() => _AchievementPopupOverlayState();
}

class _AchievementPopupOverlayState extends State<AchievementPopupOverlay>
    with SingleTickerProviderStateMixin {
  final List<AchievementDef> _queue = [];
  AchievementDef? _current;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  void _enqueue(AchievementDef achievement) {
    _queue.add(achievement);
    if (_current == null) _showNext();
  }

  Future<void> _showNext() async {
    if (_queue.isEmpty) {
      setState(() => _current = null);
      return;
    }

    setState(() => _current = _queue.removeAt(0));

    // Haptic: triple tap (achievement unlock per Visual Design Guide)
    HapticsService.instance.onAchievementUnlocked();

    // Slide in
    await _controller.forward();

    // Hold for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Slide out
    await _controller.reverse();

    // Show next in queue (if any)
    _showNext();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_current != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + DragonSpacing.sm,
            left: DragonSpacing.base,
            right: DragonSpacing.base,
            child: SlideTransition(
              position: _slideAnimation,
              child: _AchievementBanner(achievement: _current!),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AchievementBanner extends StatelessWidget {
  final AchievementDef achievement;

  const _AchievementBanner({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.base,
        vertical: DragonSpacing.md,
      ),
      decoration: BoxDecoration(
        color: DragonColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DragonColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: DragonColors.gold.withAlpha(60),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Achievement badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DragonColors.gold.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(color: DragonColors.gold, width: 1.5),
            ),
            child: Center(
              child: Text(
                achievement.iconEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: DragonSpacing.md),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Achievement Unlocked!',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DragonColors.gold,
                        letterSpacing: 1.0,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Scales reward
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: DragonColors.gold.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '+${achievement.scalesReward}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DragonColors.gold,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrainsMono',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Popup Behavior

Per Visual Design Guide section 10.3:
- **Enter:** Slide down from top with `easeOutBack` curve (500ms)
- **Hold:** Visible for 2 seconds
- **Exit:** Slide up (500ms reverse)
- **Total duration:** ~3 seconds per achievement
- **Queue:** Multiple achievements show sequentially, not simultaneously
- **Non-blocking:** Does not pause gameplay or require dismissal

---

## 10. Achievement Display Screen

### `lib/hub/achievement_screen.dart`

Tabbed screen showing all achievements in 3 categories.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/achievement.dart';
import '../core/achievement_tracker.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Full-screen achievement browser with 3 category tabs.
class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: DragonColors.nightSky,
        appBar: AppBar(
          title: const Text('Achievements'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: DragonColors.gold,
            labelColor: DragonColors.gold,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: 'Per Game'),
              Tab(text: 'Cross Game'),
              Tab(text: 'Milestones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.perGame)
                  .toList(),
            ),
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.crossGame)
                  .toList(),
            ),
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.milestone)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementList extends StatelessWidget {
  final List<AchievementDef> achievements;

  const _AchievementList({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final tracker = context.read<AchievementTracker>();

    return ListView.builder(
      padding: const EdgeInsets.all(DragonSpacing.base),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isUnlocked = tracker.isUnlocked(achievement.id);
        final progress = tracker.getProgress(achievement.id);

        return _AchievementCard(
          achievement: achievement,
          isUnlocked: isUnlocked,
          progress: progress,
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementDef achievement;
  final bool isUnlocked;
  final (int, int)? progress;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DragonSpacing.sm),
      padding: const EdgeInsets.all(DragonSpacing.md),
      decoration: BoxDecoration(
        color: isUnlocked
            ? DragonColors.surface
            : DragonColors.surface.withAlpha(120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? DragonColors.gold : DragonColors.surface,
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Badge icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? DragonColors.gold.withAlpha(40)
                  : Colors.white.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                achievement.iconEmoji,
                style: TextStyle(
                  fontSize: 24,
                  color: isUnlocked ? null : Colors.white24,
                ),
              ),
            ),
          ),
          const SizedBox(width: DragonSpacing.md),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isUnlocked ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isUnlocked ? Colors.white70 : Colors.white24,
                      ),
                ),
                if (progress != null && !isUnlocked) ...[
                  const SizedBox(height: 6),
                  _ProgressBar(
                    current: progress!.$1,
                    target: progress!.$2,
                  ),
                ],
              ],
            ),
          ),
          // Reward badge
          if (isUnlocked)
            const Icon(Icons.check_circle, color: DragonColors.emerald, size: 24)
          else
            Text(
              '+${achievement.scalesReward}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white38,
                    fontFamily: 'JetBrainsMono',
                  ),
            ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int target;

  const _ProgressBar({required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A4A),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: DragonColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: DragonSpacing.sm),
        Text(
          '$current/$target',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white38,
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
```

### Access Point

Add an achievements button to the hub screen, below the game grid or in the profile bar
area. Use an icon button with `Icons.emoji_events` (trophy). Tapping navigates to
`AchievementScreen`.

---

## 11. Daily Challenge System

### `lib/core/daily_challenge.dart`

Data models for daily challenges.

```dart
import 'package:hive/hive.dart';

part 'daily_challenge.g.dart';

/// A single day's challenge consisting of 2-3 tasks.
class DailyChallenge {
  final DateTime date;
  final List<ChallengeTask> tasks;
  final int baseReward;      // 25 scales
  final int streakBonus;     // +5 per consecutive day, cap +25

  const DailyChallenge({
    required this.date,
    required this.tasks,
    this.baseReward = 25,
    this.streakBonus = 0,
  });

  int get totalReward => baseReward + streakBonus;
  bool get isComplete => tasks.every((t) => t.isComplete);
}

/// A single task within a daily challenge.
class ChallengeTask {
  final String id;
  final String description;
  final String gameId;         // which game, or 'any' for cross-game
  final ChallengeType type;
  final int targetValue;       // score threshold, level count, streak count, etc.
  bool isComplete;

  ChallengeTask({
    required this.id,
    required this.description,
    required this.gameId,
    required this.type,
    required this.targetValue,
    this.isComplete = false,
  });
}

enum ChallengeType {
  scoreInGame,         // Score at least X in a specific game
  completeLevels,      // Complete X levels in a specific game
  getStreak,           // Achieve a streak of X in any/specific game
  playGames,           // Play X different games
  correctAnswers,      // Answer X problems correctly in any/specific game
}

/// Persisted daily challenge completion state.
@HiveType(typeId: 6)
class DailyChallengeState extends HiveObject {
  @HiveField(0)
  final String dateKey;         // "2026-02-16" format

  @HiveField(1)
  final List<String> completedTaskIds;

  @HiveField(2)
  final bool allComplete;

  DailyChallengeState({
    required this.dateKey,
    required this.completedTaskIds,
    required this.allComplete,
  });
}
```

### `lib/core/daily_challenge_manager.dart`

Generates daily challenges deterministically and tracks completion.

```dart
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'daily_challenge.dart';
import 'event_bus.dart';
import 'game_events.dart';
import 'reward_service.dart';
import 'player_profile.dart';
import '../storage/local_storage.dart';

/// Generates and tracks daily challenges.
///
/// Challenges are deterministic from the date — the same date always
/// produces the same tasks. This enables potential future leaderboards.
class DailyChallengeManager {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final RewardService _rewardService;
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

  /// Today's challenge. Regenerated if the date has changed.
  late DailyChallenge _todayChallenge;

  /// Notifies UI when task completion changes.
  final ValueNotifier<DailyChallenge> challengeNotifier;

  DailyChallengeManager({
    required EventBus eventBus,
    required LocalStorage storage,
    required RewardService rewardService,
  })  : _eventBus = eventBus,
        _storage = storage,
        _rewardService = rewardService,
        challengeNotifier = ValueNotifier(DailyChallenge(
          date: DateTime.now(),
          tasks: [],
        )) {
    _todayChallenge = _generateOrRestore();
    challengeNotifier.value = _todayChallenge;
    _subscribe();
  }

  /// Get today's challenge.
  DailyChallenge get today => _todayChallenge;

  // ── Generation ──

  DailyChallenge _generateOrRestore() {
    final now = DateTime.now();
    final dateKey = _dateKey(now);
    final profile = _storage.getProfile();
    final streak = profile.dailyChallengeStreak;
    final streakBonus = (streak * 5).clamp(0, 25);

    // Check if we have saved state for today
    final savedState = _storage.getDailyChallengeState(dateKey);

    final tasks = _generateTasks(now);

    // Restore completion state if available
    if (savedState != null) {
      for (final task in tasks) {
        if (savedState.completedTaskIds.contains(task.id)) {
          task.isComplete = true;
        }
      }
    }

    return DailyChallenge(
      date: now,
      tasks: tasks,
      streakBonus: streakBonus,
    );
  }

  /// Generate 2-3 tasks deterministically from the date.
  List<ChallengeTask> _generateTasks(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    final taskCount = 2 + random.nextInt(2); // 2 or 3 tasks
    final tasks = <ChallengeTask>[];
    final usedTypes = <ChallengeType>{};

    const games = ['dragon_runes', 'fire_trail', 'dragon_eggs', 'dragons_feast'];
    const gameNames = {
      'dragon_runes': 'Dragon Runes',
      'fire_trail': 'Fire Trail',
      'dragon_eggs': 'Dragon Eggs',
      'dragons_feast': "Dragon's Feast",
    };

    for (int i = 0; i < taskCount; i++) {
      final template = _pickTemplate(random, usedTypes);
      usedTypes.add(template.type);

      final gameId = games[random.nextInt(games.length)];
      final gameName = gameNames[gameId]!;

      final task = _instantiateTemplate(template, gameId, gameName, random, i);
      tasks.add(task);
    }

    return tasks;
  }

  _ChallengeTemplate _pickTemplate(Random random, Set<ChallengeType> used) {
    final templates = _allTemplates
        .where((t) => !used.contains(t.type))
        .toList();
    return templates[random.nextInt(templates.length)];
  }

  ChallengeTask _instantiateTemplate(
    _ChallengeTemplate template,
    String gameId,
    String gameName,
    Random random,
    int index,
  ) {
    switch (template.type) {
      case ChallengeType.scoreInGame:
        final score = [150, 200, 250, 300][random.nextInt(4)];
        return ChallengeTask(
          id: 'task_$index',
          description: 'Score $score+ in $gameName',
          gameId: gameId,
          type: ChallengeType.scoreInGame,
          targetValue: score,
        );
      case ChallengeType.completeLevels:
        final levels = [1, 2, 3][random.nextInt(3)];
        return ChallengeTask(
          id: 'task_$index',
          description: 'Complete $levels level${levels > 1 ? 's' : ''} in $gameName',
          gameId: gameId,
          type: ChallengeType.completeLevels,
          targetValue: levels,
        );
      case ChallengeType.getStreak:
        final streak = [3, 5, 7][random.nextInt(3)];
        return ChallengeTask(
          id: 'task_$index',
          description: 'Get a $streak-streak in any game',
          gameId: 'any',
          type: ChallengeType.getStreak,
          targetValue: streak,
        );
      case ChallengeType.playGames:
        final count = [2, 3][random.nextInt(2)];
        return ChallengeTask(
          id: 'task_$index',
          description: 'Play $count different games today',
          gameId: 'any',
          type: ChallengeType.playGames,
          targetValue: count,
        );
      case ChallengeType.correctAnswers:
        final count = [10, 15, 20, 25][random.nextInt(4)];
        return ChallengeTask(
          id: 'task_$index',
          description: 'Answer $count problems correctly',
          gameId: 'any',
          type: ChallengeType.correctAnswers,
          targetValue: count,
        );
    }
  }

  static const _allTemplates = [
    _ChallengeTemplate(ChallengeType.scoreInGame),
    _ChallengeTemplate(ChallengeType.completeLevels),
    _ChallengeTemplate(ChallengeType.getStreak),
    _ChallengeTemplate(ChallengeType.playGames),
    _ChallengeTemplate(ChallengeType.correctAnswers),
  ];

  // ── Event Handling ──

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<GameEnded>().listen(_onGameEnded),
    );
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen(_onLevelCompleted),
    );
    _subscriptions.add(
      _eventBus.on<StreakAchieved>().listen(_onStreakAchieved),
    );
    _subscriptions.add(
      _eventBus.on<GameStarted>().listen(_onGameStarted),
    );
  }

  /// Session tracking for "play X different games" and "answer X correctly"
  final Set<String> _gamesPlayedToday = {};
  int _correctAnswersToday = 0;
  int _levelsCompletedToday = 0;
  final Map<String, int> _levelsCompletedPerGame = {};
  final Map<String, int> _scoresPerGame = {};

  void _onGameStarted(GameStarted event) {
    _gamesPlayedToday.add(event.gameId);
    _checkTasks();
  }

  void _onGameEnded(GameEnded event) {
    _scoresPerGame[event.gameId] =
        max(_scoresPerGame[event.gameId] ?? 0, event.finalScore);
    _checkTasks();
  }

  void _onLevelCompleted(LevelCompleted event) {
    _levelsCompletedToday++;
    _levelsCompletedPerGame[event.gameId] =
        (_levelsCompletedPerGame[event.gameId] ?? 0) + 1;
    _correctAnswersToday +=
        (event.accuracy * 10).round(); // approximate from accuracy
    _checkTasks();
  }

  void _onStreakAchieved(StreakAchieved event) {
    _checkTasks();
  }

  void _checkTasks() {
    bool anyChanged = false;

    for (final task in _todayChallenge.tasks) {
      if (task.isComplete) continue;

      final completed = _isTaskComplete(task);
      if (completed) {
        task.isComplete = true;
        anyChanged = true;
      }
    }

    if (anyChanged) {
      _persistState();
      challengeNotifier.value = DailyChallenge(
        date: _todayChallenge.date,
        tasks: _todayChallenge.tasks,
        baseReward: _todayChallenge.baseReward,
        streakBonus: _todayChallenge.streakBonus,
      );

      // Check if all tasks are now complete
      if (_todayChallenge.isComplete) {
        _onAllComplete();
      }
    }
  }

  bool _isTaskComplete(ChallengeTask task) {
    switch (task.type) {
      case ChallengeType.scoreInGame:
        return (_scoresPerGame[task.gameId] ?? 0) >= task.targetValue;
      case ChallengeType.completeLevels:
        return (_levelsCompletedPerGame[task.gameId] ?? 0) >= task.targetValue;
      case ChallengeType.getStreak:
        // Check from profile bestStreak across games
        final profile = _storage.getProfile();
        for (final stats in profile.gameStats.values) {
          if (stats.bestStreak >= task.targetValue) return true;
        }
        return false;
      case ChallengeType.playGames:
        return _gamesPlayedToday.length >= task.targetValue;
      case ChallengeType.correctAnswers:
        return _correctAnswersToday >= task.targetValue;
    }
  }

  void _onAllComplete() {
    // Award scales
    _rewardService.awardExternalScales(_todayChallenge.totalReward);

    // Update streak
    final profile = _storage.getProfile();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = _dateKey(yesterday);
    final hadYesterday = _storage.getDailyChallengeState(yesterdayKey);

    int newStreak;
    if (hadYesterday != null && hadYesterday.allComplete) {
      newStreak = profile.dailyChallengeStreak + 1;
    } else {
      newStreak = 1;
    }

    _storage.updateProfile((p) => p.copyWith(
          dailyChallengeStreak: newStreak,
        ));
  }

  void _persistState() {
    final dateKey = _dateKey(_todayChallenge.date);
    _storage.saveDailyChallengeState(DailyChallengeState(
      dateKey: dateKey,
      completedTaskIds:
          _todayChallenge.tasks.where((t) => t.isComplete).map((t) => t.id).toList(),
      allComplete: _todayChallenge.isComplete,
    ));
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    challengeNotifier.dispose();
  }
}

class _ChallengeTemplate {
  final ChallengeType type;
  const _ChallengeTemplate(this.type);
}
```

### Streak Logic

- **Streak increments** when all tasks for today are completed AND yesterday's challenge
  was also fully completed.
- **Streak resets to 1** when completing today's challenge without yesterday's completion.
- **Streak resets to 0** if a full day passes without completion (checked on app launch).
- Streak bonus: `+5 per consecutive day, capped at +25`.

---

## 12. Daily Challenge Card — Hub Integration

### `lib/hub/daily_challenge_card.dart`

Replace the static placeholder with a functional card bound to `DailyChallengeManager`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/daily_challenge.dart';
import '../core/daily_challenge_manager.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Functional daily challenge card displayed on the hub screen.
class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<DailyChallengeManager>();

    return ValueListenableBuilder<DailyChallenge>(
      valueListenable: manager.challengeNotifier,
      builder: (context, challenge, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: DragonSpacing.base),
          padding: const EdgeInsets.all(DragonSpacing.md),
          decoration: BoxDecoration(
            color: DragonColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: challenge.isComplete
                  ? DragonColors.emerald
                  : DragonColors.gold.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(
                    challenge.isComplete ? Icons.check_circle : Icons.wb_sunny,
                    color: challenge.isComplete
                        ? DragonColors.emerald
                        : DragonColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: DragonSpacing.sm),
                  Text(
                    challenge.isComplete
                        ? "Today's Challenge Complete!"
                        : "Today's Challenge",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: DragonColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  // Streak display
                  _StreakBadge(
                    streak: context
                        .read<LocalStorage>()
                        .getProfile()
                        .dailyChallengeStreak,
                  ),
                ],
              ),
              const SizedBox(height: DragonSpacing.sm),
              const Divider(color: Color(0xFF2A2A4A), height: 1),
              const SizedBox(height: DragonSpacing.sm),

              // Task list
              ...challenge.tasks.map((task) => _TaskRow(task: task)),

              const SizedBox(height: DragonSpacing.sm),
              const Divider(color: Color(0xFF2A2A4A), height: 1),
              const SizedBox(height: DragonSpacing.sm),

              // Reward row
              Row(
                children: [
                  Text(
                    'Reward: ${challenge.totalReward} scales',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DragonColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (challenge.streakBonus > 0) ...[
                    Text(
                      ' (${challenge.baseReward} + ${challenge.streakBonus} streak)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white38,
                          ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskRow extends StatelessWidget {
  final ChallengeTask task;
  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DragonSpacing.xs),
      child: Row(
        children: [
          Icon(
            task.isComplete ? Icons.check_box : Icons.check_box_outline_blank,
            color: task.isComplete ? DragonColors.emerald : Colors.white24,
            size: 20,
          ),
          const SizedBox(width: DragonSpacing.sm),
          Expanded(
            child: Text(
              task.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: task.isComplete ? Colors.white54 : Colors.white,
                    decoration:
                        task.isComplete ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.sm,
        vertical: DragonSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: DragonColors.fireOrange.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: DragonColors.fireOrange,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            '$streak',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DragonColors.fireOrange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrainsMono',
                ),
          ),
        ],
      ),
    );
  }
}
```

---

## 13. Cosmetics Store Screen

### `lib/monetization/store_screen.dart`

The store screen where players spend Dragon Scales on cosmetics.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/player_profile.dart';
import '../storage/local_storage.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Cosmetics store screen for spending Dragon Scales.
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    return Scaffold(
      backgroundColor: DragonColors.nightSky,
      appBar: AppBar(
        title: const Text('Dragon Store'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Scales balance
          Padding(
            padding: const EdgeInsets.only(right: DragonSpacing.base),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.diamond, color: DragonColors.gold, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.totalScales}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: DragonColors.gold,
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(DragonSpacing.base),
        children: [
          // IAP section placeholder (Step 11)
          _SectionHeader(title: 'Premium Packs', subtitle: 'Coming in a future update'),
          const SizedBox(height: DragonSpacing.lg),

          // Dragon Colors section
          _SectionHeader(title: 'Dragon Colors', subtitle: 'Customize your dragon'),
          const SizedBox(height: DragonSpacing.sm),
          _CosmeticGrid(
            items: CosmeticCatalog.colors,
            profile: profile,
            storage: storage,
          ),
          const SizedBox(height: DragonSpacing.lg),

          // Dragon Accessories section
          _SectionHeader(title: 'Accessories', subtitle: 'Style your dragon'),
          const SizedBox(height: DragonSpacing.sm),
          _CosmeticGrid(
            items: CosmeticCatalog.accessories,
            profile: profile,
            storage: storage,
          ),
          const SizedBox(height: DragonSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
        ),
      ],
    );
  }
}

class _CosmeticGrid extends StatefulWidget {
  final List<CosmeticItem> items;
  final PlayerProfile profile;
  final LocalStorage storage;

  const _CosmeticGrid({
    required this.items,
    required this.profile,
    required this.storage,
  });

  @override
  State<_CosmeticGrid> createState() => _CosmeticGridState();
}

class _CosmeticGridState extends State<_CosmeticGrid> {
  late PlayerProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  void _purchase(CosmeticItem item) {
    if (_profile.totalScales < item.cost) return;
    if (_profile.ownedCosmetics.contains(item.id)) return;

    widget.storage.updateProfile((p) => p.copyWith(
          totalScales: p.totalScales - item.cost,
          ownedCosmetics: [...p.ownedCosmetics, item.id],
        ));
    setState(() => _profile = widget.storage.getProfile());
  }

  void _equip(CosmeticItem item) {
    if (!_profile.ownedCosmetics.contains(item.id)) return;

    if (item.type == CosmeticType.color) {
      widget.storage.updateProfile((p) => p.copyWith(equippedColor: item.id));
    } else {
      final current = List<String>.from(_profile.equippedAccessories);
      if (current.contains(item.id)) {
        current.remove(item.id);
      } else {
        current.add(item.id);
      }
      widget.storage.updateProfile((p) => p.copyWith(equippedAccessories: current));
    }
    setState(() => _profile = widget.storage.getProfile());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final owned = _profile.ownedCosmetics.contains(item.id);
        final equipped = item.type == CosmeticType.color
            ? _profile.equippedColor == item.id
            : _profile.equippedAccessories.contains(item.id);
        final canAfford = _profile.totalScales >= item.cost;

        return _CosmeticTile(
          item: item,
          owned: owned,
          equipped: equipped,
          canAfford: canAfford,
          onTap: owned ? () => _equip(item) : (canAfford ? () => _purchase(item) : null),
        );
      },
    );
  }
}

class _CosmeticTile extends StatelessWidget {
  final CosmeticItem item;
  final bool owned;
  final bool equipped;
  final bool canAfford;
  final VoidCallback? onTap;

  const _CosmeticTile({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.canAfford,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: DragonColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: equipped
                ? DragonColors.gold
                : (owned ? DragonColors.emerald.withAlpha(80) : Colors.transparent),
            width: equipped ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Preview
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.previewColor ?? Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(item.previewEmoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: DragonSpacing.xs),
            Text(
              item.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            if (equipped)
              Text(
                'Equipped',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DragonColors.gold,
                      fontSize: 10,
                    ),
              )
            else if (owned)
              Text(
                'Owned',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DragonColors.emerald,
                      fontSize: 10,
                    ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.diamond,
                    size: 10,
                    color: canAfford ? DragonColors.gold : Colors.white24,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${item.cost}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: canAfford ? DragonColors.gold : Colors.white24,
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
```

### Cosmetic Catalog

```dart
/// Cosmetic item definition.
class CosmeticItem {
  final String id;
  final String name;
  final CosmeticType type;
  final int cost;
  final String previewEmoji;
  final Color? previewColor;

  const CosmeticItem({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.previewEmoji,
    this.previewColor,
  });
}

enum CosmeticType { color, accessory }

/// All available cosmetics.
class CosmeticCatalog {
  static const colors = [
    CosmeticItem(id: 'color_crimson', name: 'Crimson', type: CosmeticType.color,
        cost: 50, previewEmoji: '\u{1F525}', previewColor: Color(0xFFDC143C)),
    CosmeticItem(id: 'color_sapphire', name: 'Sapphire', type: CosmeticType.color,
        cost: 75, previewEmoji: '\u{1F48E}', previewColor: Color(0xFF0F52BA)),
    CosmeticItem(id: 'color_emerald', name: 'Emerald', type: CosmeticType.color,
        cost: 75, previewEmoji: '\u{1F48E}', previewColor: Color(0xFF50C878)),
    CosmeticItem(id: 'color_amethyst', name: 'Amethyst', type: CosmeticType.color,
        cost: 100, previewEmoji: '\u{1F48E}', previewColor: Color(0xFF9966CC)),
    CosmeticItem(id: 'color_gold', name: 'Golden', type: CosmeticType.color,
        cost: 150, previewEmoji: '\u{2728}', previewColor: Color(0xFFFFD700)),
    CosmeticItem(id: 'color_obsidian', name: 'Obsidian', type: CosmeticType.color,
        cost: 150, previewEmoji: '\u{1F311}', previewColor: Color(0xFF1C1C1C)),
    CosmeticItem(id: 'color_frost', name: 'Frost', type: CosmeticType.color,
        cost: 100, previewEmoji: '\u{2744}', previewColor: Color(0xFFADD8E6)),
    CosmeticItem(id: 'color_sunset', name: 'Sunset', type: CosmeticType.color,
        cost: 200, previewEmoji: '\u{1F305}', previewColor: Color(0xFFFF6347)),
  ];

  static const accessories = [
    CosmeticItem(id: 'acc_crown', name: 'Crown', type: CosmeticType.accessory,
        cost: 300, previewEmoji: '\u{1F451}'),
    CosmeticItem(id: 'acc_scarf', name: 'Scarf', type: CosmeticType.accessory,
        cost: 150, previewEmoji: '\u{1F9E3}'),
    CosmeticItem(id: 'acc_glasses', name: 'Glasses', type: CosmeticType.accessory,
        cost: 100, previewEmoji: '\u{1F453}'),
    CosmeticItem(id: 'acc_hat', name: 'Top Hat', type: CosmeticType.accessory,
        cost: 200, previewEmoji: '\u{1F3A9}'),
    CosmeticItem(id: 'acc_bow', name: 'Bow Tie', type: CosmeticType.accessory,
        cost: 100, previewEmoji: '\u{1F380}'),
    CosmeticItem(id: 'acc_shield', name: 'Shield', type: CosmeticType.accessory,
        cost: 500, previewEmoji: '\u{1F6E1}'),
  ];
}
```

### Pricing (Scale Costs)

| Item | Cost | Time to Earn |
|------|------|--------------|
| Cheapest color (Crimson) | 50 | ~1-2 game sessions |
| Mid-range color | 75-150 | ~2-4 sessions |
| Premium color (Sunset) | 200 | ~4-6 sessions |
| Basic accessory | 100-150 | ~2-4 sessions |
| Premium accessory (Shield) | 500 | ~10-15 sessions |

**Pacing target from MOBILE_APP_PLAN.md:** A 15-20 minute session earns ~100-200 scales.
Cheapest items within 1-2 sessions. Expensive items are aspirational but reachable in a week.

---

## 14. Dragon Customization

### Hub Display

The dragon companion in the hub (`hub/dragon_companion.dart`) should reflect equipped
cosmetics. Since real art is Step 12, for now:

1. **Color:** The dragon emoji/placeholder tints with the equipped color. If `equippedColor`
   is `"color_crimson"`, apply a red `ColorFilter` to the dragon display.

2. **Accessories:** Show equipped accessory emojis near the dragon. E.g., if crown is
   equipped, show a small crown emoji above the dragon.

### Implementation

```dart
/// Update DragonCompanion to read cosmetics from profile.
class DragonCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    // Get equipped color
    final colorItem = CosmeticCatalog.colors
        .where((c) => c.id == profile.equippedColor)
        .firstOrNull;

    // Get equipped accessories
    final accessories = CosmeticCatalog.accessories
        .where((a) => profile.equippedAccessories.contains(a.id))
        .toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        // Dragon with color tint
        _DragonDisplay(
          evolution: profile.dragonEvolution,
          tintColor: colorItem?.previewColor,
        ),
        // Accessory emojis positioned around dragon
        if (accessories.isNotEmpty)
          Positioned(
            top: 0,
            child: Text(
              accessories.map((a) => a.previewEmoji).join(' '),
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}
```

---

## 15. "Just One More" Session Flow

### Result Screen Updates

Modify `games/shared/result_screen.dart` to implement the session design from
MOBILE_APP_PLAN.md section 9.

```dart
/// Updated result screen with encouragement and game suggestions.
class ResultScreen extends StatelessWidget {
  final GameResults results;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToHub;
  final String? encouragement;    // "So close! 2 more correct to clear this level."
  final String? gameSuggestion;   // "Your dragon is hungry! Try Dragon's Feast"

  // ... existing build method

  /// Generate encouragement text based on game results.
  static String? generateEncouragement(GameResults results, PlayerProfile profile) {
    final gameStats = profile.gameStats[results.gameId];
    if (gameStats == null) return null;

    // Near high score
    if (results.score > gameStats.highScore * 0.85 &&
        results.score < gameStats.highScore) {
      final diff = gameStats.highScore - results.score;
      return 'So close to your high score! Just $diff more points.';
    }

    // Near level completion (didn't earn a star)
    if (results.stars == 0 && results.accuracy >= 0.50) {
      if (results.accuracy < 0.60) {
        final needed = ((0.60 - results.accuracy) * results.problemsAttempted).ceil();
        return 'Almost there! $needed more correct answers to clear this level.';
      }
    }

    // Near 3-star (has 2 stars)
    if (results.stars == 2 && results.accuracy >= 0.85) {
      return 'So close to 3 stars! A little more accuracy and you\'ve got it!';
    }

    return null;
  }

  /// Generate a game suggestion if player has been on the same game too long.
  static String? generateGameSuggestion(
    String currentGameId,
    SessionManager sessionManager,
    ProgressionManager progressionManager,
  ) {
    if (!sessionManager.shouldSuggestDifferentGame) return null;

    final suggested = progressionManager.suggestGame(currentGameId);
    if (suggested == null) return null;

    const names = {
      'dragon_runes': 'Dragon Runes',
      'fire_trail': 'Fire Trail',
      'dragon_eggs': 'Dragon Eggs',
      'dragons_feast': "Dragon's Feast",
    };

    return 'Your dragon is hungry! Try ${names[suggested]} for bonus scales.';
  }
}
```

### Button Layout

Per MOBILE_APP_PLAN.md "Just One More" design:

```
Result Screen Layout:
┌──────────────────────────────────────┐
│  ★ ★ ☆                              │
│  Score: 2,450    Accuracy: 78%       │
│  Streak: 7                           │
│                                      │
│  +45 🟡  (animated counter)          │
│                                      │
│  "So close to 3 stars!"             │  ← encouragement (if applicable)
│                                      │
│  ┌──────────────────────────────┐   │
│  │                              │   │  ← Primary: PLAY AGAIN (gold, large)
│  │     ✦ PLAY AGAIN ✦          │   │     Height: 56dp
│  │                              │   │
│  └──────────────────────────────┘   │
│                                      │
│       [Back to Hub]                 │  ← Secondary: outline, smaller
│                                      │     Height: 40dp
│                                      │
│  "Try Dragon's Feast for bonus      │  ← game suggestion (if applicable)
│   scales!"                          │     Smaller text, dismissible
└──────────────────────────────────────┘
```

---

## 16. Animated Scales Counter

### `lib/widgets/animated_scales_counter.dart`

An animated counter widget used in the HUD and result screen.

```dart
import 'package:flutter/material.dart';
import '../theme/dragon_colors.dart';

/// Animated scales counter that ticks up when scales are earned.
///
/// Shows the current value, then animates to the new value when it increases.
/// Displays a floating "+X" text that fades upward.
class AnimatedScalesCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;

  const AnimatedScalesCounter({
    super.key,
    required this.value,
    this.style,
  });

  @override
  State<AnimatedScalesCounter> createState() => _AnimatedScalesCounterState();
}

class _AnimatedScalesCounterState extends State<AnimatedScalesCounter>
    with SingleTickerProviderStateMixin {
  late int _displayValue;
  int? _delta;
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0, end: -40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _delta = null);
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedScalesCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final delta = widget.value - oldWidget.value;
      if (delta > 0) {
        setState(() {
          _delta = delta;
          _displayValue = widget.value;
        });
        _controller.forward();
      } else {
        setState(() => _displayValue = widget.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: DragonColors.gold,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
            );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond, color: DragonColors.gold, size: 18),
            const SizedBox(width: 4),
            Text(_formatNumber(_displayValue), style: style),
          ],
        ),
        if (_delta != null)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _floatAnimation.value,
                right: 0,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    '+$_delta',
                    style: style?.copyWith(
                      fontSize: 14,
                      color: DragonColors.gold,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return n.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**Note:** The Visual Design Guide calls for "gold particles fly toward the counter" —
that specific particle effect is deferred to Step 12 (Art & Polish). The counter tick-up
and floating "+X" text are implemented here.

---

## 17. ProgressionManager Integration

### Wire Real Achievement & Daily Challenge Counts

`ProgressionManager` currently has placeholder values for achievement and daily challenge
requirements in evolution checks. Update to use real data:

```dart
// In EvolutionRequirements.progressItems() and isMet():

// BEFORE (placeholder):
if (achievements > 0) {
  items.add(EvolutionProgressItem(
    label: 'Unlock $achievements achievements',
    current: 0, // TODO: Step 9
    required_: achievements,
    isMet: false,
  ));
}

// AFTER (real data):
if (achievements > 0) {
  final achievementTracker = ...; // provided via constructor
  final current = achievementTracker.unlockedCount;
  items.add(EvolutionProgressItem(
    label: 'Unlock $achievements achievements',
    current: current,
    required_: achievements,
    isMet: current >= achievements,
  ));
}
```

### Changes Required

1. **ProgressionManager constructor:** Add `AchievementTracker` parameter.
2. **EvolutionRequirements.isMet():** Accept `AchievementTracker` and check real
   `unlockedCount` against `achievements` requirement.
3. **EvolutionRequirements.isMet():** Check real daily challenge completion count
   from `LocalStorage.getTotalDailyChallengesCompleted()`.
4. **EvolutionRequirements.progressItems():** Replace placeholder `current: 0` with
   actual values from AchievementTracker and LocalStorage.

### Provider Wiring

Update `app.dart` MultiProvider to include the new services:

```dart
MultiProvider(
  providers: [
    // ... existing providers
    Provider<AchievementTracker>(
      create: (context) => AchievementTracker(
        eventBus: context.read<EventBus>(),
        storage: context.read<LocalStorage>(),
        factTracker: context.read<FactTracker>(),
        rewardService: context.read<RewardService>(),
      ),
      dispose: (_, tracker) => tracker.dispose(),
    ),
    Provider<DailyChallengeManager>(
      create: (context) => DailyChallengeManager(
        eventBus: context.read<EventBus>(),
        storage: context.read<LocalStorage>(),
        rewardService: context.read<RewardService>(),
      ),
      dispose: (_, manager) => manager.dispose(),
    ),
    // ProgressionManager updated to accept AchievementTracker
  ],
)
```

### LocalStorage Extensions

Add new boxes and methods to `local_storage.dart`:

```dart
// New Hive boxes
late Box<UnlockedAchievement> _achievementsBox;
late Box<DailyChallengeState> _dailyChallengeBox;

// New methods
Future<void> saveUnlockedAchievement(UnlockedAchievement achievement);
Set<String> getUnlockedAchievementIds();
List<UnlockedAchievement> getAllUnlockedAchievements();

Future<void> saveDailyChallengeState(DailyChallengeState state);
DailyChallengeState? getDailyChallengeState(String dateKey);
int getTotalDailyChallengesCompleted();
```

---

## 18. Localization Updates

### New l10n Strings (`app_en.arb`)

```json
{
  "achievementUnlocked": "Achievement Unlocked!",
  "achievements": "Achievements",
  "achievementsPerGame": "Per Game",
  "achievementsCrossGame": "Cross Game",
  "achievementsMilestones": "Milestones",
  "achievementLocked": "Locked",
  "achievementOwned": "Unlocked",
  "achievementProgress": "{current}/{target}",
  "@achievementProgress": {
    "placeholders": {
      "current": { "type": "int" },
      "target": { "type": "int" }
    }
  },
  "achievementScalesReward": "+{count} scales",
  "@achievementScalesReward": {
    "placeholders": { "count": { "type": "int" } }
  },

  "todaysChallenge": "Today's Challenge",
  "todaysChallengeComplete": "Today's Challenge Complete!",
  "dailyChallengeReward": "Reward: {count} scales",
  "@dailyChallengeReward": {
    "placeholders": { "count": { "type": "int" } }
  },
  "dailyChallengeStreak": "{count} day streak",
  "@dailyChallengeStreak": {
    "placeholders": { "count": { "type": "int" } }
  },
  "dailyChallengeStreakBonus": "+{count} streak bonus",
  "@dailyChallengeStreakBonus": {
    "placeholders": { "count": { "type": "int" } }
  },
  "scoreInGame": "Score {score}+ in {game}",
  "@scoreInGame": {
    "placeholders": {
      "score": { "type": "int" },
      "game": { "type": "String" }
    }
  },
  "completeLevels": "Complete {count} level(s) in {game}",
  "@completeLevels": {
    "placeholders": {
      "count": { "type": "int" },
      "game": { "type": "String" }
    }
  },
  "getStreak": "Get a {count}-streak in any game",
  "@getStreak": {
    "placeholders": { "count": { "type": "int" } }
  },
  "playGames": "Play {count} different games today",
  "@playGames": {
    "placeholders": { "count": { "type": "int" } }
  },
  "correctAnswers": "Answer {count} problems correctly",
  "@correctAnswers": {
    "placeholders": { "count": { "type": "int" } }
  },

  "dragonStore": "Dragon Store",
  "dragonColors": "Dragon Colors",
  "dragonAccessories": "Accessories",
  "customizeYourDragon": "Customize your dragon",
  "styleYourDragon": "Style your dragon",
  "owned": "Owned",
  "equipped": "Equipped",
  "purchase": "Purchase",
  "insufficientScales": "Not enough scales",
  "premiumPacks": "Premium Packs",
  "comingSoon": "Coming in a future update",

  "playAgain": "Play Again",
  "backToHub": "Back to Hub",
  "soCloseHighScore": "So close to your high score! Just {points} more points.",
  "@soCloseHighScore": {
    "placeholders": { "points": { "type": "int" } }
  },
  "almostCleared": "Almost there! {count} more correct answers to clear this level.",
  "@almostCleared": {
    "placeholders": { "count": { "type": "int" } }
  },
  "soCloseThreeStars": "So close to 3 stars! A little more accuracy and you've got it!",
  "tryOtherGame": "Your dragon is hungry! Try {game} for bonus scales.",
  "@tryOtherGame": {
    "placeholders": { "game": { "type": "String" } }
  },

  "achRunesFirst": "First Rune",
  "achRunesFirstDesc": "Complete your first Dragon Runes level",
  "achRunes10": "Rune Caster",
  "achRunes10Desc": "Complete 10 Dragon Runes levels",
  "achRunes25": "Rune Master",
  "achRunes25Desc": "Complete 25 Dragon Runes levels",
  "achRunesAllWorlds": "Elder Runekeeper",
  "achRunesAllWorldsDesc": "Complete all 50 Dragon Runes levels",
  "achRunesPerfect": "Perfect Spell",
  "achRunesPerfectDesc": "3-star a Dragon Runes level with 100% accuracy",
  "achRunesStreak10": "Chain Lightning",
  "achRunesStreak10Desc": "Build a 10-streak in Dragon Runes",
  "achRunesStreak20": "Thunderstorm",
  "achRunesStreak20Desc": "Build a 20-streak in Dragon Runes",
  "achRunesSpeed": "Speed Caster",
  "achRunesSpeedDesc": "Complete a Dragon Runes level in under 60 seconds",

  "achTrailFirst": "First Flight",
  "achTrailFirstDesc": "Complete your first Fire Trail level",
  "achTrail10": "Thermal Rider",
  "achTrail10Desc": "Complete 10 Fire Trail levels",
  "achTrail25": "Firestorm Pilot",
  "achTrail25Desc": "Complete 25 Fire Trail levels",
  "achTrailAllWorlds": "Dragon Master",
  "achTrailAllWorldsDesc": "Complete all 40 Fire Trail levels",
  "achTrailPerfect": "Perfect Run",
  "achTrailPerfectDesc": "3-star a Fire Trail level with 100% accuracy",
  "achTrailStreak10": "Blazing Streak",
  "achTrailStreak10Desc": "Build a 10-streak in Fire Trail",
  "achTrailStreak20": "Inferno Chain",
  "achTrailStreak20Desc": "Build a 20-streak in Fire Trail",
  "achTrailSurvivor": "Iron Flame",
  "achTrailSurvivorDesc": "Complete a Fire Trail level without any wrong answers",

  "achEggsFirst": "First Hatch",
  "achEggsFirstDesc": "Complete your first Dragon Eggs level",
  "achEggs10": "Egg Collector",
  "achEggs10Desc": "Complete 10 Dragon Eggs levels",
  "achEggs25": "Hatchery Master",
  "achEggs25Desc": "Complete 25 Dragon Eggs levels",
  "achEggsAllWorlds": "Ancient Keeper",
  "achEggsAllWorldsDesc": "Complete all 50 Dragon Eggs levels",
  "achEggsPerfect": "Perfect Hatch",
  "achEggsPerfectDesc": "3-star a Dragon Eggs level with 100% accuracy",
  "achEggsStreak10": "Combo Cracker",
  "achEggsStreak10Desc": "Build a 10-streak in Dragon Eggs",
  "achEggsStreak20": "Hatch Storm",
  "achEggsStreak20Desc": "Build a 20-streak in Dragon Eggs",
  "achEggsDivision": "Division Dragon",
  "achEggsDivisionDesc": "Complete a Dragon Eggs level using division",

  "achFeastFirst": "First Bite",
  "achFeastFirstDesc": "Complete your first Dragon's Feast level",
  "achFeast10": "Hungry Dragon",
  "achFeast10Desc": "Complete 10 Dragon's Feast levels",
  "achFeast25": "Gourmet Dragon",
  "achFeast25Desc": "Complete 25 Dragon's Feast levels",
  "achFeastAllWorlds": "Feast King",
  "achFeastAllWorldsDesc": "Complete all 40 Dragon's Feast levels",
  "achFeastPerfect": "Perfect Palate",
  "achFeastPerfectDesc": "3-star a Dragon's Feast level with 100% accuracy",
  "achFeastStreak10": "Feeding Frenzy",
  "achFeastStreak10Desc": "Build a 10-streak in Dragon's Feast",
  "achFeastStreak20": "Insatiable",
  "achFeastStreak20Desc": "Build a 20-streak in Dragon's Feast",
  "achFeastNoCatch": "Untouchable",
  "achFeastNoCatchDesc": "Complete a Dragon's Feast level without being caught",

  "achCrossExplorer": "Dragon Explorer",
  "achCrossExplorerDesc": "Play all 4 games in one day",
  "achCrossWellRounded": "Well-Rounded",
  "achCrossWellRoundedDesc": "Earn scales in 3 different games in one session",
  "achCrossVariety": "Variety Pack",
  "achCrossVarietyDesc": "Reach level 5 in all 4 games",
  "achCrossOlympian": "Math Olympian",
  "achCrossOlympianDesc": "3-star a level in every game",
  "achCrossDaily7": "Daily Devotion",
  "achCrossDaily7Desc": "Complete 7 daily challenges in a row",
  "achCrossDaily14": "Two Week Warrior",
  "achCrossDaily14Desc": "Complete 14 daily challenges in a row",
  "achCrossDaily30": "Monthly Master",
  "achCrossDaily30Desc": "Complete 30 daily challenges in a row",
  "achCrossAllWorld1": "World Wanderer",
  "achCrossAllWorld1Desc": "Complete World 1 in all 4 games",
  "achCrossAllWorld3": "Realm Explorer",
  "achCrossAllWorld3Desc": "Complete World 3 in all 4 games",
  "achCrossTotalStars50": "Star Gatherer",
  "achCrossTotalStars50Desc": "Earn 50 total stars across all games",

  "achMileCentury": "Century",
  "achMileCenturyDesc": "Answer 100 problems correctly",
  "achMileThousand": "Thousand Strong",
  "achMileThousandDesc": "Answer 1,000 problems correctly",
  "achMileFiveThousand": "Math Machine",
  "achMileFiveThousandDesc": "Answer 5,000 problems correctly",
  "achMileFacts25": "Fact Finder",
  "achMileFacts25Desc": "Master 25 math facts (90%+ accuracy)",
  "achMileFacts50": "Fact Scholar",
  "achMileFacts50Desc": "Master 50 math facts",
  "achMileFacts100": "Fact Titan",
  "achMileFacts100Desc": "Master 100 math facts",
  "achMileTimesTables": "Times Table Titan",
  "achMileTimesTablesDesc": "Master all multiplication facts 1-12",
  "achMileScales1000": "Scale Collector",
  "achMileScales1000Desc": "Earn 1,000 total scales",
  "achMileScales5000": "Scale Hoarder",
  "achMileScales5000Desc": "Earn 5,000 total scales",
  "achMileEvolution3": "Dragon Raiser",
  "achMileEvolution3Desc": "Reach dragon evolution stage 3"
}
```

**Total new strings: ~85**

---

## 19. Unit Tests

### `test/core/achievement_test.dart`

```dart
// Test: AchievementCatalog.all contains 52 achievements
// Test: All achievement IDs are unique
// Test: All per-game achievements have a valid gameId
// Test: Cross-game and milestone achievements have null gameId
// Test: All scalesReward values are between 25 and 100
// Test: checkUnlocked returns false for a fresh profile
// Test: checkUnlocked returns true for runes_first with level >= 2
// Test: checkUnlocked returns true for mile_century with 100+ correct answers
// Test: checkUnlocked returns false for mile_century with 99 correct answers
```

### `test/core/achievement_tracker_test.dart`

```dart
// Test: Tracker unlocks achievement when requirements met after LevelCompleted event
// Test: Tracker does NOT re-unlock already unlocked achievements
// Test: Tracker awards bonus scales on unlock (via RewardService)
// Test: Tracker fires onAchievementUnlocked callback on unlock
// Test: unlockedCount returns correct count from storage
// Test: isUnlocked returns true for unlocked achievements, false for locked
// Test: getProgress returns correct (current, target) for milestone achievements
// Test: Multiple achievements can unlock from a single event
// Test: Achievement check doesn't crash with empty profile
```

### `test/core/daily_challenge_manager_test.dart`

```dart
// Test: Same date always generates same tasks (deterministic)
// Test: Different dates generate different tasks
// Test: Generated challenge has 2 or 3 tasks
// Test: No duplicate ChallengeTypes in a single day's tasks
// Test: Task completion persists to storage
// Test: All tasks complete triggers scale award
// Test: Streak increments when yesterday was also complete
// Test: Streak resets to 1 when yesterday was not complete
// Test: Streak bonus caps at +25 (5 days * 5)
// Test: scoreInGame task completes when score meets threshold
// Test: playGames task completes when enough unique games played
// Test: getStreak task completes when streak reaches target
// Test: completeLevels task completes when enough levels finished
// Test: correctAnswers task completes when enough correct answers
```

### `test/monetization/store_screen_test.dart`

```dart
// Test: All catalog items have unique IDs
// Test: Color items cost 50-200 scales
// Test: Accessory items cost 100-500 scales
// Test: Purchase deducts scales from profile
// Test: Purchase adds item ID to ownedCosmetics
// Test: Cannot purchase with insufficient scales
// Test: Cannot purchase already owned item
// Test: Equip sets equippedColor for color items
// Test: Equip toggles equippedAccessories for accessory items
// Test: Owned items show in profile after purchase
```

### `test/hub/daily_challenge_card_test.dart`

```dart
// Test: Card renders today's tasks
// Test: Completed tasks show checkmark icon
// Test: Incomplete tasks show empty checkbox
// Test: Streak badge shows correct count
// Test: Streak badge hidden when streak is 0
// Test: Reward text shows base + streak bonus
// Test: Card updates when task completion changes
```

---

## 20. Verification Checklist

### Scales & Store
- [ ] RewardService rates match MOBILE_APP_PLAN.md section 9 exactly
- [ ] Animated counter ticks up on scale earn with floating "+X"
- [ ] Store accessible from hub
- [ ] 8 colors + 6 accessories displayed with correct prices
- [ ] Purchase flow works: tap → deduct scales → add to owned
- [ ] Insufficient scales disables purchase button
- [ ] Equipped items show on dragon in hub
- [ ] Purchases persist across app restart

### Achievements
- [ ] 52 achievements defined (32 per-game + 10 cross-game + 10 milestone)
- [ ] AchievementTracker unlocks achievements reactively from events
- [ ] Bonus scales awarded on unlock
- [ ] Popup slides in from top, holds 2s, slides out (3s total)
- [ ] Popup shows icon, title, and "+X scales"
- [ ] Haptics fire on achievement unlock (triple tap)
- [ ] Achievement screen has 3 tabs with correct categorization
- [ ] Unlocked achievements: full color, gold border, checkmark
- [ ] Locked achievements: grey, progress bar where applicable
- [ ] Multiple achievements can queue and show sequentially

### Daily Challenges
- [ ] 2-3 tasks generated deterministically from date
- [ ] Same date → same tasks (test by hardcoding date)
- [ ] Tasks cover variety of types (score, levels, streak, variety, answers)
- [ ] DailyChallengeCard shows real task data with check state
- [ ] Tasks mark complete as events occur during gameplay
- [ ] All tasks complete → 25 scales + streak bonus awarded
- [ ] Streak tracks consecutive days
- [ ] Streak badge displays in hub card

### Session Flow
- [ ] "Play Again" button is gold, large, prominent
- [ ] "Back to Hub" button is outline, smaller
- [ ] Encouragement text shows when near high score / level clear / 3 stars
- [ ] Game suggestion shows after 3+ consecutive same-game sessions
- [ ] Suggestion is never forced — just text, always dismissible

### Integration
- [ ] ProgressionManager uses real achievement count for evolution requirements
- [ ] ProgressionManager uses real daily challenge count for evolution requirements
- [ ] Evolution Stage 2 (Fledgling) properly checks "5 achievements" requirement
- [ ] Evolution Stage 4 (Adult) properly checks "10 daily challenges" requirement
- [ ] AchievementTracker and DailyChallengeManager wired in MultiProvider
- [ ] Achievement popup overlay wraps the main app scaffold

### Quality
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (all existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] No regressions — all 4 games still fully playable
- [ ] Full reward loop works end-to-end: play → earn scales → animated counter →
      check achievements → popup if unlocked → visit store → buy cosmetic →
      see on dragon → check daily challenge → complete tasks → streak grows

---

## What Comes Next (Out of Scope)

These are explicitly out of scope for Step 9:

- **Firebase / cloud sync** — Step 10
- **RevenueCat IAP (Dragon Pack, Scale Packs)** — Step 11
- **Freemium content gating** — Step 11
- **Parental purchase gate** — Step 11
- **Real art assets / animations** — Step 12
- **Sound effects** — Step 12
- **Tutorial overlays** — Step 12

Step 9 completes the **reward loop skeleton**. After this step, the app has meaningful
meta-goals beyond just playing levels: earn scales, buy cosmetics, chase achievements,
and maintain daily streaks. The store screen has a placeholder section for IAP products
that Step 11 will populate. Dragon cosmetics use emoji/color-tint placeholders that
Step 12 will replace with real art. The important thing is that the systems, data
persistence, and UI flows are all working and tested.
