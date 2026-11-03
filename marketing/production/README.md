# marketing/production

Phase A tooling for the video channel (`marketing/guides/production-pipeline.md` §3). Code and plans live here; **media never goes in git**: everything renders to `~/Videos/math-dragons/MD-###/` (`vo/`, `gameplay/`, `math/`, `art/`, `music/`, `renders/`, plus `captions/`).

| Path | What |
|---|---|
| `manim/md_style.py` | Shared style: palette, Nunito/Cinzel, 1080 × 1920 frame, safe zones, glow/strike helpers, self-check helpers |
| `manim/MD-0NN.py` | Math cards for one video (MD-004, 006, 007, 009, 012), one Manim scene per beat |
| `manim/zero_puzzle.py` | Puzzle and rule cards shared by MD-004 and MD-006 |
| `manim/render.py` | Renders a video's scenes into `~/Videos/math-dragons/MD-###/math/` |
| `captions.py` | Aligned VO words to burned-in `.ass` + upload `.srt` |
| `voices.md` | The two locked ElevenLabs voices (fill in once) |
| `tallyclaw/` | Tallyclaw still poses (generated separately) |
| `tests/` | `pytest` for captions and the math-card self-checks |

## Setup (one time)

The virtualenv is `marketing/production/.venv` (git-ignored), Python 3.14, packages pinned in `requirements.txt` (Manim Community 0.22.1). Manim needs Cairo and Pango headers to build `pycairo` and `manimpango` (neither ships Linux wheels):

```bash
sudo dnf install cairo-devel pango-devel python3-devel   # Fedora; gcc, pkgconf, ffmpeg already present
python3 -m venv marketing/production/.venv
marketing/production/.venv/bin/pip install -r marketing/production/requirements.txt
```

No LaTeX is needed: all math is Manim `Text` in Nunito Bold, registered from `assets/fonts/` at import (it doesn't need to be installed system-wide).

## Math cards (Manim)

```bash
P=marketing/production/.venv/bin/python
$P marketing/production/manim/render.py MD-004            # previews: math/preview/<Scene>.mp4, 480x854
$P marketing/production/manim/render.py MD-004 -q h       # masters:  math/<Scene>.mp4, 1080x1920 @ 30 fps
$P marketing/production/manim/render.py MD-004 --guides   # safe-zone + caption-band guides, math/preview/guides/
$P marketing/production/manim/render.py MD-009 -s SplitSevenOverlay   # one scene
```

- Each script's docstring maps beats to scene names; `plan.md` maps them to files.
- Scenes derived from `MDOverlayScene` (MD-009's finger overlays) render with a transparent background as `.mov` (ProRes 4444 + alpha) to lay over hands footage in Kdenlive.
- **Self-check:** importing a script asserts that every string it renders appears verbatim in the treatment's `## Math strings` section and recomputes every equation (`check_equation` evaluates each side of `a = b = c` with exact fractions). A treatment edit that changes a string stops the render until the script is updated to match. Don't loosen a check to get a render through; fix the string or the treatment.
- Style rules encoded: numbers cream, operators and equals gold, correct answers as an emerald glow behind cream text, wrong answers fire orange then struck through, Deep Void → Dragon Purple background, math kept above the caption band (55-65 % of frame height) and inside the safe zone (x 65-1015, y 270-1250).
- Glyph-level colouring maps string characters to glyphs, so ligatures are off (`fi` would otherwise merge) and a glyph-count mismatch raises.
- The corner mark (`playmathdragons.com`) and text callouts that aren't math strings are added once in Kdenlive, not in the cards.

## Captions

1. Generate the VO (ElevenLabs, with timestamps) or transcribe the final take with Whisper with word timestamps, e.g. `whisper vo.mp3 --word_timestamps True --output_format json`.
2. Optional display map (`~/Videos/math-dragons/MD-###/captions/display.json`): spoken phrase to the treatment's on-screen math, e.g. `{"nine times seven": "9 × 7", "times one": "× 1"}`. Spelled-out numbers become digits automatically ("sixty-three" → `63`, "nineteen thirty-five" → `1935`); map a phrase to itself to keep words (`{"one question": "one question"}`).
3. Run:

```bash
P=marketing/production/.venv/bin/python
$P marketing/production/captions.py --treatment marketing/videos/MD-009/treatment.md --speaker Narrator \
   --timings ~/Videos/math-dragons/MD-009/vo/narrator.json \
   --display ~/Videos/math-dragons/MD-009/captions/display.json \
   --out ~/Videos/math-dragons/MD-009/captions/MD-009
# or --script vo.txt instead of --treatment
```

- Accepts Whisper JSON (`segments[].words[]` or top-level `words[]`) and ElevenLabs alignment JSON (`alignment` / `normalized_alignment` character arrays, grouped into words at spaces).
- **Fails loudly** (exit 2, nothing written) if the heard words don't match the script, showing both texts at the mismatch. Fix the take or the script and re-align; never hand-edit captions to cover a mismatch.
- Output: `.ass` (1080 × 1920, Nunito Bold 76, cream with a Deep Void outline, current word gold, centred at 60 % height, 2-4 words a line split at sentences and pauses) and `.srt` (same lines, for YouTube).
- Burn in: `ffmpeg -i master.mp4 -vf "subtitles=MD-009.ass:fontsdir=assets/fonts" -c:a copy out.mp4` (or import the `.ass` into Kdenlive).

## Tests

```bash
marketing/production/.venv/bin/python -m pytest marketing/production/tests
```

## Stage 4 plans

Each video's `marketing/videos/MD-###/plan.md` maps every treatment beat to an asset, its source, its file under `~/Videos/math-dragons/MD-###/` and a status.
