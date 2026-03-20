import '../dragon_eggs/models/egg_data.dart';
import 'math_problem.dart';

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
      highScore: targets * 100 + targets * 50,
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
