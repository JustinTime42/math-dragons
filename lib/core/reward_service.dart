import 'dart:async';
import 'package:flutter/foundation.dart';
import 'event_bus.dart';
import 'game_events.dart';
import 'player_profile.dart';
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
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

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

    final profile = _storage.getProfile();
    final gameStats = profile.gameStats[event.gameId];
    final level = gameStats?.currentLevel ?? 1;

    final scales = ScaleRates.basePerCorrect(level);
    _awardScales(scales);

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

    _storage.updateProfile((p) {
      final currentGameStats =
          p.gameStats[event.gameId] ?? const GameStats();
      final updatedLevelStars =
          Map<int, int>.from(currentGameStats.levelStars);

      // Only save if better than existing stars
      final existing = updatedLevelStars[event.levelNumber] ?? 0;
      if (event.stars > existing) {
        updatedLevelStars[event.levelNumber] = event.stars;
      }

      final updatedGameStats = currentGameStats.copyWith(
        totalStars: updatedLevelStars.values.fold<int>(0, (a, b) => a + b),
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

  /// Award scales from external sources (rewarded ad, daily challenge, manual).
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
