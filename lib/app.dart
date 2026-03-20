import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import 'theme/dragon_theme.dart';
import 'hub/hub_screen.dart';
import 'hub/settings_screen.dart';
import 'hub/achievement_screen.dart';
import 'monetization/store_screen.dart';
import 'hub/customize_screen.dart';
import 'storage/local_storage.dart';
import 'core/event_bus.dart';
import 'core/game_registry.dart';
import 'core/reward_service.dart';
import 'core/fact_tracker.dart';
import 'core/session_manager.dart';
import 'core/haptics.dart';
import 'core/audio_service.dart';
import 'core/difficulty_engine.dart';
import 'core/progression_manager.dart';
import 'core/achievement_tracker.dart';
import 'core/daily_challenge_manager.dart';
import 'widgets/achievement_popup.dart';
import 'widgets/evolution_celebration.dart';
import 'games/dragon_eggs/dragon_eggs_registration.dart';
import 'games/fire_trail/fire_trail_registration.dart';
import 'games/dragon_runes/dragon_runes_registration.dart';
import 'games/dragons_feast/dragons_feast_registration.dart';

class MathDragonsApp extends StatefulWidget {
  final LocalStorage storage;

  const MathDragonsApp({
    super.key,
    required this.storage,
  });

  @override
  State<MathDragonsApp> createState() => _MathDragonsAppState();
}

class _MathDragonsAppState extends State<MathDragonsApp>
    with WidgetsBindingObserver {
  late final EventBus _eventBus;
  late final GameRegistry _registry;
  late final RewardService _rewardService;
  late final FactTracker _factTracker;
  late final SessionManager _sessionManager;
  late final HapticsService _hapticsService;
  late final AudioService _audioService;
  late final AudioEventListener _audioEventListener;
  late final DifficultyEngine _difficultyEngine;
  late final ProgressionManager _progressionManager;
  late final AchievementTracker _achievementTracker;
  late final DailyChallengeManager _dailyChallengeManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _eventBus = EventBus();
    _registry = GameRegistry(widget.storage);
    _rewardService = RewardService(
      eventBus: _eventBus,
      storage: widget.storage,
    );
    _factTracker = FactTracker(
      eventBus: _eventBus,
      storage: widget.storage,
    );
    _sessionManager = SessionManager(storage: widget.storage);
    _hapticsService = HapticsService(storage: widget.storage);
    _audioService = AudioService(storage: widget.storage);
    _audioService.preloadSfx();
    _audioEventListener = AudioEventListener(
      audio: _audioService,
      eventBus: _eventBus,
    );
    _difficultyEngine = DifficultyEngine(factTracker: _factTracker);
    _achievementTracker = AchievementTracker(
      eventBus: _eventBus,
      storage: widget.storage,
      factTracker: _factTracker,
      rewardService: _rewardService,
    );
    _dailyChallengeManager = DailyChallengeManager(
      eventBus: _eventBus,
      storage: widget.storage,
      rewardService: _rewardService,
    );
    _progressionManager = ProgressionManager(
      eventBus: _eventBus,
      storage: widget.storage,
      factTracker: _factTracker,
      achievementTracker: _achievementTracker,
    );

    // Wire achievement popup callback
    _achievementTracker.onAchievementUnlocked = _onAchievementUnlocked;
    _progressionManager.onEvolution = _onEvolution;

    _registry.register(DragonEggsRegistration());
    _registry.register(FireTrailRegistration());
    _registry.register(DragonRunesRegistration());
    _registry.register(DragonsFeastRegistration());

    _sessionManager.startAppSession();
  }

  // Global key for the popup overlay
  final _popupKey = GlobalKey<AchievementPopupOverlayState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  void _onAchievementUnlocked(dynamic achievement) {
    _popupKey.currentState?.enqueue(achievement);
  }

  void _onEvolution(int oldStage, int newStage) {
    final context = _navigatorKey.currentContext;
    if (context != null) {
      showEvolutionCelebration(context,
          oldStage: oldStage, newStage: newStage);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _sessionManager.endAppSession();
      _audioService.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      _sessionManager.startAppSession();
      _audioService.resumeMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionManager.endAppSession();
    _audioEventListener.dispose();
    _audioService.dispose();
    _achievementTracker.dispose();
    _dailyChallengeManager.dispose();
    _progressionManager.dispose();
    _rewardService.dispose();
    _factTracker.dispose();
    _eventBus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorage>.value(value: widget.storage),
        Provider<EventBus>.value(value: _eventBus),
        Provider<GameRegistry>.value(value: _registry),
        Provider<RewardService>.value(value: _rewardService),
        Provider<FactTracker>.value(value: _factTracker),
        Provider<SessionManager>.value(value: _sessionManager),
        Provider<HapticsService>.value(value: _hapticsService),
        Provider<AudioService>.value(value: _audioService),
        Provider<DifficultyEngine>.value(value: _difficultyEngine),
        Provider<ProgressionManager>.value(value: _progressionManager),
        Provider<AchievementTracker>.value(value: _achievementTracker),
        Provider<DailyChallengeManager>.value(value: _dailyChallengeManager),
      ],
      child: _MobileFrame(
        child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Math Dragons',
        debugShowCheckedModeBanner: false,
        theme: DragonTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: AchievementPopupOverlay(
          key: _popupKey,
          child: const HubScreen(),
        ),
        routes: {
          '/settings': (context) => const SettingsScreen(),
          '/achievements': (context) => const AchievementScreen(),
          '/store': (context) => const StoreScreen(),
          '/customize': (context) => const CustomizeScreen(),
        },
      ),
      ),
    );
  }
}

class _MobileFrame extends StatelessWidget {
  final Widget child;
  const _MobileFrame({required this.child});

  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: child,
        ),
      ),
    );
  }
}
