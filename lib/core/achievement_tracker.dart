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

    // Emit event
    _eventBus.emit(AchievementUnlocked(
      achievementId: achievement.id,
      achievementTitle: achievement.title,
      scalesAwarded: achievement.scalesReward,
    ));

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
