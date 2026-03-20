// Events emitted by games through the event bus.
// Listeners (RewardService, FactTracker, CloudSync, etc.) subscribe independently.

sealed class GameEvent {
  final String gameId;
  final DateTime timestamp;

  GameEvent({required this.gameId}) : timestamp = DateTime.now();
}

class GameStarted extends GameEvent {
  final int levelNumber;

  GameStarted({required super.gameId, required this.levelNumber});
}

class AnswerGiven extends GameEvent {
  final String problem;
  final String playerAnswer;
  final String correctAnswer;
  final bool correct;
  final int responseTimeMs;

  AnswerGiven({
    required super.gameId,
    required this.problem,
    required this.playerAnswer,
    required this.correctAnswer,
    required this.correct,
    required this.responseTimeMs,
  });
}

class StreakAchieved extends GameEvent {
  final int streakLength;

  StreakAchieved({required super.gameId, required this.streakLength});
}

class LevelCompleted extends GameEvent {
  final int levelNumber;
  final int score;
  final int stars;
  final double accuracy;

  LevelCompleted({
    required super.gameId,
    required this.levelNumber,
    required this.score,
    required this.stars,
    required this.accuracy,
  });
}

class GameEnded extends GameEvent {
  final int finalScore;
  final Duration duration;

  GameEnded({
    required super.gameId,
    required this.finalScore,
    required this.duration,
  });
}

class AchievementUnlocked extends GameEvent {
  final String achievementId;
  final String achievementTitle;
  final int scalesAwarded;

  AchievementUnlocked({
    required this.achievementId,
    required this.achievementTitle,
    required this.scalesAwarded,
  }) : super(gameId: 'system');
}
