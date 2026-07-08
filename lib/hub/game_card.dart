import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/audio_service.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../navigation/dragon_routes.dart';

class GameCard extends StatefulWidget {
  final String gameId;
  final String title;
  final String description;
  final Color accentColor;
  final String imagePath;
  final int level;
  final int totalStars;
  final int timesPlayed;

  const GameCard({
    super.key,
    required this.gameId,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.imagePath,
    required this.level,
    this.totalStars = 0,
    this.timesPlayed = 0,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _tapController.reverse();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  Future<void> _onTap() async {
    final audio = context.read<AudioService>();
    audio.playButtonTap();
    // Await the whole game flow. The future completes only once the game
    // stack has been popped (and GameShell.dispose has stopped its music),
    // so resuming hub music here can't race the game's teardown.
    await Navigator.of(context).push(
      DragonPageRoute.gameTransition(gameId: widget.gameId),
    );
    if (mounted) audio.playHubMusic();
  }

  /// Progress within current world (each world = 10 levels).
  double get _worldProgress {
    final levelInWorld = ((widget.level - 1) % 10) + 1;
    return levelInWorld / 10;
  }

  int get _currentWorld => ((widget.level - 1) ~/ 10) + 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _onTap,
        child: Container(
          decoration: BoxDecoration(
            color: DragonColors.nightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.accentColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full-bleed background image
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),

                // Gradient scrim for text readability
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Game name — top left
                Positioned(
                  top: DragonSpacing.sm,
                  left: DragonSpacing.sm,
                  right: DragonSpacing.sm,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFamily: 'Cinzel',
                      fontSize: 20,
                      height: 1.1,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Level info — bottom left
                Positioned(
                  bottom: DragonSpacing.sm,
                  left: DragonSpacing.sm,
                  right: DragonSpacing.sm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Level and Stars row
                      Row(
                        children: [
                          Text(
                            'Level ${widget.level}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.accentColor,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: DragonSpacing.xs),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: DragonSpacing.xs),
                          Image.asset(
                            DragonAssets.iconStarFilled,
                            width: 14,
                            height: 14,
                            opacity: widget.totalStars > 0
                                ? const AlwaysStoppedAnimation(1.0)
                                : const AlwaysStoppedAnimation(0.3),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.totalStars}',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.totalStars > 0
                                  ? DragonColors.dragonGold
                                  : DragonColors.disabled,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: DragonSpacing.xxs),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _worldProgress,
                          backgroundColor: Colors.white24,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(widget.accentColor),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'World $_currentWorld',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: Colors.white70,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
