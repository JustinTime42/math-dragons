import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../shared/game_shell.dart';
import '../shared/result_screen.dart';
import 'fire_trail_flame_game.dart';
import 'models/fire_trail_config.dart';
import 'models/grid_position.dart';
import 'widgets/countdown_overlay.dart';
import 'widgets/dpad_controls.dart';
import 'widgets/flame_meter.dart';
import 'widgets/problem_display.dart';
import 'widgets/score_streak_display.dart';

/// The main Fire Trail screen. Wraps the Flame game with Flutter overlays.
class FireTrailScreen extends StatefulWidget {
  final int startingLevel;
  const FireTrailScreen({super.key, this.startingLevel = 1});

  @override
  State<FireTrailScreen> createState() => _FireTrailScreenState();
}

class _FireTrailScreenState extends State<FireTrailScreen> {
  late FireTrailFlameGame _flameGame;
  late FireTrailConfig _config;
  final FocusNode _focusNode = FocusNode();

  // UI state
  String _problemText = '';
  int _score = 0;
  int _streak = 0;
  int _correctCount = 0;
  double _flamePercent = 1.0;
  bool _showCountdown = true;
  bool _gameOverShown = false;
  bool _showWrongFlash = false;
  int _currentWorld = 1;
  int _currentLevelInWorld = 1;

  @override
  void initState() {
    super.initState();
    // Convert starting level number to world + level in world
    // Fire Trail: 8 levels per world
    _currentWorld = ((widget.startingLevel - 1) ~/ 8) + 1;
    _currentLevelInWorld = ((widget.startingLevel - 1) % 8) + 1;
    _config = FireTrailConfig.forLevel(_currentWorld, _currentLevelInWorld);
    _createGame();
  }

  void _createGame() {
    _flameGame = FireTrailFlameGame(
      config: _config,
      onAnswerEaten: _onAnswerEaten,
      onGameOver: _onGameOver,
      onFlameChanged: _onFlameChanged,
      onScoreChanged: _onScoreChanged,
      onProblemChanged: _onProblemChanged,
      onWrongFlash: _onWrongFlash,
      onLevelComplete: _onLevelComplete,
    );
  }

  void _onAnswerEaten(bool isCorrect, int score, int streak) {
    // Emit AnswerGiven event
    final eventBus = context.read<EventBus>();
    final problem = _flameGame.problems.currentProblem;
    if (problem != null) {
      eventBus.emit(AnswerGiven(
        gameId: 'fire_trail',
        problem: problem.factKey,
        playerAnswer: isCorrect ? '${problem.answer}' : 'wrong',
        correctAnswer: '${problem.answer}',
        correct: isCorrect,
        responseTimeMs: 0,
      ));
    }

    // Check streak milestones
    if (isCorrect && streak > 0 && streak % 5 == 0) {
      eventBus.emit(StreakAchieved(
        gameId: 'fire_trail',
        streakLength: streak,
      ));
    }

    setState(() {
      _score = score;
      _streak = streak;
      _correctCount = _flameGame.correctCount;
    });
  }

  void _onGameOver(String reason) {
    if (_gameOverShown) return;
    _gameOverShown = true;

    final eventBus = context.read<EventBus>();
    eventBus.emit(GameEnded(
      gameId: 'fire_trail',
      finalScore: _flameGame.score,
      duration: _flameGame.gameDuration,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _showResults(isLevelComplete: false);
    });
  }

  void _onLevelComplete() {
    final eventBus = context.read<EventBus>();
    final stars = _flameGame.calculateStars();
    final accuracy = _flameGame.totalAttempts > 0
        ? _flameGame.correctCount / _flameGame.totalAttempts
        : 0.0;
    final levelNumber = (_currentWorld - 1) * 8 + _currentLevelInWorld;

    eventBus.emit(LevelCompleted(
      gameId: 'fire_trail',
      levelNumber: levelNumber,
      score: _flameGame.score,
      stars: stars,
      accuracy: accuracy,
    ));

    eventBus.emit(GameEnded(
      gameId: 'fire_trail',
      finalScore: _flameGame.score,
      duration: _flameGame.gameDuration,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _showResults(isLevelComplete: true);
    });
  }

  void _onFlameChanged(double percent) {
    setState(() => _flamePercent = percent);
  }

  void _onScoreChanged(int score) {
    setState(() => _score = score);
  }

  void _onProblemChanged(String text) {
    setState(() => _problemText = text);
  }

  void _onWrongFlash() {
    setState(() => _showWrongFlash = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showWrongFlash = false);
    });
  }

  void _showResults({required bool isLevelComplete}) {
    final stars = _flameGame.calculateStars();
    final accuracy = _flameGame.totalAttempts > 0
        ? _flameGame.correctCount / _flameGame.totalAttempts
        : 0.0;
    final levelNumber = (_currentWorld - 1) * 8 + _currentLevelInWorld;

    final results = GameResults(
      gameId: 'fire_trail',
      score: _flameGame.score,
      accuracy: accuracy,
      streak: _flameGame.bestStreak,
      scalesEarned: _flameGame.scalesEarned,
      stars: stars,
      levelNumber: levelNumber,
      problemsAttempted: _flameGame.totalAttempts,
      problemsCorrect: _flameGame.correctCount,
    );

    final currentLevel = (_currentWorld - 1) * 8 + _currentLevelInWorld;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ResultScreen(
        results: results,
        accentColor: DragonColors.fireTrailAccent,
        onNextLevel: isLevelComplete && currentLevel < 40
            ? () {
                Navigator.pop(context); // dismiss sheet
                _nextLevel();
              }
            : null,
        onPlayAgain: () {
          Navigator.pop(context); // dismiss sheet
          _restartGame();
        },
        onBackToHub: () {
          final navigator = Navigator.of(context);
          navigator.pop(); // dismiss sheet
          navigator.popUntil((route) => route.isFirst); // back to hub
        },
        encouragement: _getEncouragement(stars, accuracy),
      ),
    );
  }

  String? _getEncouragement(int stars, double accuracy) {
    if (stars == 0 && accuracy >= 0.5) {
      return "Keep going! You're getting closer.";
    }
    if (stars == 2 && accuracy >= 0.85) {
      return 'So close to 3 stars! Just a bit more accuracy.';
    }
    return null;
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _streak = 0;
      _correctCount = 0;
      _flamePercent = 1.0;
      _showCountdown = true;
      _gameOverShown = false;
    });
    _flameGame.resetGame();
  }

  void _nextLevel() {
    final currentLevel = (_currentWorld - 1) * 8 + _currentLevelInWorld;
    if (currentLevel >= 40) return;

    final nextLevel = currentLevel + 1;
    _currentWorld = ((nextLevel - 1) ~/ 8) + 1;
    _currentLevelInWorld = ((nextLevel - 1) % 8) + 1;
    _config = FireTrailConfig.forLevel(_currentWorld, _currentLevelInWorld);

    setState(() {
      _score = 0;
      _streak = 0;
      _correctCount = 0;
      _flamePercent = 1.0;
      _showCountdown = true;
      _gameOverShown = false;
    });
    _createGame();
  }

  void _onPauseChanged(bool isPaused) {
    _flameGame.setPaused(isPaused);
  }

  void _onCountdownComplete() {
    setState(() => _showCountdown = false);
    _flameGame.startPlaying();
  }

  // Swipe detection state
  Offset? _swipeStart;

  void _onSwipeStart(Offset position) {
    _swipeStart = position;
  }

  void _onSwipeUpdate(Offset position) {
    if (_swipeStart == null) return;
    const threshold = 18.0;

    final dx = position.dx - _swipeStart!.dx;
    final dy = position.dy - _swipeStart!.dy;
    final adx = dx.abs();
    final ady = dy.abs();

    if (adx + ady > threshold) {
      _swipeStart = null;
      if (adx > ady) {
        _flameGame.setDirection(dx > 0 ? Direction.right : Direction.left);
      } else {
        _flameGame.setDirection(dy > 0 ? Direction.down : Direction.up);
      }
    }
  }

  void _onSwipeEnd() {
    _swipeStart = null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final direction = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowUp => Direction.up,
      LogicalKeyboardKey.arrowDown => Direction.down,
      LogicalKeyboardKey.arrowLeft => Direction.left,
      LogicalKeyboardKey.arrowRight => Direction.right,
      _ => null,
    };

    if (direction != null) {
      _flameGame.setDirection(direction);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: GameShell(
      gameId: 'fire_trail',
      title: l10n.fireTrail,
      accentColor: DragonColors.fireTrailAccent,
      backgroundImage: DragonAssets.gameBackgrounds['fire_trail'],
      onPauseChanged: _onPauseChanged,
      child: Column(
        children: [
          // Problem display
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: DragonSpacing.sm,
            ),
            child: ProblemDisplay(problemText: _problemText),
          ),

          // Game area with swipe detection
          Expanded(
            child: Stack(
              children: [
                // Flame game
                GestureDetector(
                  onPanStart: (d) => _onSwipeStart(d.localPosition),
                  onPanUpdate: (d) => _onSwipeUpdate(d.localPosition),
                  onPanEnd: (_) => _onSwipeEnd(),
                  child: GameWidget(game: _flameGame),
                ),

                // Wrong answer red flash
                if (_showWrongFlash)
                  IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _showWrongFlash ? 0.35 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(color: Colors.red),
                    ),
                  ),

                // Countdown overlay
                if (_showCountdown)
                  CountdownOverlay(onComplete: _onCountdownComplete),
              ],
            ),
          ),

          // Bottom HUD: flame meter + score/streak
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.base,
              vertical: DragonSpacing.xs,
            ),
            child: Row(
              children: [
                FlameMeter(intensity: _flamePercent),
                const SizedBox(width: DragonSpacing.base),
                Expanded(
                  child: ScoreStreakDisplay(
                    score: _score,
                    streak: _streak,
                    correctCount: _correctCount,
                    correctToAdvance: _config.correctToAdvance,
                  ),
                ),
              ],
            ),
          ),

          // D-pad controls
          Padding(
            padding: const EdgeInsets.only(bottom: DragonSpacing.sm),
            child: DPadControls(
              onDirection: (dir) => _flameGame.setDirection(dir),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
