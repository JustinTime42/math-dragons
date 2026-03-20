import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/game_events.dart';

void main() {
  late EventBus eventBus;

  setUp(() {
    eventBus = EventBus();
  });

  tearDown(() {
    eventBus.dispose();
  });

  group('EventBus', () {
    test('emit and receive a single event type', () async {
      final events = <AnswerGiven>[];
      eventBus.on<AnswerGiven>().listen(events.add);

      eventBus.emit(AnswerGiven(
        gameId: 'dragon_eggs',
        problem: '3+2',
        playerAnswer: '5',
        correctAnswer: '5',
        correct: true,
        responseTimeMs: 500,
      ));

      // Allow the event to propagate
      await Future.delayed(Duration.zero);

      expect(events, hasLength(1));
      expect(events.first.gameId, 'dragon_eggs');
      expect(events.first.correct, true);
    });

    test('typed subscription only receives matching events', () async {
      final answerEvents = <AnswerGiven>[];
      final startEvents = <GameStarted>[];

      eventBus.on<AnswerGiven>().listen(answerEvents.add);
      eventBus.on<GameStarted>().listen(startEvents.add);

      eventBus.emit(GameStarted(gameId: 'fire_trail', levelNumber: 1));
      eventBus.emit(AnswerGiven(
        gameId: 'fire_trail',
        problem: '7x8',
        playerAnswer: '56',
        correctAnswer: '56',
        correct: true,
        responseTimeMs: 300,
      ));

      await Future.delayed(Duration.zero);

      expect(answerEvents, hasLength(1));
      expect(startEvents, hasLength(1));
      expect(answerEvents.first.problem, '7x8');
      expect(startEvents.first.levelNumber, 1);
    });

    test('multiple listeners on same event type', () async {
      int listener1Count = 0;
      int listener2Count = 0;

      eventBus.on<AnswerGiven>().listen((_) => listener1Count++);
      eventBus.on<AnswerGiven>().listen((_) => listener2Count++);

      eventBus.emit(AnswerGiven(
        gameId: 'dragon_eggs',
        problem: '3+2',
        playerAnswer: '5',
        correctAnswer: '5',
        correct: true,
        responseTimeMs: 500,
      ));

      await Future.delayed(Duration.zero);

      expect(listener1Count, 1);
      expect(listener2Count, 1);
    });

    test('stream filter works correctly with mixed events', () async {
      final answerEvents = <AnswerGiven>[];
      final streakEvents = <StreakAchieved>[];
      final levelEvents = <LevelCompleted>[];

      eventBus.on<AnswerGiven>().listen(answerEvents.add);
      eventBus.on<StreakAchieved>().listen(streakEvents.add);
      eventBus.on<LevelCompleted>().listen(levelEvents.add);

      eventBus.emit(AnswerGiven(
        gameId: 'test',
        problem: '1+1',
        playerAnswer: '2',
        correctAnswer: '2',
        correct: true,
        responseTimeMs: 100,
      ));
      eventBus.emit(StreakAchieved(gameId: 'test', streakLength: 5));
      eventBus.emit(LevelCompleted(
        gameId: 'test',
        levelNumber: 1,
        score: 100,
        stars: 3,
        accuracy: 1.0,
      ));
      eventBus.emit(AnswerGiven(
        gameId: 'test',
        problem: '2+2',
        playerAnswer: '4',
        correctAnswer: '4',
        correct: true,
        responseTimeMs: 200,
      ));

      await Future.delayed(Duration.zero);

      expect(answerEvents, hasLength(2));
      expect(streakEvents, hasLength(1));
      expect(levelEvents, hasLength(1));
    });

    test('dispose prevents further emissions', () async {
      final events = <GameEvent>[];
      eventBus.stream.listen(events.add);

      eventBus.dispose();

      // Should not throw
      eventBus.emit(GameStarted(gameId: 'test', levelNumber: 1));

      await Future.delayed(Duration.zero);

      expect(events, isEmpty);
    });

    test('events have correct timestamps', () async {
      final before = DateTime.now();
      final events = <GameEvent>[];
      eventBus.stream.listen(events.add);

      eventBus.emit(GameStarted(gameId: 'test', levelNumber: 1));

      await Future.delayed(Duration.zero);
      final after = DateTime.now();

      expect(events.first.timestamp.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(events.first.timestamp.isBefore(after.add(const Duration(seconds: 1))), true);
    });
  });
}
