import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/daily_challenge.dart';
import 'package:math_dragons/core/daily_challenge_manager.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/core/reward_service.dart';
import 'package:math_dragons/storage/local_storage.dart';

// Mock LocalStorage for testing.
class MockLocalStorage extends LocalStorage {
  PlayerProfile _profile = PlayerProfile(id: 'test-id');
  final Map<String, DailyChallengeState> _dailyChallenges = {};

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

  @override
  Set<String> getUnlockedAchievementIds() => {};

  @override
  Future<void> saveDailyChallengeState(DailyChallengeState state) async {
    _dailyChallenges[state.dateKey] = state;
  }

  @override
  DailyChallengeState? getDailyChallengeState(String dateKey) =>
      _dailyChallenges[dateKey];

  @override
  int getTotalDailyChallengesCompleted() =>
      _dailyChallenges.values.where((s) => s.allComplete).length;

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

void main() {
  group('DailyChallengeManager', () {
    late MockLocalStorage storage;
    late EventBus eventBus;
    late RewardService rewardService;

    setUp(() {
      storage = MockLocalStorage();
      eventBus = EventBus();
      rewardService = RewardService(eventBus: eventBus, storage: storage);
    });

    tearDown(() {
      rewardService.dispose();
      eventBus.dispose();
    });

    test('same date always generates same tasks (deterministic)', () {
      final manager1 = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      final tasks1 = manager1.today.tasks;

      // Create a second manager for the same date
      final eventBus2 = EventBus();
      final storage2 = MockLocalStorage();
      final rewardService2 =
          RewardService(eventBus: eventBus2, storage: storage2);
      final manager2 = DailyChallengeManager(
        eventBus: eventBus2,
        storage: storage2,
        rewardService: rewardService2,
      );

      final tasks2 = manager2.today.tasks;

      // Same date => same number of tasks
      expect(tasks1.length, tasks2.length);

      // Same task types in same order
      for (int i = 0; i < tasks1.length; i++) {
        expect(tasks1[i].type, tasks2[i].type);
        expect(tasks1[i].targetValue, tasks2[i].targetValue);
        expect(tasks1[i].description, tasks2[i].description);
      }

      manager1.dispose();
      manager2.dispose();
      rewardService2.dispose();
      eventBus2.dispose();
    });

    test('generated challenge has 2 or 3 tasks', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      final challenge = manager.today;
      expect(challenge.tasks.length, inInclusiveRange(2, 3));

      manager.dispose();
    });

    test('no duplicate ChallengeTypes in a single day tasks', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      final challenge = manager.today;
      final types = challenge.tasks.map((t) => t.type).toSet();
      expect(types.length, challenge.tasks.length,
          reason: 'All task types should be unique within a single day');

      manager.dispose();
    });

    test('ChallengeTask fields are properly populated', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      final challenge = manager.today;
      for (final task in challenge.tasks) {
        expect(task.id, isNotEmpty);
        expect(task.description, isNotEmpty);
        expect(task.gameId, isNotEmpty);
        expect(task.targetValue, greaterThan(0));
        expect(ChallengeType.values, contains(task.type));
      }

      manager.dispose();
    });

    test('each task has a non-empty description', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      for (final task in manager.today.tasks) {
        expect(task.description, isNotEmpty);
        expect(task.description.length, greaterThan(5),
            reason: 'Description should be a meaningful sentence');
      }

      manager.dispose();
    });

    test('tasks start with isComplete = false', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      for (final task in manager.today.tasks) {
        expect(task.isComplete, isFalse);
      }

      manager.dispose();
    });

    test('today challenge has default baseReward of 25', () {
      final manager = DailyChallengeManager(
        eventBus: eventBus,
        storage: storage,
        rewardService: rewardService,
      );

      expect(manager.today.baseReward, 25);

      manager.dispose();
    });
  });
}
