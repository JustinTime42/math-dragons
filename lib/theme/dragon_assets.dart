/// Centralized asset path constants for all image assets.
class DragonAssets {
  DragonAssets._();

  // -- Dragon portraits (indexed by evolution stage 0-5) --
  static const dragonPortraits = [
    'assets/images/dragons/dragon_egg.png',
    'assets/images/dragons/dragon_hatchling.png',
    'assets/images/dragons/dragon_fledgling.png',
    'assets/images/dragons/dragon_young.png',
    'assets/images/dragons/dragon_adult.png',
    'assets/images/dragons/dragon_elder.png',
  ];

  // -- Dragon hub companions (indexed by evolution stage 0-5) --
  static const dragonHubCompanions = [
    'assets/images/dragons/dragon_egg_hub.png',
    'assets/images/dragons/dragon_hatchling_hub.png',
    'assets/images/dragons/dragon_fledgling_hub.png',
    'assets/images/dragons/dragon_young_hub.png',
    'assets/images/dragons/dragon_adult_hub.png',
    'assets/images/dragons/dragon_elder_hub.png',
  ];

  // -- Hub background --
  static const hubBackground = 'assets/images/hub/hub_background.png';

  // -- Game portal images (hub cards) --
  static const gamePortalImages = <String, String>{
    'dragon_runes': 'assets/images/hub/hub_rune_portal.png',
    'fire_trail': 'assets/images/hub/hub_fire_tunnel.png',
    'dragon_eggs': 'assets/images/hub/hub_egg_nest.png',
    'dragons_feast': 'assets/images/hub/hub_feast_table.png',
  };

  // -- Game backgrounds --
  static const gameBackgrounds = <String, String>{
    'dragon_runes': 'assets/images/games/runes/runes_background.png',
    'fire_trail': 'assets/images/games/fire_trail/fire_trail_background.png',
    'dragon_eggs': 'assets/images/games/dragon_eggs/dragon_eggs_background.png',
    'dragons_feast': 'assets/images/games/dragons_feast/feast_background.png',
  };

  // -- Per-skin Dragon Runes backgrounds --
  static const runesBackgrounds = <String, String>{
    'color_crimson': 'assets/images/games/runes/runes_background_crimson.png',
    'color_sapphire': 'assets/images/games/runes/runes_background_sapphire.png',
    'color_emerald': 'assets/images/games/runes/runes_background_emerald.png',
    'color_amethyst': 'assets/images/games/runes/runes_background_amethyst.png',
    'color_gold': 'assets/images/games/runes/runes_background_gold.png',
    'color_obsidian': 'assets/images/games/runes/runes_background_obsidian.png',
    'color_frost': 'assets/images/games/runes/runes_background_frost.png',
    'color_sunset': 'assets/images/games/runes/runes_background_sunset.png',
  };

  // -- Per-skin Dragon Eggs backgrounds --
  static const dragonEggsBackgrounds = <String, String>{
    'color_crimson': 'assets/images/games/dragon_eggs/dragon_eggs_background_crimson.png',
    'color_sapphire': 'assets/images/games/dragon_eggs/dragon_eggs_background_sapphire.png',
    'color_emerald': 'assets/images/games/dragon_eggs/dragon_eggs_background_emerald.png',
    'color_amethyst': 'assets/images/games/dragon_eggs/dragon_eggs_background_amethyst.png',
    'color_gold': 'assets/images/games/dragon_eggs/dragon_eggs_background_gold.png',
    'color_obsidian': 'assets/images/games/dragon_eggs/dragon_eggs_background_obsidian.png',
    'color_frost': 'assets/images/games/dragon_eggs/dragon_eggs_background_frost.png',
    'color_sunset': 'assets/images/games/dragon_eggs/dragon_eggs_background_sunset.png',
  };

  /// Resolve the Runes background for the player's equipped skin.
  static String resolveRunesBackground(String? equippedColor) =>
      (equippedColor != null ? runesBackgrounds[equippedColor] : null) ??
      gameBackgrounds['dragon_runes']!;

  // -- Background cosmetic images (keyed by bg_* cosmetic ID) --
  static const backgroundImages = <String, String>{
    'bg_crimson': 'assets/images/games/dragon_eggs/dragon_eggs_background_crimson.png',
    'bg_sapphire': 'assets/images/games/dragon_eggs/dragon_eggs_background_sapphire.png',
    'bg_emerald': 'assets/images/games/dragon_eggs/dragon_eggs_background_emerald.png',
    'bg_amethyst': 'assets/images/games/dragon_eggs/dragon_eggs_background_amethyst.png',
    'bg_gold': 'assets/images/games/dragon_eggs/dragon_eggs_background_gold.png',
    'bg_obsidian': 'assets/images/games/dragon_eggs/dragon_eggs_background_obsidian.png',
    'bg_frost': 'assets/images/games/dragon_eggs/dragon_eggs_background_frost.png',
    'bg_sunset': 'assets/images/games/dragon_eggs/dragon_eggs_background_sunset.png',
  };

  /// Resolve the Dragon Eggs background for the player's equipped background.
  static String resolveDragonEggsBackground(String? equippedBackground) =>
      (equippedBackground != null ? backgroundImages[equippedBackground] : null) ??
      gameBackgrounds['dragon_eggs']!;

  // -- Color variant images (keyed by cosmetic ID) --
  static const colorVariantImages = <String, String>{
    'color_crimson': colorVariantCrimson,
    'color_sapphire': colorVariantSapphire,
    'color_emerald': colorVariantEmerald,
    'color_amethyst': colorVariantAmethyst,
    'color_gold': colorVariantGold,
    'color_obsidian': colorVariantObsidian,
    'color_frost': colorVariantFrost,
    'color_sunset': colorVariantSunset,
  };

  static const colorVariantCrimson = 'assets/images/dragons/dragon_color_variant_crimson.png';
  static const colorVariantSapphire = 'assets/images/dragons/dragon_color_variant_sapphire.png';
  static const colorVariantEmerald = 'assets/images/dragons/dragon_color_variant_emerald.png';
  static const colorVariantAmethyst = 'assets/images/dragons/dragon_color_variant_amethyst.png';
  static const colorVariantGold = 'assets/images/dragons/dragon_color_variant_gold.png';
  static const colorVariantObsidian = 'assets/images/dragons/dragon_color_variant_obsidian.png';
  static const colorVariantFrost = 'assets/images/dragons/dragon_color_variant_frost.png';
  static const colorVariantSunset = 'assets/images/dragons/dragon_color_variant_sunset.png';
  static const colorVariantDefault = 'assets/images/dragons/dragon_color_variant_default.png';

  // -- Accessory images (keyed by cosmetic ID) --
  static const accessoryImages = <String, String>{
    'acc_crown': 'assets/images/dragons/acc_crown.png',
    'acc_scarf': 'assets/images/dragons/acc_scarf.png',
    'acc_wizard_hat': 'assets/images/dragons/acc_wizard_hat.png',
    'acc_necklace': 'assets/images/dragons/acc_necklace.png',
    'acc_battle_armor': 'assets/images/dragons/acc_battle_armor.png',
    'acc_wing_decorations': 'assets/images/dragons/acc_wing_decorations.png',
  };

  // -- Dragon's Feast power-up icons --
  static const feastPowerUpFreeze = 'assets/images/games/dragons_feast/feast_powerup_freeze.png';
  static const feastPowerUpWings = 'assets/images/games/dragons_feast/feast_powerup_wings.png';
  static const feastPowerUpShield = 'assets/images/games/dragons_feast/feast_powerup_shield.png';

  // -- UI icons --
  static const iconScale = 'assets/images/ui/icon_scale.png';
  static const iconStreakFlame = 'assets/images/ui/icon_streak_flame.png';
  static const iconStarFilled = 'assets/images/ui/icon_star_filled.png';
  static const iconStarEmpty = 'assets/images/ui/icon_star_empty.png';
  static const badgeFrame = 'assets/images/ui/badge_frame.png';
}
