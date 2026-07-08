import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../core/difficulty_engine.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../../storage/local_storage.dart';
import '../../theme/dragon_anchor_points.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../shared/difficulty_config.dart';
import '../shared/math_problem.dart';
import '../dragon_eggs/models/egg_data.dart' as egg;
import '../shared/game_shell.dart';
import '../shared/result_screen.dart';
import 'dragon_runes_flame_game.dart';
import 'models/dragon_runes_config.dart';
import 'systems/equation_validator.dart';
import 'systems/hint_manager.dart';
import 'systems/level_generator.dart';
import 'systems/scoring_manager.dart';
import 'widgets/chain_display.dart';
import 'widgets/hint_button.dart';
import 'widgets/level_complete_overlay.dart';
import 'widgets/score_streak_display.dart';
import 'widgets/target_panel.dart';

class DragonRunesScreen extends StatefulWidget {
  final int startingLevel;
  const DragonRunesScreen({super.key, this.startingLevel = 1});

  @override
  State<DragonRunesScreen> createState() => _DragonRunesScreenState();
}

class _DragonRunesScreenState extends State<DragonRunesScreen> {
  // -- Game state --
  late int _currentLevel;
  late DragonRunesConfig _config;
  late GeneratedLevel _generatedLevel;
  late ScoringManager _scoring;
  late HintManager _hintManager;
  final Set<String> _solvedTargets = {};
  final List<String> _foundTargetDisplayTexts = [];
  final List<String> _foundBonusDisplayTexts = [];
  List<String> _chainTokens = [];
  bool _levelComplete = false;
  String? _feedbackMessage;
  DateTime _lastAttemptTime = DateTime.now();
  DateTime _gameStartTime = DateTime.now();

  // Flame game
  DragonRunesFlameGame? _flameGame;
  // Key to force rebuild of GameWidget when level changes
  UniqueKey _gameKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.startingLevel;
    _scoring = ScoringManager();
    _initLevel();
  }

  void _initLevel() {
    _config = DragonRunesConfig.forLevel(_currentLevel);
    final generator = LevelGenerator();

    // Query engine for suggested facts to bias family generation
    List<MathFact>? suggestedFacts;
    try {
      final engine = context.read<DifficultyEngine>();
      // Generate fact pool for this level's params and pick suggestions
      final pool = FactPool.forLevel(
        numberMin: _config.numberMin,
        numberMax: _config.numberMax,
        operations: _config.allowedOps.map(_mapToEggOp).toList(),
      );
      if (pool.isNotEmpty) {
        final first = engine.selectNext(pool);
        if (first != null) suggestedFacts = [first];
      }
    } catch (_) {
      // Engine not available (e.g. in tests) — fallback to random
    }

    _generatedLevel = generator.generate(
      _config,
      suggestedFacts: suggestedFacts,
    );
    _solvedTargets.clear();
    _foundTargetDisplayTexts.clear();
    _foundBonusDisplayTexts.clear();
    _scoring.reset();
    _chainTokens = [];
    _levelComplete = false;
    _feedbackMessage = null;
    _lastAttemptTime = DateTime.now();
    _gameStartTime = DateTime.now();

    _hintManager = HintManager(
      targets: _generatedLevel.targets,
      solvedTargets: _solvedTargets,
      nodes: _generatedLevel.nodes,
    );

    _createFlameGame();
  }

  void _createFlameGame() {
    _flameGame = DragonRunesFlameGame(
      config: _config,
      targets: _generatedLevel.targets,
      nodeData: _generatedLevel.nodes,
      onEquationValidated: _onEquationValidated,
      onLevelComplete: _onLevelComplete,
      onChainChanged: _onChainChanged,
    );
    _gameKey = UniqueKey();
  }

  void _onChainChanged(List<String> tokens) {
    setState(() {
      _chainTokens = tokens;
    });
  }

  void _onEquationValidated(EquationResult result, List<int> chainIndices) {
    final responseTimeMs = DateTime.now()
        .difference(_lastAttemptTime)
        .inMilliseconds;
    _lastAttemptTime = DateTime.now();

    _scoring.handleResult(result);
    final eventBus = context.read<EventBus>();

    setState(() {
      switch (result) {
        case TargetMatchEquation(:final target):
          _solvedTargets.add(target.canonical);
          _foundTargetDisplayTexts.add(target.displayText);
          _feedbackMessage = 'Spell cast!';

          // Emit AnswerGiven
          eventBus.emit(
            AnswerGiven(
              gameId: 'dragon_runes',
              problem: target.displayText,
              playerAnswer: target.displayText,
              correctAnswer: target.displayText,
              correct: true,
              responseTimeMs: responseTimeMs,
            ),
          );

          // Check streak milestones
          if (_scoring.streak > 0 && _scoring.streak % 5 == 0) {
            eventBus.emit(
              StreakAchieved(
                gameId: 'dragon_runes',
                streakLength: _scoring.streak,
              ),
            );
          }

        case InvalidEquation():
          _feedbackMessage = 'Invalid spell!';
          eventBus.emit(
            AnswerGiven(
              gameId: 'dragon_runes',
              problem: 'invalid',
              playerAnswer: 'invalid',
              correctAnswer: 'unknown',
              correct: false,
              responseTimeMs: responseTimeMs,
            ),
          );

        case AlreadyFoundEquation():
          _feedbackMessage = 'Already cast!';

        case BonusEquation(:final displayText):
          _foundBonusDisplayTexts.add(displayText);
          _feedbackMessage = 'Bonus spell! +50';

          eventBus.emit(
            AnswerGiven(
              gameId: 'dragon_runes',
              problem: displayText,
              playerAnswer: displayText,
              correctAnswer: displayText,
              correct: true,
              responseTimeMs: responseTimeMs,
            ),
          );

          // Check streak milestones
          if (_scoring.streak > 0 && _scoring.streak % 5 == 0) {
            eventBus.emit(
              StreakAchieved(
                gameId: 'dragon_runes',
                streakLength: _scoring.streak,
              ),
            );
          }
      }
    });

    // Clear feedback after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _feedbackMessage = null;
        });
      }
    });
  }

  void _onLevelComplete() {
    final eventBus = context.read<EventBus>();
    _scoring.completeLevelBonus();

    final accuracy = _scoring.totalAttempts > 0
        ? _scoring.equationsFound / _scoring.totalAttempts
        : 0.0;
    final stars = _calculateStars(accuracy, 3 - _hintManager.remaining);

    eventBus.emit(
      LevelCompleted(
        gameId: 'dragon_runes',
        levelNumber: _currentLevel,
        score: _scoring.score,
        stars: stars,
        accuracy: accuracy,
      ),
    );

    setState(() {
      _levelComplete = true;
    });

    // Show results after brief celebration
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showResults();
    });
  }

  int _calculateStars(double accuracy, int hintsUsed) {
    if (accuracy >= 0.9 && hintsUsed == 0) return 3;
    if (accuracy >= 0.75 && hintsUsed <= 1) return 2;
    return 1;
  }

  void _useHint() {
    final indices = _hintManager.useHint();
    if (indices != null) {
      _flameGame?.showHintHighlights(indices);
      setState(() {});
    }
  }

  void _showResults() {
    final accuracy = _scoring.totalAttempts > 0
        ? _scoring.equationsFound / _scoring.totalAttempts
        : 0.0;
    final stars = _calculateStars(accuracy, 3 - _hintManager.remaining);
    final scalesEarned =
        _scoring.equationsFound * 2 +
        (_scoring.bestStreak >= 3 ? 5 : 0) +
        (_levelComplete ? 25 : 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ResultScreen(
        results: GameResults(
          gameId: 'dragon_runes',
          score: _scoring.score,
          accuracy: accuracy,
          streak: _scoring.bestStreak,
          scalesEarned: scalesEarned,
          stars: stars,
          levelNumber: _currentLevel,
          problemsAttempted: _scoring.totalAttempts,
          problemsCorrect: _scoring.equationsFound,
        ),
        accentColor: DragonColors.runesAccent,
        onNextLevel: _currentLevel < 50
            ? () {
                Navigator.pop(context); // dismiss sheet
                _nextLevel();
              }
            : null,
        onPlayAgain: () {
          Navigator.pop(context); // dismiss sheet
          _replayLevel();
        },
        onBackToHub: () {
          final eventBus = context.read<EventBus>();
          eventBus.emit(
            GameEnded(
              gameId: 'dragon_runes',
              finalScore: _scoring.score,
              duration: DateTime.now().difference(_gameStartTime),
            ),
          );
          final navigator = Navigator.of(context);
          navigator.pop(); // dismiss sheet
          navigator.popUntil((route) => route.isFirst); // back to hub
        },
      ),
    );
  }

  void _nextLevel() {
    setState(() {
      _currentLevel++;
      if (_currentLevel > 50) _currentLevel = 50;
      _initLevel();
    });
  }

  void _replayLevel() {
    setState(() {
      _initLevel();
    });
  }

  void _onPauseChanged(bool isPaused) {
    // Flame game doesn't need special pause handling since it's event-driven
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.read<LocalStorage>().getProfile();
    final equippedColor = profile.equippedColor;

    // Resolve per-skin background
    final backgroundImage = DragonAssets.resolveRunesBackground(equippedColor);

    // Resolve dragon portrait: color variant if equipped, otherwise evolution portrait
    final stage = profile.dragonEvolution.clamp(
      0,
      DragonAssets.dragonPortraits.length - 1,
    );
    final dragonPortrait = DragonAssets.resolveDragonImage(
      evolutionStage: stage,
      context: DragonRenderContext.portrait,
      skinId: equippedColor,
    );

    return GameShell(
      gameId: 'dragon_runes',
      title: l10n.dragonRunes,
      accentColor: DragonColors.runesAccent,
      level: _currentLevel,
      backgroundImage: backgroundImage,
      backgroundOverlay: Positioned.fill(
        child: Center(
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(dragonPortrait, width: 250, height: 250),
          ),
        ),
      ),
      onPauseChanged: _onPauseChanged,
      child: Column(
        children: [
          // Target equations panel
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xs,
            ),
            child: TargetPanel(
              totalTargets: _generatedLevel.targets.length,
              foundTargets: _foundTargetDisplayTexts,
              foundBonuses: _foundBonusDisplayTexts,
            ),
          ),

          // Flame game area
          Expanded(
            child: Stack(
              children: [
                GameWidget(key: _gameKey, game: _flameGame!),

                // Feedback message overlay
                if (_feedbackMessage != null)
                  Positioned(
                    top: DragonSpacing.lg,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DragonSpacing.base,
                          vertical: DragonSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: DragonColors.deepVoid.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: DragonColors.runesAccent.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          _feedbackMessage!,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: DragonColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Level complete overlay
                if (_levelComplete) const LevelCompleteOverlay(),
              ],
            ),
          ),

          // Chain display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DragonSpacing.sm),
            child: ChainDisplay(chainTokens: _chainTokens),
          ),

          // Bottom HUD: Score, Streak, Progress, Hint
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ScoreStreakDisplay(
                    score: _scoring.score,
                    streak: _scoring.streak,
                    solved: _solvedTargets.length,
                    totalTargets: _generatedLevel.targets.length,
                  ),
                ),
                const SizedBox(width: DragonSpacing.sm),
                HintButton(remaining: _hintManager.remaining, onTap: _useHint),
              ],
            ),
          ),

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Map Dragon Runes MathOp to egg_data MathOp for FactPool.
  static egg.MathOp _mapToEggOp(MathOp op) {
    switch (op) {
      case MathOp.add:
        return egg.MathOp.add;
      case MathOp.subtract:
        return egg.MathOp.subtract;
      case MathOp.multiply:
        return egg.MathOp.multiply;
      case MathOp.divide:
        return egg.MathOp.divide;
    }
  }
}
