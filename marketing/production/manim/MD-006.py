"""MD-006: Is zero even? (Dragon Puzzle, part 2: the answer). Math cards.

Treatment: marketing/videos/MD-006/treatment.md. Reuses MD-004's puzzle and
rule cards exactly (zero_puzzle.py). Render with
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-006

Scenes (beat -> scene):
    0-3 s    NeitherTempting   MD-004 puzzle card; NEITHER? turns fire orange
    3-9 s    ZeroFeelsNothing  the 0 dims to an empty plate, then back to 0
    9-16 s   ZeroIsEven        NEITHER? struck; EVEN glows emerald; two empty
                               groups; 0 = 0 + 0; 0 ÷ 2 = 0; remainder 0
    16-22 s  CountDownByTwos   6, 4, 2, 0 one at a time onto gold even ticks
    22-28 s  RuleCheck         MD-004 rule card with a gold check next to 0
    28-30 s  (Tallyclaw still + text card: Kdenlive, not Manim; else hold RuleCheck)
"""

from manim import (
    DOWN,
    LEFT,
    RIGHT,
    UP,
    Create,
    Ellipse,
    FadeIn,
    FadeOut,
    Line,
    ReplacementTransform,
    VGroup,
    Write,
)

from md_style import (
    CREAM,
    FIRE_ORANGE,
    GOLD,
    MATH_CENTER_Y,
    MATH_TOP,
    SAFE_WIDTH,
    MDScene,
    assert_verbatim,
    check_equation,
    check_mark,
    glow,
    glyphs_for,
    md_text,
    px,
    strike,
)
from zero_puzzle import RULE, empty_groups, puzzle_card, rule_text

VIDEO = "MD-006"

# Exact strings, copied from the treatment's "Math strings" section.
ZERO = "0"
EVEN, ODD, NEITHER = "EVEN", "ODD", "NEITHER?"
ZERO_SPLIT = "0 = 0 + 0"
ZERO_HALF = "0 ÷ 2 = 0"
REMAINDER = "remainder 0"
COUNTDOWN = "6, 4, 2, 0"

# ---- self-check (runs at import, before any frame renders) ----------------
assert_verbatim(VIDEO, [ZERO, EVEN, ODD, NEITHER, ZERO_SPLIT, ZERO_HALF, REMAINDER, COUNTDOWN, RULE])
assert check_equation(ZERO_SPLIT) == 0
assert check_equation(ZERO_HALF) == 0
assert 0 // 2 == 0 and 0 % 2 == 0 and int(REMAINDER.split()[-1]) == 0 % 2
COUNT_VALUES = [int(v) for v in COUNTDOWN.split(", ")]
assert COUNT_VALUES == list(range(6, -1, -2)) == [6, 4, 2, 0]
assert all(v % 2 == 0 for v in COUNT_VALUES)
assert 2 * 0 == 0


class NeitherTempting(MDScene):
    """0-3 s. Same card as MD-004 frame one; NEITHER? turns fire orange."""

    def construct(self):
        group, m = puzzle_card()
        self.add(group)
        self.wait(0.5)
        self.play(m["neither"].animate.set_color(FIRE_ORANGE), run_time=0.6)
        self.hold(1.9)


class ZeroFeelsNothing(MDScene):
    """3-9 s. The 0 dims to an empty plate (simple vector plate), then back."""

    def construct(self):
        group, m = puzzle_card()
        zero = m["zero"]
        self.add(zero)
        plate = VGroup(
            Ellipse(width=px(620), height=px(220), color=CREAM, stroke_width=8),
            Ellipse(width=px(400), height=px(130), color=CREAM, stroke_width=5, stroke_opacity=0.6),
        ).move_to(zero)
        self.wait(0.6)
        self.play(zero.animate.set_opacity(0.15), FadeIn(plate), run_time=1.0)
        self.hold(2.4)
        self.play(FadeOut(plate), zero.animate.set_opacity(1), run_time=1.0)
        self.hold(1.0)


class ZeroIsEven(MDScene):
    """9-16 s. The answer, one step at a time."""

    def construct(self):
        group, m = puzzle_card()
        m["neither"].set_color(FIRE_ORANGE)
        self.add(group)
        line = strike(m["neither"])
        self.play(Create(line), run_time=0.5)
        m["even"].set_color(CREAM)
        halo = self.glow_in(m["even"], run_time=0.6)
        self.wait(0.6)
        # Shrink the answer to the top, then two empty groups and the equations.
        answer = VGroup(halo, m["even"], m["zero"])
        self.play(FadeOut(VGroup(m["odd"], m["neither"], line)),
                  answer.animate.scale(0.7).move_to(UP * (MATH_TOP - px(150))),
                  run_time=0.7)
        groups = empty_groups(2).scale(0.8).move_to(UP * (MATH_CENTER_Y + px(60)))
        self.play(Create(groups), run_time=0.7)
        split = md_text(ZERO_SPLIT).next_to(groups, DOWN, buff=px(60))
        self.play(Write(split), run_time=0.8)
        self.hold(1.0)
        half = md_text(ZERO_HALF, digit_px=120)
        rem = md_text(REMAINDER, digit_px=80)
        self.play(FadeOut(groups), split.animate.move_to(UP * MATH_CENTER_Y), run_time=0.5)
        VGroup(half, rem).arrange(DOWN, buff=px(40)).next_to(split, DOWN, buff=px(80))
        self.play(Write(half), run_time=0.7)
        self.play(FadeIn(rem), run_time=0.5)
        self.hold(1.2)


class CountDownByTwos(MDScene):
    """16-22 s. 6, 4, 2, 0 appear one at a time, each landing on a gold tick.

    The number line has ticks only (no odd numerals), so the only numbers on
    screen are the treatment's string.
    """

    def construct(self):
        row = md_text(COUNTDOWN, digit_px=130)
        row.move_to(UP * (MATH_TOP - px(140)))
        width = SAFE_WIDTH * 0.86
        axis_y = MATH_CENTER_Y - px(120)
        axis = Line(LEFT * width / 2, RIGHT * width / 2, color=CREAM, stroke_width=6).shift(UP * axis_y)
        step = width / 6  # positions 0..6, 0 at the left
        ticks = VGroup()
        for k in range(7):
            even = k % 2 == 0
            t = Line(UP * px(40 if even else 22), DOWN * px(40 if even else 22),
                     color=GOLD if even else CREAM, stroke_width=10 if even else 5)
            t.move_to(axis.get_left() + RIGHT * step * k)
            ticks.add(t)
        self.play(Create(axis), FadeIn(ticks), run_time=0.8)
        for value in COUNT_VALUES:
            glyph = glyphs_for(row, COUNTDOWN, str(value))
            # The comma after the value (if any) appears with it.
            idx = COUNTDOWN.index(str(value))
            comma = glyphs_for(row, COUNTDOWN, ",", COUNTDOWN[:idx].count(",")) if idx + 1 < len(COUNTDOWN) else VGroup()
            self.play(FadeIn(glyph, shift=DOWN * 0.15), FadeIn(comma), run_time=0.4)
            drop = glyph.copy().scale(0.7)
            target = drop.copy().next_to(ticks[value], DOWN, buff=px(30))
            self.play(ReplacementTransform(drop, target), ticks[value].animate.set_stroke(width=16), run_time=0.6)
            self.wait(0.25)
        self.hold(1.2)


class RuleCheck(MDScene):
    """22-28 s. MD-004's rule card returns with a gold check next to the 0."""

    def construct(self):
        rule = rule_text()
        group, m = puzzle_card()
        zero = m["zero"]
        zero.scale(0.75).move_to(UP * (MATH_CENTER_Y - px(40)))
        self.add(rule)
        self.play(FadeIn(zero), run_time=0.6)
        tick = check_mark(size=px(150)).next_to(zero, RIGHT, buff=px(60))
        self.play(Create(tick), run_time=0.6)
        self.hold(4.8)
