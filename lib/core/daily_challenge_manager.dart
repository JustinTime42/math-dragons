import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'daily_challenge.dart';
import 'event_bus.dart';
import 'game_events.dart';
import 'reward_service.dart';
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

    const games = [
      'dragon_runes',
      'fire_trail',
      'dragon_eggs',
      'dragons_feast'
    ];
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
    final templates =
        _allTemplates.where((t) => !used.contains(t.type)).toList();
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
          description:
              'Complete $levels level${levels > 1 ? 's' : ''} in $gameName',
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
    _levelsCompletedPerGame[event.gameId] =
        (_levelsCompletedPerGame[event.gameId] ?? 0) + 1;
    // Approximate correct answers from accuracy and a base count
    _correctAnswersToday +=
        (event.accuracy * 10).round();
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
      completedTaskIds: _todayChallenge.tasks
          .where((t) => t.isComplete)
          .map((t) => t.id)
          .toList(),
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
