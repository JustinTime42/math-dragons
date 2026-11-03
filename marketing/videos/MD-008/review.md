# MD-008: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (one required pre-publish check, no script change required)

App claims checked against the installable build 1.0.3 (8) = `28d6638` (`docs/RELEASES.md`), extracted with `git archive 28d6638` (not `main`, which now carries the unreleased 1.0.4 (9) adaptive work). No adaptivity claim is used.

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "On Google Play, an app with ads says 'Contains ads' on its page." | VERIFIED | Play Console Help 9859455 (fetched 2026-10-27): "Apps that contain ads show a 'Contains ads' label on their store listing. This label will be visible to all Play Store users." The developer declares it ("You must declare whether your app contains ads"); Google "can also verify the declaration at any time". | None. (Note: the App Store has no equivalent ads label, so Q1 is Android-only. The script doesn't claim otherwise; the description's "two of the answers" is accurate.) |
| 2 | "Both app stores have a privacy section on the app's page." / on-screen "App Store: App Privacy" · "Google Play: Data safety" | VERIFIED | Apple: a current product page (apps.apple.com, TestFlight id899247664, fetched 2026-10-27) has a section headed exactly **"App Privacy"**, beginning "The developer, Apple, indicated that the app's privacy practices may include…". developer.apple.com/app-store/app-privacy-details: "On each app's product page, users can learn about some of the data types the app may collect". Google Play Help 11416267: "Under 'Data safety,' you'll find a summary of the app's data safety practices." | Raise claim 2 to HIGH; the heading has now been eyeballed. |
| 3 | "The developer fills it in." / "Filled in by the developer" | VERIFIED | Apple support 102399: for third-party apps "the information is self-reported by the developer"; developer page: "You're responsible for keeping your responses accurate and up to date." Google 11416267: "based on information declared by app developers"; the independent security review "does not verify the accuracy and completeness". | None |
| 4 | "the dragon math game I built" | VERIFIED | brand-and-voice §5.2 | None |
| 5 | "No ads." | VERIFIED (build 8) | `lib/monetization/ad_manager.dart` at `28d6638` is two TODO comment lines; `pubspec.yaml` has no ad SDK (deps: flame, hive, hive_flutter, path_provider, provider, flame_audio, equatable, uuid, url_launcher, intl). The store screen's "Premium Packs: Coming in a future update" placeholder is a purchase tease, not an ad; it's correctly on the do-not-show list. | None |
| 6 | "No accounts." / visual: launches straight to the hub | VERIFIED (build 8) | No auth packages; `lib/app.dart` `home:` is `HubScreen` (wrapped in the achievement overlay), no sign-in or onboarding route. | None. Sense note below on the beta join flow. |
| 7 | "The app collects no data." | VERIFIED (build 8), scoped correctly | No network or analytics packages; the release `android/app/src/main/AndroidManifest.xml` has no INTERNET permission (only the debug and profile manifests do, as Flutter generates); external links go through the parental gate and the system browser. | **Required before publish:** confirm Math Dragons' own store declarations match the video, since the video sends parents to look: Play Console Data safety = "No data collected / No data shared" and Ads = "No"; App Store Connect App Privacy = "Data Not Collected". A parent who checks and finds a mismatch would sink the whole video. |
| 8 | "It's free during the beta. If you want in, it's playmathdragons.com." | VERIFIED | §5.2, §5.4; `website/src/config/site.ts` `SITE_URL = 'https://playmathdragons.com'`; matches content-strategy §6 line exactly | None |
| 9 | Hook B "Your kid wants a new app?" | OK | Premise, no fact | None |
| 10 | Description "where the app stores show two of the answers"; caption "ads, accounts, and what data it collects" | VERIFIED | Same as 1-3 | None |

Claims list completeness: complete apart from the hook B premise (trivial). The joke-free script has no premises to add.

Math recomputed: no math strings. The only numerals are `1.`, `2.`, `3.` and "3 questions" (the script asks exactly 3; counted). Word count recomputed by script: 93 Narrator words (claimed 93), 2.45 words/s over 38 s, inside the 95 budget. Title "3 Questions to Ask Before Installing Any Kids' App" = 50 chars (40-65; payload in the first 40).

Sense read:
- **Skeptical parent:** the lesson stands on its own by 25 s and the store facts are right. Likely pushback: "No accounts, but I had to join a Google Group / use TestFlight to get it." The claim is about the app ("before your kid can play"), which is true; MD-001 covers the join flow. No fix needed, but Justin should be ready for that reply in comments.
- "The developer fills it in" could read as a dig at other apps. It reads as useful context (Apple and Google both say it), and no app is named or implied. OK.
- **Math teacher:** nothing to correct.
- The visual "Dragon Eggs, a correct equation hatches an egg" matches the registration description ("Hatch dragon eggs with math equations"). Check the captured frames so every visible problem is correct.

Compliance (§A-H):
- A (Made for Kids): PASS. "Parents," first word; subject is a parent decision; gameplay is a demo inside a parent lesson. Hashtags parent/teacher/homeschool only.
- B (claims): PASS, all three app claims are §5.2 and true in build 8; privacy scoped to "the app"; no "safe", no seal, no "COPPA". No perk used.
- C (AI disclosure): YouTube no, Facebook yes, as planned.
- D (engagement bait): PASS. Caption question "What do you check before you hit install?" is genuine.
- E (audio): PASS, game's own music and SFX.
- F (visuals/IP): PASS as planned: own generic mockup, no store UI or badges, text-only store names. Keep "Google Play" and "App Store" as plain text (nominative use), no logos.
- G (kids/privacy): PASS; fresh test profile, no real dragon name.
- H (links/CTA): PASS. One CTA, last 5 s, after the payoff, standard wording; `/fb008` in the first comment only.

Voice (§11): adult address, one idea, zero em-dashes (file count 0), zero X/Y reframes, Narrator first person. PASS.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
