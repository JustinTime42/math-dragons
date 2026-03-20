"""Regenerate all dragon images with native transparent backgrounds.

Uses GPT-Image-1 with background="transparent" to get clean alpha channels,
eliminating the need for rembg post-processing.
"""

import sys
import shutil
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from dotenv import load_dotenv
load_dotenv(Path(__file__).parent / ".env")

from image_gen import generate_image
from post_process import resize_image, compress_png

PROJECT_ROOT = Path(__file__).parent.parent.parent

STYLE_PREFIX = (
    "Art style: stylized semi-realistic cartoon, digital painting, game asset "
    "quality. Detailed dragon scales with warm highlights, expressive features, "
    "rich fantasy color palette. Deep purple (#2D1B69) and warm gold (#F4A261) "
    "dominant colors, emerald (#2A9D8F) and fire orange (#E76F51) accents. "
    "Wings of Fire book cover meets Clash Royale character design quality. "
    "Warm, inviting, NOT chibi, NOT baby-cute, NOT grimdark. Appealing to "
    "ages 7-14. "
)

# All dragon images to regenerate: (raw_name, prompt, output_dir, output_name, target_size)
DRAGONS = [
    # === Evolution Portraits (512x512) ===
    (
        "dragon_egg.png",
        STYLE_PREFIX + (
            "A large dragon egg centered in the frame as a character portrait. "
            "The egg is oval-shaped with a deep purple (#2D1B69) shell covered "
            "in swirling veins of warm gold (#F4A261) that appear to pulse with "
            "inner magical light. Faint emerald (#2A9D8F) energy seeps through "
            "hairline cracks on the surface. The egg rests on a small nest of "
            "golden coins and purple crystals. Warm amber glow emanates from "
            "inside the egg. Isolated subject, clean edges, centered composition. "
            "Digital painting, game character portrait format."
        ),
        "assets/images/dragons", "dragon_egg.png", "512x512",
    ),
    (
        "dragon_hatchling.png",
        STYLE_PREFIX + (
            "A tiny dragon hatchling as a character portrait, freshly emerged "
            "from an egg. The hatchling is small with a round body covered in "
            "soft deep purple (#2D1B69) scales and a warm gold (#F4A261) "
            "underbelly. It has oversized but expressive amber-gold eyes, small "
            "curved horns just beginning to grow, and stubby wings that are "
            "still folded close to its body. A single wisp of smoke curls from "
            "one nostril. Broken eggshell fragments lie at its feet. The "
            "expression is curious and alert, not babyish. Isolated subject, "
            "clean edges. Digital painting, game character portrait, warm lighting."
        ),
        "assets/images/dragons", "dragon_hatchling.png", "512x512",
    ),
    (
        "dragon_fledgling.png",
        STYLE_PREFIX + (
            "A fledgling dragon character portrait. The dragon is about the "
            "size of a large cat, with increasingly defined deep purple "
            "(#2D1B69) scales and more prominent gold (#F4A261) underbelly "
            "markings. Its wings are partially unfurled, showing translucent "
            "purple membrane. The horns are slightly longer and more curved. "
            "A small flame flickers from its open mouth, tinged with orange "
            "(#E76F51). Its amber-gold eyes show a confident, determined "
            "expression. The dragon is perched on a stone ledge in a "
            "three-quarter pose. Isolated subject, clean edges. Digital "
            "painting, game character portrait."
        ),
        "assets/images/dragons", "dragon_fledgling.png", "512x512",
    ),
    (
        "dragon_young.png",
        STYLE_PREFIX + (
            "A young dragon in a heroic character portrait. The dragon is now "
            "in full recognizable dragon form -- medium-sized, muscular but "
            "lean, with powerful deep purple (#2D1B69) scales that shimmer in "
            "warm light. Wings are fully formed and spread wide, showing "
            "detailed purple membrane with veins of gold (#F4A261). Curved "
            "horns are elegant and prominent. The dragon breathes a stream of "
            "bright orange (#E76F51) and gold fire. Its underbelly displays "
            "clearly defined gold scales. Fierce, confident amber-gold eyes. "
            "Claws grip a rocky outcrop. Isolated subject, clean edges. "
            "Digital painting, game character portrait, dramatic lighting "
            "from the fire breath."
        ),
        "assets/images/dragons", "dragon_young.png", "512x512",
    ),
    (
        "dragon_adult.png",
        STYLE_PREFIX + (
            "A majestic adult dragon in a powerful character portrait. Large "
            "and commanding, with richly detailed deep purple (#2D1B69) "
            "scales, each individually rendered with subtle iridescent "
            "highlights. Massive wings spread in a dominant display, showing "
            "thick membrane with prominent gold (#F4A261) veining. Long, "
            "elegant curved horns. Its powerful jaw breathes an intense "
            "torrent of golden-orange fire. Muscular body with prominent "
            "gold underbelly scales that resemble armor plating. Blazing "
            "amber-gold eyes radiate intelligence and power. Standing in a "
            "confident battle-ready pose. Isolated subject, clean edges. "
            "Digital painting, game character portrait, epic warm dramatic "
            "lighting."
        ),
        "assets/images/dragons", "dragon_adult.png", "512x512",
    ),
    (
        "dragon_elder.png",
        STYLE_PREFIX + (
            "An ancient elder dragon in a majestic character portrait. "
            "Immense and wise, with deep purple (#2D1B69) scales that have "
            "faintly glowing emerald (#2A9D8F) and gold (#F4A261) arcane "
            "rune patterns naturally etched into them over centuries. Its "
            "horns have grown into a magnificent crown-like arrangement "
            "resembling a natural diadem. Ancient amber-gold eyes glow with "
            "inner magical light. The dragon is surrounded by slowly orbiting "
            "motes of purple and gold magical energy. Its wings shimmer with "
            "subtle starlight patterns. The gold underbelly scales now "
            "display intricate ancient patterns. Expression is wise, serene, "
            "yet powerful. Isolated subject, clean edges. Digital painting, "
            "game character portrait, mystical warm lighting."
        ),
        "assets/images/dragons", "dragon_elder.png", "512x512",
    ),

    # === Hub Companions (256x256) ===
    (
        "dragon_egg_hub.png",
        STYLE_PREFIX + (
            "A small glowing dragon egg on a tiny golden nest, deep purple "
            "shell with gold veins, gentle pulsing magical glow, cute but "
            "not cartoonish, game sprite idle pose, side view, slight "
            "rocking motion implied, stylized fantasy digital painting, "
            "clean edges, isolated subject."
        ),
        "assets/images/dragons", "dragon_egg_hub.png", "256x256",
    ),
    (
        "dragon_hatchling_hub.png",
        STYLE_PREFIX + (
            "A tiny purple dragon hatchling sitting attentively, side view "
            "with head turned slightly toward viewer, stubby wings folded, "
            "gold underbelly, amber eyes, small horns, cute but not chibi, "
            "game sprite idle pose, clean simple composition, stylized "
            "fantasy digital painting, isolated subject."
        ),
        "assets/images/dragons", "dragon_hatchling_hub.png", "256x256",
    ),
    (
        "dragon_fledgling_hub.png",
        STYLE_PREFIX + (
            "A small fledgling purple dragon in idle standing pose, wings "
            "partially open, small flame from mouth, gold underbelly, "
            "amber eyes, slightly longer horns, alert posture, game "
            "sprite character, side view, stylized fantasy digital "
            "painting, isolated subject."
        ),
        "assets/images/dragons", "dragon_fledgling_hub.png", "256x256",
    ),
    (
        "dragon_young_hub.png",
        STYLE_PREFIX + (
            "A young purple dragon standing proudly in idle pose, wings "
            "folded at sides, tail curled, gold underbelly, amber eyes, "
            "curved horns, small smoke wisps from nostrils, game sprite "
            "character, three-quarter front view, stylized fantasy digital "
            "painting, isolated subject."
        ),
        "assets/images/dragons", "dragon_young_hub.png", "256x256",
    ),
    (
        "dragon_adult_hub.png",
        STYLE_PREFIX + (
            "A majestic adult purple dragon in regal idle pose, wings "
            "folded majestically, powerful build, gold underbelly armor "
            "scales, long curved horns, amber eyes, small ember glow from "
            "nostrils, confident calm expression, game sprite character, "
            "three-quarter view, stylized fantasy digital painting, "
            "isolated subject."
        ),
        "assets/images/dragons", "dragon_adult_hub.png", "256x256",
    ),
    (
        "dragon_elder_hub.png",
        STYLE_PREFIX + (
            "An ancient elder purple dragon in serene idle pose, glowing "
            "rune patterns on scales, crown-like horns, gold eyes glowing "
            "with wisdom, small orbiting magical motes, majestic calm "
            "posture, game sprite character, three-quarter view, stylized "
            "fantasy digital painting, isolated subject."
        ),
        "assets/images/dragons", "dragon_elder_hub.png", "256x256",
    ),

    # === Color Variants (128x128) ===
    (
        "dragon_color_variant_crimson.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, deep crimson red "
            "scales #DC143C as primary color, dark gold underbelly and "
            "highlights, amber eyes, curved horns, confident fierce "
            "expression, small fire wisps, stylized semi-realistic cartoon, "
            "Wings of Fire style, game character portrait icon, isolated "
            "subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_crimson.png", "128x128",
    ),
    (
        "dragon_color_variant_sapphire.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, rich sapphire "
            "blue scales #0F52BA as primary color, silver-blue underbelly "
            "and highlights, bright blue eyes, curved horns, regal calm "
            "expression, small frost wisps, stylized semi-realistic cartoon, "
            "Wings of Fire style, game character portrait icon, isolated "
            "subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_sapphire.png", "128x128",
    ),
    (
        "dragon_color_variant_emerald.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, rich emerald "
            "green scales #50C878 as primary color, warm gold underbelly "
            "and highlights, bright green eyes, curved horns, alert "
            "expression, small nature wisps with leaves, stylized "
            "semi-realistic cartoon, Wings of Fire style, game character "
            "portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_emerald.png", "128x128",
    ),
    (
        "dragon_color_variant_amethyst.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, soft violet "
            "amethyst scales #9966CC as primary color, lavender underbelly "
            "and highlights, purple glowing eyes, curved horns, mystical "
            "serene expression, small purple magical wisps, stylized "
            "semi-realistic cartoon, Wings of Fire style, game character "
            "portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_amethyst.png", "128x128",
    ),
    (
        "dragon_color_variant_gold.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, brilliant golden "
            "scales #FFD700 as primary color, warm white underbelly and "
            "highlights, amber-gold glowing eyes, curved horns, radiant "
            "proud expression, golden light emanating, stylized "
            "semi-realistic cartoon, Wings of Fire style, game character "
            "portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_gold.png", "128x128",
    ),
    (
        "dragon_color_variant_obsidian.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, near-black "
            "obsidian scales #1C1C1C with subtle dark reflections, dark "
            "red underbelly and highlights #8B0000, red glowing eyes, "
            "curved horns, mysterious intense expression, dark smoke "
            "wisps, subtle rim light on edges for visibility, stylized "
            "semi-realistic cartoon, Wings of Fire style, game character "
            "portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_obsidian.png", "128x128",
    ),
    (
        "dragon_color_variant_frost.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, pale ice blue "
            "frost scales #ADD8E6 with crystalline sheen, white and silver "
            "underbelly and highlights, icy blue eyes, curved horns with "
            "frost crystals, calm cool expression, frost and snowflake "
            "wisps, stylized semi-realistic cartoon, Wings of Fire style, "
            "game character portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_frost.png", "128x128",
    ),
    (
        "dragon_color_variant_sunset.png",
        STYLE_PREFIX + (
            "A young dragon portrait head and upper body, warm sunset "
            "orange-red scales #FF6347 transitioning to gold, warm gold "
            "underbelly and highlights, warm amber eyes, curved horns, "
            "energetic joyful expression, warm ember wisps, stylized "
            "semi-realistic cartoon, Wings of Fire style, game character "
            "portrait icon, isolated subject, clean edges."
        ),
        "assets/images/dragons", "dragon_color_variant_sunset.png", "128x128",
    ),

    # === Accessories (64x64) ===
    (
        "acc_crown.png",
        STYLE_PREFIX + (
            "A small ornate golden dragon crown, fantasy style with dragon "
            "wing-shaped points, set with small purple amethyst gems, warm "
            "gold #F4A261 metal, designed to sit on top of a dragon's head "
            "between horns, game cosmetic accessory item, simple clean "
            "design, stylized fantasy digital painting, top-down slight "
            "angle, isolated subject."
        ),
        "assets/images/dragons", "acc_crown.png", "64x64",
    ),
    (
        "acc_scarf.png",
        STYLE_PREFIX + (
            "A small cozy knitted scarf in deep purple and gold stripes, "
            "slightly flowing as if in wind, fantasy styled with small "
            "dragon scale clasps, designed to wrap around a dragon's neck, "
            "game cosmetic accessory item, simple clean design, stylized "
            "fantasy digital painting, isolated subject."
        ),
        "assets/images/dragons", "acc_scarf.png", "64x64",
    ),
    (
        "acc_battle_armor.png",
        STYLE_PREFIX + (
            "A small set of fantasy dragon battle armor, chest plate and "
            "shoulder guards, dark steel with gold #F4A261 trim and purple "
            "gemstone accents, dragon scale texture on the metal, "
            "battle-ready but ornamental, designed to fit a dragon's chest "
            "and shoulders, game cosmetic accessory item, stylized fantasy "
            "digital painting, isolated subject."
        ),
        "assets/images/dragons", "acc_battle_armor.png", "64x64",
    ),
    (
        "acc_wizard_hat.png",
        STYLE_PREFIX + (
            "A small pointed wizard hat for a dragon, deep purple fabric "
            "with gold star and moon embroidery, slightly drooping tip, a "
            "golden buckle or clasp where the brim meets the cone, magical "
            "sparkle accents, designed to perch on a dragon's head, game "
            "cosmetic accessory item, stylized fantasy digital painting, "
            "isolated subject."
        ),
        "assets/images/dragons", "acc_wizard_hat.png", "64x64",
    ),
    (
        "acc_necklace.png",
        STYLE_PREFIX + (
            "A fantasy necklace or pendant for a dragon, golden chain with "
            "a large emerald #2A9D8F gemstone pendant, ornate dragon claw "
            "setting holding the gem, magical inner glow from the gemstone, "
            "designed to hang around a dragon's neck, game cosmetic "
            "accessory item, stylized fantasy digital painting, isolated "
            "subject."
        ),
        "assets/images/dragons", "acc_necklace.png", "64x64",
    ),
    (
        "acc_wing_decorations.png",
        STYLE_PREFIX + (
            "A set of ornamental wing decorations for a dragon, delicate "
            "golden chains with small gemstones and dangling charms that "
            "attach along wing edges, gold and purple color scheme, "
            "jewelry-like quality, fantasy ornamental, designed to drape "
            "along dragon wing membranes, game cosmetic accessory item, "
            "stylized fantasy digital painting, isolated subject."
        ),
        "assets/images/dragons", "acc_wing_decorations.png", "64x64",
    ),
]


def process_one(raw_name, prompt, output_dir, output_name, target_size):
    """Generate one image with transparent bg, then resize + compress."""
    raw_path = PROJECT_ROOT / "assets" / "images" / "raw" / raw_name
    out_dir = PROJECT_ROOT / output_dir
    out_path = out_dir / output_name
    out_dir.mkdir(parents=True, exist_ok=True)

    # Step 1: Generate with transparent background
    print(f"  Generating (transparent bg)...")
    generate_image(
        prompt=prompt,
        output_path=str(raw_path),
        size="1024x1024",
        transparent=True,
        quality="high",
        variations=1,
    )

    # Step 2: Resize (no bg removal needed!)
    print(f"  Resizing to {target_size}...")
    results = resize_image(str(raw_path), target_size, str(out_dir))
    main_file = Path(results[0]["path"])
    if main_file != out_path:
        shutil.move(str(main_file), str(out_path))

    # Step 3: Compress
    print(f"  Compressing...")
    compress_png(str(out_path), quality="80-95")

    size_kb = out_path.stat().st_size / 1024
    print(f"  Done: {out_path.name} ({size_kb:.1f} KB)")


if __name__ == "__main__":
    print(f"Regenerating {len(DRAGONS)} dragon images with native transparency...")
    print(f"Project root: {PROJECT_ROOT}")
    print()

    success = 0
    failed = 0
    for i, (raw_name, prompt, outdir, outname, size) in enumerate(DRAGONS, 1):
        print(f"[{i}/{len(DRAGONS)}] {outname} ({size})")
        try:
            process_one(raw_name, prompt, outdir, outname, size)
            success += 1
        except Exception as e:
            print(f"  ERROR: {e}")
            import traceback
            traceback.print_exc()
            failed += 1
        print()

    print(f"Done! {success} succeeded, {failed} failed out of {len(DRAGONS)} total.")
