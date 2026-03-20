/// Positioning data for an accessory on a dragon image.
/// All values are fractions of the dragon image size (0.0–1.0).
class AccessoryAnchor {
  /// X position (0 = left edge, 1 = right edge).
  final double dx;

  /// Y position (0 = top edge, 1 = bottom edge).
  final double dy;

  /// Size relative to the dragon image (e.g. 0.35 = 35% of dragon size).
  final double scale;

  /// If true, render behind the dragon image (used for wings).
  final bool behind;

  /// Rotation in radians (0 for most items).
  final double rotation;

  const AccessoryAnchor({
    required this.dx,
    required this.dy,
    required this.scale,
    this.behind = false,
    this.rotation = 0,
  });
}

/// Per-accessory anchor point data for each dragon image.
class DragonAnchorPoints {
  DragonAnchorPoints._();

  /// Per-accessory anchors: accessoryId → { evolutionStage → anchor }.
  /// Calibrated from visual analysis of hub companion artwork.
  static const accessoryAnchors = <String, Map<int, AccessoryAnchor>>{
    // Crown: thin band sitting directly on skull, between horns
    'acc_crown': {
      1: AccessoryAnchor(dx: 0.33, dy: 0.04, scale: 0.24),
      2: AccessoryAnchor(dx: 0.32, dy: 0.02, scale: 0.23),
      3: AccessoryAnchor(dx: 0.38, dy: 0.01, scale: 0.24),
      4: AccessoryAnchor(dx: 0.35, dy: 0.00, scale: 0.22),
      5: AccessoryAnchor(dx: 0.34, dy: 0.02, scale: 0.22),
    },

    // Wizard Hat: tall pointed hat, brim at skull level, center much higher
    'acc_wizard_hat': {
      1: AccessoryAnchor(dx: 0.32, dy: -0.12, scale: 0.40),
      2: AccessoryAnchor(dx: 0.30, dy: -0.14, scale: 0.38),
      3: AccessoryAnchor(dx: 0.36, dy: -0.14, scale: 0.40),
      4: AccessoryAnchor(dx: 0.34, dy: -0.16, scale: 0.38),
      5: AccessoryAnchor(dx: 0.33, dy: -0.14, scale: 0.38),
    },

    // Scarf: wraps around upper neck / throat area
    'acc_scarf': {
      1: AccessoryAnchor(dx: 0.34, dy: 0.28, scale: 0.30),
      2: AccessoryAnchor(dx: 0.34, dy: 0.24, scale: 0.28),
      3: AccessoryAnchor(dx: 0.38, dy: 0.24, scale: 0.30),
      4: AccessoryAnchor(dx: 0.36, dy: 0.22, scale: 0.28),
      5: AccessoryAnchor(dx: 0.36, dy: 0.22, scale: 0.28),
    },

    // Necklace: pendant hangs at lower neck / upper chest
    'acc_necklace': {
      1: AccessoryAnchor(dx: 0.34, dy: 0.36, scale: 0.24),
      2: AccessoryAnchor(dx: 0.34, dy: 0.32, scale: 0.22),
      3: AccessoryAnchor(dx: 0.38, dy: 0.32, scale: 0.24),
      4: AccessoryAnchor(dx: 0.36, dy: 0.30, scale: 0.22),
      5: AccessoryAnchor(dx: 0.36, dy: 0.30, scale: 0.22),
    },

    // Battle Armor: chest plate covering midsection / torso
    'acc_battle_armor': {
      1: AccessoryAnchor(dx: 0.38, dy: 0.48, scale: 0.34),
      2: AccessoryAnchor(dx: 0.38, dy: 0.44, scale: 0.34),
      3: AccessoryAnchor(dx: 0.40, dy: 0.44, scale: 0.36),
      4: AccessoryAnchor(dx: 0.40, dy: 0.44, scale: 0.36),
      5: AccessoryAnchor(dx: 0.40, dy: 0.44, scale: 0.36),
    },

    // Wing Decorations: wing joint area, rendered behind dragon
    'acc_wing_decorations': {
      1: AccessoryAnchor(dx: 0.62, dy: 0.20, scale: 0.38, behind: true),
      2: AccessoryAnchor(dx: 0.64, dy: 0.16, scale: 0.38, behind: true),
      3: AccessoryAnchor(dx: 0.62, dy: 0.14, scale: 0.40, behind: true),
      4: AccessoryAnchor(dx: 0.60, dy: 0.12, scale: 0.42, behind: true),
      5: AccessoryAnchor(dx: 0.64, dy: 0.10, scale: 0.42, behind: true),
    },
  };

  /// Color variant anchors (bust/head close-ups).
  /// Only head and neck accessories are visible; chest/wings return null.
  static const colorVariantAccessoryAnchors = <String, AccessoryAnchor>{
    'acc_crown': AccessoryAnchor(dx: 0.42, dy: -0.02, scale: 0.28),
    'acc_wizard_hat': AccessoryAnchor(dx: 0.40, dy: -0.18, scale: 0.44),
    'acc_scarf': AccessoryAnchor(dx: 0.42, dy: 0.62, scale: 0.34),
    'acc_necklace': AccessoryAnchor(dx: 0.42, dy: 0.72, scale: 0.26),
    // Battle armor and wing decorations: not visible in bust close-up
  };

  /// Get the anchor for a specific accessory on a specific dragon stage.
  /// Returns null for egg stage (0) or if the accessory has no anchor
  /// for the given configuration (e.g. armor on a color variant bust).
  static AccessoryAnchor? getAccessoryAnchor({
    required String accessoryId,
    required int evolutionStage,
    required bool isColorVariant,
  }) {
    if (evolutionStage == 0) return null;
    if (isColorVariant) return colorVariantAccessoryAnchors[accessoryId];
    return accessoryAnchors[accessoryId]?[evolutionStage.clamp(1, 5)];
  }
}
