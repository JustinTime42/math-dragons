import 'dart:async';
import 'package:flutter/foundation.dart';
import 'achievement_tracker.dart';
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
  AchievementTracker? _achievementTracker;
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

  /// Fires when dragon evolution stage changes.
  final ValueNotifier<int> evolutionStage = ValueNotifier(0);

  /// Callback fired when the dragon evolves to a new stage.
  void Function(int oldStage, int newStage)? onEvolution;

  ProgressionManager({
    required EventBus eventBus,
    required LocalStorage storage,
    required FactTracker factTracker,
    AchievementTracker? achievementTracker,
  })  : _eventBus = eventBus,
        _storage = storage,
        _factTracker = factTracker,
        _achievementTracker = achievementTracker {
    evolutionStage.value = _storage.getProfile().dragonEvolution;
    _subscribe();
  }

  /// Set the achievement tracker (for late initialization).
  set achievementTracker(AchievementTracker tracker) {
    _achievementTracker = tracker;
  }

  void _subscribe() {
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen((event) => checkEvolution()),
    );
    _subscriptions.add(
      _eventBus.on<GameEnded>().listen((event) => checkEvolution()),
    );
  }

  /// Check if the player qualifies for the next evolution stage.
  /// Updates the profile if a new stage is reached.
  void checkEvolution() {
    final profile = _storage.getProfile();
    final currentStage = profile.dragonEvolution;

    // Sync the notifier with profile state
    evolutionStage.value = currentStage;

    // Check next stage only (no skipping stages)
    final nextStage = currentStage + 1;
    if (nextStage > 5) return; // Already at max

    final req = EvolutionRequirements.forStage(nextStage);
    if (req.isMet(profile, _factTracker,
        achievementTracker: _achievementTracker, storage: _storage)) {
      _storage.updateProfile(
          (p) => p.copyWith(dragonEvolution: nextStage));
      evolutionStage.value = nextStage;
      onEvolution?.call(currentStage, nextStage);
    }
  }

  /// Get progress toward the next evolution stage as a map of requirement -> progress.
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
      requirements: req.progressItems(profile, _factTracker,
          achievementTracker: _achievementTracker, storage: _storage),
    );
  }

  /// Suggest a game the player should try next (variety encouragement).
  String? suggestGame(String currentGameId) {
    final profile = _storage.getProfile();
    const allGames = [
      'dragon_runes',
      'fire_trail',
      'dragon_eggs',
      'dragons_feast'
    ];

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
  final String label;
  final int current;
  final int target;
  final bool isMet;

  const EvolutionProgressItem({
    required this.label,
    required this.current,
    required this.target,
    required this.isMet,
  });

  double get progress =>
      target > 0 ? (current / target).clamp(0.0, 1.0) : 1.0;
}

/// Evolution requirements for each dragon stage.
class EvolutionRequirements {
  final int stage;
  final int minLevelInGames;
  final int gamesRequired;
  final int totalScales;
  final int achievements;
  final int threeStarLevels;
  final int dailyChallenges;
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
          minLevelInGames: 5,
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
  bool isMet(PlayerProfile profile, FactTracker factTracker,
      {AchievementTracker? achievementTracker, LocalStorage? storage}) {
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

    // Check achievements
    if (achievements > 0) {
      final current = achievementTracker?.unlockedCount ?? 0;
      if (current < achievements) return false;
    }

    // Check daily challenges
    if (dailyChallenges > 0) {
      final current = storage?.getTotalDailyChallengesCompleted() ?? 0;
      if (current < dailyChallenges) return false;
    }

    return true;
  }

  /// Build progress items for UI display.
  List<EvolutionProgressItem> progressItems(
      PlayerProfile profile, FactTracker factTracker,
      {AchievementTracker? achievementTracker, LocalStorage? storage}) {
    final items = <EvolutionProgressItem>[];

    if (gamesRequired > 0) {
      final current = _gamesAtMinLevel(profile);
      items.add(EvolutionProgressItem(
        label:
            'Reach level $minLevelInGames in $gamesRequired game${gamesRequired > 1 ? 's' : ''}',
        current: current,
        target: gamesRequired,
        isMet: current >= gamesRequired,
      ));
    }

    if (totalScales > 0) {
      items.add(EvolutionProgressItem(
        label: 'Earn $totalScales scales',
        current: profile.totalScales,
        target: totalScales,
        isMet: profile.totalScales >= totalScales,
      ));
    }

    if (threeStarLevels > 0) {
      final current = _countThreeStarLevels(profile);
      items.add(EvolutionProgressItem(
        label: '3-star $threeStarLevels levels',
        current: current,
        target: threeStarLevels,
        isMet: current >= threeStarLevels,
      ));
    }

    if (masteredFacts > 0) {
      final current = factTracker.masteredFactCount;
      items.add(EvolutionProgressItem(
        label: 'Master $masteredFacts facts',
        current: current,
        target: masteredFacts,
        isMet: current >= masteredFacts,
      ));
    }

    if (achievements > 0) {
      final current = achievementTracker?.unlockedCount ?? 0;
      items.add(EvolutionProgressItem(
        label: 'Unlock $achievements achievements',
        current: current,
        target: achievements,
        isMet: current >= achievements,
      ));
    }

    if (dailyChallenges > 0) {
      final current = storage?.getTotalDailyChallengesCompleted() ?? 0;
      items.add(EvolutionProgressItem(
        label: 'Complete $dailyChallenges daily challenges',
        current: current,
        target: dailyChallenges,
        isMet: current >= dailyChallenges,
      ));
    }

    return items;
  }

  int _gamesAtMinLevel(PlayerProfile profile) {
    const allGames = [
      'dragon_runes',
      'fire_trail',
      'dragon_eggs',
      'dragons_feast'
    ];
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
