#!/usr/bin/env python3
"""Track A accessory-layer generator (diff-extract).

Renders a dragon *wearing* an accessory from the exact base-dragon reference
(Nano Banana Pro), then extracts a registered transparent RGBA layer by
differencing the render against the base, clamped to the accessory's slot
bounding box. Horn/anatomy occlusion falls out for free: pixels the dragon
covers are unchanged from the base -> diff ~0 -> transparent -> the real dragon
shows through at runtime.

See docs/step12/ACCESSORY_PIPELINE_DECISION.md (Track A).

Proof run (crown on the default young hub dragon, ~1 image / pennies):

    .venv/bin/python tools/asset_generator/generate_accessory_layer.py --proof
"""

import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

sys.path.insert(0, str(Path(__file__).parent))
import gemini_gen  # noqa: E402

CANVAS = 1024

# Slot bounding boxes as (x0, y0, x1, y1) fractions of the canvas. The diff is
# clamped to these so model noise outside the worn region is discarded.
SLOT_BBOX = {
    "headTop": (0.22, 0.00, 0.78, 0.34),
    "neck": (0.28, 0.28, 0.72, 0.56),
    "chest": (0.28, 0.44, 0.78, 0.76),
    "wings": (0.00, 0.18, 1.00, 0.82),
}

# Per-accessory instruction + slot. The occlusion clause ("horns pass in front")
# is what makes the extracted layer notch correctly.
ACCESSORY_PROMPTS = {
    "acc_crown": (
        "headTop",
        "Add a regal golden crown resting on top of this dragon's head, sitting "
        "snugly between and slightly BEHIND the two horns so the horns clearly "
        "pass in front of the crown band and occlude it.",
    ),
    "acc_wizard_hat": (
        "headTop",
        "Add a tall pointed wizard hat sitting on this dragon's head, with the "
        "horns passing in front of the hat's brim and lower body so they occlude it.",
    ),
    "acc_scarf": (
        "neck",
        "Wrap a cozy knitted scarf around this dragon's neck, tucked naturally so "
        "the jaw and the front of the neck occlude the parts that pass behind them.",
    ),
    "acc_necklace": (
        "neck",
        "Add an ornate jeweled necklace hanging at the base of this dragon's neck, "
        "resting on the chest, with the jaw and neck occluding any part behind them.",
    ),
    "acc_battle_armor": (
        "chest",
        "Add a fitted metal chest-plate armor over this dragon's chest and "
        "shoulders, conforming to the body with the near foreleg occluding its edge.",
    ),
    "acc_wing_decorations": (
        "wings",
        "Add decorative jeweled ornaments along this dragon's wings, with the body "
        "and wing membranes occluding any parts that pass behind them.",
    ),
}

PRESERVE = (
    " Match the dragon's exact front three-quarter perspective, scale, and "
    "lighting. Keep the dragon, its horns, scales, pose, colors, and the "
    "background pixel-identical and unchanged. Do not redraw or restyle the "
    "dragon. Output only the same dragon with the accessory added."
)

# Nano Banana regenerates the whole frame, so we cannot diff the accessory
# render against the ORIGINAL art. Instead we first render a "clean plate" (the
# dragon re-rendered by the same model on a flat background), then edit THAT
# plate to add the accessory. Because step 2 edits step 1's own output, the two
# images stay aligned and the diff isolates just the accessory + its shadow.
PLATE_PROMPT = (
    "Re-render this exact dragon completely unchanged: identical pose, body "
    "shape, horns, wings, scales, colors, markings, expression, scale, and "
    "framing. Place it on a plain solid white background. Do not add, remove, "
    "or restyle anything. Output only the same dragon on white."
)


def _bbox_px(slot: str) -> tuple[int, int, int, int]:
    x0, y0, x1, y1 = SLOT_BBOX[slot]
    return (
        int(x0 * CANVAS),
        int(y0 * CANVAS),
        int(x1 * CANVAS),
        int(y1 * CANVAS),
    )


def extract_layer(
    base: Image.Image,
    worn: Image.Image,
    slot: str,
    threshold: int = 38,
    feather: float = 1.2,
) -> tuple[Image.Image, dict]:
    """Diff-extract the accessory as a registered RGBA layer.

    Returns (layer, metrics). `metrics` reports how much the render drifted
    OUTSIDE the slot bbox (a proxy for identity preservation / alignment) so we
    can judge whether the extraction is trustworthy.
    """
    base = base.convert("RGB").resize((CANVAS, CANVAS))
    worn_rgb = worn.convert("RGB").resize((CANVAS, CANVAS))

    b = np.asarray(base, dtype=np.int16)
    w = np.asarray(worn_rgb, dtype=np.int16)
    diff = np.abs(w - b).sum(axis=2)  # 0..765 per pixel

    x0, y0, x1, y1 = _bbox_px(slot)
    inside = np.zeros((CANVAS, CANVAS), dtype=bool)
    inside[y0:y1, x0:x1] = True

    changed = diff > threshold
    outside_drift = float(diff[changed & ~inside].mean()) if (changed & ~inside).any() else 0.0
    outside_frac = float((changed & ~inside).mean())

    mask = changed & inside
    alpha = (mask.astype(np.float32) * 255).clip(0, 255).astype(np.uint8)
    alpha_img = Image.fromarray(alpha, mode="L")

    # Morphological opening (erode then dilate to the same size) removes isolated
    # speckle from subtle re-lighting of nearby dragon pixels without growing the
    # mask outward into the plate's background (which would leave a white fringe).
    alpha_img = alpha_img.filter(ImageFilter.MinFilter(3))  # erode
    alpha_img = alpha_img.filter(ImageFilter.MaxFilter(3))  # dilate back to size
    # Pull the edge in ~1px past the anti-aliased boundary to drop white fringe.
    alpha_img = alpha_img.filter(ImageFilter.MinFilter(3))
    if feather > 0:
        alpha_img = alpha_img.filter(ImageFilter.GaussianBlur(feather))

    layer = worn.convert("RGBA").resize((CANVAS, CANVAS))

    # Defringe: where the render is near-white (background bleed) but we kept it,
    # such pixels are contamination; darken toward neutral to kill the halo.
    rgb = np.asarray(layer.convert("RGB"), dtype=np.float32)
    near_white = (rgb.min(axis=2) > 225)
    a2 = np.asarray(alpha_img, dtype=np.float32)
    a2[near_white] *= 0.15  # near-white kept pixels are almost certainly fringe
    alpha_img = Image.fromarray(a2.clip(0, 255).astype(np.uint8), mode="L")

    layer.putalpha(alpha_img)

    metrics = {
        "outside_drift_mean": round(outside_drift, 1),
        "outside_changed_fraction": round(outside_frac, 4),
        "inside_changed_fraction": round(float(mask.mean()), 4),
    }
    return layer, metrics


def generate(
    base_path: Path,
    accessory_id: str,
    out_dir: Path,
    model: str,
) -> None:
    slot, instruction = ACCESSORY_PROMPTS[accessory_id]
    prompt = instruction + PRESERVE
    base = Image.open(base_path)

    print(f"[{accessory_id}] rendering with {model} ...")
    worn = gemini_gen.edit_image(prompt, reference_images=[base], model=model)

    out_dir.mkdir(parents=True, exist_ok=True)
    stem = f"{accessory_id}_{base_path.stem}"
    raw_path = out_dir / f"{stem}_worn_render.png"
    worn.convert("RGBA").resize((CANVAS, CANVAS)).save(raw_path)

    layer, metrics = extract_layer(base, worn, slot)
    layer_path = out_dir / f"{stem}_layer.png"
    layer.save(layer_path)

    # Composite the extracted layer back over OUR base dragon for visual review.
    preview = base.convert("RGBA").resize((CANVAS, CANVAS))
    preview.alpha_composite(layer)
    preview_path = out_dir / f"{stem}_composite_preview.png"
    preview.save(preview_path)

    print(f"  raw render:   {raw_path}")
    print(f"  layer:        {layer_path}")
    print(f"  composite:    {preview_path}")
    print(f"  metrics:      {metrics}")
    if metrics["outside_changed_fraction"] > 0.05:
        print(
            "  WARNING: high drift outside the slot bbox -> the model repainted "
            "the dragon; extraction may be unreliable (see decision doc, "
            "Kontext-seeded fallback)."
        )


def generate_pair(
    base_path: Path,
    accessory_id: str,
    out_dir: Path,
    model: str,
) -> None:
    """Two-step aligned pipeline: clean plate -> plate+accessory -> diff.

    This is the reliable path given the model regenerates whole frames. The
    plate becomes the canonical dragon for this (skin, stage, context); the
    extracted layer is registered to the plate and composited over it at runtime.
    """
    slot, instruction = ACCESSORY_PROMPTS[accessory_id]
    out_dir.mkdir(parents=True, exist_ok=True)
    base = Image.open(base_path)
    stem = f"{accessory_id}_{base_path.stem}"

    # The plate (clean dragon on white) depends only on the base dragon, not the
    # accessory, so cache it per base and reuse across accessories for that base.
    plate_path = out_dir / f"plate_{base_path.stem}.png"
    if plate_path.exists():
        print(f"[{accessory_id}] step 1/2: reusing cached plate {plate_path.name}")
        plate = Image.open(plate_path).convert("RGBA").resize((CANVAS, CANVAS))
    else:
        print(f"[{accessory_id}] step 1/2: clean plate ({model}) ...")
        plate = gemini_gen.edit_image(
            PLATE_PROMPT, reference_images=[base], model=model
        )
        plate = plate.convert("RGBA").resize((CANVAS, CANVAS))
        plate.save(plate_path)

    print(f"[{accessory_id}] step 2/2: add accessory onto the plate ...")
    worn = gemini_gen.edit_image(
        instruction + PRESERVE, reference_images=[plate], model=model
    )
    worn_path = out_dir / f"{stem}_plate_worn.png"
    worn.convert("RGBA").resize((CANVAS, CANVAS)).save(worn_path)

    layer, metrics = extract_layer(plate, worn, slot)
    layer_path = out_dir / f"{stem}_pair_layer.png"
    layer.save(layer_path)

    preview = plate.copy()
    preview.alpha_composite(layer)
    preview_path = out_dir / f"{stem}_pair_composite.png"
    preview.save(preview_path)

    print(f"  plate:      {plate_path}")
    print(f"  worn:       {worn_path}")
    print(f"  layer:      {layer_path}")
    print(f"  composite:  {preview_path}")
    print(f"  metrics:    {metrics}")
    if metrics["outside_changed_fraction"] > 0.05:
        print("  WARNING: plate drifted when adding the accessory; extraction noisy.")
    else:
        print("  OK: low outside drift -> clean registered layer.")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--proof", action="store_true",
                    help="Crown on the default young hub dragon (aligned pair).")
    ap.add_argument("--naive", action="store_true",
                    help="Use single-shot diff-against-original (unreliable; for comparison).")
    ap.add_argument("--accessory", default="acc_crown",
                    choices=sorted(ACCESSORY_PROMPTS))
    ap.add_argument("--base", help="Path to a base dragon PNG.")
    ap.add_argument("--lite", action="store_true",
                    help="Use the cheap Nano Banana Lite model for iteration.")
    ap.add_argument("--out", default="assets/images/dragons/posed/candidates/track_a_proof")
    args = ap.parse_args()

    model = gemini_gen.NANO_BANANA_LITE if args.lite else gemini_gen.NANO_BANANA_PRO
    out_dir = Path(args.out)

    run = generate if args.naive else generate_pair

    if args.proof:
        base = Path(
            "assets/images/dragons/posed/raw/dragons/hub/stage_3_young/"
            "dragon_hub_front_3q_left_stage3_default.png"
        )
        run(base, "acc_crown", out_dir, model)
        return

    if not args.base:
        ap.error("--base is required unless --proof is used")
    run(Path(args.base), args.accessory, out_dir, model)


if __name__ == "__main__":
    main()
