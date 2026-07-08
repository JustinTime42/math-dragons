# Posed Dragon Accessory Pipeline

Math Dragons accessories should be authored against canonical dragon poses, not
against arbitrary skin art. A skin/species can use any pose, but accessory
anchors and accessory art are keyed by pose.

## Runtime Key

Dragon art and accessory art are keyed as:

```text
render context + pose id + stage + accessory id
```

Current contexts:

- `DragonRenderContext.hub`
- `DragonRenderContext.portrait`

Current default poses:

- `hub_front_3q_left`
- `portrait_front_3q_left`

## Art Rule

Every dragon image that shares a `pose_id` must preserve:

- canvas size
- subject bounding box
- pose
- head angle
- body orientation
- attachment landmarks

Skins may change color, markings, horn texture, and scale pattern, but not the
geometry of the dragon.

Every dragon and accessory prompt should use the approved style bible references
from `assets/style_bible/approved/` and `assets/style_bible/v2/`. Prompt text
alone is not reliable enough for this pipeline. The sample generator passes
these references automatically.

Generated sprites should request native PNG transparency through the OpenAI
Images API (`background="transparent"`, `output_format="png"`). Keep green
chroma-key backgrounds only as a fallback if a generator cannot produce a clean
alpha channel.

The current approved style target is stylized semi-realistic fantasy digital
painting for ages 7-14: painterly lighting, rich scale texture, readable mobile
game silhouettes, and expressive amber eyes. Avoid chibi proportions, plastic
toy rendering, flat vector outlines, baby-cute mascot styling, grimdark horror,
classroom motifs, text, and UI elements.

## Accessory Layers

Accessories should be generated as registered visible layers, not standalone
object cutouts. For each `context + stage + accessory`, generate a transparent
1024x1024 PNG using the matching dragon template as the registration reference.

The accessory layer must:

- use the exact same canvas registration as the dragon template
- place the accessory where it would be worn on the dragon
- include only accessory pixels that remain visible after body/horn/neck/wing
  occlusion
- omit hidden portions instead of drawing them through the dragon
- contain no dragon pixels, guide marks, shadows, background, or text

Runtime renders the dragon image and then overlays these registered accessory
layers at the same size. Manual anchor calibration is a legacy fallback for
standalone accessory cutouts and is not expected to solve occlusion.

## Crown Candidate Fallback

If registered crown layers are visually poor, generate standalone crown
candidate cutouts instead of trying to extract crowns from full dragon renders.
Diff masking is unreliable because diffusion edits also alter non-accessory
pixels.

The fallback intentionally generates many partial crown variants for manual
selection and calibration:

- crown color theme is independent from dragon color
- crown art is keyed by pose/context, not by growth stage
- calibration handles scale, position, and x/y/z rotation
- prompts request pre-occluded crown fragments with missing rear rim segments
  and horn notches

Preview the candidate prompts:

```bash
.venv/bin/python tools/asset_generator/generate_crown_candidates.py --dry-run --limit 2
```

Generate a small smoke test first:

```bash
.venv/bin/python tools/asset_generator/generate_crown_candidates.py \
  --context hub \
  --theme classic_gold \
  --variations 4 \
  --keep-going
```

Generate a focused first batch:

```bash
.venv/bin/python tools/asset_generator/generate_crown_candidates.py \
  --theme classic_gold \
  --theme ruby \
  --theme sapphire \
  --variations 4 \
  --keep-going
```

Generate all crown themes and orientation variants:

```bash
.venv/bin/python tools/asset_generator/generate_crown_candidates.py --variations 3 --keep-going
```

Candidates are written under:

```text
assets/images/dragons/posed/candidates/crowns/
```

Do not wire that whole folder into production. Review the candidates, pick the
usable cutouts, then copy selected files into the production accessory set and
calibrate anchors.

## Sample Generation

Use the sample prompt manifest:

```text
tools/asset_generator/pose_sample_prompts.json
```

Generate into:

```text
assets/images/dragons/pose_samples/raw/
assets/images/dragons/pose_samples/final/
```

These samples are for visual validation only and should not overwrite production
dragon assets.

The first sample creates the canonical pose template. Later samples reference
that template when it exists, so regenerating the whole manifest in order should
produce tighter pose consistency than running individual prompts by hand.

## Full Review Batch

The production candidate batch should stay intentionally small:

- `hub_front_3q_left`
- `portrait_front_3q_left`

Do not generate right-facing or side poses unless a screen specifically needs
them. The current full review batch is:

```text
2 contexts x 6 stages x 9 skins = 108 dragon images
2 contexts x 5 wearable stages x 6 accessories = 60 accessory images
```

The generator writes to a review folder first:

```text
assets/images/dragons/posed/raw/
```

Inspect the planned work:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --dry-run
```

Generate a small smoke test:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --limit 6
```

Generate the full batch:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --keep-going
```

Regenerate only fitted accessory layers:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only accessories --overwrite --keep-going
```

Generate skin-themed crown layers:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only themed-accessories --accessory acc_crown --overwrite --keep-going
```

Generate one themed crown slice for review:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only themed-accessories --accessory acc_crown --skin color_crimson --context hub --stage 3 --overwrite
```

Themed accessories are optional per accessory. Crowns currently support
skin-specific layers. Runtime resolves `acc_crown` to a skin-specific layer when
a dragon color is equipped, such as:

```text
acc_crown_hub_front_3q_left_stage3_color_crimson.png
```

Other accessories continue using the shared pose/stage layer unless added to the
themed accessory set.

Regenerate existing files only when intended:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --overwrite --keep-going
```

Regenerate only the egg stage:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --stage 0 --overwrite --keep-going
```

Regenerate one context or one stage when reviewing smaller slices:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --context hub --stage 0 --overwrite
```

Generate templates first if you want maximum control over review gates:

```bash
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only templates
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only variants
.venv/bin/python tools/asset_generator/generate_posed_assets.py --only accessories
```

Variants and accessories reference the generated default-skin template for their
context and stage. If you run `--only variants` or `--only accessories`, generate
templates first.
