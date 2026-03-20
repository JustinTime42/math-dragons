import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/achievement.dart';

void main() {
  group('AchievementCatalog', () {
    test('all contains 52 achievements (32 per-game + 10 cross-game + 10 milestone)', () {
      expect(AchievementCatalog.all.length, 52);
      expect(AchievementCatalog.perGameAchievements.length, 32);
      expect(AchievementCatalog.crossGameAchievements.length, 10);
      expect(AchievementCatalog.milestoneAchievements.length, 10);
    });

    test('all achievement IDs are unique', () {
      final ids = AchievementCatalog.all.map((a) => a.id).toSet();
      expect(ids.length, AchievementCatalog.all.length);
    });

    test('all per-game achievements have a non-null gameId', () {
      for (final achievement in AchievementCatalog.perGameAchievements) {
        expect(
          achievement.gameId,
          isNotNull,
          reason: '${achievement.id} should have a non-null gameId',
        );
      }
    });

    test('cross-game achievements have null gameId', () {
      for (final achievement in AchievementCatalog.crossGameAchievements) {
        expect(
          achievement.gameId,
          isNull,
          reason: '${achievement.id} should have null gameId',
        );
      }
    });

    test('milestone achievements have null gameId', () {
      for (final achievement in AchievementCatalog.milestoneAchievements) {
        expect(
          achievement.gameId,
          isNull,
          reason: '${achievement.id} should have null gameId',
        );
      }
    });

    test('all scalesReward values are between 25 and 100', () {
      for (final achievement in AchievementCatalog.all) {
        expect(
          achievement.scalesReward,
          inInclusiveRange(25, 100),
          reason: '${achievement.id} scalesReward should be 25-100',
        );
      }
    });
  });

  group('AchievementCheckContext', () {
    AchievementCheckContext emptyContext() {
      return const AchievementCheckContext(
        totalCorrectAnswers: 0,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );
    }

    test('checkUnlocked returns false for a fresh empty context', () {
      final ctx = emptyContext();
      for (final achievement in AchievementCatalog.all) {
        expect(
          achievement.checkUnlocked(ctx),
          isFalse,
          reason: '${achievement.id} should not unlock with empty context',
        );
      }
    });

    test('checkUnlocked returns true for runes_first with dragon_runes level >= 2', () {
      final runesFirst = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'runes_first',
      );

      final ctx = AchievementCheckContext(
        totalCorrectAnswers: 0,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {
          'dragon_runes': const GameStatsSnapshot(currentLevel: 2),
        },
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );

      expect(runesFirst.checkUnlocked(ctx), isTrue);
    });

    test('checkUnlocked returns true for mile_century with 100+ correct answers', () {
      final mileCentury = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'mile_century',
      );

      final ctx = const AchievementCheckContext(
        totalCorrectAnswers: 100,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );

      expect(mileCentury.checkUnlocked(ctx), isTrue);
    });

    test('checkUnlocked returns false for mile_century with 99 correct answers', () {
      final mileCentury = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'mile_century',
      );

      final ctx = const AchievementCheckContext(
        totalCorrectAnswers: 99,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );

      expect(mileCentury.checkUnlocked(ctx), isFalse);
    });

    test('getProgress returns correct (current, target) tuple for milestone achievements', () {
      final mileCentury = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'mile_century',
      );

      final ctx = const AchievementCheckContext(
        totalCorrectAnswers: 42,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );

      final progress = mileCentury.getProgress!(ctx);
      expect(progress, isNotNull);
      expect(progress!.$1, 42); // current
      expect(progress.$2, 100); // target
    });

    test('getProgress returns correct values for facts milestone', () {
      final mileFacts25 = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'mile_facts_25',
      );

      final ctx = const AchievementCheckContext(
        totalCorrectAnswers: 0,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 15,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 0,
        totalDailyChallenges: 0,
      );

      final progress = mileFacts25.getProgress!(ctx);
      expect(progress!.$1, 15); // current
      expect(progress.$2, 25); // target
    });

    test('getProgress returns correct values for daily challenge streak', () {
      final crossDaily7 = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'cross_daily_7',
      );

      final ctx = const AchievementCheckContext(
        totalCorrectAnswers: 0,
        totalScales: 0,
        dragonEvolution: 0,
        gameStats: {},
        masteredFacts: 0,
        totalThreeStarLevels: 0,
        dailyChallengeStreak: 4,
        totalDailyChallenges: 0,
      );

      final progress = crossDaily7.getProgress!(ctx);
      expect(progress!.$1, 4); // current
      expect(progress.$2, 7); // target
    });
  });

  group('UnlockedAchievement', () {
    test('stores achievementId, unlockedAt, and scalesAwarded', () {
      final now = DateTime.now();
      final unlocked = UnlockedAchievement(
        achievementId: 'runes_first',
        unlockedAt: now,
        scalesAwarded: 25,
      );

      expect(unlocked.achievementId, 'runes_first');
      expect(unlocked.unlockedAt, now);
      expect(unlocked.scalesAwarded, 25);
    });
  });

  group('AchievementCategory', () {
    test('has three values: perGame, crossGame, milestone', () {
      expect(AchievementCategory.values.length, 3);
      expect(AchievementCategory.values, contains(AchievementCategory.perGame));
      expect(AchievementCategory.values, contains(AchievementCategory.crossGame));
      expect(AchievementCategory.values, contains(AchievementCategory.milestone));
    });

    test('all per-game achievements have perGame category', () {
      for (final a in AchievementCatalog.perGameAchievements) {
        expect(a.category, AchievementCategory.perGame);
      }
    });

    test('all cross-game achievements have crossGame category', () {
      for (final a in AchievementCatalog.crossGameAchievements) {
        expect(a.category, AchievementCategory.crossGame);
      }
    });

    test('all milestone achievements have milestone category', () {
      for (final a in AchievementCatalog.milestoneAchievements) {
        expect(a.category, AchievementCategory.milestone);
      }
    });
  });
}
