---
id: MD-002
status: treatment
pillar: 4
series: none
format: F8 (F8b, "How to join" Short, vertical 9:16)
target_length_s: 28
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: yes
calendar_hook: none
---

# MD-002: How to join the Math Dragons beta

## Concept
In under 30 seconds a parent learns what the beta is (four dragon math games, no ads, no accounts, the app collects no data), who it's for (kids 5-12), the perk, and where to join.

## Hooks
- A: Frame one: a phone showing the four game icons from the app's hub. On-screen text: "Parents: free beta". Narrator: "Parents, four dragon math games, no ads, free during the beta."
- B: Frame one: Fire Trail gameplay mid-answer. On-screen text: "No ads. No accounts." Narrator: "Parents, I built my daughter a math game with no ads and no accounts."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-5 s | Gameplay: the app's hub on a phone, the four game icons; quick punch-in on each | Parents: free beta | Narrator: Parents, four dragon math games, no ads, free during the beta. |
| 5-11 s | Gameplay: 1.5 s cuts of Dragon Eggs, Fire Trail, Dragon Runes, Dragon's Feast | Kids 5-12 / + − × ÷ | Narrator: They're for kids five to twelve: short practice with addition, subtraction, multiplication and division. |
| 11-16 s | Tallyclaw still (neutral) beside a list ticking in | No accounts / The app collects no data / iPhone, iPad, Android | Narrator: No accounts. The app collects no data. iPhone, iPad and Android. |
| 16-19 s | Gameplay: a Dragon Eggs correct answer, egg hatches | Built by a dad | Narrator: I built it for my daughter. |
| 19-24 s | Text card on purple, gold underline under "full unlock" | Everyone in the beta gets the full unlock free when Math Dragons launches. | Narrator: Everyone in the beta gets the full unlock free when Math Dragons launches. |
| 24-28 s | Hub screen again (loops to frame one); URL large inside the safe area | Free during the beta / playmathdragons.com | Narrator: It's free during the beta. If you want in, it's playmathdragons.com. |

Word count: 66 (budget about 70 for 28 s at 2.5 words/s).

Optional swap, **publish after 1.0.4 (9) is released to testers** (and the spec §9.5 claim tests pass): replace "No accounts. The app collects no data. iPhone, iPad and Android." with the C1 claim verbatim plus the facts that fit: "Math Dragons keeps track of the math facts your kid misses. No accounts." (spec §2.1 C1; brand §5.2). Keep the default line until `docs/RELEASES.md` lists 1.0.4 (9) as installable.

## Math strings (exact, rendered from code)
- `Kids 5-12`
- `+ − × ÷` (operation symbols only, no equation)

Verified (python, 2026-10-27): all four `Operation` values appear in the Dragon Eggs, Fire Trail and Dragon Runes registrations.

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Four dragon math games | code: `lib/games/*/*_registration.dart` (4 games); brand §5.2 | HIGH |
| 2 | No ads | brand §5.2; idea-bank.review §2 (I-113 check) | HIGH |
| 3 | Free during the beta | brand §5.4 | HIGH |
| 4 | For kids five to twelve | brand §5.2 | HIGH (positioning) |
| 5 | Short practice with addition, subtraction, multiplication and division | site lede (approved); code `Operation.*` in registrations | HIGH |
| 6 | No accounts | brand §5.2 | HIGH |
| 7 | The app collects no data | brand §5.2 (scoped to the app); `docs/RELEASES.md` 1.0.3 (8) no INTERNET permission | HIGH |
| 8 | iPhone, iPad and Android | brand §5.2 (TestFlight + Play closed testing) | HIGH, once LAUNCH-CHECKLIST steps 7-9 are done |
| 9 | "I built it for my daughter." | site `index.astro` "Why I built it" (confirmed by Justin, LAUNCH-CHECKLIST Part 1 §4); brand §4.4 | HIGH |
| 10 | "Everyone in the beta gets the full unlock free when Math Dragons launches." | brand §5.4 exact sentence | HIGH |
| 11 | (Optional swap only) "Math Dragons keeps track of the math facts your kid misses." | `docs/specs/adaptive-practice.md` §2.1 C1 | Publish after 1.0.4 (9) is released to testers |

## CTA
Narrator, last 4 s, spoken and on screen: "It's free during the beta. If you want in, it's playmathdragons.com."

## Copy
- YouTube title: `Four dragon math games for kids 5-12, free during the beta` (58 characters)
- Shorts description:
  ```
  Four short dragon math games for kids 5 to 12, built by a dad. No ads, no accounts, and the app collects no data.
  Free beta: playmathdragons.com
  #parenting #homeschool #teachers
  ```
- Facebook caption: "Four short dragon math games for kids 5 to 12, built by a dad. No ads, no accounts, and the app collects no data."
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb002`
- Hashtags: #parenting #homeschool #teachers

## Production notes
- **Gameplay to capture** (physical Android phone, `scrcpy --record`, Do Not Disturb, fresh test profile): the hub with the four icons; one clean correct answer in each game; one Dragon Eggs hatch. Avoid Dragon Runes world names "Inferno Algebra" and "Dragon's Calculus" on screen. No debug banner. Gameplay shown as a demo for the parent, never a long loop on its own (compliance §A).
- **Tallyclaw still:** neutral pose, from `04_stone_dragon.png` / `09_stone_face.png` (visual-style §8). No Tallyclaw voice; he never delivers the CTA.
- **Music:** `assets/audio/music/fire_trail.ogg`, under the VO and ducked. SFX: the game's correct-answer chime on the hatch.
- **Cover frame:** 24-28 s, URL and "Free during the beta" visible over the hub.
- **Prerequisites:** LAUNCH-CHECKLIST steps 7-9 done (both join flows working) and `website/phase-2` deployed (the `/fb###` redirect is only in that branch's `public/_redirects`). MD-001 must be live first so it can be this Short's related video.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: none (optional "Join the beta" playlist with MD-001)
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own voice clone, gameplay, still art) / Facebook yes (realistic AI voice, compliance §C)
- Facebook first-comment path: /fb002

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows its format's beats (F8b: what you get, who it's for, the one CTA; points to F8a)
- [x] Word count within budget for the target length (66 vs about 70)
- [x] Voice checklist passed (brand §11); zero em-dashes, zero X/Y reframes; perk sentence exact; adaptivity only in the flagged optional swap
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded
- [x] Titles and copy written to §7 (no genuine question fits this promo, so the caption has none rather than a forced one)
- [x] Compliance checklist §A-H passed (no kids on screen, no kid tags; claims on §5.2; no badges; one CTA; no step count or time promised)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off
