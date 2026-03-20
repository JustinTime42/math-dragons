import 'package:hive/hive.dart';

part 'achievement.g.dart';

/// A single achievement definition.
class AchievementDef {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final int scalesReward;
  final String? gameId;
  final String iconEmoji;

  /// Returns true if the achievement should unlock.
  final bool Function(AchievementCheckContext) checkUnlocked;

  /// Optional: returns progress as (current, target).
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
  final int totalCorrectAnswers;
  final int totalScales;
  final int dragonEvolution;
  final Map<String, GameStatsSnapshot> gameStats;
  final int masteredFacts;
  final int totalThreeStarLevels;
  final int dailyChallengeStreak;
  final int totalDailyChallenges;
  final String? triggerEventGameId;
  final int? triggerStreakLength;
  final int? triggerLevelNumber;
  final double? triggerAccuracy;

  const AchievementCheckContext({
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

/// Persisted achievement state.
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

// ── Helper for per-game level checks ──
int _gameLevel(AchievementCheckContext ctx, String gameId) =>
    ctx.gameStats[gameId]?.currentLevel ?? 0;

int _gameStreak(AchievementCheckContext ctx, String gameId) =>
    ctx.gameStats[gameId]?.bestStreak ?? 0;

bool _hasThreeStar(AchievementCheckContext ctx, String gameId) {
  final stars = ctx.gameStats[gameId]?.levelStars ?? {};
  return stars.values.any((s) => s >= 3);
}

/// The complete catalog of all achievements.
class AchievementCatalog {
  static final List<AchievementDef> all = [
    ...perGameAchievements,
    ...crossGameAchievements,
    ...milestoneAchievements,
  ];

  static final List<AchievementDef> perGameAchievements = [
    // ── Dragon Runes ──
    AchievementDef(
      id: 'runes_first',
      title: 'First Rune',
      description: 'Complete your first Dragon Runes level',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 25,
      iconEmoji: '\u{1F4DC}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_runes') >= 2,
    ),
    AchievementDef(
      id: 'runes_10',
      title: 'Rune Caster',
      description: 'Complete 10 Dragon Runes levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 50,
      iconEmoji: '\u{1F4DC}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_runes') >= 11,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_runes') - 1, 10),
    ),
    AchievementDef(
      id: 'runes_25',
      title: 'Rune Master',
      description: 'Complete 25 Dragon Runes levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 75,
      iconEmoji: '\u{1F4DC}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_runes') >= 26,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_runes') - 1, 25),
    ),
    AchievementDef(
      id: 'runes_all_worlds',
      title: 'Elder Runekeeper',
      description: 'Complete all 50 Dragon Runes levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 100,
      iconEmoji: '\u{1F4DC}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_runes') >= 51,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_runes') - 1, 50),
    ),
    AchievementDef(
      id: 'runes_perfect',
      title: 'Perfect Spell',
      description: '3-star a Dragon Runes level with 100% accuracy',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 50,
      iconEmoji: '\u{2728}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'dragon_runes' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0 &&
          _hasThreeStar(ctx, 'dragon_runes'),
    ),
    AchievementDef(
      id: 'runes_streak_10',
      title: 'Chain Lightning',
      description: 'Build a 10-streak in Dragon Runes',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 50,
      iconEmoji: '\u{26A1}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragon_runes') >= 10,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragon_runes'), 10),
    ),
    AchievementDef(
      id: 'runes_streak_20',
      title: 'Thunderstorm',
      description: 'Build a 20-streak in Dragon Runes',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 75,
      iconEmoji: '\u{26A1}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragon_runes') >= 20,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragon_runes'), 20),
    ),
    AchievementDef(
      id: 'runes_speed',
      title: 'Speed Caster',
      description: 'Complete a Dragon Runes level in under 60 seconds',
      category: AchievementCategory.perGame,
      gameId: 'dragon_runes',
      scalesReward: 50,
      iconEmoji: '\u{23F1}',
      // This is checked via trigger data; for now check level progress
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_runes') >= 6,
    ),

    // ── Fire Trail ──
    AchievementDef(
      id: 'trail_first',
      title: 'First Flight',
      description: 'Complete your first Fire Trail level',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 25,
      iconEmoji: '\u{1F525}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'fire_trail') >= 2,
    ),
    AchievementDef(
      id: 'trail_10',
      title: 'Thermal Rider',
      description: 'Complete 10 Fire Trail levels',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 50,
      iconEmoji: '\u{1F525}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'fire_trail') >= 11,
      getProgress: (ctx) => (_gameLevel(ctx, 'fire_trail') - 1, 10),
    ),
    AchievementDef(
      id: 'trail_25',
      title: 'Firestorm Pilot',
      description: 'Complete 25 Fire Trail levels',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 75,
      iconEmoji: '\u{1F525}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'fire_trail') >= 26,
      getProgress: (ctx) => (_gameLevel(ctx, 'fire_trail') - 1, 25),
    ),
    AchievementDef(
      id: 'trail_all_worlds',
      title: 'Dragon Master',
      description: 'Complete all 40 Fire Trail levels',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 100,
      iconEmoji: '\u{1F525}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'fire_trail') >= 41,
      getProgress: (ctx) => (_gameLevel(ctx, 'fire_trail') - 1, 40),
    ),
    AchievementDef(
      id: 'trail_perfect',
      title: 'Perfect Run',
      description: '3-star a Fire Trail level with 100% accuracy',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 50,
      iconEmoji: '\u{2728}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'fire_trail' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0 &&
          _hasThreeStar(ctx, 'fire_trail'),
    ),
    AchievementDef(
      id: 'trail_streak_10',
      title: 'Blazing Streak',
      description: 'Build a 10-streak in Fire Trail',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 50,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'fire_trail') >= 10,
      getProgress: (ctx) => (_gameStreak(ctx, 'fire_trail'), 10),
    ),
    AchievementDef(
      id: 'trail_streak_20',
      title: 'Inferno Chain',
      description: 'Build a 20-streak in Fire Trail',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 75,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'fire_trail') >= 20,
      getProgress: (ctx) => (_gameStreak(ctx, 'fire_trail'), 20),
    ),
    AchievementDef(
      id: 'trail_survivor',
      title: 'Iron Flame',
      description: 'Complete a Fire Trail level without any wrong answers',
      category: AchievementCategory.perGame,
      gameId: 'fire_trail',
      scalesReward: 50,
      iconEmoji: '\u{1F6E1}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'fire_trail' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0,
    ),

    // ── Dragon Eggs ──
    AchievementDef(
      id: 'eggs_first',
      title: 'First Hatch',
      description: 'Complete your first Dragon Eggs level',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 25,
      iconEmoji: '\u{1F95A}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_eggs') >= 2,
    ),
    AchievementDef(
      id: 'eggs_10',
      title: 'Egg Collector',
      description: 'Complete 10 Dragon Eggs levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 50,
      iconEmoji: '\u{1F95A}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_eggs') >= 11,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_eggs') - 1, 10),
    ),
    AchievementDef(
      id: 'eggs_25',
      title: 'Hatchery Master',
      description: 'Complete 25 Dragon Eggs levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 75,
      iconEmoji: '\u{1F95A}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_eggs') >= 26,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_eggs') - 1, 25),
    ),
    AchievementDef(
      id: 'eggs_all_worlds',
      title: 'Ancient Keeper',
      description: 'Complete all 50 Dragon Eggs levels',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 100,
      iconEmoji: '\u{1F95A}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_eggs') >= 51,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragon_eggs') - 1, 50),
    ),
    AchievementDef(
      id: 'eggs_perfect',
      title: 'Perfect Hatch',
      description: '3-star a Dragon Eggs level with 100% accuracy',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 50,
      iconEmoji: '\u{2728}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'dragon_eggs' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0 &&
          _hasThreeStar(ctx, 'dragon_eggs'),
    ),
    AchievementDef(
      id: 'eggs_streak_10',
      title: 'Combo Cracker',
      description: 'Build a 10-streak in Dragon Eggs',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 50,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragon_eggs') >= 10,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragon_eggs'), 10),
    ),
    AchievementDef(
      id: 'eggs_streak_20',
      title: 'Hatch Storm',
      description: 'Build a 20-streak in Dragon Eggs',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 75,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragon_eggs') >= 20,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragon_eggs'), 20),
    ),
    AchievementDef(
      id: 'eggs_division',
      title: 'Division Dragon',
      description: 'Complete a Dragon Eggs level using division',
      category: AchievementCategory.perGame,
      gameId: 'dragon_eggs',
      scalesReward: 50,
      iconEmoji: '\u{2797}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragon_eggs') >= 32,
    ),

    // ── Dragon's Feast ──
    AchievementDef(
      id: 'feast_first',
      title: 'First Bite',
      description: "Complete your first Dragon's Feast level",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 25,
      iconEmoji: '\u{1F356}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragons_feast') >= 2,
    ),
    AchievementDef(
      id: 'feast_10',
      title: 'Hungry Dragon',
      description: "Complete 10 Dragon's Feast levels",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 50,
      iconEmoji: '\u{1F356}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragons_feast') >= 11,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragons_feast') - 1, 10),
    ),
    AchievementDef(
      id: 'feast_25',
      title: 'Gourmet Dragon',
      description: "Complete 25 Dragon's Feast levels",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 75,
      iconEmoji: '\u{1F356}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragons_feast') >= 26,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragons_feast') - 1, 25),
    ),
    AchievementDef(
      id: 'feast_all_worlds',
      title: 'Feast King',
      description: "Complete all 40 Dragon's Feast levels",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 100,
      iconEmoji: '\u{1F356}',
      checkUnlocked: (ctx) => _gameLevel(ctx, 'dragons_feast') >= 41,
      getProgress: (ctx) => (_gameLevel(ctx, 'dragons_feast') - 1, 40),
    ),
    AchievementDef(
      id: 'feast_perfect',
      title: 'Perfect Palate',
      description: "3-star a Dragon's Feast level with 100% accuracy",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 50,
      iconEmoji: '\u{2728}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'dragons_feast' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0 &&
          _hasThreeStar(ctx, 'dragons_feast'),
    ),
    AchievementDef(
      id: 'feast_streak_10',
      title: 'Feeding Frenzy',
      description: "Build a 10-streak in Dragon's Feast",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 50,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragons_feast') >= 10,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragons_feast'), 10),
    ),
    AchievementDef(
      id: 'feast_streak_20',
      title: 'Insatiable',
      description: "Build a 20-streak in Dragon's Feast",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 75,
      iconEmoji: '\u{1F4A5}',
      checkUnlocked: (ctx) => _gameStreak(ctx, 'dragons_feast') >= 20,
      getProgress: (ctx) => (_gameStreak(ctx, 'dragons_feast'), 20),
    ),
    AchievementDef(
      id: 'feast_no_catch',
      title: 'Untouchable',
      description: "Complete a Dragon's Feast level without being caught",
      category: AchievementCategory.perGame,
      gameId: 'dragons_feast',
      scalesReward: 50,
      iconEmoji: '\u{1F6E1}',
      checkUnlocked: (ctx) =>
          ctx.triggerEventGameId == 'dragons_feast' &&
          ctx.triggerAccuracy != null &&
          ctx.triggerAccuracy! >= 1.0,
    ),
  ];

  static final List<AchievementDef> crossGameAchievements = [
    AchievementDef(
      id: 'cross_explorer',
      title: 'Dragon Explorer',
      description: 'Play all 4 games in one day',
      category: AchievementCategory.crossGame,
      scalesReward: 50,
      iconEmoji: '\u{1F30D}',
      checkUnlocked: (ctx) {
        const games = [
          'dragon_runes',
          'fire_trail',
          'dragon_eggs',
          'dragons_feast'
        ];
        return games.every((g) => (ctx.gameStats[g]?.timesPlayed ?? 0) > 0);
      },
    ),
    AchievementDef(
      id: 'cross_wellrounded',
      title: 'Well-Rounded',
      description: 'Earn scales in 3 different games in one session',
      category: AchievementCategory.crossGame,
      scalesReward: 50,
      iconEmoji: '\u{1F3AF}',
      checkUnlocked: (ctx) {
        const games = [
          'dragon_runes',
          'fire_trail',
          'dragon_eggs',
          'dragons_feast'
        ];
        final played = games.where((g) =>
            (ctx.gameStats[g]?.timesPlayed ?? 0) > 0).length;
        return played >= 3;
      },
    ),
    AchievementDef(
      id: 'cross_variety',
      title: 'Variety Pack',
      description: 'Reach level 5 in all 4 games',
      category: AchievementCategory.crossGame,
      scalesReward: 75,
      iconEmoji: '\u{1F3B2}',
      checkUnlocked: (ctx) {
        const games = [
          'dragon_runes',
          'fire_trail',
          'dragon_eggs',
          'dragons_feast'
        ];
        return games.every((g) => _gameLevel(ctx, g) >= 5);
      },
    ),
    AchievementDef(
      id: 'cross_olympian',
      title: 'Math Olympian',
      description: '3-star a level in every game',
      category: AchievementCategory.crossGame,
      scalesReward: 75,
      iconEmoji: '\u{1F3C5}',
      checkUnlocked: (ctx) {
        const games = [
          'dragon_runes',
          'fire_trail',
          'dragon_eggs',
          'dragons_feast'
        ];
        return games.every((g) => _hasThreeStar(ctx, g));
      },
    ),
    AchievementDef(
      id: 'cross_daily_7',
      title: 'Daily Devotion',
      description: 'Complete 7 daily challenges in a row',
      category: AchievementCategory.crossGame,
      scalesReward: 75,
      iconEmoji: '\u{1F4C5}',
      checkUnlocked: (ctx) => ctx.dailyChallengeStreak >= 7,
      getProgress: (ctx) => (ctx.dailyChallengeStreak, 7),
    ),
    AchievementDef(
      id: 'cross_daily_14',
      title: 'Two Week Warrior',
      description: 'Complete 14 daily challenges in a row',
      category: AchievementCategory.crossGame,
      scalesReward: 100,
      iconEmoji: '\u{1F4C5}',
      checkUnlocked: (ctx) => ctx.dailyChallengeStreak >= 14,
      getProgress: (ctx) => (ctx.dailyChallengeStreak, 14),
    ),
    AchievementDef(
      id: 'cross_daily_30',
      title: 'Monthly Master',
      description: 'Complete 30 daily challenges in a row',
      category: AchievementCategory.crossGame,
      scalesReward: 100,
      iconEmoji: '\u{1F4C5}',
      checkUnlocked: (ctx) => ctx.dailyChallengeStreak >= 30,
      getProgress: (ctx) => (ctx.dailyChallengeStreak, 30),
    ),
    AchievementDef(
      id: 'cross_all_world1',
      title: 'World Wanderer',
      description: 'Complete World 1 in all 4 games',
      category: AchievementCategory.crossGame,
      scalesReward: 75,
      iconEmoji: '\u{1F5FA}',
      checkUnlocked: (ctx) {
        // World 1 max: Runes 10, Trail 8, Eggs 10, Feast 8
        return _gameLevel(ctx, 'dragon_runes') >= 11 &&
            _gameLevel(ctx, 'fire_trail') >= 9 &&
            _gameLevel(ctx, 'dragon_eggs') >= 11 &&
            _gameLevel(ctx, 'dragons_feast') >= 9;
      },
    ),
    AchievementDef(
      id: 'cross_all_world3',
      title: 'Realm Explorer',
      description: 'Complete World 3 in all 4 games',
      category: AchievementCategory.crossGame,
      scalesReward: 100,
      iconEmoji: '\u{1F5FA}',
      checkUnlocked: (ctx) {
        // World 3 max: Runes 35, Trail 24, Eggs 30, Feast 24
        return _gameLevel(ctx, 'dragon_runes') >= 36 &&
            _gameLevel(ctx, 'fire_trail') >= 25 &&
            _gameLevel(ctx, 'dragon_eggs') >= 31 &&
            _gameLevel(ctx, 'dragons_feast') >= 25;
      },
    ),
    AchievementDef(
      id: 'cross_total_stars_50',
      title: 'Star Gatherer',
      description: 'Earn 50 total stars across all games',
      category: AchievementCategory.crossGame,
      scalesReward: 75,
      iconEmoji: '\u{2B50}',
      checkUnlocked: (ctx) {
        final totalStars =
            ctx.gameStats.values.fold<int>(0, (sum, g) => sum + g.totalStars);
        return totalStars >= 50;
      },
      getProgress: (ctx) {
        final totalStars =
            ctx.gameStats.values.fold<int>(0, (sum, g) => sum + g.totalStars);
        return (totalStars, 50);
      },
    ),
  ];

  static final List<AchievementDef> milestoneAchievements = [
    AchievementDef(
      id: 'mile_century',
      title: 'Century',
      description: 'Answer 100 problems correctly',
      category: AchievementCategory.milestone,
      scalesReward: 50,
      iconEmoji: '\u{1F4AF}',
      checkUnlocked: (ctx) => ctx.totalCorrectAnswers >= 100,
      getProgress: (ctx) => (ctx.totalCorrectAnswers, 100),
    ),
    AchievementDef(
      id: 'mile_thousand',
      title: 'Thousand Strong',
      description: 'Answer 1,000 problems correctly',
      category: AchievementCategory.milestone,
      scalesReward: 75,
      iconEmoji: '\u{1F4AA}',
      checkUnlocked: (ctx) => ctx.totalCorrectAnswers >= 1000,
      getProgress: (ctx) => (ctx.totalCorrectAnswers, 1000),
    ),
    AchievementDef(
      id: 'mile_five_thousand',
      title: 'Math Machine',
      description: 'Answer 5,000 problems correctly',
      category: AchievementCategory.milestone,
      scalesReward: 100,
      iconEmoji: '\u{1F916}',
      checkUnlocked: (ctx) => ctx.totalCorrectAnswers >= 5000,
      getProgress: (ctx) => (ctx.totalCorrectAnswers, 5000),
    ),
    AchievementDef(
      id: 'mile_facts_25',
      title: 'Fact Finder',
      description: 'Master 25 math facts (90%+ accuracy)',
      category: AchievementCategory.milestone,
      scalesReward: 50,
      iconEmoji: '\u{1F4D6}',
      checkUnlocked: (ctx) => ctx.masteredFacts >= 25,
      getProgress: (ctx) => (ctx.masteredFacts, 25),
    ),
    AchievementDef(
      id: 'mile_facts_50',
      title: 'Fact Scholar',
      description: 'Master 50 math facts',
      category: AchievementCategory.milestone,
      scalesReward: 75,
      iconEmoji: '\u{1F4D6}',
      checkUnlocked: (ctx) => ctx.masteredFacts >= 50,
      getProgress: (ctx) => (ctx.masteredFacts, 50),
    ),
    AchievementDef(
      id: 'mile_facts_100',
      title: 'Fact Titan',
      description: 'Master 100 math facts',
      category: AchievementCategory.milestone,
      scalesReward: 100,
      iconEmoji: '\u{1F4D6}',
      checkUnlocked: (ctx) => ctx.masteredFacts >= 100,
      getProgress: (ctx) => (ctx.masteredFacts, 100),
    ),
    AchievementDef(
      id: 'mile_times_tables',
      title: 'Times Table Titan',
      description: 'Master all multiplication facts 1-12',
      category: AchievementCategory.milestone,
      scalesReward: 100,
      iconEmoji: '\u{1F9EE}',
      // 144 multiplication facts (1x1 through 12x12)
      checkUnlocked: (ctx) => ctx.masteredFacts >= 144,
      getProgress: (ctx) => (ctx.masteredFacts, 144),
    ),
    AchievementDef(
      id: 'mile_scales_1000',
      title: 'Scale Collector',
      description: 'Earn 1,000 total scales',
      category: AchievementCategory.milestone,
      scalesReward: 50,
      iconEmoji: '\u{1F48E}',
      checkUnlocked: (ctx) => ctx.totalScales >= 1000,
      getProgress: (ctx) => (ctx.totalScales, 1000),
    ),
    AchievementDef(
      id: 'mile_scales_5000',
      title: 'Scale Hoarder',
      description: 'Earn 5,000 total scales',
      category: AchievementCategory.milestone,
      scalesReward: 75,
      iconEmoji: '\u{1F48E}',
      checkUnlocked: (ctx) => ctx.totalScales >= 5000,
      getProgress: (ctx) => (ctx.totalScales, 5000),
    ),
    AchievementDef(
      id: 'mile_evolution_3',
      title: 'Dragon Raiser',
      description: 'Reach dragon evolution stage 3',
      category: AchievementCategory.milestone,
      scalesReward: 75,
      iconEmoji: '\u{1F409}',
      checkUnlocked: (ctx) => ctx.dragonEvolution >= 3,
      getProgress: (ctx) => (ctx.dragonEvolution, 3),
    ),
  ];
}
