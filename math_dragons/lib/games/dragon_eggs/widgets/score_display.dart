import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';
import '../../../theme/dragon_spacing.dart';

/// Compact score + streak badge positioned at the top of the game area.
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int streak;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.md,
        vertical: DragonSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DragonColors.dragonGold,
            ),
          ),
          if (streak > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: DragonColors.fireOrange,
                  size: 14,
                ),
                Text(
                  '$streak',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: DragonColors.fireOrange,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
