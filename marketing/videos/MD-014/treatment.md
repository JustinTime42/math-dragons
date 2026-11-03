---
id: MD-014
status: treatment
pillar: 4
series: Dad Dev Diary
format: F7
target_length_s: 37
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: yes
calendar_hook:
---

# MD-014: Why I built this (origin story)

## Concept
In my own words, parents hear why I built Math Dragons: the math apps we tried felt like worksheets in a costume, so I built games where solving the problem is the fun part. Then the facts, then the one CTA.

> **Justin picks the final wording at the script gate.** The default script uses his candidate lines 1 and 2 (lightly trimmed, see "Wording options" below). Candidate 3 is kept as an alternate (reviewer's compliant wording, DECIDED by Justin 2026-11-03 (recommended default kept)). The perk sentence is out of the default (DECIDED by Justin 2026-11-03 (recommended default kept), see "Perk (alternate block)").

## Hooks
- A: First frame: Justin's hands at a keyboard, an early dragon sketch on paper beside it. On-screen text: "Why I built a math game". VO (Narrator): "Parents, my daughter was struggling with math facts."
- B: First frame: Dragon Eggs gameplay, eggs piling up toward the danger line. On-screen text: "A worksheet in a costume". VO (Narrator): "Parents, every math app we tried was a worksheet with a costume on."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-3 s | Hands at keyboard, early dragon sketch beside it (no screen content legible) | "Why I built a math game" | Narrator: "Parents, my daughter was struggling with math facts." |
| 3-13 s | Illustration: a plain worksheet wearing a cartoon costume (a party hat and cape), sliding aside; a "chore" checklist ticks off before a small game icon appears | "A worksheet in a costume" | Narrator: "Every math app we tried was a worksheet with a costume on. The math was the chore you did to get back to the fun." |
| 13-15 s | Gameplay: Dragon Eggs, eggs piling up toward the danger line at the top | "Risk" | Narrator: "A real game has risk," |
| 15-17 s | Gameplay: Fire Trail, mid-world level, the dragon moving nonstop at the level's constant speed toward the gems (the "clock" is its pace and, in Dragon Eggs, the egg spawn timer; there's no per-question timer) | "A clock you're racing" | Narrator: "a clock you're racing," |
| 17-19 s | Gameplay: Dragon Scales counter ticking up after a correct answer (plus a dragon evolution moment only if one is reachable on the test profile; never faked) | "A reward you earn" | Narrator: "and a reward that feels earned." |
| 19-23 s | Illustration: the worksheet again, a single gold star at the bottom | "Worksheet: reward at the end" | Narrator: "A worksheet only has the reward at the end." |
| 23-28 s | Gameplay: Fire Trail, the dragon eats the right gem (correct chime) | "Solving it is the fun part" | Narrator: "So I built games where solving the problem is the fun part." |
| 28-32 s | Hub screen, the four game cards | "4 games · No ads · No accounts" / "The app collects no data" | Narrator: "Four dragon games. No ads. No accounts. The app collects no data." |
| 32-37 s | Hub with the dragon companion; URL card in the safe area; last frame returns to the sketch from frame one (loop) | "Free during the beta" / "playmathdragons.com" | Narrator: "It's free during the beta. If you want in, it's playmathdragons.com." |

Word count: 92 Narrator words (budget about 92 at 2.5 words/s for 37 s; F7 range 20-45 s)

### Perk (alternate block): DECIDED by Justin 2026-11-03 (recommended default kept)
Default per the review: **no perk in this video** (the delivery path isn't built, `pages-v1.review` I14 isn't closed, the 8-second CTA broke the 2-5 s rule, and the perk already appears on the site, MD-001 and MD-002). If Justin decides to keep it, swap the 32-37 s row for this one (105 words, about 43 s; set `target_length_s: 43`):

| Time | Visual | On-screen text | VO |
|---|---|---|---|
| 32-43 s | Hub with the dragon companion; full-screen text card for the perk (it's 13 words, too long for a callout), then the URL card | "Free during the beta" / text card with the exact sentence "Everyone in the beta gets the full unlock free when Math Dragons launches." / "playmathdragons.com" | Narrator: "It's free during the beta. Everyone in the beta gets the full unlock free when Math Dragons launches. If you want in, it's playmathdragons.com." |

Never a shortened on-screen paraphrase such as "Full unlock free at launch" (fails §5.4: it drops "Everyone in the beta").

### Wording options (Justin chooses at the script gate)
Default (in the script above): candidate 1's first two sentences, candidate 2's first two sentences, then candidate 1's closing sentence. Changes from Justin's candidates, and why:
- Candidate 2's last sentence ("I wanted the whole path to feel like a game, with every move a real math problem.") is **dropped from the default**: "every move a real math problem" overstates the app (flying in Fire Trail and moving around the board in Dragon's Feast aren't answers; idea-bank.review I-119). If Justin wants it, use: "I wanted the whole path to feel like a game, with real math at every step that counts." (+19 words, about 45 s; still inside the F7 range.)
- **Alternate (candidate 3), DECIDED by Justin 2026-11-03 (recommended default kept):** "I wanted the pull of the games kids love, pointed at something good: a real math workout that feels like playing." (21 words; the reviewer's minimal fix, changing only "kids can't put down", which fails §6.2, to "kids love". Swap it in for the 19-28 s lines.)

Optional gated line (not in the default; Phase 1 claim C1, verbatim; **publish only after 1.0.4 (9) is released to testers** and the §9.5 claim tests pass): "Math Dragons keeps track of the math facts your kid misses." (+11 words, would push to about 47 s; cut "Four dragon games." to compensate.)

## Math strings (exact, rendered from code)
- `4 games` (py: four registrations, `lib/games/*/*_registration.dart`)
- No equations on screen beyond what appears inside the captured gameplay (captured, not rendered; review the clips so every visible problem and answer is correct, which the app's own generator guarantees, but check the frames shown).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | "my daughter was struggling with math facts" | Justin's own account; website origin line confirmed by Justin (`marketing/website/LAUNCH-CHECKLIST.md:32`, `website/src/pages/index.astro:38`) | HIGH (author's story) |
| 2 | "Every math app we tried was a worksheet with a costume on. The math was the chore you did to get back to the fun." | Justin's experience (his source notes below); scoped to "we tried", no app named. Matches the "chocolate-covered broccoli" critique of bolted-on edutainment (Bruckman 1999, playbook evidence table "Integrated design", MODERATE) | Author's experience (unverifiable by design); framing MODERATE |
| 3 | "A real game has risk" (shown: Dragon Eggs) | Line numbers are the installable build 1.0.3 (8), commit `28d6638`. Dragon Eggs ends when an active egg reaches the danger line (`lib/games/dragon_eggs/dragon_eggs_flame_game.dart:324-334` `_checkGameOver`, `components/danger_line.dart`); Fire Trail: wall hit on no-wrap levels (`lib/games/fire_trail/fire_trail_flame_game.dart:161-169`) and the flame going out after wrong answers (`:232-247`; −0.20 per wrong answer, `flame_intensity` `onWrongAnswer`) | HIGH (app behavior) |
| 4 | "a clock you're racing" (shown: Fire Trail) | No per-question timer exists; Fire Trail's "countdown" is only the 3-2-1 before play. The clock is: Fire Trail's dragon never stops, moving at a constant per-level speed (`lib/games/fire_trail/models/fire_trail_config.dart:34-46` `speedForLevel`, used as `stepsPerSecond`), and Dragon Eggs spawns eggs on a timer, twice as fast during a wrong-answer penalty (`lib/games/dragon_eggs/systems/egg_spawner.dart:47`), falling under gravity (`systems/egg_physics.dart:35`) (build 8) | HIGH (app behavior) |
| 5 | "a reward that feels earned" (shown: scales, evolution) | Dragon Scales per correct answer (`lib/core/reward_service.dart:88-90`) and per level plus a 3-star bonus (`:104-109`); scales counter in the HUD (`lib/games/shared/game_shell.dart:197-217`); evolution stages 0-5 (`lib/core/progression_manager.dart:19`, `:51-70`) (build 8) | HIGH (mechanics exist); "feels earned" is opinion |
| 6 | "A worksheet only has the reward at the end." | Justin's framing (opinion) | n/a (opinion) |
| 7 | "So I built games where solving the problem is the fun part." | In each game you answer through the action: eat the right gem (Fire Trail, idea-bank.review I-119 wording), hatch eggs with equations (Dragon Eggs), connect runes (Dragon Runes), eat the right numbers (Dragon's Feast) (registration descriptions, `lib/games/*/*_registration.dart`); brand-and-voice §5.3 message 2 ("The math is the game") | HIGH (design), opinion ("fun") |
| 8 | "Four dragon games." | `lib/app.dart:108-111` registers four games in build 8; `lib/games/*/*_registration.dart` (Dragon Eggs, Fire Trail, Dragon Runes, Dragon's Feast); §5.2 | HIGH |
| 9 | "No ads." | §5.2; `lib/monetization/ad_manager.dart` empty stub; no ad SDK in `pubspec.yaml` | HIGH |
| 10 | "No accounts." | §5.2; no auth code or packages | HIGH |
| 11 | "The app collects no data." | §5.2; no network packages; no Android INTERNET permission in 1.0.3 (8) (`docs/RELEASES.md`) | HIGH |
| 12 | "It's free during the beta." | §5.2, §5.4 | HIGH |
| 13 | Perk sentence: **not in the default script** (DECIDED by Justin 2026-11-03 (recommended default kept); alternate block only). If used: exact §5.4 wording, spoken and as a full text card; never a paraphrase | §5.4; `pages-v1.review.md` I14 (delivery path not built: `FoundingTester.record()` stores an on-device flag only, `lib/main.dart:26`); review rows 13-14 | n/a in default |
| 14 | URL `playmathdragons.com` | `website/src/config/site.ts` `SITE_URL` | HIGH |

Words avoided per the brief: no "addictive/addicting/hooked", no brain-chemistry or dopamine language, "a clock you're racing" in place of "time pressure", no competitor names, no claim about all apps.

## CTA
"It's free during the beta. If you want in, it's playmathdragons.com." (once, after the payoff, last 5 s, spoken and on screen; standard wording per content-strategy §6). Perk version: see the alternate block, DECIDED by Justin 2026-11-03 (recommended default kept).

## Copy
- YouTube title: Why I Built a Math Game Where Solving Is the Fun Part (53 chars)
- Shorts description: The math apps we tried felt like worksheets in a costume, so I built four dragon games where solving the problem is the fun part. No ads, no accounts, and the app collects no data. Free beta: playmathdragons.com #parenting #homeschool #parentingtips #mathforparents
- Facebook caption: Why I built Math Dragons: the math apps we tried felt like worksheets with a costume on, so I built games where solving the problem is the fun part. What makes a learning game feel like a real game to your kid?
- Facebook first comment: Free beta for iPhone, iPad and Android: playmathdragons.com/fb014
- Hashtags: #parenting #homeschool #parentingtips #mathforparents

## Production notes
- **Justin's source notes (verbatim, 2026-10-27):** "Basically most math problems are just math worksheets with some gamey decorators, not genuinely fun games on their own. A genuinely fun game has risk, time pressure, and satisfying rewards. A math worksheet may have the satisfying reward, but nothing genuinely fun on the path toward it. The idea of these math games is that kids are genuinely solving math problems and exercising those math brains, but in the form of games that have all the elements of an addicting time waster games that get people so hooked. So we are leveraging those same brain chemistry rewards of viral mobile games but in a way that genuinely gives the brain a math workout."
- **Hands footage:** Justin's hands at a keyboard, overhead or side; an early dragon sketch (real one if it exists, otherwise skip that prop; don't fake a "first sketch"). Nothing legible on the monitor; no code-on-screen walls (F7 rule).
- **Illustration:** worksheet in a costume (party hat, cape), a chore checklist, a single gold star; style-bible look, no text inside AI images, no children shown.
- **Gameplay to capture** (physical Android phone, `scrcpy --record`, DND, fresh profile; capture from the installable build, not a dev build of `main`):
  1. Dragon Eggs: eggs stacking close to the danger line, then a correct answer clearing one (about 4 s).
  2. Fire Trail: a mid-world level where the dragon's constant speed is visible, eating the right gem with the correct chime (about 6 s, used twice).
  3. Dragon Scales counter animating after a correct answer (about 3 s). Show an evolution only if one is reachable on the test profile in reasonable time; never fake one.
  4. Hub with the four game cards and the dragon companion (about 10 s).
  Do not show: Dragon Runes world names ("Inferno Algebra", "Dragon's Calculus"), the store screen's "Premium Packs" placeholder, any debug banner.
- **No child's name, face or voice**; "my daughter" only (`compliance-checklist.md` §G). "Alaska" left out (footer/story-page only, §5.2).
- **Music:** `assets/audio/music/hub_theme.ogg` under the story, `dragon_eggs.ogg` / `fire_trail.ogg` under the matching clips, all low. SFX: `assets/audio/sfx/correct.wav`, `scales_earn.wav`, `evolution.wav` from the game.
- **Cover frame:** 0-3 s, hands and sketch with "Why I built a math game" visible.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: Dad Dev Diary
- AI disclosure: YouTube no (Justin's own cloned voice, real gameplay) / Facebook yes (realistic AI voice)
- Facebook first-comment path: /fb014

## Gate checklist (script-standards §9, self-check)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows F7 beats (moment, decision and reasoning with gameplay, one CTA at the end)
- [x] Word count within budget for the target length
- [x] Voice checklist passed (`brand-and-voice.md` §11): first person "I"; no banned words in the default script (candidate 3 as supplied fails §6.2 and is flagged)
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (standard CTA, last 5 s; perk out of the default, DECIDED by Justin 2026-11-03 (recommended default kept))
- [x] Titles and copy written to §7
- [x] Compliance checklist §A-H passed (default script; the gated C1 line is excluded)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off (including the final origin wording)

## Fixes applied (2026-10-27)
From `review.md` (script gate, PASS WITH FIXES):
- **Perk (DECIDED by Justin 2026-11-03 (recommended default kept)):** applied the reviewer's default. Removed the perk sentence from the VO and the on-screen "Full unlock free at launch" (which failed §5.4). The CTA is back to the standard line in the last 5 s. The exact perk sentence is kept as an alternate block with a full text card, for Justin to choose.
- **Candidate 3 (DECIDED by Justin 2026-11-03 (recommended default kept)):** the alternate now reads "I wanted the pull of the games kids love, pointed at something good: a real math workout that feels like playing."
- Code citations corrected to the installable build 1.0.3 (8), `28d6638`: Fire Trail `fire_trail_flame_game.dart:161-169` (wall hit) and `:232-247` (wrong answer, flame out); Dragon Eggs `:324-334`; `fire_trail_config.dart:34-46`; `egg_spawner.dart:47`; `reward_service.dart:88-90`, `:104-109`; `game_shell.dart:197-217`; `progression_manager.dart:19`, `:51-70`; `app.dart:108-111`.
- The clock is described accurately: no per-question timer; Fire Trail's dragon moves at a constant per-level speed, and Dragon Eggs spawns eggs on a timer (faster after a wrong answer). The Fire Trail clip must show a mid-world speed.
- Evolution shown only if reachable on the test profile; never faked.
- Word count 105 to 92; length 43 s to 37 s; script timings re-cut.
- Note for Justin (guide, not changed here): `format-library.md` F7 cites "Fire Trail's countdown" as timing answers; it's only a 3-2-1 start countdown.
