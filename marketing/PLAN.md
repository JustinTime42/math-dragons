# Video Pipeline Plan (tracker)

Source of truth for progress. Update it in the same session as the work, before writing a handoff. Pipeline definition: `README.md`.

**Current stage:** 0. Research, awaiting Justin's review gate (report delivered 2026-10-19)

## Stage 0: Research
- [x] Scaffold pipeline folder, tracker, `/handoff` skill (2026-10-19)
- [x] Deep research run (2026-10-19): virality best practices for faceless parent-facing math Shorts/Reels (6 researchers: algorithms + craft, formats + case studies, AI production pipeline, policy + COPPA, CTA + funnel, math-learning evidence + trivia bank)
- [x] Final report: `reports/Faceless short form video playbook.md` (~9.4k words; its last section maps recommendations + open questions to each Stage 1 guide)
- [ ] GATE: Justin reviews report, flags disagreements (decisions round 1 done 2026-10-19, see Decisions below)

## Stage 1: Guidance docs (`guides/`)
Each guide is drafted from the research report, reviewed by Justin, then frozen as the rubric for later gates.
- [ ] `brand-and-voice.md`: channel identity, the dragon as mascot/"face", tone, words we use and avoid, VO voice spec
- [ ] `visual-style.md`: 9:16 layout, safe zones, caption style, color/type pulled from `docs/VISUAL_DESIGN_GUIDE.md`, how AI visuals match the in-game art
- [ ] `content-strategy.md`: audience, pillars, promo-vs-value ratio, series, cadence, platform differences (YT vs FB)
- [ ] `format-library.md`: reusable video templates (beat structure, length, example) per format
- [ ] `script-standards.md`: hook rules, structure, length, CTA patterns, the script checklist used at the Stage 3 gate
- [ ] `compliance-checklist.md`: Made-for-Kids, AI disclosure, engagement-bait, claims (FTC), music rights, link rules
- [ ] `fact-check-protocol.md`: how claims get verified; links to the evidence bank
- [ ] `production-pipeline.md`: tools, automation design, quality bar, per-video cost/time budget
- [ ] `metrics-and-learning.md`: what we track, where, and how lessons flow back into the guides
- [ ] `idea-scoring-rubric.md`: how Stage 2 ideas are scored
- [ ] GATE: Justin approves all guides

## Stage 2: Idea bank
- [ ] Generate 100+ one-liners across pillars/formats into `ideas/idea-bank.md`
- [ ] Score against rubric; Justin selects first batch (target 10-15)

## Stage 3: Treatments
- [ ] Treatments for first batch (`videos/MD-###/treatment.md`)

## Stage 4: Production plans
- [ ] Plans for first batch

## Stage 5: Production
- [ ] Pipeline tooling decision + build (manual first pass, then automate what repeats)
- [ ] First 3 videos produced and QA'd

## Stage 6: Publish + learn
- [ ] Channel setup checklist (YouTube + FB page; Not Made for Kids; link routing)
- [ ] Publishing log + metrics sheet live
- [ ] First weekly review

## Decisions (resolved 2026-10-19, Justin)
- **Age range: primarily 5-12.** Video copy uses this. Note: `docs/store-listing.md` (6-12) and `docs/VISUAL_DESIGN_GUIDE.md` §1 (7-14+) still differ; flag before the next store-listing edit.
- **Docs home:** repo `marketing/` (vault MOC links here).
- **Play closed test:** joins via an open-join Google Group.
- **Narrator voice:** ElevenLabs clone of Justin's voice.
- **Privacy facts:** the app has no Firebase code or packages in `lib/` or `pubspec.yaml` (verified 2026-10-19; leftover Firebase infra is unused), no accounts, no ads. "No accounts, no ads, nothing collected" is supportable; keep any claim limited to the app itself (Apple/Google collect their own TestFlight/Play data). The vault product facts and repo README "Step 10 / Firebase" lines are stale.

## Open decisions (need Justin)
- [ ] **Short beta URL.** Recommended: one short dedicated domain that 301-redirects to (or hosts) a device-detecting landing page, which sends iPhone visitors to TestFlight and Android to the Google Group + Play opt-in. Avoid bit.ly-style shorteners (low trust, spam-flagged on Meta). whois 2026-10-19: `mathdragons.com` registered 2025-08-25 (Justin's?); available per whois: `playmathdragons.com`, `getmathdragons.com`, `trymathdragons.com`, `mathdragons.fun`, `mathdragons.io`, `mathdragons.gg`; `mathdragons.app` has no DNS (likely available, unconfirmed).
- [ ] **Dragon mascot personality + voice:** proposal in the 2026-10-19 session (recommended: the ancient, theatrical veteran dragon who "was there" for math history; gruff and fierce, secretly soft; speaks to parents, with its own ElevenLabs Voice Design voice and Rhubarb lip-sync on a rigged 2D puppet). Awaiting Justin's pick; it seeds `guides/brand-and-voice.md`.
- [ ] Hold promo videos until current TestFlight + Play builds are approved, with a rebuild cadence that beats TestFlight's 90-day build expiry?
