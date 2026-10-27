# MD-001: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS WITH FIXES** (script and copy pass; recording is blocked until the join flows are live, which the treatment already says)

Build checked: 1.0.3 (8) = `28d6638` (`docs/RELEASES.md`; 1.0.4 (9) is not listed, so no adaptivity claim may appear, and none does). Site checked: `website/src/pages/index.astro` and `website/src/config/site.ts` on `main`, plus `website/phase-2` (diff is analytics attributes, the launch-list form and "app privacy policy"; no step wording changed).

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Free during the beta | TRUE | `index.astro` facts list "Free during the beta"; brand §5.2/§5.4. Store screen at `28d6638` shows "Premium Packs: Coming in a future update" (nothing to buy) | Don't show the Dragon Store screen in gameplay cuts |
| 2 | Four dragon math games (names) | TRUE | `git ls-tree 28d6638 lib/games`: 4 `*_registration.dart`, `displayName` = Dragon Eggs, Fire Trail, Dragon Runes, Dragon's Feast | none |
| 3 | For kids five to twelve | TRUE (positioning) | brand §5.2; site lede "ages 5 to 12" | none |
| 4 | Short practice in addition, subtraction, multiplication and division | TRUE, with a footage caveat | `28d6638`: Dragon Eggs/Fire Trail/Dragon Runes registrations include `MathOperation.division`. **But in 1.0.3 Dragon Eggs scores non-integral division as correct** (`lib/games/dragon_eggs/models/equation.dart` at `28d6638` has no remainder check; fixed in `3cd97d9`, "7 ÷ 2 = 3 is wrong", which ships only in 1.0.4 (9)). | Claims list cites `Operation.*`; the code is `MathOperation.*` (citation only). See fix 2 for footage |
| 5 | No ads | TRUE | `28d6638:lib/monetization/ad_manager.dart` is a 2-line TODO stub; no ad SDK in `pubspec.yaml` | none |
| 6 | No accounts | TRUE | no auth/account files or packages in `lib/` or `pubspec.yaml` at `28d6638` | none |
| 7 | The app collects no data | TRUE (scoped) | `pubspec.yaml` at `28d6638`: no network/analytics packages (only `url_launcher`, links behind the parental gate); `AndroidManifest.xml` has no INTERNET permission | none |
| 8 | It works offline | TRUE | same as 7: no network dependency; only outbound browser links need a connection | none |
| 9 | "Everyone in the beta gets the full unlock free when Math Dragons launches." | TRUE (exact §5.4 sentence, VO and card) | brand §5.4; string compared character for character | none |
| 10 | "It's my thank-you for joining." | OK | site says "our thank-you"; first person fits the Narrator; not tied to feedback | none |
| 11 | The page shows the steps for your device | TRUE | `index.astro` "Looks like your device" cards + `/js/platform.js` | none |
| 12 | iPhone/iPad: 3 steps (Get TestFlight; tap Join the Math Dragons beta; Accept, then Install) | TRUE as site wording; **NOT LIVE** | `index.astro` iOS `<ol>` has 3 `<li>` (py below); `LAUNCH-CHECKLIST.md` §7 all unchecked (Beta App Review, public link "isn't accepting any new testers") | Hard gate already in treatment; keep it |
| 13 | TestFlight is Apple's free app for testing new apps | TRUE | site wording; `site.ts` `testflightApp` = App Store id899247664 (TestFlight) | none |
| 14 | Android: 3 steps (join the tester group; Become a tester; install from Google Play) | TRUE as site wording; **NOT LIVE** | Android `<ol>` has 3 `<li>`; `LAUNCH-CHECKLIST.md` §8 closed-testing rollout unchecked, §9 end-to-end check unchecked | Hard gate already in treatment |
| 15 | Use the same Google account your Play Store uses | TRUE | `index.astro` bold warning | none |
| 16 | "App not available": check the account circle; it must be the account that joined the group | TRUE | `index.astro` `<details>` bullet 1 | none |
| 17 | Wait a few minutes, then try the tester page again | TRUE (site wording) | `index.astro` `<details>` bullet 2 | none |
| 18 | iPhone, iPad and Android | TRUE once live | brand §5.2; same gate as 12/14 | none |
| 19 | (missing from list) Description: "built by a dad" | TRUE | site "Why I built it"; brand §5.2 | add to claims list |
| 20 | (missing from list) Hook B text "iPhone or Android: 3 steps each" | TRUE (step counts) | py below | add to claims list if Hook B is picked |
| 21 | (missing from list) Gameplay footage equations (every number visible in the 5-13 s cuts and on any Dragon Eggs screen) | UNCHECKED (not yet captured) | script-standards §4: every on-screen number is checked | list the visible equations at capture; recompute at the render gate |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-001 / MD-002: site step counts and game count
ol blocks: 2 li per block: [3, 3]
registrations on main: 4 ['dragon_eggs_registration.dart', 'dragon_runes_registration.dart', 'dragons_feast_registration.dart', 'fire_trail_registration.dart']
age range 5..12 inclusive: [5, 6, 7, 8, 9, 10, 11, 12]
MD-001: 53 chars, 40<=len<=65: True | Join the Math Dragons beta on iPhone, iPad or Android
   first-comment paths: {'playmathdragons.com/fb001'}
   hashtags: #parenting #homeschool #teachers count 3
```
(Registrations also confirmed at `28d6638` with `git ls-tree`.) Word count: 212 tokens by regex, which splits `playmathdragons.com` in two (2 occurrences), so **210 words as stated**. Per-beat pace 1.0-2.4 words/s, all realistic; slowest beats are the tap-along steps, as intended. Em-dashes: 0. X/Y reframes: 0.

Sense read:
- As a parent: clear, ordered, honest. The same-account warning and the "App not available" fix are the right two things to dwell on. Nothing promises a time to join.
- As a math teacher: no math is taught, so the only exposure is gameplay. In 1.0.3, Dragon Eggs accepts an uneven division (e.g. 7 ÷ 2 = 3) as correct. A two-second cut that happens to show one would be the kind of clip that gets screenshotted.
- The description's feedback request sits on the line right after the perk sentence. Read quickly, "free unlock... If you can, let your kid play... then tell me" could look like a trade. The treatment says it "sits apart", but in the block it is the next line.
- If posted to Facebook, taps from the first comment open in Facebook's in-app browser, where the site itself warns the install steps may not work. The walkthrough doesn't mention it.

Compliance (§A-H):
- A Made for Kids: PASS. First spoken word and frame-one text "Parents"; subject is a parent task; gameplay only as 2 s demo cuts; no child-directed lines; parent/teacher/homeschool hashtags only.
- B Claims: PASS. All app claims on §5.2 and true at `28d6638`; no adaptivity; privacy scoped to "the app"; perk sentence exact and not tied to feedback (see fix 3 on layout).
- C AI disclosure: PASS. YouTube no (own voice clone, real screen recordings, illustration); Facebook yes if posted.
- D Engagement bait: PASS. FB caption question ("Which step would you want explained better?") is genuine.
- E Audio: PASS (game soundtrack, rights confirmed 2026-10-26).
- F Visuals/IP: PASS. No badges or ®, Apple bezel only, never side by side. The real TestFlight/Play screens appear only as steps, which is the point of the video.
- G Privacy: PASS. Dedicated test Google account, avatar blurred, no Apple ID visible.
- H Links/CTA: PASS. One CTA in the last 5 s, plain spoken URL; `/yt` first line of the description; `/fb001` only in the FB first comment. **Note:** `/yt` and `/fb###` redirects exist only on `website/phase-2` (`public/_redirects` is absent on `main`), so phase 2 must be deployed before upload (already in the treatment).

Fixes:
1. (Gate, unchanged) Do not record until LAUNCH-CHECKLIST §7, §8 and §9 are checked and `website/phase-2` is deployed. As of this review all three steps are open.
2. Gameplay capture: in Dragon Eggs, capture an addition or subtraction build (or release 1.0.4 (9) first and capture on it). At the render gate, list and recompute every equation visible in gameplay frames. Add this to Production notes and the Math strings section.
3. Description: separate the perk line from the feedback request (e.g. put the "How to join..." sentence or a blank line plus the hashtags between them, or move the feedback line above the perk), so the perk can't be read as payment for feedback (brand §5.4).
4. Claims list: add "built by a dad" (description) and Hook B's "3 steps each" text; fix the citation `Operation.*` to `MathOperation.*`.
5. Optional, only if posted to Facebook: one on-screen line in the 27-36 s beat, "In Facebook? Open in Safari or Chrome", matching the site's in-app-browser banner.

Justin sign-off:

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
