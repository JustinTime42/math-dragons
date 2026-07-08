#!/usr/bin/env python3
"""Generate clean standalone accessory ICONS for the shop/customizer tiles.

The equipped-on-dragon layers look great in the big preview but are too detailed
(and occluded) for the small grid tiles. This renders each accessory as a
complete, unoccluded item on white, keyed to transparency, matching the actual
in-game item by referencing its worn render.

    .venv/bin/python tools/asset_generator/generate_accessory_icons.py
    .venv/bin/python tools/asset_generator/generate_accessory_icons.py --only acc_crown
"""

import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

sys.path.insert(0, str(Path(__file__).parent))
import gemini_gen  # noqa: E402

ICON = 512
PROOF = Path("assets/images/dragons/posed/candidates/track_a_proof")
# Output overwrites the catalog imagePaths used by the tiles.
OUT = Path("assets/images/dragons")

# item name used in the prompt + the stage-3 worn render to reference.
ITEMS = {
    "acc_crown": "golden crown",
    "acc_scarf": "knitted scarf",
    "acc_wizard_hat": "pointed wizard hat",
    "acc_necklace": "jeweled pendant necklace",
    "acc_battle_armor": "metal chest-plate armor",
    "acc_wing_decorations": "set of jeweled wing ornaments",
}


def _prompt(name: str) -> str:
    return (
        f"Show ONLY the {name} from this image as a clean standalone game item "
        "icon: the complete item, fully visible and NOT occluded by the dragon "
        "or any body part, centered and facing the viewer, on a plain solid "
        "white background. Do not include the dragon or any part of it. Keep the "
        "item's exact design, colors, and painterly fantasy style. Single object, "
        "centered, generous margin."
    )


def _key_white(img: Image.Image) -> Image.Image:
    """Make the plain white background transparent via a border flood, so light
    highlights inside the item are preserved."""
    rgb = img.convert("RGB").resize((ICON, ICON))
    arr = np.asarray(rgb, dtype=np.int16)
    near_white = (arr.min(axis=2) > 238)

    # Flood from the border through near-white pixels so only the background
    # (connected to the edge) is removed, not white specular dots on the item.
    h, w = near_white.shape
    bg = np.zeros((h, w), dtype=bool)
    from collections import deque

    dq = deque()
    for x in range(w):
        for y in (0, h - 1):
            if near_white[y, x] and not bg[y, x]:
                bg[y, x] = True
                dq.append((y, x))
    for y in range(h):
        for x in (0, w - 1):
            if near_white[y, x] and not bg[y, x]:
                bg[y, x] = True
                dq.append((y, x))
    while dq:
        y, x = dq.popleft()
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < h and 0 <= nx < w and near_white[ny, nx] and not bg[ny, nx]:
                bg[ny, nx] = True
                dq.append((ny, nx))

    alpha = np.where(bg, 0, 255).astype(np.uint8)
    alpha_img = Image.fromarray(alpha, "L").filter(ImageFilter.GaussianBlur(0.6))
    out = rgb.convert("RGBA")
    out.putalpha(alpha_img)
    return out


def generate(acc_id: str) -> None:
    name = ITEMS[acc_id]
    ref = PROOF / f"{acc_id}_dragon_hub_front_3q_left_stage3_default_plate_worn.png"
    refs = [ref] if ref.exists() else []
    print(f"[{acc_id}] generating icon" + (" (ref worn render)" if refs else ""))
    img = gemini_gen.edit_image(_prompt(name), reference_images=refs,
                                model=gemini_gen.NANO_BANANA_PRO)
    icon = _key_white(img)
    out_path = OUT / f"{acc_id}.png"
    icon.save(out_path)
    print(f"  wrote {out_path}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--only", action="append", choices=sorted(ITEMS),
                    help="Generate only these accessory ids (repeatable).")
    args = ap.parse_args()
    for acc in (args.only or sorted(ITEMS)):
        generate(acc)


if __name__ == "__main__":
    main()
