"""MD-009: The 9s finger trick. Math overlays + the "why" card.

Treatment: marketing/videos/MD-009/treatment.md. Render with
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-009

Most of this video is hands footage, so most scenes are MDOverlayScene:
transparent .mov files laid over the footage in Kdenlive. Finger positions are
drawn evenly spaced across the safe area; in the edit, scale/move each overlay
to sit over the real fingers (left pinky = finger 1 as the camera sees it).

Scenes (beat -> scene):
    0-3 s    HookOverlay         9 × 7 on your fingers
    3-8 s    NumbersOverlay      1 2 3 4 5 6 7 8 9 10 pop in, left to right
    8-11 s   FoldSevenOverlay    Fold finger 7
    11-15 s  SplitSevenOverlay   gold bracket over 6, cream over 3; 6 | 3; 9 × 7 = 63
    15-19 s  SplitThreeOverlay   2 | 7; 9 × 3 = 27
    19-22 s  SplitOneOverlay, SplitFiveOverlay, SplitTenOverlay (montage, ~1 s each)
             RangeOverlay        Works for 9 × 1 to 9 × 10
    22-28 s  WhyCard (full card) 9 × 7 = 70 − 7 = 63; seven stacks of ten, 7 ones
                                 off the end; 70 − 7 = 60 + 3 = 63; 6 tens + 3 = 63
    28-30 s  ResultOverlay       9 × 7 = 63 (loop frame)
"""

from manim import (
    DOWN,
    LEFT,
    RIGHT,
    UP,
    FadeIn,
    FadeOut,
    Line,
    Square,
    VGroup,
    Write,
)

from md_style import (
    CREAM,
    GOLD,
    MATH_BOTTOM,
    MATH_CENTER_Y,
    MATH_TOP,
    SAFE_LEFT,
    SAFE_WIDTH,
    MDOverlayScene,
    MDScene,
    assert_verbatim,
    backing,
    check_equation,
    fit_width,
    md_lines,
    glyph_span,
    glyphs_for,
    md_text,
    px,
)

VIDEO = "MD-009"

# Exact strings, copied from the treatment's "Math strings" section.
HOOK = "9 × 7 on your fingers"
NUMBERS = "1 2 3 4 5 6 7 8 9 10"
FOLD7 = "Fold finger 7"
RANGE = "Works for 9 × 1 to 9 × 10"
WHY = "9 × 7 = 70 − 7 = 63"
STACKS = "70 − 7 = 60 + 3 = 63"
TENS = "6 tens + 3 = 63"
# (n, split, result) for every fold shown.
FOLDS = {
    7: ("6 | 3", "9 × 7 = 63"),
    3: ("2 | 7", "9 × 3 = 27"),
    1: ("0 | 9", "9 × 1 = 9"),
    5: ("4 | 5", "9 × 5 = 45"),
    10: ("9 | 0", "9 × 10 = 90"),
}

# ---- self-check (runs at import, before any frame renders) ----------------
assert_verbatim(VIDEO, [HOOK, NUMBERS, FOLD7, RANGE, WHY, STACKS, TENS,
                        *[s for pair in FOLDS.values() for s in pair]])
# The trick itself, for every n it claims: 9n = 10(n - 1) + (10 - n).
for n in range(1, 11):
    assert 9 * n == 10 * (n - 1) + (10 - n) == 10 * n - n
for n, (split, result) in FOLDS.items():
    left, right = (int(v) for v in split.split(" | "))
    assert (left, right) == (n - 1, 10 - n), (n, split)
    assert check_equation(result) == 9 * n == 10 * left + right, (n, result)
assert [int(v) for v in NUMBERS.split()] == list(range(1, 11))
assert FOLD7 == f"Fold finger {7}" and HOOK.startswith("9 × 7")
assert check_equation(WHY) == 63 and check_equation(STACKS) == 63
assert 6 * 10 + 3 == 63 and TENS == f"{6} tens + {3} = {6 * 10 + 3}"
assert 70 - 7 == 63 == 6 * 10 + 3  # seven tens, take away 7 ones: six tens and 3

FINGER_Y = MATH_CENTER_Y - px(200)
SPACING = SAFE_WIDTH / 10


def finger_x(k: int) -> float:
    """Centre x of finger k (1..10), evenly spread across the safe area."""
    return SAFE_LEFT + SPACING * (k - 0.5)


def top_card(s: str, digit_px: float = 110):
    t = md_text(s, digit_px=digit_px)
    if t.width > SAFE_WIDTH * 0.9:
        t.scale_to_fit_width(SAFE_WIDTH * 0.9)
    t.move_to(UP * (MATH_TOP - px(110)))
    return VGroup(backing(t), t)


def brackets(n: int):
    """Gold bracket over the n - 1 fingers left of the fold, cream over the rest."""
    out = VGroup()
    y = FINGER_Y + px(90)
    for lo, hi, color in ((1, n - 1, GOLD), (n + 1, 10, CREAM)):
        if hi < lo:
            continue
        x0, x1 = finger_x(lo) - SPACING * 0.4, finger_x(hi) + SPACING * 0.4
        b = VGroup(
            Line([x0, y, 0], [x1, y, 0], color=color, stroke_width=10),
            Line([x0, y, 0], [x0, y - px(40), 0], color=color, stroke_width=10),
            Line([x1, y, 0], [x1, y - px(40), 0], color=color, stroke_width=10),
        )
        out.add(b)
    return out


def split_label(n: int):
    split = FOLDS[n][0]
    t = md_text(split, digit_px=120)
    t.move_to([finger_x(n), FINGER_Y + px(210), 0])
    # Keep it inside the safe area at the edges (n = 1, n = 10).
    if t.get_left()[0] < SAFE_LEFT:
        t.shift(RIGHT * (SAFE_LEFT - t.get_left()[0]))
    if t.get_right()[0] > SAFE_LEFT + SAFE_WIDTH:
        t.shift(LEFT * (t.get_right()[0] - SAFE_LEFT - SAFE_WIDTH))
    # The left digit takes the gold bracket's colour, the right one cream.
    glyphs_for(t, split, split.split(" | ")[0]).set_color(GOLD)
    return VGroup(backing(t), t)


class HookOverlay(MDOverlayScene):
    def construct(self):
        t = fit_width(md_lines(HOOK, ["9 × 7"], digit_px=130), SAFE_WIDTH * 0.9).move_to(UP * (MATH_TOP - px(170)))
        self.add(backing(t), t)
        self.hold(3.0)


class NumbersOverlay(MDOverlayScene):
    """Gold numerals 1..10 over the fingers, popping in left to right."""

    def construct(self):
        row = md_text(NUMBERS, digit_px=80, color=GOLD)
        # "1" also occurs inside "10", so split glyphs by token, in order.
        glyph_groups, pos = [], 0
        for token in NUMBERS.split():
            pos = NUMBERS.index(token, pos)
            glyph_groups.append(glyph_span(row, NUMBERS, pos, len(token)))
            pos += len(token)
        for k, g in enumerate(glyph_groups, start=1):
            g.move_to([finger_x(k), FINGER_Y + px(110), 0])
        self.wait(0.3)
        for g in glyph_groups:
            self.play(FadeIn(g, scale=1.4), run_time=0.25)
        self.hold(2.2)


class FoldSevenOverlay(MDOverlayScene):
    def construct(self):
        self.add(top_card(FOLD7))
        self.hold(3.0)


def _split_scene(scene, n: int, hold: float):
    b = brackets(n)
    lab = split_label(n)
    res = top_card(FOLDS[n][1], digit_px=130)
    scene.play(FadeIn(b), run_time=0.3)
    scene.play(FadeIn(lab), run_time=0.3)
    scene.play(FadeIn(res), run_time=0.3)
    scene.hold(hold)


class SplitSevenOverlay(MDOverlayScene):
    def construct(self):
        _split_scene(self, 7, 3.0)


class SplitThreeOverlay(MDOverlayScene):
    def construct(self):
        _split_scene(self, 3, 3.0)


class SplitOneOverlay(MDOverlayScene):
    def construct(self):
        _split_scene(self, 1, 0.6)


class SplitFiveOverlay(MDOverlayScene):
    def construct(self):
        _split_scene(self, 5, 0.6)


class SplitTenOverlay(MDOverlayScene):
    def construct(self):
        _split_scene(self, 10, 0.6)


class RangeOverlay(MDOverlayScene):
    def construct(self):
        t = md_lines(RANGE, ["for"], digit_px=110).move_to(UP * (MATH_TOP - px(150)))
        self.add(backing(t), t)
        self.hold(3.0)


class ResultOverlay(MDOverlayScene):
    """28-30 s loop frame: finger 7 folded, 9 × 7 = 63."""

    def construct(self):
        self.add(top_card(FOLDS[7][1], digit_px=130))
        self.hold(2.0)


class WhyCard(MDScene):
    """22-28 s. Nine sevens is seventy, minus seven."""

    def construct(self):
        eq = fit_width(md_text(WHY, digit_px=110)).move_to(UP * (MATH_TOP - px(90)))
        self.play(Write(eq), run_time=0.8)
        # Seven stacks of ten unit squares.
        cell = px(38)
        stacks = VGroup()
        for _ in range(7):
            col = VGroup(*[Square(side_length=cell, stroke_color=CREAM, stroke_width=3,
                                  fill_color=GOLD, fill_opacity=0.85) for _ in range(10)])
            col.arrange(UP, buff=px(4))
            stacks.add(col)
        stacks.arrange(RIGHT, buff=px(34)).move_to(UP * (MATH_CENTER_Y + px(20)))
        self.play(FadeIn(stacks, lag_ratio=0.08), run_time=1.0)
        self.wait(0.4)
        # Take 7 ones off the end: the top 7 squares of the last stack.
        last = stacks[-1]
        removed = VGroup(*last.submobjects[3:])
        self.play(FadeOut(removed, shift=UP * 0.6), run_time=0.8)
        stacks_line = md_text(STACKS, digit_px=80).move_to(UP * (MATH_BOTTOM + px(110)))
        self.play(FadeIn(stacks_line), run_time=0.5)
        self.wait(0.8)
        tens = md_text(TENS, digit_px=80).move_to(stacks_line)
        self.play(FadeOut(stacks_line), FadeIn(tens), run_time=0.5)
        self.hold(1.2)
