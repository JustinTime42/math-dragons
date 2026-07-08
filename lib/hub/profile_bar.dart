import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/dragon_anchor_points.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../storage/local_storage.dart';
import '../core/progression_manager.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({super.key});

  @visibleForTesting
  static const evolutionNames = [
    'Egg',
    'Hatchling',
    'Fledgling',
    'Young Dragon',
    'Adult Dragon',
    'Elder Dragon',
  ];

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final progressionMgr = context.read<ProgressionManager>();

    return ValueListenableBuilder(
      valueListenable: storage.profileNotifier,
      builder: (context, profile, child) {
        final evolutionProgress = progressionMgr.getEvolutionProgress();
        final stage = profile.dragonEvolution.clamp(
          0,
          DragonAssets.dragonPortraits.length - 1,
        );
        final evolutionName = evolutionNames[stage];
        final portraitImage = DragonAssets.resolveDragonImage(
          evolutionStage: stage,
          context: DragonRenderContext.portrait,
          skinId: profile.equippedColor,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DragonSpacing.base,
            vertical: DragonSpacing.sm,
          ),
          child: Row(
            children: [
              // Dragon evolution indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: DragonColors.dragonGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: DragonColors.dragonGold, width: 2),
                ),
                child: Center(
                  child: Image.asset(portraitImage, width: 28, height: 28),
                ),
              ),

              const SizedBox(width: DragonSpacing.sm),

              // Dragon name + evolution stage + progress bar
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEvolutionDialog(context, evolutionProgress),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.dragonName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        evolutionName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DragonColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (evolutionProgress.nextStage != null) ...[
                        const SizedBox(height: 3),
                        _EvolutionProgressBar(
                          progress: evolutionProgress.overallProgress,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Scales counter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DragonSpacing.sm,
                  vertical: DragonSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: DragonColors.dragonGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: DragonColors.dragonGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(DragonAssets.iconScale, width: 16, height: 16),
                    const SizedBox(width: DragonSpacing.xs),
                    Text(
                      formatScales(profile.totalScales),
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: DragonColors.dragonGold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: DragonSpacing.xs),

              // Settings button
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: DragonColors.textSecondary,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEvolutionDialog(BuildContext context, EvolutionProgress progress) {
    final stage = progress.currentStage;
    final stageName = evolutionNames[stage.clamp(0, evolutionNames.length - 1)];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DragonColors.nightSurface,
        title: Row(
          children: [
            Image.asset(
              DragonAssets.resolveDragonImage(
                evolutionStage: stage,
                context: DragonRenderContext.portrait,
              ),
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$stageName (Stage $stage)',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        content: progress.nextStage == null
            ? const Text(
                'Maximum Evolution!',
                style: TextStyle(color: DragonColors.dragonGold),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next: ${evolutionNames[progress.nextStage!]}',
                    style: const TextStyle(
                      color: DragonColors.dragonGold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...progress.requirements.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            req.isMet
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: req.isMet
                                ? Colors.greenAccent
                                : DragonColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req.label,
                              style: TextStyle(
                                color: req.isMet
                                    ? Colors.white70
                                    : Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '${req.current}/${req.target}',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: req.isMet
                                  ? Colors.greenAccent
                                  : DragonColors.dragonGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _EvolutionProgressBar(progress: progress.overallProgress),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress.overallProgress * 100).round()}%',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Format large scale counts with comma separators.
  @visibleForTesting
  static String formatScales(int scales) {
    if (scales < 1000) return '$scales';
    final str = scales.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

/// Gold shimmer progress bar for evolution progress.
class _EvolutionProgressBar extends StatelessWidget {
  final double progress;

  const _EvolutionProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [DragonColors.dragonGold, Color(0xFFF1C40F)],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
