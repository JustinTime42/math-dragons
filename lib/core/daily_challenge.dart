import 'package:hive/hive.dart';

part 'daily_challenge.g.dart';

/// A single day's challenge consisting of 2-3 tasks.
class DailyChallenge {
  final DateTime date;
  final List<ChallengeTask> tasks;
  final int baseReward;
  final int streakBonus;

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
  final String gameId;
  final ChallengeType type;
  final int targetValue;
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
  scoreInGame,
  completeLevels,
  getStreak,
  playGames,
  correctAnswers,
}

/// Persisted daily challenge completion state.
@HiveType(typeId: 6)
class DailyChallengeState extends HiveObject {
  @HiveField(0)
  final String dateKey;

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
