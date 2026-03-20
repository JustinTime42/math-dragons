import 'package:flutter/material.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../widgets/cosmetic_preview.dart';

/// Animated dragon companion for the hub screen.
/// Shows a pulsing dragon image based on evolution stage.
/// Replaced with Rive animation in Step 12.
class DragonCompanion extends StatefulWidget {
  final int evolutionStage;
  final VoidCallback? onTap;
  final String? equippedColorId;
  final List<String> equippedAccessoryIds;
  final String? equippedBackground;

  const DragonCompanion({
    super.key,
    this.evolutionStage = 0,
    this.onTap,
    this.equippedColorId,
    this.equippedAccessoryIds = const [],
    this.equippedBackground,
  });

  @override
  State<DragonCompanion> createState() => _DragonCompanionState();
}

class _DragonCompanionState extends State<DragonCompanion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnimation;
  late final Animation<double> _glowAnimation;

  static const _evolutionSizes = [64.0, 72.0, 80.0, 88.0, 96.0, 104.0];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    // Subtle scale breathing: 1.0 -> 1.03
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Glow opacity pulsing: 0.1 -> 0.25
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.25).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.evolutionStage.clamp(0, DragonAssets.dragonHubCompanions.length - 1);
    final size = _evolutionSizes[stage];

    final hasBg = widget.equippedBackground != null;
    final bgPath = hasBg
        ? DragonAssets.backgroundImages[widget.equippedBackground!]
        : null;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _breathController,
        builder: (context, child) {
          return Transform.scale(
            scale: _breathAnimation.value,
            child: hasBg && bgPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: size + 80,
                      height: size + 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(bgPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: CosmeticPreview(
                          evolutionStage: widget.evolutionStage,
                          equippedColorId: widget.equippedColorId,
                          equippedAccessoryIds: widget.equippedAccessoryIds,
                          useHubImage: true,
                          size: size,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: size + 32,
                    height: size + 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: DragonColors.dragonGold
                              .withValues(alpha: _glowAnimation.value),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CosmeticPreview(
                        evolutionStage: widget.evolutionStage,
                        equippedColorId: widget.equippedColorId,
                        equippedAccessoryIds: widget.equippedAccessoryIds,
                        useHubImage: true,
                        size: size,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
