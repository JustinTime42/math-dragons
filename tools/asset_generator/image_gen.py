"""OpenAI GPT-Image-1 wrapper for generating game assets with style references."""

import base64
import os
import time
from pathlib import Path

from openai import OpenAI


def _get_client() -> OpenAI:
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        raise RuntimeError("OPENAI_API_KEY environment variable is not set")
    return OpenAI(api_key=api_key)


def generate_candidates(
    prompt: str,
    count: int = 4,
    output_dir: str = "assets/style_bible/candidates",
    quality: str = "medium",
) -> list[dict]:
    """Generate style exploration candidate images.

    Returns list of dicts with 'path' and 'index' keys.
    """
    client = _get_client()
    out = Path(output_dir)
    out.mkdir(parents=True, exist_ok=True)

    result = client.images.generate(
        model="gpt-image-1",
        prompt=prompt,
        n=count,
        size="1024x1024",
        quality=quality,
    )

    timestamp = int(time.time())
    generated = []
    for i, img_data in enumerate(result.data):
        image_bytes = base64.b64decode(img_data.b64_json)
        filename = f"candidate_{timestamp}_{i}.png"
        filepath = out / filename
        filepath.write_bytes(image_bytes)
        generated.append({"path": str(filepath), "index": i})

    return generated


def generate_image(
    prompt: str,
    output_path: str,
    style_refs: list[str] | None = None,
    size: str = "1024x1024",
    transparent: bool = True,
    quality: str = "high",
    variations: int = 1,
) -> list[dict]:
    """Generate a game asset image, optionally with style reference images.

    If style_refs are provided, uses images.edit() to pass them as reference.
    Otherwise uses images.generate().

    Returns list of dicts with 'path' key for each generated image.
    """
    client = _get_client()
    out_path = Path(output_path)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    if style_refs:
        # Use edit endpoint to pass reference images for style consistency
        style_prompt = (
            "Match the visual style of the provided reference images exactly. "
            "Use the same line weight, color palette, shading technique, and "
            "level of detail. "
        ) + prompt

        ref_files = []
        try:
            for ref_path in style_refs[:5]:
                ref_files.append(open(ref_path, "rb"))

            generated = []
            for v in range(variations):
                result = client.images.edit(
                    model="gpt-image-1",
                    image=ref_files,
                    prompt=style_prompt,
                    size=size,
                    quality=quality,
                    background="transparent" if transparent else "opaque",
                    output_format="png",
                )

                image_bytes = base64.b64decode(result.data[0].b64_json)
                if variations > 1:
                    stem = out_path.stem
                    vpath = out_path.with_stem(f"{stem}_v{v + 1}")
                    vpath.write_bytes(image_bytes)
                    generated.append({"path": str(vpath)})
                else:
                    out_path.write_bytes(image_bytes)
                    generated.append({"path": str(out_path)})

            return generated
        finally:
            for f in ref_files:
                f.close()
    else:
        # No style refs — use generate endpoint (supports n > 1)
        result = client.images.generate(
            model="gpt-image-1",
            prompt=prompt,
            n=variations,
            size=size,
            quality=quality,
            background="transparent" if transparent else "opaque",
        )

        generated = []
        for i, img_data in enumerate(result.data):
            image_bytes = base64.b64decode(img_data.b64_json)
            if variations > 1:
                stem = out_path.stem
                vpath = out_path.with_stem(f"{stem}_v{i + 1}")
                vpath.write_bytes(image_bytes)
                generated.append({"path": str(vpath)})
            else:
                out_path.write_bytes(image_bytes)
                generated.append({"path": str(out_path)})

        return generated
