"""Every math-card script's import-time self-check passes.

Importing a script runs its asserts: each string is verbatim in the
treatment's "Math strings" section and each equation recomputes. A treatment
edit that changes a string makes this fail until the script is updated.
"""

import importlib.util
import sys
from pathlib import Path

import pytest

MANIM_DIR = Path(__file__).resolve().parents[1] / "manim"
sys.path.insert(0, str(MANIM_DIR))
SCRIPTS = sorted(MANIM_DIR.glob("MD-*.py"))


def test_scripts_exist():
    assert {p.stem for p in SCRIPTS} >= {"MD-004", "MD-006", "MD-007", "MD-009", "MD-012"}


@pytest.mark.parametrize("path", SCRIPTS, ids=lambda p: p.stem)
def test_self_check(path):
    spec = importlib.util.spec_from_file_location(path.stem.replace("-", "_"), path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)  # raises AssertionError on any drift


def test_check_equation_catches_wrong_math():
    import md_style

    assert md_style.check_equation("9 × 7 = 70 − 7 = 63") == 63
    with pytest.raises(AssertionError):
        md_style.check_equation("9 × 7 = 64")
    with pytest.raises(AssertionError):
        md_style.check_equation("import os = 1")
