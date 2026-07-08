"""Google Gemini / Nano Banana image generation wrapper.

Used by the Track A accessory pipeline (see
docs/step12/ACCESSORY_PIPELINE_DECISION.md): render a dragon *wearing* an
accessory from the exact base-dragon reference so the model produces correct
3/4 perspective and horn occlusion, then diff-extract a registered layer.

Nano Banana Pro (`gemini-3-pro-image`) is the default for finals;
`gemini-3.1-flash-lite-image` is the cheap workhorse for iteration.
"""

import os
import pathlib
from io import BytesIO

from PIL import Image

# Model ids (verified available on this key 2026-07-07).
NANO_BANANA_PRO = "gemini-3-pro-image"
NANO_BANANA_LITE = "gemini-3.1-flash-lite-image"


def _load_env() -> None:
    """Populate os.environ from tools/asset_generator/.env if not already set."""
    env_path = pathlib.Path(__file__).with_name(".env")
    if not env_path.exists():
        return
    for line in env_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip())


def _client():
    _load_env()
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise RuntimeError("GEMINI_API_KEY is not set (tools/asset_generator/.env)")
    from google import genai  # imported lazily so non-Gemini tooling still runs

    return genai.Client(api_key=api_key)


def edit_image(
    prompt: str,
    reference_images: list[str | Image.Image] | None = None,
    model: str = NANO_BANANA_PRO,
) -> Image.Image:
    """Run an in-context image edit/generation.

    Passes the reference image(s) plus the instruction; returns the first image
    part of the response as a PIL RGBA Image. Raises if the model returns no
    image (its text, if any, is included in the error to aid debugging).
    """
    from google.genai import types

    client = _client()

    contents: list = [prompt]
    for ref in reference_images or []:
        img = Image.open(ref) if isinstance(ref, (str, pathlib.Path)) else ref
        contents.append(img.convert("RGBA"))

    response = client.models.generate_content(
        model=model,
        contents=contents,
        config=types.GenerateContentConfig(response_modalities=["IMAGE"]),
    )

    candidates = response.candidates or []
    if not candidates:
        raise RuntimeError(
            f"Model {model} returned no candidates "
            f"(prompt_feedback={getattr(response, 'prompt_feedback', None)})"
        )
    candidate = candidates[0]
    content = getattr(candidate, "content", None)
    parts = getattr(content, "parts", None) or []

    texts: list[str] = []
    for part in parts:
        if getattr(part, "inline_data", None) and part.inline_data.data:
            return Image.open(BytesIO(part.inline_data.data)).convert("RGBA")
        if getattr(part, "text", None):
            texts.append(part.text)

    raise RuntimeError(
        f"Model {model} returned no image "
        f"(finish_reason={getattr(candidate, 'finish_reason', None)}). "
        f"Text: {' '.join(texts)[:500] or '(none)'}"
    )
