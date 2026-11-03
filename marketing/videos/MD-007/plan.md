# MD-007: production plan

Make a ten, decoded (Homework Decoder, F3). 56 s, 1080 × 1920, 30 fps. Treatment: `treatment.md`. Media root: `~/Videos/math-dragons/MD-007/` (paths below are relative to it).

- **Math cards:** `marketing/production/manim/MD-007.py`. Previews in `math/preview/`; masters via `render.py MD-007 -q h` into `math/`.
- **Minus glyph (open, Justin's call):** the treatment writes `10 - 8 = 2` with an ASCII hyphen (as the CCSS text does); visual-style §6 says to use U+2212. The card renders the treatment verbatim. To switch, change the treatment string first, then the script; the self-check keeps them in step.
- **Gameplay:** none (the app drills facts, it doesn't teach making ten), so nothing to capture on build 1.0.4 (9). **Tallyclaw:** none.
- **Recreated worksheet:** our own layout and type, no publisher design, no child's name or handwriting.

| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-4 s | Worksheet line on a cream card: `Make a ten to add: 8 + 6 = ___` | Manim: MD-007.py `Worksheet` | math/Worksheet.mp4 | preview rendered |
| 0-4 s | Text: "Make a ten?" | Kdenlive title | (in project) | todo |
| 0-4 s | VO line 1: "Your kid's homework says make a ten. Here's what that means." | ElevenLabs, Narrator | vo/line01.mp3 | todo |
| 4-9 s | `8 + 6`, then `10 - 8 = 2` small beneath; text "8 needs 2 more to make 10" | Manim: MD-007.py `EightPlusSix`; Kdenlive title | math/EightPlusSix.mp4 | preview rendered |
| 4-9 s | VO line 2: "Take eight plus six. Eight is two away from ten." | ElevenLabs, Narrator | vo/line02.mp3 | todo |
| 9-13 s | The 6 splits into 2 and 4: `6 = 2 + 4` | Manim: MD-007.py `SplitSix` | math/SplitSix.mp4 | preview rendered |
| 9-13 s | VO line 3: "So split the six into two and four." | ElevenLabs, Narrator | vo/line03.mp3 | todo |
| 13-18 s | `8 + 2 = 10`, then `10 + 4 = 14` | Manim: MD-007.py `MakeTen` | math/MakeTen.mp4 | preview rendered |
| 13-18 s | SFX: correct chime on `= 14` | Game SFX `assets/audio/sfx/correct.wav` | music/correct.wav | todo |
| 13-18 s | VO line 4: "Eight plus two makes ten. Ten plus four is fourteen." | ElevenLabs, Narrator | vo/line04.mp3 | todo |
| 18-21 s | Justin's hands, overhead, tap the paper; text "You may already do this" | Hands footage (phone, overhead, purple cloth, no rings); Kdenlive title | hands/tap_paper.mp4 | todo |
| 18-21 s | VO line 5: "You may already do this in your head." | ElevenLabs, Narrator | vo/line05.mp3 | todo |
| 21-26 s | Full chain one step at a time: `8 + 6 = 8 + 2 + 4 = 10 + 4 = 14` (stacked, = signs aligned); label `Common Core 1.OA.C.6, grade 1` | Manim: MD-007.py `FullChain` | math/FullChain.mp4 | preview rendered |
| 21-26 s | VO line 6: "That's the exact example in the Common Core standard for first grade." | ElevenLabs, Narrator | vo/line06.mp3 | todo |
| 26-33 s | Re-hook: one box (`8 + 6`) splits into two easy boxes (`8 + 2 = 10`, `10 + 4 = 14`); text "Why teach it? / 1 harder fact → 2 easy steps" | Manim: MD-007.py `WhyTeach`; Kdenlive title | math/WhyTeach.mp4 | preview rendered |
| 26-33 s | VO line 7: "Why teach it? Ten is easy to add to, so one harder fact becomes two easy steps." | ElevenLabs, Narrator | vo/line07.mp3 | todo |
| 33-44 s | Ten frame (2 rows of 5): 8 gold dots; 2 dots slide in from a frame of 6, leaving 4; text "Ten frame: a box with 10 spaces / Studies: kids who needed extra help" | Manim: MD-007.py `TenFrame`; Kdenlive title | math/TenFrame.mp4 | preview rendered |
| 33-44 s | VO line 8: "Here it is as a ten frame, a box with ten spaces. In studies of kids who needed extra help, pictures like this were part of what worked." | ElevenLabs, Narrator | vo/line08.mp3 | todo |
| 44-48 s | The standard's strategies listed briefly, "making ten" highlighted; text "One of several strategies" | Kdenlive title, list copied from CCSS 1.OA.C.6 (claim 7: counting on, making ten, decomposing a number leading to ten, relationship between addition and subtraction, easier equivalent sums) | (in project) | todo |
| 44-48 s | VO line 9: "The standard lists it as one of several strategies." | ElevenLabs, Narrator | vo/line09.mp3 | todo |
| 48-55 s | Hands write "How many more to make 10?", put the pen down, slide the paper away | Hands footage | hands/write_question.mp4 | todo |
| 48-55 s | Text: "Ask: "How many more to make 10?"" | Kdenlive title | (in project) | todo |
| 48-55 s | VO line 10: "To help at home, ask one question: how many more to make ten? Then let your kid finish." | ElevenLabs, Narrator | vo/line10.mp3 | todo |
| 55-56 s | Worksheet line again, blank filled: `8 + 6 = 14` (loops to frame one) | Manim: MD-007.py `WorksheetFilled` | math/WorksheetFilled.mp4 | preview rendered |
| whole | Word timings for captions | Whisper word timestamps on the final VO, or ElevenLabs alignment | vo/narrator.timings.json | todo |
| whole | Captions `.ass` + `.srt`; display map e.g. `{"eight plus six": "8 + 6", "eight plus two makes ten": "8 + 2 = 10", "ten plus four is fourteen": "10 + 4 = 14", "one question": "one question"}` | `marketing/production/captions.py --treatment ... --speaker Narrator` | captions/MD-007.ass, captions/MD-007.srt | todo |
| whole | Corner mark `playmathdragons.com`, top-left, cream 70 % | Kdenlive title | (in project) | todo |
| whole | Music bed under VO | Game track `assets/audio/music/dragon_eggs.ogg` | music/dragon_eggs.ogg | todo |
| whole | Master export, about -14 LUFS | Kdenlive (H.264, 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz) | renders/MD-007_master.mp4 | todo |

Music: `assets/audio/music/dragon_eggs.ogg`; SFX `assets/audio/sfx/correct.wav`.
Cover frame: 21-26 s (full chain card with "Make a ten?" text), or 0-4 s with the worksheet line.
