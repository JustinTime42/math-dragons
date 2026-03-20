import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Displays score, streak, and level info in the HUD.
class ScoreStreakDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int correctCount;
  final int correctToAdvance;

  const ScoreStreakDisplay({
    super.key,
    required this.score,
    required this.streak,
    required this.correctCount,
    required this.correctToAdvance,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (correctToAdvance - correctCount).clamp(0, correctToAdvance);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score
        Text(
          'Score: $score',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: DragonColors.dragonGold,
          ),
        ),

        // Streak (if active)
        if (streak > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department,
                  color: DragonColors.fireOrange, size: 18),
              Text(
                'x$streak',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: DragonColors.fireOrange,
                ),
              ),
            ],
          ),

        // Remaining to advance
        Text(
          '$remaining left',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Color(0xFFA89DB8),
          ),
        ),
      ],
    );
  }
}
