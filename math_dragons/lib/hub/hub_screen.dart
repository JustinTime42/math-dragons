import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../storage/local_storage.dart';
import '../core/audio_service.dart';
import 'game_card.dart';
import 'profile_bar.dart';
import 'dragon_companion.dart';
import 'daily_challenge_card.dart';
import 'achievement_screen.dart';
import '../monetization/store_screen.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AudioService>().playHubMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storage = context.read<LocalStorage>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.lairGradient,
          image: DecorationImage(
            image: AssetImage(DragonAssets.hubBackground),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: storage.profileNotifier,
            builder: (context, profile, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile bar at top
                    const ProfileBar(),

                    const SizedBox(height: DragonSpacing.sm),

                    // Hub title
                    Text(
                      l10n.hubTitle,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                    const SizedBox(height: DragonSpacing.base),

                    // Dragon companion (animated, tap to customize)
                    DragonCompanion(
                      evolutionStage: profile.dragonEvolution,
                      equippedColorId: profile.equippedColor,
                      equippedAccessoryIds: profile.equippedAccessories,
                      equippedBackground: profile.equippedBackground,
                      onTap: () => Navigator.pushNamed(context, '/customize'),
                    ),

                    const SizedBox(height: DragonSpacing.sm),

                    // Achievement and Store quick-access row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DragonSpacing.base,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickAccessButton(
                              icon: Icons.emoji_events,
                              label: 'Achievements',
                              color: DragonColors.dragonGold,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AchievementScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: DragonSpacing.sm),
                          Expanded(
                            child: _QuickAccessButton(
                              icon: Icons.store,
                              label: 'Dragon Store',
                              color: DragonColors.amethyst,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StoreScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: DragonSpacing.base),

                    // Game cards grid
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DragonSpacing.base,
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: DragonSpacing.sm,
                        mainAxisSpacing: DragonSpacing.sm,
                        childAspectRatio: 0.62,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _buildGameCards(l10n, profile),
                      ),
                    ),

                    const SizedBox(height: DragonSpacing.lg),

                    // Daily challenge card
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DragonSpacing.base,
                      ),
                      child: DailyChallengeCard(),
                    ),

                    const SizedBox(height: DragonSpacing.lg),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGameCards(AppLocalizations l10n, dynamic profile) {
    final games = [
      (
        id: 'dragon_runes',
        title: l10n.dragonRunes,
        desc: l10n.dragonRunesDescription,
        color: DragonColors.runesAccent,
      ),
      (
        id: 'fire_trail',
        title: l10n.fireTrail,
        desc: l10n.fireTrailDescription,
        color: DragonColors.fireTrailAccent,
      ),
      (
        id: 'dragon_eggs',
        title: l10n.dragonEggs,
        desc: l10n.dragonEggsDescription,
        color: DragonColors.dragonEggsAccent,
      ),
      (
        id: 'dragons_feast',
        title: l10n.dragonsFeast,
        desc: l10n.dragonsFeastDescription,
        color: DragonColors.dragonsFeastAccent,
      ),
    ];

    return games.map((g) {
      final stats = profile.gameStats[g.id];
      return GameCard(
        gameId: g.id,
        title: g.title,
        description: g.desc,
        accentColor: g.color,
        imagePath: DragonAssets.gamePortalImages[g.id]!,
        level: stats?.currentLevel ?? 1,
        totalStars: stats?.totalStars ?? 0,
        timesPlayed: stats?.timesPlayed ?? 0,
      );
    }).toList();
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DragonSpacing.md,
          vertical: DragonSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: DragonSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
