"""Shared Manim style for Math Dragons video math cards.

Source of truth for every value here: marketing/guides/visual-style.md
(§1 canvas, §2 safe zones, §3 colour, §4 type, §6 math cards).

Import from a video script with `from md_style import *` (the render wrapper,
render.py, puts this directory on the path). Importing this module:
  * switches the Manim config to a 9:16 portrait frame (1080 x 1920 at -qh,
    480 x 854 at -ql), 16 x 9 scene units, so 1 unit = 120 px at 1080 wide;
  * registers assets/fonts/Nunito-Bold.ttf and Cinzel-Bold.ttf with Pango
    (no LaTeX anywhere: all math is Manim `Text` in Nunito Bold).

Safe-zone guides: set MD_GUIDES=1 in the environment (render.py --guides)
and every MDScene draws the visual-style §2 safe rectangle and the §5 caption
band on top. Never ship a render made with guides on.
"""

from __future__ import annotations

import os
import re
from fractions import Fraction
from pathlib import Path

import manimpango
from manim import (
    BOLD,
    DOWN,
    LEFT,
    RIGHT,
    UP,
    DashedVMobject,
    Line,
    Mobject,
    Rectangle,
    Scene,
    Text,
    VGroup,
    VMobject,
    config,
)

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
PRODUCTION_DIR = Path(__file__).resolve().parents[1]
REPO_ROOT = PRODUCTION_DIR.parents[1]
FONTS_DIR = REPO_ROOT / "assets" / "fonts"
VIDEOS_DIR = REPO_ROOT / "marketing" / "videos"

# ---------------------------------------------------------------------------
# Palette (visual-style §3, from lib/theme/dragon_colors.dart)
# ---------------------------------------------------------------------------
DEEP_VOID = "#1A0F3D"
DRAGON_PURPLE = "#2D1B69"
MIDNIGHT_BLUE = "#1A1A2E"
CREAM = "#F0E6D3"  # Text Primary: numbers and text
GOLD = "#F4A261"  # Dragon Gold: operators, equals, highlight
WARM_GLOW = "#F7C08A"  # secondary accent
EMERALD = "#2A9D8F"  # correct (glow only behind cream text, §6)
FIRE_ORANGE = "#E76F51"  # wrong / "common wrong answer"

# ---------------------------------------------------------------------------
# Fonts (visual-style §4). Registered once, at import.
# ---------------------------------------------------------------------------
NUNITO = "Nunito"
CINZEL = "Cinzel"
for _f in ("Nunito-Bold.ttf", "Cinzel-Bold.ttf"):
    _p = FONTS_DIR / _f
    if not _p.exists():
        raise FileNotFoundError(f"font missing: {_p}")
    if not manimpango.register_font(str(_p)):
        raise RuntimeError(f"Pango could not register {_p}")

# ---------------------------------------------------------------------------
# Canvas (visual-style §1): portrait 9:16, 30 fps for anything but previews.
# ---------------------------------------------------------------------------
CANVAS_W_PX = 1080
CANVAS_H_PX = 1920
FRAME_W = 9.0
FRAME_H = 16.0
UNIT_PX = CANVAS_W_PX / FRAME_W  # 120 px per scene unit at full size


def setup_portrait() -> None:
    """Turn whatever quality preset the CLI chose into its portrait twin."""
    w, h = config.pixel_width, config.pixel_height
    if w > h:
        config.pixel_width, config.pixel_height = h, w
    config.frame_width = FRAME_W
    config.frame_height = FRAME_H
    config.background_color = DEEP_VOID
    # Masters (-qh and up) at 30 fps per visual-style §1; previews keep the
    # preset's rate. Manim's quality name is unreliable at import, so use size.
    if min(w, h) >= 1080:
        config.frame_rate = 30


setup_portrait()


def px(n: float) -> float:
    """Pixels on the 1080 x 1920 canvas to scene units."""
    return n / UNIT_PX


def canvas_x(x_px: float) -> float:
    """Canvas x pixel (0 = left edge) to scene x."""
    return x_px / UNIT_PX - FRAME_W / 2


def canvas_y(y_px: float) -> float:
    """Canvas y pixel (0 = top edge) to scene y."""
    return FRAME_H / 2 - y_px / UNIT_PX


# Safe zone (visual-style §2): x 65-1015, y 270-1250 on 1080 x 1920.
SAFE_LEFT, SAFE_RIGHT = canvas_x(65), canvas_x(1015)
SAFE_TOP, SAFE_BOTTOM = canvas_y(270), canvas_y(1250)
SAFE_WIDTH = SAFE_RIGHT - SAFE_LEFT
SAFE_HEIGHT = SAFE_TOP - SAFE_BOTTOM
SAFE_CENTER = ((SAFE_LEFT + SAFE_RIGHT) / 2) * RIGHT + ((SAFE_TOP + SAFE_BOTTOM) / 2) * UP
# Caption band (visual-style §5): 55-65 % of the frame height. Math cards keep
# out of it so burned-in captions never sit on top of an equation.
CAPTION_TOP, CAPTION_BOTTOM = canvas_y(0.55 * CANVAS_H_PX), canvas_y(0.65 * CANVAS_H_PX)
# Usable math area: the safe zone above the caption band.
MATH_TOP, MATH_BOTTOM = SAFE_TOP, CAPTION_TOP
MATH_CENTER_Y = (MATH_TOP + MATH_BOTTOM) / 2

# Equation size (visual-style §6): 120-160 px tall. We size by the height of
# a digit, so "140" means a cream "8" is 140 px tall on the 1080 canvas.
EQ_DIGIT_PX = 140
SMALL_DIGIT_PX = 80

# ---------------------------------------------------------------------------
# Math text
# ---------------------------------------------------------------------------
# Glyphs painted gold (operators, equals, separators). Everything else cream.
OPERATOR_CHARS = set("+−-×÷=→|<>")

_DIGIT_REF_CACHE: dict[str, float] = {}


def _digit_height(font: str) -> float:
    if font not in _DIGIT_REF_CACHE:
        _DIGIT_REF_CACHE[font] = Text("8", font=font, weight=BOLD).height
    return _DIGIT_REF_CACHE[font]


def md_text(
    s: str,
    digit_px: float = EQ_DIGIT_PX,
    color: str = CREAM,
    font: str = NUNITO,
    operator_color: str | None = GOLD,
) -> Text:
    """Render `s` verbatim in Nunito Bold, numbers cream and operators gold.

    The string is never rewritten: what the treatment says is what renders.
    Scaling is by digit height, so every card in a video shares one size.
    """
    # Ligatures off so glyph i is character i (e.g. "fi" in "fingers").
    t = Text(s, font=font, weight=BOLD, color=color, disable_ligatures=True)
    # Pango may or may not emit (empty) submobjects for spaces; support both,
    # and fail loudly on anything else so colouring never lands on the wrong glyph.
    if len(t.submobjects) == len(s):
        glyphs = list(s)
        t.md_spaces_kept = True
    elif len(t.submobjects) == sum(1 for c in s if not c.isspace()):
        glyphs = [c for c in s if not c.isspace()]
        t.md_spaces_kept = False
    else:
        raise AssertionError(f"glyph count mismatch for {s!r}: {len(s)} chars, {len(t.submobjects)} glyphs")
    if operator_color:
        for ch, glyph in zip(glyphs, t.submobjects):
            if ch in OPERATOR_CHARS:
                glyph.set_color(operator_color)
    t.scale(px(digit_px) / _digit_height(font))
    return t


def glyph_span(t: Text, s: str, idx: int, length: int) -> VGroup:
    """The glyphs of `t` (made from `s`) for characters s[idx:idx+length]."""
    return glyphs_for(t, s, s[idx : idx + length], at=idx)


def glyphs_for(t: Text, s: str, sub: str, occurrence: int = 0, at: int | None = None) -> VGroup:
    """The glyphs of `t` (made from `s`) that spell `sub` (nth occurrence)."""
    if at is not None:
        idx = at
    else:
        idx = -1
        for _ in range(occurrence + 1):
            idx = s.index(sub, idx + 1)
    if getattr(t, "md_spaces_kept", False):
        start, n = idx, len(sub)
    else:
        start = sum(1 for c in s[:idx] if not c.isspace())
        n = sum(1 for c in sub if not c.isspace())
    return VGroup(*t.submobjects[start : start + n])


def md_lines(s: str, breaks: list[str], digit_px: float = EQ_DIGIT_PX, **kw) -> VGroup:
    """`s` split into centred lines; the pieces must rejoin to `s` exactly."""
    pieces = []
    rest = s
    for b in breaks:
        i = rest.index(b) + len(b)
        pieces.append(rest[:i].rstrip())
        rest = rest[i:].lstrip()
    pieces.append(rest)
    if " ".join(pieces) != s:
        raise AssertionError(f"line split changed the string: {pieces!r} vs {s!r}")
    return VGroup(*[md_text(p, digit_px=digit_px, **kw) for p in pieces]).arrange(DOWN, buff=px(digit_px * 0.45))


def fit_width(m: Mobject, max_width: float = SAFE_WIDTH * 0.94) -> Mobject:
    if m.width > max_width:
        m.scale_to_fit_width(max_width)
    return m


def title_text(s: str, size_px: float = 90, color: str = GOLD) -> Text:
    """Cinzel Bold for titles and series names only (never numbers)."""
    return md_text(s, digit_px=size_px, color=color, font=CINZEL, operator_color=None)


# ---------------------------------------------------------------------------
# Effects
# ---------------------------------------------------------------------------
def glow(m: Mobject, color: str = EMERALD, widths=(26, 16, 8), opacity: float = 0.3) -> VGroup:
    """Soft stroke halo for `m`. Use MDScene.glow_in so it sits behind `m`."""
    layers = VGroup()
    for w in widths:
        c = m.copy()
        c.set_fill(opacity=0)
        c.set_stroke(color, width=w, opacity=opacity)
        layers.add(c)
    return layers


def strike(m: Mobject, color: str = FIRE_ORANGE, width: float = 14) -> Line:
    """A fire-orange strike-through across `m` (slightly rising)."""
    pad = px(18)
    return Line(
        m.get_left() + LEFT * pad + DOWN * m.height * 0.08,
        m.get_right() + RIGHT * pad + UP * m.height * 0.08,
        color=color,
        stroke_width=width,
    )


def check_mark(size: float = px(90), color: str = GOLD, width: float = 14) -> VMobject:
    v = VMobject(stroke_color=color, stroke_width=width)
    v.set_points_as_corners(
        [LEFT * size * 0.5, DOWN * size * 0.4 + LEFT * size * 0.1, UP * size * 0.5 + RIGHT * size * 0.5]
    )
    return v


def background() -> Rectangle:
    """Full-bleed Deep Void -> Dragon Purple gradient (visual-style §6)."""
    r = Rectangle(width=FRAME_W, height=FRAME_H, stroke_width=0)
    r.set_fill(color=[DEEP_VOID, DRAGON_PURPLE], opacity=1)
    r.set_sheen_direction(UP)
    return r


def safe_zone_guides() -> VGroup:
    safe = Rectangle(width=SAFE_WIDTH, height=SAFE_HEIGHT, stroke_color="#00FFFF", stroke_width=3)
    safe.move_to(SAFE_CENTER)
    band = Rectangle(
        width=SAFE_WIDTH, height=CAPTION_TOP - CAPTION_BOTTOM, stroke_width=0, fill_color="#FF00FF", fill_opacity=0.18
    )
    band.move_to(((CAPTION_TOP + CAPTION_BOTTOM) / 2) * UP)
    label = Text("safe zone / caption band (MD_GUIDES)", font=NUNITO, color="#00FFFF").scale(0.3)
    label.next_to(safe, UP, buff=0.05)
    return VGroup(DashedVMobject(safe, num_dashes=80), band, label)


def guides_enabled() -> bool:
    return os.environ.get("MD_GUIDES", "") not in ("", "0", "false", "no")


class MDScene(Scene):
    """Scene with the Math Dragons background and optional safe-zone guides."""

    def setup(self):
        self.add(background())
        if guides_enabled():
            self.add_foreground_mobject(safe_zone_guides())

    def glow_in(self, m: Mobject, run_time: float = 0.4, **kw) -> VGroup:
        """Fade an emerald halo in *behind* `m` (cream text stays on top)."""
        from manim import FadeIn

        halo = glow(m, **kw)
        self.play(FadeIn(halo), run_time=run_time)
        self.add(m)  # re-adding moves m above the halo
        return halo

    def hold(self, seconds: float = 1.5):
        """Hold the frame (visual-style §6: long enough to read twice)."""
        self.wait(seconds)


class MDOverlayScene(MDScene):
    """No background: rendered with --transparent to lay over footage."""

    def setup(self):
        if guides_enabled():
            self.add_foreground_mobject(safe_zone_guides())


def backing(m: Mobject, pad: float = px(28), opacity: float = 0.72) -> Mobject:
    """Rounded Deep Void plate behind overlay text so it reads over footage."""
    from manim import RoundedRectangle

    r = RoundedRectangle(
        corner_radius=px(24), width=m.width + 2 * pad, height=m.height + 2 * pad,
        stroke_width=0, fill_color=DEEP_VOID, fill_opacity=opacity,
    )
    return r.move_to(m)


# ---------------------------------------------------------------------------
# Self-checks: strings verbatim from the treatment, equations recomputed.
# ---------------------------------------------------------------------------
def treatment_math_strings(video_id: str) -> set[str]:
    """Every backtick string in the treatment's '## Math strings' section."""
    text = (VIDEOS_DIR / video_id / "treatment.md").read_text(encoding="utf-8")
    m = re.search(r"^## Math strings.*?$(.*?)^## ", text, flags=re.S | re.M)
    if not m:
        raise AssertionError(f"{video_id}: no '## Math strings' section")
    return set(re.findall(r"`([^`]+)`", m.group(1)))


def assert_verbatim(video_id: str, strings) -> None:
    """Every string a scene renders must appear verbatim in the treatment."""
    allowed = treatment_math_strings(video_id)
    missing = [s for s in strings if s not in allowed]
    if missing:
        raise AssertionError(f"{video_id}: strings not in treatment Math strings: {missing!r}")


_EXPR_OK = re.compile(r"^[0-9+\-*/(). ]+$")


def _eval(expr: str) -> Fraction:
    e = expr.replace("×", "*").replace("÷", "/").replace("−", "-").strip()
    if not _EXPR_OK.match(e):
        raise AssertionError(f"not a plain arithmetic expression: {expr!r}")
    # Exact rational arithmetic: wrap every integer literal in Fraction.
    e = re.sub(r"(\d+)", r"Fraction(\1)", e)
    return eval(e, {"__builtins__": {}, "Fraction": Fraction})  # noqa: S307 (sanitised above)


def check_equation(s: str) -> Fraction:
    """Assert every side of an `a = b = c` chain is equal; return the value."""
    sides = [p for p in s.split("=")]
    if len(sides) < 2:
        raise AssertionError(f"no '=' in {s!r}")
    values = [_eval(p) for p in sides]
    if len(set(values)) != 1:
        raise AssertionError(f"equation false: {s!r} -> {values}")
    return values[0]
