# MD-002: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS WITH FIXES**

Build checked: 1.0.3 (8) = `28d6638` (`docs/RELEASES.md`). 1.0.4 (9) is **not** listed as installable, so the optional C1 swap stays unpublishable; the default line must be used.

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Four dragon math games | TRUE | `28d6638`: 4 `*_registration.dart` files | none |
| 2 | No ads | TRUE | `28d6638:lib/monetization/ad_manager.dart` is a TODO stub; no ad SDK | none |
| 3 | Free during the beta | TRUE | brand §5.4; site facts list | none |
| 4 | For kids five to twelve | TRUE (positioning) | brand §5.2 | none |
| 5 | Short practice with addition, subtraction, multiplication and division (`+ − × ÷`) | TRUE, footage caveat | `MathOperation.division` in Dragon Eggs, Fire Trail and Dragon Runes at `28d6638`. In 1.0.3, Dragon Eggs accepts uneven division as correct (no remainder check in `models/equation.dart`; fixed in `3cd97d9`, not yet released) | Citation says `Operation.*`; code is `MathOperation.*`. See fix 3 |
| 6 | No accounts | TRUE | no auth code or packages | none |
| 7 | The app collects no data | TRUE (scoped) | no network/analytics packages; no INTERNET permission at `28d6638` | none |
| 8 | iPhone, iPad and Android | TRUE as a platform fact; **join flows NOT LIVE** | `LAUNCH-CHECKLIST.md` §7-§9 unchecked (TestFlight public link not accepting testers; Play rollout pending) | Gate already in treatment; keep it |
| 9 | "I built it for my daughter." | TRUE | site "Why I built it" (approved, LAUNCH-CHECKLIST §4) | none |
| 10 | Perk sentence | TRUE (exact §5.4, VO and card) | compared character for character | none |
| 11 | (Optional swap) C1 "Math Dragons keeps track of the math facts your kid misses." | NOT PUBLISHABLE TODAY | spec §2.1: needs Phase 1 merged, **released**, §9.5 tests passing; RELEASES.md lists only 1.0.3 (8) | Keep the default line. Also: the swap drops "The app collects no data" and "iPhone, iPad and Android"; check the beat still fits 5 s (13 words = 2.6 w/s, OK) |
| 12 | (missing from list) Description and caption: "Four short dragon math games... built by a dad" | TRUE | site; brand §5.2 | add to claims list |
| 13 | (missing from list) Hook B: "I built my daughter a math game with no ads and no accounts" | TRUE | as 2, 6, 9 | add if Hook B is picked |
| 14 | (missing from list) Gameplay equations visible in the hub/game cuts and the Dragon Eggs hatch | UNCHECKED (not captured) | script-standards §4 | list at capture, recompute at render gate |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
ol blocks: 2 li per block: [3, 3]
registrations on main: 4 ['dragon_eggs_registration.dart', 'dragon_runes_registration.dart', 'dragons_feast_registration.dart', 'fire_trail_registration.dart']
age range 5..12 inclusive: [5, 6, 7, 8, 9, 10, 11, 12]
MD-002: 58 chars, 40<=len<=65: True | Four dragon math games for kids 5-12, free during the beta
   first-comment paths: {'playmathdragons.com/fb002'}
   hashtags: #parenting #homeschool #teachers count 3
```
Per-beat pace (words / seconds):
```
0-5 s   11 w / 5s = 2.20 w/s
5-11 s  14 w / 6s = 2.33 w/s
11-16 s 11 w / 5s = 2.20 w/s
16-19 s  6 w / 3s = 2.00 w/s
19-24 s 13 w / 5s = 2.60 w/s
24-28 s 12 w / 4s = 3.00 w/s <-- FAST
TOTAL 67 tokens (URL counted as 2) = 66 words, as stated
```
The CTA beat is the problem: "It's free during the beta. If you want in, it's playmathdragons.com." is 11 written words, but the URL is spoken as "play math dragons dot com", so about 14 spoken words in 4 s (3.5 w/s). Em-dashes: 0. X/Y reframes: 0.

Sense read:
- As a parent: a clean summary. "Free during the beta" is said twice (hook and CTA); acceptable for a promo Short, but it's the most repetitive line in the batch.
- As a math teacher: the only risk is gameplay. A 1.5 s cut of Dragon Eggs showing a "correct" uneven division in 1.0.3 would be a real error on screen.
- Made for Kids lens: this is the batch's highest-risk video. Over half the runtime is gameplay or the hub, plus Tallyclaw art, and the **YouTube title is product-for-kids language with no adult address** ("Four dragon math games for kids 5-12..."). Title, description and hashtags are what YouTube's classifier reads alongside the visuals.

Compliance (§A-H):
- A Made for Kids: PASS WITH FIX. Spoken "Parents" and on-screen "Parents: free beta" on frame one, no child-directed lines, parent hashtags. Fix the title (fix 1).
- B Claims: PASS. All on §5.2 and true at `28d6638`; adaptivity only in the gated optional swap; privacy scoped; perk exact and untied.
- C AI disclosure: PASS (YouTube no; Facebook yes).
- D Engagement bait: PASS (caption has no question, which is better than a forced one).
- E Audio: PASS (game soundtrack).
- F Visuals/IP: PASS. No badges, no ®; avoid "Inferno Algebra"/"Dragon's Calculus" (noted).
- G Privacy: PASS (test profile, no kids).
- H Links/CTA: PASS. One CTA, after the payoff, plain spoken URL; `/fb002` only in the first comment; no step count or time. Requires `website/phase-2` deployed for `/fb002` (noted).

Fixes:
1. Title: lead with the adult. For example `Parents: 4 dragon math games for kids 5-12, free in beta` (56 chars) or `For parents: a free beta of 4 dragon math games, ages 5-12` (58 chars). Recompute the length after editing.
2. Timing: give the CTA 5 s (24-29 s, target 29 s) or cut one beat's words, e.g. 0-5 s "Parents: four dragon math games. No ads. Free in beta." Re-time and recount.
3. Gameplay capture: in Dragon Eggs show an addition or subtraction build (or capture on 1.0.4 (9) once released). List every equation visible in footage and recompute it at the render gate.
4. Claims list: add the description/caption "built by a dad" and Hook B's line; fix `Operation.*` to `MathOperation.*`.
5. Publish gate (unchanged): LAUNCH-CHECKLIST §7-§9 done, `website/phase-2` deployed, MD-001 live as the related video.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
