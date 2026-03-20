import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/daily_challenge.dart';
import '../core/daily_challenge_manager.dart';
import '../storage/local_storage.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Functional daily challenge card displayed on the hub screen.
class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.read<DailyChallengeManager>();

    return ValueListenableBuilder<DailyChallenge>(
      valueListenable: manager.challengeNotifier,
      builder: (context, challenge, child) {
        final storage = context.read<LocalStorage>();
        final streak = storage.getProfile().dailyChallengeStreak;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DragonSpacing.md),
          decoration: BoxDecoration(
            color: DragonColors.nightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: challenge.isComplete
                  ? DragonColors.emeraldFlame
                  : DragonColors.dragonGold.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(
                    challenge.isComplete
                        ? Icons.check_circle
                        : Icons.wb_sunny,
                    color: challenge.isComplete
                        ? DragonColors.emeraldFlame
                        : DragonColors.dragonGold,
                    size: 20,
                  ),
                  const SizedBox(width: DragonSpacing.sm),
                  Text(
                    challenge.isComplete
                        ? "Today's Challenge Complete!"
                        : "Today's Challenge",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: DragonColors.dragonGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  _StreakBadge(streak: streak),
                ],
              ),
              const SizedBox(height: DragonSpacing.sm),
              const Divider(color: DragonColors.divider, height: 1),
              const SizedBox(height: DragonSpacing.sm),

              // Task list
              ...challenge.tasks.map((task) => _TaskRow(task: task)),

              const SizedBox(height: DragonSpacing.sm),
              const Divider(color: DragonColors.divider, height: 1),
              const SizedBox(height: DragonSpacing.sm),

              // Reward row
              Row(
                children: [
                  Text(
                    'Reward: ${challenge.totalReward} scales',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DragonColors.dragonGold,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (challenge.streakBonus > 0)
                    Text(
                      ' (${challenge.baseReward} + ${challenge.streakBonus} streak)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white38,
                          ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskRow extends StatelessWidget {
  final ChallengeTask task;
  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DragonSpacing.xs),
      child: Row(
        children: [
          Icon(
            task.isComplete
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: task.isComplete
                ? DragonColors.emeraldFlame
                : Colors.white24,
            size: 20,
          ),
          const SizedBox(width: DragonSpacing.sm),
          Expanded(
            child: Text(
              task.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: task.isComplete ? Colors.white54 : Colors.white,
                    decoration:
                        task.isComplete ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.sm,
        vertical: DragonSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: DragonColors.fireOrange.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            DragonAssets.iconStreakFlame,
            width: 14,
            height: 14,
          ),
          const SizedBox(width: 2),
          Text(
            '$streak',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DragonColors.fireOrange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrainsMono',
                ),
          ),
        ],
      ),
    );
  }
}
