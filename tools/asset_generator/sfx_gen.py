"""ElevenLabs SFX generation wrapper."""

import os
from pathlib import Path

from elevenlabs.client import ElevenLabs


def _get_client() -> ElevenLabs:
    api_key = os.environ.get("ELEVENLABS_API_KEY")
    if not api_key:
        raise RuntimeError("ELEVENLABS_API_KEY environment variable is not set")
    return ElevenLabs(api_key=api_key)


def generate_sfx(
    description: str,
    output_path: str,
    duration: float | None = None,
    loop: bool = False,
    prompt_influence: float = 0.3,
) -> dict:
    """Generate a sound effect from a text description.

    Args:
        description: What the sound should be.
        output_path: Where to save the audio file.
        duration: Duration in seconds (0.5-30), or None for auto.
        loop: Whether to create a seamless loop.
        prompt_influence: How closely to follow the prompt (0-1).

    Returns:
        Dict with 'path' and 'size_bytes' keys.
    """
    client = _get_client()
    out = Path(output_path)
    out.parent.mkdir(parents=True, exist_ok=True)

    kwargs: dict = {
        "text": description,
        "output_format": "mp3_44100_128",
        "prompt_influence": prompt_influence,
    }
    if duration is not None:
        kwargs["duration_seconds"] = duration
    if loop:
        kwargs["loop"] = True

    audio_iter = client.text_to_sound_effects.convert(**kwargs)

    # Collect all chunks
    audio_data = b"".join(audio_iter)
    out.write_bytes(audio_data)

    return {
        "path": str(out),
        "size_bytes": len(audio_data),
    }
