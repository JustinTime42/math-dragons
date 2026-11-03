"""MD-007: Make a ten, decoded. Math cards.

Treatment: marketing/videos/MD-007/treatment.md. Render with
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-007

Scenes (beat -> scene):
    0-4 s    Worksheet        recreated worksheet line on a cream card (our layout)
    4-9 s    EightPlusSix     8 + 6, then 10 − 8 = 2 small beneath
    9-13 s   SplitSix         the 6 splits into 2 and 4: 6 = 2 + 4
    13-18 s  MakeTen          8 + 2 = 10, then 10 + 4 = 14
    21-26 s  FullChain        8 + 6 = 8 + 2 + 4 = 10 + 4 = 14, one step at a time,
                              label Common Core 1.OA.C.6, grade 1
    26-33 s  WhyTeach         one "hard" box (8 + 6) splits into two easy boxes
    33-44 s  TenFrame         8 gold dots; 2 slide in from a frame of 6, 4 stay
    55-56 s  WorksheetFilled  the worksheet line again, blank filled: 8 + 6 = 14
Beats 18-21, 44-48, 48-55 are hands footage / text callouts (see plan.md).

Minus glyph: true minus sign (U+2212) on screen, per Justin 2026-11-03 and visual-style §6.
"""

from manim import (
    DOWN,
    LEFT,
    RIGHT,
    UP,
    Create,
    FadeIn,
    FadeOut,
    ReplacementTransform,
    RoundedRectangle,
    Square,
    TransformFromCopy,
    VGroup,
    Write,
)
from manim import Dot as _Dot

from md_style import (
    CREAM,
    DEEP_VOID,
    EMERALD,
    GOLD,
    MATH_BOTTOM,
    MATH_CENTER_Y,
    MATH_TOP,
    SAFE_WIDTH,
    MDScene,
    assert_verbatim,
    check_equation,
    fit_width,
    glow,
    glyphs_for,
    md_lines,
    md_text,
    px,
)

VIDEO = "MD-007"

# Exact strings, copied from the treatment's "Math strings" section.
WORKSHEET = "Make a ten to add: 8 + 6 = ___"
EIGHT_SIX = "8 + 6"
TEN_MINUS = "10 − 8 = 2"
SIX_SPLIT = "6 = 2 + 4"
EIGHT_TWO = "8 + 2 = 10"
TEN_FOUR = "10 + 4 = 14"
CHAIN = "8 + 6 = 8 + 2 + 4 = 10 + 4 = 14"
ANSWER = "8 + 6 = 14"
LABEL = "Common Core 1.OA.C.6, grade 1"

# ---- self-check (runs at import, before any frame renders) ----------------
assert_verbatim(VIDEO, [WORKSHEET, EIGHT_SIX, TEN_MINUS, SIX_SPLIT, EIGHT_TWO, TEN_FOUR, CHAIN, ANSWER, LABEL])
assert check_equation(EIGHT_SIX + " = 14") == 14
assert check_equation(TEN_MINUS) == 2
assert check_equation(SIX_SPLIT) == 6
assert check_equation(EIGHT_TWO) == 10
assert check_equation(TEN_FOUR) == 14
assert check_equation(CHAIN) == 14
assert check_equation(ANSWER) == 14
assert WORKSHEET.endswith(EIGHT_SIX + " = ___") and ANSWER.startswith(EIGHT_SIX + " = ")
# Ten frame: 8 filled + 2 moved = 10; 6 − 2 = 4 left over; frame is 2 × 5.
TEN_FRAME_FILLED, TEN_FRAME_SECOND, MOVED = 8, 6, 2
assert TEN_FRAME_FILLED + MOVED == 10 == 2 * 5
assert TEN_FRAME_SECOND - MOVED == 4
# The chain card is shown one step per line; the lines must rejoin exactly.
CHAIN_LINES = ["8 + 6", "= 8 + 2 + 4", "= 10 + 4", "= 14"]
assert " ".join(CHAIN_LINES) == CHAIN


WS_DIGIT_PX = 110


def worksheet_card():
    """Cream card, Deep Void text: our own layout, no publisher design.

    Two lines, split after the colon (md_lines checks the string is unchanged).
    Operators stay Deep Void: gold on cream is too low-contrast for a worksheet.
    """
    t = md_lines(WORKSHEET, [":"], digit_px=WS_DIGIT_PX, color=DEEP_VOID, operator_color=None)
    fit_width(t, SAFE_WIDTH * 0.84)
    card = RoundedRectangle(corner_radius=px(30), width=SAFE_WIDTH * 0.96, height=t.height + px(220),
                            stroke_width=0, fill_color=CREAM, fill_opacity=1)
    card.move_to(UP * MATH_CENTER_Y)
    t.move_to(card)
    return card, t


class Worksheet(MDScene):
    """0-4 s. Frame one already shows the worksheet line."""

    def construct(self):
        card, t = worksheet_card()
        self.add(card, t)
        self.hold(4.0)


class WorksheetFilled(MDScene):
    """55-56 s. The same card; the 8 + 6 = ___ part becomes 8 + 6 = 14."""

    def construct(self):
        card, t = worksheet_card()
        self.add(card, t)
        old = t[1]  # the "8 + 6 = ___" line
        new = md_text(ANSWER, digit_px=WS_DIGIT_PX, color=DEEP_VOID, operator_color=None)
        new.scale(old.submobjects[0].height / new.submobjects[0].height)  # same "8" size
        new.move_to(old.get_center() * UP + t.get_center() * RIGHT)
        self.play(ReplacementTransform(old, new), run_time=0.5)
        self.hold(1.0)


class EightPlusSix(MDScene):
    """4-9 s. 8 + 6, then how far 8 is from 10."""

    def construct(self):
        top = md_text(EIGHT_SIX, digit_px=160).move_to(UP * (MATH_CENTER_Y + px(120)))
        self.play(FadeIn(top), run_time=0.5)
        self.hold(1.2)
        small = md_text(TEN_MINUS, digit_px=90).next_to(top, DOWN, buff=px(110))
        self.play(Write(small), run_time=0.9)
        self.hold(2.4)


class SplitSix(MDScene):
    """9-13 s. The 6 splits into 2 and 4."""

    def construct(self):
        top = md_text(EIGHT_SIX, digit_px=160).move_to(UP * (MATH_CENTER_Y + px(120)))
        self.add(top)
        six = glyphs_for(top, EIGHT_SIX, "6")
        split = md_text(SIX_SPLIT, digit_px=120).next_to(top, DOWN, buff=px(110))
        self.play(six.animate.set_color(GOLD), run_time=0.4)
        self.play(TransformFromCopy(six, glyphs_for(split, SIX_SPLIT, "6")), run_time=0.6)
        self.play(FadeIn(VGroup(*[g for g in split.submobjects[1:]]), shift=DOWN * 0.1), run_time=0.6)
        self.play(six.animate.set_color(CREAM), run_time=0.3)
        self.hold(2.1)


class MakeTen(MDScene):
    """13-18 s. 8 + 2 = 10, then 10 + 4 = 14."""

    def construct(self):
        a = md_text(EIGHT_TWO).move_to(UP * (MATH_CENTER_Y + px(150)))
        b = md_text(TEN_FOUR).next_to(a, DOWN, buff=px(110))
        self.play(Write(a), run_time=0.8)
        self.hold(1.4)
        self.play(Write(b), run_time=0.8)
        self.glow_in(glyphs_for(b, TEN_FOUR, "14"))
        self.hold(1.6)


class FullChain(MDScene):
    """21-26 s. The standard's exact example, one step per line."""

    def construct(self):
        lines = [md_text(s, digit_px=115) for s in CHAIN_LINES]
        stack = VGroup(*lines).arrange(DOWN, buff=px(45), aligned_edge=LEFT)
        # Line 1 sits over the first number of the "=" lines, so the = signs form a column.
        lines[0].align_to(glyphs_for(lines[1], CHAIN_LINES[1], "8"), LEFT)
        stack.move_to(UP * (MATH_CENTER_Y + px(90)))
        label = md_text(LABEL, digit_px=48, operator_color=None).set_opacity(0.85)
        label.move_to(UP * (MATH_BOTTOM + px(50)))
        self.play(FadeIn(lines[0]), FadeIn(label), run_time=0.5)
        for ln in lines[1:]:
            self.wait(0.6)
            self.play(Write(ln), run_time=0.6)
        self.glow_in(glyphs_for(lines[-1], CHAIN_LINES[-1], "14"))
        self.hold(1.4)


class WhyTeach(MDScene):
    """26-33 s. One harder fact becomes two easy steps."""

    def construct(self):
        def box(s, w, color):
            t = md_text(s, digit_px=110)
            r = RoundedRectangle(corner_radius=px(26), width=max(w, t.width + px(120)), height=t.height + px(120),
                                 stroke_color=color, stroke_width=8)
            return VGroup(r.move_to(t), t)

        hard = box(EIGHT_SIX, SAFE_WIDTH * 0.62, GOLD).move_to(UP * (MATH_TOP - px(200)))
        easy1 = box(EIGHT_TWO, SAFE_WIDTH * 0.7, EMERALD)
        easy2 = box(TEN_FOUR, SAFE_WIDTH * 0.7, EMERALD)
        VGroup(easy1, easy2).arrange(DOWN, buff=px(50)).next_to(hard, DOWN, buff=px(90))
        self.play(FadeIn(hard), run_time=0.6)
        self.hold(1.6)
        self.play(TransformFromCopy(hard[0], easy1[0]), TransformFromCopy(hard[0], easy2[0]), run_time=0.8)
        self.play(Write(easy1[1]), run_time=0.6)
        self.play(Write(easy2[1]), run_time=0.6)
        self.hold(2.8)


def ten_frame(cell=px(120)):
    cells = VGroup(*[Square(side_length=cell, stroke_color=CREAM, stroke_width=5) for _ in range(10)])
    cells.arrange_in_grid(rows=2, cols=5, buff=0)
    return cells


class TenFrame(MDScene):
    """33-44 s. A box with ten spaces: 8 gold + 2 moved in = 10; 4 left over."""

    def construct(self):
        a = ten_frame().move_to(UP * (MATH_CENTER_Y + px(170)))
        b = ten_frame().move_to(UP * (MATH_CENTER_Y - px(190)))
        r = px(40)
        dots_a = VGroup(*[_Dot(a[i].get_center(), radius=r, color=GOLD) for i in range(TEN_FRAME_FILLED)])
        dots_b = VGroup(*[_Dot(b[i].get_center(), radius=r, color=CREAM) for i in range(TEN_FRAME_SECOND)])
        self.play(Create(a), run_time=0.8)
        self.play(FadeIn(dots_a, lag_ratio=0.1), run_time=1.0)
        self.hold(1.5)
        self.play(Create(b), FadeIn(dots_b, lag_ratio=0.1), run_time=1.0)
        self.hold(1.5)
        # The last two dots of the 6-frame slide into the 8-frame's empty spaces.
        moving = [dots_b[TEN_FRAME_SECOND - 1 - k] for k in range(MOVED)]
        targets = [a[TEN_FRAME_FILLED + k].get_center() for k in range(MOVED)]
        self.play(*[m.animate.move_to(t) for m, t in zip(moving, targets)], run_time=1.4)
        self.glow_in(a)
        self.hold(3.3)
