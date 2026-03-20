"""Asset manifest loader and status reporter."""

import json
from pathlib import Path


def load_manifest(manifest_path: str) -> list[dict]:
    """Load the asset manifest JSON.

    Returns list of asset definitions.
    """
    p = Path(manifest_path)
    if not p.exists():
        raise FileNotFoundError(f"Manifest not found: {manifest_path}")
    with open(p) as f:
        return json.load(f)


def save_manifest(manifest_path: str, assets: list[dict]) -> None:
    """Save asset definitions to a JSON manifest."""
    p = Path(manifest_path)
    p.parent.mkdir(parents=True, exist_ok=True)
    with open(p, "w") as f:
        json.dump(assets, f, indent=2)


def list_generated_assets(
    asset_dir: str = "assets/images",
    manifest_path: str | None = None,
) -> dict:
    """Report status of generated assets vs. expected manifest.

    Args:
        asset_dir: Directory to scan for existing assets.
        manifest_path: Optional path to manifest.json for comparing expected vs found.

    Returns:
        Dict with 'found', 'missing', 'total', 'found_files', and 'missing_files' keys.
    """
    base = Path(asset_dir)

    # Scan what exists on disk
    found_files = set()
    if base.exists():
        for ext in ("*.png", "*.jpg", "*.webp"):
            for f in base.rglob(ext):
                found_files.add(str(f.relative_to(base)))

    # If manifest provided, compare against expected files
    if manifest_path:
        manifest = load_manifest(manifest_path)
        expected = set()
        for asset in manifest:
            out_dir = asset.get("output_dir", "")
            filename = asset.get("filename", "")
            if out_dir and filename:
                # Make relative to asset_dir
                full = Path(out_dir) / filename
                try:
                    rel = str(full.relative_to(base))
                except ValueError:
                    rel = str(full)
                expected.add(rel)

        missing = expected - found_files
        found_expected = expected & found_files

        return {
            "found": len(found_expected),
            "missing": len(missing),
            "total": len(expected),
            "extra": len(found_files - expected),
            "found_files": sorted(found_expected),
            "missing_files": sorted(missing),
        }
    else:
        return {
            "found": len(found_files),
            "missing": 0,
            "total": len(found_files),
            "extra": 0,
            "found_files": sorted(found_files),
            "missing_files": [],
        }
