"""Batch post-processing script for all 69 raw generated images."""

import sys
from pathlib import Path

# Add this directory to path
sys.path.insert(0, str(Path(__file__).parent))

PROJECT_ROOT = Path(__file__).parent.parent.parent

from post_process import remove_background, resize_image, compress_png

def process(raw_name: str, output_dir: str, output_name: str, target_size: str, remove_bg: bool = True):
    """Process a single raw image: remove bg -> resize -> compress."""
    raw_path = PROJECT_ROOT / "assets" / "images" / "raw" / raw_name
    out_dir = PROJECT_ROOT / output_dir
    out_path = out_dir / output_name
    out_dir.mkdir(parents=True, exist_ok=True)

    if not raw_path.exists():
        print(f"  SKIP (missing): {raw_name}")
        return False

    current = str(raw_path)

    # Step 1: Background removal
    if remove_bg:
        print(f"  Removing background...")
        result = remove_background(current)
        current = result["path"]

    # Step 2: Resize
    print(f"  Resizing to {target_size}...")
    results = resize_image(current, target_size, str(out_dir))
    main_file = Path(results[0]["path"])
    if main_file != out_path:
        import shutil
        shutil.move(str(main_file), str(out_path))

    # Step 3: Compress
    print(f"  Compressing...")
    compress_png(str(out_path), quality="80-95")

    size_kb = out_path.stat().st_size / 1024
    print(f"  Done: {out_path.name} ({size_kb:.1f} KB)")
    return True


# All 69 assets to process
ASSETS = [
    # Dragon portraits (remove bg, 512x512)
    ("dragon_egg.png", "assets/images/dragons", "dragon_egg.png", "512x512", True),
    ("dragon_hatchling.png", "assets/images/dragons", "dragon_hatchling.png", "512x512", True),
    ("dragon_fledgling.png", "assets/images/dragons", "dragon_fledgling.png", "512x512", True),
    ("dragon_young.png", "assets/images/dragons", "dragon_young.png", "512x512", True),
    ("dragon_adult.png", "assets/images/dragons", "dragon_adult.png", "512x512", True),
    ("dragon_elder.png", "assets/images/dragons", "dragon_elder.png", "512x512", True),

    # Dragon hub companions (remove bg, 256x256)
    ("dragon_egg_hub.png", "assets/images/dragons", "dragon_egg_hub.png", "256x256", True),
    ("dragon_hatchling_hub.png", "assets/images/dragons", "dragon_hatchling_hub.png", "256x256", True),
    ("dragon_fledgling_hub.png", "assets/images/dragons", "dragon_fledgling_hub.png", "256x256", True),
    ("dragon_young_hub.png", "assets/images/dragons", "dragon_young_hub.png", "256x256", True),
    ("dragon_adult_hub.png", "assets/images/dragons", "dragon_adult_hub.png", "256x256", True),
    ("dragon_elder_hub.png", "assets/images/dragons", "dragon_elder_hub.png", "256x256", True),

    # Hub background (NO bg removal, 1920x1080)
    ("hub_background.png", "assets/images/hub", "hub_background.png", "1920x1080", False),

    # Hub portals (remove bg, 256x256)
    ("hub_rune_portal.png", "assets/images/hub", "hub_rune_portal.png", "256x256", True),
    ("hub_fire_tunnel.png", "assets/images/hub", "hub_fire_tunnel.png", "256x256", True),
    ("hub_egg_nest.png", "assets/images/hub", "hub_egg_nest.png", "256x256", True),
    ("hub_feast_table.png", "assets/images/hub", "hub_feast_table.png", "256x256", True),

    # Game backgrounds (NO bg removal, 1920x1080)
    ("runes_background.png", "assets/images/games/runes", "runes_background.png", "1920x1080", False),
    ("fire_trail_background.png", "assets/images/games/fire_trail", "fire_trail_background.png", "1920x1080", False),
    ("dragon_eggs_background.png", "assets/images/games/dragon_eggs", "dragon_eggs_background.png", "1920x1080", False),
    ("feast_background.png", "assets/images/games/dragons_feast", "feast_background.png", "1920x1080", False),

    # Runes game assets (remove bg, various sizes)
    ("rune_node_inactive.png", "assets/images/games/runes", "rune_node_inactive.png", "64x64", True),
    ("rune_node_active.png", "assets/images/games/runes", "rune_node_active.png", "64x64", True),
    ("rune_spell_particle.png", "assets/images/games/runes", "rune_spell_particle.png", "32x32", True),

    # Fire Trail game assets (remove bg, various sizes)
    ("fire_dragon_head.png", "assets/images/games/fire_trail", "fire_dragon_head.png", "64x64", True),
    ("fire_gem_correct.png", "assets/images/games/fire_trail", "fire_gem_correct.png", "48x48", True),
    ("fire_gem_wrong.png", "assets/images/games/fire_trail", "fire_gem_wrong.png", "48x48", True),

    # Dragon Eggs game assets (remove bg, various sizes)
    ("egg_cream.png", "assets/images/games/dragon_eggs", "egg_cream.png", "64x64", True),
    ("egg_blue.png", "assets/images/games/dragon_eggs", "egg_blue.png", "64x64", True),
    ("egg_green.png", "assets/images/games/dragon_eggs", "egg_green.png", "64x64", True),
    ("egg_orange.png", "assets/images/games/dragon_eggs", "egg_orange.png", "64x64", True),
    ("egg_operator.png", "assets/images/games/dragon_eggs", "egg_operator.png", "64x64", True),
    ("egg_division.png", "assets/images/games/dragon_eggs", "egg_division.png", "64x64", True),
    ("egg_crack_1.png", "assets/images/games/dragon_eggs", "egg_crack_1.png", "64x64", True),
    ("egg_crack_2.png", "assets/images/games/dragon_eggs", "egg_crack_2.png", "64x64", True),
    ("baby_dragon_fly.png", "assets/images/games/dragon_eggs", "baby_dragon_fly.png", "48x48", True),

    # Dragon's Feast game assets (remove bg, various sizes)
    ("feast_dragon.png", "assets/images/games/dragons_feast", "feast_dragon.png", "64x64", True),
    ("feast_enemy_guardian.png", "assets/images/games/dragons_feast", "feast_enemy_guardian.png", "64x64", True),
    ("feast_gem_blue.png", "assets/images/games/dragons_feast", "feast_gem_blue.png", "48x48", True),
    ("feast_gem_purple.png", "assets/images/games/dragons_feast", "feast_gem_purple.png", "48x48", True),
    ("feast_gem_gold.png", "assets/images/games/dragons_feast", "feast_gem_gold.png", "48x48", True),
    ("feast_gem_teal.png", "assets/images/games/dragons_feast", "feast_gem_teal.png", "48x48", True),
    ("feast_gem_red.png", "assets/images/games/dragons_feast", "feast_gem_red.png", "48x48", True),
    ("feast_gem_green.png", "assets/images/games/dragons_feast", "feast_gem_green.png", "48x48", True),
    ("feast_powerup_freeze.png", "assets/images/games/dragons_feast", "feast_powerup_freeze.png", "48x48", True),
    ("feast_powerup_wings.png", "assets/images/games/dragons_feast", "feast_powerup_wings.png", "48x48", True),
    ("feast_powerup_shield.png", "assets/images/games/dragons_feast", "feast_powerup_shield.png", "48x48", True),

    # UI elements
    ("app_icon.png", "assets/images/ui", "app_icon.png", "1024x1024", False),  # No bg removal for app icon
    ("badge_frame.png", "assets/images/ui", "badge_frame.png", "64x64", True),
    ("icon_star_filled.png", "assets/images/ui", "icon_star_filled.png", "32x32", True),
    ("icon_star_empty.png", "assets/images/ui", "icon_star_empty.png", "32x32", True),
    ("icon_scale.png", "assets/images/ui", "icon_scale.png", "32x32", True),
    ("icon_streak_flame.png", "assets/images/ui", "icon_streak_flame.png", "24x24", True),
    ("feature_graphic.png", "assets/images/ui", "feature_graphic.png", "1024x500", False),  # No bg removal

    # Dragon color variants (remove bg, 128x128)
    ("dragon_color_variant_crimson.png", "assets/images/dragons", "dragon_color_variant_crimson.png", "128x128", True),
    ("dragon_color_variant_sapphire.png", "assets/images/dragons", "dragon_color_variant_sapphire.png", "128x128", True),
    ("dragon_color_variant_emerald.png", "assets/images/dragons", "dragon_color_variant_emerald.png", "128x128", True),
    ("dragon_color_variant_amethyst.png", "assets/images/dragons", "dragon_color_variant_amethyst.png", "128x128", True),
    ("dragon_color_variant_gold.png", "assets/images/dragons", "dragon_color_variant_gold.png", "128x128", True),
    ("dragon_color_variant_obsidian.png", "assets/images/dragons", "dragon_color_variant_obsidian.png", "128x128", True),
    ("dragon_color_variant_frost.png", "assets/images/dragons", "dragon_color_variant_frost.png", "128x128", True),
    ("dragon_color_variant_sunset.png", "assets/images/dragons", "dragon_color_variant_sunset.png", "128x128", True),

    # Accessories (remove bg, 64x64)
    ("acc_crown.png", "assets/images/dragons", "acc_crown.png", "64x64", True),
    ("acc_scarf.png", "assets/images/dragons", "acc_scarf.png", "64x64", True),
    ("acc_battle_armor.png", "assets/images/dragons", "acc_battle_armor.png", "64x64", True),
    ("acc_wizard_hat.png", "assets/images/dragons", "acc_wizard_hat.png", "64x64", True),
    ("acc_necklace.png", "assets/images/dragons", "acc_necklace.png", "64x64", True),
    ("acc_wing_decorations.png", "assets/images/dragons", "acc_wing_decorations.png", "64x64", True),
]


if __name__ == "__main__":
    print(f"Processing {len(ASSETS)} assets...")
    print(f"Project root: {PROJECT_ROOT}")
    print()

    success = 0
    failed = 0
    for i, (raw, outdir, outname, size, rmbg) in enumerate(ASSETS, 1):
        print(f"[{i}/{len(ASSETS)}] {raw} -> {outname} ({size})")
        try:
            if process(raw, outdir, outname, size, rmbg):
                success += 1
            else:
                failed += 1
        except Exception as e:
            print(f"  ERROR: {e}")
            failed += 1
        print()

    print(f"Done! {success} succeeded, {failed} failed out of {len(ASSETS)} total.")
