# Math Dragons Asset Generator

Automated asset generation pipeline for Math Dragons. Uses Claude Code
custom slash commands backed by a Python CLI to generate all 75+ images
and 18 sound effects needed for the game.

## Setup

1. Install Python dependencies:
   ```bash
   pip install -r tools/asset_generator/requirements.txt
   ```

2. Install pngquant (for PNG compression):
   ```bash
   scoop install pngquant
   ```

3. Create `.env` file from template:
   ```bash
   cp tools/asset_generator/.env.example tools/asset_generator/.env
   ```
   Then add your API keys to `tools/asset_generator/.env`:
   - `OPENAI_API_KEY` — from https://platform.openai.com/api-keys
   - `ELEVENLABS_API_KEY` — from https://elevenlabs.io/app/settings/api-keys

That's it. No MCP server to configure or restart — the commands work
immediately.

## Quick Start

The pipeline is driven by **5 custom slash commands** that you invoke
directly in Claude Code:

| Command | What it does |
|---|---|
| `/generate-image` | Generate images via OpenAI GPT-Image-1 |
| `/generate-sfx` | Generate sound effects via ElevenLabs |
| `/generate-music` | Generate or source background music |
| `/process-image` | Post-process: bg removal, resize, compress |
| `/asset-status` | Check what's generated vs. what's missing |

Just type the command followed by what you want. Examples:

```
/generate-image a dragon hatchling portrait, 512x512, transparent background
/generate-sfx a short magical chime for correct answers, save to assets/audio/sfx/correct.mp3
/process-image resize all dragons to 512x512 and compress
/asset-status what images are we missing?
```

## CLI Reference

Under the hood, the slash commands use `tools/asset_generator/cli.py`.
You can also call it directly:

```bash
python tools/asset_generator/cli.py <command> [options]
```

| Subcommand | Purpose | API |
|---|---|---|
| `image` | Generate a game image | OpenAI GPT-Image-1 |
| `style-candidates` | Generate style bible exploration images | OpenAI GPT-Image-1 |
| `sfx` | Generate a sound effect | ElevenLabs |
| `remove-bg` | Remove image background | rembg (local) |
| `resize` | Resize + density variants | Pillow (local) |
| `compress` | Compress PNGs | pngquant (local) |
| `post-process` | Full pipeline: bg removal + resize + compress | local |
| `list-assets` | Report found/missing assets vs. manifest | local |

Run `python tools/asset_generator/cli.py <command> --help` for full
option details.

---

## Practical Workflow

The entire asset generation process has 4 phases. All paths below are
relative to `math_dragons/`.

### Phase 1: Create the Style Bible (~$3-5)

The style bible is a set of 5-10 curated reference images that define the
visual look of the game. Every subsequent image generation uses these as
style references so all assets look consistent.

**Step 1 — Generate candidates.** Ask Claude:

> Generate style bible candidates for Math Dragons. Use the style anchor
> prompt from `docs/step12/ART_GENERATION_PROMPTS.md` Section 0.1. Create
> 5-8 variations, saving to `assets/style_bible/candidates/`. Try different
> phrasings that explore the "stylized semi-realistic cartoon, Wings of Fire
> meets Clash Royale" look.

Claude will run:

```bash
python tools/asset_generator/cli.py style-candidates \
  "A majestic purple and gold dragon in a crystal-lit cavern, stylized
   semi-realistic cartoon digital painting, detailed scales with warm
   highlights, expressive amber eyes, rich fantasy color palette of deep
   purple and warm gold with emerald accents, midnight blue background,
   game art quality, Wings of Fire book cover meets Clash Royale character" \
  -n 4 -o assets/style_bible/candidates -q medium
```

Repeat with 4-6 prompt variations to get 16-24 candidate images.

**Step 2 — Curate manually.** Open `assets/style_bible/candidates/` in your
file browser. Delete images you don't like. Move the 5-10 best ones to
`assets/style_bible/approved/`.

**Step 3 — Validate consistency.** Ask Claude:

> Generate 3 test assets using the approved style bible as references.
> Try a dragon portrait, a background, and a UI icon. Use the approved
> images in `assets/style_bible/approved/` as style_refs.

```bash
python tools/asset_generator/cli.py image \
  "A tiny dragon hatchling with purple scales and gold underbelly,
   oversized amber eyes, small curved horns, curious expression, digital
   painting, game character portrait, midnight blue background" \
  -o assets/style_bible/test/dragon_test.png \
  -r assets/style_bible/approved/candidate_1.png \
     assets/style_bible/approved/candidate_2.png \
  -q high
```

If the results look wrong, go back to Step 1 with refined prompts.

---

### Phase 2: Generate All 75 Images (~$15)

Once the style bible is approved, generate every asset. The prompts are all
in `docs/step12/ART_GENERATION_PROMPTS.md` under the "DALL-E 3 Prompt"
sections (these work best with GPT-Image-1).

**Recommended approach — ask Claude:**

> Read `docs/step12/ART_GENERATION_PROMPTS.md` and generate all 75 images.
> For each asset, use the DALL-E 3 prompt variant from the catalog. Pass
> all approved style bible images as style_refs. Save each image to its
> documented output path. After generating each image, post-process it to
> remove the background and resize to the documented output size.

Claude will iterate through each asset:

```bash
# 1. Generate the raw image
python tools/asset_generator/cli.py image \
  "[STYLE_PREFIX] A large dragon egg centered in the frame as a character
   portrait. Deep purple shell with swirling veins of warm gold that pulse
   with inner magical light. Faint emerald energy seeps through hairline
   cracks. Background is midnight blue. Digital painting, game character
   portrait format." \
  -o assets/images/dragons/dragon_egg_raw.png \
  -r assets/style_bible/approved/anchor_1.png \
     assets/style_bible/approved/anchor_2.png \
     assets/style_bible/approved/anchor_3.png \
  -q high

# 2. Post-process: remove bg, resize to 512x512, compress
python tools/asset_generator/cli.py post-process \
  assets/images/dragons/dragon_egg_raw.png \
  -o assets/images/dragons/dragon_egg.png \
  -s 512x512 -q 80-95
```

**Asset categories and counts:**

| Category | Count | Output Directory | Typical Size |
|---|---|---|---|
| Dragon Evolution Portraits | 6 | `assets/images/dragons/` | 512x512 |
| Dragon Hub Companions | 6 | `assets/images/dragons/` | 256x256 |
| Hub Environment | 5 | `assets/images/hub/` | varies |
| Game Backgrounds | 4 | `assets/images/games/` | 1920x1080 |
| Game-Specific Assets | ~30 | `assets/images/games/` | varies |
| UI Elements | 10 | `assets/images/ui/` | 48x48 to 128x128 |
| Store/Cosmetic Assets | 14 | `assets/images/ui/` | varies |

**For UI icons that need density variants** (badges, small icons):

```bash
python tools/asset_generator/cli.py post-process \
  assets/images/ui/scales_icon_raw.png \
  -o assets/images/ui/scales_icon.png \
  -s 48x48 -d -q 80-95
```

The `-d` flag creates 1x, 1.5x, 2x, 3x, 4x variants in subdirectories.

**For game backgrounds** (no transparency, landscape aspect):

```bash
python tools/asset_generator/cli.py image \
  "A grand dragon's cavern interior, crystal formations, ancient stonework,
   deep purple and midnight blue color scheme with gold crystal accents,
   atmospheric fog, panoramic wide view, fantasy game background, digital
   painting" \
  -o assets/images/hub/hub_background.png \
  -r assets/style_bible/approved/anchor_1.png \
  -s 1536x1024 --opaque -q high
```

**Checking progress.** At any point:

```
/project:asset-status what images are still missing?
```

Or directly:

```bash
python tools/asset_generator/cli.py list-assets --dir assets/images
```

---

### Phase 3: Generate Sound Effects (~$5)

15 of the 18 SFX are generated via ElevenLabs. The other 3 (button_tap,
countdown, swipe) are generic UI sounds better sourced from free packs
like [Kenney.nl UI Audio](https://kenney.nl/assets/ui-audio) (CC0 license).

**Ask Claude:**

> Generate all 15 custom sound effects for Math Dragons. Read the SFX
> list from `docs/step12/AUDIO_INTEGRATION_PLAN.md` Section 6. Save each
> to `assets/audio/sfx/`. Use descriptive prompts that specify the mood
> and context (children's game, magical/fantasy theme).

Example CLI calls:

```bash
# Correct answer chime
python tools/asset_generator/cli.py sfx \
  "Short bright magical chime, rewarding and positive, like collecting a
   gem in a children's fantasy game, sparkling crystalline tone, 0.5 seconds" \
  -o assets/audio/sfx/correct.mp3 -d 0.5 --prompt-influence 0.5

# Wrong answer buzz
python tools/asset_generator/cli.py sfx \
  "Short gentle negative feedback sound, soft low-pitched thud with a slight
   magical fizzle, not harsh or scary, suitable for a children's game,
   0.4 seconds" \
  -o assets/audio/sfx/wrong.mp3 -d 0.4 --prompt-influence 0.5

# Streak bonus
python tools/asset_generator/cli.py sfx \
  "Ascending three-note magical fanfare, bright and exciting, like a power-up
   activation in a fantasy game, sparkling with a sense of building momentum,
   0.8 seconds" \
  -o assets/audio/sfx/streak.mp3 -d 0.8

# Level complete
python tools/asset_generator/cli.py sfx \
  "Triumphant short victory fanfare with magical sparkles, ascending melody
   that feels rewarding and celebratory, fantasy RPG style, suitable for
   children, 1.5 seconds" \
  -o assets/audio/sfx/level_complete.mp3 -d 1.5

# Achievement unlocked
python tools/asset_generator/cli.py sfx \
  "Grand achievement unlock sound, deep resonant gong followed by bright
   ascending chimes and sparkles, majestic and rewarding, fantasy RPG style,
   2 seconds" \
  -o assets/audio/sfx/achievement.mp3 -d 2.0

# Dragon roar
python tools/asset_generator/cli.py sfx \
  "Friendly young dragon roar, not scary, more like an excited puppy-sized
   dragon trying to be fierce, with a slight magical echo, fantasy cartoon
   style, 1 second" \
  -o assets/audio/sfx/dragon_roar.mp3 -d 1.0

# Evolution transformation
python tools/asset_generator/cli.py sfx \
  "Magical transformation sound, building shimmer that crescendos into a
   burst of energy, like a dragon evolving to its next stage, mystical and
   awe-inspiring, fantasy game, 2.5 seconds" \
  -o assets/audio/sfx/evolution.mp3 -d 2.5

# Egg crack
python tools/asset_generator/cli.py sfx \
  "Delicate cracking sound of a magical dragon egg, crystalline shell
   fracturing with faint magical energy wisps, gentle and mysterious,
   0.6 seconds" \
  -o assets/audio/sfx/egg_crack.mp3 -d 0.6

# Egg hatch
python tools/asset_generator/cli.py sfx \
  "Dragon egg hatching open with a burst of magical energy, shell breaking
   apart with a shimmer of sparkling light, warm and wondrous feeling,
   1.2 seconds" \
  -o assets/audio/sfx/egg_hatch.mp3 -d 1.2

# Munch (Dragon's Feast eating sound)
python tools/asset_generator/cli.py sfx \
  "Quick satisfying chomp or munch sound, like a small dragon eating a
   number tile, slightly magical with a subtle sparkle, cartoon style,
   0.3 seconds" \
  -o assets/audio/sfx/munch.mp3 -d 0.3

# Scales earned (currency)
python tools/asset_generator/cli.py sfx \
  "Light coin or gem collection sound, bright metallic clink with a magical
   shimmer, like collecting dragon scales as currency, satisfying and quick,
   0.4 seconds" \
  -o assets/audio/sfx/scales_earn.mp3 -d 0.4

# Game over
python tools/asset_generator/cli.py sfx \
  "Gentle game over sound, descending soft tones that feel a bit sad but not
   harsh, with a slight magical fade-out, encouraging the player to try again,
   children's game style, 1.5 seconds" \
  -o assets/audio/sfx/game_over.mp3 -d 1.5

# Power-up activated
python tools/asset_generator/cli.py sfx \
  "Power-up activation sound, bright energetic burst with ascending sparkle,
   like a magical shield or speed boost activating, exciting and empowering,
   fantasy game, 0.7 seconds" \
  -o assets/audio/sfx/power_up.mp3 -d 0.7

# Hint reveal
python tools/asset_generator/cli.py sfx \
  "Gentle hint or clue reveal sound, soft magical tinkling like a fairy
   whispering a secret, warm and helpful feeling, subtle sparkle,
   0.5 seconds" \
  -o assets/audio/sfx/hint.mp3 -d 0.5

# Rune connect (Dragon Runes chain completion)
python tools/asset_generator/cli.py sfx \
  "Magical rune connection sound, a satisfying click followed by a brief
   magical resonance, like linking arcane symbols together, mystical and
   rewarding, 0.5 seconds" \
  -o assets/audio/sfx/rune_connect.mp3 -d 0.5
```

**After generating, convert to WAV for flame_audio:**

The SFX are generated as MP3 but `flame_audio` uses WAV for low-latency
pooled playback. Ask Claude to convert them:

> Convert all MP3 files in `assets/audio/sfx/` to 16-bit 44.1kHz mono WAV
> using ffmpeg, with loudness normalization.

```bash
for f in assets/audio/sfx/*.mp3; do
  ffmpeg -i "$f" -af "loudnorm=I=-14:TP=-3" -ar 44100 -ac 1 \
    -sample_fmt s16 "${f%.mp3}.wav" && rm "$f"
done
```

**Manually download the 3 UI sounds** from
[Kenney.nl UI Audio](https://kenney.nl/assets/ui-audio) (CC0):
- `button_tap.wav`
- `countdown.wav`
- `swipe.wav`

Place them in `assets/audio/sfx/`.

---

### Phase 3b: Generate Background Music

For background music, use:

```
/generate-music hub theme, cheerful fantasy, 60-90 second loop
```

See the command's built-in docs for options (ElevenLabs ambient loops,
Suno API for melodic tracks, or free library sources).

| Track | Style | Duration | Loop? |
|---|---|---|---|
| Hub theme | Cheerful fantasy, orchestral | 60-90s | Yes |
| Fire Trail | Fast-paced, exciting | 60s | Yes |
| Dragon Runes | Calm puzzle, mysterious | 60s | Yes |
| Dragon's Feast | Arcade energy, playful | 60s | Yes |
| Dragon Eggs | Gentle, nurturing | 60s | Yes |
| Victory fanfare | Triumphant, short | 5-10s | No |
| Game over | Sympathetic, encouraging | 5-10s | No |

---

### Phase 4: Verify Everything

**Ask Claude:**

```
/asset-status check all images and audio, what's missing?
```

Or directly:

```bash
python tools/asset_generator/cli.py list-assets --dir assets/images
python tools/asset_generator/cli.py list-assets --dir assets/audio/sfx
```

**Size budget checks:**
- Total image assets should be < 25 MB
- Total SFX assets should be < 1 MB (excluding music)

**Compress all images:**

```bash
python tools/asset_generator/cli.py compress assets/images -r -q 80-95
```

---

## Regenerating Individual Assets

If any asset doesn't look right, regenerate just that one:

> The dragon_fledgling.png doesn't match the style. Regenerate it with
> 3 variations so I can pick the best one.

```bash
python tools/asset_generator/cli.py image \
  "[detailed prompt from the catalog]" \
  -o assets/images/dragons/dragon_fledgling.png \
  -r assets/style_bible/approved/anchor_1.png \
     assets/style_bible/approved/anchor_2.png \
  -v 3 -q high
```

This creates `dragon_fledgling_v1.png`, `_v2.png`, `_v3.png`. Review them,
keep the best one, rename it, and run post-processing.

---

## Standalone Tool Usage

Each tool can be used independently outside the full workflow:

**Remove background from any image:**
```bash
python tools/asset_generator/cli.py remove-bg some/photo.png -o some/photo_nobg.png
```

**Resize an image with density variants for Flutter:**
```bash
python tools/asset_generator/cli.py resize raw_icon.png -s 48x48 -o assets/images/ui -d 1.0,1.5,2.0,3.0,4.0
```

**Compress a single PNG or an entire directory:**
```bash
python tools/asset_generator/cli.py compress assets/images/dragons -r -q 80-95
```

---

## Cost Estimates

| Item | Est. Cost |
|---|---|
| Style bible exploration (~30 images at medium) | ~$3 |
| 75 production images at high quality | ~$15 |
| Regeneration buffer (~30 retries) | ~$6 |
| ElevenLabs SFX (15 effects) | ~$5/month |
| Kenney.nl UI audio packs | Free (CC0) |
| Local processing (rembg, pngquant) | Free |
| **Total** | **~$29** |

## APIs Used

- **OpenAI GPT-Image-1** — Image generation (~$0.20/image at high quality)
- **ElevenLabs** — Sound effect generation (~$5/month Starter plan)
- **rembg** — Local AI background removal (free, runs locally)
- **pngquant** — PNG compression (free, runs locally)

## Legacy MCP Server

The original MCP server in `server.py` is still functional and configured
in `../../.mcp.json`. The CLI (`cli.py`) calls the same Python modules
(`image_gen.py`, `sfx_gen.py`, `post_process.py`, `manifest.py`) so both
approaches produce identical results. The slash commands are preferred for
new work since they require no server process.
