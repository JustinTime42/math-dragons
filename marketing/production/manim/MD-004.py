"""MD-004: Is zero even? (Dragon Puzzle, part 1). Math cards.

Treatment: marketing/videos/MD-004/treatment.md. Render with
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-004

Scenes (beat -> scene):
    0-5 s    PuzzleCard      0 between EVEN and ODD, NEITHER? below, each pulses
    5-13 s   RuleCard        six dots as 3 + 3, label 6 = 3 + 3, the rule, 0 returns
    13-16 s  ThinkingBeat    the 0 alone, a fire bar burns down (no numbers)
    16-18 s  LoopCard        the opening frame, held (loop)
Nothing is coloured as right or wrong in part 1.
"""

from manim import (
    DOWN,
    UP,
    Circumscribe,
    FadeIn,
    FadeOut,
    Indicate,
    Rectangle,
    VGroup,
    Write,
)

from md_style import (
    FIRE_ORANGE,
    GOLD,
    MATH_TOP,
    SAFE_BOTTOM,
    SAFE_WIDTH,
    MDScene,
    assert_verbatim,
    check_equation,
    md_text,
    px,
)
from zero_puzzle import RULE, dot_groups, puzzle_card, rule_text

VIDEO = "MD-004"

# Exact strings, copied from the treatment's "Math strings" section.
ZERO = "0"
EVEN, ODD, NEITHER = "EVEN", "ODD", "NEITHER?"
DOTS_LABEL = "6 = 3 + 3"
DOTS_SUM = "3 + 3"

# ---- self-check (runs at import, before any frame renders) ----------------
assert_verbatim(VIDEO, [ZERO, EVEN, ODD, NEITHER, DOTS_LABEL, DOTS_SUM, RULE])
assert check_equation(DOTS_LABEL) == 6
assert 6 % 2 == 0 and 3 + 3 == 6
assert 0 % 2 == 0  # the part-2 answer (not shown here)
assert puzzle_card()[1]["zero"] is not None


class PuzzleCard(MDScene):
    """0-5 s. Frame one already shows the whole puzzle (content on frame one)."""

    def construct(self):
        group, m = puzzle_card()
        self.add(group)
        self.wait(0.4)
        for key in ("even", "odd", "neither"):
            self.play(Indicate(m[key], color=m[key].get_color(), scale_factor=1.12), run_time=0.9)
            self.wait(0.3)
        self.hold(1.2)


class RuleCard(MDScene):
    """5-13 s. The rule with a non-zero example, then the 0 returns."""

    def construct(self):
        rule = rule_text()
        dots = dot_groups(3, 2)
        dots.move_to(UP * (MATH_TOP - px(560)))
        label = md_text(DOTS_LABEL, digit_px=120)
        label.next_to(dots, DOWN, buff=px(60))
        self.play(FadeIn(dots, shift=UP * 0.2), run_time=0.8)
        self.play(Write(label), run_time=1.0)
        self.hold(1.2)
        self.play(FadeIn(rule), run_time=0.8)
        self.hold(2.6)
        group, m = puzzle_card()
        self.play(FadeOut(VGroup(dots, label, rule)), FadeIn(m["zero"]), run_time=0.8)
        self.hold(0.8)


class ThinkingBeat(MDScene):
    """13-16 s. Silence: the 0 alone, a dragon-fire bar burns down. No count."""

    def construct(self):
        group, m = puzzle_card()
        self.add(m["zero"])
        width = SAFE_WIDTH * 0.9
        bar = Rectangle(width=width, height=px(36), stroke_width=0)
        bar.set_fill(color=[FIRE_ORANGE, GOLD], opacity=1)
        bar.move_to(UP * (SAFE_BOTTOM + px(60)))
        self.add(bar)
        # Burn from the right edge to nothing over 3 s; one smooth motion, no flashing.
        self.play(bar.animate.stretch(0.001, 0, about_point=bar.get_left()), run_time=3.0, rate_func=lambda t: t)


class LoopCard(MDScene):
    """16-18 s. The opening frame exactly, so the replay starts on the question."""

    def construct(self):
        group, _ = puzzle_card()
        self.add(group)
        self.hold(2.0)
