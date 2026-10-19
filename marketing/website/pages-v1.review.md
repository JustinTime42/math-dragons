---
review: accuracy and sense review (marketing/README.md procedure)
subject: playmathdragons.com v1 pages (index, privacy, support, feedback, 404, Base layout footer/header, config/site.ts)
app tree checked: /home/justin/dev/math-dragons-app-links, branch app/store-links-founding-flag @ 7655335 (1.0.3+8)
reviewer: independent agent, no authoring context
date: 2026-10-19
verdict: PASS WITH FIXES
---

# playmathdragons.com v1 pages: accuracy and sense review

## Verdict: PASS WITH FIXES

The core app claims hold up against the shipping branch: no ads, no accounts, no analytics or third-party SDKs, no network permission in the Android release manifest, all links parent-gated in Settings > For Parents, no real-money purchases, one profile per device, iOS 15 / Android 7.0 (API 24), iPad supported, four operations. The copy is calm, adult-addressed, scoped ("the app collects no data"), em-dash free, and free of banned outcome claims.

It is not publishable as written. Four statements are wrong in a way a parent or a store reviewer could catch, and three launch blockers sit outside the copy:

**Must fix in copy before publish**
1. **Device backups.** "This information never leaves the device", "never sent anywhere" and "erased and can't be recovered" are not literally true. Hive stores everything in the app documents directory (`Hive.initFlutter()` → `getApplicationDocumentsDirectory()`), which iOS includes in iCloud/computer backups, and the Android manifest does not set `allowBackup`, so Android Auto Backup copies it to the user's Google account and **restores it on reinstall**. (Claims P5, S9, S11, P16.)
2. **The Google Group exposes testers' emails to each other.** The live group's About page (fetched 2026-10-19) says "Group members can view members", "Group members can view conversations", "Group members can post". The policy only says "Google shows us the email address you joined with". Every Android tester can currently see every other tester's address and email the whole group. Fix the group settings (view members: managers only; post: managers only), then the policy line becomes accurate. (P13.)
3. **TestFlight steps are incomplete.** Install needs "Accept" before "Install" for a new tester, and screenshot feedback needs "tap the thumbnail, tap Done" before "Share Beta Feedback" (Apple, testflight.apple.com). (I7, F4.)
4. **Android "Clear data" path** is Samsung wording. Stock Android/Pixel is Storage & cache > Clear storage. (P16, S11.)

**Launch blockers (not copy, but the pages make them claims)**
- The TestFlight public link `Qj1a4NA8` currently returns "This beta isn't accepting any new testers right now." The landing page's main iOS CTA leads to a dead end.
- `playmathdragons.com` is not on Cloudflare yet: NS is `domaincontrol.com` (GoDaddy), A records point at GoDaddy parking, TLS fails. The app build links to `/privacy`, `/support`, `/feedback`; if 1.0.3+8 goes to review before the site is live, the in-app privacy link is broken (Apple 5.1.1(i), Google User Data policy both require a working one).
- "no cookies" must not ship until checked in DevTools on the deployed site (SPEC §5 rule). Cloudflare sets `__cf_bm` only with Bot Management/Bot Fight Mode and `cf_clearance` only when a challenge/JS detection runs, so it is very likely true, but confirm Bot Fight Mode and challenges are off for the zone.

**Should fix (store-review and skeptical-parent risk)**
- Decouple the founding perk from "We ask" (index). Right now it reads as an exchange for feedback (Apple 2.2 / 3.2.2, brand guide 5.4 "never tie it to... survey answers").
- "No ads, ever." is a forever promise nobody has decided; say "No ads."
- Privacy policy retention is vague ("when they are no longer needed") and missing for Google Group emails and Cloudflare logs; Google's User Data policy asks for a retention and deletion policy. Name the email processor (routeworks.app mail is Microsoft 365, MX `routeworks-app.mail.protection.outlook.com`).
- "Is my child's information safe?" heading: see sense-read item 3. Not a strict violation, but cheap to fix.
- Trademarks: TestFlight is **TestFlight®** on Apple's trademark list (brand guide §7 says ™; the guide is wrong). First mention on the home page carries no symbol at all. Footer credit line should add "registered in the U.S. and other countries and regions", plus iPadOS and Safari, which the pages use.

## Claims table

Verdicts: VERIFIED / NEEDS CAVEAT / UNVERIFIABLE / WRONG. Page codes: I = index, P = privacy, S = support, F = feedback, B = Base layout, C = config/site.ts, 4 = 404.

| # | Page | Claim | Verdict | Evidence | Suggested fix |
|---|---|---|---|---|---|
| I1 | I (title, lede) | Four dragon math games | VERIFIED | `lib/games/{dragon_eggs,dragon_runes,dragons_feast,fire_trail}/*_registration.dart` | |
| I2 | I, S | For kids ages 5 to 12 | VERIFIED (decision) | Justin 2026-10-19, brand 5.2. App has no age setting (`ageGroup` field never written) | Keep Play target-audience bands and App Store age rating consistent with 5-12 |
| I3 | I, S | Addition, subtraction, multiplication and division | VERIFIED | `MathOperation` enum `lib/core/game_interface.dart:64`; per-game `MathOp` enums. Dragon's Feast also does even/odd/prime/factors (`category_system.dart`), so this under-claims, which is fine | Optional: "plus even, odd and prime numbers in Dragon's Feast" |
| I4 | I | Short practice sessions | VERIFIED (descriptive) | Level-based rounds (`correctToAdvance`, 8 levels per world). No session timer exists, so "short" is a design description, not a number | Don't attach a minute count without measuring |
| I5 | I (meta), I | Free beta / Free during the beta | VERIFIED | No purchase code; `purchases_flutter` commented out (`pubspec.yaml`); `iap_manager.dart` is a TODO stub | |
| I6 | I, P, S | No ads | VERIFIED | No ad SDK in `pubspec.yaml`/`pubspec.lock`; `ad_manager.dart` is a 2-line TODO stub | |
| I7 | I | iOS step 3: "Tap Install in TestFlight" | NEEDS CAVEAT | Apple: "If you're a new tester, tap Accept, then tap Install" (testflight.apple.com) | "Tap **Accept**, then **Install**, in TestFlight." |
| I8 | I, P, S | No accounts | VERIFIED | No sign-in code; `firebaseUid`/`linkedProvider` are legacy, unused, always null (`migration.dart:37`); no Firebase in any history of `pubspec.yaml` | |
| I9 | I, P, S | The app collects no data | VERIFIED | No networking code; Android release merged manifest (`build/app/intermediates/merged_manifest/release/...`) has no INTERNET permission; only outbound action is `launchUrl` to the browser. Scoped to "the app" as required | Keep the scoping everywhere |
| I10 | I, P, S | Works offline / no internet required | VERIFIED | All assets bundled; no network permission on Android; no network calls on iOS | |
| I11 | I, S | iPhone, iPad and Android | VERIFIED (build config) | `TARGETED_DEVICE_FAMILY = "1,2"` (pbxproj 357/483/536); Play package `com.mathdragonsgame.mathDragons` | But see blocker: TestFlight link not accepting testers today |
| I12 | I | "I'm a dad and a developer. My daughter was struggling with math facts, and every app we tried had the same problems." | UNVERIFIABLE (author's story) | Justin's own account, consistent with spec /story | Name the problems in plain words (e.g. ads, purchase prompts, quizzes before the fun) without naming apps; vague grievances read as filler to a skeptical parent |
| I13 | I | "the full game, free, before anyone else" | VERIFIED | Everything in the build is free; "Premium Packs: Coming in a future update" placeholder exists in the store screen (`store_screen.dart:52`) | |
| I14 | I, S | "Everyone in the beta gets the full unlock free when Math Dragons launches." | NEEDS CAVEAT | Exact 5.4 wording, good. But: the only mechanism is an on-device flag (`founding_tester.dart`, cutoff placeholder 2099); it is lost on Clear data, uninstall (unless Auto Backup/iCloud restores it) or a new device; Apple 3.1.1 compatibility of a local flag is unresolved; StoreKit `AppTransaction` can't see TestFlight history. The promise is "everyone", the mechanism is "this device, if its data survives" | Keep the sentence (it's locked), but (a) move it out of "You get / We ask" (see sense 1), (b) add to support FAQ a plain line such as "Keep the app installed so we can recognize your device at launch", and (c) do not use it in more places until the delivery path is built |
| I15 | I | "We ask: let your kid play a few times over two weeks, then tell us what worked" | VERIFIED (request) | Spec 4.1 value exchange (survey dropped, fine) | See sense 1 |
| I16 | I | In-app banner: tap the menu (⋯), then Open in Safari / Open in Chrome | UNVERIFIABLE | Menu glyph and labels differ by app and OS (FB Android uses ⋮ and "Open in Chrome"/"Open in external browser"); SPEC §13 lists this as owed real-device verification | Test on both apps/OSes; consider "Tap the menu (⋯ or ⋮)" and "Open in browser" |
| I17 | I | TestFlight is "Apple's free app for testing new apps" | VERIFIED | App Store listing id899247664 resolves to "TestFlight App - App Store"; free | Add ® on first mention: "TestFlight®" |
| I18 | I | Android: join the group with the same Google account as the Play Store | VERIFIED | Research report §2, Play Console Help 9845334 ("users must join the group before opting into your test") | |
| I19 | I | "tap Become a tester" | VERIFIED (secondary) | Standard Play opt-in page label; page requires sign-in so not re-fetched | Confirm on device during W5 |
| I20 | I, S | "App not available" fixes: account, wait a few minutes, Chrome | VERIFIED (secondary) | Research report §2 (DEV Community Sep 2026, PrimeTestLab) | |
| I21 | C | Links: TestFlight app id899247664, group URL, opt-in URL | VERIFIED | All resolve (curl 2026-10-19); group URL correct; opt-in URL redirects to Google sign-in as expected | |
| I22 | C | TestFlight public link `Qj1a4NA8` | WRONG (today) | Page text: "This beta isn't accepting any new testers right now." | Fix in App Store Connect (approved build in the public group, link enabled) before publishing |
| P1 | P | Developer is Routeworks LLC; privacy contact privacy@routeworks.app | UNVERIFIABLE locally | Matches SPEC 4.6. Google requires the policy to name the developer as listed on Play | Confirm the Play and App Store Connect developer names read "Routeworks LLC" |
| P2 | P | Stored: dragon's name and growth stage | VERIFIED | `PlayerProfile.dragonName`, `dragonEvolution` | |
| P3 | P | Stored: scores, levels, stars, scales, play time, achievements, streaks | VERIFIED | `GameStats` (highScore, currentLevel, totalStars, levelStars), `totalScales`, `totalPlayTimeMinutes`, `achievements` box, `dailyChallengeStreak`, `bestStreak` | |
| P4 | P | Stored: facts practiced and how often answered correctly | NEEDS CAVEAT | `FactRecord` also stores answer times (`averageResponseTimeMs`, `totalResponseTimeMs`) and dates (`lastPresented`, `lastIncorrect`); profile stores `createdAt`, `lastPlayedAt`; settings include haptics | "...how often and how quickly they were answered correctly"; add "dates the app was played" and "sound, music and vibration settings" |
| P4b | P | Stored: "a note that the app was installed during the beta" | VERIFIED | `founding_tester` flag plus `founding_tester_since` date in `app_meta` box | Optional: "and the date" |
| P5 | P | "This information never leaves the device. We can't see it, and no one else can either." | WRONG (literal) | iOS backs up the Documents directory to iCloud/computer; Android Auto Backup is on by default (no `allowBackup` in manifest) and backs app data up to the user's Google account. We still can't see it | "It stays on your device (and in your device's own iCloud or Google backup, if you use one). We can't see it." Or app task: set `android:allowBackup="false"` and exclude from iCloud backup, if Justin prefers the stronger claim |
| P6 | P | Private storage other apps can't read | VERIFIED | App sandbox (iOS) / internal app storage (Android) | |
| P7 | P | Does not collect names, emails, location, device IDs/ad IDs, analytics, photos, contacts | VERIFIED | No permissions in release manifest beyond a signature-level receiver permission; no usage-description keys in `Info.plist`; profile id is the constant `'default'` (`local_storage.dart:33`); `uuid` package is listed but unused in `lib/` | Optional cleanup: drop unused `uuid` dependency |
| P8 | P | "never asks a child to enter any [personal information]" | NEEDS CAVEAT | The dragon-name field is free text ("Name your dragon...", `settings_screen.dart:115`); a child may type their own name. It stays on device (subject to P5) | Fine as is; optionally "A child can name the dragon; that name stays on the device." |
| P9 | P | No advertising, no analytics tools, no third-party services that collect data | VERIFIED | Every dependency checked: flame, flame_audio/audioplayers (asset playback only), hive, hive_flutter, path_provider, provider, equatable, uuid, intl, url_launcher, flutter_localizations. `http` in the lock file is transitive and unused (no INTERNET permission) | |
| P10 | P | Only links are in Settings > For Parents: privacy, feedback, help | VERIFIED | `lib/core/external_links.dart` is the only `launchUrl`/`Uri.parse` use in `lib/`; tiles at `settings_screen.dart:228-244` | |
| P11 | P | Each behind a grown-ups check (multiplication young children can't easily solve), opens in the browser | VERIFIED | `parental_gate.dart`: both factors 13-29, never a multiple of 10, one try per challenge; `LaunchMode.externalApplication` | |
| P12 | P | No social features, no chat, no way to contact anyone through the app | VERIFIED | No such code. Gated web pages carry mailto links, which is the intended adult path | |
| P12b | P, S | No in-app purchases right now | VERIFIED | See I5. The "Dragon Store" spends earned Dragon Scales only | Add one line so a parent who sees "Dragon Store" isn't alarmed: "The in-game Dragon Store uses scales earned by playing, not money." |
| P13 | P | Android beta: "Google shows us the email address you joined with" | NEEDS CAVEAT (currently incomplete) | Group About page: "Group members can view members", "can view conversations", "can post". Other testers see the address too, and the profile name | Change group settings to managers-only for view members and posting; then keep the line. If not changed, the policy must say other members can see it |
| P14 | P | Apple/Google may share installs, crash reports, feedback/screenshots | NEEDS CAVEAT | TestFlight: public-link testers are anonymous, developer sees install date, sessions, crashes, latest version; feedback can include an email the tester types; "Your email address will be visible to the developer when you send email feedback" (testflight.apple.com). Play: testers "can also provide private feedback through Google Play" (Play Help 9845334); vitals include device model and OS | "...such as install dates, session and crash counts, crash reports with device model and system version, and any feedback, screenshots or email address you choose to send." |
| P15 | P | "We use this only to run the beta and fix problems." | NEEDS CAVEAT | No retention stated for tester emails | Add retention: e.g. "We delete the tester group when the beta ends." (Justin to choose) |
| P16 | P | Delete app (iOS) / Settings > Apps > Math Dragons > Storage > Clear data (Android) removes all data | WRONG (partly) | Pixel/stock: Storage & cache > Clear storage; Samsung: Storage > Clear data. Uninstall + reinstall on Android can restore from Auto Backup; iCloud backups keep a copy | "Open Settings > Apps > Math Dragons > Storage (or Storage & cache), then Clear data (or Clear storage)." Add "A copy may remain in your device's iCloud or Google backup until that backup is replaced." |
| P17 | P | Website: no ads, no analytics, no cookies, no forms | NEEDS CAVEAT | No ads/analytics scripts, CSP `connect-src 'none'`, `form-action 'none'` (`public/_headers`). "no cookies" is unverified on the deployed site (SPEC §5, §9). Cloudflare's dashboard shows aggregate traffic stats for every zone, which some will read as "analytics" | Keep only after DevTools check with Bot Fight Mode off. Consider "no analytics or tracking tools (Cloudflare gives us total traffic counts, not information about individual visitors)" |
| P18 | P | Cloudflare processes IP and browser type to deliver pages and stop abuse | VERIFIED | Standard CDN processing; site deploys as Workers static assets (`wrangler.jsonc`) | Add a link to Cloudflare's privacy policy and a log retention note if known |
| P19 | P | Emails used only to reply/fix; deleted "when no longer needed" | NEEDS CAVEAT | Google User Data policy asks for a retention and deletion policy; mail is held by Microsoft 365 (MX record) | State a period (e.g. "within 12 months of the conversation ending", Justin's call) and name Microsoft as the email provider |
| P20 | P | Do Not Track / GPC: nothing to turn off; will respect if analytics added | VERIFIED | No tracking exists; satisfies CalOPPA DNT disclosure as summarized in the research report; matches SPEC §7 future plan | |
| P21 | P | "We don't sell or share personal information." | NEEDS CAVEAT | True in the CCPA sense, but Cloudflare (hosting) and Microsoft (email) process data on our behalf, and Apple 5.1.1(i) wants third-party protection addressed | "We don't sell or share personal information. Service providers that host this site and our email (Cloudflare, Microsoft) process it only to provide those services." |
| P22 | P | "There is no data on our servers to delete" | VERIFIED (narrowly) | No servers; emails and group membership are held by providers, covered by the next sentence | Add "To leave the tester group, leave it in Google Groups or ask us to remove you." |
| P23 | P | Effective/updated October 19, 2026 | NEEDS CAVEAT | Site is not live; policy can't be effective before publication | Set both dates to the deploy date |
| P24 | P | Change process: update date, update page before app changes | VERIFIED (commitment) | | |
| S1 | S, F | "We aim to respond within 48 hours." | VERIFIED (decision) | Justin 2026-10-19 (SPEC 4.7, 12) | |
| S2 | S | iOS/iPadOS 15 or later | VERIFIED | `IPHONEOS_DEPLOYMENT_TARGET = 15.0` (all 3 configs), Podfile `platform :ios, '15.0'` | Note: not tested on an iOS 15 device as far as the repo shows |
| S3 | S | Android 7.0 or later | VERIFIED | `minSdk = flutter.minSdkVersion` = 24 (`FlutterExtension.kt:26`, Flutter 3.44.0); merged release manifest `minSdkVersion="24"`; API 24 = Android 7.0 | Same testing caveat |
| S4 | S | Join: TestFlight on iOS, Google tester group + Play on Android | VERIFIED | Matches config and research | |
| S5 | S | "No ads, ever." | NEEDS CAVEAT | No recorded decision that ads are permanently excluded; a forever promise in a public FAQ | "No ads." |
| S6 | S | No purchases now; paid features planned for full release | VERIFIED | PLAN.md monetization decision 2026-10-19 | |
| S7 | S | FAQ heading "Is my child's information safe?" | NEEDS CAVEAT | Brand 6.2 bans "safe (unqualified)"; SPEC §5 "never 'safe' without specifics". The heading makes no claim and the answer gives specifics, so it is not a strict violation, but a question-and-answer pair reads as an implied "yes, safe" | "What does the app do with my child's information?" |
| S8 | S | Answer: "The app collects no data... no accounts" | VERIFIED | See I8, I9 | |
| S9 | S | "Progress stays on your device and is never sent anywhere." | WRONG (literal) | See P5 (OS backups) | "Progress stays on your device. The app never sends it anywhere." (true: the OS backup is the OS, not the app), or the P5 wording |
| S10 | S | One player profile per device; siblings share | VERIFIED | Single key `current_profile` in `player_profile` box (`local_storage.dart:15`) | |
| S11 | S | Reset: Android path; iOS delete and reinstall; "all progress and settings are erased and can't be recovered" | WRONG | Path wording as P16; Android reinstall can restore from Auto Backup; iOS restore from backup brings it back. Also erases the founding flag (the beta-unlock record) | Fix path wording; "can't be recovered unless you restore the device from a backup"; add "This also removes the record that you joined the beta" (or confirm the store-native mechanism makes that moot) |
| S12 | S | Leave the beta: "Delete the app." | WRONG | Deleting doesn't end testing; testers stay enrolled and keep getting build notices. Apple: "tap Stop Testing" on the app's page in TestFlight | "On iPhone or iPad, open TestFlight, choose Math Dragons and tap Stop Testing. On Android, open the tester page and choose Leave the program, and leave the Google Group if you want your email removed. Then delete the app." |
| S13 | S | Android tester page has "Leave the program" | VERIFIED (secondary) | Google's beta pages use "Leave the program"; opt-in page requires sign-in so not re-fetched | Confirm on device |
| S14 | S | Crash: close, reopen, restart; email with device and version | VERIFIED (advice) | | Also ask for the app version (Settings shows a hard-coded "1.0.0", `settings_screen.dart:266`, app task: show the real version) |
| S15 | S | About: developer, ages, ads none, internet no, price free during beta | VERIFIED | As above | |
| F1 | F | "We read everything" | UNVERIFIABLE (commitment) | Plausible for a solo dev | |
| F2 | F | "Your kid's age (just the age, nothing else)" | VERIFIED (good practice) | Minimizes data | |
| F3 | F | "If you're under 13, ask a grown-up to write to us." | VERIFIED | SPEC 4.7 prescribes this notice; the one deliberate child-addressed line, consistent with FTC practice | Spec wording is "ask a parent"; either is fine |
| F4 | F | Screenshot feedback: take a screenshot, then tap Share Beta Feedback | NEEDS CAVEAT | Apple: take screenshot, tap the thumbnail, tap Done, then Share Beta Feedback | "Take a screenshot, tap the preview in the corner, tap Done, then tap **Share Beta Feedback**." |
| F5 | F | TestFlight app > Math Dragons > Send Beta Feedback | VERIFIED | testflight.apple.com | |
| F6 | F | (absent) Android in-app feedback route | n/a | Play supports private tester feedback | Optional: "On Android, you can also send private feedback from the Math Dragons page in Google Play." |
| B1 | B | "Built in Alaska by a dad, for his own kid." | VERIFIED (decision) | Brand 5.2, SPEC 4.11 (footer only) | |
| B2 | B | "Apple, iPhone, iPad and TestFlight are trademarks of Apple Inc." | NEEDS CAVEAT | Apple list: TestFlight®, iPhone®, iPad®, iPadOS®; Apple's model line adds "registered in the U.S. and other countries and regions". Pages also use iPadOS (S) and Safari (I) | "Apple, iPhone, iPad, iPadOS, Safari and TestFlight are trademarks of Apple Inc., registered in the U.S. and other countries and regions." |
| B3 | B | "Google Play and Android are trademarks of Google LLC." | VERIFIED | Google brand guidance: "Android is a trademark of Google LLC"; Google Play is a Google LLC mark. Chrome (I) is also Google's | Optionally add Chrome; Facebook/Instagram (Meta) are named in the banner too |
| B4 | B | © year Routeworks LLC | VERIFIED | Build-time year | |
| 4-1 | 4 | "Even a dragon gets lost sometimes." | VERIFIED (joke, no fact) | Adult-addressed, harmless | |

## Spec and guide divergences (flag for Justin, not errors in the copy itself)

- **SPEC 4.1 hero:** asks for a worry-led parent-problem headline with the microcopy "Free beta. No ads. No accounts. The app collects no data." under the CTA, plus a gameplay clip. v1 uses a product-name H1 and a facts list. Acceptable for a phase-1 store-pages release only if Justin agrees; otherwise a W2 gap.
- **SPEC 4.7 / 3:** `/support` should have a contact form plus email. v1 is email only (README calls this phase 1). Apple 1.5 is satisfied by the email address. Fine, but record the deviation in SPEC or PLAN.
- **SPEC 4.11 footer:** Accessibility link, YouTube/Facebook links missing (analytics opt-out not needed while there is no analytics). `/accessibility`, `/story`, `/faq`, desktop QR (4.4) not built. Note as phase-2 items.
- **SPEC 4.6 / research:** the planned policy sections for forms, waitlist and analytics are correctly absent because none exist. Good: the policy describes what ships.
- **Brand §7:** "TestFlight with ™" is wrong; Apple lists TestFlight®. Update the guide.
- **Brand §4.1:** the Narrator is "I", "never 'we' pretending to be a company". The landing mixes "I built one" with "We ask... tell us". The legal "we" in the privacy policy is fine (it names the LLC). On the landing, "I ask" / "tell me" fits the one-dad story better.
- **Brand §5.2** row "The app collects no data" says "the website collects form messages and anonymous analytics". v1 has neither; the policy correctly says so. Update the guide note when convenient.

## Sense read

Read as a skeptical parent and as an App Store / Play reviewer.

1. **The perk looks like payment for feedback.** Index: "**You get:** ... Everyone in the beta gets the full unlock free when Math Dragons launches. **We ask:** let your kid play... then tell us what worked." Side by side, that is a trade. Brand 5.4 and SPEC 4.9 say the perk is a thank-you to everyone, never tied to feedback; Apple 2.2 bars compensation for TestFlight distribution and section 3 bars incentivized feedback. Fix: keep "You get: the full game, free, before anyone else." Put the perk sentence on its own line after the ask, framed as a gift: "And a thank-you: Everyone in the beta gets the full unlock free when Math Dragons launches, whether or not you send feedback."
2. **The perk has no delivery path yet, and the support page tells people how to destroy the only record of it.** The flag is device-local; "How do I reset my child's progress?" and "How do I leave the beta?" both end in deleting app data. A parent who resets after launch, or switches phones, may lose the unlock the site promised to "everyone". Either build the store-native path first or add one honest line in support (see S11) and stop repeating the promise beyond the two current places.
3. **"Is my child's information safe?"** A parent will read the heading plus answer as "yes, it's safe". The answer is careful and specific, so this is a style breach more than a false claim, but the fix costs nothing (S7).
4. **"Never leaves the device" vs backups** (P5, S9, S11). A technically minded parent, or a Play reviewer reading the manifest (no `allowBackup="false"`), can show the data does get copied to the user's own cloud backup and comes back on reinstall. Say so plainly; it's a reassuring detail (it's their own backup, we can't see it), not a scary one.
5. **Google Group exposure** (P13). This is the one real privacy gap: today a tester's email and name are visible to every other member, and any member can post to all. Parents joining a kids'-app beta will not expect that. Change the settings before promoting the Android path; re-fetch `/g/math-dragons/about` to confirm.
6. **"No ads, ever"** (S5) promises the future. "No ads" says the same thing today without a commitment nobody signed.
7. **Dead iOS link** (I22). The first iPhone parent who taps through hits "This beta isn't accepting any new testers right now". Fix before any promotion; SPEC §10 `/beta-status` banner is the fallback when a build lapses.
8. **In-app store placeholder.** The app's Dragon Store shows "Premium Packs: Coming in a future update". A parent who reads "no purchases right now" and then sees "Premium Packs" may wonder. One sentence in the policy/FAQ (P12b) heads it off. Separately (app, not site), App Review sometimes flags "coming soon" placeholders under 2.1/2.2; consider hiding that header until IAP exists.
9. **Inconsistency check across pages:** ages, devices, links, "grown-ups check", "For Parents", 48-hour response, and the perk sentence match everywhere. The privacy page lists three gated links and the app has exactly those three. Good.
10. **Child-directed content:** none, apart from the spec-mandated under-13 notice on `/feedback`. The 404 joke and dragon art are adult-addressed. Pass.
11. **Mechanics (brand §7, §11):** zero em-dashes in all five built pages (counted in `dist/`), zero "That's not X, that's Y" reframes. Flesch-Kincaid grade (scripted, approximate): index 2.9, privacy 5.9, support 4.0, feedback 3.9. Index and support are below the 5th-7th target, which is fine; simpler is not a fault. No banned words from §6.2 (proven, guaranteed, improves, COPPA, genius, addictive, lifetime/forever, "we collect no data") appear; "safe" appears once (S7); "ever" appears in "No ads, ever" (S5) and in a harmless "If we ever add analytics".

## Store-requirement completeness (privacy policy)

| Requirement | Source | Status |
|---|---|---|
| Identify what data the app collects, how, and uses | Apple 5.1.1(i) | Met (none collected; on-device list given; tighten per P4) |
| Third parties with access provide equal protection | Apple 5.1.1(i) | App: met implicitly (no third parties). Add the P21 line to cover site processors |
| Retention/deletion policy; how to revoke consent or request deletion | Apple 5.1.1(i), Google User Data | Partly met: deletion steps present; retention vague for emails, absent for tester emails and hosting logs (P15, P19) |
| Privacy point of contact | Google User Data | Met (privacy@routeworks.app) |
| Developer/app name matching the store listing | Google User Data | Likely met; confirm Play developer name (P1) |
| Active, public, non-geofenced, non-PDF URL | Google User Data | **Not yet**: domain not deployed (blocker) |
| Linked in-app, easily accessible | Apple 5.1.1(i), Google | Met in 1.0.3+8 (Settings > For Parents, gated); Kids-category gate is allowed |
| Children's data statement | Google Families, COPPA practice | Met (section 3) |
| Do Not Track disclosure; third parties collecting PII on the site | CalOPPA (per research report) | Met (DNT); third parties partly (add Cloudflare/Microsoft, P21) |
| Support URL with an easy way to contact | Apple 1.5 | Met (`/support`, plain email) once the site is live |

## Sources

- App tree `/home/justin/dev/math-dragons-app-links` @ 7655335: `pubspec.yaml`, `pubspec.lock`, `android/app/src/main/AndroidManifest.xml`, merged release manifest under `build/app/intermediates/merged_manifest/release/`, `android/app/build.gradle.kts`, `ios/Runner/Info.plist`, `ios/Runner.xcodeproj/project.pbxproj`, `ios/Podfile`, `lib/core/{player_profile,fact_tracker,achievement,daily_challenge,founding_tester,external_links,game_interface}.dart`, `lib/storage/local_storage.dart`, `lib/hub/settings_screen.dart`, `lib/monetization/*.dart`, `lib/games/*`
- Flutter 3.44.0 `FlutterExtension.kt` (minSdk 24, targetSdk 36); hive_flutter 1.1.0 `initFlutter` (uses `getApplicationDocumentsDirectory`)
- Apple: [Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers) (public-link testers anonymous; install date, sessions, crashes shown); [TestFlight](https://testflight.apple.com/) (Accept/Install, screenshot feedback steps, Send Beta Feedback, Stop Testing, what is shared); [Apple trademark list](https://www.apple.com/legal/intellectual-property/trademark/appletmlist.html) (TestFlight®, iPadOS®)
- Google: [Play Console Help 9845334](https://support.google.com/googleplay/android-developer/answer/9845334) (group join before opt-in, private feedback); [Android beta program page](https://developers.google.com/android/beta) ("Leave the program"); [Android brand guidelines](https://developer.android.com/distribute/tools/promote/brand) ("Android is a trademark of Google LLC"); live group page `https://groups.google.com/g/math-dragons/about` (fetched 2026-10-19)
- Cloudflare: [Cloudflare cookies](https://developers.cloudflare.com/fundamentals/reference/policies-compliances/cloudflare-cookies/) (`__cf_bm` only with Bot Management/Bot Fight Mode; `cf_clearance` with JS detections/challenges)
- Android storage labels: [Yahoo Tech guide](https://tech.yahoo.com/phones/articles/clear-app-cache-data-android-180000781.html) (Pixel "Storage & cache > Clear storage", Samsung "Storage > Clear data")
- DNS: `dig` 2026-10-19 (playmathdragons.com NS domaincontrol.com; routeworks.app MX Microsoft 365); curl of TestFlight link ("This beta isn't accepting any new testers right now")
- `marketing/reports/Beta landing page for kids app.md` (Apple 5.1.1(i), Google User Data, CalOPPA summaries)
