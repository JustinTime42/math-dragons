import 'package:flutter/material.dart';
import '../theme/dragon_assets.dart';

/// Where an accessory attaches on the dragon's body.
enum AccessorySlot { headTop, neck, chest, wings }

/// Cosmetic item definition.
class CosmeticItem {
  final String id;
  final String name;
  final CosmeticType type;
  final int cost;
  final String previewEmoji;
  final Color? previewColor;
  final String? imagePath;
  final AccessorySlot? slot;

  /// Aura render style for [CosmeticType.effect] items. Null for other types.
  /// The aura is tinted with [previewColor].
  final AuraStyle? auraStyle;

  const CosmeticItem({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.previewEmoji,
    this.previewColor,
    this.imagePath,
    this.slot,
    this.auraStyle,
  });
}

enum CosmeticType { color, accessory, background, effect }

/// Visual style for a non-occluding aura [CosmeticType.effect].
///
/// Effects render as a soft glow behind the dragon and never intersect the
/// dragon silhouette, so they sidestep the perspective/occlusion problem that
/// worn accessories have on the 3/4 painterly art. See
/// `docs/step12/ACCESSORY_PIPELINE_DECISION.md` (Track D).
enum AuraStyle { glow }

/// All available cosmetics.
class CosmeticCatalog {
  static const colors = [
    CosmeticItem(
        id: 'color_crimson',
        name: 'Crimson',
        type: CosmeticType.color,
        cost: 50,
        previewEmoji: '\u{1F525}',
        previewColor: Color(0xFFDC143C),
        imagePath: DragonAssets.colorVariantCrimson),
    CosmeticItem(
        id: 'color_sapphire',
        name: 'Sapphire',
        type: CosmeticType.color,
        cost: 75,
        previewEmoji: '\u{1F48E}',
        previewColor: Color(0xFF0F52BA),
        imagePath: DragonAssets.colorVariantSapphire),
    CosmeticItem(
        id: 'color_emerald',
        name: 'Emerald',
        type: CosmeticType.color,
        cost: 75,
        previewEmoji: '\u{1F48E}',
        previewColor: Color(0xFF50C878),
        imagePath: DragonAssets.colorVariantEmerald),
    CosmeticItem(
        id: 'color_amethyst',
        name: 'Amethyst',
        type: CosmeticType.color,
        cost: 100,
        previewEmoji: '\u{1F48E}',
        previewColor: Color(0xFF9966CC),
        imagePath: DragonAssets.colorVariantAmethyst),
    CosmeticItem(
        id: 'color_gold',
        name: 'Golden',
        type: CosmeticType.color,
        cost: 150,
        previewEmoji: '\u{2728}',
        previewColor: Color(0xFFFFD700),
        imagePath: DragonAssets.colorVariantGold),
    CosmeticItem(
        id: 'color_obsidian',
        name: 'Obsidian',
        type: CosmeticType.color,
        cost: 150,
        previewEmoji: '\u{1F311}',
        previewColor: Color(0xFF1C1C1C),
        imagePath: DragonAssets.colorVariantObsidian),
    CosmeticItem(
        id: 'color_frost',
        name: 'Frost',
        type: CosmeticType.color,
        cost: 100,
        previewEmoji: '\u{2744}',
        previewColor: Color(0xFFADD8E6),
        imagePath: DragonAssets.colorVariantFrost),
    CosmeticItem(
        id: 'color_sunset',
        name: 'Sunset',
        type: CosmeticType.color,
        cost: 200,
        previewEmoji: '\u{1F305}',
        previewColor: Color(0xFFFF6347),
        imagePath: DragonAssets.colorVariantSunset),
  ];

  static const accessories = [
    CosmeticItem(
        id: 'acc_crown',
        name: 'Crown',
        type: CosmeticType.accessory,
        cost: 300,
        previewEmoji: '\u{1F451}',
        imagePath: 'assets/images/dragons/acc_crown.png',
        slot: AccessorySlot.headTop),
    CosmeticItem(
        id: 'acc_scarf',
        name: 'Scarf',
        type: CosmeticType.accessory,
        cost: 150,
        previewEmoji: '\u{1F9E3}',
        imagePath: 'assets/images/dragons/acc_scarf.png',
        slot: AccessorySlot.neck),
    CosmeticItem(
        id: 'acc_wizard_hat',
        name: 'Wizard Hat',
        type: CosmeticType.accessory,
        cost: 200,
        previewEmoji: '\u{1F9D9}',
        imagePath: 'assets/images/dragons/acc_wizard_hat.png',
        slot: AccessorySlot.headTop),
    CosmeticItem(
        id: 'acc_necklace',
        name: 'Necklace',
        type: CosmeticType.accessory,
        cost: 100,
        previewEmoji: '\u{1F4FF}',
        imagePath: 'assets/images/dragons/acc_necklace.png',
        slot: AccessorySlot.neck),
    CosmeticItem(
        id: 'acc_battle_armor',
        name: 'Battle Armor',
        type: CosmeticType.accessory,
        cost: 500,
        previewEmoji: '\u{1F6E1}',
        imagePath: 'assets/images/dragons/acc_battle_armor.png',
        slot: AccessorySlot.chest),
    CosmeticItem(
        id: 'acc_wing_decorations',
        name: 'Wing Decorations',
        type: CosmeticType.accessory,
        cost: 100,
        previewEmoji: '\u{1FAB6}',
        imagePath: 'assets/images/dragons/acc_wing_decorations.png',
        slot: AccessorySlot.wings),
  ];

  static const backgrounds = [
    CosmeticItem(
        id: 'bg_crimson',
        name: 'Volcanic Landscape',
        type: CosmeticType.background,
        cost: 75,
        previewEmoji: '\u{1F30B}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_crimson.png'),
    CosmeticItem(
        id: 'bg_sapphire',
        name: 'Deep Sea Cavern',
        type: CosmeticType.background,
        cost: 75,
        previewEmoji: '\u{1F30A}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_sapphire.png'),
    CosmeticItem(
        id: 'bg_emerald',
        name: 'Jungle Ruins',
        type: CosmeticType.background,
        cost: 100,
        previewEmoji: '\u{1F33F}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_emerald.png'),
    CosmeticItem(
        id: 'bg_amethyst',
        name: 'Crystal Cave',
        type: CosmeticType.background,
        cost: 100,
        previewEmoji: '\u{1F52E}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_amethyst.png'),
    CosmeticItem(
        id: 'bg_gold',
        name: 'Golden Desert',
        type: CosmeticType.background,
        cost: 125,
        previewEmoji: '\u{1F3DC}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_gold.png'),
    CosmeticItem(
        id: 'bg_obsidian',
        name: 'Shadow Mountain',
        type: CosmeticType.background,
        cost: 125,
        previewEmoji: '\u{26F0}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_obsidian.png'),
    CosmeticItem(
        id: 'bg_frost',
        name: 'Frozen Tundra',
        type: CosmeticType.background,
        cost: 150,
        previewEmoji: '\u{2744}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_frost.png'),
    CosmeticItem(
        id: 'bg_sunset',
        name: 'Desert Canyon',
        type: CosmeticType.background,
        cost: 150,
        previewEmoji: '\u{1F305}',
        imagePath: 'assets/images/games/dragon_eggs/dragon_eggs_background_sunset.png'),
  ];

  /// Non-occluding aura effects. These render as a soft glow behind the dragon
  /// and never touch the dragon silhouette, so they need no per-stage or
  /// per-skin art and are code-drawn at runtime (see [AuraStyle]).
  static const effects = [
    CosmeticItem(
        id: 'effect_ember_aura',
        name: 'Ember Aura',
        type: CosmeticType.effect,
        cost: 200,
        previewEmoji: '\u{1F525}',
        previewColor: Color(0xFFFF7A18),
        auraStyle: AuraStyle.glow),
    CosmeticItem(
        id: 'effect_frost_aura',
        name: 'Frost Aura',
        type: CosmeticType.effect,
        cost: 200,
        previewEmoji: '\u{2744}',
        previewColor: Color(0xFF7EC8FF),
        auraStyle: AuraStyle.glow),
    CosmeticItem(
        id: 'effect_arcane_aura',
        name: 'Arcane Aura',
        type: CosmeticType.effect,
        cost: 250,
        previewEmoji: '\u{2728}',
        previewColor: Color(0xFFB57EFF),
        auraStyle: AuraStyle.glow),
  ];

  /// Find a cosmetic item by ID across all cosmetic categories.
  static CosmeticItem? findById(String id) {
    for (final item in colors) {
      if (item.id == id) return item;
    }
    for (final item in accessories) {
      if (item.id == id) return item;
    }
    for (final item in backgrounds) {
      if (item.id == id) return item;
    }
    for (final item in effects) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Toggle [item] in the equipped-accessory list, enforcing the equip rules:
  /// at most one item per [AccessorySlot], and at most one aura
  /// [CosmeticType.effect] at a time. Returns a new list; does not mutate
  /// [current]. Shared by the store and customize screens.
  static List<String> toggleEquipped(List<String> current, CosmeticItem item) {
    final next = List<String>.from(current);
    if (next.contains(item.id)) {
      next.remove(item.id);
      return next;
    }
    if (item.type == CosmeticType.effect) {
      // Only one aura may be equipped at a time.
      next.removeWhere((id) => findById(id)?.type == CosmeticType.effect);
    } else if (item.slot != null) {
      // Only one accessory per body slot.
      next.removeWhere((id) => findById(id)?.slot == item.slot);
    }
    next.add(item.id);
    return next;
  }
}
