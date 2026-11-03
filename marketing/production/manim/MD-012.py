"""MD-012: There are only 55 times-table facts. Math cards.

Treatment: marketing/videos/MD-012/treatment.md. Render with
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-012

One grid, generated in code from a, b in 1..10; every fade is driven by the
same sets, and the counter values (100, 55, 36) are those sets' sizes, so the
display can't drift from the math. Tiles carry no product numbers at full-grid
size (they would be below legible size on a phone; treatment production notes).

Layout (1080 x 1920 px): callout row y ~340; counter + side cards in the left
column (x 65-445); the 11 x 11 grid (headers + 10 x 10) at the right
(x 465-1015, y 470-1020), all above the caption band.

Scenes (beat -> scene):
    0-4 s    Hook            grid, lower-left half starting to fade; Not 100 facts. 55.
    4-9 s    WholeTable      full grid, headers 1-10; 1 × 1 to 10 × 10 = 100 boxes; counter 100
    9-14 s   FlippedPair     3 × 7 and 7 × 3 light gold, merge: 3 × 7 = 7 × 3 = 21
    14-18 s  EachPairOnce    below-diagonal fades; counter 100 -> 55; Each pair once: 55
    18-25 s  SetAside        rows/cols 1 then 10 dim; 1 × 7 = 7, 10 × 7 = 70; counter 55 -> 36
    25-29 s  ThirtySix       the 2-9 triangle glows emerald, 36 holds, one fade back to the full grid
"""

from manim import (
    DOWN,
    RIGHT,
    UP,
    FadeIn,
    FadeOut,
    ReplacementTransform,
    Square,
    VGroup,
)

from md_style import (
    CREAM,
    DRAGON_PURPLE,
    GOLD,
    SAFE_WIDTH,
    MDScene,
    assert_verbatim,
    canvas_x,
    canvas_y,
    check_equation,
    fit_width,
    md_text,
    px,
)

VIDEO = "MD-012"

# Exact strings, copied from the treatment's "Math strings" section.
HOOK = "Not 100 facts. 55."
WHOLE = "1 × 1 to 10 × 10 = 100 boxes"
FLIP = "3 × 7 = 7 × 3"
FLIP_FULL = "3 × 7 = 7 × 3 = 21"
PAIRS = "Each pair once: 55"
ONE_CARD = "1 × 7 = 7"
TEN_CARD = "10 × 7 = 70"
ONE_RULE = "× 1 stays the same"
TEN_RULE = "× 10 puts a 0 on the end"
CORE = "36"

# ---- the sets every visual is driven by ------------------------------------
N = range(1, 11)
ALL = {(a, b) for a in N for b in N}  # row a, column b
PAIRS_ONCE = {(a, b) for (a, b) in ALL if a <= b}  # each flipped pair once, squares kept
WITH_1_OR_10 = {(a, b) for (a, b) in PAIRS_ONCE if {a, b} & {1, 10}}
CORE_SET = PAIRS_ONCE - WITH_1_OR_10

# ---- self-check (runs at import, before any frame renders) ----------------
assert_verbatim(VIDEO, [HOOK, WHOLE, FLIP, FLIP_FULL, PAIRS, ONE_CARD, TEN_CARD, ONE_RULE, TEN_RULE, CORE])
assert len(ALL) == 100 and len(PAIRS_ONCE) == 55 and len(WITH_1_OR_10) == 19 and len(CORE_SET) == 36
assert len(PAIRS_ONCE) == 10 + 45  # 10 squares + 45 flipped pairs
assert CORE_SET == {(a, b) for a in range(2, 10) for b in range(2, 10) if a <= b}
assert HOOK == f"Not {len(ALL)} facts. {len(PAIRS_ONCE)}."
assert WHOLE == f"1 × 1 to 10 × 10 = {len(ALL)} boxes" and 10 * 10 == len(ALL)
assert PAIRS == f"Each pair once: {len(PAIRS_ONCE)}" and CORE == str(len(CORE_SET))
assert check_equation(FLIP) == 21 and check_equation(FLIP_FULL) == 21
assert check_equation(ONE_CARD) == 7 and check_equation(TEN_CARD) == 70
assert all(1 * b == b for b in N)  # × 1 stays the same
assert all(str(10 * b) == str(b) + "0" for b in N)  # × 10 puts a 0 on the end (whole numbers)

# ---- layout -----------------------------------------------------------------
CELL = px(50)
GRID_LEFT_PX, GRID_TOP_PX = 465, 470
COUNTER_POS = canvas_x(255) * RIGHT + canvas_y(610) * UP
SIDE_POS = canvas_x(255) * RIGHT + canvas_y(860) * UP
CALLOUT_POS = canvas_y(345) * UP


def cell_center(row: int, col: int):
    """row/col 0 are the headers; 1..10 the table."""
    x = canvas_x(GRID_LEFT_PX) + CELL * (col + 0.5)
    y = canvas_y(GRID_TOP_PX) - CELL * (row + 0.5)
    return x * RIGHT + y * UP


def build_grid():
    tiles = {}
    for a, b in sorted(ALL):
        t = Square(side_length=CELL * 0.9, stroke_color=CREAM, stroke_width=2, stroke_opacity=0.5,
                   fill_color=DRAGON_PURPLE, fill_opacity=1)
        t.set_fill(color="#4A3A8C")
        tiles[(a, b)] = t.move_to(cell_center(a, b))
    headers = VGroup()
    for k in N:
        for pos in (cell_center(0, k), cell_center(k, 0)):
            headers.add(md_text(str(k), digit_px=26, color=GOLD).move_to(pos))
    corner = md_text("×", digit_px=26).move_to(cell_center(0, 0))
    return tiles, VGroup(headers, corner)


def callout(s: str):
    t = md_text(s, digit_px=72)
    fit_width(t, SAFE_WIDTH * 0.96)
    return t.move_to(CALLOUT_POS)


def counter(n: int):
    return md_text(str(n), digit_px=150).move_to(COUNTER_POS)


def dim(tiles, keys, opacity=0.08):
    return [tiles[k].animate.set_opacity(opacity) for k in sorted(keys)]


class Hook(MDScene):
    """0-4 s. Frame one: the grid, lower-left half already fading."""

    def construct(self):
        tiles, headers = build_grid()
        self.add(*tiles.values(), headers, callout(HOOK))
        lower = ALL - PAIRS_ONCE
        for k in lower:
            tiles[k].set_opacity(0.6)
        self.play(*dim(tiles, lower, 0.25), run_time=3.5, rate_func=lambda t: t)
        self.wait(0.5)


class WholeTable(MDScene):
    """4-9 s. One times one up to ten times ten: a hundred boxes."""

    def construct(self):
        tiles, headers = build_grid()
        self.add(*tiles.values(), headers)
        self.play(FadeIn(callout(WHOLE)), FadeIn(counter(len(ALL))), run_time=0.6)
        self.hold(4.4)


class FlippedPair(MDScene):
    """9-14 s. 3 × 7 and 7 × 3 are the same fact, flipped."""

    def construct(self):
        tiles, headers = build_grid()
        cnt = counter(len(ALL))
        self.add(*tiles.values(), headers, cnt)
        top = callout(FLIP)
        self.play(tiles[(3, 7)].animate.set_fill(GOLD), tiles[(7, 3)].animate.set_fill(GOLD), FadeIn(top), run_time=0.7)
        self.hold(1.6)
        ghost = tiles[(7, 3)].copy()
        self.add(ghost)
        full = callout(FLIP_FULL)
        self.play(ghost.animate.move_to(tiles[(3, 7)]), ReplacementTransform(top, full), run_time=0.9)
        self.remove(ghost)
        self.hold(1.8)


class EachPairOnce(MDScene):
    """14-18 s. Count each pair once: the lower-left half goes; 100 -> 55."""

    def construct(self):
        tiles, headers = build_grid()
        cnt = counter(len(ALL))
        self.add(*tiles.values(), headers, cnt)
        new_cnt = counter(len(PAIRS_ONCE))
        self.play(*dim(tiles, ALL - PAIRS_ONCE), run_time=1.2)
        self.play(ReplacementTransform(cnt, new_cnt), FadeIn(callout(PAIRS)), run_time=0.6)
        self.hold(2.2)


class SetAside(MDScene):
    """18-25 s. Set aside the ones and the tens; 55 -> 36."""

    def construct(self):
        tiles, headers = build_grid()
        for k in ALL - PAIRS_ONCE:
            tiles[k].set_opacity(0.08)
        cnt = counter(len(PAIRS_ONCE))
        self.add(*tiles.values(), headers, cnt)
        ones = {k for k in WITH_1_OR_10 if 1 in k}
        tens = WITH_1_OR_10 - ones
        assert len(ones) + len(tens) == len(WITH_1_OR_10)
        rule1, card1 = callout(ONE_RULE), md_text(ONE_CARD, digit_px=56).move_to(SIDE_POS)
        self.play(*dim(tiles, ones, 0.25), FadeIn(rule1), FadeIn(card1), run_time=0.8)
        self.hold(2.4)
        rule10 = callout(TEN_RULE)
        card10 = md_text(TEN_CARD, digit_px=56).move_to(SIDE_POS + DOWN * px(110))
        self.play(*dim(tiles, tens, 0.25), ReplacementTransform(rule1, rule10), FadeIn(card10), run_time=0.8)
        self.hold(1.6)
        new_cnt = counter(len(CORE_SET))
        self.play(ReplacementTransform(cnt, new_cnt), run_time=0.6)
        self.hold(0.8)


class ThirtySix(MDScene):
    """25-29 s. Only the 2-9 triangle remains, glowing; 36 holds; one fade back."""

    def construct(self):
        tiles, headers = build_grid()
        for k in ALL - CORE_SET:
            tiles[k].set_opacity(0.08)
        cnt = counter(len(CORE_SET))
        self.add(*tiles.values(), headers, cnt)
        core = VGroup(*[tiles[k] for k in sorted(CORE_SET)])
        halo = self.glow_in(core, run_time=0.5)
        self.hold(2.3)
        # One single fade back to the full grid for the loop (no flicker).
        self.play(FadeOut(halo), FadeOut(cnt), *[tiles[k].animate.set_fill(opacity=1).set_stroke(opacity=0.5) for k in sorted(ALL - CORE_SET)],
                  run_time=1.0)
        self.wait(0.2)
