import 'dart:math';
import 'equation_validator.dart';

/// Outcome type of a scoring event.
enum ScoringOutcomeType { correct, incorrect, alreadyFound, bonus }

/// Result of processing an equation validation through the scoring system.
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
  }) =>
      ScoringOutcome._(
        type: ScoringOutcomeType.correct,
        points: points,
        streak: streak,
        hadStreakBonus: hadStreakBonus,
      );

  factory ScoringOutcome.incorrect() =>
      const ScoringOutcome._(type: ScoringOutcomeType.incorrect);

  factory ScoringOutcome.alreadyFound() =>
      const ScoringOutcome._(type: ScoringOutcomeType.alreadyFound);

  factory ScoringOutcome.bonus({required int points}) =>
      ScoringOutcome._(type: ScoringOutcomeType.bonus, points: points);
}

/// Manages score, streak, and equation counting.
class ScoringManager {
  int score = 0;
  int streak = 0;
  int bestStreak = 0;
  int equationsFound = 0;
  int bonusFound = 0;
  int totalAttempts = 0;

  static const int correctBase = 100;
  static const int bonusBase = 50;
  static const int streakBonus = 50;
  static const int streakThreshold = 3;
  static const int levelCompleteBonus = 500;

  /// Handle a validated equation result.
  ScoringOutcome handleResult(EquationResult result) {
    totalAttempts++;

    switch (result) {
      case TargetMatchEquation():
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
        // Bonus equations earn half points, preserve streak
        streak++;
        bestStreak = max(bestStreak, streak);
        bonusFound++;
        final bonusPts = bonusBase;
        score += bonusPts;
        return ScoringOutcome.bonus(points: bonusPts);
    }
  }

  /// Add level complete bonus.
  int completeLevelBonus() {
    score += levelCompleteBonus;
    return levelCompleteBonus;
  }

  /// Reset for a new level.
  void reset() {
    score = 0;
    streak = 0;
    bestStreak = 0;
    equationsFound = 0;
    bonusFound = 0;
    totalAttempts = 0;
  }
}
