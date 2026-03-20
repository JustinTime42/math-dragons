import 'package:flutter/material.dart';

import '../../../theme/dragon_colors.dart';

/// Score, streak, and progress HUD for Dragon's Feast.
class FeastScoreDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final int correctEaten;
  final int requiredCorrect;
  final int level;

  const FeastScoreDisplay({
    super.key,
    required this.score,
    required this.streak,
    required this.correctEaten,
    required this.requiredCorrect,
    required this.level,
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
            const Icon(Icons.local_fire_department,
                color: Color(0xFFE76F51), size: 18),
            Text(
              'x$streak',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE76F51),
              ),
            ),
          ]),

        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$correctEaten / $requiredCorrect',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: Color(0xFFA89DB8),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 80,
              height: 4,
              child: LinearProgressIndicator(
                value: requiredCorrect > 0
                    ? (correctEaten / requiredCorrect).clamp(0.0, 1.0)
                    : 0.0,
                backgroundColor: const Color(0xFF2A2A4A),
                valueColor: const AlwaysStoppedAnimation(
                  DragonColors.dragonsFeastAccent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
