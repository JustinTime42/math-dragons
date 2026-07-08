#!/usr/bin/env python3
"""Generate review assets for the posed dragon/accessory pipeline.

This writes to assets/images/dragons/posed/raw/ by default and does not replace
the production app assets. Generate, review, calibrate, then wire approved files
into DragonAssets in a separate step.
"""

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


PROJECT_ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = PROJECT_ROOT / "tools/asset_generator/posed_asset_manifest.json"
CLI_PATH = PROJECT_ROOT / "tools/asset_generator/cli.py"


@dataclass(frozen=True)
class Job:
    asset_id: str
    kind: str
    output: Path
    prompt: str
    refs: tuple[str, ...]


def main() -> int:
    args = _parse_args()
    manifest = json.loads(MANIFEST_PATH.read_text())
    jobs = list(
        _build_jobs(
            manifest,
            args.only,
            args.context,
            args.stage,
            args.accessory,
            args.skin,
        )
    )

    if args.limit is not None:
        jobs = jobs[: args.limit]

    print(f"Prepared {len(jobs)} posed asset job(s).")
    print(f"Mode: {args.only}")
    if args.context:
        print(f"Context filter: {args.context}")
    if args.stage is not None:
        print(f"Stage filter: {args.stage}")
    if args.accessory:
        print(f"Accessory filter: {args.accessory}")
    if args.skin:
        print(f"Skin filter: {args.skin}")
    print(f"Output root: {manifest['output_dir']}")
    print()

    completed = 0
    skipped = 0
    failed = 0

    for index, job in enumerate(jobs, 1):
        rel_output = job.output.relative_to(PROJECT_ROOT)
        exists = job.output.exists()
        print(f"[{index}/{len(jobs)}] {job.asset_id}")
        print(f"  kind: {job.kind}")
        print(f"  out:  {rel_output}")
        if job.refs:
            print("  refs: " + ", ".join(job.refs))

        if args.dry_run:
            continue
        if exists and not args.overwrite:
            print("  skipped: exists, pass --overwrite to regenerate")
            skipped += 1
            continue

        try:
            _run_image_job(job, manifest["canvas"])
            completed += 1
        except Exception as exc:
            print(f"  ERROR: {exc}")
            failed += 1
            if not args.keep_going:
                raise
        print()

    if args.dry_run:
        print("Dry run complete. No files were generated.")
    else:
        print(f"Done. generated={completed}, skipped={skipped}, failed={failed}")

    return 1 if failed else 0


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate posed Math Dragons dragon/accessory review assets."
    )
    parser.add_argument(
        "--only",
        choices=[
            "all",
            "templates",
            "variants",
            "accessories",
            "themed-accessories",
        ],
        default="all",
        help="Subset to generate. Templates are default-skin dragons.",
    )
    parser.add_argument(
        "--limit",
        type=int,
        help="Generate only the first N jobs, useful for smoke tests.",
    )
    parser.add_argument(
        "--context",
        choices=["hub", "portrait"],
        help="Generate only one render context.",
    )
    parser.add_argument(
        "--stage",
        type=int,
        choices=range(0, 6),
        metavar="0-5",
        help="Generate only one dragon evolution stage.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned jobs without calling the image API.",
    )
    parser.add_argument(
        "--accessory",
        help="Generate only one accessory ID, e.g. acc_crown.",
    )
    parser.add_argument(
        "--skin",
        help="Generate only one skin ID, e.g. color_crimson. Used by variants and themed accessories.",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Regenerate files that already exist.",
    )
    parser.add_argument(
        "--keep-going",
        action="store_true",
        help="Continue after a failed generation job.",
    )
    return parser.parse_args()


def _build_jobs(
    manifest: dict,
    only: str,
    context_filter: str | None = None,
    stage_filter: int | None = None,
    accessory_filter: str | None = None,
    skin_filter: str | None = None,
) -> Iterable[Job]:
    contexts = manifest["contexts"]
    stages = manifest["stages"]
    skins = manifest["skins"]
    accessories = manifest["accessories"]
    themed_accessories = manifest.get("themed_accessories", [])
    output_root = Path(manifest["output_dir"])
    style_refs = tuple(manifest["style_refs"])

    for context in contexts:
        if context_filter is not None and context["id"] != context_filter:
            continue
        for stage in stages:
            if stage_filter is not None and stage["id"] != stage_filter:
                continue
            template_path = _dragon_output_path(output_root, context, stage, skins[0])

            if only in ("all", "templates"):
                yield _dragon_template_job(
                    manifest=manifest,
                    context=context,
                    stage=stage,
                    skin=skins[0],
                    output=template_path,
                    refs=style_refs,
                )

            if only in ("all", "variants"):
                for skin in skins[1:]:
                    if skin_filter is not None and skin["id"] != skin_filter:
                        continue
                    output = _dragon_output_path(output_root, context, stage, skin)
                    refs = _refs_with_template(template_path, style_refs)
                    yield _dragon_variant_job(
                        manifest=manifest,
                        context=context,
                        stage=stage,
                        skin=skin,
                        output=output,
                        refs=refs,
                    )

            if stage["id"] == 0:
                continue

            if only in ("all", "accessories"):
                for accessory in accessories:
                    if (
                        accessory_filter is not None
                        and accessory["id"] != accessory_filter
                    ):
                        continue
                    output = _accessory_output_path(
                        output_root, context, stage, accessory
                    )
                    refs = _refs_with_template(template_path, style_refs)
                    yield _accessory_job(
                        manifest=manifest,
                        context=context,
                        stage=stage,
                        accessory=accessory,
                        output=output,
                        refs=refs,
                    )

            if only == "themed-accessories":
                for themed_accessory in themed_accessories:
                    if (
                        accessory_filter is not None
                        and themed_accessory["id"] != accessory_filter
                    ):
                        continue
                    accessory = _accessory_by_id(accessories, themed_accessory["id"])
                    for skin in skins[1:]:
                        if skin_filter is not None and skin["id"] != skin_filter:
                            continue
                        skin_dragon_path = _dragon_output_path(
                            output_root, context, stage, skin
                        )
                        output = _accessory_output_path(
                            output_root, context, stage, accessory, skin=skin
                        )
                        refs = _refs_with_template(skin_dragon_path, style_refs)
                        yield _themed_accessory_job(
                            manifest=manifest,
                            context=context,
                            stage=stage,
                            skin=skin,
                            accessory=accessory,
                            themed_accessory=themed_accessory,
                            output=output,
                            refs=refs,
                        )


def _dragon_output_path(
    output_root: Path, context: dict, stage: dict, skin: dict
) -> Path:
    return (
        PROJECT_ROOT
        / output_root
        / "dragons"
        / context["id"]
        / f"stage_{stage['id']}_{stage['name']}"
        / f"dragon_{context['pose_id']}_stage{stage['id']}_{skin['id']}.png"
    )


def _accessory_output_path(
    output_root: Path,
    context: dict,
    stage: dict,
    accessory: dict,
    skin: dict | None = None,
) -> Path:
    skin_suffix = f"_{skin['id']}" if skin is not None else ""
    return (
        PROJECT_ROOT
        / output_root
        / "accessories"
        / context["id"]
        / f"stage_{stage['id']}_{stage['name']}"
        / f"{accessory['id']}_{context['pose_id']}_stage{stage['id']}{skin_suffix}.png"
    )


def _dragon_template_job(
    manifest: dict,
    context: dict,
    stage: dict,
    skin: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    if stage["id"] == 0:
        return _egg_template_job(manifest, context, stage, skin, output, refs)

    prompt = " ".join(
        [
            manifest["style_preamble"],
            manifest["geometry_rule"],
            f"Create the canonical {stage['name']} dragon template for Math Dragons.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}.",
            context["description"],
            stage["description"],
            f"Species/color treatment: {skin['description']}.",
            "Use a 1024x1024 square canvas, centered subject, generous padding, no crop.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
            "This image is the master pose template for this context and stage.",
        ]
    )
    return Job(
        asset_id=f"dragon_{context['id']}_stage{stage['id']}_{skin['id']}",
        kind="template",
        output=output,
        prompt=prompt,
        refs=refs,
    )


def _dragon_variant_job(
    manifest: dict,
    context: dict,
    stage: dict,
    skin: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    if stage["id"] == 0:
        return _egg_variant_job(manifest, context, stage, skin, output, refs)

    prompt = " ".join(
        [
            manifest["style_preamble"],
            manifest["geometry_rule"],
            f"Create a {skin['name']} skin/species variant from the provided canonical {stage['name']} dragon pose.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}.",
            "Preserve the provided template pose, alpha silhouette, head angle, horn placement, skull plane, wing position, crop, and attachment landmarks.",
            f"Only change color and species surface markings: {skin['description']}.",
            "No accessories.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
        ]
    )
    return Job(
        asset_id=f"dragon_{context['id']}_stage{stage['id']}_{skin['id']}",
        kind="variant",
        output=output,
        prompt=prompt,
        refs=refs,
    )


def _egg_template_job(
    manifest: dict,
    context: dict,
    stage: dict,
    skin: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    prompt = " ".join(
        [
            manifest["style_preamble"],
            "Create the canonical stage 0 dragon egg asset for Math Dragons.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}.",
            stage["description"],
            f"Species/color treatment: {skin['description']}.",
            "The entire visible subject must be one egg only. Do not include a dragon beside it, behind it, inside it, emerging from it, reflected on it, or silhouetted near it.",
            "No creature of any kind. No face or eyes on the egg. No hatchling parts, horns, wings, claws, tail, snout, or feet.",
            "Use a 1024x1024 square canvas, centered subject, generous padding, no crop.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
            "This image is the master egg template for this context.",
        ]
    )
    return Job(
        asset_id=f"dragon_{context['id']}_stage{stage['id']}_{skin['id']}",
        kind="template",
        output=output,
        prompt=prompt,
        refs=refs,
    )


def _egg_variant_job(
    manifest: dict,
    context: dict,
    stage: dict,
    skin: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    prompt = " ".join(
        [
            manifest["style_preamble"],
            "Create a species/color variant from the provided canonical dragon egg asset.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}.",
            "Preserve the provided egg-only template shape, crop, scale, alpha silhouette, and canvas placement.",
            f"Only change shell color, shell markings, cracks, material highlights, and inner glow: {skin['description']}.",
            "The entire visible subject must remain one egg only. Do not include a dragon beside it, behind it, inside it, emerging from it, reflected on it, or silhouetted near it.",
            "No creature of any kind. No face or eyes on the egg. No hatchling parts, horns, wings, claws, tail, snout, or feet.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
        ]
    )
    return Job(
        asset_id=f"dragon_{context['id']}_stage{stage['id']}_{skin['id']}",
        kind="variant",
        output=output,
        prompt=prompt,
        refs=refs,
    )


def _accessory_job(
    manifest: dict,
    context: dict,
    stage: dict,
    accessory: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    prompt = " ".join(
        [
            manifest["style_preamble"],
            f"Create a fitted visible accessory layer for Math Dragons: {accessory['description']}.",
            f"Accessory ID: {accessory['id']}. Slot: {accessory['slot']}.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}. Dragon stage: {stage['id']} {stage['name']}.",
            "Use the provided dragon template as the exact registration and occlusion reference.",
            "Place the accessory exactly where it would be worn on that dragon template.",
            "Output a full 1024x1024 transparent layer using the same canvas registration as the dragon template.",
            "Include only the accessory pixels that would remain visible after the dragon body, horns, neck, chest, wings, and limbs occlude it.",
            "Omit all hidden accessory portions instead of drawing them through the dragon.",
            "For wraparound items, show only the front/side visible segments and omit the back segment hidden behind the body.",
            "For head items, do not cover horns or skull parts that should appear in front of the accessory.",
            "For chest or wing items, conform to the body/wing perspective and omit any portions hidden behind anatomy.",
            "Do not include the dragon, head, body, mannequin, guide marks, text, UI, shadows, or background.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
        ]
    )


def _themed_accessory_job(
    manifest: dict,
    context: dict,
    stage: dict,
    skin: dict,
    accessory: dict,
    themed_accessory: dict,
    output: Path,
    refs: tuple[str, ...],
) -> Job:
    prompt = " ".join(
        [
            manifest["style_preamble"],
            f"Create a skin-themed fitted visible accessory layer for Math Dragons: {accessory['description']}.",
            f"Accessory ID: {accessory['id']}. Slot: {accessory['slot']}.",
            f"Target dragon skin/species: {skin['name']} ({skin['id']}), {skin['description']}.",
            themed_accessory["theme_rule"],
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}. Dragon stage: {stage['id']} {stage['name']}.",
            "Use the provided matching skin dragon image as the exact registration, perspective, and occlusion reference.",
            "Place the accessory exactly where it would be worn on that dragon.",
            "Output a full 1024x1024 transparent layer using the same canvas registration as the dragon image.",
            "Include only the accessory pixels that would remain visible after the dragon body, horns, neck, chest, wings, and limbs occlude it.",
            "Omit all hidden accessory portions instead of drawing them through the dragon.",
            "Do not include the dragon, head, body, mannequin, guide marks, text, UI, shadows, or background.",
            "Transparent background with PNG alpha, no shadows cast onto a floor, no gradients, no text.",
        ]
    )
    return Job(
        asset_id=f"{accessory['id']}_{context['id']}_stage{stage['id']}_{skin['id']}",
        kind="themed-accessory",
        output=output,
        prompt=prompt,
        refs=refs,
    )


def _accessory_by_id(accessories: list[dict], accessory_id: str) -> dict:
    for accessory in accessories:
        if accessory["id"] == accessory_id:
            return accessory
    raise ValueError(f"Unknown themed accessory id: {accessory_id}")


def _refs_with_template(template_path: Path, style_refs: tuple[str, ...]) -> tuple[str, ...]:
    template_ref = str(template_path.relative_to(PROJECT_ROOT))
    refs = [template_ref]
    refs.extend(_existing_refs(style_refs))
    return tuple(refs[:5])


def _existing_refs(paths: tuple[str, ...]) -> tuple[str, ...]:
    refs = []
    for path in paths:
        ref_path = Path(path)
        if not ref_path.is_absolute():
            ref_path = PROJECT_ROOT / ref_path
        if ref_path.exists():
            refs.append(str(ref_path.relative_to(PROJECT_ROOT)))
    return tuple(refs[:5])


def _run_image_job(job: Job, canvas: str) -> None:
    job.output.parent.mkdir(parents=True, exist_ok=True)
    command = [
        sys.executable,
        str(CLI_PATH),
        "image",
        job.prompt,
        "-o",
        str(job.output.relative_to(PROJECT_ROOT)),
        "-s",
        canvas,
        "-q",
        "high",
    ]
    if job.refs:
        command.extend(["-r", *job.refs])
    subprocess.run(command, cwd=PROJECT_ROOT, check=True)


if __name__ == "__main__":
    raise SystemExit(main())
