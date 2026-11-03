# MD-006: production plan

Is zero even? (Dragon Puzzle part 2, the answer, F1). 30 s, 1080 × 1920, 30 fps. Treatment: `treatment.md`. Media root: `~/Videos/math-dragons/MD-006/` (paths below are relative to it).

- **Math cards:** `marketing/production/manim/MD-006.py`, reusing MD-004's puzzle and rule cards exactly (`zero_puzzle.py`). Previews in `math/preview/`; masters via `render.py MD-006 -q h` into `math/`.
- **Gameplay:** none (no app tie-in), so nothing to capture on build 1.0.4 (9). **Hands:** none.
- **Tallyclaw:** optional unimpressed still with a text card at 28-30 s; cut it if the still isn't approved, and hold the rule card instead.

| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-3 s | MD-004 puzzle card; `NEITHER?` turns fire orange | Manim: MD-006.py `NeitherTempting` | math/NeitherTempting.mp4 | preview rendered |
| 0-3 s | Text: "Parents: the answer / A very common answer: neither" | Kdenlive title | (in project) | todo |
| 0-3 s | VO line 1: "Parents, a very common answer is neither." | ElevenLabs, Narrator | vo/line01.mp3 | todo |
| 3-9 s | The 0 dims to an empty plate, then back to 0 | Manim: MD-006.py `ZeroFeelsNothing` (simple vector plate; swap for a style-bible plate illustration if preferred) | math/ZeroFeelsNothing.mp4 | preview rendered |
| 3-9 s | Text: "Zero feels like nothing" | Kdenlive title | (in project) | todo |
| 3-9 s | VO line 2: "Zero feels like nothing, and nothing doesn't seem like it could be even or odd." | ElevenLabs, Narrator | vo/line02.mp3 | todo |
| 9-16 s | `NEITHER?` struck; `EVEN` glows emerald; two empty groups; `0 = 0 + 0`; `0 ÷ 2 = 0`, `remainder 0` | Manim: MD-006.py `ZeroIsEven` | math/ZeroIsEven.mp4 | preview rendered |
| 9-16 s | Text: "0 is even / 0 = 0 + 0" | Kdenlive title | (in project) | todo |
| 9-16 s | SFX: correct chime when EVEN glows | Game SFX `assets/audio/sfx/correct.wav` | music/correct.wav | todo |
| 9-16 s | VO line 3: "But zero is even. Split zero into two equal groups: zero and zero. None left over." | ElevenLabs, Narrator | vo/line03.mp3 | todo |
| 16-22 s | `6, 4, 2, 0` one at a time onto gold even ticks of a number line | Manim: MD-006.py `CountDownByTwos` | math/CountDownByTwos.mp4 | preview rendered |
| 16-22 s | VO line 4: "Count down by twos: six, four, two, zero. Zero lands right where the evens go." | ElevenLabs, Narrator | vo/line04.mp3 | todo |
| 22-28 s | MD-004 rule card with a gold check next to 0 (`Even = 2 equal groups, none left over`) | Manim: MD-006.py `RuleCheck` | math/RuleCheck.mp4 | preview rendered |
| 22-28 s | VO line 5: "So the rule your kid learned still works: two equal groups, none left over. Zero passes." | ElevenLabs, Narrator | vo/line05.mp3 | todo |
| 28-30 s | Optional: Tallyclaw still + card "Tallyclaw: "Zero. Even. Next question."" (no VO, held 2 s or more); if cut, hold RuleCheck's last frame | Tallyclaw still: `unimpressed`; Kdenlive title | art/tallyclaw_unimpressed.png | todo (poses being generated) |
| whole | Word timings for captions | Whisper word timestamps on the final VO, or ElevenLabs alignment | vo/narrator.timings.json | todo |
| whole | Captions `.ass` + `.srt`; display map `{"zero and zero": "0 and 0"}` optional (numbers become digits automatically: "six, four, two, zero" shows `6, 4, 2, 0`) | `marketing/production/captions.py --treatment ... --speaker Narrator` | captions/MD-006.ass, captions/MD-006.srt | todo |
| whole | Corner mark `playmathdragons.com`, top-left, cream 70 % | Kdenlive title | (in project) | todo |
| whole | Music bed | Game track `assets/audio/music/hub_theme.ogg` (same as part 1) | music/hub_theme.ogg | todo |
| whole | Master export, about -14 LUFS | Kdenlive (H.264, 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz) | renders/MD-006_master.mp4 | todo |

Music: `assets/audio/music/hub_theme.ogg`; SFX `assets/audio/sfx/correct.wav`.
Cover frame: 9-16 s ("NEITHER?" crossed out and "0 is even" visible).
After upload: switch MD-004's YouTube related video to MD-006.
