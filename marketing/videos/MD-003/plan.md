# MD-003: production plan

Einstein didn't fail math (F4 with still Tallyclaw art + Narrator). 60 s, 1080 × 1920, 30 fps. Treatment: `treatment.md`. Media root: `~/Videos/math-dragons/MD-003/` (paths below are relative to it).

- **Gameplay:** none (no app tie-in in this video), so nothing to capture on build 1.0.4 (9).
- **Tallyclaw:** Narrator-only default; his line is a text card. Stills from `marketing/production/tallyclaw/<pose>.png` (being generated; Justin approves poses before use), copied into `art/`.
- **Math strings** (`1896`, `Top grade: 6`, `Algebra: 6`, `Geometry: 6`, `1935`, `Age 16`, `1895`, `Graduated 1900`) are rendered by a Manim script that doesn't exist yet: `marketing/production/manim/MD-003.py` (to write, same self-check pattern as MD-004).
- **Recreations** (certificate, clipping, exam paper) are our own layouts and type, never photos or Ripley's art. No Einstein likeness needed; if one is used, flat illustration only.

| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-5 s | Tallyclaw still, left of frame | Tallyclaw still: `unimpressed` | art/tallyclaw_unimpressed.png | todo (candidates in progress) |
| 0-5 s | "FAILED MATH" scroll, right of frame | Illustration: style-bible image, no text in image; "FAILED MATH" added as text in Manim/Kdenlive | art/scroll.png | todo |
| 0-5 s | Text: "Einstein failed math?" + speech card "I was there. He did not." | Kdenlive title (Nunito Bold), card held 3 s or more | (in project) | todo |
| 0-5 s | VO line 1: "Parents, Einstein failed math? Tallyclaw was there. His verdict: he did not." | ElevenLabs, Narrator | vo/line01.mp3 | todo |
| 0-5 s | SFX: low dragon rumble on "His verdict: he did not." | Game SFX `assets/audio/sfx/dragon_roar.wav`, pitched down / low in the mix | music/sfx_rumble.wav | todo |
| 5-15 s | Swiss school building (flat style) | Illustration: style-bible image, no text | art/school.png | todo |
| 5-15 s | Recreated certificate, rows light up gold: `1896`, `Top grade: 6`, `Algebra: 6`, `Geometry: 6` | Manim: MD-003.py `Certificate` (to write) | math/Certificate.mp4 | todo |
| 5-15 s | VO line 2: "In eighteen ninety-six, Einstein finished school in Switzerland. On a scale where six was the top grade, he got sixes in algebra and geometry." | ElevenLabs, Narrator | vo/line02.mp3 | todo |
| 15-24 s | 1935 clipping, recreated (plain type, no Ripley's logo) slides in; text "One famous version / 1935 / Ripley's Believe It or Not" | Illustration (blank clipping, no text) + Manim: MD-003.py `Clipping` (`1935`) + Kdenlive title for the words | art/clipping.png, math/Clipping.mp4 | todo |
| 15-24 s | VO line 3: "So where did the story come from? One famous version: in nineteen thirty-five, a rabbi in Princeton showed him a Ripley's clipping." | ElevenLabs, Narrator | vo/line03.mp3 | todo |
| 24-28 s | Headline card, gold quote marks: "Greatest living mathematician failed in mathematics" | Kdenlive title over art/clipping.png | (in project) | todo |
| 24-28 s | VO line 4: "The headline: Greatest living mathematician failed in mathematics." | ElevenLabs, Narrator | vo/line04.mp3 | todo |
| 28-31 s | Tallyclaw still + quote card "I never failed in mathematics." | Tallyclaw still: `smug`; Kdenlive title | art/tallyclaw_smug.png | todo |
| 28-31 s | VO line 5: "Einstein's reply: I never failed in mathematics." | ElevenLabs, Narrator | vo/line05.mp3 | todo |
| 31-41 s | Math card `Age 16` · `1895` · Zurich; exam paper splits, "General part" struck in fire orange; text "The inconvenient part / General part: failed" | Manim: MD-003.py `ExamSplit` (to write) | math/ExamSplit.mp4 | todo |
| 31-41 s | VO line 6: "Now the inconvenient part. At sixteen, he did fail a university entrance exam in Zurich. He fell short on the exam's general part." | ElevenLabs, Narrator | vo/line06.mp3 | todo |
| 41-45 s | Same paper, other half glows emerald: "Math and physics: very good" | Manim: MD-003.py `ExamSplit` (continues) | math/ExamSplit.mp4 | todo |
| 41-45 s | VO line 7: "In math and physics, he did very well." | ElevenLabs, Narrator | vo/line07.mp3 | todo |
| 45-54 s | Certificate over Aarau, then flat map path Aarau → Zurich, "1900" stamp; text "Aarau: the sixes / Aarau → Zurich / `Graduated 1900`" | Illustration: map (no text) + Manim: MD-003.py `AarauToZurich` (to write) | art/map.png, math/AarauToZurich.mp4 | todo |
| 45-54 s | VO line 8: "He went to school in Aarau, where he earned those sixes, then got into that same Zurich school and graduated in nineteen hundred." | ElevenLabs, Narrator | vo/line08.mp3 | todo |
| 54-57 s | Awe beat: Tallyclaw looking at the "1900" stamp; text "One bad exam at 16" | Tallyclaw still: `neutral` | art/tallyclaw_neutral.png | todo (neutral candidates v1-v3 exist) |
| 54-57 s | VO line 9: "One bad exam didn't decide his story." | ElevenLabs, Narrator | vo/line09.mp3 | todo |
| 57-60 s | Opening frame again; scroll now stamped "MYTH" (loop) | Tallyclaw still: `unimpressed` + art/scroll.png + Kdenlive "MYTH" stamp | (in project) | todo |
| 57-60 s | SFX: stamp on "MYTH" | Not in `assets/audio/sfx/`: generate with ElevenLabs SFX (`/generate-sfx`) and keep the receipt | music/sfx_stamp.mp3 | todo |
| 57-60 s | VO line 10: "So, Einstein failed math? Tallyclaw's verdict stands." | ElevenLabs, Narrator | vo/line10.mp3 | todo |
| whole | Word timings for captions | Whisper word timestamps on the final VO, or ElevenLabs alignment | vo/narrator.timings.json | todo |
| whole | Captions `.ass` (burned in) + `.srt` (YouTube); display map for years (1896, 1935, 1895, 1900 automatic) | `marketing/production/captions.py --treatment ... --speaker Narrator` | captions/MD-003.ass, captions/MD-003.srt | todo |
| whole | Corner mark `playmathdragons.com`, top-left, cream 70 % | Kdenlive title | (in project) | todo |
| whole | Music bed under VO | Game track `assets/audio/music/dragon_runes.ogg` | music/dragon_runes.ogg | todo |
| whole | Master export, about -14 LUFS | Kdenlive (H.264, 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz) | renders/MD-003_master.mp4 | todo |

Music: `assets/audio/music/dragon_runes.ogg` (game soundtrack, Routeworks LLC rights confirmed 2026-10-26). SFX stamp: ElevenLabs SFX + license receipt in `music/`.
Cover frame: 0-5 s (Tallyclaw, the "FAILED MATH" scroll and "Einstein failed math?" visible).
