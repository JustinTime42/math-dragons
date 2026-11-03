# MD-005: production plan

Fingers aren't cheating (F5, Narrator + still Tallyclaw text card). 44 s, 1080 × 1920, 30 fps. Treatment: `treatment.md`. Media root: `~/Videos/math-dragons/MD-005/` (paths below are relative to it).

- **No real child, ever:** the small hands are illustration only; Justin's overhead hands only in 4-10 s, nothing identifying.
- **Gameplay:** none (no app mention), so nothing to capture on build 1.0.4 (9).
- **Math strings** (`Counting on fingers at 5 or 6?`, `328 kids, ages 5-6`, `6 short lessons, 2 weeks`, `37% → 77%`, `40% → 48%`, `3 years`) are rendered by a Manim script that doesn't exist yet: `marketing/production/manim/MD-005.py` (to write, same self-check pattern as MD-004; bars driven by the same numbers as the labels).
- **The two studies stay visibly separate:** different card backgrounds and a hard cut at 29 s.

| Beat (time) | Asset | Source | File | Status |
|---|---|---|---|---|
| 0-4 s | Small cartoon hands counting (no face, no real child) on dark purple | Illustration: style-bible image, no text | art/kid_hands.png | todo |
| 0-4 s | Text: `Counting on fingers at 5 or 6?` | Manim: MD-005.py `HookText` (to write) | math/HookText.mov | todo |
| 0-4 s | VO line 1: "Parents, if your five- or six-year-old counts on their fingers, good." | ElevenLabs, Narrator | vo/line01.mp3 | todo |
| 4-10 s | Justin's hands, overhead, mime "show me how" next to a paper with 3 + 4 | Hands footage (phone, overhead, purple cloth, no rings) | hands/show_me_how.mp4 | todo |
| 4-10 s | Text: "Tonight: let them count / Ask how they got it" | Kdenlive title | (in project) | todo |
| 4-10 s | VO line 2: "Don't ask them to stop. Let them count, then ask how they got it." | ElevenLabs, Narrator | vo/line02.mp3 | todo |
| 10-17 s | Flat map of France; classroom as dragon-world tables (no people); callout "One study, France / `328 kids, ages 5-6` / `6 short lessons, 2 weeks`" | Illustration (no text) + Manim: MD-005.py `StudyOne` (to write) | art/france_map.png, math/StudyOne.mp4 | todo |
| 10-17 s | VO line 3: "In one study in France, teachers gave five- and six-year-olds six short finger-counting lessons over two weeks." | ElevenLabs, Narrator | vo/line03.mp3 | todo |
| 17-24 s | Bar grows 37 % to 77 % in emerald, label "Kids not using fingers yet: `37% → 77%`" | Manim: MD-005.py `BarLessons` (to write) | math/BarLessons.mp4 | todo |
| 17-24 s | VO line 4: "Kids who weren't using their fingers before went from about thirty-seven percent right on addition to seventy-seven." | ElevenLabs, Narrator | vo/line04.mp3 | todo |
| 24-29 s | Second bar 40 % to 48 % in cream beside the first, "No lessons: `40% → 48%`" | Manim: MD-005.py `BarControl` (to write) | math/BarControl.mp4 | todo |
| 24-29 s | VO line 5: "Similar kids without the lessons went from about forty to forty-eight." | ElevenLabs, Narrator | vo/line05.mp3 | todo |
| 29-38 s | Hard cut, new card: three-year timeline, fingers icon appears early and fades; "A second study / `3 years` / Used fingers, then stopped: did best" | Manim: MD-005.py `StudyTwo` (to write) | math/StudyTwo.mp4 | todo |
| 29-38 s | VO line 6: "A second study followed kids for three years. It suggests the ones who used fingers early, then stopped, did best at addition." | ElevenLabs, Narrator | vo/line06.mp3 | todo |
| 38-41 s | Tallyclaw still to one side, text card "Fingers aren't cheating. They're tools." (held 3 s, no VO) | Tallyclaw still: `pointing`; Kdenlive title | art/tallyclaw_pointing.png | todo (poses being generated) |
| 41-44 s + loop | Illustrated hands from frame one; recap "Let them count. Ask how." | art/kid_hands.png + Kdenlive title | (in project) | todo |
| 41-44 s | VO line 7: "So tonight: let them count. Ask how." | ElevenLabs, Narrator | vo/line07.mp3 | todo |
| whole | Word timings for captions | Whisper word timestamps on the final VO, or ElevenLabs alignment | vo/narrator.timings.json | todo |
| whole | Captions `.ass` + `.srt`; display map `{"thirty-seven percent": "37%"}` etc. so captions read as the cards do | `marketing/production/captions.py --treatment ... --speaker Narrator` | captions/MD-005.ass, captions/MD-005.srt | todo |
| whole | Corner mark `playmathdragons.com`, top-left, cream 70 % | Kdenlive title | (in project) | todo |
| whole | Music bed, calm, under VO | Game track `assets/audio/music/hub_theme.ogg` | music/hub_theme.ogg | todo |
| whole | Master export, about -14 LUFS | Kdenlive (H.264, 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz) | renders/MD-005_master.mp4 | todo |

Music: `assets/audio/music/hub_theme.ogg`.
Cover frame: 17-24 s ("37% → 77%" bar with "Kids not using fingers yet"), or 0-4 s with the hook text.
