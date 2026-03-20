"""One-shot script to generate style bible candidates for Math Dragons."""

import sys
from pathlib import Path

# Ensure local modules resolve
sys.path.insert(0, str(Path(__file__).parent))

from dotenv import load_dotenv
load_dotenv(Path(__file__).parent / ".env")

from image_gen import generate_candidates

PROJECT_ROOT = Path(__file__).parent.parent.parent

BATCHES = [
    {
        "name": "1_anchor_direct",
        "prompt": (
            "A majestic purple and gold dragon standing in a crystal-lit cavern, "
            "stylized semi-realistic cartoon art style, detailed scales with warm highlights, "
            "expressive amber eyes, Wings of Fire book cover quality meets Clash Royale character design, "
            "rich fantasy color palette of deep purple #2D1B69 and warm gold #F4A261 with emerald #2A9D8F accents, "
            "midnight blue #1A1A2E background, warm inviting atmosphere, glowing crystals and ancient stonework, "
            "detailed enough for teenagers yet appealing to younger children, "
            "NOT chibi NOT super-deformed NOT baby dragon, digital painting, game art quality"
        ),
        "count": 2,
    },
    {
        "name": "2_heroic_emphasis",
        "prompt": (
            "A powerful young dragon with rich purple scales and golden underbelly highlights, "
            "standing proudly in an ancient crystal cavern. Stylized fantasy game art blending "
            "Wings of Fire's detailed dragon anatomy with Clash Royale's bold vibrant character design. "
            "Warm amber eyes full of intelligence. Deep purple (#2D1B69) scales catch torchlight, "
            "gold (#F4A261) accents glow, emerald (#2A9D8F) crystals illuminate the midnight blue (#1A1A2E) "
            "stone walls. Inviting and heroic atmosphere, appealing to ages 7-14. "
            "NOT chibi, NOT cartoonish, NOT grimdark. High-quality digital painting, mobile game character art."
        ),
        "count": 2,
    },
    {
        "name": "3_book_cover_style",
        "prompt": (
            "Fantasy dragon character portrait in a luminous crystal grotto, "
            "semi-realistic cartoon style inspired by children's fantasy book covers and mobile strategy game art. "
            "The dragon has deep violet-purple scales with individual scale detail, warm golden belly markings, "
            "curved elegant horns, and expressive amber-gold eyes. Warm torchlight and cool crystal glow create "
            "dramatic lighting. Color palette: royal purple, burnished gold, teal-emerald accents against deep "
            "navy-blue stone. The art style is detailed and polished — not childish or chibi, but warm and "
            "inviting rather than dark or scary. Professional game asset quality, digital painting."
        ),
        "count": 2,
    },
    {
        "name": "4_painterly_warm",
        "prompt": (
            "A regal dragon rendered in warm painterly digital art style, "
            "rich purple and gold color scheme, the dragon stands in a magical cavern glowing with "
            "teal crystals and amber torchlight. Thick visible brushstrokes give texture to the scales. "
            "The style evokes premium mobile game splash art — polished but with painterly charm. "
            "Deep saturated colors: purple #2D1B69, gold #F4A261, emerald #2A9D8F, midnight blue #1A1A2E. "
            "The dragon looks powerful yet friendly — a companion, not a threat. Curved horns, amber eyes, "
            "gold underbelly patterns. Suitable for children ages 7-14. NOT photorealistic, NOT chibi, "
            "NOT anime. Digital painting with visible artistic hand."
        ),
        "count": 1,
    },
    {
        "name": "5_clash_royale_lean",
        "prompt": (
            "A purple dragon character designed for a mobile game, Clash Royale art style with bold outlines "
            "and vibrant saturated colors, strong silhouette, exaggerated proportions for readability at small "
            "sizes, detailed scale texture, amber glowing eyes, gold accents on underbelly and horn tips. "
            "Standing in a fantasy cavern with glowing emerald and purple crystals. "
            "Colors: deep purple #2D1B69, warm gold #F4A261, teal #2A9D8F accents, navy #1A1A2E background. "
            "The character should feel like a premium mobile game unit — heroic, appealing, iconic. "
            "NOT chibi, NOT realistic, NOT grimdark. Digital game art."
        ),
        "count": 1,
    },
    {
        "name": "6_wings_of_fire_lean",
        "prompt": (
            "A young purple dragon in the style of Wings of Fire book cover illustrations by Joy Ang, "
            "semi-realistic with detailed anatomy, beautiful scale rendering, dramatic lighting, "
            "the dragon has deep violet-purple scales with golden underbelly markings and amber eyes, "
            "curved horns, partially spread wings showing membrane detail. "
            "Standing in a crystal-lit cavern with emerald and amethyst formations. "
            "Midnight blue atmosphere with warm gold and teal accent lighting. "
            "Fantasy book illustration quality, rich and detailed but accessible for children. "
            "NOT chibi, NOT cartoon-simple, NOT photorealistic. Digital painting, character portrait."
        ),
        "count": 1,
    },
    {
        "name": "7_game_ui_ready",
        "prompt": (
            "Game-ready dragon character art: a majestic purple dragon with golden highlights "
            "in a crystal cavern setting. Art style optimized for mobile game UI — clean edges, "
            "strong value contrast, readable at multiple sizes from 64px to 512px. "
            "Semi-realistic cartoon style bridging fantasy book illustration and mobile game character design. "
            "Purple (#2D1B69) scales, gold (#F4A261) underbelly and horn accents, amber eyes, "
            "emerald (#2A9D8F) crystal glow, midnight blue (#1A1A2E) background. "
            "The dragon looks intelligent, powerful, and approachable — a math tutor companion. "
            "Warm inviting atmosphere. NOT chibi, NOT super-deformed. Digital painting, game asset quality."
        ),
        "count": 1,
    },
]


def main():
    total = sum(b["count"] for b in BATCHES)
    print(f"Generating {total} style candidates across {len(BATCHES)} batches...\n")

    all_results = []
    for batch in BATCHES:
        out_dir = str(PROJECT_ROOT / "assets" / "style_bible" / "candidates" / batch["name"])
        print(f"  Batch '{batch['name']}' ({batch['count']} images) ...")
        try:
            results = generate_candidates(
                prompt=batch["prompt"],
                count=batch["count"],
                output_dir=out_dir,
                quality="high",
            )
            for r in results:
                print(f"    -> {r['path']}")
            all_results.extend(results)
        except Exception as e:
            print(f"    ERROR: {e}")

    print(f"\nDone. Generated {len(all_results)} images total.")
    for r in all_results:
        print(f"  {r['path']}")


if __name__ == "__main__":
    main()
