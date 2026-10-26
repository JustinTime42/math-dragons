---
status: draft (awaiting accuracy review + Justin's approval)
guide: production-pipeline
created: 2026-10-26
sources:
  - marketing/reports/Faceless short form video playbook.md (pipeline and cost sections)
  - marketing/research_notes/Faceless short form video playbook/ai_production_pipeline.md
  - marketing/guides/format-library.md, script-standards.md, visual-style.md, compliance-checklist.md
---

# Production Pipeline

How an approved treatment becomes a finished video. Two phases: **manual first** (learn what works on the first 6-9 videos), then **automate what repeats**. Prices and tool details are from October 2026 research and change often; check them before buying.

## 1. Folder layout

```
marketing/videos/MD-###/
  treatment.md     Stage 3 (script-standards.md template)
  review.md        accuracy + compliance results, both gates
  plan.md          Stage 4 production plan (§5)
  upload.md        what was posted where, settings used, links
```

**Media stays out of git** (video files are large). Store it outside the repo at `~/Videos/math-dragons/MD-###/` with subfolders `vo/`, `gameplay/`, `math/`, `art/`, `music/`, `renders/`, and reference paths from `plan.md`. Keep license receipts for any third-party or AI audio in that folder.

## 2. Voices (one-time setup)

| Voice | How | Notes |
|---|---|---|
| **Narrator (Justin)** | ElevenLabs **Professional Voice Clone** (Justin has the Creator plan, 2026-10-26) | Needs substantially more clean audio than an instant clone; follow ElevenLabs' current recording guidance (quiet room, consistent mic, natural reading). YouTube exempts cloning your own voice from its AI disclosure; Facebook needs the AI label (`compliance-checklist.md` §C) |
| **Tallyclaw** | ElevenLabs Voice Design from the prompt in `brand-and-voice.md` §4.2 | Generate 3-5 candidates; Justin picks |

Lock both: record the voice IDs, model and settings (stability, similarity, style) in `marketing/production/voices.md` so every video sounds the same. Commercial use requires a paid ElevenLabs plan; confirm the Creator plan's terms cover use by Routeworks LLC (ElevenLabs' music terms limit lower plans to individual use, and the voice terms should be checked the same way).

## 3. Phase A: manual (first 6-9 videos)

Per video, after the treatment passes its gate:

1. **Production plan** (`plan.md`, §5): every beat mapped to an asset and its source.
2. **Voice-over:** generate the Narrator and Tallyclaw lines in ElevenLabs. Save 2-3 takes; pick the best.
3. **Timing:** get word-level timestamps by aligning the final VO to the script text: run Whisper with word timestamps on the VO (or group ElevenLabs' per-character timestamps into words), then check the words match the script exactly.
4. **Math cards:** render each exact math string with Manim (Python) from scripts in `marketing/production/manim/`. Never type math into an AI tool.
5. **Gameplay:** record on a physical Android phone with `scrcpy --record` (avoids the on-device 3-minute limit). Turn on Do Not Disturb, hide notifications, and use a fresh test profile.
6. **Hands footage:** phone camera, overhead, per `visual-style.md` §10.
7. **Tallyclaw:** still art until the puppet exists (§6).
8. **Captions:** a small script (`marketing/production/captions.py`, to build) turns the aligned words into an `.ass` subtitle file with 2-4 words per line and the current word in gold, plus a plain `.srt`. The `.ass` is burned in; the `.srt` is uploaded to YouTube as the caption file.
9. **Assemble:** in **Kdenlive** (free, Linux-native, handles phone and scrcpy H.264 footage and AAC audio, has a built-in subtitle editor): 1080 × 1920 timeline, gameplay, math cards, hands, Tallyclaw, corner mark, music. (DaVinci Resolve's free Linux version can't import or export H.264 or AAC, so it would need every file converted first; not worth it for Phase A.)
10. **Audio:** voice first. Music well under the VO; aim for about -14 LUFS integrated for the whole mix (a common social-video loudness target; the platforms normalize anyway).
11. **Export:** H.264 MP4, 1080 × 1920, 30 fps, high bitrate (16-20 Mbps), AAC 48 kHz stereo, captions burned in (or burn them afterwards with ffmpeg from the `.ass` file). One clean master per video.
12. **Render gate:** a fresh independent review of the actual file (`fact-check-protocol.md` §2b). Justin watches it.
13. **Upload:** natively to YouTube (with the `.srt` caption file) and Facebook, following `compliance-checklist.md` §J. Record it in `upload.md`.

**Time:** the first videos will take several hours each while templates and habits form. Research estimates about 45-90 minutes of human time per video once templated (an estimate, not a measured figure).

## 4. Phase B: automate what repeats (after about 6-9 videos)

Build only what Phase A showed is repetitive. The target shape from the research:

- **Treatment to JSON:** a script turns `treatment.md` into a JSON spec (beats, VO lines, math strings, gameplay clip in/out points, art, music).
- **Automated math check:** every number in the VO and captions is recomputed and matched against the math-card data before rendering.
- **VO by API:** ElevenLabs with timestamps, using the locked voices.
- **Remotion** (React) `ShortTemplate` composition renders captions, math cards (or Manim clips), gameplay, Tallyclaw and the corner mark from the JSON. Remotion is free for individuals and companies of up to 3 people.
- **Rhubarb Lip Sync** turns Tallyclaw's VO into mouth-shape timings for the puppet.
- **Scripted gameplay capture** with a Flutter integration test and a fixed seed, so the same moment can be re-recorded on demand.
- Code lives in `marketing/production/`.

What stays human: the treatment, the picks (takes, cover frame), and both review gates.

## 5. Production plan template (`plan.md`, Stage 4)

```markdown
# MD-###: production plan
| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-1 s | Puzzle math card | Manim: puzzle.py | math/puzzle.mp4 | todo |
| 0-1 s | VO line 1 (Narrator) | ElevenLabs | vo/line1.mp3 | todo |
Music: <game track / ElevenLabs Music + license receipt>
Cover frame: <timestamp>
```

## 6. Tallyclaw puppet (one-time build)

1. Generate puppet art per `visual-style.md` §8 (front-facing bust, separate layers, nine mouth shapes, blink, 3-4 poses) from the style bible, then clean it up by hand.
2. Rig in Remotion (layer swaps) or Rive.
3. Drive the mouth from Rhubarb output; add idle breathing and blinks.
4. Test with three lines of different lengths; Justin approves before any F4 video uses the puppet.

## 7. Video models (optional, tested first)

Sora's API was shut down on 2026-09-24. Candidates for short, text-free hero shots from style-bible art are Kling, Google Veo and Runway. Before any use: a small bake-off with 3-5 style-bible images to see which keeps the flat illustrated look, and a check of current model IDs and commercial terms. Veo output carries Google's invisible SynthID watermark; YouTube may auto-label AI content it detects.

## 8. Music

1. **The game's own soundtrack and SFX** (`assets/audio/`). Justin confirmed 2026-10-26 that Routeworks LLC has the rights to use the music commercially. It makes the videos sound like the game. (Technical note: the music `.ogg` files are actually MP3s; fine for editing.) Never register it with Content ID if it's AI-generated.
2. ElevenLabs Music, only on a plan whose current terms cover use by Routeworks LLC in published social video (their music terms limit lower plans to individual use; check before first use and keep the receipt).
3. Facebook only: Meta's Sound Collection.
Never trending commercial songs on the Facebook Page. Never register AI music with Content ID.

## 9. Budget

| Item | Estimate |
|---|---|
| Variable cost per video (VO, a few images, optional hero shot) | about $1-5 (research estimate) |
| ElevenLabs subscription | Starter or Creator tier, depending on cloning and volume |
| Kdenlive, Manim, Remotion (up to 3 people), Rhubarb, scrcpy, ffmpeg, Whisper | free |

## 10. Open decisions (Justin)

Resolved 2026-10-26 (Justin): Creator plan with a Professional Voice Clone; media stored locally only (`~/Videos/math-dragons/`); editor is Claude's pick, Kdenlive.

Still open:
1. ElevenLabs terms: does the Creator plan cover commercial use by Routeworks LLC (voice and music)?
