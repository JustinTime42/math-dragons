import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../../core/session_manager.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../../core/audio_service.dart';
import '../../storage/local_storage.dart';

/// Shared wrapper for all game screens.
/// Provides HUD, pause overlay, and session management.
class GameShell extends StatefulWidget {
  final String gameId;
  final String title;
  final Color accentColor;
  final int level;
  final Widget child;

  /// Optional callback when pause state changes.
  final ValueChanged<bool>? onPauseChanged;

  /// Optional background image path shown behind the game content.
  final String? backgroundImage;

  /// Optional widget rendered between the background and content (e.g. dragon portrait).
  final Widget? backgroundOverlay;

  const GameShell({
    super.key,
    required this.gameId,
    required this.title,
    required this.accentColor,
    required this.child,
    this.level = 1,
    this.onPauseChanged,
    this.backgroundImage,
    this.backgroundOverlay,
  });

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Start the game session
    final session = context.read<SessionManager>();
    session.startGame(widget.gameId);

    // Start game music
    context.read<AudioService>().playGameMusic(widget.gameId);

    // Emit GameStarted event after the current build frame completes,
    // so that synchronous EventBus listeners don't trigger setState during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final eventBus = context.read<EventBus>();
      eventBus.emit(GameStarted(
        gameId: widget.gameId,
        levelNumber: widget.level,
      ));
    });
  }

  @override
  void dispose() {
    // End the game session and stop music
    try {
      final session = context.read<SessionManager>();
      session.endGame();
      context.read<AudioService>().stopMusic();
    } catch (_) {
      // Provider may not be available during dispose
    }
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    widget.onPauseChanged?.call(_isPaused);
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    widget.onPauseChanged?.call(false);
  }

  void _quitToHub() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.backgroundImage == null ? DragonColors.nightSky : null,
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(widget.backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Per-skin background overlay (e.g. dragon portrait)
              if (widget.backgroundOverlay != null) widget.backgroundOverlay!,

              // Main content: HUD + game area
              Column(
                children: [
                  // Top HUD bar
                  _buildHUD(context, l10n, profile.totalScales),

                  // Game content area
                  Expanded(child: widget.child),
                ],
              ),

              // Pause overlay
              if (_isPaused) _buildPauseOverlay(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD(BuildContext context, AppLocalizations l10n, int totalScales) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.sm,
        vertical: DragonSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.8),
      ),
      child: Row(
        children: [
          // Pause button
          IconButton(
            icon: const Icon(Icons.pause, size: 22),
            color: DragonColors.textSecondary,
            onPressed: _togglePause,
            tooltip: l10n.pause,
          ),

          // Game title and level
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: widget.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.level(widget.level),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DragonColors.textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Scales counter
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: DragonColors.dragonGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  DragonAssets.iconScale,
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: DragonSpacing.xxs),
                Text(
                  '$totalScales',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DragonColors.dragonGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: DragonColors.deepVoid.withValues(alpha: 0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Paused title
            Text(
              l10n.paused,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Cinzel',
              ),
            ),

            const SizedBox(height: DragonSpacing.xxl),

            // Resume button (primary / gold)
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: _resume,
                child: Text(l10n.resume),
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Settings button (secondary)
            SizedBox(
              width: 220,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                },
                child: Text(l10n.settings),
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Quit to hub button (secondary)
            SizedBox(
              width: 220,
              child: OutlinedButton(
                onPressed: _quitToHub,
                child: Text(l10n.quitToHub),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
