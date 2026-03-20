import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../core/audio_service.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';

/// Data class holding game results to display.
class GameResults {
  final String gameId;
  final int score;
  final double accuracy; // 0.0 - 1.0
  final int streak;
  final int scalesEarned;
  final int stars; // 0-3
  final int levelNumber;
  final int problemsAttempted;
  final int problemsCorrect;

  const GameResults({
    required this.gameId,
    required this.score,
    required this.accuracy,
    required this.streak,
    required this.scalesEarned,
    required this.stars,
    required this.levelNumber,
    this.problemsAttempted = 0,
    this.problemsCorrect = 0,
  });
}

/// Post-game results screen shown as a modal bottom sheet.
/// "Play Again" is the primary CTA; "Back to Hub" is secondary.
class ResultScreen extends StatefulWidget {
  final GameResults results;
  final Color accentColor;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToHub;
  final VoidCallback? onNextLevel;
  final String? encouragement;
  final String? gameSuggestion;

  const ResultScreen({
    super.key,
    required this.results,
    required this.accentColor,
    required this.onPlayAgain,
    required this.onBackToHub,
    this.onNextLevel,
    this.encouragement,
    this.gameSuggestion,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _starsController;
  late final AnimationController _scalesController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _starsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scalesController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Play victory music
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AudioService>().playVictoryMusic();
    });

    // Start animations in sequence
    _slideController.forward().then((_) {
      _starsController.forward().then((_) {
        _scalesController.forward();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _starsController.dispose();
    _scalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final r = widget.results;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: DragonColors.nightSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          border: Border.all(color: DragonColors.divider),
        ),
        padding: const EdgeInsets.all(DragonSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DragonColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: DragonSpacing.lg),

            // Title
            Text(
              r.stars >= 1 ? l10n.levelComplete : l10n.gameOver,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamily: 'Cinzel',
                color: r.stars >= 1
                    ? DragonColors.dragonGold
                    : DragonColors.fireOrange,
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Star rating (animated fill)
            _buildStars(),

            const SizedBox(height: DragonSpacing.lg),

            // Stats grid
            _buildStatsGrid(context, l10n, r),

            const SizedBox(height: DragonSpacing.base),

            // Scales earned (animated counter)
            _buildScalesEarned(r),

            // Encouragement text
            if (widget.encouragement != null) ...[
              const SizedBox(height: DragonSpacing.base),
              Text(
                widget.encouragement!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DragonColors.dragonGold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Game suggestion
            if (widget.gameSuggestion != null) ...[
              const SizedBox(height: DragonSpacing.sm),
              Text(
                widget.gameSuggestion!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DragonColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: DragonSpacing.lg),

            // When level is completed and next level is available, show Next Level as primary
            if (widget.onNextLevel != null && r.stars >= 1) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: widget.onNextLevel,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.nextLevel),
                ),
              ),
              const SizedBox(height: DragonSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: widget.onPlayAgain,
                  icon: const Icon(Icons.replay, size: 18),
                  label: Text(l10n.playAgain),
                ),
              ),
            ] else ...[
              // No next level (game over or continuous game): Play Again is primary
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: widget.onPlayAgain,
                  icon: const Icon(Icons.replay),
                  label: Text(l10n.playAgain),
                ),
              ),
            ],

            const SizedBox(height: DragonSpacing.sm),

            // "Back to Hub" button — always secondary
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: widget.onBackToHub,
                child: Text(l10n.backToHub),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, _) {
        final filledStars = (_starsController.value * widget.results.stars)
            .ceil()
            .clamp(0, 3);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isFilled = index < filledStars;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedScale(
                scale: isFilled ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  isFilled
                      ? DragonAssets.iconStarFilled
                      : DragonAssets.iconStarEmpty,
                  width: 40,
                  height: 40,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    GameResults r,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.scoreLabel,
            value: '${r.score}',
            color: DragonColors.textPrimary,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.accuracyLabel,
            value: '${(r.accuracy * 100).round()}%',
            color: r.accuracy >= 0.9
                ? DragonColors.emeraldFlame
                : r.accuracy >= 0.7
                    ? DragonColors.dragonGold
                    : DragonColors.fireOrange,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.streakLabel,
            value: '${r.streak}',
            color: DragonColors.fireOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: DragonColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildScalesEarned(GameResults r) {
    return AnimatedBuilder(
      animation: _scalesController,
      builder: (context, _) {
        final displayScales =
            (_scalesController.value * r.scalesEarned).round();
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DragonSpacing.lg,
            vertical: DragonSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: DragonColors.goldShimmer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                DragonAssets.iconScale,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: DragonSpacing.sm),
              Text(
                '+$displayScales',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: DragonColors.deepVoid,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
