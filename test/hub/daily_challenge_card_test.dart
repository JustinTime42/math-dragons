import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/daily_challenge.dart';

void main() {
  group('ChallengeTask', () {
    test('isComplete defaults to false', () {
      final task = ChallengeTask(
        id: 'task_0',
        description: 'Score 200+ in Fire Trail',
        gameId: 'fire_trail',
        type: ChallengeType.scoreInGame,
        targetValue: 200,
      );

      expect(task.isComplete, isFalse);
    });

    test('isComplete can be set to true', () {
      final task = ChallengeTask(
        id: 'task_0',
        description: 'Score 200+ in Fire Trail',
        gameId: 'fire_trail',
        type: ChallengeType.scoreInGame,
        targetValue: 200,
        isComplete: true,
      );

      expect(task.isComplete, isTrue);
    });

    test('task with isComplete=false reports correctly', () {
      final task = ChallengeTask(
        id: 'task_1',
        description: 'Complete 2 levels in Dragon Runes',
        gameId: 'dragon_runes',
        type: ChallengeType.completeLevels,
        targetValue: 2,
        isComplete: false,
      );

      expect(task.isComplete, isFalse);
      expect(task.id, 'task_1');
      expect(task.description, 'Complete 2 levels in Dragon Runes');
      expect(task.gameId, 'dragon_runes');
      expect(task.type, ChallengeType.completeLevels);
      expect(task.targetValue, 2);
    });

    test('task with isComplete=true reports correctly', () {
      final task = ChallengeTask(
        id: 'task_2',
        description: 'Get a 5-streak in any game',
        gameId: 'any',
        type: ChallengeType.getStreak,
        targetValue: 5,
        isComplete: true,
      );

      expect(task.isComplete, isTrue);
      expect(task.id, 'task_2');
      expect(task.description, 'Get a 5-streak in any game');
      expect(task.gameId, 'any');
      expect(task.type, ChallengeType.getStreak);
      expect(task.targetValue, 5);
    });
  });

  group('DailyChallenge', () {
    test('isComplete returns true when all tasks complete', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [
          ChallengeTask(
            id: 'task_0',
            description: 'Score 200+ in Fire Trail',
            gameId: 'fire_trail',
            type: ChallengeType.scoreInGame,
            targetValue: 200,
            isComplete: true,
          ),
          ChallengeTask(
            id: 'task_1',
            description: 'Complete 2 levels in Dragon Runes',
            gameId: 'dragon_runes',
            type: ChallengeType.completeLevels,
            targetValue: 2,
            isComplete: true,
          ),
        ],
      );

      expect(challenge.isComplete, isTrue);
    });

    test('isComplete returns false when any task incomplete', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [
          ChallengeTask(
            id: 'task_0',
            description: 'Score 200+ in Fire Trail',
            gameId: 'fire_trail',
            type: ChallengeType.scoreInGame,
            targetValue: 200,
            isComplete: true,
          ),
          ChallengeTask(
            id: 'task_1',
            description: 'Complete 2 levels in Dragon Runes',
            gameId: 'dragon_runes',
            type: ChallengeType.completeLevels,
            targetValue: 2,
            isComplete: false,
          ),
        ],
      );

      expect(challenge.isComplete, isFalse);
    });

    test('isComplete returns false when all tasks incomplete', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [
          ChallengeTask(
            id: 'task_0',
            description: 'Score 200+ in Fire Trail',
            gameId: 'fire_trail',
            type: ChallengeType.scoreInGame,
            targetValue: 200,
            isComplete: false,
          ),
          ChallengeTask(
            id: 'task_1',
            description: 'Answer 15 problems correctly',
            gameId: 'any',
            type: ChallengeType.correctAnswers,
            targetValue: 15,
            isComplete: false,
          ),
        ],
      );

      expect(challenge.isComplete, isFalse);
    });

    test('totalReward returns baseReward + streakBonus', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [],
        baseReward: 25,
        streakBonus: 15,
      );

      expect(challenge.totalReward, 40);
    });

    test('totalReward defaults to baseReward when no streakBonus', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [],
      );

      expect(challenge.baseReward, 25);
      expect(challenge.streakBonus, 0);
      expect(challenge.totalReward, 25);
    });

    test('totalReward with large streak bonus', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [],
        baseReward: 25,
        streakBonus: 25,
      );

      expect(challenge.totalReward, 50);
    });

    test('isComplete returns true for empty task list', () {
      final challenge = DailyChallenge(
        date: DateTime(2026, 2, 16),
        tasks: [],
      );

      // every() on an empty iterable returns true
      expect(challenge.isComplete, isTrue);
    });
  });
}
