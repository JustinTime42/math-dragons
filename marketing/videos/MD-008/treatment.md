---
id: MD-008
status: treatment
pillar: 4
series: none
format: F6
target_length_s: 38
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: yes
calendar_hook:
---

# MD-008: Three questions to ask before installing a kids' app

## Concept
Parents get three questions (ads, accounts, data) and where to check two of them on the store page, then hear my honest answers for Math Dragons.

## Hooks
- A: First frame: a phone mockup on Deep Void with three gold question marks over the "Install" area. On-screen text: "3 questions before you install". VO (Narrator): "Parents, ask three questions before you install any kids' app."
- B: First frame: a thumb hovering over a generic "Install" button (our own mockup, no real store UI). On-screen text: "Your kid wants a new app?" VO (Narrator): "Your kid wants a new app. Ask these three things first."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-4 s | Illustration/math card: phone mockup (our own generic design, no store branding), three gold question marks pulse in one at a time | "3 questions before you install" | Narrator: "Parents, ask three questions before you install any kids' app." |
| 4-11 s | Card 1: "1" in gold, a crossed-out ad banner icon; then a small text card "Google Play: Contains ads" | "1. Does it show ads?" / "Google Play: Contains ads" | Narrator: "One. Does it show ads? On Google Play, an app with ads says 'Contains ads' on its page." |
| 11-15 s | Card 2: "2" in gold, a login-box icon | "2. Does it need an account?" | Narrator: "Two. Does it need an account before your kid can play?" |
| 15-25 s | Card 3: "3" in gold, a shield icon; then two text labels side by side: "App Store: App Privacy" / "Google Play: Data safety"; then a small line "Filled in by the developer" | "3. What data does it collect?" / "App Privacy · Data safety" / "Filled in by the developer" | Narrator: "Three. What data does the app collect? Both app stores have a privacy section on the app's page. The developer fills it in." |
| 25-29 s | Gameplay (hard cut): Math Dragons launches straight to the hub, no sign-in screen; then Fire Trail, the dragon eats the right gem | "My answers:" | Narrator: "Here are my answers for the dragon math game I built." |
| 29-33 s | Gameplay continues (Fire Trail, then Dragon Eggs); three gold check marks pop in one per phrase, echoing the three question marks | "No ads ✓" / "No accounts ✓" / "The app collects no data ✓" | Narrator: "No ads. No accounts. The app collects no data." |
| 33-38 s | Hub screen with the dragon companion; URL card in the safe area; final frame returns to the three question marks, now checks (loop) | "Free during the beta" / "playmathdragons.com" | Narrator: "It's free during the beta. If you want in, it's playmathdragons.com." |

Word count: 93 Narrator words (budget about 95 at 2.5 words/s for 38 s; F6 range 20-40 s)

## Math strings (exact, rendered from code)
- None. The only numerals on screen are the list markers `1.`, `2.`, `3.` and the count in "3 questions" (the script asks exactly three).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | "On Google Play, an app with ads says 'Contains ads' on its page." | Google Play Console Help 9859455 (fetched 2026-10-27): "Apps that contain ads show a 'Contains ads' label on their store listing. This label will be visible to all Play Store users." | HIGH |
| 2 | "Both app stores have a privacy section on the app's page." (labels "App Privacy" and "Data safety") | Apple, developer.apple.com/app-store/app-privacy-details/ (fetched 2026-10-27): "On each app's product page, users can learn about some of the data types the app may collect"; Google Play Help 11416267 (fetched 2026-10-27): "Under 'Data safety,' you'll find a summary of the app's data safety practices." Reviewer: confirm the App Store section heading reads "App Privacy" on a current product page | HIGH (heading "App Privacy" confirmed on a live App Store product page by the reviewer, 2026-10-27) |
| 3 | "The developer fills it in." | Apple page: "You'll need to provide information about your app's privacy practices ... in App Store Connect"; Google: "Developers use the Data safety section to share information about how their app handles your data", and an independent review "does not verify the accuracy and completeness" | HIGH |
| 4 | "the dragon math game I built" (Justin built it) | brand-and-voice §5.2 "Built by a dad for his own kid" | HIGH |
| 5 | "No ads." | brand-and-voice §5.2; `lib/monetization/ad_manager.dart` is an empty TODO stub; no ad SDK in `pubspec.yaml` (idea-bank.review §2, re-checked 2026-10-27) | HIGH |
| 6 | "No accounts." | §5.2; no auth code or packages in `lib/` or `pubspec.yaml`; profile is a local Hive object (`lib/core/player_profile.dart`) | HIGH |
| 7 | "The app collects no data." (scoped to the app) | §5.2; no network packages in `pubspec.yaml`; no Android INTERNET permission in 1.0.3 (8) (`docs/RELEASES.md`); external links behind the parental gate (`lib/core/external_links.dart`) | HIGH |
| 8 | Visual: app opens with no sign-in screen | `lib/hub/` (no login screen exists); confirm in the capture | HIGH |
| 9 | "It's free during the beta." | §5.2, §5.4 | HIGH |
| 10 | URL `playmathdragons.com` | `website/src/config/site.ts` `SITE_URL` | HIGH |

No adaptivity claim is used, so nothing here waits on 1.0.4 (9).

## CTA
"It's free during the beta. If you want in, it's playmathdragons.com." (once, after the payoff, last 5 s, spoken and on screen)

## Copy
- YouTube title: 3 Questions to Ask Before Installing Any Kids' App (50 chars)
- Shorts description: Three questions worth asking before any kids' app goes on your phone, and where the app stores show two of the answers. Free beta: playmathdragons.com #parenting #parentingtips #homeschool #teachertips
- Facebook caption: Three questions I'd ask before any kids' app goes on the family tablet: ads, accounts, and what data it collects. What do you check before you hit install?
- Facebook first comment: Free beta for iPhone, iPad and Android: playmathdragons.com/fb008
- Hashtags: #parenting #parentingtips #homeschool #teachertips

## Production notes
- **Assets:** three question-card graphics and the check-mark card (our own icons on Deep Void to Dragon Purple, Nunito Bold, gold numerals, `visual-style.md` §3-6). The phone and "Install" mockup is our own generic drawing: no Apple or Google UI, no store badges, no screenshots of any other app (`compliance-checklist.md` §F).
- **Gameplay to capture** (physical Android phone, `scrcpy --record`, Do Not Disturb, fresh test profile, `production-pipeline.md` §3.5):
  1. Cold launch from the home screen to the hub, showing there is no sign-in or account screen (about 3 s).
  2. Fire Trail, an early level: the dragon eats a correct gem (about 4 s).
  3. Dragon Eggs, an early level: a correct equation hatches an egg (about 3 s).
  4. Hub with the dragon companion for the CTA backdrop (about 5 s).
  Do not show: the store screen ("Premium Packs: Coming in a future update", `store_screen.dart:52`, reads like a purchase prompt), Dragon Runes world names ("Inferno Algebra", "Dragon's Calculus"; banned by `brand-and-voice.md` §6.2), any debug banner, the Settings dragon-name field with a real name in it.
- **Pre-publish check (required, review row 7):** the video sends parents to look, so before upload confirm Math Dragons' own declarations match it: Play Console Data safety says "No data collected" (and no data shared) and the Ads declaration is "No"; App Store Connect App Privacy says "Data Not Collected". Record the result in `upload.md`. Don't publish on a mismatch.
- **Music:** `assets/audio/music/hub_theme.ogg` under the question cards, `fire_trail.ogg` under the gameplay, both well under the VO. SFX: `assets/audio/sfx/correct.wav` on each check mark.
- **Cover frame:** the 0-4 s card with all three question marks and "3 questions before you install" visible.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: none (pillar 4; optionally a "Math Dragons" playlist)
- AI disclosure: YouTube no (Justin's own cloned voice and animation are exempt) / Facebook yes (realistic AI voice, `compliance-checklist.md` §C)
- Facebook first-comment path: /fb008

## Gate checklist (script-standards §9, self-check)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows F6 beats (lesson complete by 25 s, gameplay payoff, one CTA in the last 5 s)
- [x] Word count within budget for the target length
- [x] Voice checklist passed (`brand-and-voice.md` §11): no competitor named or implied as sketchy; no "safe", no seals
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded
- [x] Titles and copy written to §7
- [x] Compliance checklist §A-H passed
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (script gate, PASS WITH FIXES):
- Claim 2 raised to HIGH: the reviewer confirmed the App Store section heading reads "App Privacy".
- Production notes: added the required pre-publish check that Play Data safety says "No data collected", the Play Ads declaration is "No", and App Store Connect says "Data Not Collected".
- No script, word-count or copy changes.
