#!/usr/bin/env python3
"""Render a video's Manim math cards into ~/Videos/math-dragons/MD-###/math/.

Usage (from anywhere, with the production venv):
    marketing/production/.venv/bin/python marketing/production/manim/render.py MD-004
    ... render.py MD-004 -q h                 # final: 1080x1920, 30 fps
    ... render.py MD-004 --guides             # draw safe-zone guides (preview only)
    ... render.py MD-009 -s FoldSevenOverlay  # one scene

Quality l (default) writes previews to math/preview/<Scene>.mp4 (480x854, 15 fps).
Quality h writes masters to math/<Scene>.mp4 (1080x1920, 30 fps).
Scenes derived from MDOverlayScene render with a transparent background
(.mov, ProRes 4444 with alpha) for laying over hands or gameplay footage.

The script's assert-based self-check runs at import, so a wrong equation or a
string that drifted from the treatment stops the render before any frame.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
VENV_MANIM = HERE.parent / ".venv" / "bin" / "manim"
MEDIA_ROOT = Path.home() / "Videos" / "math-dragons"


def scene_classes(script: Path) -> tuple[list[str], list[str]]:
    src = script.read_text(encoding="utf-8")
    normal = re.findall(r"^class (\w+)\(MDScene\)", src, flags=re.M)
    overlay = re.findall(r"^class (\w+)\(MDOverlayScene\)", src, flags=re.M)
    return normal, overlay


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("video", help="video id, e.g. MD-004")
    ap.add_argument("-q", "--quality", choices=["l", "m", "h"], default="l")
    ap.add_argument("-s", "--scene", action="append", help="scene class to render (repeatable); default all")
    ap.add_argument("--guides", action="store_true", help="overlay safe-zone guides (never ship these)")
    args = ap.parse_args()

    script = HERE / f"{args.video}.py"
    if not script.exists():
        print(f"no script: {script}", file=sys.stderr)
        return 2
    normal, overlay = scene_classes(script)
    if args.scene:
        unknown = set(args.scene) - set(normal) - set(overlay)
        if unknown:
            print(f"unknown scene(s): {sorted(unknown)}", file=sys.stderr)
            return 2
        normal = [s for s in normal if s in args.scene]
        overlay = [s for s in overlay if s in args.scene]

    out_dir = MEDIA_ROOT / args.video / "math"
    if args.quality != "h":
        out_dir = out_dir / "preview"
    if args.guides:
        out_dir = out_dir / "guides"
    work = MEDIA_ROOT / args.video / "math" / ".manim"
    out_dir.mkdir(parents=True, exist_ok=True)

    env = dict(os.environ)
    env["PYTHONPATH"] = str(HERE) + os.pathsep + env.get("PYTHONPATH", "")
    if args.guides:
        env["MD_GUIDES"] = "1"

    for scenes, transparent in ((normal, False), (overlay, True)):
        if not scenes:
            continue
        cmd = [str(VENV_MANIM), "render", f"-q{args.quality}", "--media_dir", str(work), "--disable_caching"]
        if transparent:
            cmd.append("--transparent")
        cmd += [str(script), *scenes]
        print("+", " ".join(cmd), flush=True)
        r = subprocess.run(cmd, env=env, cwd=HERE)
        if r.returncode != 0:
            return r.returncode
        for name in scenes:
            hits = sorted((work / "videos").rglob(f"{name}.mov" if transparent else f"{name}.mp4"),
                          key=lambda p: p.stat().st_mtime)
            if not hits:
                print(f"render missing for {name}", file=sys.stderr)
                return 1
            dest = out_dir / hits[-1].name
            shutil.copy2(hits[-1], dest)
            print(f"-> {dest}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
