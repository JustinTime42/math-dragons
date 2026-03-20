import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/progression_manager.dart';
import 'package:math_dragons/core/achievement_tracker.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/game_events.dart';
import 'package:math_dragons/core/reward_service.dart';
import 'package:math_dragons/core/daily_challenge.dart';
import 'package:math_dragons/storage/local_storage.dart';

// Mock LocalStorage for testing
class MockLocalStorage extends LocalStorage {
  PlayerProfile _profile = PlayerProfile(id: 'test-id');
  final Map<String, DailyChallengeState> _dailyChallenges = {};
  final Set<String> _unlockedAchievementIds = {};

  @override
  PlayerProfile getProfile() => _profile;

  @override
  Future<void> saveProfile(PlayerProfile profile) async {
    _profile = profile;
  }

  @override
  Future<PlayerProfile> updateProfile(
    PlayerProfile Function(PlayerProfile current) transform,
  ) async {
    _profile = transform(_profile);
    return _profile;
  }

  void setProfile(PlayerProfile profile) {
    _profile = profile;
  }

  @override
  Set<String> getUnlockedAchievementIds() => _unlockedAchievementIds;

  @override
  int getTotalDailyChallengesCompleted() =>
      _dailyChallenges.values.where((s) => s.allComplete).length;

  void setUnlockedAchievements(int count) {
    _unlockedAchievementIds.clear();
    for (int i = 0; i < count; i++) {
      _unlockedAchievementIds.add('ach_$i');
    }
  }

  void setDailyChallengesCompleted(int count) {
    _dailyChallenges.clear();
    for (int i = 0; i < count; i++) {
      _dailyChallenges['2026-01-${(i + 1).toString().padLeft(2, '0')}'] =
          DailyChallengeState(
        dateKey: '2026-01-${(i + 1).toString().padLeft(2, '0')}',
        completedTaskIds: ['task_0'],
        allComplete: true,
      );
    }
  }
}

// Mock FactTracker for testing
class MockFactTracker extends FactTracker {
  int _masteredCount = 0;

  MockFactTracker({required super.eventBus, required super.storage});

  @override
  int get masteredFactCount => _masteredCount;

  void setMasteredFactCount(int count) {
    _masteredCount = count;
  }
}

// Mock AchievementTracker for testing
class MockAchievementTracker extends AchievementTracker {
  int _unlockedCount = 0;

  MockAchievementTracker({
    required super.eventBus,
    required super.storage,
    required super.factTracker,
    required super.rewardService,
  });

  @override
  int get unlockedCount => _unlockedCount;

  void setUnlockedCount(int count) {
    _unlockedCount = count;
  }
}

void main() {
  group('EvolutionRequirements', () {
    late MockLocalStorage storage;
    late MockFactTracker factTracker;
    late EventBus eventBus;
    late RewardService rewardService;
    late MockAchievementTracker achievementTracker;

    setUp(() {
      storage = MockLocalStorage();
      eventBus = EventBus();
      factTracker = MockFactTracker(eventBus: eventBus, storage: storage);
      rewardService = RewardService(eventBus: eventBus, storage: storage);
      achievementTracker = MockAchievementTracker(
        eventBus: eventBus,
        storage: storage,
        factTracker: factTracker,
        rewardService: rewardService,
      );
    });

    tearDown(() {
      achievementTracker.dispose();
      rewardService.dispose();
      eventBus.dispose();
      factTracker.dispose();
    });

    group('Stage 1 (Hatchling)', () {
      test('requires level 5 in 1 game + 100 scales', () {
        final req = EvolutionRequirements.forStage(1);
        expect(req.stage, 1);
        expect(req.minLevelInGames, 5);
        expect(req.gamesRequired, 1);
        expect(req.totalScales, 100);
        expect(req.threeStarLevels, 0);
        expect(req.masteredFacts, 0);
      });

      test('isMet when profile has level 5 in 1 game and 100 scales', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 100,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 5),
          },
        );

        expect(req.isMet(profile, factTracker), true);
      });

      test('isMet when profile has more than required', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 500,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 10),
            'dragon_runes': const GameStats(currentLevel: 5),
          },
        );

        expect(req.isMet(profile, factTracker), true);
      });

      test('not met when scales are insufficient', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 99,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 3),
          },
        );

        expect(req.isMet(profile, factTracker), false);
      });

      test('not met when no game reaches level 5', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 100,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 4),
          },
        );

        expect(req.isMet(profile, factTracker), false);
      });

      test('progressItems returns correct current/required values', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 50,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 2),
          },
        );

        final items = req.progressItems(profile, factTracker);
        expect(items, hasLength(2));

        // Check level requirement
        expect(items[0].label, 'Reach level 5 in 1 game');
        expect(items[0].current, 0);
        expect(items[0].target, 1);
        expect(items[0].isMet, false);
        expect(items[0].progress, 0.0);

        // Check scales requirement
        expect(items[1].label, 'Earn 100 scales');
        expect(items[1].current, 50);
        expect(items[1].target, 100);
        expect(items[1].isMet, false);
        expect(items[1].progress, 0.5);
      });

      test('progressItems shows met requirements', () {
        final req = EvolutionRequirements.forStage(1);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 150,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 5),
          },
        );

        final items = req.progressItems(profile, factTracker);
        expect(items[0].isMet, true);
        expect(items[0].current, 1);
        expect(items[0].progress, 1.0);
        expect(items[1].isMet, true);
        expect(items[1].progress, 1.0);
      });
    });

    group('Stage 2 (Fledgling)', () {
      test('requires level 8 in 2 different games', () {
        final req = EvolutionRequirements.forStage(2);
        expect(req.stage, 2);
        expect(req.minLevelInGames, 8);
        expect(req.gamesRequired, 2);
        expect(req.totalScales, 750);
        expect(req.achievements, 5);
      });

      test('isMet when profile has level 8 in 2 games and 750 scales', () {
        final req = EvolutionRequirements.forStage(2);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 750,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 8),
            'dragon_runes': const GameStats(currentLevel: 10),
          },
        );
        achievementTracker.setUnlockedCount(5);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), true);
      });

      test('not met when only 1 game reaches level 8', () {
        final req = EvolutionRequirements.forStage(2);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 750,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 8),
            'dragon_runes': const GameStats(currentLevel: 7),
          },
        );
        achievementTracker.setUnlockedCount(5);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), false);
      });

      test('progressItems shows correct plural label for multiple games', () {
        final req = EvolutionRequirements.forStage(2);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 200,
          gameStats: {
            'fire_trail': const GameStats(currentLevel: 8),
          },
        );

        final items = req.progressItems(profile, factTracker);
        expect(items[0].label, 'Reach level 8 in 2 games');
        expect(items[0].current, 1);
        expect(items[0].target, 2);
        expect(items[0].progress, 0.5);
      });

      test('progressItems includes achievements placeholder', () {
        final req = EvolutionRequirements.forStage(2);
        final profile = PlayerProfile(id: 'test');

        final items = req.progressItems(profile, factTracker);
        // Find achievements item
        final achievementItem = items.firstWhere(
          (item) => item.label.contains('achievements'),
        );
        expect(achievementItem.current, 0);
        expect(achievementItem.target, 5);
        expect(achievementItem.isMet, false);
      });
    });

    group('Stage 3 (Young Dragon)', () {
      test('requires level 15 in 3 games + 3000 scales + 10 three-star levels', () {
        final req = EvolutionRequirements.forStage(3);
        expect(req.stage, 3);
        expect(req.minLevelInGames, 15);
        expect(req.gamesRequired, 3);
        expect(req.totalScales, 3000);
        expect(req.achievements, 15);
        expect(req.threeStarLevels, 10);
      });

      test('isMet when all requirements satisfied', () {
        final req = EvolutionRequirements.forStage(3);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 3000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 15,
              levelStars: {1: 3, 2: 3, 3: 3},
            ),
            'dragon_runes': GameStats(
              currentLevel: 16,
              levelStars: {1: 3, 2: 3, 3: 3, 4: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 20,
              levelStars: {1: 3, 2: 3, 3: 3},
            ),
          },
        );
        achievementTracker.setUnlockedCount(15);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), true);
      });

      test('not met when three-star count is insufficient', () {
        final req = EvolutionRequirements.forStage(3);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 3000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 15,
              levelStars: {1: 3, 2: 2, 3: 1},
            ),
            'dragon_runes': GameStats(
              currentLevel: 16,
              levelStars: {1: 3, 2: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 20,
              levelStars: {1: 3, 2: 3, 3: 3},
            ),
          },
        );
        achievementTracker.setUnlockedCount(15);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), false);
      });

      test('three-star count aggregates across all games', () {
        final req = EvolutionRequirements.forStage(3);
        final profile = PlayerProfile(
          id: 'test',
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 15,
              levelStars: {1: 3, 2: 3, 3: 2, 4: 1},
            ),
            'dragon_runes': GameStats(
              currentLevel: 16,
              levelStars: {1: 3, 2: 3, 3: 3, 4: 3, 5: 2},
            ),
          },
        );

        final items = req.progressItems(profile, factTracker);
        final threeStarItem = items.firstWhere(
          (item) => item.label.contains('3-star'),
        );
        expect(threeStarItem.current, 6); // 2 from fire_trail + 4 from dragon_runes
        expect(threeStarItem.target, 10);
      });

      test('progressItems includes three-star levels requirement', () {
        final req = EvolutionRequirements.forStage(3);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 1500,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 15,
              levelStars: {1: 3, 2: 3, 3: 3},
            ),
          },
        );

        final items = req.progressItems(profile, factTracker);
        final threeStarItem = items.firstWhere(
          (item) => item.label.contains('3-star'),
        );
        expect(threeStarItem.label, '3-star 10 levels');
        expect(threeStarItem.current, 3);
        expect(threeStarItem.target, 10);
        expect(threeStarItem.progress, 0.3);
      });
    });

    group('Stage 4 (Adult Dragon)', () {
      test('requires all 4 games at level 25', () {
        final req = EvolutionRequirements.forStage(4);
        expect(req.stage, 4);
        expect(req.minLevelInGames, 25);
        expect(req.gamesRequired, 4);
        expect(req.totalScales, 10000);
        expect(req.achievements, 30);
        expect(req.threeStarLevels, 30);
        expect(req.dailyChallenges, 10);
      });

      test('isMet when all 4 games at level 25+', () {
        final req = EvolutionRequirements.forStage(4);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 10000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 25,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragon_runes': GameStats(
              currentLevel: 26,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 30,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragons_feast': GameStats(
              currentLevel: 25,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
          },
        );
        achievementTracker.setUnlockedCount(30);
        storage.setDailyChallengesCompleted(10);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), true);
      });

      test('not met when only 3 games at level 25', () {
        final req = EvolutionRequirements.forStage(4);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 10000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 25,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragon_runes': GameStats(
              currentLevel: 26,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 30,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
            'dragons_feast': GameStats(
              currentLevel: 24,
              levelStars: {for (int i = 1; i <= 10; i++) i: 3},
            ),
          },
        );
        achievementTracker.setUnlockedCount(30);
        storage.setDailyChallengesCompleted(10);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), false);
      });

      test('progressItems includes daily challenges placeholder', () {
        final req = EvolutionRequirements.forStage(4);
        final profile = PlayerProfile(id: 'test');

        final items = req.progressItems(profile, factTracker);
        final dailyItem = items.firstWhere(
          (item) => item.label.contains('daily challenges'),
        );
        expect(dailyItem.current, 0);
        expect(dailyItem.target, 10);
        expect(dailyItem.isMet, false);
      });
    });

    group('Stage 5 (Elder Dragon)', () {
      test('requires 100 mastered facts', () {
        final req = EvolutionRequirements.forStage(5);
        expect(req.stage, 5);
        expect(req.minLevelInGames, 35);
        expect(req.gamesRequired, 4);
        expect(req.totalScales, 25000);
        expect(req.achievements, 50);
        expect(req.threeStarLevels, 60);
        expect(req.dailyChallenges, 30);
        expect(req.masteredFacts, 100);
      });

      test('isMet when all requirements including mastered facts satisfied', () {
        final req = EvolutionRequirements.forStage(5);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 25000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 35,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragon_runes': GameStats(
              currentLevel: 36,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 40,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragons_feast': GameStats(
              currentLevel: 35,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
          },
        );

        factTracker.setMasteredFactCount(100);
        achievementTracker.setUnlockedCount(50);
        storage.setDailyChallengesCompleted(30);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), true);
      });

      test('not met when mastered facts insufficient', () {
        final req = EvolutionRequirements.forStage(5);
        final profile = PlayerProfile(
          id: 'test',
          totalScales: 25000,
          gameStats: {
            'fire_trail': GameStats(
              currentLevel: 35,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragon_runes': GameStats(
              currentLevel: 36,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragon_eggs': GameStats(
              currentLevel: 40,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
            'dragons_feast': GameStats(
              currentLevel: 35,
              levelStars: {for (int i = 1; i <= 20; i++) i: 3},
            ),
          },
        );

        factTracker.setMasteredFactCount(99);
        achievementTracker.setUnlockedCount(50);
        storage.setDailyChallengesCompleted(30);

        expect(req.isMet(profile, factTracker,
            achievementTracker: achievementTracker, storage: storage), false);
      });

      test('progressItems includes mastered facts requirement', () {
        final req = EvolutionRequirements.forStage(5);
        final profile = PlayerProfile(id: 'test');
        factTracker.setMasteredFactCount(50);

        final items = req.progressItems(profile, factTracker);
        final factsItem = items.firstWhere(
          (item) => item.label.contains('Master 100 facts'),
        );
        expect(factsItem.current, 50);
        expect(factsItem.target, 100);
        expect(factsItem.progress, 0.5);
        expect(factsItem.isMet, false);
      });
    });

    group('Stage progression', () {
      test('cannot skip stages', () {
        // This is tested implicitly by how ProgressionManager.checkEvolution works
        // It only checks the next stage (currentStage + 1)
        expect(EvolutionRequirements.forStage(1).stage, 1);
        expect(EvolutionRequirements.forStage(2).stage, 2);
        expect(EvolutionRequirements.forStage(3).stage, 3);
        expect(EvolutionRequirements.forStage(4).stage, 4);
        expect(EvolutionRequirements.forStage(5).stage, 5);
      });

      test('invalid stage returns default requirements', () {
        final req = EvolutionRequirements.forStage(0);
        expect(req.stage, 0);
        expect(req.minLevelInGames, 0);
        expect(req.gamesRequired, 0);

        final reqHigh = EvolutionRequirements.forStage(99);
        expect(reqHigh.stage, 0);
      });
    });
  });

  group('EvolutionProgress', () {
    test('overallProgress is average of all requirements', () {
      final requirements = [
        const EvolutionProgressItem(
          label: 'Test 1',
          current: 50,
          target: 100,
          isMet: false,
        ),
        const EvolutionProgressItem(
          label: 'Test 2',
          current: 75,
          target: 100,
          isMet: false,
        ),
        const EvolutionProgressItem(
          label: 'Test 3',
          current: 100,
          target: 100,
          isMet: true,
        ),
      ];

      final progress = EvolutionProgress(
        currentStage: 1,
        nextStage: 2,
        requirements: requirements,
      );

      // Average: (0.5 + 0.75 + 1.0) / 3 = 0.75
      expect(progress.overallProgress, closeTo(0.75, 0.01));
    });

    test('overallProgress is 1.0 when no requirements', () {
      final progress = const EvolutionProgress(
        currentStage: 5,
        nextStage: null,
        requirements: [],
      );

      expect(progress.overallProgress, 1.0);
    });
  });

  group('EvolutionProgressItem', () {
    test('progress is correctly calculated', () {
      const item = EvolutionProgressItem(
        label: 'Test',
        current: 50,
        target: 200,
        isMet: false,
      );

      expect(item.progress, 0.25);
    });

    test('progress is clamped at 1.0 when current exceeds target', () {
      const item = EvolutionProgressItem(
        label: 'Test',
        current: 150,
        target: 100,
        isMet: true,
      );

      expect(item.progress, 1.0);
    });

    test('progress is 1.0 when target is 0', () {
      const item = EvolutionProgressItem(
        label: 'Test',
        current: 0,
        target: 0,
        isMet: true,
      );

      expect(item.progress, 1.0);
    });
  });

  group('ProgressionManager', () {
    late MockLocalStorage storage;
    late MockFactTracker factTracker;
    late EventBus eventBus;
    late ProgressionManager manager;

    setUp(() {
      storage = MockLocalStorage();
      eventBus = EventBus();
      factTracker = MockFactTracker(eventBus: eventBus, storage: storage);
      manager = ProgressionManager(
        eventBus: eventBus,
        storage: storage,
        factTracker: factTracker,
      );
    });

    tearDown(() {
      manager.dispose();
      factTracker.dispose();
      eventBus.dispose();
    });

    test('initializes with profile dragon evolution stage', () {
      storage.setProfile(PlayerProfile(id: 'test', dragonEvolution: 2));
      final newManager = ProgressionManager(
        eventBus: eventBus,
        storage: storage,
        factTracker: factTracker,
      );

      expect(newManager.evolutionStage.value, 2);
      newManager.dispose();
    });

    test('checkEvolution updates profile when requirements met', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 100,
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 5),
        },
      ));

      manager.checkEvolution();

      expect(storage.getProfile().dragonEvolution, 1);
      expect(manager.evolutionStage.value, 1);
    });

    test('checkEvolution does NOT update when requirements not met', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 50, // Not enough scales
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 5),
        },
      ));

      manager.checkEvolution();

      expect(storage.getProfile().dragonEvolution, 0);
      expect(manager.evolutionStage.value, 0);
    });

    test('checkEvolution respects stage progression order', () {
      // Set up profile that qualifies for stage 3 but is currently at stage 0
      // Should only evolve to stage 1
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 5000,
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 20),
          'dragon_runes': const GameStats(currentLevel: 20),
          'dragon_eggs': const GameStats(currentLevel: 20),
          'dragons_feast': const GameStats(currentLevel: 20),
        },
      ));

      manager.checkEvolution();

      // Should only evolve to next stage (1), not skip to 3
      expect(storage.getProfile().dragonEvolution, 1);
      expect(manager.evolutionStage.value, 1);
    });

    test('checkEvolution does nothing when at max stage', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 5,
        totalScales: 100000,
      ));

      manager.checkEvolution();

      expect(storage.getProfile().dragonEvolution, 5);
      expect(manager.evolutionStage.value, 5);
    });

    test('checkEvolution is called on LevelCompleted event', () async {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 100,
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 5),
        },
      ));

      eventBus.emit(LevelCompleted(
        gameId: 'fire_trail',
        levelNumber: 5,
        stars: 3,
        score: 1000,
        accuracy: 1.0,
      ));

      // Give time for async event processing
      await Future.delayed(const Duration(milliseconds: 10));

      expect(storage.getProfile().dragonEvolution, 1);
    });

    test('checkEvolution is called on GameEnded event', () async {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 100,
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 5),
        },
      ));

      eventBus.emit(GameEnded(
        gameId: 'fire_trail',
        finalScore: 1000,
        duration: const Duration(minutes: 5),
      ));

      // Give time for async event processing
      await Future.delayed(const Duration(milliseconds: 10));

      expect(storage.getProfile().dragonEvolution, 1);
    });

    test('getEvolutionProgress returns correct progress for next stage', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 0,
        totalScales: 50,
        gameStats: {
          'fire_trail': const GameStats(currentLevel: 2),
        },
      ));

      final progress = manager.getEvolutionProgress();

      expect(progress.currentStage, 0);
      expect(progress.nextStage, 1);
      expect(progress.requirements, hasLength(2));
      expect(progress.requirements[0].label, contains('level 5'));
      expect(progress.requirements[1].label, contains('100 scales'));
    });

    test('getEvolutionProgress returns empty requirements at max stage', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        dragonEvolution: 5,
      ));

      final progress = manager.getEvolutionProgress();

      expect(progress.currentStage, 5);
      expect(progress.nextStage, null);
      expect(progress.requirements, isEmpty);
      expect(progress.overallProgress, 1.0);
    });

    test('suggestGame returns least-played game that is not current', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        gameStats: {
          'fire_trail': const GameStats(timesPlayed: 10),
          'dragon_runes': const GameStats(timesPlayed: 5),
          'dragon_eggs': const GameStats(timesPlayed: 2),
          'dragons_feast': const GameStats(timesPlayed: 7),
        },
      ));

      final suggestion = manager.suggestGame('fire_trail');

      expect(suggestion, 'dragon_eggs'); // Least played (2 times)
    });

    test('suggestGame excludes current game', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        gameStats: {
          'fire_trail': const GameStats(timesPlayed: 1),
          'dragon_runes': const GameStats(timesPlayed: 5),
          'dragon_eggs': const GameStats(timesPlayed: 10),
          'dragons_feast': const GameStats(timesPlayed: 8),
        },
      ));

      final suggestion = manager.suggestGame('fire_trail');

      // fire_trail has least plays (1) but is current, so should suggest dragon_runes (5)
      expect(suggestion, 'dragon_runes');
    });

    test('suggestGame returns game with 0 plays when available', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        gameStats: {
          'fire_trail': const GameStats(timesPlayed: 10),
          'dragon_runes': const GameStats(timesPlayed: 5),
          // dragon_eggs and dragons_feast have no entries (0 plays)
        },
      ));

      final suggestion = manager.suggestGame('fire_trail');

      // Should return one of the games with 0 plays
      expect(
        ['dragon_eggs', 'dragons_feast'],
        contains(suggestion),
      );
    });

    test('suggestGame returns a game when all have equal plays', () {
      storage.setProfile(PlayerProfile(
        id: 'test',
        gameStats: {
          'fire_trail': const GameStats(timesPlayed: 5),
          'dragon_runes': const GameStats(timesPlayed: 5),
          'dragon_eggs': const GameStats(timesPlayed: 5),
          'dragons_feast': const GameStats(timesPlayed: 5),
        },
      ));

      final suggestion = manager.suggestGame('fire_trail');

      // Should return one of the other games
      expect(suggestion, isNotNull);
      expect(suggestion, isNot('fire_trail'));
      expect(
        ['dragon_runes', 'dragon_eggs', 'dragons_feast'],
        contains(suggestion),
      );
    });
  });
}
