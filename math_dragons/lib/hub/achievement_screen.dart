import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/achievement.dart';
import '../core/achievement_tracker.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Full-screen achievement browser with 3 category tabs.
class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: DragonColors.midnightBlue,
        appBar: AppBar(
          title: const Text('Achievements'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: DragonColors.dragonGold,
            labelColor: DragonColors.dragonGold,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Per Game'),
              Tab(text: 'Cross Game'),
              Tab(text: 'Milestones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.perGame)
                  .toList(),
            ),
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.crossGame)
                  .toList(),
            ),
            _AchievementList(
              achievements: AchievementCatalog.all
                  .where((a) => a.category == AchievementCategory.milestone)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementList extends StatelessWidget {
  final List<AchievementDef> achievements;

  const _AchievementList({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final tracker = context.read<AchievementTracker>();

    return ListView.builder(
      padding: const EdgeInsets.all(DragonSpacing.base),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isUnlocked = tracker.isUnlocked(achievement.id);
        final progress = tracker.getProgress(achievement.id);

        return _AchievementCard(
          achievement: achievement,
          isUnlocked: isUnlocked,
          progress: progress,
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementDef achievement;
  final bool isUnlocked;
  final (int, int)? progress;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DragonSpacing.sm),
      padding: const EdgeInsets.all(DragonSpacing.md),
      decoration: BoxDecoration(
        color: isUnlocked
            ? DragonColors.nightSurface
            : DragonColors.nightSurface.withAlpha(120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? DragonColors.dragonGold
              : DragonColors.nightSurface,
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Badge icon with frame
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ColorFiltered(
                  colorFilter: isUnlocked
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                      : const ColorFilter.matrix(<double>[
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                  child: Image.asset(
                    DragonAssets.badgeFrame,
                    width: 48,
                    height: 48,
                  ),
                ),
                Text(
                  achievement.iconEmoji,
                  style: TextStyle(
                    fontSize: 20,
                    color: isUnlocked ? null : Colors.white24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DragonSpacing.md),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isUnlocked ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isUnlocked ? Colors.white70 : Colors.white24,
                      ),
                ),
                if (progress != null && !isUnlocked) ...[
                  const SizedBox(height: 6),
                  _ProgressBar(
                    current: progress!.$1,
                    target: progress!.$2,
                  ),
                ],
              ],
            ),
          ),
          // Reward badge
          if (isUnlocked)
            const Icon(Icons.check_circle,
                color: DragonColors.emeraldFlame, size: 24)
          else
            Text(
              '+${achievement.scalesReward}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white38,
                    fontFamily: 'JetBrainsMono',
                  ),
            ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int target;

  const _ProgressBar({required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: DragonColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: DragonColors.dragonGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: DragonSpacing.sm),
        Text(
          '$current/$target',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white38,
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
