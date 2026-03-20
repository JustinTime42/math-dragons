import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../storage/local_storage.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../shared/game_shell.dart';
import '../shared/result_screen.dart';
import 'dragon_eggs_flame_game.dart';
import 'models/equation.dart';
import 'systems/equation_builder.dart';
import 'widgets/equation_display.dart';
import 'widgets/score_display.dart';
import 'widgets/feedback_overlay.dart';

class DragonEggsScreen extends StatefulWidget {
  final int startingLevel;
  const DragonEggsScreen({super.key, this.startingLevel = 1});

  @override
  State<DragonEggsScreen> createState() => _DragonEggsScreenState();
}

class _DragonEggsScreenState extends State<DragonEggsScreen> {
  late int _currentLevel;
  late DragonEggsFlameGame _flameGame;

  String _equationText = '? _ ? = ?';
  EquationStep _equationStep = EquationStep.selectLeft;
  int _score = 0;
  int _combo = 0;
  int _streak = 0;
  int _solved = 0;
  int _required = 3;
  String? _feedbackText;
  bool _feedbackCorrect = false;
  bool _feedbackNewFact = false;
  int _feedbackCounter = 0;
  bool _gameOverShown = false;
  bool _levelComplete = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.startingLevel;
    _createFlameGame();
  }

  void _createFlameGame() {
    _flameGame = DragonEggsFlameGame(
      onEquationResult: _onEquationResult,
      onGameOver: _onGameOver,
      onScoreChanged: _onScoreChanged,
      onEquationChanged: _onEquationChanged,
      onLevelComplete: _onLevelComplete,
      onProgressChanged: _onProgressChanged,
      currentLevel: _currentLevel,
    );
  }

  void _onEquationResult(EquationResult result, int responseTimeMs) {
    final eventBus = context.read<EventBus>();
    eventBus.emit(AnswerGiven(
      gameId: 'dragon_eggs',
      problem: result.factKey,
      playerAnswer: '${result.playerAnswer}',
      correctAnswer: '${result.correctAnswer}',
      correct: result.isCorrect,
      responseTimeMs: responseTimeMs,
    ));

    if (result.isCorrect &&
        _flameGame.streak > 0 &&
        _flameGame.streak % 5 == 0) {
      eventBus.emit(StreakAchieved(
        gameId: 'dragon_eggs',
        streakLength: _flameGame.streak,
      ));
    }

    setState(() {
      if (result.isCorrect) {
        _feedbackText = '+${_flameGame.lastEarnedPoints}';
        _feedbackNewFact = _flameGame.lastWasNewFact;
      } else {
        _feedbackText = 'Nope!';
        _feedbackNewFact = false;
      }
      _feedbackCorrect = result.isCorrect;
      _feedbackCounter++;
    });
  }

  void _onLevelComplete() {
    final eventBus = context.read<EventBus>();
    final accuracy = _flameGame.totalAttempts > 0
        ? _flameGame.correctCount / _flameGame.totalAttempts
        : 0.0;
    final stars = _flameGame.calculateStars();

    eventBus.emit(LevelCompleted(
      gameId: 'dragon_eggs',
      levelNumber: _currentLevel,
      score: _flameGame.score,
      stars: stars,
      accuracy: accuracy,
    ));

    setState(() {
      _levelComplete = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showResults();
    });
  }

  void _onGameOver() {
    if (_gameOverShown) return;
    _gameOverShown = true;

    final eventBus = context.read<EventBus>();
    eventBus.emit(GameEnded(
      gameId: 'dragon_eggs',
      finalScore: _flameGame.score,
      duration: _flameGame.gameDuration,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _showResults(isGameOver: true);
    });
  }

  void _showResults({bool isGameOver = false}) {
    final accuracy = _flameGame.totalAttempts > 0
        ? _flameGame.correctCount / _flameGame.totalAttempts
        : 0.0;
    final stars = _flameGame.calculateStars();

    final results = GameResults(
      gameId: 'dragon_eggs',
      score: _flameGame.score,
      accuracy: accuracy,
      streak: _flameGame.bestStreak,
      scalesEarned: _flameGame.scalesEarned,
      stars: stars,
      levelNumber: _currentLevel,
      problemsAttempted: _flameGame.totalAttempts,
      problemsCorrect: _flameGame.correctCount,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ResultScreen(
        results: results,
        accentColor: DragonColors.dragonEggsAccent,
        onNextLevel: (!isGameOver && _currentLevel < 50)
            ? () {
                Navigator.pop(context);
                _nextLevel();
              }
            : null,
        onPlayAgain: () {
          Navigator.pop(context);
          _restartGame();
        },
        onBackToHub: () {
          final navigator = Navigator.of(context);
          navigator.pop();
          navigator.popUntil((route) => route.isFirst);
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

  void _nextLevel() {
    setState(() {
      _currentLevel++;
      if (_currentLevel > 50) _currentLevel = 50;
      _levelComplete = false;
      _gameOverShown = false;
      _equationText = '? _ ? = ?';
      _equationStep = EquationStep.selectLeft;
      _feedbackText = null;
      _feedbackNewFact = false;
      _feedbackCounter = 0;
    });
    _flameGame.advanceLevel();
  }

  void _restartGame() {
    setState(() {
      _equationText = '? _ ? = ?';
      _equationStep = EquationStep.selectLeft;
      _score = 0;
      _combo = 0;
      _streak = 0;
      _solved = 0;
      _feedbackText = null;
      _feedbackNewFact = false;
      _feedbackCounter = 0;
      _gameOverShown = false;
      _levelComplete = false;
    });
    _flameGame.resetGame();
  }

  void _onScoreChanged(int score, int combo, int streak) {
    setState(() {
      _score = score;
      _combo = combo;
      _streak = streak;
    });
  }

  void _onEquationChanged(String displayString, EquationStep step) {
    setState(() {
      _equationText = displayString;
      _equationStep = step;
    });
  }

  void _onProgressChanged(int solved, int required) {
    setState(() {
      _solved = solved;
      _required = required;
    });
  }

  void _onPauseChanged(bool isPaused) {
    _flameGame.setPaused(isPaused);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.read<LocalStorage>().getProfile();
    final backgroundImage =
        DragonAssets.resolveDragonEggsBackground(profile.equippedBackground);

    return GameShell(
      gameId: 'dragon_eggs',
      title: l10n.dragonEggs,
      accentColor: DragonColors.dragonEggsAccent,
      level: _currentLevel,
      backgroundImage: backgroundImage,
      onPauseChanged: _onPauseChanged,
      child: Stack(
        children: [
          GameWidget(game: _flameGame),

          EquationDisplay(
            equationText: _equationText,
            step: _equationStep,
            onEquals: () => _flameGame.pressEquals(),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                ScoreDisplay(
                  score: _score,
                  streak: _streak,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: DragonSpacing.sm,
                    top: DragonSpacing.sm,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DragonSpacing.sm,
                      vertical: DragonSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: DragonColors.deepVoid.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_solved / $_required',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: DragonColors.dragonGold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          FeedbackOverlay(
            text: _feedbackText,
            isCorrect: _feedbackCorrect,
            combo: _combo,
            isNewFact: _feedbackNewFact,
            feedbackKey: _feedbackCounter,
          ),

          if (_levelComplete)
            Container(
              color: DragonColors.deepVoid.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: DragonColors.dragonGold,
                      size: 64,
                    ),
                    const SizedBox(height: DragonSpacing.base),
                    Text(
                      'Level $_currentLevel Complete!',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontFamily: 'Cinzel',
                            color: DragonColors.dragonGold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
