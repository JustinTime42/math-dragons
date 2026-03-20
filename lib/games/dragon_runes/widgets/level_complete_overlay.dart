import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';
import '../../../theme/dragon_spacing.dart';

/// Brief celebration overlay before showing the result screen.
class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DragonColors.deepVoid.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: DragonColors.dragonGold,
              size: 64,
            ),
            const SizedBox(height: DragonSpacing.base),
            Text(
              'All Spells Found!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'Cinzel',
                    color: DragonColors.dragonGold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
