# Conversion and UX for the Math Dragons Beta Landing Page (playmathdragons.com)

Research date: 2026-10-19. Scope: landing-page conversion, message match, install-flow UX, in-app browser behavior, desktop handoff, trust, email fallback, beta value exchange, competitor examples. Legal compliance, analytics, and hosting are out of scope (covered by other researchers).

Source-quality note: primary sources found were Unbounce's 2024 benchmark report, Apple App Store Connect help, Google Play Console help, a maintained open-source in-app-browser test matrix (shalanah/inapp-debugger), and the live competitor sites. Much of the in-app-browser and closed-testing troubleshooting material comes from vendor blogs (deep-link and "tester community" services) that have a commercial interest; those are flagged. I found **no NN/g or Baymard article** directly on these questions within my search budget. Treat any NN/g claims elsewhere in the final report as needing their own sourcing.

## 1. Above-the-fold structure and conversion benchmarks

### Takeaway
The best data available (Unbounce 2024, 41,000+ pages) says: keep copy short and simple (5th-7th grade reading level converts about 2x better than professional-level copy), expect mobile to convert slightly worse than desktop, and Facebook/Instagram paid-social traffic converts well while YouTube traffic converts lower. Competitor kids' edu sites use a short benefit headline, a single dominant CTA (store badges or "try free"), and push "free / no ads" claims to or just below the fold.

### Cited Findings
- Unbounce 2024 Conversion Benchmark Report: median landing-page conversion rate across all industries is **6.6%**; sample of 41,000+ landing pages, 57M+ conversions, 464M unique visitors. Unbounce itself frames the median as a baseline, not a target. — [Unbounce 2024 Conversion Benchmark Report](https://unbounce.com/conversion-benchmark-report/)
- Older Unbounce edition (2020) reported a 3.2% median with top-quartile pages at about 25%; figures are not directly comparable across editions. — [Unbounce 2020 report](https://unbounce.com/conversion-benchmark-report-2020/); summary in [MarketingProfs 2021](https://www.marketingprofs.com/charts/2021/44860/landing-page-conversion-benchmarks-for-16-industries)
- Reading level: pages at a 5th-7th grade reading level convert at **11.1%**, 56% higher than 8th-9th grade, and more than 2x professional-level writing (**5.3%**). Difficult (3+ syllable) words correlate -24.3% with conversion; reading time -19.4%; word count -18.6%. — [Unbounce 2024](https://unbounce.com/conversion-benchmark-report/)
- Mobile accounts for **83%** of analyzed visits, but desktop converts about **8% better** than mobile on average. — [Unbounce 2024](https://unbounce.com/conversion-benchmark-report/)
- Paid social conversion rates: Instagram **17.9%**, Facebook **13%**, paid-social average 12%; **YouTube, TikTok and X fall between 6% and 9%**. — [Unbounce 2024](https://unbounce.com/conversion-benchmark-report/)
- Email traffic converts best on average (19.3%) per a summary of the 2024 report. — [MarketingProfs summary via search](https://marketingprofs.com/charts/2024/52374/landing-page-conversion-benchmarks) (secondary; not verified on the primary page)
- The Unbounce page lists an Education benchmark page but gives no education- or app-specific numbers on the main report page. — [Unbounce 2024](https://unbounce.com/conversion-benchmark-report/)
- A CRO-agency guide claims mobile-specific pages convert 25.2% higher than generic responsive pages; I could not verify against a primary source. — [Foundry CRO (unverified)](https://foundrycro.com/blog/landing-page-audit-framework-paid-traffic-2026/)

Competitor above-the-fold patterns (fetched 2026-10-19):
- **Khan Academy Kids**: headline "Joyful Learning Starts Here!"; subhead says ages 2-8 and ends with "100% free!"; hero is a clickable video thumbnail of a child using the app on a tablet; primary CTAs are three store badges (App Store, Google Play, Amazon) with nothing competing; "No ads, no subscriptions" appears in the very next section; awards/testimonials further down. Copy talks about kids more than to parents. — [Khan Academy Kids](https://www.khanacademy.org/kids)
- **DragonBox** (a Kahoot company): headline "Incredible learning experiences for you and your child to share."; illustration hero; CTA "Our Apps" plus store badges on a featured app with an age band ("From 4 to 8 years old"); no trust signals or privacy claims above the fold; speaks to the parent in second person. — [DragonBox](https://www.dragonbox.com/)
- **Prodigy**: headline "Make Math and English fun for kids"; audience-split CTAs ("Teachers, get full access for free" / "Parents, explore memberships"); heavy trust stack: a commissioned survey stat ("91% of parents said their children enjoy Prodigy Math"), parent and teacher testimonials, Mom's Choice Award, Parent and Teacher Choice Award, Common Sense privacy seal. — [Prodigy](https://www.prodigygame.com/main-en/)
- **Synthesis Tutor**: problem/outcome-led headline "Your child's personal math tutor." with subhead "Warm, patient, encouraging." and reassurance that parents "never have to worry about them falling behind"; CTA "Try it for free" with "No credit card necessary" microcopy directly beneath (objection removal attached to the button); static images, video lower down; "Designed for ages 5-11"; founder/origin story (SpaceX school) placed far down the page; social proof claims of "35,000" and "25,000" families appear inconsistently on the same page. — [Synthesis Tutor](https://www.synthesis.com/tutor)

### Inferences
- For Math Dragons, the Synthesis pattern (outcome headline aimed at the parent + one CTA + objection-killing microcopy right under the button, e.g. "Free. No ads. No accounts. Nothing collected.") is the closest fit, because the "no ads, no accounts, no data" promise is a genuine differentiator and should not be pushed below the fold the way Khan does.
- Write the page at roughly a 5th-7th grade reading level; this aligns with Unbounce data and with the project's "talk to adults, not kids" rule (simple is not childish).
- YouTube-sourced traffic should be expected to convert lower than Facebook traffic (6-9% vs 13% median in Unbounce data), though Unbounce's numbers are for generic conversion goals (forms, clicks), not multi-step app installs. A multi-step beta install will convert far lower than these medians; set expectations per step rather than end-to-end.
- Headline problem-led vs product-led: competitors split (Khan/Prodigy product/benefit-led, Synthesis outcome/parent-worry-led). No controlled study found; worth an A/B variant per campaign.

### Gaps
- No NN/g, CXL or Baymard study found specifically on hero video loop vs screenshot for mobile app pages, or on problem-led vs product-led headlines. Not found within search budget.
- No published benchmark found for beta/TestFlight signup conversion rates or step-by-step drop-off for app install flows.
- Todo Math, Beast Academy, and indie game beta pages were not analyzed (search budget).

## 2. Message match between video and landing page

### Takeaway
The principle ("scent") is well established in CRO practice: the landing page should repeat the ad's promise, wording, and look, and the ad's message should be the page's main point. Evidence is mostly practitioner, older, and not mobile-video-specific.

### Cited Findings
- CXL: missing scent is often the reason landing pages underperform, more than structure or copy; ad copy and landing-page copy should be nearly identical, the ad's message should be the main point of the page, and ad design should be consistent with page design. Article is 2010s-era and not mobile-specific. — [CXL: maintaining scent](https://cxl.com/blog/give-your-advertising-roi-a-serious-boost-by-maintaining-scent/)
- "Message match" and "ad scent" are the same concept: how closely a page repeats the ad's promise, wording and look. — [Landing Doctor](https://landingdoctors.com/guides/what-is-message-match)
- Commonly cited stats (e.g., "73% mismatch rate," KlientBoost "66% lift") circulate on secondary blogs without verifiable primary studies. — flagged as unverified; see [Webtonic](https://www.webtonic.io/blog/message-match)

### Inferences
- Per-campaign variants are cheap on a static site: e.g. `/s/<video-slug>` or `?v=` parameter that swaps the headline, hero clip (the same dragon/mini-game shown in the Short), and Tallyclaw line to match that video. Keep the CTA and install steps identical across variants.
- First frame of the hero should be visually recognizable from the video (same mini-game, same dragon), so the visitor gets instant confirmation they landed in the right place.

### Gaps
- No controlled study found on short-form-video-to-landing-page continuity specifically.

## 3. Multi-step install flows (TestFlight and Play closed testing)

### Takeaway
Both platforms impose real friction. iOS: install TestFlight, then open the public link. Android: join Google Group, then opt in on the web with the **same Google account** used in Play, then install; the opt-in link only exists after publishing and can take hours to go live. The dominant Android failure is account mismatch; the dominant iOS failures are config-side (link disabled, build expired, review not passed).

### Cited Findings
Apple / TestFlight:
- Public links can be capped at 1-10,000 testers per group; up to 10,000 external testers per app. Public-link testers appear as anonymous in App Store Connect, but installation date, sessions and crashes are visible. Anyone can reshare the link. — [Apple: Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- Public links can be "Open to Anyone" or filtered by device/platform and OS version range; at least one criterion is required. — [Apple](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- First build needs full TestFlight App Review; later builds of the same version may not. Testers accept invitations "using the TestFlight app on their device." — [Apple](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- Builds expire 90 days after upload, and each build has its own link; common public-link errors: "This beta is full," "Unable to install / no longer available" (expired build), "Page not found" (disabled link), "You're not invited to test this app" (wrong link or Apple ID; fix: open the exact link in Safari). — [TF Invites (vendor, undated, ©2026)](https://www.tfinvites.com/blog/testflight-public-link-not-working)
- Developer reports: public link failing when TestFlight was already installed / account had been invited by email ("No builds available"). — [Apple Developer Forums 718229](https://developer.apple.com/forums/thread/718229); [Apple Developer Forums 109085](https://developer.apple.com/forums/thread/109085) (anecdotal)

Google Play closed testing:
- Testers need a Google Account; "For closed tests using a Google Group, users must join the group before opting into your test." Each tester must opt in using the link. The opt-in link only displays once the app status is "Published"; after first publish, the test link "can take several hours to become available." After clicking the opt-in link testers see an explanation of tester responsibilities, then the opt-in. Your feedback channel appears on the opt-in page. Closed-test apps are not searchable on Play. Testers cannot leave public reviews for test versions. — [Google Play Console Help: Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334)
- Failure modes (2026 dev article): wrong Google account (group-joined account differs from Play Store account) produces "App not available"; using the store listing link instead of the opt-in link (correct one starts `play.google.com/apps/testing/`, from "Join on the web"); download link can take a few minutes to work; email list and Google Group cannot both be active on one track. — [DEV Community, Sep 2026](https://dev.to/zenith605/google-play-closed-testing-joined-the-group-but-opt-in-says-app-not-available-6-checks-3dm3)
- Some default browsers don't pass the Google session correctly; recommended fix is opening the opt-in link in Chrome on the device, signed into the same account as Play. — [PrimeTestLab (vendor)](https://primetestlab.com/blog/google-group-closed-testing-not-working); [12 Testers Community (vendor)](https://12testerscommunity.com/blog/google-play-closed-testing-not-working-fixes)
- Opting out and back in restarts the 14-day continuous-opt-in count (relevant to Google's 12-testers/14-days production gate for new personal accounts). — [DEV Community](https://dev.to/zenith605/google-play-closed-testing-joined-the-group-but-opt-in-says-app-not-available-6-checks-3dm3)

### Inferences
- Use a numbered stepper with platform auto-detection (show only the iOS or Android path, with a toggle for the other). iOS: (1) Get TestFlight [App Store badge], (2) Come back and tap "Join the Math Dragons beta" [public link], (3) Tap Install in TestFlight. Android: (1) Join the group [one tap; note "use the Google account your Play Store uses"], (2) Tap "Become a tester," (3) Install from Play.
- Put a screenshot of each step's target screen next to the step, so the parent knows what "success" looks like before tapping away.
- Because each step leaves the site, make every step a self-contained button that works when the user returns (no state that must persist), and add a "Did it say 'App not available'?" troubleshooting accordion covering the account-mismatch and "wait a few minutes" cases.
- On Android, the account-mismatch issue is the single highest-value line of microcopy on the page.
- Consider making the Google Group auto-approve (open join) so step 1 is instant.

### Gaps
- No quantitative data found on drop-off per step for TestFlight or Play closed-testing flows.
- Not confirmed whether Google's opt-in page now also offers join-from-device flows that skip the group page; Google's help page did not describe "Join on Android."

## 4. In-app browsers (YouTube, Facebook) and store links

### Takeaway
Per a maintained test matrix (iOS updated 2026-03-07, Android 2024-11-07), **YouTube opens links in the user's default browser** on both iOS and Android, so YouTube Shorts traffic largely avoids the in-app-browser problem (and lands signed in to Google in Chrome/Safari). **Facebook (and Instagram) use their own in-app browsers** on both platforms, which can break store hand-offs and has no Google session, so Facebook Reels traffic needs an "open in your browser" escape path.

### Cited Findings
- iOS (updated March 7, 2026): YouTube and Gmail "use default browser" ✅; Facebook, Instagram, Messenger, TikTok, Threads, LinkedIn, Google Search App do not (❌). Facebook iOS supports the `x-safari-https://` escape scheme "only via window.open" and browser-specific schemes (e.g. `googlechromes://`); Instagram needs a separate workaround. Note "Don't select Safari icon" caveat for YouTube/Gmail (selecting it routes into SFSafariViewController). — [shalanah/inapp-debugger](https://github.com/shalanah/inapp-debugger)
- Android (updated Nov 7, 2024, so older): YouTube, Gmail, LinkedIn, X, Snapchat open default browser/tab view ✅; Facebook, Instagram, Messenger, TikTok, Threads use in-app browsers ❌; Facebook and Instagram honor an `intent://` link escape to the default browser; TikTok "not dependable." — [shalanah/inapp-debugger](https://github.com/shalanah/inapp-debugger)
- Facebook/Instagram in-app browsers can suppress deep links to installed apps; on iOS a Universal Link only hands off on a user-initiated navigation, so JS/server redirects inside a webview don't trigger it; on Android, in-app WebViews may ignore `intent://`. Escape is via the menu ("Open in Safari" / "Open in external browser"). Common workaround: interstitial with an "Open in browser" button and design for a real user tap. — [WarpLink (vendor)](https://warplink.app/blog/deep-linking-in-app-browsers); [appy.to (vendor)](https://appy.to/blog/in-app-browser-deep-links)
- Facebook/Instagram inject JavaScript into pages in their iOS in-app browsers, unlike SFSafariViewController. — reported in search results summarizing [appy.to](https://appy.to/blog/in-app-browser-deep-links) (secondary)
- Host-app in-app browsers are sandboxed and logged out (example given for YouTube links inside Facebook). — [u2l.ai (vendor)](https://u2l.ai/blog/youtube-link-opens-in-browser)

### Inferences
- Detect Facebook/Instagram in-app browsers via user agent (`FBAN`/`FBAV`/`Instagram`) and show a top banner: "You're in Facebook's browser. Tap ⋯ then Open in Safari/Chrome so the install works." On Android, offer an `intent://` button to escape; on iOS, try the `x-safari-https://` scheme via a user-tap `window.open`, with the manual instruction as fallback.
- The Android Google Group/opt-in steps are the most fragile inside Facebook's webview (no Google sign-in), so on Android-in-Facebook, gate the stepper behind the escape banner. The iOS TestFlight/App Store links may still hand off from Facebook on a real tap, but this is unconfirmed; test on devices before launch.
- Link in YouTube Shorts descriptions/comments, pinned comment, or related-video link will generally open in the default browser; still test, since the Android row is two years old.

### Gaps
- No official Meta, Google, or Apple documentation found on current in-app browser handling of testflight.apple.com, apps.apple.com, groups.google.com, or play.google.com links.
- No direct confirmation of whether TestFlight public links open the TestFlight app from Facebook's iOS in-app browser. Requires on-device testing.
- Android data is from Nov 2024; may be outdated.

## 5. Desktop visitors (QR code, send-to-phone)

### Takeaway
QR codes are a usable desktop-to-phone handoff (a 2024 Census Bureau study found 100% success, about 12 seconds per scan, among experienced users). I found no NN/g article on this within budget.

### Cited Findings
- U.S. Census Bureau 2024 working paper: in a usability study of 20 respondents, all successfully scanned a QR code with no usability issues; average time-on-task 12.4 seconds. Limitation: no respondents without prior QR experience. — [Census Bureau RSM2024-05](https://www.census.gov/library/working-papers/2024/adrm/rsm2024-05.html)
- Old practitioner advice: point QR codes at a mobile-appropriate destination, not a desktop page. — [MarketingProfs 2011](https://www.marketingprofs.com/opinions/2011/23387/qr-codes-and-mobile-phones-3-marketing-blunders-to-avoid) (outdated)

### Inferences
- On desktop, replace the stepper with: one QR code pointing to playmathdragons.com (the phone then gets the platform-detected stepper, which avoids two QR codes), plus a short typed URL and an optional "email me the link" field.

### Gaps
- No data found comparing QR vs "send link to my phone" email conversion. NN/g QR article URL tried returned 404.

## 6. Trust for a kids' product from an unknown solo developer

### Takeaway
Competitors lean on awards, seals, survey stats and testimonials (Prodigy) or simply on brand (Khan); founder stories, when used, sit far below the fold (Synthesis). A new indie product has none of the third-party proof, so its trust signals are the specific privacy promise, real screenshots, and the dad-developer story.

### Cited Findings
- Prodigy's trust stack: Common Sense privacy seal, Mom's Choice Award, Parent and Teacher Choice Award, EdTech 1000, a commissioned-survey stat, testimonials labeled by role (parent, grade 5 teacher). — [Prodigy](https://www.prodigygame.com/main-en/)
- Synthesis places its founder/origin story far down the page under a named byline; its family-count social proof is inconsistent on the same page (35,000 vs 25,000), a credibility risk. — [Synthesis Tutor](https://www.synthesis.com/tutor)
- Khan Academy Kids states "No ads, no subscriptions" directly below the hero. — [Khan Academy Kids](https://www.khanacademy.org/kids)

### Inferences
- Put a one-line origin hook above the fold or right under it ("Built by a dad for his own kids"), and the fuller story lower. Without a face, use a signed first-person note, a photo of hands/desk/notebook sketches, or Tallyclaw "introducing" the dad.
- State privacy as specific, checkable facts ("No ads. No accounts. The app doesn't collect any data.") and link to the App Store/Play data-safety labels as third-party corroboration.
- Ethical social proof with few testimonials: use real, attributable quotes only (first name + "parent of a 7-year-old"), counts that are true ("Founding beta: 37 families so far"), and avoid inconsistent numbers like Synthesis's. Never fabricate.

### Gaps
- No NN/g/Baymard study found on trust signals for unknown developers or children's products.

## 7. Email capture as fallback, and the beta value exchange

### Takeaway
I found no authoritative sources within budget on email-capture-as-fallback, double opt-in effects, or how successful betas frame "what you get / what we ask." Google's own opt-in page does show testers "an explanation of tester responsibilities" and the developer's feedback channel, which is a built-in value-exchange moment.

### Cited Findings
- Google Play shows testers an explanation of tester responsibilities before opt-in, and displays the developer's feedback channel on the opt-in page. — [Google Play Console Help](https://support.google.com/googleplay/android-developer/answer/9845334)
- Testers cannot leave public reviews on test versions, so feedback must route through the developer's own channel. — [Google Play Console Help](https://support.google.com/googleplay/android-developer/answer/9845334)
- Email-sourced traffic converts best of all channels (19.3% median), per a summary of Unbounce 2024. — [MarketingProfs](https://marketingprofs.com/charts/2024/52374/landing-page-conversion-benchmarks) (secondary)

### Inferences
- Email capture is most useful as (a) the desktop "send me the link" path, (b) a fallback for users on unsupported devices or stuck mid-flow, and (c) the channel for feedback asks and launch news. Keep it visually secondary to the install CTA so it doesn't split attention from the main goal.
- Fill in the Play Console feedback channel (email or form URL) since it appears on the opt-in page.
- Frame the exchange explicitly near the CTA: "You get: the full game free, early. We ask: 2 minutes of feedback after your kid plays." Founding-tester recognition (e.g. name in credits, a "Founding Dragon Rider" in-game badge) is a common pattern, but I found no sourced evidence on its effect.

### Gaps
- No sourced data on double opt-in vs single opt-in conversion or list quality.
- No sourced examples of indie game/app beta landing pages and their value-exchange framing (search budget exhausted).
