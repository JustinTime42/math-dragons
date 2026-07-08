#!/usr/bin/env python3
"""Generate pose-pipeline sample assets from pose_sample_prompts.json."""

import json
import subprocess
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
PROMPTS_PATH = PROJECT_ROOT / "tools/asset_generator/pose_sample_prompts.json"
CLI_PATH = PROJECT_ROOT / "tools/asset_generator/cli.py"


def main() -> int:
    manifest = json.loads(PROMPTS_PATH.read_text())
    samples = manifest["samples"]
    global_refs = manifest.get("style_refs", [])

    for sample in samples:
        output = sample["output"]
        prompt = sample["prompt"]
        refs = _existing_refs(sample.get("refs", []) + global_refs)
        command = [
            sys.executable,
            str(CLI_PATH),
            "image",
            prompt,
            "-o",
            output,
            "-s",
            manifest.get("canvas", "1024x1024"),
            "-q",
            "high",
        ]
        if refs:
            command.extend(["-r", *refs])

        print(f"Generating {sample['asset_id']} -> {output}")
        if refs:
            print("  refs: " + ", ".join(refs))
        subprocess.run(command, cwd=PROJECT_ROOT, check=True)

    return 0


def _existing_refs(paths: list[str]) -> list[str]:
    refs = []
    for path in paths:
        ref_path = PROJECT_ROOT / path
        if ref_path.exists():
            refs.append(path)
    return refs[:5]


if __name__ == "__main__":
    raise SystemExit(main())
