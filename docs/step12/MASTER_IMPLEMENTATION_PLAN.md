# Math Dragons Step 12: Art, Sound & Polish -- Master Implementation Plan

> Single source of truth for executing Step 12. This plan synthesizes all seven
> research documents into a sequenced, actionable execution plan with clear
> dependencies, timelines, costs, and acceptance criteria.
>
> **Last updated:** 2026-02-16

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Pre-Implementation Phase (Setup)](#2-pre-implementation-phase-setup)
3. [Art Asset Production Phase](#3-art-asset-production-phase)
4. [Audio Production Phase](#4-audio-production-phase)
5. [Code Implementation Phases](#5-code-implementation-phases)
6. [Critical Path & Parallelism](#6-critical-path--parallelism)
7. [Risk Register](#7-risk-register)
8. [Definition of Done](#8-definition-of-done)
9. [Cost Summary](#9-cost-summary)

---

## 1. Executive Summary

### What Step 12 Covers

Step 12 transforms Math Dragons from a functionally complete but visually placeholder
game into a polished, themed product. It covers six major areas:

1. **Art Assets** -- Replace all emoji placeholders and procedural Canvas drawings with
   AI-generated fantasy dragon art (75 images across hub, 4 games, UI, and store).

2. **Sound & Music** -- Add 6 background music tracks and 18 sound effects, integrated
   with the existing EventBus and settings toggles.

3. **Haptic Feedback** -- Wire the 51 missing haptic calls identified in the audit
   (only 1 of ~52 needed calls is currently implemented).

4. **Animations & Visual Polish** -- Screen transitions, micro-interactions (score
   float, streak pulse, star fill, currency shimmer), ambient hub effects (floating
   embers, background glow), and optional Rive dragon companion.

5. **Tutorials** -- First-play tutorial overlays for the hub and each of the 4 games,
   contextual tooltips, and a help button in the pause menu.

6. **Loading States & Empty States** -- Splash screen animation, game loading
   indicators, and empty-state widgets for screens with no data.

### Total Estimated Timeline

| Track | Duration | Can Parallelize? |
|-------|----------|-----------------|
| Pre-implementation setup | 1 day | Must complete first |
| Art asset production | ~20 days | Yes -- independent of code work |
| Audio production | ~4 days | Yes -- independent of code and art |
| Code Phase A: Foundation | 2-3 days | After setup |
| Code Phase B: Haptics | 1 day | After Phase A |
| Code Phase C: Audio integration | 1-2 days | After audio production + Phase A |
| Code Phase D: Tutorials | 2-3 days | After Phase A |
| Code Phase E: Art integration | 3-4 days | After art production + Phase A |
| Code Phase F: Animations & polish | 3-5 days | After Phase A |
| Code Phase G: Testing & optimization | 2-3 days | After all other phases |

**Minimum calendar time (with parallelism):** ~20-25 days total. Art production is the
longest-pole item. Code phases B through F can proceed in parallel with art/audio
production and with each other (to a degree), but Phase G must wait for everything else.

**Minimum code-only time (sequential):** ~15-21 days of active development.

### Total Estimated Cost

| Category | Low Estimate | High Estimate |
|----------|-------------|---------------|
| AI art tool subscriptions (1-2 months) | $53 | $106 |
| Music generation (Suno Pro, 1 month) | $10 | $10 |
| Backup music (Soundraw, 1 month) | $0 | $11 |
| Custom SFX (ElevenLabs Starter) | $0 | $50 |
| Rive (free tier or Cadet plan) | $0 | $9 |
| Software tools | $0 | $0 |
| **Total** | **$63** | **$186** |

All software tools (rembg, Upscayl, Audacity, Photopea, JSFXR) are free.

### Dependencies and Prerequisites

- **Steps 1-10 complete** (confirmed -- all core functionality, games, progression,
  rewards, achievements, daily challenges, and Firebase are implemented).
- **Step 11 skipped** -- Monetization/compliance deferred. Art integration proceeds
  without IAP gating logic.
- **535 tests passing**, `flutter analyze` clean, debug APK builds successfully.
- **Flutter 3.41.1 / Dart 3.11.0 / Flame 1.14** -- current project versions.

### Reference Documents

| Document | Location | Contents |
|----------|----------|----------|
| AI Art Tools Report | `docs/step12/AI_ART_TOOLS_REPORT.md` | Tool comparison, recommended stack, account setup |
| Art Generation Prompts | `docs/step12/ART_GENERATION_PROMPTS.md` | 75 ready-to-use prompts for Midjourney V7 / GPT Image / Leonardo |
| Audio Research Report | `docs/step12/AUDIO_RESEARCH_REPORT.md` | Music & SFX source comparison, 6 track specs, 18 SFX specs |
| Animation Research | `docs/step12/ANIMATION_RESEARCH.md` | Framework comparison, per-animation specs, particle system design, performance budgets |
| Audio Integration Plan | `docs/step12/AUDIO_INTEGRATION_PLAN.md` | AudioService class design, EventBus wiring, Provider setup, file organization |
| Art Integration Plan | `docs/step12/ART_INTEGRATION_PLAN.md` | Asset-to-code mapping for all 75 assets, Flame/Flutter patterns, migration phases |
| Haptics Integration Audit | `docs/step12/HAPTICS_INTEGRATION_AUDIT.md` | Audit of 51 missing haptic calls with code snippets |
| Visual Design Guide | `docs/VISUAL_DESIGN_GUIDE.md` | Sections 10-11: Motion/animation specs and haptic feedback map |

---

## 2. Pre-Implementation Phase (Setup)

**Duration:** 1 day
**Must complete before:** All other phases

### 2.1 Account Setup

Create accounts and subscriptions for AI art generation and music production.
Subscribe when ready to start active production; do not subscribe weeks in advance.

| Account | Plan | Monthly Cost | Action |
|---------|------|-------------|--------|
| Midjourney | Standard (annual billing) | $24/mo | Sign up at midjourney.com, subscribe, join Discord |
| Leonardo.ai | Apprentice (annual billing) | $12/mo | Sign up at leonardo.ai, subscribe |
| Ideogram | Basic (annual billing) | $7/mo | Sign up at ideogram.ai, subscribe |
| OpenAI API | Pay-as-you-go | ~$10/mo | Sign up at platform.openai.com, add payment, set $20/mo limit |
| Suno AI | Pro (monthly) | $10/mo | Sign up at suno.com, subscribe when ready for music |
| Rive | Free | $0 | Sign up at rive.app (free tier sufficient for development) |

### 2.2 Software Installation

Install free tools on the development machine:

| Tool | Purpose | Install Command / URL |
|------|---------|----------------------|
| rembg | Batch background removal from AI-generated images | `pip install rembg[gpu]` |
| Upscayl | AI image upscaling (desktop app) | Download from upscayl.org |
| Audacity | Audio loop trimming and normalization | Download from audacityteam.org |
| FFmpeg | Audio format conversion (WAV to OGG) | `scoop install ffmpeg` |
| Python Pillow | Batch image resizing for Flutter density variants | `pip install Pillow` |
| Photopea | Browser-based image editing (no install) | photopea.com |
| JSFXR | Browser-based retro SFX generator (no install) | sfxr.me |

### 2.3 Flutter Dependency Additions

Update `math_dragons/pubspec.yaml`:

```yaml
dependencies:
  # Uncomment (already present, commented out):
  flame_audio: ^2.1.6
  rive: ^0.12.4

  # Add new:
  flutter_native_splash: ^2.4.0    # Native splash screen
```

Run `flutter pub get` after changes.

### 2.4 Directory Structure Creation

Create all asset directories before placing files:

```
math_dragons/assets/
  audio/
    music/          # 6 OGG music tracks
    sfx/            # 18 WAV sound effects
  images/
    dragons/        # Evolution portraits, hub companions, color variants, accessories
    hub/            # Hub background, 4 game portal images
    games/
      runes/        # Rune node sprites, runes background
      fire_trail/   # Dragon head, gems, fire trail background
      dragon_eggs/  # Egg sprites, eggs background
      dragons_feast/# Feast sprites, feast background
    ui/             # App icon, stars, scale, streak, badge, feature graphic
      1.5x/         # Density variants
      2.0x/
      3.0x/
      4.0x/
  animations/       # Rive .riv files (if/when created)
```

### 2.5 pubspec.yaml Asset Registration

Ensure all directories are registered (Flutter does not auto-discover subdirectories):

```yaml
flutter:
  assets:
    - assets/images/dragons/
    - assets/images/hub/
    - assets/images/games/runes/
    - assets/images/games/fire_trail/
    - assets/images/games/dragon_eggs/
    - assets/images/games/dragons_feast/
    - assets/images/ui/
    - assets/images/ui/1.5x/
    - assets/images/ui/2.0x/
    - assets/images/ui/3.0x/
    - assets/images/ui/4.0x/
    - assets/animations/
    - assets/audio/music/
    - assets/audio/sfx/
```

---

## 3. Art Asset Production Phase

**Duration:** ~20 days (runs in parallel with code phases after setup)
**Cost:** ~$53/month for AI tool subscriptions + ~$10 OpenAI API
**Reference docs:** `AI_ART_TOOLS_REPORT.md`, `ART_GENERATION_PROMPTS.md`

This phase produces all 75 image assets. It is the longest-pole item in the project
and should start as early as possible. It requires no code changes until Phase E
(Art Integration).

### 3.1 Reference Gathering (Days 1-2)

**Goal:** Collect 80-120 reference images that define the visual target.

- Create a local folder structure: `reference/dragons/`, `reference/environments/`,
  `reference/ui/`, `reference/items/`
- Collect 20-30 images per category from existing games, concept art, Pinterest
- Note styles that match "Math Dragons" vision: friendly, colorful, not scary,
  Wings of Fire meets Clash Royale
- Focus on: cartoon dragons (not chibi), fantasy game UI, glowing crystals, warm caves

### 3.2 Style Bible Creation (Days 3-5)

**Goal:** Lock the art style before generating any production assets.

1. Generate 20-30 style exploration images in Midjourney using the Style Anchor prompt
   from `ART_GENERATION_PROMPTS.md` Section 0.1
2. Select the 3-4 best images that define the "Math Dragons" look
3. Save the `--sref` code from the winning generation
4. Create a style reference document with:
   - Extracted color palette (verify against design guide hex values)
   - Keywords that consistently produce the right look
   - Character proportion guide
   - Do's and Don'ts list
5. Save all references in `reference/style_bible/`

**Deliverable:** Locked style reference code and document. All subsequent prompts
use this `--sref` value.

### 3.3 Character Generation (Days 5-8)

**Goal:** Generate all 26 dragon images (12 evolution + 8 color variants + 6 accessories).

**Order of operations (critical for consistency):**
1. Generate Stage 3 (Young Dragon) portrait first -- this is the anchor character
2. Iterate until horn shape, eye color, face structure, body proportions are perfect
3. Use the Young Dragon as `--oref` reference for all other stages
4. Generate Stages 0-2 (Egg, Hatchling, Fledgling) -- working backward
5. Generate Stages 4-5 (Adult, Elder) -- working forward
6. Generate all 6 hub companion versions (smaller, idle pose)
7. Generate 8 color variants using the Young Dragon as `--oref`
8. Generate 6 accessories on green chroma key backgrounds

**Tools:** Midjourney V7 (primary), with `--oref` and `--sref` on every prompt.

**Post-processing per image:**
- Background removal with rembg: `rembg p input/ output/`
- Edge cleanup in Photopea if needed
- Color correction toward palette hex values
- Downscale to target size (Pillow script from `AI_ART_TOOLS_REPORT.md` Phase 7)

### 3.4 Environment Generation (Days 8-10)

**Goal:** Generate 5 backgrounds (1 hub + 4 game backgrounds) and 4 portal images.

1. Generate hub background (1920x1080) in Midjourney with `--sref`
2. Train a Leonardo.ai custom model on 10-15 Midjourney outputs to match the style
3. Generate 4 game backgrounds (1920x1080 each) in Leonardo with the trained model
4. Generate 4 hub portal images (256x256) in Midjourney

**Post-processing:**
- Apply 15-20% dark overlay to game backgrounds (readability over game elements)
- Hub background: ensure center is clear for dragon companion, top 56dp is darker
- Portal images: extract on transparent backgrounds

### 3.5 Game Asset Generation (Days 10-13)

**Goal:** Generate 27 game-specific assets across all 4 games.

| Game | Assets | Count | Primary Tool |
|------|--------|-------|-------------|
| Dragon Runes | Rune node inactive, active, spell particle | 3 | Midjourney |
| Fire Trail | Dragon head, correct gem, wrong gem | 3 | Midjourney |
| Dragon Eggs | 4 color eggs, operator, division, 2 crack stages, baby dragon | 9 | Leonardo + Midjourney |
| Dragon's Feast | Player dragon, enemy guardian, 6 gems, 3 power-ups | 12 | Leonardo + OpenAI API |

**Notes:**
- Generate all 4 egg colors in the same session for consistency
- Generate all 6 feast gems in the same session for consistency
- Use OpenAI GPT Image 1 Mini API for batch gem generation ($0.02/image)
- All game sprites need transparent backgrounds
- Must be readable at final display sizes (48-64px)

### 3.6 UI & Store Asset Generation (Days 13-15)

**Goal:** Generate 7 UI elements and verify store cosmetic art from earlier phases.

| Asset | Size | Tool |
|-------|------|------|
| App icon (dragon face) | 1024x1024 | Midjourney |
| Achievement badge frame | 64x64 | Ideogram (text accuracy for badges) |
| Star filled | 32x32 | Midjourney |
| Star empty | 32x32 | Midjourney (match filled star silhouette) |
| Dragon scale (currency) | 32x32 | Midjourney |
| Streak flame | 24x24 | Midjourney |
| Feature graphic (Play Store) | 1024x500 | Midjourney |

**Notes:**
- Stars must have identical silhouettes (filled vs empty)
- Scale icon must read at 16x16 -- may need hand-polishing
- Feature graphic: do NOT include text in AI generation; add "MATH DRAGONS" title
  in Photopea using Cinzel Bold font after generation

### 3.7 Post-Processing Pass (Days 15-18)

**Goal:** Bring all 75 assets to production quality.

1. **Background removal** for all assets needing transparency:
   ```
   rembg p raw_assets/ processed_assets/
   ```

2. **Edge cleanup** in Photopea: smooth rough edges with low-hardness eraser

3. **Color correction** pass: verify all purples are near #2D1B69, golds near #F4A261,
   emeralds near #2A9D8F using Hue/Saturation adjustment layers

4. **Upscaling** with Upscayl for any assets that are too small for 4x density

5. **Consistency check**: line up all dragon stages side-by-side to verify horn shape,
   eye color, and body plan consistency; correct outliers

### 3.8 Flutter Asset Preparation (Days 18-20)

**Goal:** Prepare all assets in the correct sizes and directory structure.

1. **Batch resize** all assets to target display sizes using the Pillow script from
   `AI_ART_TOOLS_REPORT.md` Section 4 Phase 7

2. **Generate density variants** for UI icons (1x, 1.5x, 2.0x, 3.0x, 4.0x)

3. **Compress PNGs** with pngquant:
   - Backgrounds: quality 65-80 (target < 2 MB each)
   - Sprites: quality 80-95 (target < 50 KB each)
   - Icons: quality 90-100 (target < 10 KB each)

4. **Place files** in the directory structure from Section 2.4

5. **Export app icon** to all Android mipmap sizes (48-512px) and iOS icon sizes

6. **Quality checklist** from `ART_GENERATION_PROMPTS.md` Appendix C:
   - Color palette matches design guide
   - Readable at final display size
   - Clean alpha channel (no halos)
   - Correct file naming
   - No AI-generated text in any asset
   - Age-appropriate (suitable for ages 7+)
   - File sizes within budget (< 500KB per asset, < 2MB for backgrounds)

---

## 4. Audio Production Phase

**Duration:** ~4 days (runs in parallel with code phases and art production)
**Cost:** $10-$71
**Reference docs:** `AUDIO_RESEARCH_REPORT.md`, `AUDIO_INTEGRATION_PLAN.md`

### 4.1 Account Setup (Day 1, 30 minutes)

- Subscribe to Suno AI Pro ($10/month)
- Optionally create ElevenLabs account (free tier gives ~50 SFX generations)
- Download Kenney.nl UI Audio and RPG Audio packs (free, CC0)
- Download Sonniss GameAudioGDC bundles (free, large ZIP files)

### 4.2 Music Generation (Day 1-2)

**Goal:** Generate 6 music tracks using Suno AI Pro.

| Track | File Name | BPM | Key | Duration | Loop? |
|-------|-----------|-----|-----|----------|-------|
| Hub Theme | `hub_theme.ogg` | 80-100 | D major | 60-90s | Yes |
| Dragon Runes | `dragon_runes.ogg` | 90-110 | A minor | 60-90s | Yes |
| Fire Trail | `fire_trail.ogg` | 130-150 | E minor | 60-90s | Yes |
| Dragon Eggs | `dragon_eggs.ogg` | 110-125 | C major | 60-90s | Yes |
| Dragon's Feast | `dragons_feast.ogg` | 120-135 | G major | 60-90s | Yes |
| Victory/Result | `victory.ogg` | 110-120 | D major | 15-20s | No |

**Process per track:**
1. Use the Suno prompt from `AUDIO_RESEARCH_REPORT.md` Section 5
2. Enable Loop Mode for the 5 looping tracks
3. Generate 3-5 variations, select the best
4. Download as WAV

**Backup:** If any track is unsatisfactory, try Pixabay Music (free) or Soundraw ($11
for one month).

### 4.3 SFX Sourcing and Generation (Days 2-3)

**Goal:** Acquire all 18 sound effects.

**Multi-source strategy:**

| Source | SFX to Acquire | License |
|--------|---------------|---------|
| **Kenney.nl** (CC0, free) | `button_tap.wav`, `countdown.wav`, `scales_earn.wav` | CC0 -- no attribution |
| **Sonniss GDC** (free) | `dragon_roar.wav`, `level_complete.wav`, `game_over.wav`, `power_up.wav`, `swipe.wav`, `munch.wav` | Royalty-free -- no attribution |
| **Freesound.org** (CC0 filter) | `egg_crack.wav`, `streak.wav`, `correct.wav`, `wrong.wav` | CC0 -- no attribution |
| **ElevenLabs** (free tier or $50/yr) | `egg_hatch.wav`, `evolution.wav`, `achievement.wav`, `rune_connect.wav`, `hint.wav` | Paid plan for commercial use |

**For each SFX:**
1. Search/generate using the spec from `AUDIO_RESEARCH_REPORT.md` Section 6
2. Audition multiple candidates
3. Select the best match for tone, duration, and kid-friendliness

### 4.4 Audio Processing (Day 3-4)

**Goal:** Bring all audio to production format.

**Music tracks:**
```bash
# Convert WAV to OGG Vorbis at 128kbps
ffmpeg -i hub_theme.wav -c:a libvorbis -b:a 128k hub_theme.ogg
```

- Verify seamless looping in Audacity (trim loop points if needed)
- Normalize to -3 dB peak

**Sound effects:**
```bash
# Normalize, convert to mono 16-bit 44.1kHz WAV
ffmpeg -i correct_raw.wav -af "loudnorm=I=-14:TP=-3" -ar 44100 -ac 1 -sample_fmt s16 correct.wav
```

- Trim silence from start/end
- Normalize all SFX to -3 dB for consistent volume

### 4.5 Asset Placement

Place processed files into the directory structure:

```
assets/audio/
  music/
    hub_theme.ogg         (~1 MB)
    dragon_eggs.ogg       (~1 MB)
    fire_trail.ogg        (~1 MB)
    dragon_runes.ogg      (~1 MB)
    dragons_feast.ogg     (~1 MB)
    victory.ogg           (~0.3 MB)
  sfx/
    correct.wav           (~15 KB)
    wrong.wav             (~15 KB)
    streak.wav            (~25 KB)
    level_complete.wav    (~70 KB)
    achievement.wav       (~70 KB)
    scales_earn.wav       (~15 KB)
    egg_crack.wav         (~25 KB)
    egg_hatch.wav         (~45 KB)
    dragon_roar.wav       (~45 KB)
    munch.wav             (~10 KB)
    button_tap.wav        (~5 KB)
    evolution.wav         (~90 KB)
    countdown.wav         (~15 KB)
    game_over.wav         (~45 KB)
    power_up.wav          (~25 KB)
    hint.wav              (~25 KB)
    rune_connect.wav      (~15 KB)
    swipe.wav             (~10 KB)
```

**Total audio bundle: ~6.5 MB** (5.5 MB music + 1 MB SFX)

### 4.6 Licensing Documentation

Maintain a spreadsheet tracking every audio asset:

| File | Source | License | Date Acquired | Cost | Attribution Required? |
|------|--------|---------|---------------|------|-----------------------|
| hub_theme.ogg | Suno Pro | Perpetual commercial | YYYY-MM-DD | $0 (included in sub) | No |
| button_tap.wav | Kenney.nl | CC0 | YYYY-MM-DD | Free | No |
| ... | ... | ... | ... | ... | ... |

Save screenshots/PDFs of license terms at time of acquisition.

---

## 5. Code Implementation Phases

All code phases are sequential unless otherwise noted. Each phase ends with
`flutter analyze` clean + `flutter test` passing + `flutter build apk --debug` succeeding.

### Phase A: Foundation (2-3 days)

**Prerequisites:** Pre-implementation setup complete.
**Blocks:** All subsequent code phases.

#### A.1 AudioService + AudioEventListener

**New file:** `lib/core/audio_service.dart`
**Reference:** `AUDIO_INTEGRATION_PLAN.md` Section 2

- Create `AudioService` class following the exact interface from the integration plan
- Create `AudioEventListener` class that subscribes to EventBus events for cross-cutting
  SFX (AnswerGiven, StreakAchieved, LevelCompleted, GameEnded, AchievementUnlocked)
- Named methods for every SFX and music track
- Settings checks per-call (`_soundEnabled`, `_musicEnabled`)
- All methods wrapped in try/catch (audio must never crash the app)
- AudioPool for 4 high-frequency SFX (correct, wrong, button_tap, munch)
- Music volume at 40%, SFX at 80%, UI SFX at 50%

#### A.2 TapScaleWrapper Widget

**New file:** `lib/widgets/tap_scale_wrapper.dart`

- Wraps any child widget with a press-and-release scale animation
- On press: scale to 0.95 with `Curves.easeOut` over 100ms
- On release: scale back to 1.0 with `Curves.easeOutBack` over 150ms
- Triggers `HapticsService.onButtonPress()` on tap
- Triggers `AudioService.playButtonTap()` on tap
- Used throughout the app for all interactive buttons

#### A.3 Animated Score/Star/Progress Widgets

**New files or additions:**
- `lib/widgets/animated_score_counter.dart` -- Score number counts up from 0 to final value
  with `Tween<int>` over 600ms
- `lib/widgets/animated_star_rating.dart` -- Stars fill in sequence with staggered
  `Curves.elasticOut` animations (200ms apart)
- `lib/widgets/animated_progress_bar.dart` -- Fill animates from 0% to target over 1 second

#### A.4 Empty State Widgets

**New file:** `lib/widgets/empty_state.dart`

- Generic empty state widget: centered icon + title + optional subtitle
- Used for: no achievements yet, no daily challenges completed, store loading
- Matches design guide typography and colors

#### A.5 SplashGate + flutter_native_splash

**New file:** `lib/widgets/splash_gate.dart`

- Shows an animated splash while services initialize
- Option A (simple): "Math Dragons" text fades in with gold underline drawing L-to-R
- Option B (enhanced): Rive animation with dragon silhouette (if Rive asset created)
- Transitions to hub screen when initialization completes

**flutter_native_splash setup:**
- Configure `flutter_native_splash.yaml` with midnight blue (#1A1A2E) background
  and centered app icon
- Run `flutter pub run flutter_native_splash:create`

#### A.6 Provider Wiring

**Modified files:** `lib/main.dart`, `lib/app.dart`
**Reference:** `AUDIO_INTEGRATION_PLAN.md` Section 8

- Create AudioService in `main.dart`, preload SFX with `unawaited()`
- Pass AudioService into MathDragonsApp constructor
- Create AudioEventListener in `_MathDragonsAppState.initState()`
- Add `Provider<AudioService>` to MultiProvider
- Add audio lifecycle calls to `didChangeAppLifecycleState` (pauseMusic/resumeMusic)
- Add AudioEventListener + AudioService to dispose chain

**Estimated effort for Phase A: 16-24 hours**

---

### Phase B: Haptics Integration (1 day)

**Prerequisites:** Phase A complete (for TapScaleWrapper).
**Reference:** `HAPTICS_INTEGRATION_AUDIT.md`

#### B.1 Game Event Haptics (Priority 1 from audit)

Wire haptic calls into the Flutter wrapper `State` classes for all 4 games, using the
callback pattern (Flame games fire callbacks, Flutter side calls haptics):

**Fire Trail** (`lib/games/fire_trail/fire_trail_game.dart`):
- `_onAnswerEaten()`: `onCorrectAnswer()` / `onWrongAnswer()`
- `_onAnswerEaten()` streak check: `onStreakMilestone()`
- `_onLevelComplete()`: `onLevelComplete()`
- D-pad/swipe handlers: `onDirectionChange()`

**Dragon Runes** (`lib/games/dragon_runes/dragon_runes_game.dart`):
- `_onEquationValidated()` correct: `onCorrectAnswer()` + streak check
- `_onEquationValidated()` invalid: `onWrongAnswer()`
- `_onLevelComplete()`: `onLevelComplete()`
- `_onChainChanged()`: `onRuneSelect()`

**Dragon's Feast** (`lib/games/dragons_feast/dragons_feast_game.dart`):
- `_onTileEaten()`: `onMunch()` + `onCorrectAnswer()` / `onWrongAnswer()` + streak check
- `_onLevelComplete()`: `onLevelComplete()`
- D-pad/swipe handlers: `onDirectionChange()`

**Dragon Eggs** (`lib/games/dragon_eggs/dragon_eggs_game.dart`):
- `_onEquationResult()`: `onCorrectAnswer()` + `onEggHatch()` / `onWrongAnswer()` + streak check
- Add `onEggSelected` callback from Flame game: `onEggSelect()`

#### B.2 UI Button Haptics (Priority 2 from audit)

Add `onButtonPress()` to all ~22 button handlers, using either:
- The `TapScaleWrapper` widget from Phase A (preferred for new/refactored buttons), or
- Direct `context.read<HapticsService>().onButtonPress()` calls at the start of handlers

Key locations (11 files, ~22 buttons):
- `game_shell.dart` (4 buttons)
- `result_screen.dart` (2 buttons)
- `level_select_screen.dart` (level tile taps)
- `game_card.dart` (game card tap)
- `hub_screen.dart` (2 quick-access buttons)
- `profile_bar.dart` (2 interactive elements)
- `settings_screen.dart` (4 buttons)
- `backup_prompt.dart` (2 buttons)
- `store_screen.dart` (cosmetic tile taps)
- `equation_display.dart` (equals button)
- `hint_button.dart` (hint button)

#### B.3 Service-Level Haptics (Priority 3 from audit)

- Inject `HapticsService` into `RewardService` for `onScalesEarned()` on `_awardScales()`
- Inject `HapticsService` into `ProgressionManager` for `onDragonEvolution()` on
  `checkEvolution()` when evolution stage increments

#### B.4 Error Haptics (Priority 4 from audit)

Add `onError()` to ~6 error/failure handlers:
- Wrong answer flash handlers in Fire Trail and Dragon's Feast
- Player caught by enemy in Dragon's Feast (add callback from Flame game)
- Account upgrade failure in settings and backup prompt
- Store purchase failure (insufficient scales)

#### B.5 Device Testing

- Test all haptic patterns on a real Android device
- Verify haptics toggle in settings disables all haptic feedback
- Verify no haptic calls crash on devices without haptic hardware

**Estimated effort for Phase B: 6-8 hours**

---

### Phase C: Audio Integration (1-2 days)

**Prerequisites:** Phase A complete + audio files placed in `assets/audio/`.
**Reference:** `AUDIO_INTEGRATION_PLAN.md`

#### C.1 Uncomment flame_audio Dependency

In `pubspec.yaml`, uncomment `flame_audio: ^2.1.6`. Run `flutter pub get`.

#### C.2 Hub Music Lifecycle

- `hub_screen.dart`: Call `audioService.playHubMusic()` in `initState` postFrameCallback
- Music continues through Settings and Achievement screens (no change on navigation)

#### C.3 Game Music Lifecycle

- `game_shell.dart`: Call `audioService.playGameMusic(gameId)` in `initState`,
  `audioService.stopMusic()` in `dispose`
- Pause menu: duck music to 20% volume, restore on resume

#### C.4 Victory Music

- `result_screen.dart`: Call `audioService.playVictoryMusic()` in `initState` postFrameCallback

#### C.5 EventBus-Driven SFX

The `AudioEventListener` (created in Phase A) handles the 5 cross-cutting SFX
automatically via EventBus:
- `AnswerGiven` (correct/wrong) -> `playCorrect()` / `playWrong()`
- `StreakAchieved` -> `playStreak()`
- `LevelCompleted` -> `playLevelComplete()`
- `GameEnded` -> `playGameOver()`

**Do NOT add redundant direct calls** in game files for these 5 events -- they are
already handled by the EventBus listener. Direct calls would cause double-play.

#### C.6 Game-Specific Direct SFX

Add direct `audioService.playX()` calls for SFX not modeled as EventBus events:

| Game | SFX Call | Location |
|------|---------|----------|
| Dragon Eggs | `playEggCrack()`, `playEggHatch()` | `_onEquationResult()` callbacks |
| Dragon Runes | `playRuneConnect()`, `playHint()` | `_onEquationValidated()`, `_useHint()` |
| Dragon's Feast | `playMunch()`, `playPowerUp()` | `_onTileEaten()`, power-up handler |
| Fire Trail | `playCountdown()`, `playSwipe()` | Countdown overlay, direction handlers |
| All games | `playCountdown()` | Countdown overlay tick callbacks |
| Hub/UI | `playButtonTap()` | All button handlers (via TapScaleWrapper or direct) |
| Evolution | `playEvolution()`, `playDragonRoar()` | Evolution animation start/complete |
| Store | `playButtonTap()`, `playScalesEarn()` | Purchase button, purchase confirmation |

#### C.7 Settings Toggle Wiring

- `settings_screen.dart`: Wire sound toggle to `audioService.onSoundSettingChanged(v)`
- Wire music toggle to `audioService.onMusicSettingChanged(v)` + `playHubMusic()` on re-enable

#### C.8 App Lifecycle

Add to existing `didChangeAppLifecycleState` in `app.dart`:
- `paused`/`detached`: `audioService.pauseMusic()`
- `resumed`: `audioService.resumeMusic()`

#### C.9 Unit Tests (~30-40 tests)

- Settings respect tests (sound/music disabled prevents playback)
- Music lifecycle tests (track switching, stop, skip-if-same)
- EventBus integration tests (events trigger correct SFX methods)
- Dispose tests (cache cleared, subscriptions cancelled)

**Estimated effort for Phase C: 8-14 hours**

---

### Phase D: Tutorials (2-3 days)

**Prerequisites:** Phase A complete.

#### D.1 TutorialService

**New file:** `lib/core/tutorial_service.dart`

- Tracks which tutorials have been shown (stored in Hive via LocalStorage)
- `bool shouldShowTutorial(String tutorialId)` -- returns true if not yet shown
- `void markTutorialShown(String tutorialId)` -- persists completion
- `void resetAllTutorials()` -- for settings screen "Reset Tutorials" button
- Tutorial IDs: `hub_intro`, `dragon_eggs_intro`, `fire_trail_intro`,
  `dragon_runes_intro`, `dragons_feast_intro`

#### D.2 DragonDialogue Widget

**New file:** `lib/widgets/dragon_dialogue.dart`

- Speech bubble widget with dragon companion image and text
- Positioned at bottom of screen (above navigation)
- Tap to advance to next message, tap on last message to dismiss
- Used in hub tutorial and game tutorials
- Matches design guide typography (Nunito body text, warm white on dark surface)

#### D.3 Hub Tutorial (4 steps)

**Modified file:** `lib/hub/hub_screen.dart`

Show on first app launch (or when tutorials are reset):

1. Dragon companion says "Welcome to my lair! I'm [dragon name]."
2. Highlight game cards: "Choose a game to practice math!"
3. Highlight profile bar: "Earn Dragon Scales to help me grow!"
4. Highlight daily challenge card: "Come back every day for bonus challenges!"

Use `tutorial_coach_mark` package or custom overlay with `Stack` + `AnimatedOpacity`.

#### D.4 Per-Game Tutorials (4 games x 3-4 steps)

Show on first play of each game:

**Dragon Eggs (3 steps):**
1. "Tap eggs to build an equation: number, operator, number, equals!"
2. "Complete correct equations to hatch eggs and earn scales!"
3. "Watch the danger line -- don't let eggs pile up too high!"

**Fire Trail (3 steps):**
1. "Swipe or use the D-pad to guide the dragon!"
2. "Eat the correct answer gem to keep your flame burning!"
3. "Wrong answers reduce your flame intensity. Don't let it go out!"

**Dragon Runes (4 steps):**
1. "Drag to connect rune nodes and form equations!"
2. "Match the target numbers shown on the right!"
3. "Build a streak for bonus points!"
4. "Tap the hint button if you're stuck!"

**Dragon's Feast (4 steps):**
1. "Use the D-pad to move your dragon around the grid!"
2. "Eat tiles that match the category at the top!"
3. "Avoid the enemy guardians -- they'll catch you!"
4. "Grab power-ups for special abilities!"

#### D.5 Help Button in Pause Menu

- Add "How to Play" button to the pause overlay in `game_shell.dart`
- Opens a brief help dialog with the game's tutorial steps as static text
- Uses `TutorialService.resetTutorial(gameId)` to allow replay of the tutorial

#### D.6 Reset Tutorials in Settings

- Add "Reset Tutorials" option in `settings_screen.dart`
- Calls `TutorialService.resetAllTutorials()`
- Shows confirmation dialog before resetting

**Estimated effort for Phase D: 16-24 hours**

---

### Phase E: Art Integration (3-4 days)

**Prerequisites:** Phase A complete + art assets placed in `assets/images/`.
**Reference:** `ART_INTEGRATION_PLAN.md`

This phase replaces all emoji placeholders and procedural Canvas drawings with the
AI-generated art assets. Follow the 4-phase migration strategy from the integration plan.

#### E.1 Hub Screen Art (2-3 hours)

1. Replace `lairGradient` in `hub_screen.dart` with `DecorationImage` for hub background
2. Replace `_evolutionEmojis` in `dragon_companion.dart` with `_evolutionAssets` image paths
3. Replace `_evolutionEmojis` in `profile_bar.dart` with image paths
4. Create `ScaleIcon` widget, replace all `Icons.diamond` instances (4 files)
5. Add `imageAsset` parameter to `GameCard`, pass hub portal images
6. Replace streak flame icons in `daily_challenge_card.dart`
7. Replace emoji in evolution dialog

**Fallback:** Use `Image.asset(..., errorBuilder: ...)` to fall back to emoji if
asset is missing. Keep `_evolutionEmojis` list for fallback.

#### E.2 Game Backgrounds (1-2 hours)

1. Fire Trail: Load background sprite in `FireTrailFlameGame.onLoad()`, pass to GridRenderer
2. Dragon Runes: Replace `backgroundBuilder` gradient with `DecorationImage`
3. Dragon Eggs: Add `DecorationImage` to game screen wrapper
4. Dragon's Feast: Load background sprite in Feast FlameGame `onLoad()`

**Fallback:** Keep original gradient code in `else` branch when sprite is null.

#### E.3 Game Sprites (6-8 hours)

Follow the detailed code patterns from `ART_INTEGRATION_PLAN.md` Section 3:

1. **Fire Trail:** Dragon head (sprite with rotation), answer gems (sprite with text overlay)
2. **Dragon Runes:** Rune nodes (inactive/active sprites with state-based glow/border overlays)
3. **Dragon Eggs:** 6 egg color sprites (map baseColor to sprite), keep pop animation
4. **Dragon's Feast:** Player dragon (3 state sprites), enemy guardian (4 state sprites),
   6 category gems, 3 power-up icons

**Key principle:** Every sprite field is nullable (`Sprite?`). If null, the original
Canvas procedural drawing runs as fallback. This allows incremental integration.

**Testing:** After each game's sprites are integrated, run the full test suite and
play through several levels to verify hitbox alignment and visual correctness.

#### E.4 UI Elements & Store Art (2-3 hours)

1. Replace `Icons.star` / `Icons.star_border` with custom star images (3 files)
2. Replace emoji previews in `store_screen.dart` with color variant images
3. Replace emoji accessories with accessory images
4. Add badge frame image to `achievement_screen.dart`
5. Replace app icon in Android mipmap directories and iOS Assets.xcassets

#### E.5 Feature Flag

Add `AppConfig.useArtAssets` flag (default `false`). Set to `true` once all assets
are verified. This allows shipping with a single toggle if some assets are not ready.

**Estimated effort for Phase E: 20-30 hours**

---

### Phase F: Animations & Polish (3-5 days)

**Prerequisites:** Phase A complete.
**Reference:** `ANIMATION_RESEARCH.md`, `VISUAL_DESIGN_GUIDE.md` Section 10

#### F.1 Screen Transitions (2-3 hours)

Create custom `PageRouteBuilder` transitions for all navigation paths:

| Transition | Type | Duration | Curve |
|-----------|------|----------|-------|
| Hub to Game | Fade + scale up (0.85 to 1.0) | 400ms | `easeInOutCubic` |
| Game to Hub | Fade + scale down (1.0 to 0.85) | 300ms | `easeInOutCubic` |
| Game to Result | Slide up from bottom | 350ms | `easeOutCubic` |
| Any to Dialog | Fade + scale from 0.9 | 250ms | `easeOutBack` |

#### F.2 Micro-Interactions (4-6 hours)

| Animation | Framework | Duration | Notes |
|-----------|-----------|----------|-------|
| Score float (+3 gold text) | Flame MoveEffect + OpacityEffect | 800ms | Float up 40dp, fade out |
| Streak pulse | Flutter AnimationController | 300ms | Scale 1.0-1.15 with `easeOutBack` |
| Star fill sequence | Flutter staggered AnimationControllers | 1200ms | Stars fill at 200ms intervals with `elasticOut` |
| Score tally count-up | Flutter Tween<int> | 600ms | Count from 0 to final value |
| Scales earned particles | Custom Canvas bezier path-following | 800ms | 8-12 gold particles arc to counter |
| Button press feedback | TapScaleWrapper (Phase A) | 250ms | Scale 0.95 and back |

#### F.3 Hub Ambient Effects (3-4 hours)

| Effect | Framework | Description |
|--------|-----------|-------------|
| Floating embers | Custom Canvas (CustomPainter) | 15-25 particles, upward drift with sine wave, alpha 0.2-0.6 |
| Background glow | AnimatedBuilder + CustomPainter | Radial gradient pulse, 8s cycle, opacity 0.1-0.25 |
| Currency shimmer | ShaderMask + AnimationController | Diagonal sweep across scales counter, 3s cycle |
| Star twinkle | Flutter AnimationController | Random 5-10s interval, scale 1.0-1.2 with white flash |

**Performance notes:**
- Hub embers: 15-25 `drawCircle()` calls per frame is negligible
- Pause ambient animations when hub is not visible
- Use `RepaintBoundary` around animated regions

#### F.4 Achievement Popup Enhancement (1 hour)

The existing `AchievementPopupOverlay` (from Step 9) already implements slide-down
with `easeOutBack`. Enhancements:
- Add gold particle burst on appearance
- Add subtle glow behind the badge icon
- Ensure SFX plays (wired in Phase C)

#### F.5 Daily Challenge Completion Animation (1-2 hours)

- Animate checkmark appearance when a task is completed (scale from 0 with `elasticOut`)
- Animate "All Complete!" banner with gold shimmer when all daily tasks are done
- Streak count increment with number bounce

#### F.6 Rive Dragon Companion (Optional, 6-10 hours if time allows)

**This is a stretch goal.** If time and skill allow:
1. Create a `.riv` file in the Rive editor with the dragon companion
2. Add idle breathing state (4s cycle)
3. Add wing stretch state (triggered randomly every 15-30s)
4. Add look-toward state (Number input for head direction based on tapped game card)
5. Integrate using `rive` package's `RiveAnimation` widget on the hub screen
6. Replace the static `Image.asset()` dragon companion with the Rive animation

If skipped, the static image dragon companion from Phase E is the shipped version.

**Estimated effort for Phase F: 20-40 hours (excluding optional Rive)**

---

### Phase G: Testing & Optimization (2-3 days)

**Prerequisites:** All previous phases complete.

#### G.1 Automated Testing

- [ ] `flutter analyze` -- zero warnings/errors
- [ ] `flutter test` -- all tests pass (should be 535+ from previous steps, plus
  new tests from Phases A and C)
- [ ] `flutter build apk --debug` -- build succeeds
- [ ] `flutter build apk --release` -- release build succeeds

#### G.2 Budget Android Device Testing

Test on a budget Android phone (~$150, 2024-2025 vintage, e.g., Samsung Galaxy A15,
Xiaomi Redmi 13, or Motorola Moto G14):

- [ ] App launches without crash
- [ ] Hub screen renders at 60 FPS with ambient effects
- [ ] All 4 games play smoothly at 60 FPS during normal gameplay
- [ ] Particle effects do not cause frame drops below 45 FPS
- [ ] Screen transitions are smooth (no jank on first run)
- [ ] Music plays without stuttering
- [ ] SFX play with no perceptible latency
- [ ] Tutorial overlays render correctly
- [ ] Art assets display at correct sizes and positions
- [ ] No memory pressure warnings during extended play (10+ minutes)

#### G.3 Performance Profiling

Use Flutter DevTools Timeline in Profile mode on the budget device:

- [ ] Frame rendering times stay under 16ms (60 FPS target)
- [ ] No shader compilation jank (Impeller should be active on Android)
- [ ] No memory leaks (heap does not grow unbounded during gameplay)
- [ ] Image cache does not exceed 100 MB

Verify Impeller is active:
```bash
flutter run --verbose 2>&1 | grep -i impeller
```

#### G.4 Particle Count Verification

Verify worst-case particle counts stay within budget:

| Effect | Budget | Actual |
|--------|--------|--------|
| Green burst (correct) | 15-20 | Verify |
| Red burst (wrong) | 8-12 | Verify |
| Gold sparkle (scales) | 8-12 | Verify |
| Spell effect (runes) | ~40 | Verify |
| Munch effect (feast) | 15 | Verify |
| Fire trail embers | 30-50 | Verify |
| Hub ambient embers | 15-25 | Verify |
| **Worst case total** | **~130** | Verify < 150 |

Must stay under 300 simultaneous particles at all times.

#### G.5 Memory Budget Verification

| Category | Budget | Actual |
|----------|--------|--------|
| Hub screen images | ~10 MB | Verify |
| Per-game images | ~8 MB | Verify |
| Audio (SFX cache) | ~1 MB | Verify |
| Audio (music track) | ~1 MB | Verify |
| Rive files (if used) | ~0.5 MB | Verify |
| **Total runtime** | < 150 MB | Verify |

#### G.6 Visual Regression Check

Walk through every screen in the app and verify:

- [ ] Hub screen: background, dragon companion, game cards, profile bar, daily challenge
- [ ] Each game: background, sprites, particle effects, HUD elements
- [ ] Result screen: stars, score tally, scales counter
- [ ] Settings: all toggles work, haptics/sound/music independently toggle
- [ ] Store: color variants display, accessories display, purchase flow works
- [ ] Achievements: badge frames, progress bars, tab navigation
- [ ] Tutorials: display correctly, advance on tap, don't re-show after completion

#### G.7 Audio Regression Check

- [ ] Hub music plays on launch and resumes after returning from games
- [ ] Each game plays its own music track
- [ ] Victory music plays on result screen
- [ ] Music transitions are clean (no overlap, no silence gaps)
- [ ] Backgrounding the app pauses music; foregrounding resumes
- [ ] Disabling music in settings stops it immediately
- [ ] Re-enabling music starts the appropriate track
- [ ] All 18 SFX play at the correct moments
- [ ] SFX do not double-play (EventBus listener handles cross-cutting events)

**Estimated effort for Phase G: 16-24 hours**

---

## 6. Critical Path & Parallelism

### Dependency Graph

```
Pre-Implementation Setup (1 day)
  |
  +--> Art Production (20 days) --------+
  |                                     |
  +--> Audio Production (4 days) ---+   |
  |                                 |   |
  +--> Code Phase A: Foundation ----+---+---+
       (2-3 days)                   |   |   |
         |                          |   |   |
         +--> Phase B: Haptics      |   |   |
         |    (1 day)               |   |   |
         |                          |   |   |
         +--> Phase D: Tutorials    |   |   |
         |    (2-3 days)            |   |   |
         |                          |   |   |
         +--> Phase F: Animations   |   |   |
              (3-5 days)            |   |   |
                                    |   |   |
         Phase C: Audio Integration-+   |   |
         (1-2 days)                     |   |
         Requires: Phase A + audio files|   |
                                        |   |
         Phase E: Art Integration ------+   |
         (3-4 days)                         |
         Requires: Phase A + art files      |
                                            |
         Phase G: Testing & Optimization ---+
         (2-3 days)
         Requires: ALL phases complete
```

### What Can Run in Parallel

| Activity | Can parallel with |
|----------|-------------------|
| Art production | Audio production, all code phases (until Phase E needs assets) |
| Audio production | Art production, Phases A-B-D-F |
| Phase B (Haptics) | Phases D, F (independent) |
| Phase D (Tutorials) | Phases B, F (independent) |
| Phase F (Animations) | Phases B, D (independent) |

### Blocking Dependencies

| Phase | Blocked by |
|-------|-----------|
| Phase C (Audio integration) | Phase A + audio files existing in `assets/audio/` |
| Phase E (Art integration) | Phase A + art files existing in `assets/images/` |
| Phase G (Testing) | All phases A-F complete |

### Recommended Execution Order (for a solo developer)

Since a solo developer cannot truly parallelize, here is the optimal sequence:

1. **Day 1:** Pre-implementation setup
2. **Days 2-5:** Phase A (Foundation) -- while art generation runs in background
3. **Day 6:** Phase B (Haptics)
4. **Days 7-9:** Phase D (Tutorials)
5. **Days 3-20:** Art production (run Midjourney/Leonardo sessions in evenings/breaks)
6. **Days 7-10:** Audio production (Suno sessions, SFX sourcing)
7. **Days 10-11:** Phase C (Audio integration) -- audio files should be ready by now
8. **Days 12-15:** Phase F (Animations & polish)
9. **Days 20-23:** Phase E (Art integration) -- art assets should be ready by now
10. **Days 24-26:** Phase G (Testing & optimization)

**Total calendar time: ~26 days** (assuming ~4-6 hours/day of active development
plus art generation sessions).

---

## 7. Risk Register

| # | Risk | Likelihood | Impact | Mitigation |
|---|------|-----------|--------|-----------|
| 1 | **Art style inconsistency** -- AI-generated images from different tools/sessions look inconsistent | Medium | High | Lock style with Midjourney `--sref` code early (Section 3.2). Use the same style reference on every prompt. Color-correct all assets in post-processing. Generate related assets in the same session. |
| 2 | **Art readability at small sizes** -- Sprites look great at 512px but are illegible at 48-64px display size | Medium | Medium | Test every sprite at its FINAL display size before moving on. Simplify detail if needed. Hand-polish edges in Photopea/Aseprite at small sizes. |
| 3 | **Audio licensing compliance** -- Accidentally using non-commercial audio in a commercial app | Low | High | Only use paid Suno Pro (perpetual commercial), CC0 sources (Kenney, Sonniss), or paid ElevenLabs. Maintain licensing spreadsheet (Section 4.6). Save license terms at time of acquisition. |
| 4 | **Performance on budget Android** -- Art + audio + particles + animations exceed device capabilities | Medium | High | Follow strict performance budgets from `ANIMATION_RESEARCH.md` Section 5. Test on a real budget device early and often. Particle counts capped at 130-150. Keep sprite sheets under 2048x2048. Use Impeller (default on Flutter 3.41.1 Android). |
| 5 | **Scope creep** -- Rive dragon companion, advanced particle effects, or tutorial polish consume excessive time | High | Medium | Rive dragon is explicitly marked as optional/stretch goal. All animations have a "simple" and "enhanced" option. Tutorials use basic DragonDialogue widget, not complex coach marks. Ship the MVP of each feature. |
| 6 | **Midjourney download/availability issues** -- Midjourney has occasional download limits due to Warner Music deal | Low | Medium | Have Leonardo.ai and OpenAI GPT Image API as backup generators. Generate in batches during high-availability windows. Save all outputs immediately. |
| 7 | **flame_audio platform issues** -- Audio playback issues on specific Android devices | Low | Medium | All audio calls are wrapped in try/catch. Game works without audio. The `flame_audio` package is widely used and battle-tested. Test on 2-3 different Android devices. |
| 8 | **Art production takes longer than 20 days** -- AI art requires more iteration than expected | Medium | Low | Art production is decoupled from code phases B-D-F via the fallback strategy. Code can ship with fallback emoji/procedural rendering. Art integration (Phase E) can be incremental -- ship whatever is ready. |
| 9 | **Test suite breaks from new Provider dependencies** -- Adding AudioService/TutorialService to Provider tree breaks existing widget tests | Low | Low | Add services to test helper `MultiProvider` wrappers. Use `testMode` flag in AudioService to skip actual playback. For haptics, platform channel calls are silently ignored in tests. |
| 10 | **APK size increases significantly** -- 75 images + 24 audio files could bloat the APK | Medium | Low | Compress PNGs with pngquant. Use OGG for music (10-15x smaller than WAV). Target total asset increase ~20-25 MB. Google Play allows 150 MB APK / 200 MB AAB. Current APK is well under 30 MB. |

---

## 8. Definition of Done

Step 12 is considered complete when ALL of the following are true:

### Art
- [ ] All 75 image assets generated, post-processed, and placed in `assets/images/`
- [ ] All emoji placeholders in hub screen replaced with art images
- [ ] All procedural Canvas drawings in game components have sprite alternatives
  (with fallback to procedural if sprite is null)
- [ ] App icon replaced in Android mipmap directories
- [ ] Feature graphic created for Google Play Store listing
- [ ] All art assets pass the quality checklist (color palette, readability, transparency,
  naming, no AI text, age-appropriate, file size budget)

### Audio
- [ ] 6 music tracks generated, processed, and placed in `assets/audio/music/`
- [ ] 18 SFX sourced, processed, and placed in `assets/audio/sfx/`
- [ ] `AudioService` class implemented with all named methods
- [ ] `AudioEventListener` wired to EventBus for 5 cross-cutting events
- [ ] Hub music plays on launch and transitions to game music on game entry
- [ ] Victory music plays on result screen
- [ ] All game-specific SFX play at correct moments
- [ ] Music pauses on app background, resumes on foreground
- [ ] Sound and music toggles in settings work independently and immediately
- [ ] Licensing spreadsheet maintained for all audio assets

### Haptics
- [ ] All 51 missing haptic calls from the audit are implemented
- [ ] Haptics toggle in settings disables all haptic feedback
- [ ] Every game event (correct, wrong, streak, level complete) triggers the appropriate
  haptic pattern
- [ ] All UI buttons trigger `onButtonPress()` haptic

### Animations & Polish
- [ ] Screen transitions implemented (hub-to-game, game-to-result, dialog animations)
- [ ] Score float animation in all games
- [ ] Star fill sequence on result screen
- [ ] Scales earned particle animation
- [ ] Hub ambient effects (floating embers, background glow, currency shimmer)
- [ ] Button press feedback (scale animation) on all interactive elements

### Tutorials
- [ ] Hub tutorial shows on first launch (4 steps)
- [ ] Per-game tutorial shows on first play of each game (3-4 steps per game)
- [ ] "How to Play" button in pause menu replays tutorial
- [ ] "Reset Tutorials" option in settings
- [ ] Tutorial state persisted in Hive (survives app restart)

### Loading & Empty States
- [ ] Splash screen shows during app initialization
- [ ] Native splash screen configured via flutter_native_splash
- [ ] Empty state widgets for screens with no data

### Technical
- [ ] `flutter analyze` returns zero warnings/errors
- [ ] All tests pass (`flutter test`)
- [ ] Debug APK builds successfully (`flutter build apk --debug`)
- [ ] Release APK builds successfully (`flutter build apk --release`)
- [ ] App runs at 60 FPS on a budget Android device during normal gameplay
- [ ] No memory leaks during extended play sessions
- [ ] Total APK size increase from Step 12 is under 30 MB

### Optional (Stretch Goals, NOT required for completion)
- [ ] Rive dragon companion with idle/react/evolve animations
- [ ] Dragon evolution transition animation (Rive + Flutter layered)
- [ ] Fire trail continuous ember emitter with particle pooling
- [ ] Egg hatch multi-phase animation (crack, break, baby dragon fly)
- [ ] Advanced ambient effects (star twinkle, background parallax)

---

## 9. Cost Summary

### One-Time Costs

| Item | Cost | Notes |
|------|------|-------|
| Google Play Developer Account | $25 | Required for Step 13 (Launch), not Step 12. Already planned. |

### Monthly Subscription Costs (1-2 months active)

| Service | Monthly (Annual) | Duration Needed | Total |
|---------|-----------------|-----------------|-------|
| Midjourney Standard | $24/mo | 1-2 months | $24-$48 |
| Leonardo.ai Apprentice | $12/mo | 1-2 months | $12-$24 |
| Ideogram Basic | $7/mo | 1 month | $7 |
| Suno Pro | $10/mo | 1 month | $10 |
| Rive Cadet (optional) | $9/mo | 0-1 month | $0-$9 |
| **Subtotal** | | | **$53-$98** |

### Pay-Per-Use Costs

| Service | Estimated Usage | Total |
|---------|----------------|-------|
| OpenAI GPT Image API | ~50 images at $0.02/ea | ~$1 |
| Additional API retries/iterations | Buffer | ~$9 |
| **Subtotal** | | **~$10** |

### Optional Costs

| Service | Cost | When Needed |
|---------|------|-------------|
| Soundraw (backup music) | $11 for 1 month | Only if Suno output unsatisfactory |
| ElevenLabs Starter (custom SFX) | $50/year | Only if free tier insufficient for commercial use |
| **Subtotal** | | **$0-$61** |

### Free Tools (No Cost)

| Tool | Purpose |
|------|---------|
| rembg | Background removal |
| Upscayl | Image upscaling |
| Audacity | Audio editing |
| FFmpeg | Audio conversion |
| Photopea | Image editing |
| JSFXR | Retro SFX generation |
| Python + Pillow | Batch image resizing |
| Kenney.nl audio packs | UI SFX (CC0) |
| Sonniss GameAudioGDC | Game SFX (royalty-free) |
| Freesound.org (CC0) | Specific SFX |
| Pixabay Music | Backup music source |

### Total Cost Summary

| Scenario | Total Cost |
|----------|-----------|
| **Minimum** (1 month subs, free SFX only, no Rive) | **$63** |
| **Expected** (1 month subs, some paid SFX) | **$113** |
| **Maximum** (2 months subs, all backups, Rive Cadet) | **$186** |

For comparison, hiring professionals for equivalent work:
- Freelance game artist: $2,000-$5,000+
- Freelance composer: $500-$3,000+
- Freelance sound designer: $300-$1,500+

---

*Document created: 2026-02-16*
*Project: Math Dragons (Flutter 3.41.1, Dart 3.11.0, Flame 1.14)*
*Status: Ready for execution*
