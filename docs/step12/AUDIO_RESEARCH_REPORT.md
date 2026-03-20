# Math Dragons -- Audio & Music Research Report

**Date:** February 2026
**Project:** Math Dragons (Flutter mobile game, ages 7-14, fantasy/dragon theme)
**Purpose:** Evaluate sources for background music (6 tracks) and sound effects (18 SFX)

---

## Table of Contents

1. [AI Music Generation Tools](#1-ai-music-generation-tools)
2. [Royalty-Free Music Libraries](#2-royalty-free-music-libraries)
3. [Sound Effects Sources](#3-sound-effects-sources)
4. [Recommended Strategy](#4-recommended-strategy)
5. [Music Requirements Specification](#5-music-requirements-specification)
6. [SFX Requirements Specification](#6-sfx-requirements-specification)

---

## 1. AI Music Generation Tools

### Suno AI

| Attribute | Details |
|---|---|
| **Free Plan** | 50 credits/day (~10 songs), non-commercial use only |
| **Pro Plan** | $10/mo ($8/mo annual) -- 2,500 credits/month, commercial rights |
| **Premier Plan** | ~$30/mo ($24/mo annual) -- 10,000 credits/month, Suno Studio (stems, early access) |
| **Commercial License** | Songs made while subscribed carry perpetual commercial rights. Suno claims no stake in earnings. Free-tier songs are non-commercial only. Retroactive licensing not available. |
| **Loop Capability** | Yes -- Loop Mode added April 2025. Generates seamless background loops for game soundtracks. Set in/out points and repetition counts. |
| **Fantasy Quality** | Excellent. V5 model delivers clear orchestral separation (strings, winds, percussion are individually discernible). Well-suited for medieval/fantasy instrumentation. |
| **Output Formats** | MP3 on free; WAV on paid plans. Stems available on Premier. |
| **2026 Note** | Warner Music licensing deal in late 2025 introduced stricter download limits. Downloads may be capped even on paid plans with occasional download windows. |

**Verdict:** Best overall AI generator for this project. Loop mode, high orchestral quality, and affordable Pro plan ($10/mo) make it the top choice. One month of Pro ($10) should produce all 6 tracks with credits to spare.

### Udio

| Attribute | Details |
|---|---|
| **Free Plan** | 10 credits/day + 100/month bank, commercial use (attribution required) |
| **Standard Plan** | ~$10/mo -- 2,400 credits/month, no attribution needed |
| **Pro Plan** | ~$30/mo -- 6,000 credits/month |
| **Commercial License** | Commercial rights on all tiers. Free tier requires attribution; paid tiers do not. |
| **Loop Capability** | Not a dedicated feature. Must manually craft loops from extended generation. |
| **Fantasy Quality** | Competitive with Suno, strong on genre diversity. |
| **Output Formats** | WAV, video, stems -- **HOWEVER, as of early 2026, all downloads are temporarily disabled** due to major-label licensing transition with Universal Music. Only occasional short download windows announced. |
| **2026 Note** | Universal/Udio subscription service planned for 2026. Currently in a transitional state that makes the platform unreliable for production use. |

**Verdict:** NOT recommended at this time. Downloads being disabled is a dealbreaker. Re-evaluate in late 2026 once the Universal partnership launches.

### Soundraw

| Attribute | Details |
|---|---|
| **Creator Plan** | $11.04/mo -- basic generation and download |
| **Artist Starter** | $19.49/mo |
| **Artist Pro** | $23.39/mo |
| **Artist Unlimited** | $32.49/mo |
| **Commercial License** | Worldwide, perpetual commercial license. Tracks stay licensed even after cancellation. Cannot register with Content ID. 100% royalty ownership on streaming (Artist tiers). |
| **Loop Capability** | Yes -- built-in mixer allows fine-tuning every bar, toggling instruments, adjusting intensity. Dynamic Tracks feature auto-varies loops. Good loop support. |
| **Fantasy Quality** | Moderate. 30+ genres available; "Cinematic" mood is closest to fantasy. V2 allows blending two genres (e.g., "Cinematic" + "Classical"). Not specifically tuned for fantasy/medieval, but customizable. |
| **Output Formats** | MP3 and WAV. Full stems downloadable. |
| **Unique Advantage** | Owns all master recordings and publishing rights in the training data -- no legal gray areas. |

**Verdict:** Strong runner-up. Excellent licensing terms and mixer customization. Slightly less suited for fantasy-specific music than Suno's prompt-driven approach, but the stem downloads and bar-by-bar editing are valuable for loop perfection.

### AIVA

| Attribute | Details |
|---|---|
| **Free Plan** | 3 downloads/month, up to 3 min, MP3 + MIDI only, non-commercial |
| **Standard Plan** | EUR 15/mo (~$16/mo) -- 15 downloads/month, 5 min max, monetize on YouTube/Twitch/TikTok/Instagram only |
| **Pro Plan** | EUR 49/mo (~$53/mo) -- 300 downloads/month, 5.5 min max, ALL formats (WAV), **full copyright ownership** |
| **Commercial License** | Free = non-commercial. Standard = limited commercial (social platforms only). Pro = full copyright transfer, unrestricted commercial use forever. |
| **Loop Capability** | No dedicated loop mode. Must manually compose and arrange for seamless loops. MIDI export allows manual loop-point editing in a DAW. |
| **Fantasy Quality** | Excellent. 250+ style presets including dedicated "Fantasy" style. Orchestral compositions are AIVA's strongest area -- sweeping strings, brass, and percussion. Rated 7/10 in independent reviews for overall quality. |
| **Output Formats** | Free/Standard: MP3 + MIDI. Pro: WAV, FLAC, MP3, MIDI. |

**Verdict:** Best orchestral quality and has a dedicated Fantasy style, but the Pro plan at EUR 49/mo is expensive for a one-time need of 6 tracks. Consider a single month subscription if Suno's output doesn't meet quality standards.

### Mubert

| Attribute | Details |
|---|---|
| **Free (Render)** | Watermarked, 100 API calls/month |
| **Ambassador** | $14/mo -- personal use |
| **Pro** | $39/mo -- commercial license, no watermark |
| **API Pro** | $99/mo -- 1,000 API calls, commercial license |
| **Commercial License** | Royalty-free commercial use on Pro plan and above. API 2.0 beta is currently non-commercial only. |
| **Loop Capability** | Generates continuous ambient/generative music streams. Good for ambient backgrounds but less controllable for structured game tracks. |
| **Fantasy Quality** | Weak for fantasy. Mubert excels at electronic, ambient, and lo-fi genres. Not suited for orchestral fantasy/medieval compositions. |
| **Output Formats** | MP3, WAV on paid plans. |

**Verdict:** NOT recommended for this project. Mubert's strength is electronic/ambient music, which does not match the fantasy/medieval aesthetic of Math Dragons.

### Beatoven.ai

| Attribute | Details |
|---|---|
| **Free Plan** | Limited generation minutes |
| **Creator Plan** | ~$2.50/mo (entry tier) |
| **Paid Plans** | From ~$20/mo with minute-based download allocations |
| **Commercial License** | Non-exclusive perpetual license for all downloads. Fairly Trained certified -- ethically trained on licensed music. |
| **Loop Capability** | Can adjust tempo, modify intensity at specific points, extend clip length, remix sections. Seamless loop creation supported but not a primary feature. |
| **Fantasy Quality** | Moderate. 16 emotion presets (happy, motivational, scary, etc.). Better for video backgrounds and podcasts than for game soundtracks. Limited orchestral instrument control. |
| **Output Formats** | MP3 and WAV. Stem downloads on paid plans. |
| **Unique Advantage** | Fairly Trained certification -- independently verified ethical training practices. Lowest risk for Content ID issues. |

**Verdict:** Interesting for ethical sourcing but not the best fit for fantasy game music. The mood-based system is too broad for the specific medieval/dragon aesthetic needed.

### AI Music Generator Comparison Summary

| Tool | Monthly Cost | Fantasy Quality | Loop Support | Commercial License | Recommended? |
|---|---|---|---|---|---|
| **Suno** | $10 (Pro) | Excellent | Yes (Loop Mode) | Yes (perpetual) | **YES -- Primary** |
| Udio | $10 (Standard) | Good | No | Yes | NO (downloads disabled) |
| Soundraw | $11+ | Moderate | Yes (mixer) | Yes (perpetual) | Backup option |
| AIVA | $53 (Pro) | Excellent | No (manual) | Yes (full copyright) | If higher quality needed |
| Mubert | $39 (Pro) | Poor | Yes (ambient) | Yes | NO (wrong genre) |
| Beatoven.ai | $20+ | Moderate | Limited | Yes (perpetual) | NO (too generic) |

---

## 2. Royalty-Free Music Libraries

### Epidemic Sound

| Attribute | Details |
|---|---|
| **Creator Plan** | $9.99/mo (annual) or $17.99/mo (monthly) |
| **Pro Plan** | $29.99/mo (annual) or $74.99/mo (monthly) |
| **Enterprise** | Custom pricing, 12-month minimum |
| **Game Development** | Dedicated game development page exists. Enterprise license likely required for mobile app distribution. |
| **License Model** | Subscription-based. Music is licensed while subscribed. Royalty-free, no additional cost per publish. |
| **Fantasy Catalog** | Large library (40,000+ tracks). Fantasy/adventure category exists but is not the platform's strength. |
| **Format** | WAV, MP3, stems available |
| **Note for Games** | Standard Creator/Pro plans cover online content (YouTube, social). For in-app game distribution, Enterprise plan is almost certainly required. Contact sales for pricing -- likely $500+/year. |

**Verdict:** Overkill for 6 tracks. Enterprise pricing for game distribution is expensive and not transparent. Better suited for content creators who need ongoing access to a large library.

### Artlist

| Attribute | Details |
|---|---|
| **Music & SFX Social** | $9.99/mo (annual) -- social platforms only |
| **Music & SFX Pro** | $16.58-$24.92/mo (annual) -- commercial use |
| **Artlist Max** | $39.99/mo (annual, ~$480/year) -- everything |
| **Business Plan** | Custom pricing -- **required for games, apps, software** |
| **License for Games** | Standard plans explicitly do NOT cover apps/games. Business plan required. Contact sales. |
| **Fantasy Catalog** | Good cinematic/orchestral catalog. Celtic, epic, adventure sub-genres available. |
| **Format** | WAV, MP3 |

**Verdict:** NOT recommended. The Business plan requirement for games means custom/enterprise pricing with no transparent cost. Impractical for an indie project needing only 6 tracks.

### AudioJungle (Envato)

| Attribute | Details |
|---|---|
| **Pricing Model** | Per-track purchase. Standard license: $15-$35/track. Extended license (required for games): $80+/track. |
| **Envato Elements** | ~$12.50/mo (subscription) -- unlimited downloads, but license may not cover mobile games. |
| **License for Games** | Extended license required for mobile apps/games where end users pay (or app contains paid elements). One license per project per track. |
| **Fantasy Catalog** | Large. Search "fantasy adventure," "medieval," "epic orchestral" -- thousands of results with previews. |
| **Format** | WAV, MP3 (varies by seller) |
| **Estimated Cost** | 6 tracks x ~$80-$120 extended license = **$480-$720 total** |

**Verdict:** Good quality and legal clarity, but expensive for the extended license. The per-track model means $80+ per track for game use. Only worth it if you find the perfect tracks and want human-composed quality.

### Incompetech (Kevin MacLeod)

| Attribute | Details |
|---|---|
| **Pricing** | Free with CC BY attribution. No-attribution license: $30 for 1 track, $50 for 2, $20/track for 3+ |
| **License** | CC BY 4.0 -- commercial use allowed with attribution. Or pay for attribution-free use. |
| **Fantasy Catalog** | Moderate. Kevin MacLeod has 2,000+ pieces. Fantasy/adventure tracks exist but production quality is dated (2000s-era synthesized orchestral). |
| **Format** | MP3 (free), WAV available on some tracks |
| **Estimated Cost** | 6 tracks with no-attribution: $30 + $50 + ($20 x 4) = **$160** or free with attribution |

**Verdict:** Budget-friendly but production quality has not kept pace with modern standards. The orchestral tracks sound noticeably synthetic. Acceptable for a prototype or MVP, but not for a polished release.

### Free Music Archive (FMA)

| Attribute | Details |
|---|---|
| **Pricing** | Free. Tracks licensed under various CC licenses. |
| **License** | Varies per track: CC0, CC BY, CC BY-SA, CC BY-NC. Must check each track. Avoid CC BY-NC for commercial app. |
| **Fantasy Catalog** | Small and inconsistent. Quality varies wildly. Few dedicated fantasy/medieval tracks. |
| **Format** | MP3 primarily |

**Verdict:** NOT recommended as a primary source. Too much variance in quality and licensing. Useful for supplementary searching but unreliable for a cohesive soundtrack.

### Pixabay Music

| Attribute | Details |
|---|---|
| **Pricing** | Completely free. No account required to download. |
| **License** | Pixabay Content License -- free for commercial and non-commercial use, no attribution required. |
| **Fantasy Catalog** | Moderate. Searching "fantasy," "medieval fantasy," "epic fantasy" returns dozens of results. Quality is mid-tier -- some gems among many average tracks. |
| **Format** | MP3 (no WAV option on most tracks) |
| **Limitation** | MP3 only is a minor limitation. No stems. No loop-point metadata. |

**Verdict:** Worth browsing as a free option. If you find tracks that fit, the licensing is the simplest possible (no attribution, no cost). Convert MP3 to WAV/OGG as needed. Quality is hit-or-miss but the price is right.

### Mixkit

| Attribute | Details |
|---|---|
| **Pricing** | Completely free. No account required. |
| **Music License** | Stock Music Free License -- personal and commercial projects, YouTube, social, ads, podcasts, educational. **EXCLUDES: video games, CDs, DVDs, TV/radio broadcast.** |
| **SFX License** | Sound Effects Free License -- **includes video games**, apps, all media. |
| **Fantasy Catalog** | Small. Limited fantasy/adventure selection. |

**Verdict:** CRITICAL WARNING -- Mixkit's music license explicitly excludes video games. Their music tracks CANNOT be used in Math Dragons. However, their sound effects CAN be used in games. Use Mixkit for SFX only, not for music.

### Royalty-Free Library Comparison Summary

| Library | Cost for 6 Tracks | Game License? | Fantasy Quality | Recommended? |
|---|---|---|---|---|
| Epidemic Sound | $500+/yr (Enterprise) | Enterprise only | Good | NO (too expensive) |
| Artlist | Custom (Business) | Business only | Good | NO (custom pricing) |
| AudioJungle | $480-$720 (extended) | Yes (extended) | Good | Backup option |
| Incompetech | $0-$160 | Yes (CC BY or paid) | Dated | Budget backup |
| FMA | Free | Check per track | Variable | NO (unreliable) |
| **Pixabay Music** | **Free** | **Yes** | **Mid-tier** | **Worth browsing** |
| Mixkit | Free | **NO (music excluded)** | Small | **SFX only** |

---

## 3. Sound Effects Sources

### Freesound.org

| Attribute | Details |
|---|---|
| **Pricing** | Free (account required to download) |
| **License Types** | CC0 (do anything), CC BY (attribution required), CC BY-NC (non-commercial -- avoid these) |
| **Catalog** | 600,000+ sounds. Huge variety. Filter by license type. |
| **Game SFX Quality** | Variable. Professional-quality recordings mixed with amateur uploads. Must audition carefully. |
| **Format** | WAV, FLAC, OGG, MP3 (varies by upload) |
| **Key Tip** | Filter searches to CC0 or CC BY only for commercial use. Avoid CC BY-NC sounds. |

**Verdict:** Excellent free source for specific SFX. Filter by CC0 license for simplest compliance. Plan to spend time auditioning many clips to find the right ones.

### Zapsplat

| Attribute | Details |
|---|---|
| **Free Tier** | MP3 only, download limits, attribution required ("Credit: Zapsplat") |
| **Gold (Premium)** | GBP 4/mo (GBP 30/year, ~$38/year) -- WAV, unlimited downloads, no attribution, thousands of extra premium SFX |
| **License** | Free: commercial use with attribution. Gold: perpetual, unlimited projects, worldwide, no attribution, even after cancellation. |
| **Catalog** | 200,000+ sound effects. Well-organized categories. Game audio section available. |
| **Format** | Free: MP3. Gold: WAV (professional quality). |

**Verdict:** Strong contender. The Gold annual plan at ~$38/year is very affordable for WAV access with no attribution. Good organization makes finding specific game SFX efficient.

### Pixabay Sound Effects

| Attribute | Details |
|---|---|
| **Pricing** | Completely free, no account required |
| **License** | Pixabay Content License -- commercial use, no attribution |
| **Catalog** | 120,000+ sound effects. Game sound effects category available. |
| **Format** | MP3 primarily |
| **Limitation** | MP3 format only. Must convert to WAV for Flutter integration. |

**Verdict:** Good free source. The game SFX section has useful clips. MP3-only is a minor inconvenience (easy to convert). Worth searching first before paying for anything.

### SoundSnap

| Attribute | Details |
|---|---|
| **6-Month Plan** | $149 ($25/mo) -- 150 downloads/month |
| **Annual Plan** | $249 ($21/mo) -- unlimited downloads |
| **License** | Single unified license covering broadcast, TV, VOD, apps, video games, all media. Commercial rights included. |
| **Catalog** | 400,000+ sounds. Professional studio quality. Well-tagged and searchable. |
| **Format** | WAV (high quality), MP3 |

**Verdict:** Premium quality but expensive for only 18 SFX. The $249/year plan is overkill unless you need ongoing access. Consider only if free sources don't yield satisfactory results.

### Sonniss GameAudioGDC

| Attribute | Details |
|---|---|
| **Pricing** | Completely free |
| **License** | Royalty-free, no attribution, commercial use in any project. No fees or paperwork. |
| **Catalog** | 200+ GB across multiple years. 300,000+ sound effects from 1,000+ sound libraries. Professional studio quality. |
| **Format** | WAV (professional quality) |
| **Download** | Large ZIP files (multi-GB). Available at sonniss.com/gameaudiogdc |

**Verdict:** EXCELLENT free resource. Professional-quality WAV files specifically curated for game development. The only downside is the massive download size -- you'll need to download large bundles and search through them locally. Well worth the disk space for a game project.

### Kenney.nl

| Attribute | Details |
|---|---|
| **Pricing** | Completely free |
| **License** | CC0 (Creative Commons Zero) -- public domain, no restrictions whatsoever |
| **Audio Packs** | UI Audio (50 assets), Digital Audio (60 assets), Impact Sounds (130 assets), RPG Audio, Interface Sounds |
| **Format** | OGG and WAV |
| **Quality** | Clean, consistent, designed specifically for games. Retro/clean digital aesthetic. |

**Verdict:** EXCELLENT for UI sounds (button taps, menu clicks) and basic game feedback sounds. The RPG Audio pack may contain useful fantasy-themed effects. CC0 license is the cleanest possible -- zero compliance burden.

### SFXR / JFXR / Bfxr

| Attribute | Details |
|---|---|
| **Pricing** | Completely free, open source |
| **JSFXR** | Browser-based at sfxr.me -- no download needed |
| **JFXR** | Browser-based at jfxr.frozenfractal.com |
| **Bfxr** | Desktop app at bfxr.net |
| **Output** | WAV export. 44100 Hz / 22050 Hz. 8-bit or 16-bit. |
| **Style** | Retro 8-bit/chiptune aesthetic. Procedurally generated using waveform synthesis. |
| **Presets** | Random generators for: Pickup/Coin, Laser/Shoot, Explosion, Powerup, Hit/Hurt, Jump, Blip/Select |

**Verdict:** Good for quick prototyping of game SFX. The retro 8-bit sound may not match Math Dragons' fantasy aesthetic for primary effects, but could work for UI feedback sounds (button tap, countdown beeps). Use selectively alongside more polished sources.

### ElevenLabs Sound Effects

| Attribute | Details |
|---|---|
| **Free Plan** | 10,000 credits/month (~50 sound effects at 200 credits each) |
| **Starter Plan** | $50/year -- more credits |
| **Paid Plans** | Scale up to Business at $13,200/year |
| **Cost Per SFX** | 200 credits per generation (auto duration) or 40 credits/second (custom duration) |
| **Commercial License** | Free plan: non-commercial only. Paid plans: commercial use with written consent requirement (check current terms). |
| **Quality** | Sound Effect V2 (Sept 2025): up to 30 seconds, seamless looping, 48 kHz professional quality. Text-to-SFX with good prompt adherence. |
| **Output** | WAV, high quality |

**Verdict:** Promising for custom SFX generation from text prompts. The free tier gives ~50 generations which is enough for all 18 SFX with retries. However, commercial licensing on the free plan is non-commercial only -- a Starter plan ($50/year) may be needed. Good for hard-to-find fantasy SFX (dragon roar, egg crack, magical transformation).

### SFX Source Comparison Summary

| Source | Cost | Game License? | Quality | Best For |
|---|---|---|---|---|
| **Sonniss GDC** | Free | Yes (royalty-free) | Professional | Dragon roar, impacts, magic |
| **Kenney.nl** | Free | Yes (CC0) | Good (clean) | UI sounds, button taps |
| **Freesound.org** | Free | Yes (CC0/CC BY) | Variable | Specific niche SFX |
| **Pixabay SFX** | Free | Yes | Good | General game SFX |
| Zapsplat | $38/yr | Yes (Gold) | Good | If free sources insufficient |
| SFXR/JFXR | Free | Yes (you own it) | Retro 8-bit | Countdown beeps, UI clicks |
| **ElevenLabs** | $0-$50/yr | Paid plans | Excellent | Custom fantasy SFX |
| SoundSnap | $249/yr | Yes | Professional | If premium quality needed |
| Mixkit SFX | Free | Yes | Good | General game SFX |

---

## 4. Recommended Strategy

### Best Approach for Background Music

**Primary: Suno AI Pro ($10 for one month)**

1. Subscribe to Suno Pro for one month ($10).
2. Use Loop Mode + detailed fantasy/orchestral prompts to generate all 6 tracks.
3. Generate 3-5 variations per track, select the best.
4. Download as WAV with stems (if on Premier) or WAV (on Pro).
5. Use Audacity (free) to trim loop points and verify seamless looping.
6. Cancel subscription after one month. All downloaded tracks retain perpetual commercial rights.

**Backup: Pixabay Music (free) + Soundraw ($11 for one month)**

If Suno output is unsatisfactory for any track:
- Browse Pixabay Music for free fantasy tracks that fit.
- Subscribe to Soundraw for one month ($11) to use the bar-by-bar mixer for precise loop crafting.

**Estimated Music Cost: $10-$21**

### Best Approach for Sound Effects

**Multi-source free strategy with ElevenLabs for custom SFX:**

1. **Kenney.nl** (free, CC0) -- Download UI Audio and RPG Audio packs for:
   - button_tap.wav, countdown.wav (from UI Audio / Interface Sounds)
   - scales_earn.wav (from coin/pickup sounds)

2. **Sonniss GameAudioGDC** (free, royalty-free) -- Download and search bundles for:
   - dragon_roar.wav (creature/monster SFX)
   - level_complete.wav (fanfare/stinger)
   - game_over.wav (negative stinger)
   - power_up.wav (energy/whoosh)
   - swipe.wav (whoosh)
   - munch.wav (bite/chomp)

3. **Freesound.org** (free, filter CC0) -- Search for:
   - egg_crack.wav (search: "egg crack," "shell break")
   - streak.wav (search: "ascending sparkle," "magic whoosh")
   - correct.wav (search: "positive chime," "correct ding")
   - wrong.wav (search: "error buzz," "wrong answer")

4. **ElevenLabs Sound Effects** (free tier for prototyping, $50/yr Starter if needed) -- Generate custom SFX for:
   - egg_hatch.wav ("cracking egg shell bursting open with a baby dragon chirp squeak")
   - evolution.wav ("magical transformation with rising energy, sparkling particles, and dramatic crescendo")
   - achievement.wav ("grand magical reveal with shimmering bells and orchestral hit")
   - rune_connect.wav ("magical energy arc connection with electric sparkle")
   - hint.wav ("gentle magical sparkle reveal sound")

5. **JSFXR** (free, browser-based) -- Generate as fallback for:
   - Simple UI beeps and clicks if Kenney packs don't have the right feel

**Estimated SFX Cost: $0-$50**

### Estimated Total Cost

| Item | Low Estimate | High Estimate |
|---|---|---|
| Music (Suno Pro, 1 month) | $10 | $10 |
| Music (Soundraw backup, 1 month) | $0 | $11 |
| SFX (free sources) | $0 | $0 |
| SFX (ElevenLabs Starter, if needed) | $0 | $50 |
| **Total** | **$10** | **$71** |

This compares favorably to alternatives:
- AudioJungle extended licenses: $480-$720
- Epidemic Sound Enterprise: $500+/year
- Hiring a composer: $500-$3,000+
- Hiring a sound designer: $300-$1,500+

### Licensing Compliance Checklist for a Kids App on Google Play

1. **COPPA Compliance (Audio-specific)**
   - [ ] Audio files do not contain children's voices or personally identifiable audio
   - [ ] No audio is collected from users (microphone access not used)
   - [ ] Audio content is appropriate for ages 7-14 (no violent, scary, or mature themes)
   - [ ] FTC considers "music or other audio content" when evaluating child-directed services -- ensure audio reinforces the educational/child-friendly nature

2. **Google Play Families Program**
   - [ ] All content (including audio) meets Families program requirements
   - [ ] Audio does not promote age-inappropriate products or behaviors
   - [ ] App age rating updated per January 31, 2026 deadline

3. **Music Licensing Documentation**
   - [ ] Maintain a spreadsheet of every audio asset with: source, license type, date acquired, cost, and any attribution requirements
   - [ ] Save screenshots/PDFs of license terms at time of purchase (terms can change)
   - [ ] For Suno: Save confirmation of Pro subscription dates and which tracks were generated during that period
   - [ ] For CC BY sources: Include attribution in app credits/about screen
   - [ ] For CC0 sources: No action needed but document anyway

4. **Attribution Requirements**
   - [ ] If using any CC BY licensed audio: include credit in app's About/Credits screen
   - [ ] If using Freesound CC BY clips: credit authors as specified
   - [ ] If using Zapsplat free tier: credit "Zapsplat" in credits
   - [ ] Zero-attribution sources (Suno paid, Kenney CC0, Pixabay, Sonniss): no credit needed

5. **No Content ID Conflicts**
   - [ ] AI-generated music from Suno is unique and will not trigger Content ID
   - [ ] Soundraw explicitly prohibits Content ID registration (non-issue for in-app use)
   - [ ] Verify no third-party has registered similar AI-generated clips

6. **File Format Compliance**
   - [ ] All audio files are in a format supported by Flutter audioplayers (WAV, MP3, OGG, AAC)
   - [ ] File sizes are reasonable for mobile distribution (compress long tracks to OGG)
   - [ ] No DRM or encryption on audio files

---

## 5. Music Requirements Specification

### Track 1: Hub Theme

| Attribute | Specification |
|---|---|
| **Mood** | Warm, inviting, magical, calm but with wonder. A cozy dragon's den. |
| **Tempo** | 80-100 BPM (relaxed, not rushed) |
| **Instruments** | Harp, soft strings (viola, cello), gentle flute, light chimes/bells, subtle low brass warmth |
| **Duration** | 60-90 seconds, seamless loop |
| **Key** | D major or G major (warm, bright) |
| **Loop Requirements** | Must loop seamlessly with no audible click or gap. Fade tail should cross-fade into intro. |
| **Reference** | Think "Stardew Valley" title screen meets "Harry Potter" common room |

**Suno Prompt:**
```
Medieval fantasy, warm and inviting; harp + soft strings + gentle flute + light chimes;
instrumental only; calm magical atmosphere, cozy dragon's den; 80-90 BPM; D major;
looping background music for a kids game hub screen; clean mix
```

**Library Search Terms:** "fantasy tavern music," "cozy medieval," "magical calm orchestral," "RPG town theme"

### Track 2: Dragon Runes (Puzzle Game)

| Attribute | Specification |
|---|---|
| **Mood** | Mystical, ethereal, contemplative, puzzle-solving concentration. Purple/magic vibes. |
| **Tempo** | 90-110 BPM (moderate, thinking pace) |
| **Instruments** | Celesta/music box, ethereal pads, pizzicato strings, light percussion (finger cymbals, triangle), glass harmonica textures |
| **Duration** | 60-90 seconds, seamless loop |
| **Key** | A minor or E minor (mystical, slightly dark) |
| **Loop Requirements** | Seamless loop. Minimalist arrangement that doesn't distract from puzzle-solving. |
| **Reference** | Think "Tetris Effect" ambient meets medieval spellcasting |

**Suno Prompt:**
```
Mystical ethereal puzzle music; celesta + ethereal pads + pizzicato strings + soft triangle;
instrumental only; magical contemplative atmosphere, ancient runes and spellcasting;
95-105 BPM; A minor; looping background music for a puzzle game; gentle and hypnotic;
clean mix; not distracting
```

**Library Search Terms:** "mystical puzzle music," "ethereal fantasy," "magical thinking music," "enchanted ambient"

### Track 3: Fire Trail (Snake-style Action Game)

| Attribute | Specification |
|---|---|
| **Mood** | Energetic, exciting, building tension, fire/speed vibes. Adrenaline but kid-friendly. |
| **Tempo** | 130-150 BPM (fast, driving) |
| **Instruments** | Driving percussion (taiko drums, snare), bold brass (horns, trumpets), fast strings (staccato violins), electric energy elements |
| **Duration** | 60-90 seconds, seamless loop |
| **Key** | E minor or B minor (intense, dramatic) |
| **Loop Requirements** | Seamless loop. Energy level should remain consistent (no big builds/drops that reveal the loop point). |
| **Reference** | Think "Dragon's Lair" arcade meets "Pac-Man Championship Edition" energy |

**Suno Prompt:**
```
Epic action fantasy, energetic and intense; taiko drums + bold brass + staccato strings +
driving percussion; instrumental only; fire dragon chase, fast-paced adventure;
140 BPM; E minor; looping background music for an arcade action game;
consistent high energy throughout; kids game; clean mix
```

**Library Search Terms:** "epic action game music," "fast fantasy battle," "dragon chase music," "intense arcade orchestral"

### Track 4: Dragon Eggs (Bubble Pop Game)

| Attribute | Specification |
|---|---|
| **Mood** | Playful, whimsical, bouncy, lighthearted. Eggs hatching, spring/nature vibes. |
| **Tempo** | 110-125 BPM (upbeat, bouncy) |
| **Instruments** | Xylophone/marimba, plucked strings (pizzicato, ukulele), light woodwinds (recorder, piccolo), bouncy bass, playful percussion (woodblock, tambourine) |
| **Duration** | 60-90 seconds, seamless loop |
| **Key** | C major or F major (bright, cheerful) |
| **Loop Requirements** | Seamless loop. Bouncy, consistent groove. Should feel like a playful nursery in a dragon's nest. |
| **Reference** | Think "Yoshi's Island" egg throws meets "Kirby" dreamland |

**Suno Prompt:**
```
Playful whimsical fantasy, bouncy and cheerful; xylophone + pizzicato strings + recorder +
light percussion + bouncy bass; instrumental only; dragon eggs hatching, spring garden,
cute and fun; 115 BPM; C major; looping background music for a kids bubble pop game;
lighthearted and silly; clean mix
```

**Library Search Terms:** "playful fantasy music," "whimsical bouncy game," "cute dragon music," "kids puzzle cheerful"

### Track 5: Dragon's Feast (Pac-Man-style Arcade Game)

| Attribute | Specification |
|---|---|
| **Mood** | Adventurous, treasure-hunt energy, arcade excitement, exploration. |
| **Tempo** | 120-135 BPM (upbeat, adventurous) |
| **Instruments** | Snare/march drums, adventurous brass (French horn, trumpet), playful strings, adventure flute, light synth accents |
| **Duration** | 60-90 seconds, seamless loop |
| **Key** | Bb major or G major (heroic, bright) |
| **Loop Requirements** | Seamless loop. Constant sense of forward motion and exploration. |
| **Reference** | Think "Indiana Jones" meets "Pac-Man" -- treasure hunting with urgency |

**Suno Prompt:**
```
Adventure fantasy arcade, heroic and exciting; French horn + march drums + adventure flute +
playful strings; instrumental only; dragon treasure hunt, dungeon exploration, arcade energy;
125 BPM; G major; looping background music for an arcade exploration game;
heroic and fun; kids game; clean mix
```

**Library Search Terms:** "adventure arcade music," "treasure hunt fantasy," "heroic exploration game," "dungeon crawler upbeat"

### Track 6: Result/Victory Screen

| Attribute | Specification |
|---|---|
| **Mood** | Triumphant, celebratory, proud, rewarding. Gold and treasure revealed. |
| **Tempo** | 110-120 BPM (celebratory, not rushed) |
| **Instruments** | Full brass fanfare (trumpets, horns, trombones), timpani, crash cymbals, triumphant strings, harp glissando |
| **Duration** | 15-20 seconds, NON-LOOPING (plays once) |
| **Key** | D major (triumphant, golden) |
| **Loop Requirements** | None -- plays once and stops. Should have a clear ending with a final sustained chord or cymbal decay. |
| **Reference** | Think "Final Fantasy" victory fanfare meets "Legend of Zelda" treasure chest open |

**Suno Prompt:**
```
Triumphant victory fanfare, grand and celebratory; trumpet fanfare + full brass + timpani +
crash cymbal + harp glissando + strings; instrumental only; dragon treasure reveal,
achievement unlocked, victory celebration; 115 BPM; D major; short 15-second victory jingle;
builds to a grand final chord; kids game; clean mix
```

**Library Search Terms:** "victory fanfare," "triumphant jingle," "game win celebration," "fantasy reward music"

---

## 6. SFX Requirements Specification

### 1. correct.wav -- Positive Feedback Chime

| Attribute | Specification |
|---|---|
| **Character** | Bright, positive, satisfying ding/chime. Clean single note. |
| **Duration** | 0.3 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney UI Audio "confirmation" sounds; or Freesound CC0 search "positive chime" |
| **ElevenLabs Prompt** | "Short bright positive chime ding, single musical note, happy confirmation sound" |
| **JSFXR** | Preset: "Pickup/Coin" -- adjust frequency up, reduce sustain |
| **Search Terms** | "correct answer ding," "positive chime," "success bell," "right answer sound" |

### 2. wrong.wav -- Negative Feedback

| Attribute | Specification |
|---|---|
| **Character** | Low, brief buzz or dull thud. Not harsh or scary (kids game). Gentle "nope." |
| **Duration** | 0.3 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney UI Audio "error" or "negative" sounds; Freesound CC0 search "wrong buzz" |
| **ElevenLabs Prompt** | "Short low gentle buzz, wrong answer sound effect, not harsh, kid-friendly error tone" |
| **JSFXR** | Preset: "Hit/Hurt" -- lower frequency, very short sustain |
| **Search Terms** | "wrong answer buzz," "error sound gentle," "incorrect thud," "soft negative tone" |

### 3. streak.wav -- Streak Achievement

| Attribute | Specification |
|---|---|
| **Character** | Ascending sparkle/whoosh. Magical rising energy. Three quick ascending notes. |
| **Duration** | 0.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Sonniss GDC bundles (magic/sparkle category); Freesound CC0 "ascending sparkle" |
| **ElevenLabs Prompt** | "Quick ascending magical sparkle whoosh, three rising tones, shimmering energy streak" |
| **Search Terms** | "ascending sparkle," "magic combo," "streak sound," "rising chime sequence" |

### 4. level_complete.wav -- Level Victory

| Attribute | Specification |
|---|---|
| **Character** | Short triumphant fanfare. Brass + cymbal hit. Rewarding and proud. |
| **Duration** | 1.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Sonniss GDC bundles (stinger/fanfare category); AudioJungle search if needed |
| **ElevenLabs Prompt** | "Short triumphant victory fanfare, brass trumpets with cymbal crash, level complete celebration, 1.5 seconds" |
| **Search Terms** | "level complete fanfare," "short victory jingle," "game stage clear," "triumph stinger" |

### 5. achievement.wav -- Achievement Unlock

| Attribute | Specification |
|---|---|
| **Character** | Grand magical reveal. Shimmering bells + orchestral swell. More elaborate than level_complete. |
| **Duration** | 1.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | ElevenLabs for custom generation; Sonniss GDC (magic/reveal category) |
| **ElevenLabs Prompt** | "Grand magical achievement reveal with shimmering bells, sparkle dust, and a brief orchestral swell, magical trophy unlock sound" |
| **Search Terms** | "achievement unlock," "magical reveal," "trophy earned," "grand discovery sound" |

### 6. scales_earn.wav -- Currency Pickup

| Attribute | Specification |
|---|---|
| **Character** | Light coin/gem pickup with sparkle. Quick and satisfying. Slightly crystalline. |
| **Duration** | 0.3 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney RPG Audio (coin pickup); Freesound CC0 "coin collect sparkle" |
| **ElevenLabs Prompt** | "Quick light crystal gem pickup sound with tiny sparkle, coin collect chime" |
| **JSFXR** | Preset: "Pickup/Coin" -- default works well, tweak frequency for crystalline feel |
| **Search Terms** | "coin pickup," "gem collect," "crystal chime," "currency earn sparkle" |

### 7. egg_crack.wav -- Egg Cracking

| Attribute | Specification |
|---|---|
| **Character** | Organic cracking/breaking. Like an eggshell splitting. Not harsh -- satisfying crack. |
| **Duration** | 0.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Freesound CC0 "egg crack" or "shell break"; Sonniss GDC (foley category) |
| **ElevenLabs Prompt** | "Egg shell cracking and splitting open, organic breaking sound, satisfying crack" |
| **Search Terms** | "egg crack," "shell break," "eggshell snap," "cracking open" |

### 8. egg_hatch.wav -- Egg Hatching Complete

| Attribute | Specification |
|---|---|
| **Character** | Shell burst + magical sparkle + cute baby dragon chirp/squeak. Multi-layered. |
| **Duration** | 1.0 second |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | ElevenLabs for custom composite; or layer: Freesound (shell crack) + (sparkle) + (baby creature chirp) |
| **ElevenLabs Prompt** | "Dragon egg hatching open with shell bursting, magical sparkle shower, and a cute baby dragon chirp squeak, fantasy hatching sound" |
| **Search Terms** | "egg hatch," "creature born," "magical birth," "baby dragon chirp" |

### 9. dragon_roar.wav -- Dragon Roar

| Attribute | Specification |
|---|---|
| **Character** | Short, triumphant dragon roar. Powerful but not terrifying (kids game). More "proud" than "scary." |
| **Duration** | 1.0 second |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Sonniss GDC bundles (creature/monster category); ElevenLabs for custom |
| **ElevenLabs Prompt** | "Short triumphant dragon roar, powerful but not scary, proud fantasy dragon call, kid-friendly, 1 second" |
| **Search Terms** | "dragon roar," "fantasy creature call," "dragon triumphant," "proud beast roar short" |

### 10. munch.wav -- Chomping/Eating

| Attribute | Specification |
|---|---|
| **Character** | Quick, satisfying chomp/bite. Cartoonish, fun. |
| **Duration** | 0.2 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney RPG Audio or Impact Sounds; Freesound CC0 "cartoon chomp" |
| **ElevenLabs Prompt** | "Quick cartoon chomp bite eating sound, fun and satisfying munch" |
| **Search Terms** | "cartoon bite," "chomp sound," "eating munch," "quick crunch" |

### 11. button_tap.wav -- UI Button Press

| Attribute | Specification |
|---|---|
| **Character** | Soft, clean UI click. Gentle tactile feedback. Not intrusive. |
| **Duration** | 0.1 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney UI Audio (primary choice -- specifically designed for this); Interface Sounds pack |
| **JSFXR** | Preset: "Blip/Select" -- reduce volume, short sustain |
| **Search Terms** | "soft UI click," "button tap," "menu select," "gentle interface click" |

### 12. evolution.wav -- Dragon Evolution/Transformation

| Attribute | Specification |
|---|---|
| **Character** | Dramatic magical transformation. Rising energy, sparkling particles, culminating swell. The most elaborate SFX. |
| **Duration** | 2.0 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | ElevenLabs custom generation (best option for this unique SFX) |
| **ElevenLabs Prompt** | "Dramatic magical transformation sound effect, rising sparkling energy that builds and swells, dragon evolving with power, magical metamorphosis with shimmer crescendo, 2 seconds" |
| **Search Terms** | "magical transformation," "evolution power up," "metamorphosis spell," "dragon level up dramatic" |

### 13. countdown.wav -- 3-2-1 Countdown Tick

| Attribute | Specification |
|---|---|
| **Character** | Clean tick or beep. Needs to work as repeated identical ticks for 3-2-1 countdown. |
| **Duration** | 0.3 seconds per tick (single tick exported) |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney UI Audio or Digital Audio (clock/timer sounds); JSFXR "Blip/Select" |
| **JSFXR** | Preset: "Blip/Select" -- clean square wave, medium pitch, very short |
| **Search Terms** | "countdown beep," "timer tick," "clock tick digital," "game countdown" |

### 14. game_over.wav -- Game Over

| Attribute | Specification |
|---|---|
| **Character** | Sad/deflating. Descending tone, gentle disappointment. NOT harsh or punishing (kids game). |
| **Duration** | 1.0 second |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Sonniss GDC (stinger/negative category); Freesound CC0 "game over" |
| **ElevenLabs Prompt** | "Gentle game over sound, descending sad tone, deflating disappointment, not harsh, kid-friendly, 1 second" |
| **Search Terms** | "game over gentle," "sad descending tone," "failure sound soft," "disappointed jingle" |

### 15. power_up.wav -- Power-Up Activation

| Attribute | Specification |
|---|---|
| **Character** | Energy surge, power boost. Quick ascending energy with punch. |
| **Duration** | 0.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Sonniss GDC (power-up category); Kenney RPG Audio; JSFXR "Powerup" |
| **ElevenLabs Prompt** | "Quick power up energy surge sound, ascending electric boost, game power activation" |
| **JSFXR** | Preset: "Powerup" -- default is usually good, adjust to taste |
| **Search Terms** | "power up," "energy boost," "game powerup," "ability activation" |

### 16. hint.wav -- Hint/Reveal

| Attribute | Specification |
|---|---|
| **Character** | Gentle magical sparkle/reveal. Like a secret being whispered. Subtle but noticeable. |
| **Duration** | 0.5 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Freesound CC0 "magic sparkle"; Sonniss GDC (magic category) |
| **ElevenLabs Prompt** | "Gentle magical sparkle reveal, hint of magic, soft shimmering discovery sound, subtle and mystical" |
| **Search Terms** | "magic sparkle hint," "gentle reveal," "mystical shimmer," "secret discovery" |

### 17. rune_connect.wav -- Magical Energy Connection

| Attribute | Specification |
|---|---|
| **Character** | Magical energy arc/connection. Electric sparkle zap. Short and crisp. |
| **Duration** | 0.3 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | ElevenLabs for custom; Sonniss GDC (magic/electric category) |
| **ElevenLabs Prompt** | "Short magical energy connection arc, electric sparkle zap linking two points, rune activation" |
| **Search Terms** | "magic connection," "energy arc," "spell link," "rune activate electric" |

### 18. swipe.wav -- Gesture Whoosh

| Attribute | Specification |
|---|---|
| **Character** | Quick, clean whoosh. Like a fast hand swipe through air. |
| **Duration** | 0.2 seconds |
| **Format** | WAV, 44100 Hz, 16-bit |
| **Source Strategy** | Kenney Impact Sounds or UI Audio; Sonniss GDC (whoosh category) |
| **ElevenLabs Prompt** | "Quick short whoosh swipe sound, fast movement through air, clean gesture sound" |
| **Search Terms** | "short whoosh," "swipe sound," "fast air movement," "gesture whoosh" |

---

## Appendix: Source Links

### AI Music Generators
- Suno: https://suno.com/pricing
- Udio: https://www.udio.com/pricing
- Soundraw: https://soundraw.io/
- AIVA: https://www.aiva.ai/
- Mubert: https://mubert.com/render/pricing
- Beatoven.ai: https://www.beatoven.ai/pricing

### Royalty-Free Libraries
- Epidemic Sound: https://www.epidemicsound.com/pricing/
- Artlist: https://artlist.io/page/pricing
- AudioJungle: https://audiojungle.net/licenses
- Incompetech: https://incompetech.com/music/royalty-free/
- Free Music Archive: https://freemusicarchive.org/
- Pixabay Music: https://pixabay.com/music/
- Mixkit: https://mixkit.co/

### Sound Effects
- Freesound: https://freesound.org/
- Zapsplat: https://www.zapsplat.com/
- Pixabay SFX: https://pixabay.com/sound-effects/
- SoundSnap: https://www.soundsnap.com/
- Sonniss GameAudioGDC: https://sonniss.com/gameaudiogdc/
- Kenney Audio: https://kenney.nl/assets/category:Audio
- JSFXR: https://sfxr.me/
- JFXR: https://jfxr.frozenfractal.com/
- Bfxr: https://www.bfxr.net/
- ElevenLabs SFX: https://elevenlabs.io/sound-effects

### Tools
- Audacity (loop trimming): https://www.audacityteam.org/
- FFmpeg (format conversion): https://ffmpeg.org/
