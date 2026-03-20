import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/achievement.dart';
import '../core/haptics.dart';
import '../core/audio_service.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Overlay widget that manages achievement popup display.
///
/// Wrap this around the main app scaffold. When an achievement unlocks,
/// the popup slides down from the top, holds for 2 seconds, and slides up.
class AchievementPopupOverlay extends StatefulWidget {
  final Widget child;

  const AchievementPopupOverlay({super.key, required this.child});

  /// Show an achievement popup from anywhere in the widget tree.
  static void show(BuildContext context, AchievementDef achievement) {
    final state =
        context.findAncestorStateOfType<AchievementPopupOverlayState>();
    state?.enqueue(achievement);
  }

  @override
  State<AchievementPopupOverlay> createState() =>
      AchievementPopupOverlayState();
}

class AchievementPopupOverlayState extends State<AchievementPopupOverlay>
    with SingleTickerProviderStateMixin {
  final List<AchievementDef> _queue = [];
  AchievementDef? _current;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  void enqueue(AchievementDef achievement) {
    _queue.add(achievement);
    if (_current == null) _showNext();
  }

  Future<void> _showNext() async {
    if (_queue.isEmpty) {
      setState(() => _current = null);
      return;
    }

    setState(() => _current = _queue.removeAt(0));

    // Haptic + audio feedback
    final haptics =
        context.mounted ? context.read<HapticsService>() : null;
    haptics?.onAchievementUnlocked();
    final audio =
        context.mounted ? context.read<AudioService>() : null;
    audio?.playAchievement();

    // Slide in
    await _controller.forward();

    // Hold for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Slide out
    await _controller.reverse();

    // Show next in queue (if any)
    _showNext();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_current != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + DragonSpacing.sm,
            left: DragonSpacing.base,
            right: DragonSpacing.base,
            child: SlideTransition(
              position: _slideAnimation,
              child: _AchievementBanner(achievement: _current!),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AchievementBanner extends StatelessWidget {
  final AchievementDef achievement;

  const _AchievementBanner({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.base,
        vertical: DragonSpacing.md,
      ),
      decoration: BoxDecoration(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DragonColors.dragonGold, width: 2),
        boxShadow: [
          BoxShadow(
            color: DragonColors.dragonGold.withAlpha(60),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Achievement badge with frame
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  DragonAssets.badgeFrame,
                  width: 48,
                  height: 48,
                ),
                Text(
                  achievement.iconEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(width: DragonSpacing.md),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Achievement Unlocked!',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DragonColors.dragonGold,
                        letterSpacing: 1.0,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Scales reward
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: DragonColors.dragonGold.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '+${achievement.scalesReward}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DragonColors.dragonGold,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrainsMono',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
