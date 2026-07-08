#!/usr/bin/env python3
"""Generate prompt-only crown cutout candidates for manual calibration.

This workflow is intentionally separate from the registered posed accessory
pipeline. It creates standalone crown PNG candidates with transparent
backgrounds so good results can be selected, scaled, rotated, and anchored in
the dev calibration screen.
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


CROWN_THEMES = {
    "classic_gold": "warm royal gold metal, small amethyst gems, polished fantasy crown highlights",
    "ruby": "warm gold metal with ruby enamel and ember-red gems",
    "sapphire": "white-gold and warm gold metal with sapphire-blue gems and cool blue enamel",
    "emerald": "warm gold metal with emerald gems, subtle vine-like engraving, no leaves protruding from the silhouette",
    "amethyst": "warm gold metal with violet amethyst gems and deep purple enamel",
    "sunstone": "bright gold and white-gold metal with sunstone gems and cream highlights",
    "obsidian": "darkened gold metal with ruby gems, smoky red enamel, strong readable rim highlights",
    "frost": "white-gold metal with pale ice-blue crystal gems and silver-blue enamel",
    "sunset": "orange-gold metal with coral and ember gems, readable warm highlights",
}


ORIENTATION_VARIANTS = {
    "front_ellipse": "front three-quarter crown view with an elliptical rim. The viewer sees the front band and both side arcs, with the far rear arc mostly absent.",
    "left_facing": "crown turned for a dragon head facing slightly left. The right side of the crown is more visible, the left rear side is tucked away.",
    "right_facing": "crown turned for a dragon head facing slightly right. The left side of the crown is more visible, the right rear side is tucked away.",
    "steep_tilt": "crown tilted downward toward the viewer with a stronger oval perspective, useful for heads angled down or forward.",
    "high_tilt": "crown tilted upward and back with a narrow rear rim, useful for heads lifted slightly upward.",
}


@dataclass(frozen=True)
class CrownCandidateJob:
    theme_id: str
    context_id: str
    orientation_id: str
    output: Path
    prompt: str
    refs: tuple[str, ...]

    @property
    def asset_id(self) -> str:
        return f"crown_{self.context_id}_{self.theme_id}_{self.orientation_id}"


def main() -> int:
    args = _parse_args()
    manifest = json.loads(MANIFEST_PATH.read_text())
    jobs = list(_build_jobs(manifest, args))
    if args.limit is not None:
        jobs = jobs[: args.limit]

    print(f"Prepared {len(jobs)} crown candidate job(s).")
    print(f"Variations per job: {args.variations}")
    print(f"Reference stage: {args.reference_stage}")
    print(f"Output root: {args.output_dir}")
    print()

    generated = 0
    skipped = 0
    failed = 0

    for index, job in enumerate(jobs, 1):
        print(f"[{index}/{len(jobs)}] {job.asset_id}")
        print(f"  out:  {job.output.relative_to(PROJECT_ROOT)}")
        print("  refs: " + ", ".join(job.refs))
        if args.show_prompts or args.dry_run:
            print(f"  prompt: {job.prompt}")

        if args.dry_run:
            print()
            continue

        if _candidate_outputs_exist(job.output, args.variations) and not args.overwrite:
            print("  skipped: candidate files exist, pass --overwrite to regenerate")
            skipped += 1
            print()
            continue

        try:
            _run_image_job(job, manifest["canvas"], args.variations)
            generated += 1
        except Exception as exc:
            print(f"  ERROR: {exc}")
            failed += 1
            if not args.keep_going:
                raise
        print()

    if args.dry_run:
        print("Dry run complete. No files were generated.")
    else:
        print(f"Done. jobs_generated={generated}, skipped={skipped}, failed={failed}")

    return 1 if failed else 0


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate standalone crown candidate cutouts for calibration."
    )
    parser.add_argument(
        "--context",
        action="append",
        choices=["hub", "portrait"],
        help="Context to generate. Repeat to include multiple. Defaults to both.",
    )
    parser.add_argument(
        "--theme",
        action="append",
        choices=sorted(CROWN_THEMES),
        help="Crown color theme. Repeat to include multiple. Defaults to all themes.",
    )
    parser.add_argument(
        "--orientation",
        action="append",
        choices=sorted(ORIENTATION_VARIANTS),
        help="Orientation variant. Repeat to include multiple. Defaults to all orientations.",
    )
    parser.add_argument(
        "--reference-stage",
        type=int,
        choices=range(1, 6),
        default=3,
        metavar="1-5",
        help="Dragon stage used as the fit/occlusion reference. Defaults to stage 3.",
    )
    parser.add_argument(
        "--variations",
        type=int,
        default=2,
        choices=range(1, 11),
        metavar="1-10",
        help="Number of model variations per prompt.",
    )
    parser.add_argument(
        "--output-dir",
        default="assets/images/dragons/posed/candidates/crowns",
        help="Review-only output directory.",
    )
    parser.add_argument(
        "--limit",
        type=int,
        help="Generate only the first N jobs.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned jobs and prompts without calling the image API.",
    )
    parser.add_argument(
        "--show-prompts",
        action="store_true",
        help="Print prompts even when generating.",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Regenerate candidate files that already exist.",
    )
    parser.add_argument(
        "--keep-going",
        action="store_true",
        help="Continue after a failed generation job.",
    )
    return parser.parse_args()


def _build_jobs(manifest: dict, args: argparse.Namespace) -> Iterable[CrownCandidateJob]:
    selected_contexts = set(args.context or ["hub", "portrait"])
    selected_themes = args.theme or list(CROWN_THEMES)
    selected_orientations = args.orientation or list(ORIENTATION_VARIANTS)
    stage = _stage_by_id(manifest["stages"], args.reference_stage)
    output_root = Path(args.output_dir)
    style_refs = tuple(manifest["style_refs"])

    for context in manifest["contexts"]:
        if context["id"] not in selected_contexts:
            continue
        dragon_ref = _dragon_reference_path(manifest, context, stage)
        refs = _refs_with_dragon(dragon_ref, style_refs)

        for theme_id in selected_themes:
            for orientation_id in selected_orientations:
                output = (
                    PROJECT_ROOT
                    / output_root
                    / context["id"]
                    / theme_id
                    / f"acc_crown_candidate_{context['pose_id']}_{theme_id}_{orientation_id}.png"
                )
                yield CrownCandidateJob(
                    theme_id=theme_id,
                    context_id=context["id"],
                    orientation_id=orientation_id,
                    output=output,
                    prompt=_build_prompt(
                        manifest=manifest,
                        context=context,
                        stage=stage,
                        theme_id=theme_id,
                        orientation_id=orientation_id,
                    ),
                    refs=refs,
                )


def _build_prompt(
    manifest: dict,
    context: dict,
    stage: dict,
    theme_id: str,
    orientation_id: str,
) -> str:
    theme = CROWN_THEMES[theme_id]
    orientation = ORIENTATION_VARIANTS[orientation_id]
    return " ".join(
        [
            manifest["style_preamble"],
            "Create one standalone transparent PNG crown candidate for Math Dragons.",
            "This is a calibratable accessory cutout, not a final full-canvas overlay.",
            f"Use the provided {stage['name']} dragon image only as a perspective, skull-plane, horn-placement, and occlusion reference.",
            f"Render context: {context['id']}. Pose ID: {context['pose_id']}.",
            context["description"],
            f"Crown color theme: {theme}.",
            f"Orientation variant: {orientation}",
            "The crown must look like it sits on a dragon skull between horns, viewed in the same camera angle as the reference dragon.",
            "Design the visible crown shape as if parts are already hidden behind an invisible dragon head and horns.",
            "Omit hidden rear rim segments instead of drawing a complete circular crown.",
            "Leave clean gaps, notches, or missing sections where horns or skull ridges would pass in front.",
            "Show only usable visible pieces: front band, visible side band, visible points, gems, and small partial rear arc only if it would truly be visible.",
            "Avoid a complete standalone crown, full ring, front-on tiara, symmetrical icon, helmet, hat, headband, or object centered as product art.",
            "Keep the crown compact with generous transparent padding so it can be scaled and rotated in the calibration tool.",
            "Transparent background with PNG alpha. No dragon pixels, mannequin, head silhouette, guide marks, background, shadow, UI, watermark, or text.",
        ]
    )


def _stage_by_id(stages: list[dict], stage_id: int) -> dict:
    for stage in stages:
        if stage["id"] == stage_id:
            return stage
    raise ValueError(f"Unknown stage: {stage_id}")


def _dragon_reference_path(manifest: dict, context: dict, stage: dict) -> Path:
    output_root = Path(manifest["output_dir"])
    path = (
        PROJECT_ROOT
        / output_root
        / "dragons"
        / context["id"]
        / f"stage_{stage['id']}_{stage['name']}"
        / f"dragon_{context['pose_id']}_stage{stage['id']}_default.png"
    )
    if not path.exists():
        raise FileNotFoundError(
            f"Missing default dragon reference for {context['id']} stage {stage['id']}: {path}"
        )
    return path


def _refs_with_dragon(dragon_ref: Path, style_refs: tuple[str, ...]) -> tuple[str, ...]:
    refs = [str(dragon_ref.relative_to(PROJECT_ROOT))]
    for ref in style_refs:
        ref_path = Path(ref)
        if not ref_path.is_absolute():
            ref_path = PROJECT_ROOT / ref_path
        if ref_path.exists():
            refs.append(str(ref_path.relative_to(PROJECT_ROOT)))
        if len(refs) == 5:
            break
    return tuple(refs)


def _candidate_outputs_exist(output: Path, variations: int) -> bool:
    if variations == 1:
        return output.exists()
    stem = output.stem
    return all(output.with_stem(f"{stem}_v{i}").exists() for i in range(1, variations + 1))


def _run_image_job(job: CrownCandidateJob, canvas: str, variations: int) -> None:
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
        "-v",
        str(variations),
    ]
    if job.refs:
        command.extend(["-r", *job.refs])
    subprocess.run(command, cwd=PROJECT_ROOT, check=True)


if __name__ == "__main__":
    raise SystemExit(main())
