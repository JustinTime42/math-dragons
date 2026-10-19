# CTA, Link, and Conversion-Funnel Strategy: Short-Form Video to Free App Beta (Math Dragons)

Research date: 2026-10-19. Context: YouTube Shorts + Facebook Reels traffic aimed at parents, converting to iOS TestFlight (public link) and Google Play closed testing (opt-in link), with a placeholder site at apps.routeworks.app/math-dragons.

Source-quality note: Official docs were reachable for YouTube Help (related video), Google Play Console Help (testing requirements, closed-test opt-in), Apple App Store Connect Help (external testers, feedback), and Meta Help (Meta One plans). Most other material comes from vendor and marketing blogs. Those claims are labeled as such below.

## 1. Are links clickable on YouTube Shorts (2025-2026), and what actually drives off-platform clicks?

### Takeaway
For an ordinary organic creator, Shorts still have no clickable external link inside the Short itself. Description and comment URLs were delinked on 2023-08-31, and the one in-player link (the "related video") can only point to your own YouTube content. The working off-platform paths are: (a) Short → related long-form video or channel page → a clickable link there, and (b) a short, memorable URL spoken and shown on screen that viewers type themselves. A 2026 clickable-link feature for Shorts exists, but only for paid brand-deal content through YouTube's Creator Partnerships API, so it doesn't help a solo app beta.

### Cited Findings
- YouTube delinked Shorts comments and descriptions on August 31, 2023, citing spam and scams. This was a policy decision, not a bug. — [link.boo guide](https://link.boo/guides/youtube-shorts-link-in-description); same date and reason in [Logie Buzz](https://logie.ai/news/youtube-affiliate-shopping-2025/). (Secondary sources. I didn't get the original YouTube announcement in this pass.)
- Conflicting: some vendor blogs say Shorts description URLs are auto-linked or "clickable but inconsistent" ([Unilink](https://www.unilink.us/blog/how-to-add-link-youtube-shorts), [u2l.ai](https://u2l.ai/blog/youtube-channel-links)). These conflict with the 2023 policy and are probably wrong or describe edge cases. Test on a real Short before relying on them.
- Official: "A related video allows you to showcase your Videos, Shorts, and Live in the Shorts player." Viewers "will see a clickable link below your channel handle." The video must be from your channel, public or unlisted, and Community Guidelines compliant. The feature requires "advanced feature access." — [YouTube Help: Add a related video to your Shorts](https://support.google.com/youtube/answer/14075157?hl=en)
- The related-video link can only be set manually in YouTube Studio. YouTube's public API doesn't support it, so schedulers and third-party tools can't add it. — [OpusClip help](https://help.opus.pro/docs/article/link-shorts-to-original-video); [Vizard help](https://help.vizard.ai/en/articles/13643189-can-i-add-a-link-to-my-long-form-youtube-video-when-publishing-shorts-via-vizard)
- Anecdote: a Short with 100,000 views "usually" sends only a few hundred viewers through its related-video link. This is one opinion piece, not measured data. — [OutlierKit](https://outlierkit.com/resources/youtube-shorts-to-long-form/)
- Channel-level links stay clickable. The channel description/About area supports up to 14 links. — [Unilink](https://www.unilink.us/blog/how-to-add-link-youtube-shorts); summarized in [Logie Buzz](https://logie.ai/news/youtube-affiliate-shopping-2025/)
- Regular (long-form) video descriptions do make URLs clickable. Only the first ~3 lines show above "Show more," so put the priority link there. — [u2l.ai](https://u2l.ai/blog/youtube-channel-links). Long-form descriptions may need channel verification or advanced features for some link behavior. — [link.boo](https://link.boo/guides/youtube-description-link-clickable) (vendor claim, unverified)
- 2026 change: "Links on Shorts" lets Shorts carry a clickable, trackable link, but only on brand-deal content through the YouTube Creator Partnerships API, with access limited to select partners (announced around NewFronts 2026). — [TRIBE](https://www.tribegroup.co/blog/youtube-links-on-shorts); also [Unilink](https://www.unilink.us/blog/how-to-add-link-youtube-shorts). Branded Shorts used as ads can link to a brand's site — [Search Engine Land](https://searchengineland.com/youtube-shorts-adds-comments-and-creator-links-to-ads-465986)
- Shorts don't support clickable links inside the player, and "link in bio" or channel-page CTAs are the standard workaround. — [Unilink](https://www.unilink.us/blog/how-to-add-link-youtube-shorts); [Instavar playbook](https://instavar.com/playbooks/conversion/youtube-link-funnel-end-screens-info-cards-and-shorts)

### Inferences
- Best YouTube setup for Math Dragons:
  1. Publish one public or unlisted long-form "Join the Math Dragons beta (iPhone + Android)" video (60-120 s screen walkthrough) with the beta landing URL in the first line of its description.
  2. Set it as the related video on every Short. This takes a manual Studio step per Short, so include it in the publishing checklist.
  3. Put the landing URL first in the channel links.
  4. Say and show a short typeable URL in the Short itself.
- Typing a URL is hard, so the domain matters. "apps.routeworks.app/math-dragons" is long to type from memory. A short vanity domain or path (e.g., a short custom domain that redirects to the landing page) would cut friction. A pinned comment with the URL as plain text still helps people who copy-paste.
- Treat YouTube as an awareness channel with a 2-3 hop funnel, not as a direct-response channel.

### Gaps
- Couldn't retrieve YouTube's original August 2023 announcement page. The date rests on consistent secondary sources.
- Exact current eligibility for "advanced feature access" (phone verification vs. channel history) wasn't confirmed in this pass.
- No measured data on Shorts → related video → external link click-through.

## 2. Facebook Reels: are links clickable in captions and comments, and do they hurt reach?

### Takeaway
On Facebook in 2026, a URL in a Reel caption is plain text for normal accounts. Clickable caption links on Reels are a paid feature of Meta One business plans (launched 2026-09-15, Advanced tier and up). Links in comments are clickable and were exempt from Meta's late-2025/2026 test capping non-subscribers at about 2 link posts per month. So a first-comment link plus a Page-profile link (and optionally comment-to-DM automation) is the free route. "First comment protects reach" is widely repeated, but Meta has never confirmed it.

### Cited Findings
- December 2025: Meta confirmed a limited test that capped professional-mode profiles and Pages without Meta Verified at 2 organic posts with external links per month. Links in comments, affiliate links, and links to Meta platforms didn't count. Meta's statement: "a limited test to understand whether the ability to publish an increased volume of posts with links adds additional value for Meta Verified subscribers." — [TechCrunch, 2025-12-17](https://techcrunch.com/2025/12/17/facebook-is-testing-a-link-posting-limit-for-professional-accounts-and-pages); [Press Gazette](https://pressgazette.co.uk/news/facebook-tests-charging-creators-and-businesses-to-post-more-than-two-links-per-month/). One report says the cap varied by account — [Gigazine](https://gigazine.net/gsc_news/en/20251218-facebook-testing-link-posting-limit)
- February 2026: Social Media Examiner reported the 2-link-post limit still applied to non-paying professional users and Pages, and that "users can still share unlimited links in the comments section without any limitations." — cited via [Built by Foundry, 2026-09-18](https://www.builtbyfoundry.io/blog/how-many-links-can-you-post-facebook-2026-2-free-4-paid) (secondary)
- Meta One launched worldwide on 2026-09-15 with personal and business/creator tiers. — [ValueYourNetwork](https://www.valueyournetwork.com/en/meta-one-business-links/); [ProPakistani](https://propakistani.pk/2026/09/16/meta-one-brings-a-new-subscription-to-facebook-instagram-whatsapp/)
- Official Meta One allowances for links in posts and reels, per month: Essential has none. Advanced: 4 Instagram posts, 4 Instagram reels, 8 Facebook reels. Expert: 8 / 8 / 20 Facebook reels. Max: 12 / 12 / unlimited Facebook reels. — [Meta Help: About Meta One plans](https://www.meta.com/help/subscriptions/960854640235758/). Reported US prices: Essential $14.99/mo, Advanced $49.99/mo, Expert $149/mo, Max $499/mo — [Built by Foundry](https://www.builtbyfoundry.io/blog/how-many-links-can-you-post-facebook-2026-2-free-4-paid); [ProPakistani](https://propakistani.pk/2026/09/16/meta-one-brings-a-new-subscription-to-facebook-instagram-whatsapp/). Secondary sources disagree on the Advanced-tier counts ([Blotato](https://www.blotato.com/blog/meta-one-link-limits), [elev8or](https://www.elev8or.io/blog/engage/meta-one-subscription)). Use Meta's help page as the authority.
- Outdated pre-Meta-One info: a July 2026 vendor page lists Meta Verified business tiers (Plus $44.99 = 2 linked Reels/mo, etc.). It's probably superseded by Meta One. — [Inro](https://www.inro.social/blog/meta-verified-clickable-links) (flag as outdated)
- Caption URLs on Reels "show as plain text" for most accounts. — [Paperbell](https://paperbell.com/blog/how-to-add-a-link-to-instagram-posts/) (Instagram-focused; applies to FB per [Built by Foundry](https://www.builtbyfoundry.io/blog/how-many-links-can-you-post-facebook-2026-2-free-4-paid))
- Meta's Widely Viewed Content Report: 98.7% (Q1 2026) and 98.9% (Q2 2026) of US Feed views had no link to a source outside Facebook. This points to heavy link de-emphasis at the feed level. — cited via [Built by Foundry](https://www.builtbyfoundry.io/blog/how-many-links-can-you-post-facebook-2026-2-free-4-paid)
- Many marketers advise putting links in the first comment, not the caption, to protect reach. Other sources call the effect unproven and note it adds a click. — [Socialync](https://www.socialync.io/blog/links-in-captions-vs-first-comment-2026); [bundle.social](https://bundle.social/blog/links-in-first-comment); [RKH](https://www.rkh.co.uk/news-views/should-you-put-links-in-facebook-captions/); [Luna Marketing](https://lunamarketingservices.com/links-in-caption-no-thank-you-facebook-edition/) (all practitioner opinion, not a Meta statement)

### Inferences
- Free-tier Facebook plan for Math Dragons:
  1. No URL in the Reel caption. Use "Link in the first comment ⬇️" or "Comment BETA."
  2. Post the landing link as the first comment from the Page.
  3. Put the landing URL in the Page's website/bio field, with an action button if available.
  4. Optionally, add comment-to-DM automation (see section 3).
- Meta One Advanced ($49.99/mo for 8 FB reel links) is probably not worth it at beta stage unless a specific Reel is clearly taking off. Even then, the link is one-shot per Reel.
- Facebook audiences skew older and parent-heavy, and Facebook Groups can double as both a recruitment channel and a feedback community (section 6).

### Gaps
- Whether the 2-link test became permanent policy for all non-subscribers after Meta One launched wasn't confirmed by a Meta primary source.
- No Meta statement on whether comment links affect Reel distribution.

## 3. CTA design inside the video, and keyword comment-to-DM automation

### Takeaway
No rigorous public study compares verbal vs. on-screen CTAs in short-form video. Practitioner consensus: use one CTA per video, deliver it both spoken and as on-screen text (muted viewing is common), and place it after the payoff, usually in the last 2-5 seconds, with at most a light mention earlier. Comment-keyword-to-DM automation is allowed by Meta as long as it uses the official private-reply API (one private reply per comment, within 7 days). It's a strong free workaround on Facebook, but reliability on FB Reels triggers is mixed, and ManyChat's free tier was cut back in March 2026. YouTube has no equivalent.

### Cited Findings
- CTA = one specific action, spoken, on-screen, or text. Keep it short and tied to one outcome. — [vidIQ](https://vidiq.com/blog/post/youtube-cta/); [PlayPlay](https://playplay.com/blog/video-cta-examples/)
- Short-form CTAs usually land in the final 2-5 seconds, as speech, overlay, or both. — [SuperDirector glossary](https://superdirector.app/glossary/cta)
- Place the CTA after the promised payoff so it doesn't interrupt the content and cost retention. — [faceless.so](https://faceless.so/blog/short-form-video-script-the-retention-guide)
- Hard-sell CTAs or CTAs that introduce a new topic can make viewers leave early. One CTA per video works better. — [FirstFrame Tools](https://firstframetools.com/blog/short-form-video-cta-examples)
- Audio-only CTAs miss muted viewers and visual-only CTAs miss multitaskers, so pair both. (Cites unnamed "studies"; dual-coding rationale.) — [InfluenceFlow](https://influenceflow.io/resources/the-ultimate-guide-to-an-effective-call-to-action-for-videos-2026-edition/)
- Unverified claim: verbal-only CTAs "miss 50%" of impact (creator's own testing). — [Zebracat](https://www.zebracat.ai/post/best-youtube-shorts-call-to-actions). Treat as anecdote.
- Comment-to-DM: per a vendor summary of Meta rules, Meta allows one private reply per comment within 7 days. The 24-hour messaging window opens only if the user replies. Auto-replying to comments on your own Page is allowed, and bots posting comments for you are not. — [InstantDM](https://instantdm.com/blog/facebook-comment-automation) (vendor summary; verify against Meta Messenger Platform docs)
- Meta Business Suite has a free, native, desktop-only "Comment to message" template triggered by keywords/hashtags, with no per-post rules. — [InstantDM category guide](https://instantdm.com/facebook-automation)
- Comment-to-DM "works on every account and every Reel with no cap" and is the free alternative to paid Reel links. — [Inro](https://www.inro.social/blog/meta-verified-clickable-links) (vendor with a stake in it)
- ManyChat's March 2026 pricing overhaul made its free plan "largely unusable." — [ReplyRush](https://www.replyrush.com/post/best-comment-to-dm-automation-tools) (competitor claim)
- ManyChat community reports (2026) of Facebook Reels comment triggers not firing. The suggested fix is reconnecting the Page with comment/messaging permissions granted. — [ManyChat Community](https://community.manychat.com/general-q-a-43/not-triggering-10609); [ManyChat Community](https://community.manychat.com/general-q-a-43/automation-not-working-not-responding-to-comments-and-dm-10765)

### Inferences
- Suggested CTA pattern for parent-facing Shorts/Reels:
  - Soft CTA as on-screen text in the first 1-2 s ("Free beta, link below"). It can double as the hook context.
  - Hard CTA at the end, spoken and on screen, for 2-4 s: "Want your kid to test it free? iPhone or Android, link in the first comment / tap the video below."
  - Use one action only. Don't stack "follow + like + join."
- Comment keywords ("comment DRAGON") also generate comments, which are an engagement signal. But a parent audience may be less used to the DM-bot flow than younger audiences. Use the native Meta Business Suite template first (free), and add ManyChat only if needed.
- The DM should contain the single smart link plus one line on what's expected of testers. That pre-qualifies for feedback.

### Gaps
- No controlled data on CTA placement vs. retention or reach in Shorts/Reels.
- No official Meta statement on whether keyword-bait comments ("comment X") are treated as engagement bait for ranking. Not found in this pass.

## 4. Landing page / smart link: routing iOS vs. Android, UTMs, shorteners, reducing install friction

### Takeaway
Use one memorable link that lands on a short page you control (the routeworks page). The page detects the platform, shows the right button prominently, and lays out each platform's real steps: install TestFlight, then tap the public link; or join the Google tester program with a Google account, then install from Play. Keep an email signup as a fallback for people who aren't ready or are on the wrong device (e.g., watching on a laptop). Give each video its own tagged URL or path for attribution. Public link-in-bio data suggests only about 1-3% of profile visitors click, so friction at each hop matters a lot.

### Cited Findings
- TestFlight public link: up to 10,000 external testers per app. Optional tester-count limit on the link. Optional criteria filter by device/OS version. Testers "accept the invitation using the TestFlight app on their device." — [Apple: Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- The first build for external testing requires TestFlight App Review, and the link isn't usable until approval. "Anyone can share this link." Public-link testers show as anonymous (no name/email), though installs, sessions, and crashes still show. — [Apple: Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- Google Play closed testing: "Users need a Google Account or a Google Workspace account to join a test." Testers come from email lists or Google Groups. The opt-in link appears only when the app status is "Published." "Each tester needs to opt in using the link." After first publish, "the test link can take several hours to become available." — [Play Console Help: Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334)
- Play Console lets you "Provide a feedback URL or email address to collect feedback from testers," and it appears on the opt-in page. Testers can't leave public reviews on test versions. — [Play Console Help](https://support.google.com/googleplay/android-developer/answer/9845334)
- Link-in-bio CTR is commonly cited at 1-3% of profile visitors. Other unsourced tables give 0.5-1.5% for large accounts and 2-4% for 1K-10K-follower accounts. — [Hopp](https://www.hopp.co/post/understanding-ctr-and-clicks-on-your-link-in-bio); [ttcalculator](https://ttcalculator.net/calculators/conversion-rate/tiktok-conversion-rate-optimization/) (weak, vendor data)
- Bio pages with fewer links convert better. Vendors claim 25-40% uplift from optimized bio pages over single static links. — [lflow blog](https://blog.lflow.co/blog/bio-page-conversion-social-clicks) (vendor claim)
- Link-in-bio analytics/UTM practices for tracking which post drove a click. — [Unilink analytics guide](https://www.unilink.us/blog/link-in-bio-analytics-track-audience) (vendor)

### Inferences
- Important Play Console detail for funnel design: if the closed test uses an email list, a stranger who taps the opt-in link can't join unless their address is on the list. For public recruitment, the closed track should use a Google Group set to open joining (anyone can join), with the opt-in URL behind it. The landing page then becomes a 2-step flow: "1) Join the tester group (Google account) → 2) Tap 'Become a tester' → 3) Install from Play." This follows from the help text above. Verify the Group setting before launch.
- iOS flow on the page: "1) Install TestFlight (App Store button) → 2) Come back and tap 'Join Math Dragons beta.'" Many parents won't know what TestFlight is, so one sentence ("Apple's official beta-testing app") builds trust.
- Device detection: show the matching platform button large and the other small. Desktop visitors get both, plus a QR code and the email form.
- Attribution: use per-video paths (e.g., /md/yt-012) or UTM params on the landing URL. TestFlight public links and Play opt-in URLs don't carry UTMs into the stores, so measure clicks at the landing page, and add a 1-question "where did you hear about us?" in-app or in the welcome survey.
- Shorteners: generic shorteners (bit.ly, etc.) can look spammy to parents. A branded short domain gets typeability without the trust hit. No source in this pass measured shortener effects on reach.

### Gaps
- No primary data on generic-shortener effects on trust or reach on YouTube/Facebook.
- No benchmarks for landing-page → TestFlight or Play opt-in completion.

## 5. Measuring conversion, Google Play 12/14 rule, TestFlight limits

### Takeaway
Google Play's requirement is still current in 2026 per official help. Personal accounts created after 2023-11-13 need a closed test with at least 12 testers opted in continuously for at least 14 days. The production application then asks about tester engagement, feedback, and the changes you made. So it rewards engaged testers, not just signups. TestFlight builds expire 90 days after upload (secondary sources, long-standing). Reliable benchmarks for short-form → beta signup conversion don't exist publicly. Plan on measuring your own.

### Cited Findings
- Official: personal accounts created after November 13, 2023 must "run a closed test for their app with a minimum of 12 testers who have been opted in continuously for at least 14 days." A tester who opts out and back in restarts their count, so the 14 days must be consecutive. — [Play Console Help: App testing requirements for new personal developer accounts](https://support.google.com/googleplay/android-developer/answer/14151465)
- The production-access application asks: how easy recruitment was, whether testers used all features, whether usage matched expected production behavior, a summary of tester feedback and how it was collected, changes made based on the test, and how you determined readiness. There's no numeric engagement threshold, but insufficient engagement can require more testing. — [Play Console Help](https://support.google.com/googleplay/android-developer/answer/14151465)
- History: the threshold was 20 testers until December 2024, then reduced to 12. — [TestersCommunity](https://www.testerscommunity.com/blog/google-play-closed-testing-requirements-2026) (secondary). Third-party claim that installs with no sessions "contribute almost nothing" — same source, unverified by Google. A Fiverr gig citing 25 testers is wrong or outdated — [Fiverr](https://fiverr.com/androidtesters/12-testers-for-14-days)
- Reported: if the opted-in count drops below 12, the clock resets. — [ExtendsClass](https://extendsclass.com/blog/google-plays-closed-testing-requirement-what-developers-need-to-know-in-2026) (secondary; consistent with the official "continuously" wording)
- TestFlight builds are available for 90 days after upload. Internal testing allows up to 100 team members. — [Thunkable docs](https://docs.thunkable.com/publish-to-app-store-ios/testflight-overview); [Instabug](https://instabug.com/blog/testflight-guide); 90-day period introduced in 2017 — [9to5Mac](https://9to5mac.com/2017/04/11/testflight-itunes-connect-updates-developers-beta-testers/)
- Up to six builds can be submitted to TestFlight App Review per 24 hours, and only one build per version can be in review at a time. — [Apple: Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
- Edge-case anecdote: removing external testers reportedly expired all builds (single forum report). — [Apple Developer Forums](https://developer.apple.com/forums/thread/841920)

### Inferences
- Recruit well above 12 Android testers (e.g., 25-40) so drop-offs don't push you under 12 and reset the clock. Parents recruited from Reels are less committed than friends and family.
- Ship a new TestFlight build at least every ~60-75 days so a public tester never hits an expired build. Each new build also gives a reason to re-engage testers ("new dragon world, tell us what you think").
- Track a simple funnel per video: views (platform analytics) → landing-page visits (per-video path) → platform button clicks → TestFlight installs/sessions (App Store Connect) / Play opt-ins (Play Console) → feedback submitted. The store-side step can't be attributed per video, so pair it with a self-report question.
- Collect and log feedback in a structured way from day one. The Play production application literally asks for a feedback summary and the changes made.

### Gaps
- No credible public benchmarks for short-form view → beta signup rate. Practitioner rule-of-thumb figures found were for link-in-bio CTR only (section 4).
- Didn't fetch Apple's own page stating the 90-day expiry. The figure rests on long-standing secondary sources.

## 6. Motivating high-quality feedback from beta testers

### Takeaway
Use the built-in channels (TestFlight screenshot/crash feedback, the Play opt-in page's feedback URL/email). Add a very short survey and a single community space (a Facebook Group fits a parent audience). Keep the tester pool small and engaged rather than large. Credits/recognition-style incentives are common with indie devs. Avoid paid or in-store-currency incentives for reviews (store-policy specifics are out of scope here, covered by another researcher).

### Cited Findings
- TestFlight 2.3+ lets testers submit screenshots with comments, crash comments, and general comments, all visible in App Store Connect (TestFlight tab → Feedback). Webhooks can push new feedback to your server. — [Apple: View tester feedback](https://www.developer.apple.com/help/app-store-connect/test-a-beta-version/view-tester-feedback)
- After a crash, TestFlight automatically captures the log and prompts the tester for comments. Logs also show in Xcode Organizer. — [WWDC21 session 10170](https://developer.apple.com/wwdc21/10170); [Kodeco](https://kodeco.com/10868372-testflight-essentials-quickstart-guide-for-ios-beta-testing?page=3)
- App Store Connect doesn't notify you when feedback arrives, so it's easy to miss. — [newly.app](https://newly.app/how-to/testflight-feedback) (third-party)
- Google Play test opt-in page shows your feedback URL/email. Testers can't post public reviews of test versions. — [Play Console Help](https://support.google.com/googleplay/android-developer/answer/9845334)
- "A hundred unfocused players submitting 'game crashed lol' reports are less useful than twenty engaged testers." Start with a 20-50 tester first wave, and recruit some people unfamiliar with the game to judge tutorial clarity. — [BetaHub Discord closed-beta playbook](https://betahub.io/resources/how-to-run-closed-beta-test-discord/)
- Indie devs commonly offer volunteer testers credits in the game and early access keys. — [itch.io devlog example](https://itch.io/devlog/746932/recruiting-volunteer-testers.amp)
- Niche communities where you already participate outperform generic tester subreddits (r/betatests, r/alphaandbetausers, r/TestMyApp). — [Indie App Circle](https://www.indieappcircle.com/blog/how-to-get-beta-testers-for-your-app)

### Inferences
- For Math Dragons (the parent is the tester, the child is the user):
  - In-app: after a session milestone, show a parent-gated prompt ("Parents: 2 quick questions?"), with a link to a 3-5 question form. Use the same form URL as the Play feedback URL.
  - Welcome message (landing page / DM / first launch): name the expected commitment ("play 3 times in 2 weeks, answer one 2-minute survey"). That sets expectations and helps the Play 14-day count.
  - Community: a private "Math Dragons Founding Families" Facebook Group fits a Reels-sourced parent audience better than Discord. Post weekly build notes and one targeted question.
  - Recognition incentives: "Founding Family" credit (first-name/initial list in credits, opt-in), a beta-only dragon cosmetic, or a vote on the next dragon. These are low-cost and kid-motivating. Check against store policy before offering anything tied to reviews.
- Build a feedback-ops habit (weekly export of TestFlight feedback + form responses into one log). It feeds the Play production application directly.

### Gaps
- No quantitative data found on survey length or incentive type vs. response rate for beta testers.

## 7. Case studies: apps or indie games recruiting beta testers via short-form video

### Takeaway
I found no documented, sourced case study of an app or indie game recruiting TestFlight/Play beta testers specifically through YouTube Shorts or Facebook Reels with reported conversion numbers. The available indie material covers Reddit, itch.io, and Discord recruitment.

### Cited Findings
- Recruitment guides and examples center on Reddit (r/playmygame, r/testmygame, genre subs), itch.io devlogs, and Discord. — [BetaHub](https://betahub.io/resources/how-to-run-closed-beta-test-discord/); [Indie App Circle](https://www.indieappcircle.com/blog/how-to-get-beta-testers-for-your-app); [itch.io](https://itch.io/devlog/861337/were-looking-for-volunteer-closed-beta-testers.amp)
- The 12-tester rule is widely described as a burden for solo devs, which has spawned paid tester services. — [Level Up Coding](https://levelup.gitconnected.com/the-12-tester-tax-google-plays-closed-testing-rule-is-quietly-killing-solo-devs-2cea83c2e338); [Fiverr](https://fiverr.com/androidtesters/12-testers-for-14-days)

### Inferences
- Paid "12 testers" services would technically satisfy the count but probably not the engagement and feedback questions on the production application, and they won't give parent/kid insight. Organic parent testers from short-form are more valuable even if fewer.
- Math Dragons can become its own case study: log per-video funnel numbers from the start.

### Gaps
- No short-form → beta-tester case studies with numbers found. A deeper search of r/gamedev, r/androiddev, and r/iOSProgramming postmortems might turn up anecdotes (not done due to the tool-call budget).
