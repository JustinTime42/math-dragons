import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Shows score, streak, and progress.
class ScoreStreakDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int solved;
  final int totalTargets;

  const ScoreStreakDisplay({
    super.key,
    required this.score,
    required this.streak,
    required this.solved,
    required this.totalTargets,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(children: [
            const Icon(Icons.auto_awesome,
                color: DragonColors.runesAccent, size: 18),
            Text(
              'x$streak',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DragonColors.runesAccent,
              ),
            ),
          ]),

        // Progress
        Text(
          '$solved / $totalTargets',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            color: Color(0xFFA89DB8),
          ),
        ),
      ],
    );
  }
}
