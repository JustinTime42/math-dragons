import 'package:flutter/material.dart';
import '../models/cosmetic_catalog.dart';
import '../theme/dragon_anchor_points.dart';
import '../theme/dragon_assets.dart';

/// Displays a dragon preview with equipped cosmetics.
///
/// Accessories are positioned at per-accessory anchor points
/// with correct z-ordering (wings behind, everything else in front).
class CosmeticPreview extends StatelessWidget {
  final int evolutionStage;
  final String? equippedColorId;
  final List<String> equippedAccessoryIds;
  final double size;
  final bool useHubImage;

  const CosmeticPreview({
    super.key,
    required this.evolutionStage,
    this.equippedColorId,
    this.equippedAccessoryIds = const [],
    this.size = 72,
    this.useHubImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageList = useHubImage
        ? DragonAssets.dragonHubCompanions
        : DragonAssets.dragonPortraits;
    final stage = evolutionStage.clamp(0, imageList.length - 1);

    final isColorVariant = equippedColorId != null;
    final dragonImage = isColorVariant
        ? (DragonAssets.colorVariantImages[equippedColorId] ?? imageList[stage])
        : imageList[stage];

    // Find equipped accessories that have images
    final accessoryItems = CosmeticCatalog.accessories
        .where((a) =>
            equippedAccessoryIds.contains(a.id) && a.imagePath != null)
        .toList();

    // Look up per-accessory anchors, filtering out any without anchors
    final accessoriesWithAnchors = <(CosmeticItem, AccessoryAnchor)>[];
    for (final item in accessoryItems) {
      final anchor = DragonAnchorPoints.getAccessoryAnchor(
        accessoryId: item.id,
        evolutionStage: stage,
        isColorVariant: isColorVariant,
      );
      if (anchor != null) accessoriesWithAnchors.add((item, anchor));
    }

    // If no accessories resolved, just show the dragon
    if (accessoriesWithAnchors.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Image.asset(
            dragonImage,
            width: size * 0.83,
            height: size * 0.83,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Split accessories into behind (wings) and front groups
    final behindItems =
        accessoriesWithAnchors.where((e) => e.$2.behind).toList();
    final frontItems =
        accessoriesWithAnchors.where((e) => !e.$2.behind).toList();

    final dragonSize = size * 0.83;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Layer 1: Behind accessories (wings)
          for (final (item, anchor) in behindItems)
            _buildAccessoryWidget(item, anchor, dragonSize),

          // Layer 2: Dragon image
          Center(
            child: Image.asset(
              dragonImage,
              width: dragonSize,
              height: dragonSize,
              fit: BoxFit.contain,
            ),
          ),

          // Layer 3: Front accessories (head, neck, chest)
          for (final (item, anchor) in frontItems)
            _buildAccessoryWidget(item, anchor, dragonSize),
        ],
      ),
    );
  }

  Widget _buildAccessoryWidget(
    CosmeticItem item,
    AccessoryAnchor anchor,
    double dragonSize,
  ) {
    final accSize = dragonSize * anchor.scale;

    // Calculate position: anchor dx/dy are fractions of dragon size,
    // offset so the accessory centers on the anchor point.
    // The dragon is centered in the SizedBox, so we offset from the
    // dragon's top-left corner.
    final dragonOffset = (size - dragonSize) / 2;
    final left = dragonOffset + (anchor.dx * dragonSize) - (accSize / 2);
    final top = dragonOffset + (anchor.dy * dragonSize) - (accSize / 2);

    Widget child = Image.asset(
      item.imagePath!,
      width: accSize,
      height: accSize,
      fit: BoxFit.contain,
    );

    if (anchor.rotation != 0) {
      child = Transform.rotate(angle: anchor.rotation, child: child);
    }

    return Positioned(
      left: left,
      top: top,
      child: child,
    );
  }
}
