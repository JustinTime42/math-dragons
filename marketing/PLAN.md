# Video Pipeline Plan (tracker)

Source of truth for progress. Update it in the same session as the work, before writing a handoff. Pipeline definition: `README.md`.

**Current stage:** 0. Research, awaiting Justin's review gate (report delivered 2026-10-19). Parallel track: W (website) not started.

## Stage 0: Research
- [x] Scaffold pipeline folder, tracker, `/handoff` skill (2026-10-19)
- [x] Deep research run (2026-10-19): virality best practices for faceless parent-facing math Shorts/Reels (6 researchers: algorithms + craft, formats + case studies, AI production pipeline, policy + COPPA, CTA + funnel, math-learning evidence + trivia bank)
- [x] Final report: `reports/Faceless short form video playbook.md` (~9.4k words; its last section maps recommendations + open questions to each Stage 1 guide)
- [ ] GATE: Justin reviews report, flags disagreements (decisions round 1 done 2026-10-19, see Decisions below)

## Stage 1: Guidance docs (`guides/`)
Each guide is drafted from the research report, reviewed by Justin, then frozen as the rubric for later gates.
- [x] `brand-and-voice.md` APPROVED by Justin 2026-10-19 (accuracy review PASS WITH FIXES, fixes applied, `guides/brand-and-voice.review.md`). Scope: channel identity, the dragon as mascot/"face", tone, words we use and avoid, VO voice spec
- [ ] `visual-style.md`: 9:16 layout, safe zones, caption style, color/type pulled from `docs/VISUAL_DESIGN_GUIDE.md`, how AI visuals match the in-game art
- [x] `content-strategy.md` DRAFTED 2026-10-26; independent review PASS WITH FIXES (`guides/compliance-and-strategy.review.md`), fixes applied; Justin approved cadence (3/week), pillar mix + 4:1 ratio, calendar days within cadence; awaiting final approval of the full doc. Scope: audience, pillars, promo-vs-value ratio, series, cadence, platform differences (YT vs FB)
- [x] `format-library.md` DRAFTED 2026-10-26 (8 formats), review pending. Scope: reusable video templates (beat structure, length, example) per format
- [x] `script-standards.md` DRAFTED 2026-10-26 (incl. treatment template), review pending. Scope: hook rules, structure, length, CTA patterns, the script checklist used at the Stage 3 gate
- [x] `compliance-checklist.md` DRAFTED 2026-10-26; review PASS WITH FIXES, fixes applied; keyword-to-DM off (Justin); awaiting final approval. Scope: Made-for-Kids, AI disclosure, engagement-bait, claims (FTC), music rights, link rules
- [ ] `fact-check-protocol.md`: operationalizes the mandatory accuracy and sense review in `README.md` (claims list, independent verifier, code-checked math, sense read, `review.md`, Justin sign-off); links to the evidence bank
- [ ] `production-pipeline.md`: tools, automation design, quality bar, per-video cost/time budget
- [ ] `metrics-and-learning.md`: what we track, where, and how lessons flow back into the guides
- [ ] `idea-scoring-rubric.md`: how Stage 2 ideas are scored
- [ ] GATE: Justin approves all guides

## Stage 2: Idea bank
- [ ] Generate 100+ one-liners across pillars/formats into `ideas/idea-bank.md`
- [ ] Score against rubric; Justin selects first batch (target 10-15)

## Stage 3: Treatments
- [ ] Treatments for first batch (`videos/MD-###/treatment.md`)
- [ ] Accuracy and sense review passed + Justin sign-off on each (`videos/MD-###/review.md`)

## Stage 4: Production plans
- [ ] Plans for first batch

## Stage 5: Production
- [ ] Pipeline tooling decision + build (manual first pass, then automate what repeats)
- [ ] First 3 videos produced and QA'd, including the second accuracy and sense review on the rendered file

## Stage 6: Publish + learn
- [ ] Channel setup checklist (YouTube + FB page; Not Made for Kids; link routing)
- [ ] Publishing log + metrics sheet live
- [ ] First weekly review

## Track W: Marketing website (`playmathdragons.com`)
Same quality bar as the videos: spec, review gates, the mandatory accuracy and sense review (README), and Justin sign-off. **Critical path:** every video CTA points at this site, so the beta landing page must be live and tested before the first video is published.

Starting material: `/spec.md` (landing-page section spec: hero, origin story, how it works, social proof, testing-track explainer, FAQ, privacy, contact, footer) and the current placeholder `apps.routeworks.app/math-dragons` (hosts the privacy policy). `spec.md` has stale or unverified items that must be corrected: "zero data stored... everything on device" wording, ages 5-9 (now 5-12), "Android now, iOS coming?" (both are live), "email capture... google account" (Play now joins via open Google Group), "lifetime free access" for testers (check against App Store/Play incentive rules).

- [x] W0. Research done 2026-10-19, report `reports/Beta landing page for kids app.md` (ends with SPEC recommendations + 24 open items). Run covered: conversion/UX, compliance/policy, stack/tooling; notes in `research_notes/Beta landing page for kids app/`): landing-page conversion best practices for app betas, kids'-app site requirements (COPPA, App Store/Play privacy-policy and support-URL requirements, Apple "Kids" category rules if applicable), device-detection routing to TestFlight vs Google Group + Play opt-in, per-video attribution paths without third-party trackers, privacy-respecting analytics
- [x] W1. Site spec APPROVED by Justin 2026-10-19 (drafted same day) at `marketing/website/SPEC.md` (12 open decisions in its §12). Scope: sitemap, page-by-page content outline, routing logic, attribution scheme (`/yt1`-style paths), analytics stance, hosting/stack, accessibility + performance targets. Supersedes the landing section of `/spec.md` once approved
- [x] W1 GATE: Justin approved spec 2026-10-19
- [x] **LIVE 2026-10-23 (Cloudflare version 5cfb201b). Phase 1 slice (pulled forward 2026-10-19, Justin): store-required pages** live before app 1.0.3+8 ships, since the app links to them. Branch `website/store-pages`, code in `/website`: `/` (minimal join page), `/privacy` (corrected policy), `/support` (Apple Support URL), `/feedback`, 404. Astro 7.4.1 (scaffold resolved to 7, not 6), static, Cloudflare Workers static assets, no analytics/forms/cookies yet (so the policy says so). 10 contract tests + astro check pass; verified under `wrangler dev`. Feedback is email + TestFlight for now (spec's form deferred). Independent review 2026-10-19: PASS WITH FIXES (`website/pages-v1.review.md`, 66 claims); all copy fixes applied (device backups disclosed, TestFlight Accept/Stop Testing steps, Android Clear storage path, perk separated from the ask, "No ads, ever" → "No ads", FAQ "safe" heading reworded, email retention 12 months + Microsoft 365 named, TestFlight®, fuller trademark line).
  - **Step-by-step launch instructions: `marketing/website/LAUNCH-CHECKLIST.md`** (written 2026-10-23; as of then none of Justin's steps were done: domain still on GoDaddy NS, wrangler not logged in, TestFlight link still not accepting testers).
  - **Pre-deploy checklist (Justin):** (1) Cloudflare zone active for playmathdragons.com, parking A records deleted, Bot Fight Mode OFF; (2) `npx wrangler login`; (3) Google Group settings: who can view members = managers only, who can post = managers only (the policy now says other testers can't see emails); (4) TestFlight public link currently says "This beta isn't accepting any new testers right now": fix in App Store Connect (enable link / approved external build); (5) sign off on copy.
  - **Post-deploy (Claude):** verify live pages, HTTPS, headers, and no cookies/storage in DevTools before the "no cookies" line stands.
  - **Decision (Claude default, Justin may overturn):** keep OS backups enabled (Android auto backup / iCloud): restores kids' progress and the founding flag; disclosed in the policy.
  - **Deferred to later phases (review spec gaps):** parent-problem hero headline, `/story`, `/faq`, `/accessibility`, `/beta-status`, desktop QR, support form, social links, campaign paths, analytics.
- [ ] W2. Copy: all page copy written to the brand/voice guide (needs Stage 1 `brand-and-voice.md` + `compliance-checklist.md`), Tallyclaw's role on the site
- [ ] W2 GATE: accuracy and sense review (claims list incl. privacy/age/feature claims, independent verifier) + Justin sign-off
- [ ] W3. Design: visual direction from `docs/VISUAL_DESIGN_GUIDE.md` + `guides/visual-style.md`, mobile-first (most traffic arrives from phones via Shorts/Reels)
- [ ] W3 GATE: Justin approves design
- [ ] W4. Build + deploy: DNS for `playmathdragons.com`, HTTPS, privacy policy migrated, redirects from the old routeworks URL
- [ ] W5. QA GATE: real-device run of both join flows (iPhone → TestFlight, Android → Google Group → Play opt-in → install), every link checked, Lighthouse performance/accessibility, no third-party trackers, second accuracy review on the live pages, Justin sign-off
- [ ] W6. Launch: point all video CTAs and the YouTube/FB profile links at it; monitor per-path visits

## App tasks surfaced by marketing work (app workstream, separate branch)
- [ ] **Adaptive practice fix** (Justin 2026-10-26: keep adaptivity claims, fix the app): spec DRAFTED 2026-10-26 at `docs/specs/adaptive-practice.md` (6 phases, ~9.5-11.5 days; interface proposals I-1..I-9 and 11 open questions need Justin). Phase 1 (Fire Trail engine + first-answer-only counting + Runes/Feast fact keys + Dragon Eggs 7÷2=3 integer-division bug) unlocks the first claims. Gates publishing any adaptivity claim; per-phase claim wording in spec §2. **Phase 1 APPROVED 2026-10-26 (I-1, I-2, I-3, I-8); claims publish per phase as each ships (Q11).** Implementation on branch `app/adaptive-phase-1`.
Branch `app/store-links-founding-flag` (worktree `~/dev/math-dragons-app-links`), commit 7655335: items 1, 3, 4 below DONE (613 tests pass, signed release .aab 1.0.3+8 builds; not pushed or released).
- [x] Founding-tester flag (done 7655335; stored in app_meta box, no schema migration needed; cutoff placeholder 2099-01-01, MUST be set to the paid-launch date in the release that adds paid features)
- [ ] Founding flag pre-check: App Store 3.1.1 bans self-issued unlock mechanisms (license keys, codes); evaluate StoreKit `AppTransaction` grandfathering; iOS codes must be Apple offer codes. (Corrects Claude's earlier "own signed codes" option, which likely violates 3.1.1 on iOS.)
- [x] (done 7655335; merged release manifest verified) Review/remove Android `INTERNET` + `ACCESS_NETWORK_STATE` permissions (`android/app/src/main/AndroidManifest.xml:2-3`) if unused.
- [x] (done 7655335; parental gate per MOBILE_APP_PLAN, Apple 1.3) In-app privacy policy link to `playmathdragons.com/privacy` and a parent-gated `/feedback` link. None exists in `lib/` (checked 2026-10-19); Apple 5.1.1(i) and Google's User Data policy require a privacy link in the app.

- [ ] **Adaptivity is NOT true today (corrected 2026-10-26):** Fire Trail never receives the difficulty engine (`lib/games/fire_trail/fire_trail_game.dart:60-69`, `FireTrailFlameGame(difficultyEngine:)` left null), so it's random like Dragon Eggs; Dragon Runes repeats one missed fact per level; Dragon's Feast only nudges number choice. All adaptivity claims withdrawn from guides/site. Fix = pass the engine into Fire Trail (and wire Eggs), with tests; then the claim can return. Earlier note: Dragon Eggs ignores the adaptive engine (`dragon_eggs_game.dart:54`), Dragon Runes uses it for one fact per level. Wiring both in would make "it adapts" true app-wide. Also `docs/store-listing.md` claims "Adaptive difficulty automatically adjusts" and ages 6-12 (now 5-12); fix before next store-listing edit.
- [ ] Settings About shows hardcoded "Version 1.0.0" (`lib/hub/settings_screen.dart`); minor.

- **Community (Justin 2026-10-26):** no tester community yet. Justin floated Discord for support/feedback/discussion; Claude's view (2026-10-26 session): parents skew Facebook, Discord skews gamers/devs and teens; start a moderated adults-only Facebook group once ~15-20 active Android testers exist; revisit Discord for a build-in-public/dev audience later.
- **Kids as an audience (Justin asked 2026-10-26):** answered in session: stay parent-directed for now; kid-directed videos must be marked Made for Kids, which strips the funnel features; revisit a separate kids presence after public launch.

## Decisions (resolved 2026-10-19, Justin)
- **Age range: primarily 5-12.** Video copy uses this. Note: `docs/store-listing.md` (6-12) and `docs/VISUAL_DESIGN_GUIDE.md` §1 (7-14+) still differ; flag before the next store-listing edit.
- **Docs home:** repo `marketing/` (vault MOC links here).
- **Play closed test:** joins via an open-join Google Group.
- **Narrator voice:** ElevenLabs clone of Justin's voice.
- **Privacy facts:** the app has no Firebase code or packages in `lib/` or `pubspec.yaml` (verified 2026-10-19; leftover Firebase infra is unused), no accounts, no ads. "No accounts, no ads, nothing collected" is supportable; keep any claim limited to the app itself (Apple/Google collect their own TestFlight/Play data). The vault product facts and repo README "Step 10 / Firebase" lines are stale.

- **Website inputs (Justin 2026-10-19):** TestFlight link `https://testflight.apple.com/join/Qj1a4NA8`; Google Group `math-dragons@googlegroups.com`; app supports iPad; analytics Umami Cloud free; no waitlist at launch; privacy contact `privacy@routeworks.app` (developer Routeworks LLC; support `support@routeworks.app`); old routeworks URLs barely seen, redirects low priority. Old site text saved at `website/source/routeworks-2026-10-19.md`.
- **Beta perk:** lifetime free access for anyone who joins the beta and downloads the app (Justin 2026-10-19). Unconditional, never tied to ratings/reviews/feedback, which keeps it clear of Apple 3.2.2(x) and Google's ban on incentivized reviews. Apple 2.2 ("compensation of any kind") most plausibly covers testers paying, not developer perks; low risk, but copy should present it as a thank-you gift, not as payment for testing.

## Open decisions (need Justin)
- [x] **Monetization (Justin 2026-10-19):** everything is free during the beta; paid features arrive with full release (old site's $4.99 unlock/currency packs = the planned model, not current). Founding perk = beta families get the paid unlock free. **No store rules broken:** use Apple's built-in mechanisms (StoreKit `AppTransaction` grandfathering, Apple offer codes) and Google Play's equivalents (promo codes); nothing self-issued.
- [x] **DECIDED (Justin 2026-10-19): Option 1, founding-tester flag**, for now. App task (app workstream, separate branch): on first launch store `foundingTester=true` locally if before a built-in launch cutoff date; back-fill existing profiles on upgrade; PlayerProfile is Hive-backed with a forward-only schema migration system, so this needs a migration + tests. Cutoff date: placeholder far-future until launch is scheduled. Options 2-4 deferred to paid launch.
- [ ] (superseded) **How is "lifetime free access" honored with no accounts?** Claude's recommendation (2026-10-19): (1) date-cutoff founding-tester flag written locally on first launch (and back-filled for existing profiles), shipped soon; (2) website email list as the cross-platform founding-family record; (3) at paid launch, store offer codes or offline-verifiable signed codes for new devices/reinstalls; (4) honor-system code on request. Awaiting Justin on whether the app change belongs to this workstream. Original framing: The app has no login, so beta status lives only on the device. Needs a mechanism before any paid tier exists (e.g. a flag written by beta builds that survives the TestFlight/closed-test to store upgrade, plus a fallback for new devices/reinstalls such as a redeemable code emailed to beta signups). Affects what the site and videos may promise.
- [x] **Website stack LOCKED (Justin 2026-10-19): Astro + Cloudflare.** Fresh site; Astro + Cloudflare Workers (static assets) + Cloudflare DNS, analytics Umami Cloud free (Cloudflare Web Analytics can't do custom events), code in repo `/website`, docs in `marketing/website/`. Reason against Vercel Hobby: fair-use page (fetched 2026-10-19) says "Hobby teams are restricted to non-commercial personal use only", with "advertising the sale of a product or service" listed as commercial; a future freemium launch would require Pro ($20/mo). Justin is a pro web dev and open to suggestions.
- [x] **Short beta URL: `playmathdragons.com`** (registered by Justin 2026-10-19). Plan: domain points at a device-detecting landing page (iPhone to TestFlight, Android to Google Group + Play opt-in); per-video paths for attribution. Prior analysis: one short dedicated domain that 301-redirects to (or hosts) a device-detecting landing page, which sends iPhone visitors to TestFlight and Android to the Google Group + Play opt-in. Avoid bit.ly-style shorteners (low trust, spam-flagged on Meta). whois 2026-10-19: `mathdragons.com` registered 2025-08-25 (Justin's?); available per whois: `playmathdragons.com`, `getmathdragons.com`, `trymathdragons.com`, `mathdragons.fun`, `mathdragons.io`, `mathdragons.gg`; `mathdragons.app` has no DNS (likely available, unconfirmed).
- [x] **Dragon mascot personality + voice: APPROVED (Justin 2026-10-19)**: the Ancient Veteran, with Justin's cloned voice as main narrator and the dragon as recurring cameo/segment host. Production approach approved: ElevenLabs Voice Design dragon voice + rigged 2D puppet from style-bible art + Rhubarb Lip Sync mouth timing, AI video lip-sync only for tested hero moments. Original proposal (recommended: the ancient, theatrical veteran dragon who "was there" for math history; gruff and fierce, secretly soft; speaks to parents, with its own ElevenLabs Voice Design voice and Rhubarb lip-sync on a rigged 2D puppet). Seeds `guides/brand-and-voice.md`.
- [x] **Dragon name: Tallyclaw** (Justin 2026-10-19; nickname "Tally"). Conflict check 2026-10-19: no dragon/game character or trademark found by that name; `youtube.com/@tallyclaw` free (404); `tallyclaw.com` is taken by an unrelated QuickBooks bookkeeping service (different class, low risk, but no mascot .com and shared search results). Keep channel handles brand-level; Tallyclaw is a character, not the channel name.
- [x] **Domain `playmathdragons.com` registered by Justin** (2026-10-19).
- [x] **YouTube handle: `@playmathdragons`** (Justin 2026-10-19; `@mathdragons` belongs to someone else). Match it on Facebook where possible.
- [ ] Hold promo videos until current TestFlight + Play builds are approved, with a rebuild cadence that beats TestFlight's 90-day build expiry?
