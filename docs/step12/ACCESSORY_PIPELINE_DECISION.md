# Accessory Pipeline Decision Record

Status: **Adopted 2026-07-07.** Supersedes the runtime-compositing strategy in
`POSED_DRAGON_ACCESSORY_PIPELINE.md` (manual anchor calibration of flat sprites).
That doc's asset-registration rules still apply; its "flat sprite + dx/dy/scale/
rotationX/rotationY anchor" compositing model is retired as the primary path.

## Problem

The dragon art is semi-realistic painterly at a fixed 3/4 view
(`front_3q_left`), 1024x1024, with two horns on top of the head, real
perspective and self-occlusion. Accessories are flat 2D sprites composited at
runtime via manual anchors. Flat overlays cannot wrap the 3/4 head, notch around
the horns, or occlude correctly. This is the exact case the games industry
avoids: no shipped 2D creature game solves generic accessory occlusion at
runtime (Flight Rising and Neopets bake occlusion into every PNG by hand; the
games that get free occlusion are secretly 3D).

## Key structural facts

- The 4 accessory slots (`headTop, neck, chest, wings`) are **spatially
  disjoint**, so we bake one layer per single accessory and stack by slot. No
  per-combination explosion (avoids the ~3000-image trap).
- Accessory art can be **skin-independent** (a gold crown is gold on any dragon),
  so the worn-accessory asset count is ~60 (2 contexts x 5 stages x 6
  accessories), not ~540.
- We only have OpenAI (GPT-image-1) + ElevenLabs API keys today. GPT-image-1 is
  unsuitable for image-to-image accessory baking (it recreates the whole frame).

## Decision

Two tracks, run together.

### Track D (now, no new setup): bias the catalog toward non-occluding cosmetics

Move most cosmetic value to items that never need occlusion. This is where
comparable games (Flight Rising, Genshin, Steam) actually monetize, it is
near-free of technical risk, and it uses the existing OpenAI + Flame pipeline.

- **Full-body color/pattern/material skins** (already partly present as color
  variants; expand to metallic/crystal/frost/shadow finishes, seasonal). Regen
  the same dragon in a new palette. Collector appeal, zero occlusion.
- **Auras / particle effects / elemental glows / trails** — Flame particle
  systems, no per-dragon art.
- **Floating headwear (crown/halo above the head)** — hovers, so no horn
  conflict; one sprite + a bob animation.
- **Scene / background themes** and **companion pets beside the dragon**.
- **Portrait card frames** with corner gems/ribbons/banners (UI layer, fully
  decoupled from the dragon).

Structural support to add: formalize slot conflict rules (Neopets-style
affected/restricted zones) and optional front/back sub-layers for wrapping items.

### Track A (small setup: one image model): AI smart-layer baking for worn props

For the genuinely-worn, must-occlude accessories (crown, armor, etc.), bake each
as a registered transparent layer using image-to-image in-context generation.

Pipeline:

1. Feed the exact base dragon PNG as a reference; prompt the model to render the
   dragon **wearing** the accessory, with the horns explicitly in front of the
   crown band, matching the dragon's perspective and lighting, keeping the rest
   pixel-identical.
2. Difference the with-accessory render against the base dragon, clamp the diff
   to the slot's bounding box, threshold, feather 1px, write RGBA. Horn-occlusion
   notches fall out for free: pixels the horns cover are unchanged from the base,
   diff to ~0, become transparent, and the real horns underneath show through.
3. Review and reroll. Ship the RGBA layer keyed by
   `(context, stage, slot, accessoryId)`. Runtime becomes 1:1 alpha stacking by
   slot; manual anchor math is retired.

Engine: **Nano Banana Pro (Gemini 3 Pro Image)** for finals (best occlusion +
identity lock), **Nano Banana 2 Lite** for cheap iteration, **Flux.1 Kontext**
(seeded, tighter preservation) as fallback. **Not GPT-image-1** (breaks the diff
trick). Cost is trivial (~$18-250 for all 540 worn-accessory images; pennies for
the initial proof). Requires one new API key (Google AI Studio / Gemini, or
fal.ai for Kontext).

### Track A validated 2026-07-07 (crown proof)

The naive "diff against the original dragon" fails: Nano Banana Pro regenerates
the whole frame (new background, repainted dragon), so ~48% of pixels outside
the crown region change. The reliable pipeline is a two-step aligned pair:

1. **Clean plate**: render the dragon unchanged on a plain white background from
   the original as reference (`PLATE_PROMPT`).
2. **Wear**: feed that plate back in and add the accessory ("horns pass in
   front"). Because step 2 edits step 1's own output, the two stay aligned
   (outside-bbox drift drops to ~0.5%).
3. **Extract**: diff wear vs plate, clamp to the slot bbox, morphological open to
   drop speckle, near-white defringe, feather -> registered RGBA layer.

Key result: the extracted crown layer composites correctly over the **original**
dragon art (no dragon-art replacement needed) with the horns occluding the crown
band. So the runtime stays as-is (dragon image + full-canvas RGBA layer per
slot). Tooling: `tools/asset_generator/gemini_gen.py` +
`generate_accessory_layer.py` (`--proof`, `--base/--accessory`, `--naive` for
comparison). Crown layers for all 5 hub stages (default skin) are wired into
`assets/images/dragons/posed/raw/accessories/hub/stage_*/acc_crown_*.png`.
Remaining to scale out: other accessories, portrait context, and the 9 skins
(accessory art is skin-independent, so skins mostly reuse the same layers unless
the head silhouette shifts).

### In reserve (not now)

- **Approach B — 3D accessory props rendered to 2D layers.** Deterministic and
  the most "correct" for hard items (crown vs horns), but a real one-time
  headless-Blender render + camera-calibration + SAM-occlusion setup. Escalate
  specific accessories here only if Track A's reliability disappoints.
- **Approach C — depth-aware 2D warp (SAM masks + OpenCV TPS offline).** Keeps
  current architecture but has the most per-image manual labor and the flattest
  look. Not primary.
- **Spine 2.5D rigging ($379 one-time, only maintained Flame runtime).** The
  future path when "make the dragon feel alive" (idle/breathing/blink) becomes a
  headline goal. It also solves accessory slotting for the fixed view, but needs
  per-stage PSD layer-cutting (4-8 weeks part-time) and does nothing sooner than
  Track A. Separate later project.
- **Full 3D dragon (image-to-3D + auto-rig).** Only if real rotation/head-turn
  becomes a design requirement, which nothing currently does. Its one useful
  idea (bake accessories onto a 3D rig) is captured more cheaply by Approach B.

## Rollout

1. Track D groundwork immediately (skins expansion + one aura + one floating
   headwear item) using the existing OpenAI + Flame pipeline.
2. Add one image model key; run a Track A proof: crown on the default young
   dragon, hub context, single accessory, prove horn occlusion via diff-extract.
3. If the proof holds, script the ~60 worn-accessory bakes and swap runtime to
   slot-stacked RGBA layers.
4. Revisit B/Spine later per the reserve notes.
