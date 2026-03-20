# Step 2: Core Services & Data Layer

> **Goal:** Implement the foundational services that every screen and game depends
> on — persistent storage, player data model, event communication, currency logic,
> math fact tracking, session management, and haptic feedback. Wire everything into
> the widget tree via Provider.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 1 complete. `flutter analyze` clean. App runs and displays
> the themed hub with 4 placeholder game cards.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [PlayerProfile Data Model](#4-playerprofile-data-model)
5. [Local Storage Layer (Hive)](#5-local-storage-layer-hive)
6. [Schema Migration System](#6-schema-migration-system)
7. [Event Bus](#7-event-bus)
8. [Game Registry Enhancement](#8-game-registry-enhancement)
9. [RewardService](#9-rewardservice)
10. [FactTracker](#10-facttracker)
11. [SessionManager](#11-sessionmanager)
12. [HapticsService](#12-hapticsservice)
13. [Provider Wiring](#13-provider-wiring)
14. [Localization Updates](#14-localization-updates)
15. [Unit Tests](#15-unit-tests)
16. [Verification Checklist](#16-verification-checklist)

---

## 1. User Stories

### US-2.1: Persistent Player Data
**As a** player,
**I want** my progress (scales, level, stats) saved automatically between sessions,
**so that** I never lose my progress when I close and reopen the app.

### US-2.2: Currency Earning
**As a** player,
**I want** to earn Dragon Scales when I answer problems correctly and complete levels,
**so that** my play sessions feel rewarding even before the store exists.

### US-2.3: Fact Tracking
**As a** developer,
**I want** every math fact the player encounters tracked with accuracy and timing data,
**so that** the adaptive difficulty engine (Step 8) can select optimal problems.

### US-2.4: Game Event Communication
**As a** developer,
**I want** games to emit typed events through a shared bus without knowing who listens,
**so that** services (rewards, tracking, sync) stay decoupled from game implementations.

### US-2.5: Session Awareness
**As a** developer,
**I want** the app to know when a game session starts, ends, and how long it lasted,
**so that** we can track play time and trigger session-based logic (suggestions, rewards).

### US-2.6: Haptic Feedback
**As a** player,
**I want** to feel satisfying vibrations when I get answers right or hit milestones,
**so that** the game feels responsive and tactile.

---

## 2. Acceptance Criteria

- [ ] App launches with Hive initialized — no errors, no data loss between restarts
- [ ] PlayerProfile persists across app restarts (close and reopen → data intact)
- [ ] Profile bar on hub shows real scales count from storage (starts at 0)
- [ ] EventBus can emit and receive all 5 game event types without errors
- [ ] RewardService calculates correct scales for all earning scenarios (unit tested)
- [ ] FactTracker records and retrieves per-fact accuracy data (unit tested)
- [ ] SessionManager tracks session start/end and calculates duration
- [ ] HapticsService fires correct haptic patterns (verifiable on real device)
- [ ] All services accessible via Provider from any widget in the tree
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes — all unit tests green
- [ ] `flutter build apk --debug` succeeds

---

## 3. Architecture Overview

### Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                      Widget Tree                         │
│  Hub, Games, Settings, Results — read via Provider       │
└──────────────┬────────────────────────┬─────────────────┘
               │ write                  │ read
               ▼                        │
┌──────────────────────────┐            │
│       Event Bus          │            │
│  Games emit GameEvents   │            │
│  Services listen          │            │
└──────┬─────┬─────┬───────┘            │
       │     │     │                    │
       ▼     ▼     ▼                    │
┌────────┐┌────────┐┌──────────┐        │
│Reward  ││Fact    ││Session   │        │
│Service ││Tracker ││Manager   │        │
└───┬────┘└───┬────┘└──────────┘        │
    │         │                         │
    ▼         ▼                         │
┌──────────────────────────┐            │
│    Local Storage (Hive)  │◄───────────┘
│  PlayerProfile           │
│  FactHistory             │
│  Settings                │
│  Schema version          │
└──────────────────────────┘
```

### Key Principles

1. **Local-first.** Everything reads/writes Hive. Cloud sync (Step 10) layers on top later.
2. **Immutable models.** PlayerProfile and FactRecord are immutable with `copyWith`.
3. **Event-driven.** Games emit; services react. No direct coupling.
4. **Provider for DI.** All services are singletons provided at the root of the widget tree.

---

## 4. PlayerProfile Data Model

### `lib/core/player_profile.dart`

Replace the existing stub with the full data model. This is the central source of
truth for all player state. It mirrors the Firestore schema from the planning doc
so cloud sync (Step 10) is a direct mapping.

```dart
import 'package:hive/hive.dart';

part 'player_profile.g.dart';

@HiveType(typeId: 0)
class PlayerProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String dragonName;

  @HiveField(2)
  final int dragonEvolution; // 0=egg, 1=hatchling, 2=fledgling, 3=young, 4=adult, 5=elder

  @HiveField(3)
  final int totalScales;

  @HiveField(4)
  final int totalCorrectAnswers;

  @HiveField(5)
  final int totalPlayTimeMinutes;

  @HiveField(6)
  final int dailyChallengeStreak;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime lastPlayedAt;

  @HiveField(9)
  final Map<String, GameStats> gameStats; // keyed by gameId

  @HiveField(10)
  final PlayerSettings settings;

  @HiveField(11)
  final List<String> ownedCosmetics; // IDs of purchased cosmetics

  @HiveField(12)
  final String? equippedColor; // Currently equipped dragon color

  @HiveField(13)
  final List<String> equippedAccessories; // Currently equipped accessories

  @HiveField(14)
  final int schemaVersion;

  @HiveField(15)
  final bool isFirstSession; // true until first session completes

  @HiveField(16)
  final String? ageGroup; // "under13" or "13plus", null if not set

  PlayerProfile({
    required this.id,
    this.dragonName = 'Dragon',
    this.dragonEvolution = 0,
    this.totalScales = 0,
    this.totalCorrectAnswers = 0,
    this.totalPlayTimeMinutes = 0,
    this.dailyChallengeStreak = 0,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, GameStats>? gameStats,
    PlayerSettings? settings,
    List<String>? ownedCosmetics,
    this.equippedColor,
    List<String>? equippedAccessories,
    this.schemaVersion = 1,
    this.isFirstSession = true,
    this.ageGroup,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        gameStats = gameStats ?? const {},
        settings = settings ?? const PlayerSettings(),
        ownedCosmetics = ownedCosmetics ?? const [],
        equippedAccessories = equippedAccessories ?? const [];

  PlayerProfile copyWith({
    String? id,
    String? dragonName,
    int? dragonEvolution,
    int? totalScales,
    int? totalCorrectAnswers,
    int? totalPlayTimeMinutes,
    int? dailyChallengeStreak,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, GameStats>? gameStats,
    PlayerSettings? settings,
    List<String>? ownedCosmetics,
    String? equippedColor,
    List<String>? equippedAccessories,
    int? schemaVersion,
    bool? isFirstSession,
    String? ageGroup,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      dragonName: dragonName ?? this.dragonName,
      dragonEvolution: dragonEvolution ?? this.dragonEvolution,
      totalScales: totalScales ?? this.totalScales,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      dailyChallengeStreak: dailyChallengeStreak ?? this.dailyChallengeStreak,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      gameStats: gameStats ?? this.gameStats,
      settings: settings ?? this.settings,
      ownedCosmetics: ownedCosmetics ?? this.ownedCosmetics,
      equippedColor: equippedColor ?? this.equippedColor,
      equippedAccessories: equippedAccessories ?? this.equippedAccessories,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      isFirstSession: isFirstSession ?? this.isFirstSession,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }

  /// JSON serialization for Firestore sync (Step 10).
  Map<String, dynamic> toJson() { /* ... */ }
  factory PlayerProfile.fromJson(Map<String, dynamic> json) { /* ... */ }
}
```

### `GameStats` — Per-game statistics

```dart
@HiveType(typeId: 1)
class GameStats {
  @HiveField(0)
  final int currentLevel;

  @HiveField(1)
  final int highScore;

  @HiveField(2)
  final int totalStars;

  @HiveField(3)
  final int timesPlayed;

  @HiveField(4)
  final int bestStreak;

  @HiveField(5)
  final double accuracy; // lifetime accuracy 0.0-1.0

  @HiveField(6)
  final int totalCorrect;

  @HiveField(7)
  final int totalAttempted;

  @HiveField(8)
  final DateTime? lastPlayed;

  @HiveField(9)
  final Map<int, int> levelStars; // levelNumber -> stars (1-3)

  const GameStats({
    this.currentLevel = 1,
    this.highScore = 0,
    this.totalStars = 0,
    this.timesPlayed = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
    this.totalCorrect = 0,
    this.totalAttempted = 0,
    this.lastPlayed,
    this.levelStars = const {},
  });

  GameStats copyWith({ /* all fields */ }) { /* ... */ }
  Map<String, dynamic> toJson() { /* ... */ }
  factory GameStats.fromJson(Map<String, dynamic> json) { /* ... */ }
}
```

### `PlayerSettings`

```dart
@HiveType(typeId: 2)
class PlayerSettings {
  @HiveField(0)
  final bool soundEnabled;

  @HiveField(1)
  final bool musicEnabled;

  @HiveField(2)
  final bool hapticsEnabled;

  const PlayerSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
  });

  PlayerSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
  }) {
    return PlayerSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
```

### Hive Type ID Registry

Track all Hive type IDs to avoid collisions:

| typeId | Class | File |
|--------|-------|------|
| 0 | `PlayerProfile` | `core/player_profile.dart` |
| 1 | `GameStats` | `core/player_profile.dart` |
| 2 | `PlayerSettings` | `core/player_profile.dart` |
| 3 | `FactRecord` | `core/fact_tracker.dart` |
| 4 | `FactStatus` (enum adapter) | `core/fact_tracker.dart` |

### Code Generation

After writing the annotated classes, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates the `*.g.dart` adapter files that Hive needs.

---

## 5. Local Storage Layer (Hive)

### `lib/storage/local_storage.dart`

Replace the stub. This is the single interface through which all code reads/writes
persistent data. No other code should touch Hive directly.

```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../core/player_profile.dart';
import '../core/fact_tracker.dart';
import 'migration.dart';

class LocalStorage {
  static const String _profileBoxName = 'player_profile';
  static const String _factsBoxName = 'fact_history';
  static const String _metaBoxName = 'app_meta';
  static const String _profileKey = 'current_profile';
  static const String _schemaVersionKey = 'schema_version';

  late Box<PlayerProfile> _profileBox;
  late Box<FactRecord> _factsBox;
  late Box _metaBox;

  bool _initialized = false;

  /// Initialize Hive and open all boxes. Call once at app startup before runApp.
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters (generated by build_runner)
    Hive.registerAdapter(PlayerProfileAdapter());
    Hive.registerAdapter(GameStatsAdapter());
    Hive.registerAdapter(PlayerSettingsAdapter());
    Hive.registerAdapter(FactRecordAdapter());
    Hive.registerAdapter(FactStatusAdapter());

    // Open boxes
    _profileBox = await Hive.openBox<PlayerProfile>(_profileBoxName);
    _factsBox = await Hive.openBox<FactRecord>(_factsBoxName);
    _metaBox = await Hive.openBox(_metaBoxName);

    // Run migrations
    await MigrationRunner.run(this);

    _initialized = true;
  }

  // ──── Profile ────

  /// Get the current player profile, or create a default one if none exists.
  PlayerProfile getProfile() {
    return _profileBox.get(_profileKey) ?? _createDefaultProfile();
  }

  /// Save the player profile.
  Future<void> saveProfile(PlayerProfile profile) async {
    await _profileBox.put(_profileKey, profile);
  }

  /// Update the profile using a transform function.
  /// Returns the updated profile.
  Future<PlayerProfile> updateProfile(
    PlayerProfile Function(PlayerProfile current) transform,
  ) async {
    final current = getProfile();
    final updated = transform(current);
    await saveProfile(updated);
    return updated;
  }

  PlayerProfile _createDefaultProfile() {
    final profile = PlayerProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _profileBox.put(_profileKey, profile);
    return profile;
  }

  // ──── Fact History ────

  /// Get a fact record by its key (e.g., "7x8", "15-9").
  FactRecord? getFact(String factKey) {
    return _factsBox.get(factKey);
  }

  /// Save or update a fact record.
  Future<void> saveFact(FactRecord fact) async {
    await _factsBox.put(fact.factKey, fact);
  }

  /// Get all recorded facts.
  List<FactRecord> getAllFacts() {
    return _factsBox.values.toList();
  }

  /// Get facts filtered by status.
  List<FactRecord> getFactsByStatus(FactStatus status) {
    return _factsBox.values.where((f) => f.status == status).toList();
  }

  /// Count facts by status.
  Map<FactStatus, int> getFactStatusCounts() {
    final counts = <FactStatus, int>{};
    for (final status in FactStatus.values) {
      counts[status] = 0;
    }
    for (final fact in _factsBox.values) {
      counts[fact.status] = (counts[fact.status] ?? 0) + 1;
    }
    return counts;
  }

  // ──── Meta ────

  int get schemaVersion => _metaBox.get(_schemaVersionKey, defaultValue: 0) as int;

  Future<void> setSchemaVersion(int version) async {
    await _metaBox.put(_schemaVersionKey, version);
  }

  // ──── Lifecycle ────

  Future<void> close() async {
    await _profileBox.close();
    await _factsBox.close();
    await _metaBox.close();
  }

  /// Delete all data. Used only for development/testing.
  Future<void> clearAll() async {
    await _profileBox.clear();
    await _factsBox.clear();
    await _metaBox.clear();
  }
}
```

### Initialization Order

Hive must be initialized **before** the widget tree builds. Update `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. System UI
  await SystemChrome.setPreferredOrientations([ /* ... */ ]);
  SystemChrome.setSystemUIOverlayStyle( /* ... */ );

  // 2. Local storage
  final storage = LocalStorage();
  await storage.initialize();

  // 3. Run app with storage injected
  runApp(MathDragonsApp(storage: storage));
}
```

---

## 6. Schema Migration System

### `lib/storage/migration.dart`

Replace the stub. Simple, forward-only migration system. Each migration has a
target version and a function to execute.

```dart
import 'local_storage.dart';

class MigrationRunner {
  static const int currentVersion = 1;

  /// Run any needed migrations on app start.
  static Future<void> run(LocalStorage storage) async {
    final storedVersion = storage.schemaVersion;

    if (storedVersion >= currentVersion) return;

    // Run each migration in order
    for (int v = storedVersion + 1; v <= currentVersion; v++) {
      final migration = _migrations[v];
      if (migration != null) {
        await migration(storage);
      }
    }

    await storage.setSchemaVersion(currentVersion);
  }

  /// Registry of migration functions keyed by target version.
  /// Example for future use:
  ///   2: (storage) async => ... add new field ...
  ///   3: (storage) async => ... restructure data ...
  static final Map<int, Future<void> Function(LocalStorage)> _migrations = {
    1: _migrateToV1,
  };

  /// v0 -> v1: Initial schema setup. Just ensures a profile exists.
  static Future<void> _migrateToV1(LocalStorage storage) async {
    // Ensure a default profile exists
    storage.getProfile();
  }
}
```

### Migration Design Rules

1. **Never delete data** in a migration. Transform or rename.
2. **Always increment** `currentVersion` when adding a new migration.
3. **Migrations are idempotent.** Running one twice should not corrupt data.
4. **Each migration targets a single version bump** (v1→v2, v2→v3).
5. **Log migrations** for debugging (print to console in debug mode).

---

## 7. Event Bus

### `lib/core/event_bus.dart` (new file)

The event bus is a stream-based pub/sub system. Games emit `GameEvent` subtypes
(already defined in `game_events.dart`). Services subscribe by event type.

```dart
import 'dart:async';
import 'game_events.dart';

/// A simple event bus using Dart streams.
/// Games emit events. Services subscribe to specific event types.
///
/// Usage:
///   // Emit
///   eventBus.emit(AnswerGiven(gameId: 'dragon_eggs', ...));
///
///   // Listen
///   eventBus.on<AnswerGiven>().listen((event) { ... });
///
///   // Listen to all events
///   eventBus.stream.listen((event) { ... });
class EventBus {
  final _controller = StreamController<GameEvent>.broadcast();

  /// The raw event stream. Use [on<T>()] for typed subscriptions.
  Stream<GameEvent> get stream => _controller.stream;

  /// Subscribe to events of a specific type.
  Stream<T> on<T extends GameEvent>() {
    return _controller.stream.whereType<T>();
  }

  /// Emit an event to all listeners.
  void emit(GameEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Clean up. Call on app dispose.
  void dispose() {
    _controller.close();
  }
}
```

### Why Not a Package?

Dart's built-in `StreamController.broadcast()` gives us everything we need:
- Multiple listeners per event type
- Typed filtering with `whereType<T>()`
- Async-safe
- Automatic backpressure
- No external dependency

### Event Flow Example

```
Dragon Eggs emits:
  AnswerGiven(gameId: 'dragon_eggs', problem: '3+2', correct: true, ...)
    │
    ├──> RewardService.on<AnswerGiven>() → awards 2 scales
    ├──> FactTracker.on<AnswerGiven>()   → updates '3+2' accuracy record
    └──> (future) CloudSync.on<AnswerGiven>() → queues for sync
```

---

## 8. Game Registry Enhancement

### `lib/core/game_registry.dart`

The existing registry is functional but minimal. Enhance it with sorting, lookup,
and play-count tracking so the hub can display games intelligently.

```dart
import 'game_interface.dart';
import '../storage/local_storage.dart';

/// Central registry of all available games.
/// Games register on app start; the hub discovers and displays them.
class GameRegistry {
  final List<MathDragonsGame> _games = [];
  final LocalStorage _storage;

  GameRegistry(this._storage);

  List<MathDragonsGame> get games => List.unmodifiable(_games);

  int get count => _games.length;

  bool get isEmpty => _games.isEmpty;

  void register(MathDragonsGame game) {
    // Prevent duplicate registration
    if (_games.any((g) => g.gameId == game.gameId)) return;
    _games.add(game);
  }

  MathDragonsGame? getById(String gameId) {
    try {
      return _games.firstWhere((g) => g.gameId == gameId);
    } catch (_) {
      return null;
    }
  }

  /// Games sorted by most recently played (for hub display).
  List<MathDragonsGame> get gamesByLastPlayed {
    final profile = _storage.getProfile();
    return List<MathDragonsGame>.from(_games)..sort((a, b) {
      final aStats = profile.gameStats[a.gameId];
      final bStats = profile.gameStats[b.gameId];
      final aTime = aStats?.lastPlayed ?? DateTime(2000);
      final bTime = bStats?.lastPlayed ?? DateTime(2000);
      return bTime.compareTo(aTime); // most recent first
    });
  }

  /// Games the player has never played (for "try a new game" suggestions).
  List<MathDragonsGame> get unplayedGames {
    final profile = _storage.getProfile();
    return _games.where((g) {
      final stats = profile.gameStats[g.gameId];
      return stats == null || stats.timesPlayed == 0;
    }).toList();
  }
}
```

### Game Registration

Registration happens in `main.dart` after storage init and before the widget tree.
In Step 2, no real games are registered yet — just ensure the infrastructure is
ready. Real game classes register themselves in Steps 4-7.

```dart
// In main.dart, after storage init:
final registry = GameRegistry(storage);
// Steps 4-7 will add:
// registry.register(DragonEggsGame());
// registry.register(FireTrailGame());
// registry.register(DragonRunesGame());
// registry.register(DragonsFeastGame());
```

---

## 9. RewardService

### `lib/core/reward_service.dart`

Replace the stub. The RewardService listens to game events via the EventBus and
awards Dragon Scales according to the earning rates from the planning doc.

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'event_bus.dart';
import 'game_events.dart';
import '../storage/local_storage.dart';

/// Earning rates from the planning document (MOBILE_APP_PLAN.md section 9).
class ScaleRates {
  // Per correct answer: 1 for easy, 2 for medium, 3 for hard levels
  static int basePerCorrect(int levelNumber) {
    if (levelNumber <= 10) return 1;
    if (levelNumber <= 25) return 2;
    return 3;
  }

  // Streak bonus: +1 per consecutive correct, capped at +5
  static int streakBonus(int streakLength) {
    return streakLength.clamp(0, 5);
  }

  // Level completion: 10 for early, scales up to 30 for late levels
  static int levelCompletion(int levelNumber) {
    if (levelNumber <= 10) return 10;
    if (levelNumber <= 20) return 15;
    if (levelNumber <= 30) return 20;
    if (levelNumber <= 40) return 25;
    return 30;
  }

  // Bonus for 3-star completion
  static const int threeStarBonus = 15;

  // First time playing a new game
  static const int firstPlayBonus = 50;

  // Daily challenge completion
  static const int dailyChallengeBase = 25;

  // Daily challenge streak bonus: +5 per day, cap +25
  static int dailyChallengeStreakBonus(int streakDays) {
    return (streakDays * 5).clamp(0, 25);
  }

  // Bonus play session (3+ sessions/day)
  static const int bonusSession = 10;
}

/// Listens to game events and awards Dragon Scales.
/// Also updates cumulative stats on the player profile.
class RewardService {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final List<StreamSubscription> _subscriptions = [];

  /// Callback fired whenever scales are awarded. UI can listen to animate the counter.
  final ValueNotifier<int> lastScalesAwarded = ValueNotifier(0);

  RewardService({
    required EventBus eventBus,
    required LocalStorage storage,
  })  : _eventBus = eventBus,
        _storage = storage {
    _subscribe();
  }

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<AnswerGiven>().listen(_onAnswerGiven),
    );
    _subscriptions.add(
      _eventBus.on<StreakAchieved>().listen(_onStreakAchieved),
    );
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen(_onLevelCompleted),
    );
    _subscriptions.add(
      _eventBus.on<GameStarted>().listen(_onGameStarted),
    );
  }

  void _onAnswerGiven(AnswerGiven event) {
    if (!event.correct) return;

    // Determine level from game stats
    final profile = _storage.getProfile();
    final gameStats = profile.gameStats[event.gameId];
    final level = gameStats?.currentLevel ?? 1;

    final scales = ScaleRates.basePerCorrect(level);
    _awardScales(scales);

    // Update total correct count
    _storage.updateProfile((p) => p.copyWith(
      totalCorrectAnswers: p.totalCorrectAnswers + 1,
    ));
  }

  void _onStreakAchieved(StreakAchieved event) {
    final bonus = ScaleRates.streakBonus(event.streakLength);
    if (bonus > 0) {
      _awardScales(bonus);
    }
  }

  void _onLevelCompleted(LevelCompleted event) {
    int scales = ScaleRates.levelCompletion(event.levelNumber);
    if (event.stars >= 3) {
      scales += ScaleRates.threeStarBonus;
    }
    _awardScales(scales);

    // Update game stats
    _storage.updateProfile((p) {
      final currentGameStats = p.gameStats[event.gameId] ?? const GameStats();
      final updatedLevelStars = Map<int, int>.from(currentGameStats.levelStars);

      // Only save if better than existing stars
      final existing = updatedLevelStars[event.levelNumber] ?? 0;
      if (event.stars > existing) {
        updatedLevelStars[event.levelNumber] = event.stars;
      }

      final updatedGameStats = currentGameStats.copyWith(
        totalStars: updatedLevelStars.values.fold(0, (a, b) => a + b),
        highScore: event.score > currentGameStats.highScore
            ? event.score
            : null,
        levelStars: updatedLevelStars,
        currentLevel: event.levelNumber >= currentGameStats.currentLevel
            ? event.levelNumber + 1
            : null,
      );

      final newGameStats = Map<String, GameStats>.from(p.gameStats);
      newGameStats[event.gameId] = updatedGameStats;

      return p.copyWith(gameStats: newGameStats);
    });
  }

  void _onGameStarted(GameStarted event) {
    final profile = _storage.getProfile();
    final gameStats = profile.gameStats[event.gameId];

    // First-time bonus for a new game
    if (gameStats == null || gameStats.timesPlayed == 0) {
      _awardScales(ScaleRates.firstPlayBonus);
    }

    // Increment times played
    _storage.updateProfile((p) {
      final current = p.gameStats[event.gameId] ?? const GameStats();
      final updated = current.copyWith(
        timesPlayed: current.timesPlayed + 1,
        lastPlayed: DateTime.now(),
      );
      final newGameStats = Map<String, GameStats>.from(p.gameStats);
      newGameStats[event.gameId] = updated;
      return p.copyWith(
        gameStats: newGameStats,
        lastPlayedAt: DateTime.now(),
      );
    });
  }

  void _awardScales(int amount) {
    _storage.updateProfile((p) => p.copyWith(
      totalScales: p.totalScales + amount,
    ));
    lastScalesAwarded.value = amount;
  }

  /// Award scales from external sources (daily challenge, bonus session, IAP purchase, manual).
  void awardExternalScales(int amount) {
    _awardScales(amount);
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    lastScalesAwarded.dispose();
  }
}
```

---

## 10. FactTracker

### `lib/core/fact_tracker.dart`

Replace the stub. Tracks every math fact the player encounters. This is the data
layer for the adaptive difficulty engine (Step 8). Step 2 implements the recording
and retrieval — the selection algorithm comes later.

```dart
import 'dart:async';
import 'package:hive/hive.dart';
import 'event_bus.dart';
import 'game_events.dart';
import '../storage/local_storage.dart';

part 'fact_tracker.g.dart';

/// Status of a math fact based on player mastery.
/// See MOBILE_APP_PLAN.md section 8 "Fact Tracker System".
@HiveType(typeId: 4)
enum FactStatus {
  @HiveField(0)
  newFact,     // Never seen, or seen < 3 times

  @HiveField(1)
  learning,    // Seen 3+ times, accuracy < 70%

  @HiveField(2)
  familiar,    // Accuracy 70-89%

  @HiveField(3)
  mastered,    // Accuracy 90%+ with 5+ presentations
}

/// A single math fact's tracking record.
/// Examples: factKey = "7x8", "15-9", "prime:17", "mult3:12"
@HiveType(typeId: 3)
class FactRecord extends HiveObject {
  @HiveField(0)
  final String factKey;

  @HiveField(1)
  final int timesPresented;

  @HiveField(2)
  final int timesCorrect;

  @HiveField(3)
  final int currentStreak; // consecutive correct

  @HiveField(4)
  final DateTime? lastPresented;

  @HiveField(5)
  final DateTime? lastIncorrect;

  @HiveField(6)
  final double averageResponseTimeMs;

  @HiveField(7)
  final int totalResponseTimeMs; // sum for averaging

  FactRecord({
    required this.factKey,
    this.timesPresented = 0,
    this.timesCorrect = 0,
    this.currentStreak = 0,
    this.lastPresented,
    this.lastIncorrect,
    this.averageResponseTimeMs = 0,
    this.totalResponseTimeMs = 0,
  });

  /// Accuracy as 0.0-1.0.
  double get accuracy =>
      timesPresented > 0 ? timesCorrect / timesPresented : 0.0;

  /// Derived status based on presentation count and accuracy.
  FactStatus get status {
    if (timesPresented < 3) return FactStatus.newFact;
    if (accuracy < 0.7) return FactStatus.learning;
    if (accuracy < 0.9 || timesPresented < 5) return FactStatus.familiar;
    return FactStatus.mastered;
  }

  /// Create a new record after a correct answer.
  FactRecord recordCorrect(int responseTimeMs) {
    final newPresented = timesPresented + 1;
    final newCorrect = timesCorrect + 1;
    final newTotalTime = totalResponseTimeMs + responseTimeMs;
    return FactRecord(
      factKey: factKey,
      timesPresented: newPresented,
      timesCorrect: newCorrect,
      currentStreak: currentStreak + 1,
      lastPresented: DateTime.now(),
      lastIncorrect: lastIncorrect,
      averageResponseTimeMs: newTotalTime / newPresented,
      totalResponseTimeMs: newTotalTime,
    );
  }

  /// Create a new record after an incorrect answer.
  FactRecord recordIncorrect(int responseTimeMs) {
    final newPresented = timesPresented + 1;
    final newTotalTime = totalResponseTimeMs + responseTimeMs;
    return FactRecord(
      factKey: factKey,
      timesPresented: newPresented,
      timesCorrect: timesCorrect,
      currentStreak: 0,
      lastPresented: DateTime.now(),
      lastIncorrect: DateTime.now(),
      averageResponseTimeMs: newTotalTime / newPresented,
      totalResponseTimeMs: newTotalTime,
    );
  }

  FactRecord copyWith({
    String? factKey,
    int? timesPresented,
    int? timesCorrect,
    int? currentStreak,
    DateTime? lastPresented,
    DateTime? lastIncorrect,
    double? averageResponseTimeMs,
    int? totalResponseTimeMs,
  }) {
    return FactRecord(
      factKey: factKey ?? this.factKey,
      timesPresented: timesPresented ?? this.timesPresented,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      lastPresented: lastPresented ?? this.lastPresented,
      lastIncorrect: lastIncorrect ?? this.lastIncorrect,
      averageResponseTimeMs: averageResponseTimeMs ?? this.averageResponseTimeMs,
      totalResponseTimeMs: totalResponseTimeMs ?? this.totalResponseTimeMs,
    );
  }
}

/// Tracks math fact accuracy and mastery by listening to game events.
/// The problem selection algorithm (Step 8) reads from this data.
class FactTracker {
  final EventBus _eventBus;
  final LocalStorage _storage;
  final List<StreamSubscription> _subscriptions = [];

  FactTracker({
    required EventBus eventBus,
    required LocalStorage storage,
  })  : _eventBus = eventBus,
        _storage = storage {
    _subscribe();
  }

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<AnswerGiven>().listen(_onAnswerGiven),
    );
  }

  void _onAnswerGiven(AnswerGiven event) {
    // Build a fact key from the problem string.
    // Games should emit problem in a normalized format like "7x8" or "15-9".
    final factKey = _normalizeFactKey(event.problem);
    final existing = _storage.getFact(factKey) ??
        FactRecord(factKey: factKey);

    final updated = event.correct
        ? existing.recordCorrect(event.responseTimeMs)
        : existing.recordIncorrect(event.responseTimeMs);

    _storage.saveFact(updated);
  }

  /// Normalize a problem string into a consistent fact key.
  /// "3 + 2" -> "3+2", "7 × 8" -> "7x8", "15 ÷ 3" -> "15/3"
  String _normalizeFactKey(String problem) {
    return problem
        .replaceAll(' ', '')
        .replaceAll('×', 'x')
        .replaceAll('÷', '/')
        .replaceAll('=', '');
  }

  // ──── Query Methods (for difficulty engine, Step 8) ────

  /// Get a specific fact record.
  FactRecord? getFact(String factKey) => _storage.getFact(factKey);

  /// Get all tracked facts.
  List<FactRecord> getAllFacts() => _storage.getAllFacts();

  /// Get facts by their derived status.
  List<FactRecord> getFactsByStatus(FactStatus status) =>
      _storage.getFactsByStatus(status);

  /// Count of facts at each mastery level.
  Map<FactStatus, int> getStatusCounts() => _storage.getFactStatusCounts();

  /// How many facts has the player mastered (90%+ accuracy, 5+ presentations)?
  int get masteredFactCount =>
      _storage.getFactsByStatus(FactStatus.mastered).length;

  /// Facts that haven't been seen in N days (for spaced repetition boosting).
  List<FactRecord> factsNotSeenSince(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _storage.getAllFacts().where((f) {
      return f.lastPresented != null && f.lastPresented!.isBefore(cutoff);
    }).toList();
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
```

### Fact Key Convention

Games must emit `problem` strings in these normalized formats so the FactTracker
can build consistent keys:

| Game | Problem Format | Fact Key Example |
|------|---------------|------------------|
| Dragon Eggs | `"3+2=5"` | `"3+2=5"` |
| Fire Trail | `"7x8"` (question only) | `"7x8"` |
| Dragon Runes | `"3+2=5"` (full equation) | `"3+2=5"` |
| Dragon's Feast | `"prime:17"` or `"mult3:12"` | `"prime:17"` |

---

## 11. SessionManager

### `lib/core/session_manager.dart`

Replace the stub. Tracks when the player starts and stops a game session. Used for:
- Play time tracking (stored in profile)
- "Try another game" suggestions
- Session-based stats

```dart
import 'package:flutter/foundation.dart';
import '../storage/local_storage.dart';

/// Tracks the current play session state.
class SessionManager {
  final LocalStorage _storage;

  DateTime? _sessionStart;
  DateTime? _gameStart;
  String? _currentGameId;
  int _gamesPlayedThisSession = 0;
  int _consecutiveSameGame = 0;
  String? _lastGameId;

  /// Whether this is the player's very first session ever.
  bool get isFirstEverSession => _storage.getProfile().isFirstSession;

  /// Whether a game session is currently active.
  bool get isInGame => _currentGameId != null;

  /// The game currently being played, or null.
  String? get currentGameId => _currentGameId;

  /// How many games have been played in this app session.
  int get gamesPlayedThisSession => _gamesPlayedThisSession;

  /// How many times the same game has been played consecutively.
  int get consecutiveSameGame => _consecutiveSameGame;

  SessionManager({required LocalStorage storage}) : _storage = storage;

  /// Call when the app launches.
  void startAppSession() {
    _sessionStart = DateTime.now();
    _gamesPlayedThisSession = 0;
    _consecutiveSameGame = 0;
    _lastGameId = null;
  }

  /// Call when a game round starts.
  void startGame(String gameId) {
    _currentGameId = gameId;
    _gameStart = DateTime.now();
    _gamesPlayedThisSession++;

    if (gameId == _lastGameId) {
      _consecutiveSameGame++;
    } else {
      _consecutiveSameGame = 1;
      _lastGameId = gameId;
    }
  }

  /// Call when a game round ends. Returns the duration of the round.
  Duration endGame() {
    final duration = _gameStart != null
        ? DateTime.now().difference(_gameStart!)
        : Duration.zero;

    // Update play time in profile
    final minutes = duration.inMinutes;
    if (minutes > 0) {
      _storage.updateProfile((p) => p.copyWith(
        totalPlayTimeMinutes: p.totalPlayTimeMinutes + minutes,
      ));
    }

    _currentGameId = null;
    _gameStart = null;

    return duration;
  }

  /// Call when the app session ends (app goes to background or closes).
  void endAppSession() {
    // If a game was in progress, end it
    if (isInGame) {
      endGame();
    }

    // Mark first session as complete
    if (isFirstEverSession) {
      _storage.updateProfile((p) => p.copyWith(isFirstSession: false));
    }
  }

  /// Whether to suggest trying a different game.
  /// Returns true if the player has played the same game 3+ times in a row.
  bool get shouldSuggestDifferentGame => _consecutiveSameGame >= 3;

  /// Duration of the current app session.
  Duration get appSessionDuration => _sessionStart != null
      ? DateTime.now().difference(_sessionStart!)
      : Duration.zero;
}
```

---

## 12. HapticsService

### `lib/core/haptics.dart`

Replace the stub. Wraps Flutter's `HapticFeedback` with named methods matching
the haptic feedback map from the Visual Design Guide (section 11).

```dart
import 'package:flutter/services.dart';
import '../storage/local_storage.dart';

/// Named haptic feedback methods matching the Visual Design Guide.
/// All methods check the user's haptics setting before firing.
class HapticsService {
  final LocalStorage _storage;

  HapticsService({required LocalStorage storage}) : _storage = storage;

  bool get _enabled => _storage.getProfile().settings.hapticsEnabled;

  // ──── Game Events ────

  /// Correct answer — light, satisfying tap.
  Future<void> onCorrectAnswer() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Wrong answer — brief sharp buzz.
  Future<void> onWrongAnswer() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Streak milestone (5, 10, 15...) — celebratory double tap.
  Future<void> onStreakMilestone() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Level complete — positive medium then light.
  Future<void> onLevelComplete() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Dragon evolution — momentous triple selection click.
  Future<void> onDragonEvolution() async {
    if (!_enabled) return;
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.selectionClick();
      if (i < 2) await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  /// Achievement unlocked — descending intensity sequence.
  Future<void> onAchievementUnlocked() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  // ──── UI Interactions ────

  /// Scales earned — subtle background click.
  Future<void> onScalesEarned() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Button press — standard selection click.
  Future<void> onButtonPress() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Error or invalid action — warning buzz.
  Future<void> onError() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  // ──── Game-Specific ────

  /// Egg select (Dragon Eggs) — soft tap.
  Future<void> onEggSelect() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Egg hatch (Dragon Eggs) — cracking medium impact.
  Future<void> onEggHatch() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Munch (Dragon's Feast) — quick light nom.
  Future<void> onMunch() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Rune node select (Dragon Runes) — light pulse.
  Future<void> onRuneSelect() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Snake direction change (Fire Trail) — directional click.
  Future<void> onDirectionChange() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }
}
```

---

## 13. Provider Wiring

### `lib/app.dart` — Updated

Wrap the app in `MultiProvider` so all services are accessible from any widget.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'theme/dragon_theme.dart';
import 'hub/hub_screen.dart';
import 'hub/settings_screen.dart';
import 'games/dragon_runes/dragon_runes_game.dart';
import 'games/fire_trail/fire_trail_game.dart';
import 'games/dragon_eggs/dragon_eggs_game.dart';
import 'games/dragons_feast/dragons_feast_game.dart';
import 'storage/local_storage.dart';
import 'core/event_bus.dart';
import 'core/game_registry.dart';
import 'core/reward_service.dart';
import 'core/fact_tracker.dart';
import 'core/session_manager.dart';
import 'core/haptics.dart';

class MathDragonsApp extends StatefulWidget {
  final LocalStorage storage;

  const MathDragonsApp({super.key, required this.storage});

  @override
  State<MathDragonsApp> createState() => _MathDragonsAppState();
}

class _MathDragonsAppState extends State<MathDragonsApp>
    with WidgetsBindingObserver {
  late final EventBus _eventBus;
  late final GameRegistry _registry;
  late final RewardService _rewardService;
  late final FactTracker _factTracker;
  late final SessionManager _sessionManager;
  late final HapticsService _hapticsService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _eventBus = EventBus();
    _registry = GameRegistry(widget.storage);
    _rewardService = RewardService(
      eventBus: _eventBus,
      storage: widget.storage,
    );
    _factTracker = FactTracker(
      eventBus: _eventBus,
      storage: widget.storage,
    );
    _sessionManager = SessionManager(storage: widget.storage);
    _hapticsService = HapticsService(storage: widget.storage);

    _sessionManager.startAppSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _sessionManager.endAppSession();
    } else if (state == AppLifecycleState.resumed) {
      _sessionManager.startAppSession();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionManager.endAppSession();
    _rewardService.dispose();
    _factTracker.dispose();
    _eventBus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorage>.value(value: widget.storage),
        Provider<EventBus>.value(value: _eventBus),
        Provider<GameRegistry>.value(value: _registry),
        Provider<RewardService>.value(value: _rewardService),
        Provider<FactTracker>.value(value: _factTracker),
        Provider<SessionManager>.value(value: _sessionManager),
        Provider<HapticsService>.value(value: _hapticsService),
      ],
      child: MaterialApp(
        title: 'Math Dragons',
        debugShowCheckedModeBanner: false,
        theme: DragonTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const HubScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
          '/game/dragon_runes': (context) => const DragonRunesScreen(),
          '/game/fire_trail': (context) => const FireTrailScreen(),
          '/game/dragon_eggs': (context) => const DragonEggsScreen(),
          '/game/dragons_feast': (context) => const DragonsFeastScreen(),
        },
      ),
    );
  }
}
```

### `lib/main.dart` — Updated

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1A2E),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize persistent storage before building widget tree
  final storage = LocalStorage();
  await storage.initialize();

  runApp(MathDragonsApp(storage: storage));
}
```

### Accessing Services in Widgets

Any widget can now access services:

```dart
// Read-only access (most common)
final storage = context.read<LocalStorage>();
final profile = storage.getProfile();

// EventBus for emitting from games
final eventBus = context.read<EventBus>();
eventBus.emit(AnswerGiven(gameId: 'dragon_eggs', ...));

// Haptics for UI feedback
final haptics = context.read<HapticsService>();
haptics.onButtonPress();

// RewardService for manual scale awards
final rewards = context.read<RewardService>();
rewards.awardExternalScales(10); // bonus session award

// Session manager
final session = context.read<SessionManager>();
session.startGame('fire_trail');
```

---

## 14. Localization Updates

### Add new strings to `lib/l10n/app_en.arb`

Add these strings for Step 2 features that affect the UI:

```json
{
  "dragonNameLabel": "Dragon Name",
  "@dragonNameLabel": { "description": "Label for dragon name input" },

  "playTimeMinutes": "{count} min played",
  "@playTimeMinutes": {
    "description": "Total play time display",
    "placeholders": { "count": { "type": "int" } }
  },

  "factsLearned": "{count} facts learned",
  "@factsLearned": {
    "description": "Number of math facts at familiar or mastered status",
    "placeholders": { "count": { "type": "int" } }
  },

  "factsMastered": "{count} facts mastered",
  "@factsMastered": {
    "description": "Number of math facts at mastered status",
    "placeholders": { "count": { "type": "int" } }
  },

  "totalCorrect": "{count} correct answers",
  "@totalCorrect": {
    "description": "Lifetime correct answer count",
    "placeholders": { "count": { "type": "int" } }
  },

  "aboutTitle": "About Math Dragons",
  "@aboutTitle": { "description": "About section heading in settings" },

  "version": "Version {version}",
  "@version": {
    "description": "App version display",
    "placeholders": { "version": { "type": "String" } }
  }
}
```

---

## 15. Unit Tests

### Test Files to Create

```
test/
├── core/
│   ├── player_profile_test.dart
│   ├── event_bus_test.dart
│   ├── reward_service_test.dart
│   └── fact_tracker_test.dart
└── storage/
    └── migration_test.dart
```

### `test/core/player_profile_test.dart`

Test that the PlayerProfile data model works correctly:

```dart
// Test cases:
// 1. Default profile has correct initial values
//    - totalScales == 0, dragonEvolution == 0, isFirstSession == true
//
// 2. copyWith preserves unchanged fields
//    - Modify one field, verify all others unchanged
//
// 3. copyWith updates changed fields
//    - Modify totalScales, verify new value
//
// 4. GameStats defaults are correct
//    - currentLevel == 1, highScore == 0, accuracy == 0.0
//
// 5. GameStats copyWith works correctly
//
// 6. Nested gameStats map in profile copyWith
//    - Add a game's stats, then update it, verify both states
//
// 7. toJson / fromJson round-trip (for future Firestore sync)
//    - Create profile → toJson → fromJson → compare fields
//
// 8. PlayerSettings defaults are correct
//    - soundEnabled == true, musicEnabled == true, hapticsEnabled == true
```

### `test/core/event_bus_test.dart`

```dart
// Test cases:
// 1. Emit and receive a single event type
//    - Emit AnswerGiven, verify subscriber receives it
//
// 2. Typed subscription only receives matching events
//    - Subscribe to AnswerGiven, emit GameStarted, verify no callback
//    - Then emit AnswerGiven, verify callback fires
//
// 3. Multiple listeners on same event type
//    - Two listeners on AnswerGiven, both receive the event
//
// 4. Stream filter (on<T>) works correctly
//    - Emit a mix of event types, verify each typed stream only gets its type
//
// 5. Dispose prevents further emissions
//    - Dispose the bus, emit an event, verify no error and no delivery
//
// 6. Events have correct timestamps
//    - Emit event, verify timestamp is approximately now
```

### `test/core/reward_service_test.dart`

```dart
// Test cases (use a mock LocalStorage):
// 1. Correct answer awards base scales
//    - Level 1-10: 1 scale per correct
//    - Level 11-25: 2 scales per correct
//    - Level 26+: 3 scales per correct
//
// 2. Streak bonus is capped at 5
//    - StreakAchieved(streakLength: 3) → +3 scales
//    - StreakAchieved(streakLength: 10) → +5 scales (capped)
//
// 3. Level completion awards correct amount
//    - Level 5 → 10 scales
//    - Level 15 → 15 scales
//    - Level 35 → 25 scales
//    - Level 45 → 30 scales
//
// 4. Three-star bonus adds 15
//    - LevelCompleted with stars: 3 → levelCompletion + 15
//    - LevelCompleted with stars: 2 → levelCompletion only
//
// 5. First play bonus is 50 scales
//    - GameStarted for a game with timesPlayed == 0 → +50
//
// 6. First play bonus only awards once
//    - Second GameStarted for same game → no bonus
//
// 7. Incorrect answer awards nothing
//    - AnswerGiven with correct: false → 0 scales
//
// 8. Profile totalCorrectAnswers increments on correct answer
```

### `test/core/fact_tracker_test.dart`

```dart
// Test cases:
// 1. New fact starts as FactStatus.newFact
//    - Record with 0 presentations → newFact
//
// 2. Status transitions: new → learning
//    - 3 presentations, 1 correct (33%) → learning
//
// 3. Status transitions: learning → familiar
//    - 10 presentations, 8 correct (80%) → familiar
//
// 4. Status transitions: familiar → mastered
//    - 10 presentations, 9 correct (90%) → mastered
//
// 5. Accuracy calculation
//    - 7 correct out of 10 → 0.7
//
// 6. recordCorrect updates all fields correctly
//    - Increments timesPresented, timesCorrect, currentStreak
//    - Updates lastPresented, averageResponseTimeMs
//
// 7. recordIncorrect resets streak to 0
//    - After a streak of 5, one incorrect → currentStreak == 0
//    - Updates lastIncorrect
//
// 8. Fact key normalization
//    - "3 + 2" → "3+2"
//    - "7 × 8" → "7x8"
//    - "15 ÷ 3" → "15/3"
//
// 9. factsNotSeenSince returns stale facts
//    - Fact with lastPresented 10 days ago, query for 7 days → included
//    - Fact with lastPresented 3 days ago, query for 7 days → excluded
```

---

## 16. Verification Checklist

After completing this step, verify:

- [ ] **`dart run build_runner build`** succeeds — Hive adapters generated
- [ ] **`flutter analyze`** passes clean
- [ ] **`flutter test`** — all unit tests pass
- [ ] **`flutter build apk --debug`** succeeds
- [ ] **App launches** — no Hive initialization errors
- [ ] **Close and reopen app** — profile data persists
- [ ] **Hub profile bar** shows real scales count (0) from storage
- [ ] **Settings toggles** persist between app restarts
- [ ] **New file `core/event_bus.dart`** exists and compiles
- [ ] **All stubs replaced** — no more `// TODO: Implement in Step 2` in any file
- [ ] **Provider works** — add a temporary debug print in hub_screen that reads
  the profile via Provider and prints totalScales; verify it outputs 0

### Quick Smoke Test

```bash
cd math_dragons
set PATH=%USERPROFILE%\scoop\apps\flutter\current\bin;%PATH%
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug
```

---

## Files Modified in This Step

| File | Action | Description |
|------|--------|-------------|
| `lib/core/player_profile.dart` | **Replace** | Full data model with Hive annotations, copyWith, toJson/fromJson |
| `lib/core/event_bus.dart` | **Create** | Stream-based typed event bus |
| `lib/core/game_registry.dart` | **Replace** | Enhanced with sorted queries and storage dependency |
| `lib/core/reward_service.dart` | **Replace** | Full scales earning logic with event bus listeners |
| `lib/core/fact_tracker.dart` | **Replace** | FactRecord model + tracking service with event bus listener |
| `lib/core/session_manager.dart` | **Replace** | Session timing, game count, suggestions |
| `lib/core/haptics.dart` | **Replace** | Named haptic methods matching Visual Design Guide |
| `lib/storage/local_storage.dart` | **Replace** | Hive wrapper for profiles, facts, meta |
| `lib/storage/migration.dart` | **Replace** | Forward-only migration runner |
| `lib/app.dart` | **Modify** | Add MultiProvider, accept storage param, lifecycle observer |
| `lib/main.dart` | **Modify** | Initialize storage before runApp, pass to MathDragonsApp |
| `lib/l10n/app_en.arb` | **Modify** | Add new localization strings |
| `pubspec.yaml` | No change needed | Hive + Provider already in dependencies |

### Files Generated (do not edit manually)

| File | Generator |
|------|-----------|
| `lib/core/player_profile.g.dart` | `build_runner` (Hive adapters) |
| `lib/core/fact_tracker.g.dart` | `build_runner` (Hive adapters) |

---

## What This Step Does NOT Include

These are explicitly out of scope for Step 2:

- **UI changes to hub/games** — Step 3 upgrades the hub to use real data
- **Problem selection algorithm** — Step 8 (the adaptive difficulty engine)
- **Achievement definitions/checking** — Step 9
- **Daily challenge generation** — Step 9
- **Cloud sync / Firebase** — Step 10
- **IAP** — Step 11
- **Sound / animation** — Step 12

Step 2 builds the invisible foundation. The app will look identical after this step
but will be silently persisting data, tracking sessions, and ready for events.

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
