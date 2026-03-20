"""Image post-processing: background removal, resize, density variants, compression."""

import os
import shutil
import subprocess
from pathlib import Path

from PIL import Image


def remove_background(input_path: str, output_path: str | None = None) -> dict:
    """Remove background from an image using rembg.

    Args:
        input_path: Source image path.
        output_path: Destination path. Defaults to overwriting input.

    Returns:
        Dict with 'path' and 'size_bytes' keys.
    """
    from rembg import remove

    inp = Path(input_path)
    out = Path(output_path) if output_path else inp

    img = Image.open(inp)
    result = remove(img)
    result.save(out, format="PNG")

    return {"path": str(out), "size_bytes": out.stat().st_size}


def resize_image(
    input_path: str,
    target_size: str,
    output_dir: str,
    densities: list[float] | None = None,
    output_format: str = "png",
) -> list[dict]:
    """Resize image to target display size and optionally generate density variants.

    Args:
        input_path: Source image path.
        target_size: Display size as "WxH" (e.g., "64x64").
        output_dir: Base output directory.
        densities: Density multipliers (e.g., [1.0, 1.5, 2.0, 3.0, 4.0]).
        output_format: Output format ("png" or "webp").

    Returns:
        List of dicts with 'path', 'density', 'width', 'height' keys.
    """
    if densities is None:
        densities = [1.0]

    inp = Path(input_path)
    out_dir = Path(output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    tw, th = [int(x) for x in target_size.split("x")]
    img = Image.open(inp)

    # Preserve alpha channel
    if img.mode != "RGBA":
        img = img.convert("RGBA")

    results = []
    for density in densities:
        w = round(tw * density)
        h = round(th * density)
        resized = img.resize((w, h), Image.LANCZOS)

        if density == 1.0:
            dest = out_dir / f"{inp.stem}.{output_format}"
        else:
            density_dir = out_dir / f"{density}x"
            density_dir.mkdir(parents=True, exist_ok=True)
            dest = density_dir / f"{inp.stem}.{output_format}"

        save_kwargs = {"format": output_format.upper()}
        if output_format == "png":
            save_kwargs["optimize"] = True
        resized.save(dest, **save_kwargs)

        results.append({
            "path": str(dest),
            "density": density,
            "width": w,
            "height": h,
        })

    return results


def compress_png(
    input_path: str,
    quality: str = "80-95",
    recursive: bool = False,
) -> dict:
    """Compress PNG file(s) with pngquant.

    Args:
        input_path: PNG file or directory.
        quality: pngquant quality range (e.g., "80-95").
        recursive: If True and input is a directory, process recursively.

    Returns:
        Dict with 'original_bytes', 'compressed_bytes', 'savings_percent',
        and 'files_processed' keys.
    """
    pngquant = shutil.which("pngquant")
    if not pngquant:
        raise RuntimeError(
            "pngquant not found. Install with: scoop install pngquant"
        )

    inp = Path(input_path)
    files: list[Path] = []

    if inp.is_file():
        files = [inp]
    elif inp.is_dir():
        pattern = "**/*.png" if recursive else "*.png"
        files = list(inp.glob(pattern))
    else:
        raise FileNotFoundError(f"Path not found: {input_path}")

    if not files:
        return {
            "original_bytes": 0,
            "compressed_bytes": 0,
            "savings_percent": 0.0,
            "files_processed": 0,
        }

    original_total = sum(f.stat().st_size for f in files)

    for f in files:
        subprocess.run(
            [pngquant, f"--quality={quality}", "--force", "--ext", ".png", str(f)],
            check=False,
            capture_output=True,
        )

    compressed_total = sum(f.stat().st_size for f in files if f.exists())
    savings = (
        (1 - compressed_total / original_total) * 100
        if original_total > 0
        else 0.0
    )

    return {
        "original_bytes": original_total,
        "compressed_bytes": compressed_total,
        "savings_percent": round(savings, 1),
        "files_processed": len(files),
    }


def post_process_asset(
    input_path: str,
    output_path: str,
    target_size: str,
    remove_bg: bool = True,
    create_densities: bool = False,
    compress_quality: str = "80-95",
) -> dict:
    """Full post-processing pipeline: remove bg -> resize -> compress.

    Args:
        input_path: Raw generated image.
        output_path: Final asset location.
        target_size: Display size as "WxH".
        remove_bg: Whether to run rembg.
        create_densities: Whether to create density variants (for UI icons).
        compress_quality: pngquant quality range.

    Returns:
        Dict with 'path', 'size_bytes', and 'steps' keys.
    """
    steps = []
    current = input_path

    # Step 1: Background removal
    if remove_bg:
        bg_result = remove_background(current)
        current = bg_result["path"]
        steps.append({"step": "remove_background", "result": bg_result})

    # Step 2: Resize
    out = Path(output_path)
    out.parent.mkdir(parents=True, exist_ok=True)

    densities = [1.0, 1.5, 2.0, 3.0, 4.0] if create_densities else [1.0]
    resize_results = resize_image(
        current, target_size, str(out.parent), densities=densities
    )
    steps.append({"step": "resize", "result": resize_results})

    # The 1x variant is the main output — rename to match output_path
    main_file = Path(resize_results[0]["path"])
    if main_file != out:
        shutil.move(str(main_file), str(out))
        resize_results[0]["path"] = str(out)

    # Step 3: Compress all generated PNGs
    compress_result = compress_png(str(out), quality=compress_quality)
    steps.append({"step": "compress", "result": compress_result})

    # Also compress density variants if created
    if create_densities:
        for r in resize_results[1:]:
            compress_png(r["path"], quality=compress_quality)

    final_size = out.stat().st_size if out.exists() else 0

    return {
        "path": str(out),
        "size_bytes": final_size,
        "steps": steps,
    }
