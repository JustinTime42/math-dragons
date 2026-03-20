import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/player_profile.dart';
import '../../storage/local_storage.dart';
import '../../theme/dragon_assets.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';

/// Level select screen shared by all 4 games.
///
/// Shows worlds as horizontal sections with level tiles in a grid.
/// Each tile shows its level number and star rating (0-3).
/// Locked levels are dimmed and non-interactive.
class LevelSelectScreen extends StatelessWidget {
  final String gameId;
  final String gameTitle;
  final Color accentColor;
  final List<WorldDefinition> worlds;
  final void Function(int levelNumber) onLevelSelected;

  const LevelSelectScreen({
    super.key,
    required this.gameId,
    required this.gameTitle,
    required this.accentColor,
    required this.worlds,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();
    final gameStats = profile.gameStats[gameId] ?? const GameStats();

    return Scaffold(
      backgroundColor: DragonColors.midnightBlue,
      appBar: AppBar(
        title: Text(gameTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(DragonSpacing.md),
        itemCount: worlds.length,
        itemBuilder: (context, worldIndex) {
          final world = worlds[worldIndex];
          return _WorldSection(
            world: world,
            gameStats: gameStats,
            accentColor: accentColor,
            onLevelSelected: onLevelSelected,
          );
        },
      ),
    );
  }
}

class _WorldSection extends StatelessWidget {
  final WorldDefinition world;
  final GameStats gameStats;
  final Color accentColor;
  final void Function(int) onLevelSelected;

  const _WorldSection({
    required this.world,
    required this.gameStats,
    required this.accentColor,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: DragonSpacing.sm),
          child: Text(
            world.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: DragonSpacing.sm,
            crossAxisSpacing: DragonSpacing.sm,
            childAspectRatio: 0.85,
          ),
          itemCount: world.levelCount,
          itemBuilder: (context, index) {
            final levelNumber = world.firstLevel + index;
            final stars = gameStats.levelStars[levelNumber] ?? 0;
            final isUnlocked = _isUnlocked(levelNumber);

            return _LevelTile(
              levelNumber: levelNumber,
              stars: stars,
              isUnlocked: isUnlocked,
              accentColor: accentColor,
              onTap: isUnlocked ? () => onLevelSelected(levelNumber) : null,
            );
          },
        ),
        const SizedBox(height: DragonSpacing.lg),
      ],
    );
  }

  bool _isUnlocked(int levelNumber) {
    if (levelNumber == 1) return true; // First level always unlocked
    // Unlocked if previous level has at least 1 star
    final prevStars = gameStats.levelStars[levelNumber - 1] ?? 0;
    return prevStars >= 1;
  }
}

class _LevelTile extends StatelessWidget {
  final int levelNumber;
  final int stars;
  final bool isUnlocked;
  final Color accentColor;
  final VoidCallback? onTap;

  const _LevelTile({
    required this.levelNumber,
    required this.stars,
    required this.isUnlocked,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked
              ? DragonColors.nightSurface
              : DragonColors.nightSurface.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUnlocked
                ? (stars > 0 ? accentColor : DragonColors.nightSurface)
                : DragonColors.nightSurface.withAlpha(50),
            width: stars >= 3 ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$levelNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isUnlocked ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            if (isUnlocked) _StarRow(stars: stars),
            if (!isUnlocked)
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: Colors.white24,
              ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int stars;
  const _StarRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Image.asset(
          i < stars
              ? DragonAssets.iconStarFilled
              : DragonAssets.iconStarEmpty,
          width: 12,
          height: 12,
        );
      }),
    );
  }
}

/// Definition of a world's levels for the level select screen.
class WorldDefinition {
  final String name;
  final int firstLevel;
  final int levelCount;

  const WorldDefinition({
    required this.name,
    required this.firstLevel,
    required this.levelCount,
  });
}
