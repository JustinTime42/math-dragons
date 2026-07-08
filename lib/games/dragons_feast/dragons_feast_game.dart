import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../storage/local_storage.dart';
import '../../theme/dragon_anchor_points.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../../core/difficulty_engine.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../shared/game_shell.dart';
import '../shared/result_screen.dart';
import '../fire_trail/models/grid_position.dart';
import 'dragons_feast_flame_game.dart';
import 'models/feast_config.dart';
import 'widgets/category_display.dart';
import 'widgets/category_transition.dart';
import 'widgets/feast_dpad_controls.dart';
import 'widgets/feast_score_display.dart';
import 'widgets/lives_display.dart';

/// The main Dragon's Feast game screen. Wraps Flame game with Flutter overlays.
class DragonsFeastScreen extends StatefulWidget {
  final int startingLevel;
  const DragonsFeastScreen({super.key, this.startingLevel = 1});

  @override
  State<DragonsFeastScreen> createState() => _DragonsFeastScreenState();
}

class _DragonsFeastScreenState extends State<DragonsFeastScreen> {
  late DragonsFeastFlameGame _flameGame;
  late DragonsFeastConfig _config;
  final FocusNode _focusNode = FocusNode();

  // UI state
  String _categoryName = '';
  int _score = 0;
  int _streak = 0;
  int _lives = 3;
  int _correctEaten = 0;
  int _requiredCorrect = 10;
  int _currentLevel = 1;
  bool _showCountdown = true;
  bool _showCategoryTransition = false;
  bool _gameOverShown = false;
  bool _showWrongFlash = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.startingLevel;
    _config = DragonsFeastConfig.configForLevel(_currentLevel);
    _categoryName = _config.category.displayName;
    _createGame();
  }

  void _createGame() {
    final engine = context.read<DifficultyEngine>();
    final profile = context.read<LocalStorage>().getProfile();

    final dragonImagePath = DragonAssets.resolveDragonImage(
      evolutionStage: profile.dragonEvolution,
      context: DragonRenderContext.portrait,
      skinId: profile.equippedColor,
    );

    _flameGame = DragonsFeastFlameGame(
      config: _config,
      category: _config.category,
      difficultyEngine: engine,
      dragonImagePath: dragonImagePath,
      onTileEaten: _onTileEaten,
      onGameOver: _onGameOver,
      onLevelComplete: _onLevelComplete,
      onLivesChanged: _onLivesChanged,
      onScoreChanged: _onScoreChanged,
      onProgressChanged: _onProgressChanged,
      onPowerUpCollected: _onPowerUpCollected,
      onWrongFlash: _onWrongFlash,
    );
    _flameGame.currentLevel = _currentLevel;
  }

  void _onTileEaten(bool isCorrect, int score, int streak) {
    final eventBus = context.read<EventBus>();
    final responseTimeMs = _flameGame.getResponseTimeMs();

    final factKey = '${_config.category.id}:${isCorrect ? "correct" : "wrong"}';
    eventBus.emit(
      AnswerGiven(
        gameId: 'dragons_feast',
        problem: factKey,
        playerAnswer: isCorrect ? 'correct' : 'wrong',
        correctAnswer: isCorrect ? 'correct' : 'should_skip',
        correct: isCorrect,
        responseTimeMs: responseTimeMs,
      ),
    );

    if (isCorrect && streak > 0 && streak % 5 == 0) {
      eventBus.emit(
        StreakAchieved(gameId: 'dragons_feast', streakLength: streak),
      );
    }

    setState(() {
      _score = score;
      _streak = streak;
    });
  }

  void _onGameOver() {
    if (_gameOverShown) return;
    _gameOverShown = true;

    final eventBus = context.read<EventBus>();
    eventBus.emit(
      GameEnded(
        gameId: 'dragons_feast',
        finalScore: _flameGame.score,
        duration: _flameGame.gameDuration,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _showResults();
    });
  }

  void _onLevelComplete() {
    final eventBus = context.read<EventBus>();
    final totalEats = _flameGame.correctEaten + _flameGame.wrongEaten;
    final accuracy = totalEats > 0 ? _flameGame.correctEaten / totalEats : 0.0;
    final stars = _flameGame.calculateStars();

    eventBus.emit(
      LevelCompleted(
        gameId: 'dragons_feast',
        levelNumber: _flameGame.currentLevel,
        score: _flameGame.score,
        stars: stars,
        accuracy: accuracy,
      ),
    );

    // Show category transition, then advance level
    setState(() {
      _showCategoryTransition = true;
    });
  }

  void _onCategoryTransitionComplete() {
    _flameGame.advanceLevel();
    setState(() {
      _showCategoryTransition = false;
      _currentLevel = _flameGame.currentLevel;
      _config = DragonsFeastConfig.configForLevel(_currentLevel);
      _categoryName = _config.category.displayName;
      _correctEaten = 0;
      _requiredCorrect = _config.correctTileCount;
    });
  }

  void _onLivesChanged(int lives) {
    setState(() => _lives = lives);
  }

  void _onScoreChanged(int score) {
    setState(() => _score = score);
  }

  void _onProgressChanged(int eaten, int needed) {
    setState(() {
      _correctEaten = eaten;
      _requiredCorrect = needed;
    });
  }

  void _onPowerUpCollected(String powerUp) {
    // Could show a brief notification
  }

  void _onWrongFlash() {
    setState(() => _showWrongFlash = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showWrongFlash = false);
    });
  }

  void _showResults() {
    final totalEats = _flameGame.correctEaten + _flameGame.wrongEaten;
    final accuracy = totalEats > 0 ? _flameGame.correctEaten / totalEats : 0.0;
    final stars = _flameGame.calculateStars();

    final results = GameResults(
      gameId: 'dragons_feast',
      score: _flameGame.score,
      accuracy: accuracy,
      streak: _flameGame.bestStreak,
      scalesEarned: _flameGame.scalesEarned,
      stars: stars,
      levelNumber: _flameGame.currentLevel,
      problemsAttempted: totalEats,
      problemsCorrect: _flameGame.correctEaten,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ResultScreen(
        results: results,
        accentColor: DragonColors.dragonsFeastAccent,
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
    if (_flameGame.levelsCleared > 0) {
      return 'You cleared ${_flameGame.levelsCleared} level${_flameGame.levelsCleared > 1 ? 's' : ''}!';
    }
    return null;
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _streak = 0;
      _lives = 3;
      _correctEaten = 0;
      _currentLevel = 1;
      _showCountdown = true;
      _gameOverShown = false;
      _config = DragonsFeastConfig.configForLevel(1);
      _categoryName = _config.category.displayName;
      _requiredCorrect = _config.correctTileCount;
    });
    _flameGame.resetGame();
  }

  void _onPauseChanged(bool isPaused) {
    _flameGame.setPaused(isPaused);
  }

  void _onCountdownComplete() {
    setState(() => _showCountdown = false);
    _flameGame.startPlaying();
  }

  // Swipe detection
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
        _flameGame.movePlayer(dx > 0 ? Direction.right : Direction.left);
      } else {
        _flameGame.movePlayer(dy > 0 ? Direction.down : Direction.up);
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

    if (event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      _flameGame.munchTile();
      return KeyEventResult.handled;
    }

    final direction = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowUp => Direction.up,
      LogicalKeyboardKey.arrowDown => Direction.down,
      LogicalKeyboardKey.arrowLeft => Direction.left,
      LogicalKeyboardKey.arrowRight => Direction.right,
      _ => null,
    };

    if (direction != null) {
      _flameGame.movePlayer(direction);
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
        gameId: 'dragons_feast',
        title: l10n.dragonsFeast,
        accentColor: DragonColors.dragonsFeastAccent,
        level: _currentLevel,
        backgroundImage: DragonAssets.gameBackgrounds['dragons_feast'],
        onPauseChanged: _onPauseChanged,
        child: Column(
          children: [
            // Category display + lives
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DragonSpacing.base,
                vertical: DragonSpacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(child: CategoryDisplay(categoryName: _categoryName)),
                  const SizedBox(width: DragonSpacing.sm),
                  LivesDisplay(lives: _lives),
                ],
              ),
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

                  // Category transition overlay
                  if (_showCategoryTransition)
                    CategoryTransition(
                      categoryName: DragonsFeastConfig.configForLevel(
                        min(_currentLevel + 1, 40),
                      ).category.displayName,
                      onComplete: _onCategoryTransitionComplete,
                    ),

                  // Countdown overlay (reusing the same pattern)
                  if (_showCountdown)
                    _CountdownOverlay(onComplete: _onCountdownComplete),
                ],
              ),
            ),

            // Bottom HUD: score/streak/progress
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DragonSpacing.base,
                vertical: DragonSpacing.xs,
              ),
              child: FeastScoreDisplay(
                score: _score,
                streak: _streak,
                correctEaten: _correctEaten,
                requiredCorrect: _requiredCorrect,
                level: _currentLevel,
              ),
            ),

            // D-pad controls
            Padding(
              padding: const EdgeInsets.only(bottom: DragonSpacing.sm),
              child: FeastDPadControls(
                onDirection: (dir) => _flameGame.movePlayer(dir),
                onMunch: () => _flameGame.munchTile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple countdown overlay (3-2-1-GO).
class _CountdownOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const _CountdownOverlay({required this.onComplete});

  @override
  State<_CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<_CountdownOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _count = i);
      _controller.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    if (!mounted) return;
    setState(() => _count = 0);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) widget.onComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A174E).withAlpha(200),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            final scale = 1.0 + (1.0 - _controller.value) * 0.5;
            final opacity = _controller.value < 0.8
                ? 1.0
                : 1.0 - (_controller.value - 0.8) / 0.2;
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Text(
                  _count > 0 ? '$_count' : 'GO!',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: _count > 0 ? 72 : 56,
                    fontWeight: FontWeight.bold,
                    color: _count > 0
                        ? const Color(0xFFF0E6D3)
                        : DragonColors.dragonsFeastAccent,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
