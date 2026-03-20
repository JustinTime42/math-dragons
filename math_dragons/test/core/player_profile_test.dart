import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/player_profile.dart';

void main() {
  group('PlayerProfile', () {
    test('default profile has correct initial values', () {
      final profile = PlayerProfile(id: 'test');

      expect(profile.totalScales, 0);
      expect(profile.dragonEvolution, 0);
      expect(profile.isFirstSession, true);
      expect(profile.totalCorrectAnswers, 0);
      expect(profile.totalPlayTimeMinutes, 0);
      expect(profile.dailyChallengeStreak, 0);
      expect(profile.dragonName, 'Dragon');
      expect(profile.schemaVersion, 1);
      expect(profile.gameStats, isEmpty);
      expect(profile.ownedCosmetics, isEmpty);
      expect(profile.equippedAccessories, isEmpty);
      expect(profile.equippedColor, isNull);
      expect(profile.ageGroup, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final profile = PlayerProfile(
        id: 'test',
        dragonName: 'Flamewing',
        totalScales: 100,
        dragonEvolution: 2,
      );

      final updated = profile.copyWith(totalScales: 200);

      expect(updated.id, 'test');
      expect(updated.dragonName, 'Flamewing');
      expect(updated.dragonEvolution, 2);
      expect(updated.totalScales, 200);
      expect(updated.isFirstSession, true);
    });

    test('copyWith updates changed fields', () {
      final profile = PlayerProfile(id: 'test');
      final updated = profile.copyWith(
        totalScales: 500,
        dragonName: 'Ember',
        dragonEvolution: 3,
      );

      expect(updated.totalScales, 500);
      expect(updated.dragonName, 'Ember');
      expect(updated.dragonEvolution, 3);
    });

    test('nested gameStats map in profile copyWith', () {
      final profile = PlayerProfile(id: 'test');

      // Add game stats
      final withStats = profile.copyWith(
        gameStats: {
          'dragon_eggs': const GameStats(currentLevel: 5, highScore: 200),
        },
      );
      expect(withStats.gameStats['dragon_eggs']?.currentLevel, 5);
      expect(withStats.gameStats['dragon_eggs']?.highScore, 200);

      // Update game stats
      final newStats = Map<String, GameStats>.from(withStats.gameStats);
      newStats['dragon_eggs'] =
          withStats.gameStats['dragon_eggs']!.copyWith(highScore: 300);
      final updated = withStats.copyWith(gameStats: newStats);

      expect(updated.gameStats['dragon_eggs']?.currentLevel, 5);
      expect(updated.gameStats['dragon_eggs']?.highScore, 300);
    });

    test('toJson / fromJson round-trip', () {
      final now = DateTime(2026, 2, 15);
      final profile = PlayerProfile(
        id: 'test123',
        dragonName: 'Goldwing',
        dragonEvolution: 2,
        totalScales: 500,
        totalCorrectAnswers: 100,
        totalPlayTimeMinutes: 60,
        dailyChallengeStreak: 3,
        createdAt: now,
        lastPlayedAt: now,
        gameStats: {
          'fire_trail': GameStats(
            currentLevel: 8,
            highScore: 1500,
            totalStars: 20,
            timesPlayed: 15,
            bestStreak: 7,
            accuracy: 0.85,
            totalCorrect: 42,
            totalAttempted: 50,
            lastPlayed: now,
            levelStars: const {1: 3, 2: 3, 3: 2},
          ),
        },
        settings: const PlayerSettings(
          soundEnabled: false,
          musicEnabled: true,
          hapticsEnabled: false,
        ),
        ownedCosmetics: const ['red_scales', 'gold_crown'],
        equippedColor: 'red_scales',
        equippedAccessories: const ['gold_crown'],
        schemaVersion: 1,
        isFirstSession: false,
        ageGroup: '13plus',
      );

      final json = profile.toJson();
      final restored = PlayerProfile.fromJson(json);

      expect(restored.id, profile.id);
      expect(restored.dragonName, profile.dragonName);
      expect(restored.dragonEvolution, profile.dragonEvolution);
      expect(restored.totalScales, profile.totalScales);
      expect(restored.totalCorrectAnswers, profile.totalCorrectAnswers);
      expect(restored.totalPlayTimeMinutes, profile.totalPlayTimeMinutes);
      expect(restored.dailyChallengeStreak, profile.dailyChallengeStreak);
      expect(restored.settings.soundEnabled, false);
      expect(restored.settings.musicEnabled, true);
      expect(restored.settings.hapticsEnabled, false);
      expect(restored.ownedCosmetics, ['red_scales', 'gold_crown']);
      expect(restored.equippedColor, 'red_scales');
      expect(restored.isFirstSession, false);
      expect(restored.ageGroup, '13plus');
      expect(restored.gameStats['fire_trail']?.currentLevel, 8);
      expect(restored.gameStats['fire_trail']?.highScore, 1500);
      expect(restored.gameStats['fire_trail']?.levelStars[1], 3);
    });
  });

  group('GameStats', () {
    test('defaults are correct', () {
      const stats = GameStats();
      expect(stats.currentLevel, 1);
      expect(stats.highScore, 0);
      expect(stats.totalStars, 0);
      expect(stats.timesPlayed, 0);
      expect(stats.bestStreak, 0);
      expect(stats.accuracy, 0.0);
      expect(stats.totalCorrect, 0);
      expect(stats.totalAttempted, 0);
      expect(stats.lastPlayed, isNull);
      expect(stats.levelStars, isEmpty);
    });

    test('copyWith works correctly', () {
      const stats = GameStats(currentLevel: 5, highScore: 200);
      final updated = stats.copyWith(highScore: 300, timesPlayed: 10);

      expect(updated.currentLevel, 5);
      expect(updated.highScore, 300);
      expect(updated.timesPlayed, 10);
    });

    test('toJson / fromJson round-trip', () {
      final now = DateTime(2026, 2, 15);
      final stats = GameStats(
        currentLevel: 8,
        highScore: 1500,
        totalStars: 20,
        timesPlayed: 15,
        bestStreak: 7,
        accuracy: 0.85,
        totalCorrect: 42,
        totalAttempted: 50,
        lastPlayed: now,
        levelStars: const {1: 3, 2: 2, 3: 1},
      );

      final json = stats.toJson();
      final restored = GameStats.fromJson(json);

      expect(restored.currentLevel, stats.currentLevel);
      expect(restored.highScore, stats.highScore);
      expect(restored.totalStars, stats.totalStars);
      expect(restored.accuracy, stats.accuracy);
      expect(restored.levelStars[1], 3);
      expect(restored.levelStars[2], 2);
      expect(restored.levelStars[3], 1);
    });
  });

  group('PlayerSettings', () {
    test('defaults are correct', () {
      const settings = PlayerSettings();
      expect(settings.soundEnabled, true);
      expect(settings.musicEnabled, true);
      expect(settings.hapticsEnabled, true);
    });

    test('copyWith works', () {
      const settings = PlayerSettings();
      final updated = settings.copyWith(soundEnabled: false);

      expect(updated.soundEnabled, false);
      expect(updated.musicEnabled, true);
      expect(updated.hapticsEnabled, true);
    });
  });
}
