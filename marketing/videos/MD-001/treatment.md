---
id: MD-001
status: treatment
pillar: 4
series: none
format: F8 (F8a, walkthrough, HORIZONTAL 16:9, long-form)
target_length_s: 105
voices: Narrator
platforms: YouTube (long-form, featured on the channel). Not a Short. Facebook optional (see Copy)
promo: yes
calendar_hook: none
---

# MD-001: Join the Math Dragons beta (iPhone, iPad and Android walkthrough)

## Concept
A parent sees exactly how to join the free beta on their kid's device, step by step for iPhone/iPad (TestFlight) and Android (Google Group, then Play opt-in), including the same-Google-account fix.

## Hooks
- A: Frame one: playmathdragons.com open on an iPhone screen recording, the "Join the free beta" button highlighted gold. On-screen text: "Parents: join the free beta". Narrator: "Parents, here's exactly how to get Math Dragons free during the beta."
- B: Frame one: the site's two join cards (iPhone or iPad / Android), shown one after the other in a quick cut (never two devices side by side). On-screen text: "iPhone or Android: 3 steps each". Narrator: "Parents, two kinds of phones, three steps each. Here's how to join the Math Dragons beta."

## Script
Canvas 1920 × 1080. Phone recordings sit in a framed window on a Deep Void to Dragon Purple background, one device at a time.

| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-5 s | Gameplay-free hook: iPhone screen recording of playmathdragons.com, "Join the free beta" button pulses gold | Parents: join the free beta | Narrator: Parents, here's exactly how to get Math Dragons free during the beta. |
| 5-13 s | Gameplay: 2 s cuts of Dragon Eggs, Fire Trail, Dragon Runes, Dragon's Feast (game names as captions) | 4 dragon math games / Kids 5-12 | Narrator: It's four dragon math games for kids five to twelve, with short practice in addition, subtraction, multiplication and division. |
| 13-19 s | Illustration: Tallyclaw still (neutral pose) beside a list that ticks in line by line | No ads / No accounts / The app collects no data / Works offline | Narrator: No ads. No accounts. The app collects no data, and it works offline. |
| 19-27 s | Math card style text card on purple, gold underline under "full unlock" | Everyone in the beta gets the full unlock free when Math Dragons launches. | Narrator: Everyone in the beta gets the full unlock free when Math Dragons launches. It's my thank-you for joining. |
| 27-36 s | Screen recording: typing playmathdragons.com into Safari; the page loads and shows the "Looks like your device" card | Use your kid's phone or tablet / playmathdragons.com | Narrator: On the phone or tablet your kid will use, go to playmathdragons.com. The page shows the steps for your device. |
| 36-39 s | Section title card, Apple bezel around the iPhone window | iPhone or iPad: 3 steps | Narrator: iPhone or iPad first. Three steps. |
| 39-47 s | iPhone recording: tap "Get TestFlight", App Store page for TestFlight, tap Get. Step number "1" in gold | 1. Get TestFlight | Narrator: One. Get TestFlight, Apple's free app for testing new apps. |
| 47-54 s | iPhone recording: back in Safari, tap "Join the Math Dragons beta"; TestFlight opens | 2. Tap "Join the Math Dragons beta" | Narrator: Two. Come back to the page and tap Join the Math Dragons beta. |
| 54-61 s | iPhone recording: TestFlight, tap Accept, then Install; the Math Dragons icon appears on the home screen | 3. Accept, then Install | Narrator: Three. In TestFlight, tap Accept, then Install. |
| 61-64 s | Section title card, Android window (no device frame) | Android: 3 steps | Narrator: Now Android. Three steps here too. |
| 64-73 s | Android recording (scrcpy): tap "Join the tester group", Google Groups page, tap Join group. Gold callout box around the account shown on the page (test account, no real email visible) | 1. Join the tester group / Same Google account as your Play Store | Narrator: One. Join the tester group. Use the same Google account your Play Store uses. This part matters. |
| 73-79 s | Android recording: back on the site, tap "the tester page", tap "Become a tester" | 2. Tap "Become a tester" | Narrator: Two. Open the tester page and tap Become a tester. |
| 79-84 s | Android recording: Play Store listing, tap Install | 3. Install from Google Play | Narrator: Three. Install Math Dragons from Google Play. |
| 84-97 s | Android recording: the site's "Did it say App not available?" panel opens; cut to Play Store, gold circle highlights the account icon in the corner (avatar cropped or blurred) | "App not available"? / Check the account circle | Narrator: If Play says App not available, check which account is signed in. Tap the little circle in the corner. It has to be the one that joined the group. |
| 97-102 s | Android recording: tester page reloads | Wait a few minutes, try again | Narrator: Still stuck? Wait a few minutes, then try the tester page again. |
| 102-107 s | Tallyclaw still (smug pose) beside the URL in large Nunito Bold; the four game icons below | Free during the beta / playmathdragons.com | Narrator: It's free during the beta. If you want in, it's playmathdragons.com. |

Word count: 210 (budget about 267 for 107 s at 2.5 words/s; the gap is deliberate, it leaves time to see each tap). VO alone runs about 84 s; the rest is on-screen action. Total 105-110 s, inside F8a's 60-120 s.

## Math strings (exact, rendered from code)
No equations. Exact on-screen strings with numbers (rendered from code like any math card):
- `4 dragon math games`
- `Kids 5-12`
- `iPhone or iPad: 3 steps`
- `Android: 3 steps`
- Step labels `1.` `2.` `3.` (twice)
- Gameplay equations: every equation visible in the 5-13 s cuts (and any Dragon Eggs screen) is listed here at capture and recomputed at the render gate. Dragon Eggs footage shows addition or subtraction only (see Production notes).

Verified (python, 2026-10-27): the site lists exactly 3 `<li>` steps in each card (`website/src/pages/index.astro` iOS and Android `<ol class="steps">`); 4 games registered (`lib/games/*/*_registration.dart`, 4 files). Rechecked for the fixes (python, 2026-10-27): still 3 and 3 steps, 4 registrations.

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Math Dragons is free during the beta | brand-and-voice §5.2, §5.4; site `index.astro` "Free during the beta" | HIGH |
| 2 | Four dragon math games (Dragon Eggs, Fire Trail, Dragon Runes, Dragon's Feast) | code: `lib/games/*/*_registration.dart` (`displayName`); brand §5.2 | HIGH |
| 3 | For kids five to twelve | brand §5.2 (Justin's decision 2026-10-19); site lede | HIGH (positioning) |
| 4 | Short practice in addition, subtraction, multiplication and division | site lede (copy approved by Justin); code: `MathOperation.addition/subtraction/multiplication/division` in Dragon Eggs, Fire Trail, Dragon Runes registrations (in 1.0.3 Dragon Eggs scores uneven division as correct; fixed in `3cd97d9`, ships in 1.0.4 (9), so no Dragon Eggs division on screen) | HIGH |
| 5 | No ads | brand §5.2; idea-bank.review §2 (I-113: `ad_manager.dart` empty stub, no ad SDK in `pubspec.yaml`) | HIGH |
| 6 | No accounts | brand §5.2; idea-bank.review §2 (no auth code or packages) | HIGH |
| 7 | The app collects no data (scoped to "the app") | brand §5.2; idea-bank.review §2 (no network packages, no Firebase, no Android INTERNET permission in 1.0.3); `docs/RELEASES.md` 1.0.3 (8) | HIGH |
| 8 | It works offline | brand §5.2; site "Works offline" | HIGH |
| 9 | "Everyone in the beta gets the full unlock free when Math Dragons launches." | brand §5.4 exact sentence | HIGH (Justin's decision; delivery path not yet built, brand §5.2) |
| 10 | "It's my thank-you for joining." | site `index.astro` ("It's our thank-you for joining"), adapted to first person; not tied to feedback or reviews (brand §5.4) | HIGH |
| 11 | The site shows the steps for your device | site: `platform.js` + "Looks like your device" cards in `index.astro` | HIGH |
| 12 | iPhone/iPad: three steps (get TestFlight; tap Join the Math Dragons beta; Accept, then Install) | site `index.astro` iOS `<ol>`; `website/src/config/site.ts` (`testflightApp`, `testflight`) | HIGH; live: the TestFlight public link shows "Join the Math Dragons beta" (checked 2026-10-27) |
| 13 | TestFlight is Apple's free app for testing new apps | site `index.astro` wording; `site.ts` `testflightApp` (App Store id899247664) | HIGH |
| 14 | Android: three steps (join the tester group; Become a tester; install from Google Play) | site `index.astro` Android `<ol>`; `site.ts` (`googleGroup`, `playOptIn`); LAUNCH-CHECKLIST Part 1 §3 (Anyone can join) | HIGH; live: Justin reported Android closed testing working (2026-10-27) |
| 15 | Use the same Google account your Play Store uses | site `index.astro` (bold warning); playbook "The landing page must absorb store friction" (Play closed testing admits only group members, needs a Google account) | HIGH |
| 16 | If Play says "App not available", check the account circle in the corner; it has to be the one that joined the group | site `index.astro` troubleshooting `<details>`; brand §4.4 site troubleshooter line | HIGH |
| 17 | Wait a few minutes, then try the tester page again | site `index.astro` troubleshooting | HIGH |
| 18 | Works on iPhone, iPad and Android (implied by both flows) | brand §5.2; both flows live (claims 12, 14) | HIGH |
| 19 | Description: "built by a dad" | site `index.astro` "Why I built it"; brand §5.2 | HIGH |
| 20 | Hook B text "iPhone or Android: 3 steps each" (if Hook B is picked) | site `index.astro`: 3 `<li>` in each `<ol class="steps">` (py) | HIGH |
| 21 | Gameplay equations visible in footage | Listed at capture, recomputed at the render gate (script-standards §4) | to check at render gate |

Cut: the playbook's "the opt-in link can take hours" (true for a fresh publish, not for a tester today; would be a time promise, F8 rules). No time-to-join claim anywhere (F8 rule; compliance §H).

## CTA
Narrator, last 5 s, spoken and on screen: "It's free during the beta. If you want in, it's playmathdragons.com." (The URL in the 27-36 s beat is a step of the walkthrough, not a second pitch.)

## Copy
- YouTube title: `Join the Math Dragons beta on iPhone, iPad or Android` (53 characters)
- YouTube description (long-form, links clickable):
  ```
  playmathdragons.com/yt

  How to join the free Math Dragons beta, step by step, on iPhone, iPad or Android. Four dragon math games for kids 5 to 12, built by a dad. No ads, no accounts, and the app collects no data. Everyone in the beta gets the full unlock free when Math Dragons launches.

  Once you're in: if you can, let your kid play a few times over two weeks, then tell me what worked and what didn't: playmathdragons.com/feedback

  #parenting #homeschool #teachers
  ```
  (The perk closes the "what you get" paragraph; the feedback request is a separate paragraph after a blank line and starts "Once you're in", so the perk can't be read as payment for feedback, brand §5.4.)
- Shorts description: n/a (long-form, horizontal).
- Facebook caption (only if Justin also posts it to the Page): "Here's exactly how to join the free Math Dragons beta on iPhone, iPad or Android. Which step would you want explained better?"
- Facebook first comment (only if posted to Facebook): `Free beta for iPhone, iPad and Android: playmathdragons.com/fb001`
- Hashtags: #parenting #homeschool #teachers

## Production notes
- **Prerequisites:** the beta is live (TestFlight public link shows "Join the Math Dragons beta", checked 2026-10-27; Justin reported Android closed testing working). Walk both flows once on the recording day to confirm nothing changed. Still required before upload: `website/phase-2` is deployed, because `/yt` and `/fb###` redirects exist only in that branch's `public/_redirects` and the page layout (launch-list form) changes there. Record against the live page so the video matches what parents see.
- **Re-make rule (F8):** remake whenever the join flow or the site's step wording changes. Re-check every step against `index.astro` and `site.ts` at the render gate.
- **iPhone capture:** iOS built-in screen recording on Justin's iPhone, Do Not Disturb on, status bar clean. Use a device with TestFlight not yet installed (or delete it first) so step 1 is real. No Apple ID, email or notifications visible.
- **Android capture:** `scrcpy --record` on a physical phone signed in to a **dedicated test Google account** with a neutral name and no photo. The Google Groups join page and the Play account circle both show the account; blur or crop the address. Leave the group and opt out afterwards if the account must be reused (opting out and back in restarts a tester's 14-day count; harmless for a test account, but don't use a real tester's account).
- **Device frames:** Apple bezel on the iPhone window only; Android window unframed. Never an iPhone and an Android device side by side in one frame (compliance §F). No App Store, TestFlight or Google Play badges; the real TestFlight and Play screens appear only as the steps themselves. No ® in the video.
- **Gameplay:** 2 s clips of each of the four games, captured on a physical device (visual-style §7). **Dragon Eggs: addition or subtraction only, no division, until 1.0.4 (9) is released to testers** (1.0.3 accepts 7 ÷ 2 = 3 as correct; fixed in `3cd97d9`). Don't show the Dragon Store screen. List every equation visible in the cuts and recompute it at the render gate. Do not show Dragon Runes world names "Inferno Algebra" or "Dragon's Calculus" (brand §6.2; `lib/games/dragon_runes/dragon_runes_registration.dart:110,131`).
- **Tallyclaw still art:** neutral pose (13-19 s) and smug pose (102-107 s), built from `assets/style_bible/approved/04_stone_dragon.png` / `09_stone_face.png` per visual-style §8. No Tallyclaw voice. Still art doesn't exist yet; it's needed for MD-003, MD-005 and MD-006 too.
- **Music:** `assets/audio/music/hub_theme.ogg` (the file is MP3 inside), well under the VO, ducked during speech. SFX: none, or the game's soft correct chime on each step number.
- **Captions:** burned in (2-4 words) plus `.srt` upload.
- **Facebook version only (optional):** if Justin posts this to the Page, add one on-screen line in the 27-36 s beat, "In Facebook? Open in Safari or Chrome", matching the site's in-app-browser banner. Not in the YouTube master.
- **Thumbnail / cover frame:** Tallyclaw still (or the game's dragon), text "Join the free beta" and "iPhone, iPad, Android" in text (no store badges), per visual-style §12.

## Upload
- YouTube related video: n/a (this is the related-video destination for every Short)
- Playlist: none; set as the channel's featured video
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own cloned voice, real screen recordings, still illustration; no realistic synthetic people or events) / Facebook yes if posted (realistic AI voice, Justin's clone, compliance §C)
- Facebook first-comment path: /fb001 (only if posted to Facebook)

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows its format's beats (F8a: both flows step by step, same-account warning, `/yt` first description line)
- [x] Word count within budget for the target length (210 vs about 267)
- [x] Voice checklist passed (brand §11): adult address, one CTA, claims listed, no banned words, calm, zero em-dashes, zero X/Y reframes, app claims true today (build 1.0.3 (8)), perk sentence exact
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded
- [x] Titles and copy written to §7 (long-form description replaces the Shorts description)
- [x] Compliance checklist §A-H passed (A adult-addressed, no kids or kid tags; B claims on §5.2, no adaptivity, perk exact and untied; C disclosure set; D no bait; E game soundtrack; F no badges or ®, Apple bezel only, no side-by-side; G test account, nothing identifying; H one CTA, `/yt` and `/fb001` only in clickable places, no step count or time that isn't true)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (PASS WITH FIXES) and the coordinator's corrections:
- Prerequisites: the beta is now live (TestFlight link checked 2026-10-27; Android closed testing working per Justin), so the "record nothing until LAUNCH-CHECKLIST 7-9" gate became "walk both flows on the recording day"; `website/phase-2` deploy is still required for `/yt` and `/fb###`. Claims 12 and 14 updated to match.
- Gameplay: Dragon Eggs footage limited to addition or subtraction until 1.0.4 (9) ships (1.0.3 accepts 7 ÷ 2 = 3); no Dragon Store screen; every visible equation listed at capture and recomputed at the render gate (Production notes and Math strings).
- Description: perk sentence moved into the "what you get" paragraph; the feedback request is now its own paragraph after a blank line, starting "Once you're in".
- Claims list: added "built by a dad", Hook B's "3 steps each" and gameplay equations; citation fixed from `Operation.*` to `MathOperation.*`.
- Optional Facebook-only on-screen line "In Facebook? Open in Safari or Chrome" added to Production notes.
- Script, word count (210) and title unchanged.
