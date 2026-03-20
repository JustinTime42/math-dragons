# AI Art Generation Tools Report for Math Dragons

**Prepared:** February 2026
**Project:** Math Dragons -- Dragon-themed math game for kids ages 7-14
**Platform:** Flutter mobile (Android/iOS)
**Art Style Needed:** Fantasy/cartoon, kid-friendly, dragon-themed, consistent characters

---

## 1. AI Art Generation Tools Comparison

### 1.1 Midjourney (V7)

**Pricing (Feb 2026):**
| Plan | Monthly | Annual (per month) |
|------|---------|-------------------|
| Basic | $10 | $8 |
| Standard | $30 | $24 |
| Pro | $60 | $48 |
| Mega | $120 | $96 |

- Basic: ~200 images/month (limited GPU time)
- Standard: unlimited images (Relax mode), ~15hr Fast GPU
- Pro: unlimited images + Stealth mode (private generations)
- Mega: unlimited images + 60hr Fast GPU + Stealth mode

**Image Quality for Fantasy/Cartoon Game Art:** Excellent. Midjourney V7 is widely considered the best at stylized, fantasy, and illustration-style art. Dragon characters, magical environments, and cartoon game assets are squarely in its wheelhouse. The aesthetic quality is top-tier with rich colors, consistent lighting, and strong compositional sense.

**Style Consistency Features:**
- `--sref <URL or code>`: Style Reference -- captures the visual style (colors, medium, textures, lighting) from a reference image and applies it to new generations. Supports numeric style codes from an internal library.
- `--cref <URL>`: Character Reference -- analyzes a character's facial features, hair, clothing, and overall appearance, then replicates them in new generations. Critical for maintaining a consistent dragon companion design.
- `--cw 0-100`: Character Weight -- controls how strictly the character reference is followed. `--cw 0` focuses on face only; `--cw 100` preserves full appearance.
- `--sref random`: Style Randomization for exploring unique visual directions while keeping character intact.

**Transparent PNG Support:** V7 does NOT natively generate transparent backgrounds. However, the Midjourney web Editor allows you to erase backgrounds and export transparent PNGs after generation. This is an extra manual step per image.

**Upscaling:** Built-in upscaling options. Can upscale to 2x and 4x resolution. Third-party upscalers can go further.

**Commercial License:**
- All paid plans allow commercial use.
- Companies/individuals earning less than $1M/year gross revenue: any paid plan is fine.
- Companies earning more than $1M/year: must use Pro ($60) or Mega ($120) plan.
- Free users: CC BY-NC 4.0 (non-commercial only).
- Note: Purely AI-generated images are generally not copyrightable under current US law; significant human modification strengthens copyright claims.

**Best Use Cases for Math Dragons:** Primary character art (dragon evolution stages, companion), environment/background concepts, hero images for the hub screen, high-quality marketing materials.

---

### 1.2 OpenAI GPT Image (GPT Image 1 / 1.5 / Mini)

Note: OpenAI's latest image generation models are GPT Image 1, GPT Image 1.5, and GPT Image 1 Mini. DALL-E 3 is the previous generation. There is no "DALL-E 4" -- the GPT Image models are the successors.

**Pricing (Feb 2026, API):**
| Model | Low Quality | Medium Quality | High Quality |
|-------|------------|----------------|--------------|
| GPT Image 1 Mini | $0.005/img | ~$0.02/img | $0.052/img |
| GPT Image 1 | $0.011/img | ~$0.07/img | $0.167-0.25/img |
| GPT Image 1.5 | $0.009/img | ~$0.06/img | $0.20/img |
| DALL-E 3 | $0.04/img (std) | -- | $0.08-0.12/img (HD) |

Resolutions: 1024x1024 (square), 1024x1536 (portrait), 1536x1024 (landscape).

ChatGPT Plus/Pro subscribers can generate images directly in conversation without API costs (included in $20-200/month subscription).

**Image Quality for Fantasy/Cartoon Game Art:** Good. GPT Image models produce clean, well-composed images with strong prompt adherence. They excel at following complex, detailed prompts. However, the artistic "soul" and aesthetic consistency tends to be slightly below Midjourney for stylized fantasy art.

**Style Consistency Features:** Limited compared to Midjourney. You can provide reference images via the API for image-to-image editing, but there is no dedicated `--cref` or `--sref` equivalent. Consistency must be achieved through detailed prompt engineering and iterative editing.

**Transparent PNG Support:** YES -- native transparent background generation. Set the `background` parameter to `"transparent"` in the API call. Supported with PNG and WebP output formats. Works best at medium or high quality. This is a major advantage for game sprite production.

**Upscaling:** No built-in upscaling. Rely on third-party upscalers.

**Commercial License:** Full commercial rights. OpenAI grants you ownership of the output. No revenue thresholds. Safe for commercial game development.

**Best Use Cases for Math Dragons:** Game sprites and UI elements (thanks to native transparency), batch asset generation via API scripting, rapid iteration on specific design prompts, items/icons where prompt precision matters more than artistic style.

---

### 1.3 Stable Diffusion (SD 3.5 / SDXL -- Local or Cloud)

**Pricing:**
- **Local (free):** Download models and run on your own GPU. Completely free, unlimited generations. Requires 12-16GB+ VRAM GPU (e.g., RTX 3080/4070 or better for SD3.5 Large at 8B parameters).
- **Stability AI API:** SD3.5 Large (Stable Image Ultra): ~$0.08/image. Stable Image Core: ~$0.03/image. Credit system at $0.01/credit.
- **Third-party hosts (Replicate, fal.ai, RunComfy):** $0.02-0.06/image depending on model and resolution.

**Local Setup (recommended UI: Forge or ComfyUI):**
- Forge (optimized fork of Automatic1111 WebUI) for Windows -- familiar tabbed interface, better performance
- ComfyUI for node-based workflows (more powerful, steeper learning curve)
- Draw Things for macOS (Metal-optimized, native app)

**Image Quality for Fantasy/Cartoon Game Art:** Very good, especially with fine-tuned community models (LoRAs, checkpoints). SDXL and SD3.5 can produce high-quality fantasy/cartoon art, but quality depends heavily on model selection, LoRA usage, and prompt engineering. The ceiling is high but the floor is lower than Midjourney -- requires more expertise.

**Style Consistency Features:**
- **ControlNet:** Spatial guidance via pose maps, depth maps, edge detection, and more. Can maintain character poses and compositions across generations.
- **IP-Adapter:** Reference image-based style and content consistency. Similar concept to Midjourney's `--sref` and `--cref`.
- **LoRA Training:** Train custom models on your own character designs for maximum consistency. Can create a "Math Dragons dragon" LoRA that produces your exact dragon design every time.
- **Sprite Sheet Diffusion:** Research-grade tools for generating multi-frame sprite sheets with cross-frame consistency.

**Transparent PNG Support:** Not native in standard generation. Background removal must be done as a post-processing step. However, ControlNet and ComfyUI workflows can incorporate automatic background removal (via rembg nodes) into the pipeline.

**Upscaling:** Extensive options. Built-in Hires Fix, Real-ESRGAN, SwinIR, and other upscaling models. Can be chained into generation workflows.

**Commercial License:**
- **SDXL:** Released under open license. Free for commercial use.
- **SD3.5 Large:** Free for commercial use with the Stability AI Community License (companies under $1M revenue). Companies above $1M need an Enterprise license.
- **Community models/LoRAs:** License depends on the specific model -- always check.

**Best Use Cases for Math Dragons:** Batch production of consistent game assets (with LoRA training), sprite sheets, tile sets, highly customized asset pipelines where you need full control, and long-term cost savings (unlimited free local generations).

---

### 1.4 Leonardo.ai

**Pricing (Feb 2026):**
| Plan | Monthly | Annual (per month) | Tokens/Month |
|------|---------|-------------------|--------------|
| Free | $0 | $0 | 150/day (~4,500/mo) |
| Apprentice | $15 | $12 | 8,500 fast |
| Artisan Unlimited | ~$30 | ~$24 | 25,000 fast + unlimited relaxed |
| Maestro Unlimited | ~$60 | ~$48 | 60,000 fast + unlimited relaxed |

Token costs vary: standard image generation costs 1-4 tokens; upscaling, background removal, and other post-processing cost additional tokens.

**Image Quality for Fantasy/Cartoon Game Art:** Very good. Leonardo was built with game developers and concept artists as a primary audience. The built-in models produce clean, game-ready art with strong fantasy/cartoon capabilities. Quality is a tier below Midjourney's peak aesthetic but more practical for actual game asset production.

**Style Consistency Features:**
- **Custom Model Training:** Paid subscribers can upload images to train a private model that learns your specific aesthetic. This is extremely powerful for maintaining a consistent "Math Dragons" art style across all assets.
- **AI Canvas:** Infinite workspace with inpainting (modify parts of images) and outpainting (extend images). Great for iterative refinement.
- **Realtime Canvas:** Live preview generation for rapid concept exploration.

**Transparent PNG Support:** YES -- Leonardo has a built-in Transparent PNG Maker tool. This is a significant advantage for game sprite production. Background removal is available as a post-processing step within the platform (costs tokens).

**Upscaling:** Built-in AI upscaling (costs tokens). Supports 2x and 4x upscaling.

**Commercial License:**
- **Free plan:** Non-exclusive, royalty-free license for commercial use, BUT Leonardo retains rights to use/reproduce/modify your images, and all free-tier generations are public.
- **Paid plans:** Full ownership and IP rights. Private generations. Exclusive commercial rights.

**Best Use Cases for Math Dragons:** Primary workhorse for game asset production. Custom model training for style consistency, transparent PNG generation, iterative asset refinement via AI Canvas, character design sheets, game-specific elements (gems, tiles, rune stones, eggs).

---

### 1.5 Adobe Firefly

**Pricing (Feb 2026):**
| Plan | Price | Credits |
|------|-------|---------|
| Firefly Standard | $9.99/mo | Unlimited AI image + vector generation |
| Firefly Pro | $29.99/mo | 4,000 credits + AI video |
| Firefly Premium | TBA | 500 AI videos/month |
| Credit Add-ons | Varies | 4,000 / 7,000 / 50,000 credits |

**Current Promotion (Jan 23 - Mar 16, 2026):** Unlimited generations on all AI image models (up to 2K resolution) for Pro, Premium, and credit add-on subscribers.

Also available through Creative Cloud subscriptions (All Apps: ~$60/mo includes generative credits).

**Image Quality for Fantasy/Cartoon Game Art:** Good but conservative. Firefly tends to produce cleaner, more "stock photo" style results. It is improving rapidly but generally produces less creatively adventurous fantasy art compared to Midjourney or Leonardo. Better for clean, professional UI elements than for imaginative dragon characters.

**Style Consistency Features:**
- **Style Reference:** Can match the style of uploaded reference images.
- **Structure Reference:** Maintains spatial composition from reference images.
- **Generative Fill/Expand:** Powerful inpainting and outpainting within Photoshop.
- Limited compared to Midjourney's `--cref` for character consistency.

**Transparent PNG Support:** Supported through Photoshop integration (generative fill on transparent layers). Not as streamlined as Leonardo's native transparent generation.

**Upscaling:** Available through Photoshop's AI-powered Super Resolution. Excellent quality.

**Commercial License:** THE safest option for commercial use. Firefly is trained exclusively on Adobe Stock licensed content and public-domain works. No customer data is used. Enterprise plans include IP indemnification. Every generated asset is tagged with Content Credentials for provenance tracking. No revenue thresholds or restrictions -- all output is commercially safe.

**Best Use Cases for Math Dragons:** Commercially safest option if IP indemnification matters to you. Good for polished UI elements, backgrounds, and any assets where you want zero legal risk. Excellent post-processing via Photoshop integration.

---

### 1.6 Ideogram (3.0)

**Pricing (Feb 2026):**
| Plan | Monthly | Annual (per month) |
|------|---------|-------------------|
| Free | $0 | $0 |
| Basic | $8 | $7 |
| Plus | $20 | $16 |

- Free: 10 slow credits/week (~10 images/week)
- Basic: expanded credits
- Plus: highest priority, most credits

**Image Quality for Fantasy/Cartoon Game Art:** Good, especially for designs that incorporate text. The general image quality has improved significantly with Ideogram 3.0 but still slightly behind Midjourney for pure fantasy illustration.

**Style Consistency Features:**
- **Magic Prompt:** Auto-expands simple prompts with lighting, color tone, composition, and emotional atmosphere details.
- **Canvas:** Infinite creative board with Magic Fill (inpainting) and Extend (outpainting).
- **Describe:** Analyze existing images to generate matching prompts.
- No dedicated character reference system like Midjourney's `--cref`.

**Transparent PNG Support:** YES -- Ideogram's "Auto" model generates images directly on a transparent background with no removal step, no edge erosion, and no leftover pixel artifacts. This is "native transparency" -- the best in the industry. Simply include "transparent background" in your prompt and select the Auto model.

**Upscaling:** Basic upscaling available. Not as advanced as dedicated upscalers.

**Commercial License:** Commercial use is permitted on paid plans. Free tier has more restrictive terms.

**Text Rendering (Unique Strength):** Ideogram achieves approximately 90% accuracy in text rendering, compared to roughly 30% for most competitors. This makes it uniquely valuable for generating UI elements with embedded text (buttons, banners, title screens, achievement badges). Supports multi-language text rendering.

**Best Use Cases for Math Dragons:** UI elements with text (buttons, banners, title cards, achievement badges), transparent game sprites (native transparency is excellent), icons and badges where text accuracy matters.

---

### 1.7 Flux (by Black Forest Labs -- FLUX.2)

**Pricing (Feb 2026, API):**
| Model | Price per Image |
|-------|----------------|
| FLUX.2 [klein] 4B | From $0.014/img |
| FLUX.2 [dev] 9B | From ~$0.03/img |
| FLUX.2 [max] | From ~$0.06/img |
| FLUX 1.1 Pro | $0.04/img |

1 credit = $0.01 USD. Megapixel-based pricing (cost scales with resolution). Same price for API and Playground.

**Local hosting:** FLUX.2 [klein] 4B is Apache 2.0 and can be run locally for free. The 9B models require a commercial license for business use.

**Image Quality for Fantasy/Cartoon Game Art:** Very strong. Flux is praised for photorealistic output and excellent prompt accuracy. For cartoon/fantasy styles, it performs well but tends toward a more "realistic" aesthetic by default -- requires more prompt work for stylized cartoon output compared to Midjourney.

**Style Consistency Features:**
- **Flux Kontext:** Image-to-image editing with context awareness.
- **FLUX.2 Dev Edit:** Style-preserving image editing.
- No built-in character reference system. Consistency relies on LoRA training (when using open-source models) or careful prompt engineering.

**Transparent PNG Support:** PNG output supported, but no confirmed native transparent background generation like Ideogram. Post-processing removal needed.

**Upscaling:** No built-in upscaling. Use third-party tools.

**Commercial License:**
- **FLUX.2 [klein] 4B:** Apache 2.0 -- fully permissive, free commercial use, modification, redistribution.
- **FLUX.2 [klein] 9B and [dev]:** Non-Commercial License. Requires separate commercial agreement.
- **API usage:** Commercial use permitted through the API at listed prices.

**Best Use Cases for Math Dragons:** Cost-effective API-based batch generation, local hosting of the 4B model for unlimited free generation (if you have the hardware), photorealistic background/environment art.

---

## 2. Recommended Tool Selection

### Primary Tool for Character Art (Dragon Evolution Stages, Dragon Companion)

**Recommended: Midjourney (Standard Plan, $30/month)**

Rationale: Midjourney V7 produces the highest-quality fantasy character art. The `--cref` (Character Reference) parameter is purpose-built for maintaining character consistency across different poses, scenes, and evolution stages. The `--sref` (Style Reference) ensures all dragons share the same art style. For a kid-friendly dragon game, Midjourney's aesthetic sense is unmatched.

Workflow:
1. Generate a "hero image" of the baby dragon with detailed prompt
2. Use `--cref` with that image to generate all evolution stages
3. Use `--sref` with a style code to maintain consistent art direction
4. Export from Midjourney Editor with background removed

### Primary Tool for Environment/Background Art (Hub, Game Backgrounds)

**Recommended: Midjourney (same Standard Plan) + Leonardo.ai (Apprentice, $12/month)**

Rationale: Midjourney for hero backgrounds (hub screen, world maps, promotional art). Leonardo for the larger volume of in-game backgrounds that need to match the established style (use Leonardo's custom model training to lock in the Midjourney-established style, then generate backgrounds at volume).

### Primary Tool for UI Elements (Buttons, Frames, Icons, Badges)

**Recommended: Ideogram (Basic Plan, $8/month)**

Rationale: UI elements frequently contain text ("Play", "Settings", "Score", achievement names). Ideogram's 90% text rendering accuracy is unmatched. Its native transparent background support means buttons and icons come out game-ready without post-processing. For badges and achievement icons, the combination of accurate text + transparency is ideal.

### Primary Tool for Game-Specific Assets (Rune Stones, Eggs, Gems, Tiles)

**Recommended: Leonardo.ai (Apprentice Plan, $12/month) + OpenAI GPT Image API**

Rationale: Leonardo's built-in transparent PNG maker and game-asset-focused tooling make it ideal for producing large quantities of consistent game objects. For programmatic batch generation (e.g., generating 50 gem variants or 40 tile designs), the OpenAI GPT Image 1 Mini API ($0.005-0.02/image) with native transparency is extremely cost-effective and can be scripted.

### Background Removal Tool

**Primary: rembg (free, open-source, local)**

For any assets that do not come with native transparency (particularly Midjourney outputs):
- **rembg** (Python CLI/library): Free, no watermarks, no limits, batch processing support. Uses BiRefNet-general model for best accuracy. Install with `pip install rembg[gpu]`.
- **Backup: Photopea** (free, browser-based): For manual cleanup when rembg misses edges.
- **Backup: remove.bg** (web service): 1 free image/month at full resolution; $0.20/image for API.

---

## 3. Account Setup Checklist

### Required Accounts

| Account | Plan | Cost (Monthly) | Cost (Annual/mo) | Setup Steps |
|---------|------|----------------|-------------------|-------------|
| **Midjourney** | Standard | $30 | $24 | 1. Go to midjourney.com 2. Sign up with Google/Discord 3. Subscribe to Standard plan 4. Join Discord server for tutorials |
| **Leonardo.ai** | Apprentice | $15 | $12 | 1. Go to leonardo.ai 2. Sign up with Google/email 3. Subscribe to Apprentice plan 4. Explore Phoenix model for game art |
| **Ideogram** | Basic | $8 | $7 | 1. Go to ideogram.ai 2. Sign up with Google/email 3. Subscribe to Basic plan |
| **OpenAI** | API (pay-as-you-go) | ~$5-15 | ~$5-15 | 1. Go to platform.openai.com 2. Create account 3. Add payment method 4. Generate API key 5. Set usage limit ($20/mo recommended) |

### Optional/Free Accounts

| Account | Cost | Purpose |
|---------|------|---------|
| **Photopea** | Free | Browser-based image editing, manual cleanup |
| **rembg** (local install) | Free | Batch background removal |
| **Upscayl** (local install) | Free | Desktop app for AI upscaling |
| **Vectorizer.ai** | Free tier | PNG to SVG conversion |
| **Piskel** | Free | Sprite editing and sprite sheet creation |

### Estimated Monthly Budget

| Item | Monthly Cost |
|------|-------------|
| Midjourney Standard | $24 (annual) |
| Leonardo.ai Apprentice | $12 (annual) |
| Ideogram Basic | $7 (annual) |
| OpenAI API usage | ~$10 (estimated) |
| **Total** | **~$53/month** |

If budget is very tight, you can start with just Midjourney Standard ($24/mo annual) and the free tiers of Leonardo and Ideogram, plus the OpenAI API for transparency-critical sprites.

---

## 4. Asset Production Workflow

### Phase 1: Reference Image Gathering (Days 1-2)

1. Create a Pinterest board or local folder called `reference/` with subfolders:
   - `reference/dragons/` -- cartoon dragons, dragon evolution concepts, baby dragons
   - `reference/environments/` -- fantasy game backgrounds, magical forests, volcanic lairs
   - `reference/ui/` -- kid-friendly game UI, buttons, frames, fantasy UI kits
   - `reference/items/` -- gems, rune stones, eggs, magical objects, tiles
2. Collect 20-30 reference images per category from existing games, concept art, and style guides
3. Note which styles resonate with the "Math Dragons" vision (friendly, colorful, not scary)

### Phase 2: Style Bible Creation (Days 3-5)

1. **Generate style exploration images in Midjourney:**
   ```
   cute cartoon baby dragon, friendly expression, big eyes,
   colorful scales, fantasy game art style, children's game,
   bright colors, soft lighting --ar 1:1 --v 7
   ```
2. Pick the 3 best images that define the "Math Dragons" look
3. **Lock the style** by saving the `--sref` code from your favorite generation
4. **Create a style reference document:**
   - Color palette (extract with Photopea's eyedropper)
   - Art style keywords that consistently produce the right look
   - Character proportions guide
   - Do's and Don'ts (e.g., "DO: big friendly eyes, rounded shapes. DON'T: sharp teeth, dark colors, scary expressions")
5. Save all style reference images in `reference/style_bible/`

### Phase 3: Character Sheet Generation (Days 5-8)

1. **Generate the base dragon character in Midjourney:**
   ```
   cute baby dragon character sheet, multiple poses, front view side view back view,
   friendly cartoon style, colorful scales, big eyes, game character design,
   white background --sref <your_code> --ar 3:2 --v 7
   ```
2. **Create evolution stages using `--cref`:**
   - Stage 1 (Hatchling): small, round, simple features
   - Stage 2 (Whelp): slightly larger, small wings forming
   - Stage 3 (Drake): medium, functional wings, more defined features
   - Stage 4 (Dragon): full-sized, majestic, keeping the friendly face
   - Stage 5 (Elder Dragon): largest, glowing effects, maximum detail
3. For each stage, generate:
   - Front-facing portrait (for profile/UI display)
   - Full-body action pose (for game screens)
   - Multiple expressions (happy, thinking, celebrating, encouraging)
4. Use Midjourney Editor to remove backgrounds, export transparent PNGs
5. Touch up edges in Photopea if needed

### Phase 4: Background/Environment Generation (Days 8-12)

1. **Hub screen background** (Midjourney):
   ```
   magical dragon cave interior, treasure and gems, warm golden lighting,
   fantasy game background, colorful, kid-friendly, no characters --sref <your_code> --ar 16:9 --v 7
   ```
2. **Game-specific backgrounds** (Leonardo with trained model):
   - Train a Leonardo custom model on 10-15 Midjourney outputs to match the style
   - Generate game backgrounds at volume:
     - Fire Trail: volcanic paths, lava rivers, flame-lit corridors
     - Dragon Runes: ancient stone chambers, glowing rune circles
     - Dragon's Feast: enchanted gardens, crystal caves, cloud kingdoms
3. Generate at high resolution (at least 1536x1024) for multi-density support
4. Create parallax layers if needed (foreground, midground, background as separate images)

### Phase 5: Sprite/UI Element Generation (Days 12-18)

1. **UI Elements** (Ideogram -- native transparency):
   - Buttons: "Play", "Settings", "Back" with fantasy frame styling
   - Achievement badges with text labels
   - Score frames, health bars, combo indicators
   - Prompt: `fantasy game button with golden border, text "PLAY", transparent background, cartoon style, dragon theme`
2. **Game objects** (Leonardo + OpenAI API):
   - Gems (5 colors): use Leonardo Transparent PNG Maker
   - Rune stones (with mathematical symbols): Ideogram for text accuracy
   - Dragon eggs (multiple colors/stages): Leonardo
   - Tiles, food items, power-up icons: Leonardo batch generation
3. **Scripted batch generation** (OpenAI GPT Image 1 Mini API):
   ```python
   import openai
   client = openai.OpenAI()

   items = ["ruby gem", "emerald gem", "sapphire gem", "golden coin", "silver shield"]
   for item in items:
       response = client.images.generate(
           model="gpt-image-1-mini",
           prompt=f"cute cartoon {item}, fantasy game icon, simple clean design, "
                  f"kid-friendly, matching dragon game art style, centered on transparent background",
           size="1024x1024",
           quality="medium",
           background="transparent",
           output_format="png"
       )
       # Save the image...
   ```
   Cost: ~$0.02/image x 50 items = ~$1.00 total

### Phase 6: Post-Processing (Days 18-22)

1. **Background Removal** (for Midjourney outputs):
   ```bash
   pip install rembg[gpu]
   rembg p input_folder/ output_folder/
   ```
   This batch-processes all images in the folder with transparent backgrounds.

2. **Edge Cleanup** (Photopea):
   - Open transparent PNGs that have rough edges
   - Use eraser tool at low hardness to smooth edges
   - Use "Select by Color" to remove any remaining background artifacts
   - Save as PNG-24 with transparency

3. **Consistency Editing** (Photopea or Leonardo AI Canvas):
   - Color-correct assets to match the style bible's palette
   - Ensure similar lighting direction across all assets
   - Resize characters to maintain consistent proportions

4. **Upscaling** (Upscayl -- free, local):
   - Upscale any assets that are too small for xxxhdpi (4x) density
   - Use Real-ESRGAN model for general art
   - Target: largest needed size should be the 4.0x variant

### Phase 7: Flutter Asset Preparation (Days 22-25)

1. **Directory Structure:**
   ```
   assets/
     images/
       dragons/
         hatchling.png          (baseline, e.g., 96x96)
         1.5x/hatchling.png     (144x144)
         2.0x/hatchling.png     (192x192)
         3.0x/hatchling.png     (288x288)
         4.0x/hatchling.png     (384x384)
       backgrounds/
         hub_bg.png
         2.0x/hub_bg.png
         3.0x/hub_bg.png
       ui/
         btn_play.png
         1.5x/btn_play.png
         2.0x/btn_play.png
         3.0x/btn_play.png
         4.0x/btn_play.png
       items/
         gem_ruby.png
         ...
   ```

2. **Naming Convention:**
   - Use lowercase_snake_case: `dragon_hatchling.png`, `btn_play.png`, `gem_ruby.png`
   - Prefix by category: `dragon_`, `bg_`, `btn_`, `icon_`, `gem_`, `tile_`, `badge_`
   - Base image (1x) goes in the root folder; scaled variants in `1.5x/`, `2.0x/`, `3.0x/`, `4.0x/` subfolders

3. **Density Scaling:**
   | Density | Multiplier | Example (48dp icon) |
   |---------|-----------|-------------------|
   | mdpi (1x) | 1.0 | 48x48 px |
   | hdpi (1.5x) | 1.5 | 72x72 px |
   | xhdpi (2.0x) | 2.0 | 96x96 px |
   | xxhdpi (3.0x) | 3.0 | 144x144 px |
   | xxxhdpi (4.0x) | 4.0 | 192x192 px |

4. **Batch Resize Script (Python with Pillow):**
   ```python
   from PIL import Image
   import os

   def create_flutter_variants(input_path, base_size, output_dir):
       """Generate all density variants from a high-res source image."""
       img = Image.open(input_path)
       name = os.path.basename(input_path)

       scales = {
           '.': base_size,                          # 1x (mdpi)
           '1.5x': int(base_size * 1.5),            # hdpi
           '2.0x': base_size * 2,                    # xhdpi
           '3.0x': base_size * 3,                    # xxhdpi
           '4.0x': base_size * 4,                    # xxxhdpi
       }

       for folder, size in scales.items():
           dest = os.path.join(output_dir, folder)
           os.makedirs(dest, exist_ok=True)
           resized = img.resize((size, size), Image.LANCZOS)
           resized.save(os.path.join(dest, name), 'PNG')
   ```

5. **Register in pubspec.yaml:**
   ```yaml
   flutter:
     assets:
       - assets/images/dragons/
       - assets/images/backgrounds/
       - assets/images/ui/
       - assets/images/items/
   ```
   Flutter automatically resolves density variants from subdirectories.

---

## 5. Post-Processing Tools

### Background Removal

| Tool | Cost | Type | Best For |
|------|------|------|----------|
| **rembg** | Free | Python CLI/library, local | Batch processing, automation. BiRefNet-general model recommended. Install: `pip install rembg[gpu]`. Batch: `rembg p input/ output/` |
| **remove.bg** | Free (1/mo at full res), $0.20/img API | Web service | Quick one-off removals, excellent edge quality |
| **Photopea** | Free | Browser-based | Manual cleanup, fine edge work, complex compositions |
| **SpriteBuff** | Free | Web, game-focused | Sprite-specific removal with magic wand and color range tools |

### Image Editing / Compositing

| Tool | Cost | Type | Best For |
|------|------|------|----------|
| **Photopea** | Free (ad-supported) | Browser-based | Full Photoshop-like editing in browser. PSD/AI/Sketch support. Layers, masks, adjustments. Best free option. |
| **GIMP** | Free | Desktop (Win/Mac/Linux) | Heavyweight free editing. More features than Photopea but less intuitive. Good for scripted batch operations (Script-Fu). |
| **Adobe Photoshop** | $22.99/mo (Photography plan) | Desktop | Gold standard. Best generative fill via Firefly integration. Only if budget allows. |
| **Leonardo AI Canvas** | Included in plan | Web-based | AI-powered inpainting/outpainting for quick fixes |

### Batch Resizing

| Tool | Cost | Type | Best For |
|------|------|------|----------|
| **Python + Pillow** | Free | Script | Custom batch resize script (see Phase 7 above). Full control over sizes, naming, and output. |
| **ImageMagick** | Free | CLI | One-liner batch resize: `magick mogrify -resize 50% -path output/ *.png` |
| **Photopea** | Free | Browser | One-at-a-time resizing with preview |

### SVG Conversion (for Vector Assets)

| Tool | Cost | Type | Best For |
|------|------|------|----------|
| **Vectorizer.ai** | Free tier available | Web | High-quality automatic PNG-to-SVG conversion. Clean paths, well-defined edges. |
| **Recraft AI Vectorizer** | Free | Web | AI-powered raster-to-vector conversion with style preservation |
| **Vector Magic** | $9.99/mo | Web/Desktop | Professional-grade vectorization. Best quality but paid. |
| **Inkscape** | Free | Desktop | Manual tracing and vector editing. "Trace Bitmap" feature for conversion. |
| **VectorWitch** | Free tier | Web | Text-to-SVG generation for simple icons and shapes |

### Sprite Sheet Creation

| Tool | Cost | Type | Best For |
|------|------|------|----------|
| **TexturePacker** | $40 one-time (Essential) | Desktop | Industry standard. Automatic packing, trim, pivot points. Exports for all engines. |
| **Free Sprite Sheet Packer** | Free | Web | Drag-and-drop sprite packing. Quick and simple. |
| **Piskel** | Free | Web/Desktop | Sprite editing + animation preview + export as spritesheet PNG |
| **Sprite Sheet Maker** (Final Parsec) | Free | Web | Browser-based, simple file selection and packing |
| **Shoebox** | Free | Desktop | Bitmap font creation, sprite sheet packing, texture atlas generation |

---

## Summary: Recommended Stack at a Glance

| Need | Tool | Monthly Cost |
|------|------|-------------|
| Dragon characters & hero art | Midjourney Standard | $24/mo (annual) |
| Game assets, objects, sprites | Leonardo.ai Apprentice | $12/mo (annual) |
| UI elements with text, icons | Ideogram Basic | $7/mo (annual) |
| Batch transparent sprites | OpenAI GPT Image API | ~$10/mo (pay-per-use) |
| Background removal | rembg (local) | Free |
| Image editing | Photopea (browser) | Free |
| Upscaling | Upscayl (local) | Free |
| Batch resizing | Python + Pillow | Free |
| SVG conversion | Vectorizer.ai | Free |
| Sprite sheet packing | Free Sprite Sheet Packer | Free |
| **Total estimated** | | **~$53/month** |

This stack covers all asset production needs for Math Dragons while keeping costs under control. The paid tools (Midjourney, Leonardo, Ideogram) handle generation quality and consistency, while free tools (rembg, Photopea, Upscayl, Pillow) handle all post-processing.

---

## Sources

- [Midjourney Plans Comparison](https://docs.midjourney.com/hc/en-us/articles/27870484040333-Comparing-Midjourney-Plans)
- [Midjourney Style Reference Documentation](https://docs.midjourney.com/hc/en-us/articles/32180011136653-Style-Reference)
- [Midjourney Character Reference Documentation](https://docs.midjourney.com/hc/en-us/articles/32162917505293-Character-Reference)
- [Midjourney Review 2026 (Cybernews)](https://cybernews.com/ai-tools/midjourney-review/)
- [Midjourney Commercial Use Rights 2026 Guide](https://terms.law/2026/01/15/midjourney-commercial-use-rights-complete-2026-guide/)
- [OpenAI API Pricing](https://platform.openai.com/docs/pricing)
- [OpenAI Image Generation Guide](https://platform.openai.com/docs/guides/image-generation)
- [OpenAI Image Pricing Calculator 2026](https://invertedstone.com/calculators/dall-e-pricing)
- [Stability AI Platform Pricing](https://platform.stability.ai/pricing)
- [Stable Diffusion 3.5 Introduction](https://stability.ai/news/introducing-stable-diffusion-3-5)
- [Stable Diffusion Hardware Guide 2026](https://aitoolsdevpro.com/ai-tools/stable-diffusion-guide/)
- [Leonardo.ai Pricing](https://leonardo.ai/pricing/)
- [Leonardo AI Pricing 2026 Complete Guide](https://therightgpt.com/leonardo-ai-guide/pricing/)
- [Leonardo AI Review 2026 (Cybernews)](https://cybernews.com/ai-tools/leonardo-ai-review/)
- [Leonardo.ai Commercial Usage](https://intercom.help/leonardo-ai/en/articles/8044018-commercial-usage)
- [Adobe Firefly Plans Comparison](https://www.adobe.com/products/firefly/plans.html)
- [Adobe Firefly Review 2026](https://aitoolanalysis.com/adobe-firefly-review/)
- [Adobe Generative Credits Overview](https://helpx.adobe.com/firefly/web/get-started/learn-the-basics/generative-credits-overview.html)
- [Ideogram Available Plans](https://docs.ideogram.ai/plans-and-pricing/available-plans)
- [Ideogram AI Review 2026](https://pxz.ai/blog/ideogram-ai-review-2026)
- [Ideogram 3.0 Features](https://ideogram.ai/features/3.0)
- [Ideogram Native Transparency](https://geekycuriosity.substack.com/p/skip-the-background-remover-ideogram)
- [Black Forest Labs Flux Pricing](https://bfl.ai/pricing)
- [Flux 2 Klein Apache 2.0 License Guide](https://apatero.com/blog/flux-2-klein-apache-license-commercial-use)
- [Black Forest Labs Licensing](https://bfl.ai/licensing)
- [rembg on GitHub](https://github.com/danielgatis/rembg)
- [Photopea Online Editor](https://www.photopea.com/)
- [Flutter Assets and Images Documentation](https://docs.flutter.dev/ui/assets/assets-and-images)
- [Vectorizer.ai](https://vectorizer.ai/)
- [TexturePacker](https://www.codeandweb.com/texturepacker)
- [Upscayl (Free AI Upscaler)](https://deepdreamgenerator.com/blog/best-free-ai-image-upscaler-2026)
- [AI Sprite Generator PNG Guide](https://www.seeles.ai/resources/blogs/ai-sprite-generator-png-import-guide-2026)
- [Complete Guide to AI Image Generation APIs 2026](https://wavespeed.ai/blog/posts/complete-guide-ai-image-apis-2026/)
