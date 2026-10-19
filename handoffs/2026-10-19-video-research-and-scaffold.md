---
workstream: video
date: 2026-10-19
model: claude-opus-5-5
stage: "Stage 0: research (awaiting Justin's review gate)"
previous: none
---

# Handoff: video 2026-10-19

## Read first
1. `marketing/PLAN.md` (tracker; open decisions at the bottom)
2. `marketing/README.md` (pipeline stages and gates)
3. `marketing/reports/Faceless short form video playbook.md`, especially the final section "Recommendations and open questions for the guidance documents" (line ~186)
4. `~/Documents/Obsidian Vault/Projects/math-dragons/marketing/YouTube Marketing Plan.md` (prior strategy; the new guides supersede its Shorts sections once approved)
5. Research notes, only when drafting the matching guide: `marketing/research_notes/Faceless short form video playbook/*.md`

## State of work
- Pipeline scaffolded: `marketing/README.md`, `marketing/PLAN.md`, `handoffs/`, project skill `.claude/skills/handoff/SKILL.md`. Done.
- Deep research run complete: 6 research notes + a ~9.4k-word synthesized report. Done.
- Stage 0 gate (Justin reviews the report) not yet passed. Stage 1 guides not started.
- Nothing committed.

## Decisions made
- (Claude default, Justin may overturn) Working home is repo `marketing/`, not the Obsidian vault; vault MOC `Marketing.md` now links to it.
- (Claude default) Handoffs live in repo-root `handoffs/` with `LATEST.md` pointer; workstream `video`.
- (Claude) No `/handoff` skill existed in ForgeOS/fortkit; it is a seat protocol. The project skill was built from `~/dev/fortkit/templates/fort/seats/mayor.md:31` handoff schema, with "Read first", "Decisions made", and a `resume` mode added.
- (Justin, from the original brief) No Justin on camera; gameplay/animation/illustration; VO by AI or Justin; parent audience; links in description/first comment; eventual AI automation.

## Verified facts
- Report findings that change Justin's original plan (all sourced in the report):
  - Shorts description/comment links are not clickable (since 2023). Only the per-Short "related video" link is, and it must be set by hand in Studio. Implication: Short → pinned "join the beta" long-form video + a short typeable URL.
  - Facebook Reel caption links are clickable only on the paid Meta One plan (launched 2026-09-15). First-comment links still work.
  - OpenAI shut down Sora 2 / Videos API on 2026-09-24. Veo 3.1 preview model IDs may retire around 2026-10-22.
  - Made for Kids auto-classification is the top compliance risk (animated characters + games are explicit MFK factors). Disney 2025 $10M was for a blanket channel-level setting; set audience per video.
- App uses Firebase anonymous auth + optional Google Sign-In + Firestore sync (vault `Marketing.md` product facts; repo `README.md` "Step 10 complete"), so "zero data collected / everything on device" claims are not strictly true.
- Age range conflict: 5-9 (vault landing-page notes in `marketing/` vault folder context), 6-12 (`docs/store-listing.md`), 7-14+ (`docs/VISUAL_DESIGN_GUIDE.md` §1).

## Next actions
1. Get Justin's reaction to the report (Stage 0 gate) and answers to the "Open decisions" in `marketing/PLAN.md`. Tick the gate in PLAN.md.
2. Draft Stage 1 guides in this order (each one depends on earlier ones): `brand-and-voice.md` → `compliance-checklist.md` → `content-strategy.md` → `visual-style.md` → `format-library.md` → `script-standards.md` → `fact-check-protocol.md` → `idea-scoring-rubric.md` → `production-pipeline.md` → `metrics-and-learning.md`. Seed each from the report's per-guide recommendation table. Present each to Justin for approval; mark approved guides `status: approved` in frontmatter.
3. In parallel, resolve the cheap factual open questions before the compliance guide is frozen: inspect `lib/` for exactly what Firebase/crash/analytics collect; check the Play closed-test track's join mechanism in Play Console (Justin).

## Open risks / questions
- JUSTIN: all items under "Open decisions (need Justin)" in `marketing/PLAN.md` (age range, docs home, short URL, privacy wording, Play join mechanics, voice, mascot trait, whether to hold promos for approved builds).
- About a dozen learning-science studies were cited by the researcher from memory and were excluded from the report; they are unusable on screen until sourced (list in report "Open questions").
- Several policy points rest on secondary coverage (Oct 1 2026 YouTube originality post, COPPA amendment marketing-materials factor, AAP 2026 wording). Verify before freezing the compliance guide.
- No public data exists on view-to-beta-signup conversion; first 30-60 videos must be instrumented (per-video landing paths).

## Failed attempts
- Searched ForgeOS, fortkit, and `~/.claude/{skills,commands}` for a standalone handoff skill: none exists.
