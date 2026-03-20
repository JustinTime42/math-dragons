"""MCP server for Math Dragons asset generation pipeline.

Provides tools for generating images (OpenAI GPT-Image-1), sound effects
(ElevenLabs), and post-processing (rembg, Pillow, pngquant).
"""

import os
import sys
from pathlib import Path

# Add this directory to sys.path so local module imports work
sys.path.insert(0, str(Path(__file__).parent))

from dotenv import load_dotenv
from fastmcp import FastMCP

# Load .env from DOTENV_PATH or default location
dotenv_path = os.environ.get("DOTENV_PATH")
if dotenv_path:
    load_dotenv(Path(dotenv_path))
else:
    load_dotenv(Path(__file__).parent / ".env")

# Resolve project root (math_dragons/) for relative paths
PROJECT_ROOT = Path(__file__).parent.parent.parent

mcp = FastMCP(name="Math Dragons Asset Generator")


def _resolve(path: str) -> str:
    """Resolve a relative path against the project root."""
    p = Path(path)
    if not p.is_absolute():
        p = PROJECT_ROOT / p
    return str(p)


# ---------------------------------------------------------------------------
# Tool 1: generate_style_candidates
# ---------------------------------------------------------------------------
@mcp.tool
def generate_style_candidates(
    prompt: str,
    count: int = 4,
    output_dir: str = "assets/style_bible/candidates",
    quality: str = "medium",
) -> list[dict]:
    """Generate style exploration candidate images for the style bible.

    Args:
        prompt: Style exploration prompt describing the desired art style.
        count: Number of variations to generate (1-10).
        output_dir: Directory to save candidates (relative to math_dragons/).
        quality: Image quality — "low", "medium", or "high".
    """
    from image_gen import generate_candidates

    return generate_candidates(
        prompt=prompt,
        count=min(count, 10),
        output_dir=_resolve(output_dir),
        quality=quality,
    )


# ---------------------------------------------------------------------------
# Tool 2: generate_image
# ---------------------------------------------------------------------------
@mcp.tool
def generate_image(
    prompt: str,
    output_path: str,
    style_refs: list[str] | None = None,
    size: str = "1024x1024",
    transparent: bool = True,
    quality: str = "high",
    variations: int = 1,
) -> list[dict]:
    """Generate a game asset image with optional style reference images.

    Uses OpenAI GPT-Image-1. When style_refs are provided, the model matches
    the visual style of those reference images.

    Args:
        prompt: Asset-specific prompt describing what to generate.
        output_path: Where to save the result (relative to math_dragons/).
        style_refs: Paths to style bible reference images (max 5).
        size: Generation size — "1024x1024", "1024x1536", "1536x1024", or "auto".
        transparent: Whether to request a transparent background.
        quality: Image quality — "low", "medium", or "high".
        variations: Number of variations to generate (1-10).
    """
    from image_gen import generate_image as _generate

    resolved_refs = None
    if style_refs:
        resolved_refs = [_resolve(r) for r in style_refs]

    return _generate(
        prompt=prompt,
        output_path=_resolve(output_path),
        style_refs=resolved_refs,
        size=size,
        transparent=transparent,
        quality=quality,
        variations=min(variations, 10),
    )


# ---------------------------------------------------------------------------
# Tool 3: generate_sfx
# ---------------------------------------------------------------------------
@mcp.tool
def generate_sfx(
    description: str,
    output_path: str,
    duration: float | None = None,
    loop: bool = False,
    prompt_influence: float = 0.3,
) -> dict:
    """Generate a sound effect via ElevenLabs text-to-sound-effects.

    Args:
        description: What the sound should be (e.g., "Short magical chime,
            bright and rewarding, suitable for a children's game").
        output_path: Where to save the audio (relative to math_dragons/).
        duration: Duration in seconds (0.5-30), or null for auto.
        loop: Whether to create a seamless loop.
        prompt_influence: How closely to follow the prompt (0.0-1.0).
    """
    from sfx_gen import generate_sfx as _generate

    return _generate(
        description=description,
        output_path=_resolve(output_path),
        duration=duration,
        loop=loop,
        prompt_influence=prompt_influence,
    )


# ---------------------------------------------------------------------------
# Tool 4: remove_background
# ---------------------------------------------------------------------------
@mcp.tool
def remove_background(
    input_path: str,
    output_path: str | None = None,
) -> dict:
    """Remove background from an image using rembg (AI-based).

    Args:
        input_path: Source image path (relative to math_dragons/).
        output_path: Destination path. Defaults to overwriting input.
    """
    from post_process import remove_background as _remove

    return _remove(
        input_path=_resolve(input_path),
        output_path=_resolve(output_path) if output_path else None,
    )


# ---------------------------------------------------------------------------
# Tool 5: resize_image
# ---------------------------------------------------------------------------
@mcp.tool
def resize_image(
    input_path: str,
    target_size: str,
    output_dir: str,
    densities: list[float] | None = None,
    output_format: str = "png",
) -> list[dict]:
    """Resize image to target display size and generate density variants.

    Args:
        input_path: Source image (relative to math_dragons/).
        target_size: Display size as "WxH" (e.g., "64x64").
        output_dir: Base output directory (relative to math_dragons/).
        densities: Density multipliers (e.g., [1.0, 1.5, 2.0, 3.0, 4.0]).
            Defaults to [1.0] (no density variants).
        output_format: Output format — "png" or "webp".
    """
    from post_process import resize_image as _resize

    return _resize(
        input_path=_resolve(input_path),
        target_size=target_size,
        output_dir=_resolve(output_dir),
        densities=densities,
        output_format=output_format,
    )


# ---------------------------------------------------------------------------
# Tool 6: compress_png
# ---------------------------------------------------------------------------
@mcp.tool
def compress_png(
    input_path: str,
    quality: str = "80-95",
    recursive: bool = False,
) -> dict:
    """Compress PNG file(s) with pngquant for smaller file sizes.

    Args:
        input_path: PNG file or directory (relative to math_dragons/).
        quality: pngquant quality range (e.g., "80-95").
        recursive: If true and input is a directory, process all PNGs recursively.
    """
    from post_process import compress_png as _compress

    return _compress(
        input_path=_resolve(input_path),
        quality=quality,
        recursive=recursive,
    )


# ---------------------------------------------------------------------------
# Tool 7: post_process_asset
# ---------------------------------------------------------------------------
@mcp.tool
def post_process_asset(
    input_path: str,
    output_path: str,
    target_size: str,
    remove_bg: bool = True,
    create_densities: bool = False,
    compress_quality: str = "80-95",
) -> dict:
    """Full post-processing pipeline: remove background → resize → compress.

    Chains all post-processing steps for a single asset in one call.

    Args:
        input_path: Raw generated image (relative to math_dragons/).
        output_path: Final asset location (relative to math_dragons/).
        target_size: Display size as "WxH" (e.g., "64x64").
        remove_bg: Whether to run AI background removal.
        create_densities: Whether to create 1.5x/2x/3x/4x density variants.
        compress_quality: pngquant quality range.
    """
    from post_process import post_process_asset as _process

    return _process(
        input_path=_resolve(input_path),
        output_path=_resolve(output_path),
        target_size=target_size,
        remove_bg=remove_bg,
        create_densities=create_densities,
        compress_quality=compress_quality,
    )


# ---------------------------------------------------------------------------
# Tool 8: list_generated_assets
# ---------------------------------------------------------------------------
@mcp.tool
def list_generated_assets(
    asset_dir: str = "assets/images",
    manifest_path: str | None = None,
) -> dict:
    """Show status of generated assets vs. the expected manifest.

    Scans asset directories and compares against the manifest to report
    which assets exist and which are missing.

    Args:
        asset_dir: Directory to scan (relative to math_dragons/).
        manifest_path: Path to manifest.json for expected file comparison.
    """
    from manifest import list_generated_assets as _list

    return _list(
        asset_dir=_resolve(asset_dir),
        manifest_path=_resolve(manifest_path) if manifest_path else None,
    )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    mcp.run()
