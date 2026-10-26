---
status: approved (Justin, 2026-10-26)
guide: idea-scoring-rubric
created: 2026-10-26
sources:
  - marketing/guides/brand-and-voice.md, compliance-checklist.md, content-strategy.md, format-library.md, script-standards.md
  - marketing/reports/Faceless short form video playbook.md
---

# Idea Scoring Rubric

How Stage 2 one-liners are filtered and ranked before Justin picks which become treatments. The weights are our own judgment (house rules), not research findings. Recalibrate them after the first 10-15 posts, using `metrics-and-learning.md` (to be written).

## 1. Gates (pass or fail, before any scoring)

An idea that fails any gate is dropped or rewritten, not scored.

| Gate | Fails if |
|---|---|
| **G1 Adult-addressable** | It only works spoken to a child, or needs kids on screen (`compliance-checklist.md` §A) |
| **G2 Verifiable** | Its core fact, number or story can't be verified, or is LOW confidence / legend without being framed as one |
| **G3 Honest claims** | It needs a claim the app doesn't support today, or a banned claim (`brand-and-voice.md` §5.2, §6.2). Adaptivity ideas pass but carry a dependency tag until the matching phase ships |
| **G4 No bait** | Its engagement depends on engagement bait, rage-bait ambiguity, or misleading framing (`compliance-checklist.md` §D) |
| **G5 Distinct** | It's a near-duplicate of a posted or banked idea |

## 2. Scores (1-5 each, weighted)

| Criterion | Weight | 1 | 3 | 5 |
|---|---|---|---|---|
| **Hook** (would a parent stop scrolling in the first second?) | ×3 | Needs explaining before it's interesting | Clear and mildly curious | An instant "wait, what?" with something to look at |
| **Share value** (would a parent send it to someone?) | ×3 | Nice to know | Useful or funny | "My partner needs to see this" / "try this tonight" |
| **Accuracy confidence** | ×2 | MODERATE, needs careful hedging | HIGH but needs a fresh source | In the verified trivia bank or plain arithmetic |
| **Our edge** (uses what only we have: gameplay, Tallyclaw, the dad story, verified math) | ×2 | Anyone could make it | Some of our assets | Only Math Dragons could make it |
| **Production effort** (higher = easier with today's tools) | ×2 | Needs tools or assets we don't have | A few hours with current tools | Hands, math cards and VO only |
| **Funnel fit** (does it naturally lead toward the beta?) | ×1 | No connection | Fits the brand world | The app is the natural next step |
| **Format fit** (loops cleanly, fits its format's length) | ×1 | Awkward fit | Fits | Built for the loop |

**Total:** sum of score × weight, out of 70. **Tier:** A = 53+ (make soon), B = 42-52 (bank), C = under 42 (park or rework).

Funnel fit is weighted low on purpose: most videos are value videos, and their job is reach and trust.

## 3. Dependencies (tags, not scores)

Tag ideas that can't ship yet, so they're banked rather than dropped:
- `needs:tallyclaw-puppet` (talking Tallyclaw; still art works for some F4 videos)
- `needs:adaptive-P1`, `needs:adaptive-P2`, … (adaptivity claims, per `docs/specs/adaptive-practice.md` §2.1)
- `needs:gameplay-capture` (scripted capture of a specific moment)
- `calendar:<date>` (time-bound: Fibonacci Day, Pi Day, and so on)

## 4. Idea bank format

`marketing/ideas/idea-bank.md`, one row per idea:

| Column | Content |
|---|---|
| ID | `I-###`, never reused |
| One-liner | The idea in one sentence |
| Pillar / series / format | e.g. 1 / Tricks They Didn't Teach Us / F2 |
| Hook draft | First frame and first words |
| Gates | ✓ or the failed gate |
| Scores | H / S / A / E / P / F / Fit |
| Total / tier | e.g. 58 / A |
| Tags | dependencies, calendar |
| Status | banked / picked / MD-### / posted / parked |

## 5. Picking a batch

1. Sort by tier, then total.
2. Justin picks, aiming for the 4-week cycle in `format-library.md` (4 / 3 / 3 / 2 across the pillars).
3. Prefer ideas with no dependencies for the first batch.
4. Picked ideas get an `MD-###` ID and a `videos/MD-###/` folder, and move to Stage 3 (treatment).
