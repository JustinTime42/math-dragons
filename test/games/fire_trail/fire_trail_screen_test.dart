// FTT-1 and FTT-5 (docs/specs/adaptive-practice.md section 9.3): pump the real
// FireTrailScreen inside the app's providers (lib/app.dart) with fakes.
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/audio_service.dart';
import 'package:math_dragons/core/difficulty_engine.dart';
import 'package:math_dragons/core/event_bus.dart';
import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/game_events.dart';
import 'package:math_dragons/core/session_manager.dart';
import 'package:math_dragons/games/fire_trail/fire_trail_flame_game.dart';
import 'package:math_dragons/games/fire_trail/fire_trail_game.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import 'package:math_dragons/storage/local_storage.dart';
import 'package:provider/provider.dart';

import '../../support/fake_storage.dart';

class _SilentAudio extends AudioService {
  _SilentAudio({required super.storage});

  @override
  Future<void> playGameMusic(String gameId) async {}

  @override
  Future<void> stopMusic() async {}
}

void main() {
  late FakeStorage storage;
  late EventBus bus;
  late FactTracker tracker;
  late DifficultyEngine engine;
  late List<AnswerGiven> events;
  late StreamSubscription<AnswerGiven> eventsSub;

  setUp(() {
    storage = FakeStorage();
    bus = EventBus();
    tracker = FactTracker(eventBus: bus, storage: storage);
    engine = DifficultyEngine(factTracker: tracker);
    // Subscribed outside the widget test's fake-async zone (like the app's
    // services); a subscription made inside it hangs widget teardown.
    events = [];
    eventsSub = bus.on<AnswerGiven>().listen(events.add);
  });

  tearDown(() async {
    await eventsSub.cancel();
    tracker.dispose();
    bus.dispose();
  });

  Widget app() => MultiProvider(
    providers: [
      Provider<LocalStorage>.value(value: storage),
      Provider<EventBus>.value(value: bus),
      Provider<FactTracker>.value(value: tracker),
      Provider<SessionManager>.value(value: SessionManager(storage: storage)),
      Provider<AudioService>.value(value: _SilentAudio(storage: storage)),
      Provider<DifficultyEngine>.value(value: engine),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      home: FireTrailScreen(),
    ),
  );

  Future<FireTrailFlameGame> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(app());
    final game = tester
        .widget<GameWidget<FireTrailFlameGame>>(
          find.byType(GameWidget<FireTrailFlameGame>),
        )
        .game!;
    for (int i = 0; i < 20 && !game.isLoaded; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(game.isLoaded, isTrue);
    return game;
  }

  /// Response times come from DateTime.now(), which fake async does not
  /// control, so let a little real time pass between prompt and answer.
  void letWallClockPass() {
    final until = DateTime.now().add(const Duration(milliseconds: 10));
    while (DateTime.now().isBefore(until)) {}
  }

  /// The bus is an async broadcast stream and [events] listens from the real
  /// zone, so flush real microtasks after a frame.
  Future<void> deliverEvents(WidgetTester tester) async {
    await tester.pump();
    await tester.runAsync(() => pumpEventQueue());
  }

  /// Unmount and drain the countdown and feedback timers.
  Future<void> tearDownScreen(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('FTT-1 the real screen passes the difficulty engine', (
    tester,
  ) async {
    final game = await pumpScreen(tester);

    expect(game.difficultyEngine, isNotNull);
    expect(game.difficultyEngine, same(engine));
    expect(game.problems.difficultyEngine, same(engine));

    await tearDownScreen(tester);
  });

  testWidgets('FTT-5 wrong gem then correct gem on one prompt sets attempt '
      'flags and real response times', (tester) async {
    final game = await pumpScreen(tester);

    final active = game.problems.currentProblem!;
    final correctGem = game.gemData.firstWhere(
      (g) => identical(g.problem, active),
    );
    final wrongGem = game.gemData.firstWhere(
      (g) => !identical(g.problem, active),
    );

    letWallClockPass();
    game.handleGemEaten(wrongGem);
    letWallClockPass();
    game.handleGemEaten(correctGem);
    await deliverEvents(tester);

    expect(events, hasLength(2));
    final (miss, retry) = (events[0], events[1]);

    expect(miss.correct, isFalse);
    expect(miss.firstAttempt, isTrue);
    expect(miss.responseTimeMs, greaterThan(0));
    expect(miss.factKey, active.factKey);

    expect(retry.correct, isTrue);
    expect(retry.firstAttempt, isFalse);
    expect(retry.responseTimeMs, greaterThan(0));
    expect(retry.factKey, active.factKey);

    // The next prompt starts fresh: its first answer is a first attempt.
    final next = game.problems.currentProblem!;
    expect(identical(next, active), isFalse);
    final nextGem = game.gemData.firstWhere((g) => identical(g.problem, next));
    letWallClockPass();
    game.handleGemEaten(nextGem);
    await deliverEvents(tester);

    expect(events, hasLength(3));
    expect(events[2].correct, isTrue);
    expect(events[2].firstAttempt, isTrue);
    expect(events[2].factKey, next.factKey);

    await tearDownScreen(tester);
  });
}
