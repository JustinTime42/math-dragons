import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Displays the current math problem prominently above the game grid.
class ProblemDisplay extends StatelessWidget {
  final String problemText;

  const ProblemDisplay({super.key, required this.problemText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.dragonGold.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        problemText,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0E6D3),
          letterSpacing: 2,
        ),
      ),
    );
  }
}
