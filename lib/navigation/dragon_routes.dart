import 'package:flutter/material.dart';
import '../games/shared/level_select_screen.dart';
import '../games/dragon_runes/dragon_runes_game.dart';
import '../games/fire_trail/fire_trail_game.dart';
import '../games/dragon_eggs/dragon_eggs_game.dart';
import '../games/dragons_feast/dragons_feast_game.dart';
import '../theme/dragon_colors.dart';

/// Custom page route transitions for Math Dragons.
/// See Visual Design Guide section 10.2.
class DragonPageRoute {
  DragonPageRoute._();

  /// Hub -> Level Select: fade + scale up (400ms)
  static Route<T> gameTransition<T>({
    required String gameId,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return _levelSelectForGame(context, gameId);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final scaleIn = Tween<double>(begin: 0.9, end: 1.0).animate(fadeIn);

        return FadeTransition(
          opacity: fadeIn,
          child: ScaleTransition(
            scale: scaleIn,
            child: child,
          ),
        );
      },
    );
  }

  /// Standard slide-in from right for non-game screens (settings, etc.)
  static Route<T> slideTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        return SlideTransition(
          position: slideIn,
          child: child,
        );
      },
    );
  }

  /// Build a LevelSelectScreen for the given game ID.
  /// Wrapped in a StatefulWidget so it refreshes when returning from a game.
  static Widget _levelSelectForGame(BuildContext context, String gameId) {
    return _LevelSelectPage(gameId: gameId);
  }

  /// World definitions per game.
  static (String, Color, List<WorldDefinition>) _gameMetadata(String gameId) {
    switch (gameId) {
      case 'dragon_runes':
        return (
          'Dragon Runes',
          DragonColors.runesAccent,
          const [
            WorldDefinition(
                name: 'Ember Equations', firstLevel: 1, levelCount: 10),
            WorldDefinition(
                name: 'Flame Formulas', firstLevel: 11, levelCount: 10),
            WorldDefinition(
                name: 'Inferno Algebra', firstLevel: 21, levelCount: 10),
            WorldDefinition(
                name: "Dragon's Calculus", firstLevel: 31, levelCount: 10),
            WorldDefinition(
                name: 'Elder Runes', firstLevel: 41, levelCount: 10),
          ],
        );
      case 'fire_trail':
        return (
          'Fire Trail',
          DragonColors.fireTrailAccent,
          const [
            WorldDefinition(
                name: 'First Flight', firstLevel: 1, levelCount: 8),
            WorldDefinition(
                name: 'Thermal Currents', firstLevel: 9, levelCount: 8),
            WorldDefinition(
                name: 'Firestorm', firstLevel: 17, levelCount: 8),
            WorldDefinition(
                name: 'Inferno', firstLevel: 25, levelCount: 8),
            WorldDefinition(
                name: 'Dragon Master', firstLevel: 33, levelCount: 8),
          ],
        );
      case 'dragon_eggs':
        return (
          'Dragon Eggs',
          DragonColors.dragonEggsAccent,
          const [
            WorldDefinition(
                name: 'Nest of Addition', firstLevel: 1, levelCount: 10),
            WorldDefinition(
                name: 'Cracking Subtraction',
                firstLevel: 11,
                levelCount: 10),
            WorldDefinition(
                name: 'Multiplication Roost',
                firstLevel: 21,
                levelCount: 15),
            WorldDefinition(
                name: 'Division Den', firstLevel: 36, levelCount: 15),
          ],
        );
      case 'dragons_feast':
        return (
          "Dragon's Feast",
          DragonColors.dragonsFeastAccent,
          const [
            WorldDefinition(
                name: 'Easy Pickings', firstLevel: 1, levelCount: 8),
            WorldDefinition(
                name: 'Growing Appetite', firstLevel: 9, levelCount: 8),
            WorldDefinition(
                name: 'Refined Palate', firstLevel: 17, levelCount: 8),
            WorldDefinition(
                name: 'Gourmet Dragon', firstLevel: 25, levelCount: 8),
            WorldDefinition(
                name: "Dragon King's Feast",
                firstLevel: 33,
                levelCount: 8),
          ],
        );
      default:
        throw ArgumentError('Unknown game ID: $gameId');
    }
  }

  /// Map a game ID to its screen widget.
  @visibleForTesting
  static Widget gameScreenForId(String gameId, {int startingLevel = 1}) {
    switch (gameId) {
      case 'dragon_runes':
        return DragonRunesScreen(startingLevel: startingLevel);
      case 'fire_trail':
        return FireTrailScreen(startingLevel: startingLevel);
      case 'dragon_eggs':
        return DragonEggsScreen(startingLevel: startingLevel);
      case 'dragons_feast':
        return DragonsFeastScreen(startingLevel: startingLevel);
      default:
        throw ArgumentError('Unknown game ID: $gameId');
    }
  }
}

/// Wraps LevelSelectScreen in a StatefulWidget so it reads fresh data
/// from storage whenever the user returns from a game (via system back button).
class _LevelSelectPage extends StatefulWidget {
  final String gameId;
  const _LevelSelectPage({required this.gameId});

  @override
  State<_LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<_LevelSelectPage> {
  @override
  Widget build(BuildContext context) {
    final (title, color, worlds) = DragonPageRoute._gameMetadata(widget.gameId);

    return LevelSelectScreen(
      gameId: widget.gameId,
      gameTitle: title,
      accentColor: color,
      worlds: worlds,
      onLevelSelected: (levelNumber) async {
        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (ctx, anim, secAnim) =>
                DragonPageRoute.gameScreenForId(widget.gameId,
                    startingLevel: levelNumber),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (ctx, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        );
        // Force rebuild with fresh data when returning from game
        if (mounted) setState(() {});
      },
    );
  }
}
