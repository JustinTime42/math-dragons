# Math Dragons: AI Art Generation Prompt Catalog

> Complete, actionable prompt catalog for generating all visual assets for Math Dragons.
> Every prompt is ready to paste into Midjourney V7, GPT Image, or Leonardo AI.
> Follow the Style Consistency Strategy (Section 0) before generating any assets.
>
> **Updated February 2026 for Midjourney V7** (default since June 2025).

---

## Table of Contents

0. [Style Consistency Strategy](#0-style-consistency-strategy)
1. [Dragon Evolution Stages](#1-dragon-evolution-stages) (12 images)
2. [Hub Environment](#2-hub-environment) (5 images)
3. [Game Backgrounds](#3-game-backgrounds) (4 images)
4. [Game-Specific Assets](#4-game-specific-assets) (~30 images)
5. [UI Elements](#5-ui-elements) (10 images)
6. [Store / Cosmetic Assets](#6-store--cosmetic-assets) (14 images)

**Total asset count: ~75 individual images**

---

## 0. Style Consistency Strategy

### 0.1 Master Style Definition

Before generating ANY production assets, create a **Style Reference Set** of 3-4 images that define the look and feel. All subsequent generations reference these images.

**Step 1: Generate the Style Anchor Image**

This single image establishes the entire art direction. Generate it first and iterate until it is exactly right.

**Prompt (Midjourney):**
```
A majestic purple and gold dragon standing in a crystal-lit cavern, stylized semi-realistic cartoon art style, detailed scales with warm highlights, expressive amber eyes, Wings of Fire book cover quality meets Clash Royale character design, rich fantasy color palette of deep purple #2D1B69 and warm gold #F4A261 with emerald #2A9D8F accents, midnight blue #1A1A2E background, warm inviting atmosphere, glowing crystals and ancient stonework, detailed enough for teenagers yet appealing to younger children, NOT chibi NOT super-deformed NOT baby dragon, digital painting, game art quality --ar 1:1 --s 750 --q 2 --v 7
```

**Step 2: Save the style reference.** Once you have an anchor image you love, save its URL or seed for reuse.

### 0.2 Platform-Specific Consistency Techniques

#### Midjourney V7 (default since June 2025)

- **--sref [URL]**: Style reference. Paste the URL of your anchor image into every subsequent prompt. Use `--sw 100` (style weight) for strong adherence, `--sw 50` for moderate. V6.1 sref codes are fully compatible with V7.
- **--oref [URL]**: Omni Reference (**replaces V6's `--oref`**). Embed characters, objects, or creatures from a reference image. Once you have the Stage 3 (Young Dragon) portrait, use it as `--oref` for all other dragon stages. Costs 2x GPU time. Use `--ow 300` for strict character preservation.
- **--ow 0-1000**: Omni Weight (**replaces V6's `--cw`**). Default 100. Low (25-50) for loose resemblance, high (300-400+) for strict character matching.
- **--exp [value]**: Expression (new in V7). Makes images more detailed and dynamic. Use `--exp 25` for game art.
- **--draft**: Draft Mode. 10x faster, half cost. Use for exploration, switch to full quality for finals.
- **--seed [number]**: Lock the random seed to get reproducible variations. Record the seed from your best results.
- **Remix Mode**: Enable remix mode so you can tweak prompts while keeping the same composition and style.
- **Multi-prompt weighting**: Use `dragon:: purple scales::0.5 gold highlights::0.3` to control element emphasis.

**Recommended Midjourney settings for all prompts:**
```
--v 7 --s 750 --q 2
```
Add `--sref [your-anchor-URL] --sw 80` to every prompt after establishing the anchor.
Add `--oref [your-dragon-URL] --ow 300` when generating dragon evolution stages and color variants.

> **V7 key improvements:** 40% fewer anatomical errors, 35% better prompt
> understanding, richer textures and detail. Simpler prompts yield better results.

#### DALL-E 3 (via ChatGPT)

- DALL-E 3 does not have `--sref` parameters. Instead, use **detailed verbal style descriptions** consistently across all prompts.
- Begin every prompt with the same style preamble (provided below as `STYLE_PREFIX`).
- Upload your anchor image to the conversation and say "Match the art style of this reference image exactly."
- Generate in the same ChatGPT conversation to maintain style memory within the session.

**STYLE_PREFIX for DALL-E 3** (prepend to all prompts):
```
Art style: stylized semi-realistic cartoon, digital painting, game asset quality.
Detailed dragon scales with warm highlights, expressive features, rich fantasy
color palette. Deep purple (#2D1B69) and warm gold (#F4A261) dominant colors,
emerald (#2A9D8F) and fire orange (#E76F51) accents, midnight blue (#1A1A2E)
backgrounds. Wings of Fire book cover meets Clash Royale character design
quality. Warm, inviting, NOT chibi, NOT baby-cute, NOT grimdark. Appealing to
ages 7-14.
```

#### Leonardo AI

- Use the **Image Guidance** feature: upload the anchor image with Guidance strength 0.5-0.7.
- Select **Leonardo Kino XL** or **Leonardo Diffusion XL** model for stylized game art.
- Use the **Style Reference** slider at 60-80% strength.
- Enable **PhotoReal** OFF, **Alchemy** ON for stylized art output.

**Recommended Leonardo settings:**
```
Model: Leonardo Kino XL
Guidance Scale: 7-9
Steps: 40-50
Alchemy: On
PhotoReal: Off
Style Reference Strength: 0.6-0.8
```

### 0.3 Color Palette Enforcement

AI generators frequently drift from specified hex colors. Use these techniques:

1. **Name colors in natural language AND hex**: "deep purple (#2D1B69)" is better than hex alone.
2. **Use color-dominant reference images**: Create a simple color swatch strip and include it as image guidance.
3. **Post-process in Photoshop/GIMP**: Use Hue/Saturation adjustment layers to pull generated colors toward the target palette. This is almost always necessary.
4. **Batch color correction**: For small game assets (gems, icons), generate in grayscale and colorize in post-production for perfect consistency.

### 0.4 Transparency and Game-Ready Output

Most AI generators output images on solid backgrounds. For game assets needing transparency:

1. Generate on a **solid, uniform background** (pure green #00FF00 or solid black #000000 or solid white #FFFFFF) by including "on solid [color] background, isolated" in the prompt.
2. Use **remove.bg**, **Photoshop Select Subject**, or **GIMP Foreground Select** to extract the subject.
3. For small pixel-art-style assets (gems, icons), consider **Aseprite** or **Piskel** for hand-cleanup after AI generation.
4. Export all transparent assets as **PNG-32** (32-bit PNG with alpha channel).

### 0.5 Asset Resolution Strategy

Generate at the highest resolution possible, then downscale:

| Final Size | Generate At | Downscale Method |
|-----------|------------|------------------|
| 32x32 | 512x512 or 1024x1024 | Photoshop bicubic sharper |
| 48x48 | 512x512 or 1024x1024 | Photoshop bicubic sharper |
| 64x64 | 512x512 or 1024x1024 | Photoshop bicubic sharper |
| 128x128 | 1024x1024 | Photoshop bicubic sharper |
| 256x256 | 1024x1024 | Photoshop bicubic sharper |
| 512x512 | 1024x1024 | Photoshop bicubic sharper |
| 1024x1024 | 1024x1024 (native) | None |
| 1920x1080 | 1920x1080 (native, Midjourney --ar 16:9) | None |

Flutter will use `Image.asset()` with `filterQuality: FilterQuality.medium` for smooth display at any size.

### 0.6 File Naming and Output Locations

All generated assets follow the naming convention in the Visual Design Guide:

```
assets/images/dragons/     -> Dragon evolution portraits
assets/images/hub/         -> Hub background and portals
assets/images/games/       -> Game-specific assets
assets/images/ui/          -> UI elements, icons, badges
```

---

## 1. Dragon Evolution Stages

Each stage needs two versions:
- **Portrait** (profile/evolution screen): 1024x1024, downscaled to 512x512 for app
- **Hub Companion** (smaller, idle pose on hub): 1024x1024, downscaled to 256x256 for app

The dragon should be the SAME individual creature at different life stages. Consistent features across all stages: slightly curved horns, amber/gold eyes, purple-dominant scales with gold underbelly markings.

---

### 1.1 Dragon Egg (Stage 0)

#### Portrait Version
**File**: `assets/images/dragons/dragon_egg.png`
**Output size**: 512x512 (generate at 1024x1024)
**Aspect ratio**: 1:1

**Midjourney Prompt:**
```
A glowing dragon egg resting on a bed of golden coins and purple crystals, the egg is large and oval, deep purple shell with swirling gold veins that pulse with inner magical light, faint emerald energy cracks along the surface, warm amber glow emanating from within, the egg sits in a dark cavern nest lined with soft moss, stylized semi-realistic cartoon digital painting, game character portrait, warm inviting fantasy atmosphere, midnight blue background, rich detail --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A large dragon egg centered in the frame as a character portrait. The egg is oval-shaped with a deep purple (#2D1B69) shell covered in swirling veins of warm gold (#F4A261) that appear to pulse with inner magical light. Faint emerald (#2A9D8F) energy seeps through hairline cracks on the surface. The egg rests on a small nest of golden coins and purple crystals. Warm amber glow emanates from inside the egg, illuminating the surrounding darkness. Background is dark midnight blue (#1A1A2E). Digital painting, game character portrait format, centered composition.
```

**Leonardo Prompt:**
```
dragon egg character portrait, large oval purple egg with gold veins, magical inner glow, emerald energy cracks, sitting on gold coins and crystals, dark cavern background, mystical atmosphere, fantasy game art, digital painting, warm lighting
```

**Negative Prompt (all platforms):**
```
realistic photo, photograph, blurry, low quality, text, watermark, signature, deformed, ugly, mutilated, disfigured, extra limbs, bad anatomy, chicken egg, plain egg, simple egg, boring, flat lighting, dull, chibi, baby style
```

**Post-processing:**
- Remove background, extract egg on transparent PNG
- Apply subtle outer glow effect (gold, 4px radius) in Photoshop
- Ensure purple values are close to #2D1B69, adjust with Hue/Saturation if needed

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_egg_hub.png`
**Output size**: 256x256 (generate at 1024x1024)

**Midjourney Prompt:**
```
A small glowing dragon egg on a tiny golden nest, deep purple shell with gold veins, gentle pulsing magical glow, simple dark background, cute but not cartoonish, game sprite idle pose, side view, slight rocking motion implied, stylized fantasy digital painting, clean edges, isolated subject --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, complex background, text, watermark, chibi, pixel art, voxel
```

**Post-processing:**
- Extract on transparent background
- Downscale to 256x256 with bicubic sharper
- Add 1px soft edge anti-aliasing

---

### 1.2 Hatchling (Stage 1)

#### Portrait Version
**File**: `assets/images/dragons/dragon_hatchling.png`
**Output size**: 512x512 (generate at 1024x1024)

**Midjourney Prompt:**
```
A tiny dragon hatchling freshly emerged from its egg, small purple dragon with oversized expressive amber-gold eyes, stubby wings that are still wet and folded, round body with soft purple scales and a gold underbelly, small curved horns just beginning to grow, a single wisp of smoke from its nostrils, cracked eggshell fragments around its feet, curious wide-eyed expression, stylized semi-realistic cartoon, Wings of Fire art style, game character portrait, warm fantasy lighting, midnight blue background, NOT chibi NOT baby-cute, detailed scales --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A tiny dragon hatchling as a character portrait, freshly emerged from an egg. The hatchling is small with a round body covered in soft deep purple (#2D1B69) scales and a warm gold (#F4A261) underbelly. It has oversized but expressive amber-gold eyes, small curved horns just beginning to grow, and stubby wings that are still folded close to its body. A single wisp of smoke curls from one nostril. Broken eggshell fragments lie at its feet. The expression is curious and alert, not babyish. Background is midnight blue (#1A1A2E). Digital painting, game character portrait, warm lighting.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, chibi, super-deformed, baby dragon, diaper, pacifier, overly cute, bobblehead proportions, anime eyes too large, grimdark, scary, threatening, bad anatomy, deformed
```

**Post-processing:**
- Extract on transparent background
- Ensure consistent horn shape and eye color with other stages
- Color-correct purple toward #2D1B69 and gold toward #F4A261

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_hatchling_hub.png`
**Output size**: 256x256

**Midjourney Prompt:**
```
A tiny purple dragon hatchling sitting attentively, side view with head turned slightly toward viewer, stubby wings folded, gold underbelly, amber eyes, small horns, cute but not chibi, game sprite idle pose, clean simple composition, dark background, stylized fantasy digital painting, isolated subject --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, complex background, text, watermark, chibi, baby, diaper, pixel art
```

**Post-processing:**
- Transparent background extraction
- Downscale to 256x256

---

### 1.3 Fledgling (Stage 2)

#### Portrait Version
**File**: `assets/images/dragons/dragon_fledgling.png`
**Output size**: 512x512 (generate at 1024x1024)

**Midjourney Prompt:**
```
A young fledgling dragon slightly larger than a cat, purple scales becoming more defined and detailed, wings partially unfurled showing membrane detail, small curved horns growing longer, a small flame flickering from its open mouth, gold underbelly markings becoming more prominent, amber-gold eyes with a confident determined expression, perched on a stone ledge, stylized semi-realistic cartoon, Wings of Fire art style meets Clash Royale, game character portrait, warm fantasy lighting, midnight blue background, dynamic slight three-quarter pose --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A fledgling dragon character portrait. The dragon is about the size of a large cat, with increasingly defined deep purple (#2D1B69) scales and more prominent gold (#F4A261) underbelly markings. Its wings are partially unfurled, showing translucent purple membrane. The horns are slightly longer and more curved. A small flame flickers from its open mouth, tinged with orange (#E76F51). Its amber-gold eyes show a confident, determined expression. The dragon is perched on a stone ledge in a three-quarter pose. Background is midnight blue (#1A1A2E). Digital painting, game character portrait.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, chibi, baby dragon, adult dragon, fully grown, massive, scary, grimdark, deformed, bad anatomy, extra limbs, extra wings
```

**Post-processing:**
- Transparent background extraction
- Verify horn shape consistency with Hatchling and later stages
- Check that wing membrane style carries through

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_fledgling_hub.png`
**Output size**: 256x256

**Midjourney Prompt:**
```
A small fledgling purple dragon in idle standing pose, wings partially open, small flame from mouth, gold underbelly, amber eyes, slightly longer horns, alert posture, game sprite character, side view, clean dark background, stylized fantasy digital painting, isolated subject --ar 1:1 --s 750 --q 2 --v 7
```

---

### 1.4 Young Dragon (Stage 3)

#### Portrait Version
**File**: `assets/images/dragons/dragon_young.png`
**Output size**: 512x512 (generate at 1024x1024)

**Midjourney Prompt:**
```
A young dragon in full recognizable dragon form, medium-sized with powerful purple scales that catch the light, fully formed wings spread wide showing detailed purple membrane with gold veining, elegant curved horns, breathing a stream of bright orange and gold fire, muscular but lean build, gold underbelly scales clearly defined, fierce confident amber-gold eyes, claws gripping a rocky outcrop, stylized semi-realistic cartoon, Wings of Fire book cover quality, game character portrait, dramatic warm lighting from the fire breath, midnight blue background, heroic dynamic pose --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A young dragon in a heroic character portrait. The dragon is now in full recognizable dragon form -- medium-sized, muscular but lean, with powerful deep purple (#2D1B69) scales that shimmer in warm light. Wings are fully formed and spread wide, showing detailed purple membrane with veins of gold (#F4A261). Curved horns are elegant and prominent. The dragon breathes a stream of bright orange (#E76F51) and gold fire. Its underbelly displays clearly defined gold scales. Fierce, confident amber-gold eyes. Claws grip a rocky outcrop. Background is midnight blue (#1A1A2E). Digital painting, game character portrait, dramatic lighting from the fire breath.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, chibi, baby dragon, old dragon, wrinkled, ancient, runes on body, crown, accessories, deformed, bad anatomy, extra heads, extra wings
```

**Post-processing:**
- Transparent background extraction
- This is the KEY stage -- use this image as `--oref` in Midjourney for all other stages
- Verify anatomy (4 legs + 2 wings is the standard body plan for this dragon)
- Color-correct to palette

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_young_hub.png`
**Output size**: 256x256

**Midjourney Prompt:**
```
A young purple dragon standing proudly in idle pose, wings folded at sides, tail curled, gold underbelly, amber eyes, curved horns, small smoke wisps from nostrils, game sprite character, three-quarter front view, clean dark background, stylized fantasy digital painting, isolated --ar 1:1 --s 750 --q 2 --v 7
```

---

### 1.5 Adult Dragon (Stage 4)

#### Portrait Version
**File**: `assets/images/dragons/dragon_adult.png`
**Output size**: 512x512 (generate at 1024x1024)

**Midjourney Prompt:**
```
A fully grown majestic adult dragon, large and powerful with richly detailed deep purple scales, each scale individually rendered with iridescent highlights, massive wings spread in a dominant display, long elegant curved horns, powerful jaw breathing an intense torrent of golden-orange fire, muscular body with prominent gold underbelly armor-like scales, amber-gold eyes blazing with intelligence and power, battle-ready confident pose standing on a mountain peak, stylized semi-realistic cartoon, Wings of Fire meets Clash Royale, game character portrait, epic warm dramatic lighting, midnight blue sky background --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A majestic adult dragon in a powerful character portrait. Large and commanding, with richly detailed deep purple (#2D1B69) scales, each individually rendered with subtle iridescent highlights. Massive wings spread in a dominant display, showing thick membrane with prominent gold (#F4A261) veining. Long, elegant curved horns. Its powerful jaw breathes an intense torrent of golden-orange fire. Muscular body with prominent gold underbelly scales that resemble armor plating. Blazing amber-gold eyes radiate intelligence and power. Standing in a confident battle-ready pose. Background is midnight blue (#1A1A2E). Digital painting, game character portrait, epic warm dramatic lighting.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, chibi, baby dragon, old wrinkled, runes, crown, glowing markings, skeletal, undead, evil, deformed, bad anatomy, too many heads, western dragon cliche
```

**Post-processing:**
- Transparent background extraction
- Verify scale detail reads well at 512x512 (not too noisy)
- Ensure fire color gradient matches the Fire Gradient from design guide (#E76F51 -> #F4A261 -> #FFF3B0)

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_adult_hub.png`
**Output size**: 256x256

**Midjourney Prompt:**
```
A majestic adult purple dragon in regal idle pose, wings folded majestically, powerful build, gold underbelly armor scales, long curved horns, amber eyes, small ember glow from nostrils, confident calm expression, game sprite character, three-quarter view, dark background, stylized fantasy digital painting, isolated --ar 1:1 --s 750 --q 2 --v 7
```

---

### 1.6 Elder Dragon (Stage 5)

#### Portrait Version
**File**: `assets/images/dragons/dragon_elder.png`
**Output size**: 512x512 (generate at 1024x1024)

**Midjourney Prompt:**
```
An ancient elder dragon of immense wisdom and power, massive deep purple scales with faintly glowing emerald and gold arcane rune patterns etched into the scales, crown-like arrangement of horns on its head resembling a natural diadem, ancient amber-gold eyes that glow with inner magical light, surrounded by orbiting motes of purple and gold magical energy, wings that seem to shimmer with starlight, long sinuous body with the same gold underbelly markings now intricately patterned, wise serene yet powerful expression, stylized semi-realistic cartoon, Wings of Fire elder dragon meets Clash Royale legendary character, game character portrait, majestic mystical warm lighting, midnight blue cosmic background with faint stars --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
An ancient elder dragon in a majestic character portrait. Immense and wise, with deep purple (#2D1B69) scales that have faintly glowing emerald (#2A9D8F) and gold (#F4A261) arcane rune patterns naturally etched into them over centuries. Its horns have grown into a magnificent crown-like arrangement resembling a natural diadem. Ancient amber-gold eyes glow with inner magical light. The dragon is surrounded by slowly orbiting motes of purple and gold magical energy. Its wings shimmer with subtle starlight patterns. The gold underbelly scales now display intricate ancient patterns. Expression is wise, serene, yet powerful. Background is midnight blue (#1A1A2E) with faint cosmic stars. Digital painting, game character portrait, mystical warm lighting.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, chibi, baby dragon, decrepit, skeletal, undead, zombie dragon, evil, dark magic, necromancy, too much glow, overexposed, deformed, bad anatomy, wearing clothes, wearing armor
```

**Post-processing:**
- Transparent background extraction
- The glowing rune markings are KEY to distinguishing this stage -- enhance their glow in post if needed
- Add subtle particle overlay (gold/emerald motes) using Photoshop brush or the game engine
- Verify the crown-like horns are visually distinct from the Adult stage's horns

#### Hub Companion Version
**File**: `assets/images/dragons/dragon_elder_hub.png`
**Output size**: 256x256

**Midjourney Prompt:**
```
An ancient elder purple dragon in serene idle pose, glowing rune patterns on scales, crown-like horns, gold eyes glowing with wisdom, small orbiting magical motes, majestic calm posture, game sprite character, three-quarter view, dark starry background, stylized fantasy digital painting, isolated --ar 1:1 --s 750 --q 2 --v 7
```

---

## 2. Hub Environment

### 2.1 Hub Background

**File**: `assets/images/hub/hub_background.png`
**Output size**: 1920x1080 (generate natively at this aspect ratio)
**Aspect ratio**: 16:9

**Midjourney Prompt:**
```
Interior of a dragon's lair cave, warm and inviting atmosphere, glowing purple and blue crystals embedded in ancient stone walls, smooth worn stone floor with golden coin piles scattered about, arched stone ceiling with stalactites that have crystalline formations, four distinct alcoves or passages visible along the walls leading to different areas, warm amber torchlight mixed with cool crystal glow, ancient carved stonework with dragon motifs on the walls, NOT scary NOT dark NOT threatening, cozy fantasy home feeling, a large smooth stone in the center like a gathering spot, rich color palette of midnight blue #1A1A2E and deep purple #2D1B69 with warm gold #F4A261 highlights, stylized semi-realistic digital painting, game environment background, panoramic wide view --ar 16:9 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A wide panoramic view of a dragon's lair cave interior, serving as the main hub environment for a mobile game. The cave feels warm and inviting -- NOT dark or scary. Ancient stone walls are embedded with glowing purple and blue crystals. The smooth stone floor has small piles of golden coins scattered about. The arched ceiling features stalactites with crystalline formations. Four distinct passages or alcoves are visible along the walls, each leading to a different area. Warm amber torchlight mingles with cool crystal glow. Ancient carved stonework features dragon motifs. The color palette is midnight blue (#1A1A2E), deep purple (#2D1B69), and warm gold (#F4A261). Wide 16:9 composition. Digital painting, game environment background.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, people, dragons visible, scary, dark, horror, dungeons and dragons dungeon, prison, torture, cobwebs, skeletons, bones, grimdark, pixel art, low resolution
```

**Recommended settings:**
- Midjourney: `--ar 16:9`
- DALL-E 3: Request 1792x1024 (closest to 16:9)
- Leonardo: Set canvas to 1920x1080

**Post-processing:**
- May need to extend horizontally with AI outpainting for full 1920x1080 coverage
- Apply a subtle dark vignette at edges to frame the UI overlay area
- Ensure the center area is relatively clear (this is where the dragon companion sits)
- The top ~56dp should be slightly darker (the app bar will overlay here)
- Consider creating a slight parallax version (foreground and background layers) for subtle scroll effect

---

### 2.2 Rune Portal (Dragon Runes game entrance)

**File**: `assets/images/hub/hub_rune_portal.png`
**Output size**: 256x256 (generate at 1024x1024)
**Aspect ratio**: 1:1

**Midjourney Prompt:**
```
A glowing purple mystical rune circle carved into an ancient stone wall, the runes are ancient dragon script glyphs arranged in a perfect circle, the entire portal pulses with soft purple #9B59B6 and lavender #BB8FCE magical energy, wisps of purple light drift outward, carved stone frame around the circle with dragon claw marks, dark stone wall background, fantasy game portal entrance, stylized digital painting, game UI element, clean edges, centered composition, isolated element --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, people, stargate, sci-fi, technology, neon, too bright, overexposed
```

**Post-processing:**
- Extract on transparent background
- The portal must read clearly at 256x256 -- simplify details if needed
- Add animated glow effect in-engine (this static image is the base)

---

### 2.3 Fire Tunnel (Fire Trail game entrance)

**File**: `assets/images/hub/hub_fire_tunnel.png`
**Output size**: 256x256 (generate at 1024x1024)

**Midjourney Prompt:**
```
A tunnel entrance in a cave wall lit by roaring flames, orange and red fire licks along the tunnel edges, the interior glows with intense warm light fading to deep amber, carved stone archway with dragon scale patterns, embers and sparks floating upward, warm red #E74C3C and orange #E76F51 and gold #F4A261 color palette, dramatic fire lighting, fantasy game portal entrance, stylized digital painting, game UI element, clean edges, centered composition, isolated element on dark background --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, lava, volcano erupting, hellfire, demonic, skulls, scary, threatening to children
```

**Post-processing:**
- Extract on transparent background
- Ensure warm orange-red color range, not hellish or demonic red
- Fire should feel exciting and adventurous, not dangerous

---

### 2.4 Egg Nest (Dragon Eggs game entrance)

**File**: `assets/images/hub/hub_egg_nest.png`
**Output size**: 256x256 (generate at 1024x1024)

**Midjourney Prompt:**
```
A cliff-side dragon nest with several colorful eggs, the nest is made of woven branches and soft moss on a stone ledge, three or four eggs in warm colors cream blue green and orange, morning sunlight casting warm golden light, wisps of cloud around the cliff edge, blue sky visible behind, natural and warm feeling, mother-of-pearl sheen on the eggs, sky blue #3498DB accent color, fantasy game portal entrance, stylized digital painting, game UI element, clean edges, centered composition, isolated element --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, dragons visible, bird nest, chicken eggs, dark, scary, broken eggs, dead
```

**Post-processing:**
- Extract on transparent background
- Eggs should show distinct colors matching the game's egg palette (cream #F5E6CA, blue #AED6F1, green #A9DFBF, orange #F5CBA7)

---

### 2.5 Feast Table (Dragon's Feast game entrance)

**File**: `assets/images/hub/hub_feast_table.png`
**Output size**: 256x256 (generate at 1024x1024)

**Midjourney Prompt:**
```
A treasure-laden stone table or pedestal in a cave, covered with glittering gems of many colors including emerald green ruby red sapphire blue and gold, a golden goblet overflowing with sparkling jewels, green-tinted ambient light from emerald crystals nearby, treasure green #27AE60 accent color, rich and adventurous feeling, fantasy treasure hoard, game portal entrance element, stylized digital painting, game UI element, clean edges, centered composition, isolated element on dark background --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, pirate theme, skull and crossbones, dark evil treasure, cursed, cobwebs
```

**Post-processing:**
- Extract on transparent background
- Enhance green ambient glow to match the Dragon's Feast accent (#27AE60)

---

## 3. Game Backgrounds

All game backgrounds are 1920x1080, displayed behind the game canvas with slight darkening overlay. They should be atmospheric but not distracting.

### 3.1 Dragon Runes Background

**File**: `assets/images/games/runes/runes_background.png`
**Output size**: 1920x1080
**Aspect ratio**: 16:9

**Midjourney Prompt:**
```
An ancient stone chamber interior, walls covered in carved purple glowing runes and dragon script, mystical purple #9B59B6 and lavender light emanating from the rune carvings, smooth stone floor with a faint magical circle pattern, tall stone pillars with carved dragon reliefs, the atmosphere is mystical and scholarly like an ancient library of magic, NOT scary, midnight blue #1A1A2E base with purple accent lighting, dust motes floating in the magical light, arched ceiling with more rune carvings, wide panoramic game background, stylized semi-realistic digital painting, atmospheric environment art --ar 16:9 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
An ancient stone chamber serving as a game background. The walls are covered in carved runes and dragon script that glow with mystic purple (#9B59B6) and lavender (#BB8FCE) light. The stone floor features a faint magical circle pattern. Tall stone pillars with carved dragon reliefs support an arched ceiling with more rune carvings. The atmosphere is mystical and scholarly, like an ancient library of magic -- NOT scary or threatening. Base color is midnight blue (#1A1A2E) with purple accent lighting. Dust motes float in the magical light beams. Wide 16:9 panoramic composition. Digital painting, atmospheric game environment background.
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, bright, overexposed, horror, scary runes, blood, pentagram, demonic symbols, pixel art
```

**Post-processing:**
- Apply 15-20% dark overlay to reduce visual competition with game elements
- Ensure center area is relatively plain (game nodes will overlay here)
- May add subtle animated glow effect to runes in-engine

---

### 3.2 Fire Trail Background

**File**: `assets/images/games/fire_trail/fire_trail_background.png`
**Output size**: 1920x1080
**Aspect ratio**: 16:9

**Midjourney Prompt:**
```
A dramatic night sky view from above the clouds, stars visible in the deep midnight blue sky, a volcanic mountain range glowing orange and red on the distant horizon, wispy clouds lit from below by the volcanic glow, dynamic energy and sense of flight and speed, dragon red #E74C3C warm glow on the horizon fading to midnight blue #1A1A2E overhead, scattered bright stars, a crescent moon, sense of adventure and freedom, wide panoramic game background, stylized semi-realistic digital painting, atmospheric environment art --ar 16:9 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, ground level view, daytime, bright sky, too many clouds obscuring view, city lights, modern
```

**Post-processing:**
- The game grid overlays this, so keep the mid-section (where gameplay happens) relatively dark and uniform
- Enhance the horizon glow gradient
- Stars should be subtle, not overpowering

---

### 3.3 Dragon Eggs Background

**File**: `assets/images/games/dragon_eggs/dragon_eggs_background.png`
**Output size**: 1920x1080
**Aspect ratio**: 16:9

**Midjourney Prompt:**
```
A cliff-side nesting area at dawn, warm golden morning sunlight streaming across the scene, rocky cliff ledges with patches of green moss and small flowers, soft fluffy clouds in a gradient sky from warm orange at the horizon to soft blue above, gentle and natural feeling, distant mountain peaks visible, a few small dragon nests visible on ledge edges without eggs, sky blue #3498DB and warm gold #F4A261 color palette, serene and peaceful morning atmosphere, wide panoramic game background, stylized semi-realistic digital painting, atmospheric environment art --ar 16:9 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, eggs visible, dragons visible, dark, night, storm, rain, scary, cold, winter
```

**Post-processing:**
- Apply subtle dark overlay (10-15%) to prevent competition with egg sprites
- The sky gradient should be warm and inviting

---

### 3.4 Dragon's Feast Background

**File**: `assets/images/games/dragons_feast/feast_background.png`
**Output size**: 1920x1080
**Aspect ratio**: 16:9

**Midjourney Prompt:**
```
A vast treasure cavern interior, walls studded with crystals and gemstones of blue purple gold teal and red, golden light reflecting off gem-studded walls creating prismatic sparkles, ancient stone floor with worn pathways, tall gem-encrusted pillars, the atmosphere is rich and adventurous like discovering a treasure trove, treasure green #27AE60 and warm gold #F4A261 accent lighting, midnight blue #1A1A2E base darkness, a sense of wonder and excitement, wide panoramic game background, stylized semi-realistic digital painting, atmospheric environment art --ar 16:9 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic photo, blurry, text, watermark, characters, coins, specific treasure items, pirate, skull, skeleton, scary, dark dungeon, prison
```

**Post-processing:**
- Apply 20% dark overlay -- the 5x5 game grid overlays this
- Ensure gem colors are varied and match the game's gem categories
- Keep central area more uniform/darker for game grid visibility

---

## 4. Game-Specific Assets

### 4.1 Dragon Runes Assets

#### Rune Node (Inactive)
**File**: `assets/images/games/runes/rune_node_inactive.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single circular stone tablet with a faintly carved ancient rune glyph, the stone is dark grey #3D3D5C with a subtle purple #9B59B6 border ring, the rune carving is barely visible, dormant and unlit, smooth polished stone surface, isolated game element on solid black background, top-down view, perfectly circular, clean edges, stylized fantasy game asset, digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, bright glowing, active, energized, 3D render, complex, detailed carvings on edge
```

**Post-processing:**
- Extract on transparent background
- Ensure perfectly circular shape -- use circular mask if needed
- The node should be 64x64 and readable at that size
- Keep detail minimal; it needs to be clear at small sizes

#### Rune Node (Active)
**File**: `assets/images/games/runes/rune_node_active.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single circular stone tablet with a brightly glowing ancient rune glyph, the stone pulses with purple #9B59B6 magical energy, the rune carving glows lavender #BB8FCE white-hot, rays of magical light emanating outward, golden sparkle highlights, the stone border ring glows intensely, activated and magical, isolated game element on solid black background, top-down view, perfectly circular, clean edges, stylized fantasy game asset, digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, dark, dim, unlit, inactive, dull, 3D render
```

**Post-processing:**
- Extract on transparent background
- Enhance the glow bloom effect
- The active state must be clearly distinguishable from inactive at 64x64

#### Spell Particle
**File**: `assets/images/games/runes/rune_spell_particle.png`
**Output size**: 32x32 (generate at 512x512)

**Midjourney Prompt:**
```
A single point of magical energy, soft purple and gold sparkle, glowing orb with radiating light rays, magical particle effect, connection endpoint glow, simple luminous sphere with corona, isolated on solid black background, clean minimal, stylized fantasy game particle effect --ar 1:1 --s 500 --q 2 --v 7
```

**Post-processing:**
- Extract on transparent background
- This is a small particle effect -- keep it very simple
- Used as the endpoint glow on connection lines between rune nodes

---

### 4.2 Fire Trail Assets

#### Dragon Head (Player Character)
**File**: `assets/images/games/fire_trail/fire_dragon_head.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A small dragon head facing right in profile view, warm orange and red scales, bright amber eye, small curved horn, open mouth with a tiny flame, fierce but friendly expression, stylized game character sprite, clean simple design that reads well at very small sizes, solid green #00FF00 chroma key background, flat side view, game asset, digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, full body, wings, legs, complex, too detailed, scary, threatening, 3D render, pixel art
```

**Post-processing:**
- Green screen extraction to transparent background
- Must be clearly readable at 64x64 -- simplify if needed
- Facing RIGHT is important (this is the default direction; the app can mirror for left)
- Consider hand-touching in Aseprite for pixel-perfect edges at small size

#### Fire Gem (Correct Answer)
**File**: `assets/images/games/fire_trail/fire_gem_correct.png`
**Output size**: 48x48 (generate at 512x512)

**Midjourney Prompt:**
```
A single brilliant emerald green crystal gem, faceted and sparkling, glowing with inner emerald #2A9D8F light, small sparkle highlights, simple clean design, isolated game collectible item, solid black background, top-down slight angle view, stylized fantasy game asset, digital painting, jewel --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, multiple gems, ring, necklace, setting, complex, too detailed, dull, dark
```

**Post-processing:**
- Extract on transparent background
- Color-correct to emerald (#2A9D8F)
- Must sparkle and read clearly at 48x48
- Add subtle glow in engine for animation

#### Dark Crystal (Wrong Answer)
**File**: `assets/images/games/fire_trail/fire_gem_wrong.png`
**Output size**: 48x48 (generate at 512x512)

**Midjourney Prompt:**
```
A single dull reddish-brown crystal, rough and unpolished looking, murky dark red #C0392B and brown tones, no sparkle, slightly cracked, ominous but not scary, isolated game item, solid black background, top-down slight angle view, stylized fantasy game asset, digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, sparkling, beautiful, bright, glowing, green, blue, multiple crystals
```

**Post-processing:**
- Extract on transparent background
- Should be visually DISTINCT from the correct gem (dull vs sparkling, red-brown vs emerald)
- Must read clearly at 48x48

---

### 4.3 Dragon Eggs Assets

#### Egg Variations (4 colors)

Generate all four in the same session for style consistency. Each egg should have the same basic oval shape, slight speckled texture, and pearly sheen but with different base colors.

**File**: `assets/images/games/dragon_eggs/egg_cream.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt (Cream Egg):**
```
A single dragon egg, oval shaped with a slight point at top, warm cream #F5E6CA colored shell with subtle speckle pattern, mother-of-pearl iridescent sheen, smooth surface, soft warm lighting, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/games/dragon_eggs/egg_blue.png`
**Midjourney Prompt (Blue Egg):**
```
A single dragon egg, oval shaped with a slight point at top, soft blue #AED6F1 colored shell with subtle speckle pattern, mother-of-pearl iridescent sheen, smooth surface, soft cool lighting, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/games/dragon_eggs/egg_green.png`
**Midjourney Prompt (Green Egg):**
```
A single dragon egg, oval shaped with a slight point at top, soft green #A9DFBF colored shell with subtle speckle pattern, mother-of-pearl iridescent sheen, smooth surface, soft natural lighting, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/games/dragon_eggs/egg_orange.png`
**Midjourney Prompt (Orange Egg):**
```
A single dragon egg, oval shaped with a slight point at top, soft orange #F5CBA7 colored shell with subtle speckle pattern, mother-of-pearl iridescent sheen, smooth surface, soft warm lighting, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt (all eggs):**
```
realistic, blurry, text, watermark, chicken egg, cracked, broken, hatching, multiple eggs, nest, complex background
```

**Post-processing:**
- Extract all on transparent background
- Ensure consistent oval shape across all 4 colors
- Use the same mask/outline for all variants to guarantee size consistency

#### Operator Egg
**File**: `assets/images/games/dragon_eggs/egg_operator.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single dragon egg with a distinctive golden #F4D03F tint and a golden shimmer border ring around the middle, oval shape with slight point at top, the shell has a warm gold glow that distinguishes it from normal eggs, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

#### Division Egg
**File**: `assets/images/games/dragon_eggs/egg_division.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single dragon egg with a distinctive purple #8E44AD pattern, oval shape with slight point at top, the shell has swirling purple markings that distinguish it as special, faint magical glow, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

#### Cracked Egg (Stage 1 -- light cracks)
**File**: `assets/images/games/dragon_eggs/egg_crack_1.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single cream-colored dragon egg with visible hairline cracks forming on the surface, golden light seeping through the cracks from inside, the shell is still intact but stressed, oval shape, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

#### Cracked Egg (Stage 2 -- major cracks)
**File**: `assets/images/games/dragon_eggs/egg_crack_2.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A single cream-colored dragon egg with large cracks and pieces of shell breaking away, bright golden light bursting through the widening cracks, the egg is about to hatch, fragments lifting off, oval shape, isolated on solid black background, centered, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

#### Baby Dragon (Hatched)
**File**: `assets/images/games/dragon_eggs/baby_dragon_fly.png`
**Output size**: 48x48 (generate at 512x512)

**Midjourney Prompt:**
```
A tiny joyful baby dragon in flight, small round body with stubby flapping wings, mixed warm colors cream gold and soft purple, big happy amber eyes, tiny horns, mouth open in a happy squeak, dynamic flying pose heading upward, sparkle trail behind it, isolated on solid black background, small game sprite, stylized fantasy digital painting, cute but not chibi --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, large dragon, adult, scary, angry, chibi, anime, pixel art
```

**Post-processing:**
- Extract on transparent background
- Must be recognizably a dragon even at 48x48
- Keep silhouette simple and readable

---

### 4.4 Dragon's Feast Assets

#### Dragon Character (Player)
**File**: `assets/images/games/dragons_feast/feast_dragon.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A small friendly dragon character viewed from above at a three-quarter angle, green and gold scales, round compact body, small wings tucked, bright amber eyes, happy eager expression ready to eat, short tail, game character sprite for a grid-based game, isolated on solid green #00FF00 chroma key background, simple clean readable design, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, large dragon, scary, side view, complex, too detailed, fire breathing, flying
```

**Post-processing:**
- Green screen extraction to transparent background
- Must fit cleanly in a 64x64 grid cell
- Should be distinct from the enemy guardian in color and expression

#### Enemy Guardian
**File**: `assets/images/games/dragons_feast/feast_enemy_guardian.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A small menacing but not scary fantasy creature viewed from above at a three-quarter angle, dark red and purple scales, angular sharp features, glowing red-orange eyes, small horns, a wyrm or drake-like creature that serves as an enemy in a kids game, intimidating but age-appropriate, game character sprite for a grid-based game, isolated on solid green #00FF00 chroma key background, simple clean readable design, stylized fantasy digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, watermark, cute, friendly, large, scary horror, blood, gore, demon, skeleton, undead, weapons
```

**Post-processing:**
- Green screen extraction to transparent background
- Must contrast clearly with the player dragon (dark red/purple vs green/gold)
- Must be readable at 64x64

#### Grid Gems (6 varieties)

Generate all 6 in the same session for consistency. Each is a different colored gem with distinct faceting.

**Shared Negative Prompt for all gems:**
```
realistic, blurry, text, watermark, multiple gems, jewelry setting, ring, necklace, complex background
```

**File**: `assets/images/games/dragons_feast/feast_gem_blue.png`
**Midjourney Prompt:**
```
A single round-cut blue sapphire gem, brilliant blue #3498DB with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_gem_purple.png`
**Midjourney Prompt:**
```
A single diamond-cut amethyst gem, rich purple #9B59B6 with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_gem_gold.png`
**Midjourney Prompt:**
```
A single square-cut golden topaz gem, brilliant gold #F39C12 with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_gem_teal.png`
**Midjourney Prompt:**
```
A single cluster-style teal gem, brilliant teal #1ABC9C with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_gem_red.png`
**Midjourney Prompt:**
```
A single arrow-shaped red ruby gem, brilliant red #E74C3C with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_gem_green.png`
**Midjourney Prompt:**
```
A single split-style emerald gem, brilliant green #27AE60 with faceted surface and sparkle highlights, polished and luminous, isolated on solid black background, top-down view, game item sprite, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**Post-processing (all gems):**
- Extract on transparent background
- Downscale to 48x48 with bicubic sharper
- Each gem shape should be distinct (round, diamond, square, cluster, arrow, split) to help with category identification
- Color-correct to exact hex values listed

#### Power-Up Icons (3 types)

**File**: `assets/images/games/dragons_feast/feast_powerup_freeze.png`
**Output size**: 48x48 (generate at 512x512)

**Midjourney Prompt:**
```
A magical ice crystal power-up icon, pale ice blue #AED6F1 and white, snowflake-like crystalline form, frosted edges, cold magical glow, simple clean design readable at small size, isolated on solid black background, game item icon, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_powerup_wings.png`
**Output size**: 48x48

**Midjourney Prompt:**
```
A magical golden wings power-up icon, a pair of small stylized dragon wings, warm gold #F4A261 with shimmer highlights, magical golden particles, simple clean design readable at small size, isolated on solid black background, game item icon, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/games/dragons_feast/feast_powerup_shield.png`
**Output size**: 48x48

**Midjourney Prompt:**
```
A magical shield power-up icon, small round dragon scale shield, deep purple #4A2D8F with gold trim, faint magical barrier glow, protective energy radiating, simple clean design readable at small size, isolated on solid black background, game item icon, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**Negative Prompt (all power-ups):**
```
realistic, blurry, text, watermark, complex, large, detailed background, character holding it
```

**Post-processing:**
- Extract on transparent background
- Downscale to 48x48
- Add subtle glow matching the power-up color in engine

---

## 5. UI Elements

### 5.1 App Icon

**File**: `assets/images/ui/app_icon.png` (also exported to all required Android/iOS icon sizes)
**Output size**: 1024x1024 (generates at native resolution for both platform stores)
**Aspect ratio**: 1:1

**Midjourney Prompt:**
```
A compelling dragon face head icon for a mobile game app, front-facing symmetric dragon head, deep purple scales, piercing amber-gold eyes, small curved horns, slight smile showing a hint of teeth, warm gold highlights on scales, dramatic lighting from below, midnight blue background, the design must be recognizable and compelling at very small sizes like 32x32 pixels, simple bold shapes, high contrast, mobile game app icon style, stylized semi-realistic cartoon digital painting --ar 1:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A mobile game app icon featuring a front-facing dragon head. The dragon has deep purple (#2D1B69) scales, piercing amber-gold (#F4A261) eyes, small curved horns, and a slight confident smile showing just a hint of teeth. Warm gold highlights accent the scales. Dramatic lighting from below. Background is midnight blue (#1A1A2E). The design uses simple, bold shapes that remain recognizable and compelling at very small sizes (32x32 pixels). High contrast, symmetric composition. Digital painting, mobile game app icon format, 1024x1024.
```

**Negative Prompt:**
```
realistic photo, blurry, text, letters, words, watermark, full body, wings, complex details, busy background, multiple dragons, scary, horror
```

**Post-processing:**
- Round corners for Android (use Android Asset Studio)
- No transparency needed (solid background fills icon)
- Test at 16x16, 32x32, 48x48, 96x96, and 512x512 to ensure readability at all sizes
- The dragon's eyes must be the focal point even at tiny sizes
- Export to all platform-required sizes:
  - Android: 48x48, 72x72, 96x96, 144x144, 192x192, 512x512
  - iOS: 20x20, 29x29, 40x40, 58x58, 60x60, 76x76, 80x80, 87x87, 120x120, 152x152, 167x167, 180x180, 1024x1024

### 5.2 Achievement Badge Frame

**File**: `assets/images/ui/badge_frame.png`
**Output size**: 64x64 (generate at 512x512)

**Midjourney Prompt:**
```
A hexagonal golden badge frame, ornate fantasy-styled border with dragon scale pattern details, the interior of the hexagon is empty and transparent, warm gold #F4A261 metal with darker gold #D4843A shadows, subtle gem accents at each corner of the hexagon, isolated on solid green #00FF00 chroma key background, game UI element, badge frame, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, filled center, image inside frame, circular, square, simple, plain, modern
```

**Post-processing:**
- Extract on transparent background
- The CENTER must be fully transparent (achievement icons go inside)
- Export at 48x48 and 64x64 sizes
- Verify the hexagonal shape is clean and regular

### 5.3 Star (Filled)

**File**: `assets/images/ui/icon_star_filled.png`
**Output size**: 32x32 (generate at 512x512)

**Midjourney Prompt:**
```
A single fantasy-styled five-pointed star, warm gold #F4A261 with bright highlights, slightly three-dimensional with beveled edges, small sparkle effect at the top point, glowing with inner warmth, game UI rating star icon, isolated on solid black background, simple clean, stylized digital painting --ar 1:1 --s 500 --v 7
```

**Post-processing:**
- Extract on transparent background
- Downscale to 32x32 -- must be crisp and recognizable
- Also export at 16x16 and 24x24 for different contexts
- Consider hand-polishing edges at these small sizes

### 5.4 Star (Empty)

**File**: `assets/images/ui/icon_star_empty.png`
**Output size**: 32x32 (generate at 512x512)

**Midjourney Prompt:**
```
A single five-pointed star outline, grey #4A4A6A stroke with no fill, slightly three-dimensional with subtle beveled edges, same shape as a gold star but empty and unearned, game UI rating star placeholder icon, isolated on solid black background, simple clean, stylized digital painting --ar 1:1 --s 500 --v 7
```

**Post-processing:**
- Extract on transparent background
- Must have the EXACT same silhouette/shape as the filled star
- Downscale to 32x32

### 5.5 Dragon Scale (Currency Icon)

**File**: `assets/images/ui/icon_scale.png`
**Output sizes**: 16x16, 24x24, 32x32 (generate at 512x512)

**Midjourney Prompt:**
```
A single golden dragon scale, teardrop or shield-shaped, warm gold #F4A261 with subtle ridge texture lines, metallic sheen, slight three-dimensional depth, a fantasy currency icon, clean simple design that reads at very small sizes, isolated on solid black background, game UI currency icon, stylized digital painting --ar 1:1 --s 500 --v 7
```

**Negative Prompt:**
```
realistic, blurry, text, fish scale, armor, multiple scales, complex, coin, circular
```

**Post-processing:**
- Extract on transparent background
- Export at 16x16, 24x24, and 32x32
- At 16x16 the scale shape and gold color must still be recognizable
- Hand-polish at small sizes in Aseprite if needed

### 5.6 Streak Flame Icon

**File**: `assets/images/ui/icon_streak_flame.png`
**Output size**: 24x24 (generate at 512x512)

**Midjourney Prompt:**
```
A single stylized fire flame icon, warm orange #E76F51 at the base transitioning to bright gold #F4A261 at the tips, dynamic upward shape, small and clean, game UI streak indicator icon, isolated on solid black background, simple bold design, stylized digital painting --ar 1:1 --s 500 --v 7
```

**Post-processing:**
- Extract on transparent background
- Downscale to 24x24
- The flame shape should be bold and recognizable even at 24x24
- Must look good next to numbers (streak counter displays as "flame + x7")

### 5.7 Feature Graphic (Google Play Store)

**File**: `assets/images/ui/feature_graphic.png`
**Output size**: 1024x500
**Aspect ratio**: ~2:1

**Midjourney Prompt:**
```
A wide banner for a mobile game called Math Dragons, a majestic purple and gold dragon on the right side breathing fire that arcs across the scene, the fire transitions into glowing mathematical symbols and runes, deep purple and midnight blue background with golden accents, emerald crystal formations on the left, epic and inviting fantasy atmosphere, space for a game title on the left third, warm dramatic lighting, stylized semi-realistic cartoon, Wings of Fire quality art, game promotional banner --ar 2:1 --s 750 --q 2 --v 7
```

**DALL-E 3 Prompt:**
```
[STYLE_PREFIX]
A wide promotional banner (1024x500) for a mobile game called "Math Dragons". On the right side, a majestic purple (#2D1B69) and gold (#F4A261) dragon breathes fire that arcs across the scene, with the fire cleverly transitioning into glowing mathematical symbols and ancient runes. The background is deep purple and midnight blue (#1A1A2E) with golden accents. Emerald (#2A9D8F) crystal formations appear on the left side. The left third of the image has relatively clear space for the game title to be overlaid as text. Epic, inviting fantasy atmosphere with warm dramatic lighting. Digital painting, game promotional banner.
```

**Negative Prompt:**
```
realistic photo, blurry, text, title text, game name text, logo, letters, words, watermark, scary, dark, horror, simple, flat, boring
```

**Post-processing:**
- DO NOT include text in the AI generation -- add the "Math Dragons" title and tagline in Photoshop using the Cinzel Bold font
- Title text: "MATH DRAGONS" in Cinzel Bold, gold (#F4A261) with dark purple (#1A0F3D) stroke/shadow
- Optional tagline below: "Master Math. Grow Your Dragon." in Nunito SemiBold, warm white (#F0E6D3)
- Ensure the left third has clear space for this text overlay
- Final size must be exactly 1024x500 for Google Play requirements

---

## 6. Store / Cosmetic Assets

### 6.1 Dragon Color Variants

Each dragon color variant needs a small portrait showing the base dragon (use Stage 3 Young Dragon as the base form) recolored to the variant color. Generate at 512x512, export at 128x128.

These map to the cosmetic items defined in the store code:

| Code ID | Display Name | Primary Color | Secondary Color | Hex |
|---------|-------------|---------------|-----------------|-----|
| (default) | Default | Purple | Gold | #2D1B69 / #F4A261 |
| color_crimson | Crimson | Deep Red | Dark Gold | #DC143C / #C0392B |
| color_sapphire | Sapphire | Rich Blue | Silver | #0F52BA / #B0C4DE |
| color_emerald | Emerald | Rich Green | Gold | #50C878 / #F4A261 |
| color_amethyst | Amethyst | Violet | Lavender | #9966CC / #E6D0FF |
| color_gold | Golden | Rich Gold | Warm White | #FFD700 / #FFF8DC |
| color_obsidian | Obsidian | Near Black | Dark Red | #1C1C1C / #8B0000 |
| color_frost | Frost | Ice Blue | White | #ADD8E6 / #F0F8FF |
| color_sunset | Sunset | Orange-Red | Warm Gold | #FF6347 / #F4A261 |

**Base Midjourney Prompt Template (replace [PRIMARY_COLOR], [SECONDARY_COLOR], [COLOR_NAME]):**
```
A young dragon portrait head and upper body, [COLOR_NAME] colored scales as primary color [PRIMARY_COLOR], [SECONDARY_COLOR] underbelly and highlights, same dragon anatomy as purple original but recolored, amber eyes, curved horns, confident expression, small fire wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background, centered composition --ar 1:1 --s 750 --q 2 --v 7 --oref [YOUNG_DRAGON_IMAGE_URL] --ow 300
```

**Individual prompts:**

**File**: `assets/images/dragons/dragon_color_variant_default.png`
*(Use the Stage 3 portrait directly -- no new generation needed)*

**File**: `assets/images/dragons/dragon_color_variant_crimson.png`
```
A young dragon portrait head and upper body, deep crimson red scales #DC143C as primary color, dark gold underbelly and highlights, same dragon anatomy as the reference, amber eyes, curved horns, confident fierce expression, small fire wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_sapphire.png`
```
A young dragon portrait head and upper body, rich sapphire blue scales #0F52BA as primary color, silver-blue underbelly and highlights, same dragon anatomy as the reference, bright blue eyes, curved horns, regal calm expression, small frost wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_emerald.png`
```
A young dragon portrait head and upper body, rich emerald green scales #50C878 as primary color, warm gold underbelly and highlights, same dragon anatomy as the reference, bright green eyes, curved horns, alert expression, small nature wisps with leaves, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_amethyst.png`
```
A young dragon portrait head and upper body, soft violet amethyst scales #9966CC as primary color, lavender underbelly and highlights, same dragon anatomy as the reference, purple glowing eyes, curved horns, mystical serene expression, small purple magical wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_gold.png`
```
A young dragon portrait head and upper body, brilliant golden scales #FFD700 as primary color, warm white underbelly and highlights, same dragon anatomy as the reference, amber-gold glowing eyes, curved horns, radiant proud expression, golden light emanating, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_obsidian.png`
```
A young dragon portrait head and upper body, near-black obsidian scales #1C1C1C with subtle dark reflections, dark red underbelly and highlights #8B0000, same dragon anatomy as the reference, red glowing eyes, curved horns, mysterious intense expression, dark smoke wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean very dark background with subtle contrast --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_frost.png`
```
A young dragon portrait head and upper body, pale ice blue frost scales #ADD8E6 with crystalline sheen, white and silver underbelly and highlights, same dragon anatomy as the reference, icy blue eyes, curved horns with frost crystals, calm cool expression, frost and snowflake wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**File**: `assets/images/dragons/dragon_color_variant_sunset.png`
```
A young dragon portrait head and upper body, warm sunset orange-red scales #FF6347 transitioning to gold, warm gold underbelly and highlights, same dragon anatomy as the reference, warm amber eyes, curved horns, energetic joyful expression, warm ember wisps, stylized semi-realistic cartoon, Wings of Fire style, game character portrait icon, clean dark background --ar 1:1 --s 750 --q 2 --v 7
```

**Negative Prompt (all variants):**
```
realistic photo, blurry, text, watermark, chibi, baby dragon, elder dragon, runes on body, accessories, crown, armor, full body, wings fully spread, deformed, bad anatomy
```

**Post-processing (all variants):**
- Extract on transparent background
- Downscale to 128x128
- Color-correct to ensure primary colors match the hex values in the table
- All variants must have the same crop/framing for visual consistency in the store grid
- The obsidian variant needs careful handling -- ensure it reads against the dark store UI background (add a very subtle lighter edge/rim light)

### 6.2 Dragon Accessories

Each accessory is a standalone item on transparent background, designed to be overlaid on the dragon portrait. Generate at 512x512, export at 64x64.

These map to the cosmetic accessories in the store code:

**File**: `assets/images/dragons/acc_crown.png`

**Midjourney Prompt:**
```
A small ornate golden dragon crown, fantasy style with dragon wing-shaped points, set with small purple amethyst gems, warm gold #F4A261 metal, designed to sit on top of a dragon's head between horns, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, simple clean design, stylized fantasy digital painting, top-down slight angle --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/dragons/acc_scarf.png`

**Midjourney Prompt:**
```
A small cozy knitted scarf in deep purple and gold stripes, slightly flowing as if in wind, fantasy styled with small dragon scale clasps, designed to wrap around a dragon's neck, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, simple clean design, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/dragons/acc_battle_armor.png`

**Midjourney Prompt:**
```
A small set of fantasy dragon battle armor, chest plate and shoulder guards, dark steel with gold #F4A261 trim and purple gemstone accents, dragon scale texture on the metal, battle-ready but ornamental, designed to fit a dragon's chest and shoulders, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/dragons/acc_wizard_hat.png`

**Midjourney Prompt:**
```
A small pointed wizard hat for a dragon, deep purple fabric with gold star and moon embroidery, slightly drooping tip, a golden buckle or clasp where the brim meets the cone, magical sparkle accents, designed to perch on a dragon's head, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/dragons/acc_necklace.png`

**Midjourney Prompt:**
```
A fantasy necklace or pendant for a dragon, golden chain with a large emerald #2A9D8F gemstone pendant, ornate dragon claw setting holding the gem, magical inner glow from the gemstone, designed to hang around a dragon's neck, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**File**: `assets/images/dragons/acc_wing_decorations.png`

**Midjourney Prompt:**
```
A set of ornamental wing decorations for a dragon, delicate golden chains with small gemstones and dangling charms that attach along wing edges, gold and purple color scheme, jewelry-like quality, fantasy ornamental, designed to drape along dragon wing membranes, isolated on solid green #00FF00 chroma key background, game cosmetic accessory item, stylized fantasy digital painting --ar 1:1 --s 750 --v 7
```

**Negative Prompt (all accessories):**
```
realistic photo, blurry, text, watermark, human-sized, character wearing it, full dragon visible, complex background, modern style, plain, boring
```

**Post-processing (all accessories):**
- Green screen extraction to transparent background
- Downscale to 64x64
- Each accessory must have a recognizable silhouette at 64x64
- Accessories are displayed both standalone (in store) and overlaid on dragon portraits (in preview)
- Test overlay positioning on the dragon portrait to ensure they look natural

**Note on store code alignment:** The existing store code uses the IDs `acc_crown`, `acc_scarf`, `acc_glasses`, `acc_hat`, `acc_bow`, `acc_shield`. The prompts above cover crown, scarf, battle armor (which could replace glasses), wizard hat (maps to hat), necklace (could replace bow), and wing decorations (could replace shield). Adjust the file names and prompt descriptions to match whichever set of accessories you finalize in the code. The current code's emoji placeholders will be replaced by these generated images.

---

## Appendix A: Complete File Manifest

Summary of all files to generate, organized by output directory:

```
assets/images/dragons/
  dragon_egg.png                        512x512    Stage 0 portrait
  dragon_egg_hub.png                    256x256    Stage 0 hub companion
  dragon_hatchling.png                  512x512    Stage 1 portrait
  dragon_hatchling_hub.png              256x256    Stage 1 hub companion
  dragon_fledgling.png                  512x512    Stage 2 portrait
  dragon_fledgling_hub.png              256x256    Stage 2 hub companion
  dragon_young.png                      512x512    Stage 3 portrait (ANCHOR)
  dragon_young_hub.png                  256x256    Stage 3 hub companion
  dragon_adult.png                      512x512    Stage 4 portrait
  dragon_adult_hub.png                  256x256    Stage 4 hub companion
  dragon_elder.png                      512x512    Stage 5 portrait
  dragon_elder_hub.png                  256x256    Stage 5 hub companion
  dragon_color_variant_crimson.png      128x128    Store color variant
  dragon_color_variant_sapphire.png     128x128    Store color variant
  dragon_color_variant_emerald.png      128x128    Store color variant
  dragon_color_variant_amethyst.png     128x128    Store color variant
  dragon_color_variant_gold.png         128x128    Store color variant
  dragon_color_variant_obsidian.png     128x128    Store color variant
  dragon_color_variant_frost.png        128x128    Store color variant
  dragon_color_variant_sunset.png       128x128    Store color variant
  acc_crown.png                         64x64      Cosmetic accessory
  acc_scarf.png                         64x64      Cosmetic accessory
  acc_battle_armor.png                  64x64      Cosmetic accessory
  acc_wizard_hat.png                    64x64      Cosmetic accessory
  acc_necklace.png                      64x64      Cosmetic accessory
  acc_wing_decorations.png              64x64      Cosmetic accessory

assets/images/hub/
  hub_background.png                    1920x1080  Hub environment
  hub_rune_portal.png                   256x256    Game portal
  hub_fire_tunnel.png                   256x256    Game portal
  hub_egg_nest.png                      256x256    Game portal
  hub_feast_table.png                   256x256    Game portal

assets/images/games/runes/
  runes_background.png                  1920x1080  Game background
  rune_node_inactive.png                64x64      Game element
  rune_node_active.png                  64x64      Game element
  rune_spell_particle.png               32x32      Particle effect

assets/images/games/fire_trail/
  fire_trail_background.png             1920x1080  Game background
  fire_dragon_head.png                  64x64      Player character
  fire_gem_correct.png                  48x48      Correct answer
  fire_gem_wrong.png                    48x48      Wrong answer

assets/images/games/dragon_eggs/
  dragon_eggs_background.png            1920x1080  Game background
  egg_cream.png                         64x64      Number egg
  egg_blue.png                          64x64      Number egg
  egg_green.png                         64x64      Number egg
  egg_orange.png                        64x64      Number egg
  egg_operator.png                      64x64      Operator egg
  egg_division.png                      64x64      Division egg
  egg_crack_1.png                       64x64      Cracking stage 1
  egg_crack_2.png                       64x64      Cracking stage 2
  baby_dragon_fly.png                   48x48      Hatched baby dragon

assets/images/games/dragons_feast/
  feast_background.png                  1920x1080  Game background
  feast_dragon.png                      64x64      Player character
  feast_enemy_guardian.png              64x64      Enemy character
  feast_gem_blue.png                    48x48      Category gem
  feast_gem_purple.png                  48x48      Category gem
  feast_gem_gold.png                    48x48      Category gem
  feast_gem_teal.png                    48x48      Category gem
  feast_gem_red.png                     48x48      Category gem
  feast_gem_green.png                   48x48      Category gem
  feast_powerup_freeze.png              48x48      Power-up icon
  feast_powerup_wings.png               48x48      Power-up icon
  feast_powerup_shield.png              48x48      Power-up icon

assets/images/ui/
  app_icon.png                          1024x1024  App store icon
  badge_frame.png                       64x64      Achievement frame
  icon_star_filled.png                  32x32      Rating star
  icon_star_empty.png                   32x32      Rating star placeholder
  icon_scale.png                        32x32      Currency (also 16, 24)
  icon_streak_flame.png                 24x24      Streak indicator
  feature_graphic.png                   1024x500   Google Play banner
```

**Total: 75 individual image assets**

---

## Appendix B: Recommended Generation Order

Follow this order for maximum efficiency and consistency:

### Phase 1: Establish Style (Day 1)
1. Generate the **Style Anchor Image** (Section 0.1)
2. Iterate until the art style is exactly right
3. Save the anchor URL/seed for all future prompts

### Phase 2: Hero Dragon (Day 1-2)
4. Generate **Stage 3 Young Dragon Portrait** -- this is the most important image
5. Iterate until the dragon's design is locked (horn shape, eye color, face structure, body proportions)
6. Use this as `--oref` reference for all subsequent dragon images

### Phase 3: Dragon Evolution (Day 2-3)
7. Generate Stages 0-2 (Egg, Hatchling, Fledgling) -- working backward from Stage 3
8. Generate Stages 4-5 (Adult, Elder) -- working forward from Stage 3
9. Generate all 6 Hub Companion versions
10. Generate all 8 color variants

### Phase 4: Environments (Day 3-4)
11. Generate Hub Background
12. Generate all 4 Game Backgrounds
13. Generate all 4 Hub Portal elements

### Phase 5: Game Assets (Day 4-5)
14. Dragon Runes assets (3 images)
15. Fire Trail assets (3 images)
16. Dragon Eggs assets (9 images)
17. Dragon's Feast assets (12 images)

### Phase 6: UI and Store (Day 5-6)
18. App Icon
19. UI elements (stars, scale, flame, badge)
20. Feature Graphic
21. Accessories (6 images)

### Phase 7: Post-Processing (Day 6-7)
22. Background removal on all assets needing transparency
23. Color correction pass on all assets
24. Downscaling to final sizes
25. Edge cleanup on small assets
26. Test all assets in-app at actual display sizes
27. Iterate on any assets that do not look right in context

---

## Appendix C: Quality Checklist

Before finalizing each asset, verify:

- [ ] **Color palette**: Purple reads as #2D1B69 range, gold reads as #F4A261 range
- [ ] **Style consistency**: Matches the anchor image's art style
- [ ] **Size readability**: Asset is recognizable at its FINAL display size (not just generate size)
- [ ] **Transparency**: Clean alpha channel, no halos or fringe from background removal
- [ ] **File format**: PNG-32 with alpha for transparent assets, PNG-24 for opaque backgrounds
- [ ] **File naming**: Matches the exact names in the Visual Design Guide / asset manifest
- [ ] **No text**: AI-generated text is NEVER acceptable -- add all text in post-processing
- [ ] **Age-appropriate**: Nothing scary, violent, or disturbing -- suitable for ages 7+
- [ ] **Not chibi**: Dragons look like real (stylized) dragons, not baby/chibi characters
- [ ] **Dragon consistency**: Same horn shape, eye color, and body plan across all evolution stages
- [ ] **Performance**: File sizes are reasonable for mobile (aim for <500KB per asset, <2MB for backgrounds)

---

*Document created: 2026-02-16*
*For use with: Math Dragons mobile game (Flutter)*
*Compatible with: Midjourney V7, GPT Image 1/1.5, Leonardo AI*
