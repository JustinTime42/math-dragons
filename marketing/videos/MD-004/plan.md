# MD-004: production plan

Is zero even? (Dragon Puzzle part 1, F1). 18 s, 1080 × 1920, 30 fps. Treatment: `treatment.md`. Media root: `~/Videos/math-dragons/MD-004/` (paths below are relative to it).

- **Math cards:** `marketing/production/manim/MD-004.py` (puzzle and rule cards shared with MD-006 via `zero_puzzle.py`). Previews in `math/preview/`; masters via `render.py MD-004 -q h` into `math/`.
- **Gameplay:** none (no app tie-in: Dragon's Feast's "even" category starts at 1), so nothing to capture on build 1.0.4 (9).
- **Tallyclaw:** none (part 1 is Narrator only per F1). **Hands:** none.

| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-5 s | Puzzle card: `0` centred, `EVEN` left, `ODD` right, `NEITHER?` below, each pulses as spoken | Manim: MD-004.py `PuzzleCard` | math/PuzzleCard.mp4 | preview rendered |
| 0-5 s | Text: "Parents: is 0 even, odd, or neither?" | Kdenlive title (Nunito Bold, cream), top of safe area | (in project) | todo |
| 0-5 s | VO line 1: "Parents, is zero even, odd, or neither? Ask your kid. Then ask yourself." | ElevenLabs, Narrator | vo/line01.mp3 | todo |
| 5-13 s | Rule card: six dots as `3 + 3`, label `6 = 3 + 3`, `Even = 2 equal groups, none left over`, then the 0 returns | Manim: MD-004.py `RuleCard` | math/RuleCard.mp4 | preview rendered |
| 5-13 s | VO line 2: "Use the usual rule: a number is even if it splits into two equal groups, with none left over." | ElevenLabs, Narrator | vo/line02.mp3 | todo |
| 13-16 s | Thinking beat: the 0 alone, a fire bar burns down (no numbers, no countdown voice) | Manim: MD-004.py `ThinkingBeat` | math/ThinkingBeat.mp4 | preview rendered |
| 13-16 s | Silence, music only | (no VO) | n/a | n/a |
| 16-18 s | Opening frame exactly (loop) | Manim: MD-004.py `LoopCard` | math/LoopCard.mp4 | preview rendered |
| 16-18 s | Text: "Answer in part two" | Kdenlive title | (in project) | todo |
| 16-18 s | VO line 3: "Answer in part two." | ElevenLabs, Narrator | vo/line03.mp3 | todo |
| whole | Word timings for captions | Whisper word timestamps on the final VO, or ElevenLabs alignment | vo/narrator.timings.json | todo |
| whole | Captions `.ass` + `.srt` ("zero" displays as `0` automatically) | `marketing/production/captions.py --treatment ... --speaker Narrator` | captions/MD-004.ass, captions/MD-004.srt | todo |
| whole | Corner mark `playmathdragons.com`, top-left, cream 70 % | Kdenlive title | (in project) | todo |
| whole | Music bed (carries the 3 s silence) | Game track `assets/audio/music/hub_theme.ogg`, low | music/hub_theme.ogg | todo |
| whole | Master export, about -14 LUFS | Kdenlive (H.264, 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz) | renders/MD-004_master.mp4 | todo |

Music: `assets/audio/music/hub_theme.ogg` (not `dragons_feast.ogg`, so nothing hints at Dragon's Feast).
Cover frame: 0-1 s (the 0 with EVEN / ODD / NEITHER? and the "Parents:" text).
