import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/achievement.dart';
import 'package:math_dragons/core/achievement_tracker.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/core/reward_service.dart';
import 'package:math_dragons/storage/local_storage.dart';

// Mock LocalStorage for testing (extends LocalStorage, overrides methods).
class MockLocalStorage extends LocalStorage {
  PlayerProfile _profile = PlayerProfile(id: 'test-id');
  final Set<String> _unlockedAchievementIds = {};
  final List<UnlockedAchievement> _unlockedAchievements = [];

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
  Future<void> saveUnlockedAchievement(UnlockedAchievement achievement) async {
    _unlockedAchievementIds.add(achievement.achievementId);
    _unlockedAchievements.add(achievement);
  }

  @override
  int getTotalDailyChallengesCompleted() => 0;

  @override
  List<FactRecord> getFactsByStatus(FactStatus status) => [];

  @override
  List<FactRecord> getAllFacts() => [];

  @override
  FactRecord? getFact(String factKey) => null;

  @override
  Map<FactStatus, int> getFactStatusCounts() => {
        for (final s in FactStatus.values) s: 0,
      };
}

// Mock FactTracker for testing.
class MockFactTracker extends FactTracker {
  int _masteredCount = 0;

  MockFactTracker({required super.eventBus, required super.storage});

  @override
  int get masteredFactCount => _masteredCount;

  void setMasteredFactCount(int count) {
    _masteredCount = count;
  }
}

void main() {
  group('AchievementTracker', () {
    late MockLocalStorage storage;
    late EventBus eventBus;
    late MockFactTracker factTracker;
    late RewardService rewardService;
    late AchievementTracker tracker;

    setUp(() {
      storage = MockLocalStorage();
      eventBus = EventBus();
      factTracker = MockFactTracker(eventBus: eventBus, storage: storage);
      rewardService = RewardService(eventBus: eventBus, storage: storage);
      tracker = AchievementTracker(
        eventBus: eventBus,
        storage: storage,
        factTracker: factTracker,
        rewardService: rewardService,
      );
    });

    tearDown(() {
      tracker.dispose();
      rewardService.dispose();
      factTracker.dispose();
      eventBus.dispose();
    });

    test('unlockedCount returns 0 initially', () {
      expect(tracker.unlockedCount, 0);
    });

    test('isUnlocked returns false for locked achievements', () {
      expect(tracker.isUnlocked('runes_first'), isFalse);
      expect(tracker.isUnlocked('mile_century'), isFalse);
      expect(tracker.isUnlocked('cross_explorer'), isFalse);
    });

    test('after saving an UnlockedAchievement to storage, isUnlocked returns true', () async {
      await storage.saveUnlockedAchievement(UnlockedAchievement(
        achievementId: 'runes_first',
        unlockedAt: DateTime.now(),
        scalesAwarded: 25,
      ));

      expect(tracker.isUnlocked('runes_first'), isTrue);
    });

    test('unlockedCount returns correct count from storage', () async {
      await storage.saveUnlockedAchievement(UnlockedAchievement(
        achievementId: 'runes_first',
        unlockedAt: DateTime.now(),
        scalesAwarded: 25,
      ));
      await storage.saveUnlockedAchievement(UnlockedAchievement(
        achievementId: 'mile_century',
        unlockedAt: DateTime.now(),
        scalesAwarded: 50,
      ));

      expect(tracker.unlockedCount, 2);
    });

    test('isUnlocked returns false for non-existent achievement IDs', () {
      expect(tracker.isUnlocked('nonexistent_id'), isFalse);
    });

    test('multiple saves of the same achievement do not double count', () async {
      await storage.saveUnlockedAchievement(UnlockedAchievement(
        achievementId: 'runes_first',
        unlockedAt: DateTime.now(),
        scalesAwarded: 25,
      ));
      await storage.saveUnlockedAchievement(UnlockedAchievement(
        achievementId: 'runes_first',
        unlockedAt: DateTime.now(),
        scalesAwarded: 25,
      ));

      // Set stores unique IDs, so count should still be 1
      expect(tracker.unlockedCount, 1);
    });
  });
}
