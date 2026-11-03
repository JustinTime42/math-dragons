#!/usr/bin/env python3
"""Burned-in captions (.ass) and an upload caption file (.srt) from aligned VO.

Pipeline step 8 (production-pipeline.md §3); style per visual-style.md §5.

Input
  * the script text: either a plain text file (--script) or the treatment
    (--treatment, VO lines for one --speaker pulled from the Script table);
  * word timestamps (--timings) in one of two shapes, detected automatically:
      - Whisper: openai-whisper `{"segments": [{"words": [{"word", "start", "end"}]}]}`
        or the OpenAI API verbose_json `{"words": [{"word", "start", "end"}]}`;
      - ElevenLabs character alignment: `{"alignment": {"characters": [...],
        "character_start_times_seconds": [...], "character_end_times_seconds": [...]}}`
        (or the bare alignment object, or `normalized_alignment`), grouped into words.

Check
  The aligned words must match the script word for word (case, punctuation,
  hyphens and number spelling normalised: Whisper writing "63" for
  "sixty-three" or "1896" for "eighteen ninety-six" is accepted). Anything else
  raises AlignmentMismatch with the position and both texts, and the CLI exits 2.

Output
  * .ass: 1080 x 1920, Nunito Bold, cream text on a Deep Void outline, 2-4 words
    per line, the current word in gold, centred at 60 % of frame height (the
    lower-middle of the safe area). Burn it with
        ffmpeg -i in.mp4 -vf "subtitles=out.ass:fontsdir=assets/fonts" ...
  * .srt: the same lines, plain text.

  Numbers display as digits and symbols: spelled-out numbers become digits
  automatically ("sixty-three" -> "63", "nineteen thirty-five" -> "1935"), and a
  --display JSON file maps whole spoken phrases to the treatment's math strings,
  e.g. {"nine times seven": "9 × 7", "times one": "× 1"}. A display phrase is
  shown as one unit and highlighted while any of its words is spoken.

Example
  python captions.py --treatment ../videos/MD-009/treatment.md --speaker Narrator \\
      --timings ~/Videos/math-dragons/MD-009/vo/narrator.whisper.json \\
      --display manim/../captions/MD-009.display.json \\
      --out ~/Videos/math-dragons/MD-009/captions/MD-009
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path

# ---------------------------------------------------------------------------
# Style (visual-style.md §3, §5)
# ---------------------------------------------------------------------------
PLAY_RES_X, PLAY_RES_Y = 1080, 1920
CAPTION_Y = int(PLAY_RES_Y * 0.60)  # centre of the 55-65 % band
FONT = "Nunito"
FONT_SIZE = 76
MAX_WORDS, MIN_WORDS = 4, 2
MAX_CHARS = 22  # keeps a 4-word line inside the 950 px safe width at FONT_SIZE
PAUSE_BREAK_S = 0.6  # a gap this long between words starts a new line


def ass_color(hex_rgb: str, alpha: int = 0) -> str:
    """'#RRGGBB' -> ASS '&HAABBGGRR'."""
    h = hex_rgb.lstrip("#")
    r, g, b = h[0:2], h[2:4], h[4:6]
    return f"&H{alpha:02X}{b}{g}{r}".upper()


CREAM = ass_color("#F0E6D3")
GOLD = ass_color("#F4A261")
OUTLINE = ass_color("#1A0F3D")  # Deep Void
SHADOW = ass_color("#1A0F3D", alpha=0x60)


class AlignmentMismatch(Exception):
    """The aligned (heard) words don't match the script."""


# ---------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------
@dataclass
class Timed:
    text: str
    start: float
    end: float


@dataclass
class Word:
    text: str  # as written in the script, punctuation included
    start: float = 0.0
    end: float = 0.0


@dataclass
class Unit:
    """One display token (a word, or a phrase mapped to a math string)."""

    display: str
    words: list[Word] = field(default_factory=list)
    ends_sentence: bool = False

    @property
    def start(self) -> float:
        return self.words[0].start

    @property
    def end(self) -> float:
        return self.words[-1].end


# ---------------------------------------------------------------------------
# Loading timings
# ---------------------------------------------------------------------------
def load_timings(data) -> list[Timed]:
    if isinstance(data, dict) and ("alignment" in data or "normalized_alignment" in data):
        data = data.get("alignment") or data["normalized_alignment"]
    if isinstance(data, dict) and "characters" in data:
        return group_characters(
            data["characters"], data["character_start_times_seconds"], data["character_end_times_seconds"]
        )
    if isinstance(data, dict) and "segments" in data and "words" not in data:
        words = [w for seg in data["segments"] for w in seg.get("words", [])]
        if not words:
            raise ValueError("Whisper JSON has no word timestamps (run with word_timestamps=True)")
        data = {"words": words}
    if isinstance(data, dict) and "words" in data:
        return [Timed(w["word"].strip(), float(w["start"]), float(w["end"])) for w in data["words"] if w["word"].strip()]
    raise ValueError("unrecognised timings JSON (expected Whisper words or ElevenLabs alignment)")


def group_characters(chars, starts, ends) -> list[Timed]:
    if not (len(chars) == len(starts) == len(ends)):
        raise ValueError("ElevenLabs alignment arrays differ in length")
    out, buf, s0, e0 = [], "", None, None
    for c, s, e in zip(chars, starts, ends):
        if c.isspace():
            if buf:
                out.append(Timed(buf, s0, e0))
            buf, s0 = "", None
            continue
        if s0 is None:
            s0 = float(s)
        buf += c
        e0 = float(e)
    if buf:
        out.append(Timed(buf, s0, e0))
    return out


# ---------------------------------------------------------------------------
# Script text
# ---------------------------------------------------------------------------
def script_from_treatment(path: Path, speaker: str) -> str:
    text = path.read_text(encoding="utf-8")
    m = re.search(r"^## Script\s*$(.*?)^## ", text, flags=re.S | re.M)
    if not m:
        raise ValueError(f"{path}: no '## Script' section")
    lines = []
    for row in m.group(1).splitlines():
        if not row.startswith("|") or set(row) <= set("|- "):
            continue
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        vo = cells[-1]
        prefix = f"{speaker}:"
        if not vo.startswith(prefix):
            continue
        line = vo[len(prefix):].strip()
        if len(line) >= 2 and line[0] == line[-1] == '"':
            line = line[1:-1]
        lines.append(line)
    if not lines:
        raise ValueError(f"{path}: no VO lines for speaker {speaker!r}")
    return " ".join(lines)


def script_words(text: str) -> list[Word]:
    return [Word(w) for w in text.split()]


# ---------------------------------------------------------------------------
# Normalisation and number words
# ---------------------------------------------------------------------------
ONES = "zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen".split()
TENS = "_ _ twenty thirty forty fifty sixty seventy eighty ninety".split()
NUM_VALUE = {w: i for i, w in enumerate(ONES)} | {w: 10 * i for i, w in enumerate(TENS) if w != "_"}
SCALE = {"hundred": 100, "thousand": 1000}


def norm_atoms(token: str) -> list[str]:
    """Lowercase, unify apostrophes, drop punctuation, split hyphens."""
    t = unicodedata.normalize("NFKC", token).lower().replace("’", "'").replace("‘", "'")
    t = t.replace("−", "-").replace("–", "-")
    t = re.sub(r"[^\w'%\-]", "", t)
    parts = [p.strip("'") for p in re.split(r"-", t)]
    return [p for p in parts if p]


def cardinal_words(n: int) -> list[str]:
    if n < 20:
        return [ONES[n]]
    if n < 100:
        t, o = divmod(n, 10)
        return [TENS[t]] + ([ONES[o]] if o else [])
    if n < 1000:
        h, r = divmod(n, 100)
        return [ONES[h], "hundred"] + (cardinal_words(r) if r else [])
    if n < 1_000_000:
        th, r = divmod(n, 1000)
        return cardinal_words(th) + ["thousand"] + (cardinal_words(r) if r else [])
    raise ValueError(n)


def number_readings(n: int) -> list[list[str]]:
    """Ways a digit string may have been spoken (cardinal, 'and', year style)."""
    out = [cardinal_words(n)]
    if 100 < n < 1000 and n % 100:
        h, r = divmod(n, 100)
        out.append([ONES[h], "hundred", "and"] + cardinal_words(r))
    if 1000 <= n <= 2099:
        hi, lo = divmod(n, 100)
        if lo == 0:
            out.append(cardinal_words(hi) + ["hundred"])
        elif lo < 10:
            out.append(cardinal_words(hi) + ["oh"] + cardinal_words(lo))
        else:
            out.append(cardinal_words(hi) + cardinal_words(lo))
    return out


def heard_readings(token: str) -> list[list[str]]:
    """Candidate atom sequences for one heard (ASR) token."""
    atoms = norm_atoms(token)
    if len(atoms) == 1:
        m = re.fullmatch(r"(\d+)(%?)", atoms[0].replace(",", ""))
        if m:
            pct = ["percent"] if m.group(2) else []
            return [r + pct for r in number_readings(int(m.group(1)))]
    return [atoms]


# ---------------------------------------------------------------------------
# Alignment
# ---------------------------------------------------------------------------
def align(words: list[Word], heard: list[Timed]) -> list[Word]:
    """Give each script word a time from the heard words, or raise."""
    script_atoms: list[tuple[str, int]] = []
    for wi, w in enumerate(words):
        for a in norm_atoms(w.text):
            script_atoms.append((a, wi))
    atom_times: list[tuple[float, float]] = []
    pos = 0
    for hi, h in enumerate(heard):
        target = [a for a, _ in script_atoms[pos:]]
        for reading in heard_readings(h.text):
            if target[: len(reading)] == reading and reading:
                n = len(reading)
                span = (h.end - h.start) / n
                atom_times += [(h.start + k * span, h.start + (k + 1) * span) for k in range(n)]
                pos += n
                break
        else:
            raise AlignmentMismatch(_mismatch_message(words, heard, script_atoms, pos, hi))
    if pos != len(script_atoms):
        raise AlignmentMismatch(
            "audio ended early: script continues with "
            + repr(" ".join(w.text for w in words[script_atoms[pos][1]:][:8]))
        )
    for wi, w in enumerate(words):
        idx = [k for k, (_, owner) in enumerate(script_atoms) if owner == wi]
        if not idx:
            raise AlignmentMismatch(f"script word {w.text!r} has no letters or digits")
        w.start, w.end = atom_times[idx[0]][0], atom_times[idx[-1]][1]
    return words


def _mismatch_message(words, heard, script_atoms, pos, hi) -> str:
    wi = script_atoms[pos][1] if pos < len(script_atoms) else len(words)
    expected = " ".join(w.text for w in words[max(0, wi - 3): wi + 5]) or "(end of script)"
    got = " ".join(h.text for h in heard[max(0, hi - 3): hi + 5])
    return (
        f"aligned words don't match the script at script word {wi + 1}, heard word {hi + 1} "
        f"({heard[hi].start:.2f} s):\n  script: ...{expected}...\n  heard:  ...{got}...\n"
        "Fix the VO take or the script (re-generate or re-align); never edit captions by hand."
    )


# ---------------------------------------------------------------------------
# Display units
# ---------------------------------------------------------------------------
def _key(text: str) -> str:
    return " ".join(a for tok in text.split() for a in norm_atoms(tok))


def build_units(words: list[Word], display: dict[str, str] | None = None, auto_numbers: bool = True) -> list[Unit]:
    phrases = sorted(((tuple(_key(k).split()), v) for k, v in (display or {}).items()), key=lambda kv: -len(kv[0]))
    keys = [_key(w.text) for w in words]
    units: list[Unit] = []
    i = 0
    while i < len(words):
        # 1. Explicit phrase map (longest first; a phrase must cover whole words).
        hit = None
        for ph, shown in phrases:
            atoms: list[str] = []
            n = 0
            while i + n < len(words) and len(atoms) < len(ph):
                atoms += keys[i + n].split()
                n += 1
            if ph and atoms == list(ph):
                hit = (n, shown)
                break
        if hit:
            n, shown = hit
            grp = words[i:i + n]
            units.append(Unit(shown + _trailing_punct(grp[-1].text), grp, _ends_sentence(grp[-1].text)))
            i += n
            continue
        # 2. Spelled-out numbers -> digits.
        if auto_numbers:
            n, value = _parse_number(keys, i, [w.text for w in words])
            if n:
                grp = words[i:i + n]
                units.append(Unit(str(value) + _trailing_punct(grp[-1].text), grp, _ends_sentence(grp[-1].text)))
                i += n
                continue
        units.append(Unit(words[i].text, [words[i]], _ends_sentence(words[i].text)))
        i += 1
    return units


def _trailing_punct(text: str) -> str:
    m = re.search(r"[.,!?;:]+[\"”']?$", text)
    return m.group(0) if m else ""


def _ends_sentence(text: str) -> bool:
    return bool(re.search(r"[.!?:;][\"”']?$", text))


def _parse_number(keys: list[str], i: int, words_text: list[str]) -> tuple[int, int]:
    """Longest run of number words at i -> (words used, value); (0, 0) if none.

    Handles cardinals ("sixty-three", "one hundred") and year style
    ("eighteen ninety-six" -> 1896, "nineteen hundred" -> 1900). A number word
    followed by punctuation ("six, four") ends the run.
    """
    atoms: list[tuple[str, int]] = []
    j = i
    while j < len(keys):
        parts = keys[j].split()
        if not parts or not all(p in NUM_VALUE or p in SCALE for p in parts):
            break
        atoms += [(p, j) for p in parts]
        j += 1
        if _trailing_punct(words_text[j - 1]):
            break
    if not atoms:
        return 0, 0
    best = (0, 0)
    for end_word in range(i, j):
        seq = [a for a, w in atoms if w <= end_word]
        value = _value(seq)
        if value is not None:
            best = (end_word - i + 1, value)
    return best


def _value(seq: list[str]) -> int | None:
    # Year style: two 2-digit groups, e.g. eighteen | ninety six.
    for cut in range(1, len(seq)):
        a, b = _cardinal(seq[:cut]), _cardinal(seq[cut:])
        if a is not None and b is not None and 10 <= a <= 20 and 10 <= b <= 99 and "hundred" not in seq:
            return a * 100 + b
    return _cardinal(seq)


def _cardinal(seq: list[str]) -> int | None:
    total, cur, last = 0, 0, None
    for p in seq:
        if p in SCALE:
            if cur == 0:
                return None
            cur *= SCALE[p]
            if SCALE[p] >= 1000:
                total, cur = total + cur, 0
            last = "scale"
            continue
        v = NUM_VALUE[p]
        if last == "ones" or (last == "tens" and v >= 10) or (last == "teen"):
            return None  # "six three", "sixty forty": not one number
        cur += v
        last = "tens" if v >= 20 else ("teen" if v >= 10 else "ones")
    return total + cur


# ---------------------------------------------------------------------------
# Lines
# ---------------------------------------------------------------------------
def _width(units: list[Unit]) -> int:
    return len(" ".join(u.display for u in units))


def build_lines(units: list[Unit]) -> list[list[Unit]]:
    """Sentence-aware 2-4 word lines.

    Units are cut into phrases at sentence punctuation and at pauses longer
    than PAUSE_BREAK_S; each phrase is then split into the fewest balanced
    lines that respect MAX_WORDS and MAX_CHARS. A one-word sentence ("63.")
    stays on its own line rather than joining an unrelated sentence.
    """
    phrases: list[list[Unit]] = []
    cur: list[Unit] = []
    for u in units:
        if cur and u.start - cur[-1].end > PAUSE_BREAK_S:
            phrases.append(cur)
            cur = []
        cur.append(u)
        if u.ends_sentence:
            phrases.append(cur)
            cur = []
    if cur:
        phrases.append(cur)

    lines: list[list[Unit]] = []
    for ph in phrases:
        k = -(-len(ph) // MAX_WORDS)  # ceil
        while True:
            size, extra = divmod(len(ph), k)
            chunks, i = [], 0
            for c in range(k):
                n = size + (1 if c < extra else 0)
                chunks.append(ph[i:i + n])
                i += n
            if all(_width(c) <= MAX_CHARS or len(c) == 1 for c in chunks) or k >= len(ph):
                break
            k += 1
        lines.extend(chunks)
    return lines


# ---------------------------------------------------------------------------
# Writers
# ---------------------------------------------------------------------------
def _ts_ass(t: float) -> str:
    cs = int(round(t * 100))
    h, cs = divmod(cs, 360000)
    m, cs = divmod(cs, 6000)
    s, cs = divmod(cs, 100)
    return f"{h}:{m:02d}:{s:02d}.{cs:02d}"


def _ts_srt(t: float) -> str:
    ms = int(round(t * 1000))
    h, ms = divmod(ms, 3600000)
    m, ms = divmod(ms, 60000)
    s, ms = divmod(ms, 1000)
    return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"


def _ass_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace("{", "(").replace("}", ")")


HOLD_AFTER_S = 0.4  # how long a line stays after its last word (if no line follows sooner)


def line_spans(lines: list[list[Unit]]) -> list[tuple[float, float]]:
    spans = []
    for k, ln in enumerate(lines):
        end = ln[-1].end + HOLD_AFTER_S
        if k + 1 < len(lines):
            end = min(end, lines[k + 1][0].start)
        spans.append((ln[0].start, max(end, ln[-1].end)))
    return spans


def to_ass(lines: list[list[Unit]]) -> str:
    head = f"""[Script Info]
ScriptType: v4.00+
PlayResX: {PLAY_RES_X}
PlayResY: {PLAY_RES_Y}
WrapStyle: 2
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: MD,{FONT},{FONT_SIZE},{CREAM},{GOLD},{OUTLINE},{SHADOW},-1,0,0,0,100,100,0,0,1,7,3,5,65,65,0,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
"""
    events = []
    pos = f"{{\\an5\\pos({PLAY_RES_X // 2},{CAPTION_Y})}}"
    for ln, (l_start, l_end) in zip(lines, line_spans(lines)):
        for k, u in enumerate(ln):
            seg_start = l_start if k == 0 else u.start
            seg_end = ln[k + 1].start if k + 1 < len(ln) else l_end
            if seg_end <= seg_start:
                continue
            parts = []
            for j, v in enumerate(ln):
                txt = _ass_escape(v.display)
                parts.append(f"{{\\c{GOLD}}}{txt}{{\\c{CREAM}}}" if j == k else txt)
            events.append(f"Dialogue: 0,{_ts_ass(seg_start)},{_ts_ass(seg_end)},MD,,0,0,0,,{pos}{' '.join(parts)}")
    return head + "\n".join(events) + "\n"


def to_srt(lines: list[list[Unit]]) -> str:
    out = []
    for n, (ln, (s, e)) in enumerate(zip(lines, line_spans(lines)), start=1):
        out.append(f"{n}\n{_ts_srt(s)} --> {_ts_srt(e)}\n{' '.join(u.display for u in ln)}\n")
    return "\n".join(out)


# ---------------------------------------------------------------------------
# API + CLI
# ---------------------------------------------------------------------------
def make_captions(script_text: str, timings_json, display: dict[str, str] | None = None,
                  auto_numbers: bool = True) -> tuple[str, str, list[list[Unit]]]:
    words = align(script_words(script_text), load_timings(timings_json))
    lines = build_lines(build_units(words, display, auto_numbers))
    return to_ass(lines), to_srt(lines), lines


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    src = ap.add_mutually_exclusive_group(required=True)
    src.add_argument("--script", type=Path, help="plain text file with the VO words")
    src.add_argument("--treatment", type=Path, help="treatment.md; VO lines taken from its Script table")
    ap.add_argument("--speaker", default="Narrator", help="speaker whose lines to take from the treatment")
    ap.add_argument("--timings", type=Path, required=True, help="Whisper or ElevenLabs alignment JSON")
    ap.add_argument("--display", type=Path, help="JSON map of spoken phrase -> on-screen text")
    ap.add_argument("--no-auto-numbers", action="store_true", help="don't turn number words into digits")
    ap.add_argument("--out", type=Path, required=True, help="output path stem (writes .ass and .srt)")
    args = ap.parse_args(argv)

    text = args.script.read_text(encoding="utf-8") if args.script else script_from_treatment(args.treatment, args.speaker)
    timings = json.loads(args.timings.read_text(encoding="utf-8"))
    display = json.loads(args.display.read_text(encoding="utf-8")) if args.display else None
    try:
        ass, srt, lines = make_captions(text, timings, display, not args.no_auto_numbers)
    except AlignmentMismatch as e:
        print(f"CAPTIONS FAILED: {e}", file=sys.stderr)
        return 2
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.with_suffix(".ass").write_text(ass, encoding="utf-8")
    args.out.with_suffix(".srt").write_text(srt, encoding="utf-8")
    print(f"{len(lines)} caption lines -> {args.out.with_suffix('.ass')} and .srt")
    for ln in lines:
        print("  " + " ".join(u.display for u in ln))
    return 0


if __name__ == "__main__":
    sys.exit(main())
