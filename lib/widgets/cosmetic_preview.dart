import 'package:flutter/material.dart';
import '../models/cosmetic_catalog.dart';
import '../theme/dragon_anchor_points.dart';
import '../theme/dragon_assets.dart';
import 'dragon_aura.dart';

/// Displays a dragon preview with equipped cosmetics.
///
/// Posed accessories are full-canvas layers registered to the dragon template.
/// Their source pixels already omit portions hidden behind dragon anatomy.
class CosmeticPreview extends StatelessWidget {
  final int evolutionStage;
  final String? equippedColorId;
  final List<String> equippedAccessoryIds;
  final double size;
  final bool useHubImage;
  final DragonRenderContext? renderContext;

  const CosmeticPreview({
    super.key,
    required this.evolutionStage,
    this.equippedColorId,
    this.equippedAccessoryIds = const [],
    this.size = 72,
    this.useHubImage = false,
    this.renderContext,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedContext =
        renderContext ??
        (useHubImage ? DragonRenderContext.hub : DragonRenderContext.portrait);
    final stage = evolutionStage.clamp(
      0,
      DragonAssets.dragonPortraits.length - 1,
    );
    final dragonImage = DragonAssets.resolveDragonImage(
      evolutionStage: stage,
      context: resolvedContext,
      skinId: equippedColorId,
    );

    // Posed accessory layers are generated only for wearable stages.
    final accessoryItems = CosmeticCatalog.accessories
        .where(
          (a) =>
              stage > 0 &&
              equippedAccessoryIds.contains(a.id) &&
              a.imagePath != null,
        )
        .toList();

    // Non-occluding aura effects render behind the dragon at any stage. They
    // never touch the silhouette, so no per-stage/per-skin art is needed.
    final effectItems = CosmeticCatalog.effects
        .where((e) => equippedAccessoryIds.contains(e.id))
        .toList();

    final dragonWidget = Center(
      child: Image.asset(
        dragonImage,
        width: size * 0.83,
        height: size * 0.83,
        fit: BoxFit.contain,
      ),
    );

    if (accessoryItems.isEmpty && effectItems.isEmpty) {
      return SizedBox(width: size, height: size, child: dragonWidget);
    }

    final dragonSize = size * 0.83;
    final dragonOffset = (size - dragonSize) / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final item in effectItems)
            Center(
              child: DragonAura(
                color: item.previewColor ?? Colors.white,
                size: size,
              ),
            ),

          dragonWidget,

          for (final item in accessoryItems)
            _buildRegisteredAccessoryLayer(
              item,
              stage,
              dragonSize,
              dragonOffset,
              resolvedContext,
            ),
        ],
      ),
    );
  }

  Widget _buildRegisteredAccessoryLayer(
    CosmeticItem item,
    int stage,
    double layerSize,
    double layerOffset,
    DragonRenderContext renderContext,
  ) {
    final accessoryImage = DragonAssets.resolveAccessoryImage(
      accessoryId: item.id,
      evolutionStage: stage,
      context: renderContext,
      skinId: equippedColorId,
    );
    final fallbackAccessoryImage = DragonAssets.resolveAccessoryImage(
      accessoryId: item.id,
      evolutionStage: stage,
      context: renderContext,
    );
    return Positioned(
      left: layerOffset,
      top: layerOffset,
      width: layerSize,
      height: layerSize,
      child: Image.asset(
        accessoryImage,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(fallbackAccessoryImage, fit: BoxFit.contain),
      ),
    );
  }
}
