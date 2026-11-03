"""Shared cards for the zero puzzle (MD-004 part 1, MD-006 part 2).

MD-006's production notes say to reuse MD-004's puzzle and rule cards exactly,
so both scripts build them here. Strings are passed in by the caller (each
script checks its own strings against its own treatment).
"""

from __future__ import annotations

from manim import DOWN, LEFT, RIGHT, UP, Circle, Dot, VGroup

from md_style import (
    CREAM,
    GOLD,
    MATH_CENTER_Y,
    MATH_TOP,
    WARM_GLOW,
    fit_width,
    md_lines,
    md_text,
    px,
)

RULE = "Even = 2 equal groups, none left over"


def puzzle_card():
    """Big cream 0 between gold EVEN and ODD, warm-glow NEITHER? below."""
    zero = md_text("0", digit_px=420)
    even = md_text("EVEN", digit_px=110, color=GOLD)
    odd = md_text("ODD", digit_px=110, color=GOLD)
    neither = md_text("NEITHER?", digit_px=110, color=WARM_GLOW)
    zero.move_to(UP * (MATH_CENTER_Y + px(60)))
    even.next_to(zero, LEFT, buff=px(70))
    odd.next_to(zero, RIGHT, buff=px(70))
    neither.next_to(zero, DOWN, buff=px(60))
    group = VGroup(even, zero, odd, neither)
    fit_width(group)
    group.move_to(UP * (MATH_CENTER_Y + px(60)))
    return group, dict(zero=zero, even=even, odd=odd, neither=neither)


def rule_text():
    """The rule, wrapped after the comma (same glyphs, verbatim string)."""
    t = md_lines(RULE, [","], digit_px=90)
    fit_width(t)
    t.move_to(UP * (MATH_TOP - px(120)))
    return t


def dot_groups(n_per_group: int = 3, groups: int = 2):
    """Two equal groups of dots, each inside a gold ring."""
    rings = VGroup()
    for _ in range(groups):
        dots = VGroup(*[Dot(radius=px(30), color=CREAM) for _ in range(n_per_group)])
        dots.arrange(DOWN, buff=px(26))
        ring = Circle(radius=max(dots.height, dots.width) / 2 + px(50), color=GOLD, stroke_width=8)
        ring.move_to(dots)
        rings.add(VGroup(ring, dots))
    rings.arrange(RIGHT, buff=px(110))
    return rings


def empty_groups(groups: int = 2):
    """Two equal groups with nothing in them (zero split in two)."""
    rings = VGroup(*[Circle(radius=px(150), color=GOLD, stroke_width=8) for _ in range(groups)])
    rings.arrange(RIGHT, buff=px(110))
    return rings
