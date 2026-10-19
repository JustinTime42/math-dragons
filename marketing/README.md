# Math Dragons Marketing: Short-Form Video Pipeline

Home of the faceless short-form video program (YouTube Shorts + Facebook Reels) aimed at **parents**, whose job is to recruit engaged beta testers (TestFlight + Google Play closed testing) and build an audience for launch.

This folder is designed to be worked across many Claude sessions. Nothing important lives only in a conversation: every stage writes its output here, and every session ends with `/handoff` (skill at `.claude/skills/handoff/`, files in `/handoffs/`).

**Start of any session:** `/handoff resume video`, or read `PLAN.md` and the latest file named in `/handoffs/LATEST.md`.

## The pipeline

Each stage turns the previous stage's output into something more specific, and each has a vetting gate. A piece does not advance until it passes its gate.

| Stage | Output | Lives in | Gate |
|---|---|---|---|
| 0. Research | Best-practice research report | `reports/`, `research_notes/` | Justin reads it and approves the direction |
| 1. Guidance | Brand + voice guide, content strategy, format library, script standards, compliance checklist, production spec | `guides/` | Justin approves each guide; guides then become the rubric for every later gate |
| 2. Ideas | Bank of one-liner ideas, tagged by pillar/format, scored | `ideas/idea-bank.md` | Scored against the rubric in `guides/`; Justin picks which advance |
| 3. Treatment | Per video: hook, script, on-screen text, title, description, first comment, CTA | `videos/<id>/treatment.md` | Script checklist + fact-check + compliance check |
| 4. Production plan | Per video: timed beat sheet, shot list, asset list, VO direction, music/SFX, generation prompts | `videos/<id>/plan.md` | Plan review: every beat has a source asset or a generation prompt |
| 5. Production | VO audio, generated/captured visuals, edit, captions, export | `videos/<id>/` + pipeline tooling (TBD) | QA checklist on the rendered file |
| 6. Publish + learn | Post log, per-video metrics, lessons fed back into guides | `metrics/` | Weekly review |

**Parallel track W: marketing website** (`playmathdragons.com`, registered 2026-10-19). Research → spec → copy → design → build → QA → launch, with the same gates, tracked in `PLAN.md` under Track W. Website files live in `marketing/website/`. The beta landing page must be live before the first video publishes, because every CTA points there.

Video IDs: `MD-###` (e.g. `MD-001`), assigned when an idea is promoted to Stage 3. Each video folder carries a `status:` frontmatter field matching its stage.

## Standing rules (inherited from the existing marketing plan)

- Mascot: **Tallyclaw** ("Tally"), the Ancient Veteran dragon: gruff, theatrical, fierce, secretly soft, who "was there" for math history. Speaks to parents. Justin's cloned voice narrates; Tallyclaw is a recurring cameo/segment host with his own ElevenLabs voice and Rhubarb lip-sync.

- Talk to **adults** (parents, homeschoolers, teachers). Never address kids. Channel and videos are "Not Made for Kids" because they genuinely address the adult decision-maker.
- Faceless: no Justin on camera. Gameplay, animation, illustration, text, and VO (AI or Justin's voice).
- Value first. Most videos earn attention on their own (trivia, history, techniques, parent tips, feel-good); some promote the app directly. The ratio is set in `guides/content-strategy.md` once written.
- Every factual math or learning-science claim is checked against the research notes before publishing.

## Accuracy and sense review (mandatory, Justin's rule 2026-10-19)

Nothing goes to production without passing this review. It runs twice: at the end of Stage 3 (on the script and copy) and at the end of Stage 5 (on the rendered video, since edits, captions and VO can introduce errors the script didn't have).

1. **Claims list.** Every factual statement, number, date, attribution, and joke premise in the script, on-screen text, title, description and first comment is extracted into a list. Jokes count: a punchline built on a wrong fact is a wrong fact.
2. **Independent verification.** A fresh reviewer that did not write the piece (a separate agent with no authoring context) checks each claim against a fetched source or the research notes, and tries to prove it wrong. Arithmetic and any on-screen math are checked by running code.
3. **Sense read.** The reviewer reads the whole piece as a skeptical parent and a math teacher would: does each line make sense, is the reasoning right (not just the numbers), does anything mislead by simplification?
4. **Verdict recorded** in the video folder as `review.md` (claims, sources, verdict per claim, fixes made).
5. **Justin signs off** before anything is published.

Example of what this catches: a draft line said base 60 was "terrible for fractions." It is the opposite; 60's many divisors are why it was good for fractions.

## Related context

- Existing strategy (Obsidian vault): `~/Documents/Obsidian Vault/Projects/math-dragons/marketing/Marketing.md` and `YouTube Marketing Plan.md`. Those predate this pipeline; where they conflict with `guides/`, the guides win once approved.
- Product facts: `/spec.md`, `docs/store-listing.md`, `store-checklist.md`, `docs/VISUAL_DESIGN_GUIDE.md`, `assets/style_bible/`.
- Asset tooling already in the repo: `.claude/commands/generate-image.md`, `generate-music.md`, `generate-sfx.md`, `process-image.md`.
