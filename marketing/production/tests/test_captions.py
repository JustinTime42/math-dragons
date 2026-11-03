"""captions.py: alignment check, number display, .ass/.srt output.

Run: marketing/production/.venv/bin/python -m pytest marketing/production/tests
"""

import copy
import json
import sys
from pathlib import Path

import pytest

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))

import captions  # noqa: E402

FIX = HERE / "fixtures"
SCRIPT = (FIX / "md009_script.txt").read_text(encoding="utf-8")
WHISPER = json.loads((FIX / "md009_whisper.json").read_text(encoding="utf-8"))
DISPLAY = json.loads((FIX / "md009_display.json").read_text(encoding="utf-8"))
ELEVEN = json.loads((FIX / "md003_elevenlabs.json").read_text(encoding="utf-8"))


def shown(lines):
    return [" ".join(u.display for u in ln) for ln in lines]


def test_whisper_digits_align_to_spelled_script_and_display_as_math():
    ass, srt, lines = captions.make_captions(SCRIPT, WHISPER, DISPLAY)
    text = shown(lines)
    assert "9 × 7," in " ".join(text)  # phrase map -> treatment math string
    assert text[-1].endswith("63.")  # "Sixty-three." -> digits automatically
    assert all(1 <= len(ln) <= captions.MAX_WORDS for ln in lines)
    assert sum(len(ln) >= 2 for ln in lines) >= len(lines) - 1  # 2-4 words a line
    # Every script word got a time, in order.
    words = [w for ln in lines for u in ln for w in u.words]
    assert [w.text for w in words] == SCRIPT.split()
    assert all(a.start <= b.start for a, b in zip(words, words[1:]))


def test_ass_highlights_current_word_gold_and_sits_in_caption_band():
    ass, _, lines = captions.make_captions(SCRIPT, WHISPER, DISPLAY)
    assert "PlayResX: 1080" in ass and "PlayResY: 1920" in ass
    assert "Style: MD,Nunito," in ass
    y = int(1920 * 0.60)
    assert 0.55 * 1920 <= y <= 0.65 * 1920
    events = [l for l in ass.splitlines() if l.startswith("Dialogue:")]
    assert events and all(f"\\pos(540,{y})" in e for e in events)
    # Exactly one gold-highlighted unit per event.
    assert all(e.count("\\c" + captions.GOLD) == 1 for e in events)
    assert captions.GOLD == "&H0061A2F4" and captions.CREAM == "&H00D3E6F0"


def test_srt_lines_and_timestamps():
    _, srt, lines = captions.make_captions(SCRIPT, WHISPER, DISPLAY)
    blocks = [b for b in srt.strip().split("\n\n")]
    assert len(blocks) == len(lines)
    first = blocks[0].splitlines()
    assert first[0] == "1" and first[1].startswith("00:00:00,000 --> ")


def test_elevenlabs_characters_group_into_words_and_years():
    _, _, lines = captions.make_captions("In eighteen ninety-six, he got sixes in algebra.", ELEVEN)
    assert "1896," in " ".join(shown(lines))
    words = captions.load_timings(ELEVEN)
    assert [w.text for w in words][:3] == ["In", "eighteen", "ninety-six,"]


def test_mismatch_fails_loudly():
    bad = copy.deepcopy(WHISPER)
    bad["segments"][0]["words"][4]["word"] = " 8,"  # heard "nine times eight"
    with pytest.raises(captions.AlignmentMismatch) as e:
        captions.make_captions(SCRIPT, bad, DISPLAY)
    assert "script word 5" in str(e.value)


def test_missing_and_extra_words_fail():
    short = copy.deepcopy(WHISPER)
    short["segments"][0]["words"].pop()
    with pytest.raises(captions.AlignmentMismatch, match="ended early"):
        captions.make_captions(SCRIPT, short, DISPLAY)
    extra = copy.deepcopy(WHISPER)
    extra["segments"][0]["words"].append({"word": " Wow.", "start": 9.0, "end": 9.2})
    with pytest.raises(captions.AlignmentMismatch):
        captions.make_captions(SCRIPT, extra, DISPLAY)


def test_cli_exit_code_on_mismatch(tmp_path):
    bad = copy.deepcopy(WHISPER)
    bad["segments"][0]["words"][0]["word"] = " Children,"
    p = tmp_path / "bad.json"
    p.write_text(json.dumps(bad), encoding="utf-8")
    rc = captions.main(["--script", str(FIX / "md009_script.txt"), "--timings", str(p), "--out", str(tmp_path / "x")])
    assert rc == 2 and not (tmp_path / "x.ass").exists()


def test_treatment_extraction_md009():
    repo = HERE.parents[2]
    text = captions.script_from_treatment(repo / "marketing/videos/MD-009/treatment.md", "Narrator")
    assert text.startswith("Parents, here's nine times seven, on your fingers.")
    assert len(text.split()) == 72  # the treatment's stated Narrator word count


@pytest.mark.parametrize("words,value", [
    ("sixty-three", 63), ("seventy", 70), ("one hundred", 100), ("nineteen hundred", 1900),
    ("nineteen thirty-five", 1935), ("eighteen ninety-five", 1895), ("thirty-seven", 37),
])
def test_number_words(words, value):
    ws = captions.script_words(words)
    units = captions.build_units(ws)
    assert [u.display for u in units] == [str(value)]
