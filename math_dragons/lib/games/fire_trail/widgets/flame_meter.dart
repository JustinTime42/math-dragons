import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';
import '../models/flame_intensity.dart';

/// Horizontal flame intensity bar for the HUD.
class FlameMeter extends StatelessWidget {
  final double intensity; // 0.0 to 1.0

  const FlameMeter({super.key, required this.intensity});

  @override
  Widget build(BuildContext context) {
    final color = FlameIntensity.colorForValue(intensity);
    final isDanger = intensity <= 0.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Flame: ${(intensity * 100).round()}%',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color:
                isDanger ? DragonColors.fireOrange : DragonColors.dragonGold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 120,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A4A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: intensity.clamp(0.0, 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
