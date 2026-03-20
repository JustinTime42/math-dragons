#!/usr/bin/env python3
"""CLI wrapper for Math Dragons asset generation tools.

Provides clean command-line access to image generation (OpenAI),
sound effects (ElevenLabs), and post-processing (rembg, Pillow, pngquant).

Usage:
    python tools/asset_generator/cli.py <command> [options]

Commands:
    image              Generate a game image via OpenAI GPT-Image-1
    style-candidates   Generate style bible exploration images
    sfx                Generate a sound effect via ElevenLabs
    remove-bg          Remove image background using rembg
    resize             Resize image with optional density variants
    compress           Compress PNG(s) with pngquant
    post-process       Full pipeline: remove bg -> resize -> compress
    list-assets        Report asset status vs. manifest
"""

import argparse
import json
import os
import sys
from pathlib import Path

# Setup: add tools dir to path, load .env
TOOLS_DIR = Path(__file__).parent
sys.path.insert(0, str(TOOLS_DIR))

from dotenv import load_dotenv
load_dotenv(TOOLS_DIR / ".env")

PROJECT_ROOT = TOOLS_DIR.parent.parent


def resolve(path: str) -> str:
    """Resolve a relative path against the project root."""
    p = Path(path)
    if not p.is_absolute():
        p = PROJECT_ROOT / p
    return str(p)


def cmd_image(args):
    from image_gen import generate_image
    style_refs = None
    if args.style_refs:
        style_refs = [resolve(r) for r in args.style_refs]
    result = generate_image(
        prompt=args.prompt,
        output_path=resolve(args.output),
        style_refs=style_refs,
        size=args.size,
        transparent=not args.opaque,
        quality=args.quality,
        variations=args.variations,
    )
    print(json.dumps(result, indent=2))


def cmd_style_candidates(args):
    from image_gen import generate_candidates
    result = generate_candidates(
        prompt=args.prompt,
        count=args.count,
        output_dir=resolve(args.output_dir),
        quality=args.quality,
    )
    print(json.dumps(result, indent=2))


def cmd_sfx(args):
    from sfx_gen import generate_sfx
    result = generate_sfx(
        description=args.description,
        output_path=resolve(args.output),
        duration=args.duration,
        loop=args.loop,
        prompt_influence=args.prompt_influence,
    )
    print(json.dumps(result, indent=2))


def cmd_remove_bg(args):
    from post_process import remove_background
    result = remove_background(
        input_path=resolve(args.input),
        output_path=resolve(args.output) if args.output else None,
    )
    print(json.dumps(result, indent=2))


def cmd_resize(args):
    from post_process import resize_image
    densities = None
    if args.densities:
        densities = [float(d) for d in args.densities.split(",")]
    result = resize_image(
        input_path=resolve(args.input),
        target_size=args.size,
        output_dir=resolve(args.output_dir),
        densities=densities,
        output_format=args.format,
    )
    print(json.dumps(result, indent=2))


def cmd_compress(args):
    from post_process import compress_png
    result = compress_png(
        input_path=resolve(args.input),
        quality=args.quality,
        recursive=args.recursive,
    )
    print(json.dumps(result, indent=2))


def cmd_post_process(args):
    from post_process import post_process_asset
    result = post_process_asset(
        input_path=resolve(args.input),
        output_path=resolve(args.output),
        target_size=args.size,
        remove_bg=not args.keep_bg,
        create_densities=args.densities,
        compress_quality=args.quality,
    )
    print(json.dumps(result, indent=2))


def cmd_list_assets(args):
    from manifest import list_generated_assets
    result = list_generated_assets(
        asset_dir=resolve(args.dir),
        manifest_path=resolve(args.manifest) if args.manifest else None,
    )
    print(json.dumps(result, indent=2))


def main():
    parser = argparse.ArgumentParser(
        description="Math Dragons asset generation CLI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="command", required=True)

    # --- image ---
    p = sub.add_parser("image", help="Generate a game image (OpenAI GPT-Image-1)")
    p.add_argument("prompt", help="What to generate")
    p.add_argument("-o", "--output", required=True, help="Output path (relative to math_dragons/)")
    p.add_argument("-r", "--style-refs", nargs="*", help="Style reference image paths (max 5)")
    p.add_argument("-s", "--size", default="1024x1024",
                   choices=["1024x1024", "1024x1536", "1536x1024", "auto"])
    p.add_argument("--opaque", action="store_true", help="Opaque background (default: transparent)")
    p.add_argument("-q", "--quality", default="high", choices=["low", "medium", "high"])
    p.add_argument("-v", "--variations", type=int, default=1, help="Number of variations (1-10)")
    p.set_defaults(func=cmd_image)

    # --- style-candidates ---
    p = sub.add_parser("style-candidates", help="Generate style bible candidates")
    p.add_argument("prompt", help="Style exploration prompt")
    p.add_argument("-n", "--count", type=int, default=4, help="Number of candidates (1-10)")
    p.add_argument("-o", "--output-dir", default="assets/style_bible/candidates")
    p.add_argument("-q", "--quality", default="medium", choices=["low", "medium", "high"])
    p.set_defaults(func=cmd_style_candidates)

    # --- sfx ---
    p = sub.add_parser("sfx", help="Generate a sound effect (ElevenLabs)")
    p.add_argument("description", help="What the sound should be")
    p.add_argument("-o", "--output", required=True, help="Output path (relative to math_dragons/)")
    p.add_argument("-d", "--duration", type=float, help="Duration in seconds (0.5-30, or omit for auto)")
    p.add_argument("--loop", action="store_true", help="Create seamless loop")
    p.add_argument("--prompt-influence", type=float, default=0.3, help="Prompt influence (0.0-1.0)")
    p.set_defaults(func=cmd_sfx)

    # --- remove-bg ---
    p = sub.add_parser("remove-bg", help="Remove image background (rembg)")
    p.add_argument("input", help="Source image path")
    p.add_argument("-o", "--output", help="Output path (default: overwrite input)")
    p.set_defaults(func=cmd_remove_bg)

    # --- resize ---
    p = sub.add_parser("resize", help="Resize image with optional density variants")
    p.add_argument("input", help="Source image path")
    p.add_argument("-s", "--size", required=True, help='Target display size "WxH" (e.g. 64x64)')
    p.add_argument("-o", "--output-dir", required=True, help="Output directory")
    p.add_argument("-d", "--densities", help="Comma-separated density multipliers (e.g. 1.0,1.5,2.0,3.0,4.0)")
    p.add_argument("-f", "--format", default="png", choices=["png", "webp"])
    p.set_defaults(func=cmd_resize)

    # --- compress ---
    p = sub.add_parser("compress", help="Compress PNG(s) with pngquant")
    p.add_argument("input", help="PNG file or directory")
    p.add_argument("-q", "--quality", default="80-95", help='pngquant quality range (e.g. "80-95")')
    p.add_argument("-r", "--recursive", action="store_true", help="Process directory recursively")
    p.set_defaults(func=cmd_compress)

    # --- post-process ---
    p = sub.add_parser("post-process", help="Full pipeline: remove bg -> resize -> compress")
    p.add_argument("input", help="Raw generated image")
    p.add_argument("-o", "--output", required=True, help="Final asset path")
    p.add_argument("-s", "--size", required=True, help='Target display size "WxH"')
    p.add_argument("--keep-bg", action="store_true", help="Skip background removal")
    p.add_argument("-d", "--densities", action="store_true", help="Create 1.5x/2x/3x/4x density variants")
    p.add_argument("-q", "--quality", default="80-95", help="Compress quality range")
    p.set_defaults(func=cmd_post_process)

    # --- list-assets ---
    p = sub.add_parser("list-assets", help="Report asset status vs. manifest")
    p.add_argument("--dir", default="assets/images", help="Directory to scan")
    p.add_argument("--manifest", help="Path to manifest.json for comparison")
    p.set_defaults(func=cmd_list_assets)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
