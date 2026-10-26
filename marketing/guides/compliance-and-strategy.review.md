---
reviewed:
  - marketing/guides/compliance-checklist.md (draft, created 2026-10-26)
  - marketing/guides/content-strategy.md (draft, created 2026-10-26)
review_date: 2026-10-26
reviewer: independent accuracy-and-sense reviewer (did not author either guide)
procedure: marketing/README.md, "Accuracy and sense review"
app_code_checked: main @ 4c04c6f
---

# Accuracy and sense review: Compliance Checklist and Content Strategy

## Verdicts

| Document | Verdict | Blocking fixes |
|---|---|---|
| `compliance-checklist.md` | **PASS WITH FIXES** | B1 (adaptivity claim is wrong for Fire Trail). Everything else is a caveat or a gap |
| `content-strategy.md` | **PASS WITH FIXES** | S1 (the "Join the beta" walkthrough must be landscape or it becomes a Short with dead links), S2 (the weekly two-part puzzle series breaks the pillar mix) |

Most policy claims hold up against primary sources fetched today (YouTube Help, Play Console Help, Apple, FTC). The research was careful, and the guides mostly carry its caveats. The serious problems are a wrong app claim inherited from the approved brand guide, a funnel-breaking format detail, and arithmetic in the content plan that doesn't add up.

### Most important findings

1. **Fire Trail does not use the adaptive engine (WRONG, blocking, also affects the approved brand guide).** `lib/games/fire_trail/fire_trail_game.dart:60-69` builds `FireTrailFlameGame` without passing `difficultyEngine`, so it stays `null` (`fire_trail_flame_game.dart:76`, `:110`). `ProblemManager.generateProblem()` (`systems/problem_manager.dart:88-99`) then always falls back to `_generateRandom()`. The engine code in the problem manager exists but never runs. The 2026-10-19 brand review cited `problem_manager.dart:89-92` as proof and missed that the engine is never wired in. What the code actually does today:
   - **Dragon Eggs:** random (no engine).
   - **Fire Trail:** random (engine never passed).
   - **Dragon Runes:** one engine-suggested fact per level (`dragon_runes_game.dart:72-84`).
   - **Dragon's Feast:** this is a number-properties game. It asks the engine for 5 add/multiply facts and biases the board's numbers toward their operands and results (`dragons_feast_flame_game.dart:155-173`, `:731-738`). The child sorts those numbers (even/odd, primes and so on) but doesn't practice the facts themselves. It also logs answers as `"<category>:correct|wrong"`, not as arithmetic facts (`dragons_feast_game.dart:94`).

   So "Fire Trail and Dragon's Feast steer practice toward missed facts" is false for Fire Trail and a stretch for Feast. Brand guide sections 4.4 (Narrator app line), 5.1 ("two of which steer practice") and 5.2 carry the same error. Two ways out: (a) the app owner passes `context.read<DifficultyEngine>()` into `FireTrailFlameGame` (about a one-line change, which then needs a test); or (b) every guide drops the claim to what is true: "The app keeps track of the facts your kid misses. Dragon Runes brings one back every level." Don't publish any adaptivity claim until one of these is done. Also check the website copy for the same claim.
2. **A 60-120 s vertical walkthrough is a Short (WRONG premise, blocking).** Since October 15, 2024, square or vertical uploads up to 3 minutes count as Shorts (official, per `algorithms_and_craft.md` §1). Shorts descriptions have no clickable links. The whole YouTube funnel depends on this video's description link, so the walkthrough must be uploaded **16:9 landscape**. The strategy and the checklist both need to say so.
3. **The related-video link needs "advanced feature access"** (YouTube Help 14075157, fetched today). That means phone verification plus either channel history or ID/video verification. A brand-new channel may not have it on day one. Neither guide mentions this, and the strategy's first-30-days plan assumes the link works from the first Short.
4. **The pillar and series numbers conflict.** At 3 videos a week, a weekly two-part Dragon Puzzle takes 2 of 3 slots (67% of output), but pillar 1 is set at ~35% and also has to cover Tricks They Didn't Teach Us. The judging rules don't fit the volume either. In 90 days at 3 a week (~39 videos), pillar 4 gets ~8 videos and never reaches the "judge after 10-15 posts" threshold. By the week-4 review there are ~12 videos in total, about 2-4 per pillar.
5. **Off-channel posting by Justin needs a disclosure rule.** The strategy's "Parent Facebook groups … as a participant" has no rule that Justin says he built the app. Under the FTC Endorsement Guides, a developer recommending his own app while looking like an ordinary parent is a material connection that has to be disclosed. Checklist §I covers other people but not Justin.
6. **The TestFlight ® rule misreads Apple's guidance for video.** Apple's list does show TestFlight® (verified). But Apple's marketing guidelines say symbols apply "in communications distributed only in the United States", forbid them on communications distributed outside the US, and say not to add them to headline copy. A YouTube or Facebook video is distributed worldwide, and on-screen text is closer to a headline than to body copy. Drop the symbol from videos. Keep it for the website, where body copy exists and the brand guide already requires it.
7. **The CTA rules across the three guides need one sentence to reconcile them.** The brand guide says "CTA: one per piece, after the payoff, spoken and on screen", and its voice checklist expects one CTA per piece. Checklist §H says "One CTA per video". The strategy gives value videos no spoken pitch but a URL corner mark that is on screen from frame 1. These are compatible only if the corner mark is defined as branding, not a CTA, and the rule reads "at most one CTA". Brand guide §3.4 says "most videos never mention the app", and a URL on screen arguably mentions it. Details in S7.

---

## Claims table

Verdict key: VERIFIED / NEEDS CAVEAT / UNVERIFIABLE / WRONG. "Notes" = `marketing/research_notes/Faceless short form video playbook/`. Primary sources were fetched 2026-10-26 unless marked otherwise.

| # | Doc | Section | Claim | Verdict | Evidence | Suggested fix |
|---|---|---|---|---|---|---|
| 1 | CC | A | MFK videos lose comments, end screens, cards, notification bell, save-to-playlist | VERIFIED | YouTube Help 9527654 (fetched): list includes comments, cards or end screens, notification bell, save to playlist/watch later, personalized ads, miniplayer | none |
| 2 | CC | A | YouTube can override our setting, with only one appeal per video | VERIFIED | 9527654: "we may override your audience setting choice in cases of error or abuse"; "You may appeal each video only once" | none |
| 3 | CC | A | Animated characters, games that appeal to children, early education are MFK factors | VERIFIED | YouTube Help 9528076 (fetched): "animated characters or cartoon figures"; "activities that appeal to children, such as play-acting, simple songs or games, or early education". It also says no single factor decides it, and "animated content that appeals to everyone" is a general-audience example | Optional: add the general-audience examples so reviewers know dragons alone don't decide it |
| 4 | CC | A | Disney paid $10M (announced Sept 2025) for setting "not made for kids" at the channel level instead of reviewing videos | VERIFIED | FTC press release 2025-09 (via search of ftc.gov): channel-level designation left child-directed videos labeled NMFK; Disney kept the approach after YouTube flagged 300+ videos in 2020; order requires per-video review; court approved Dec 2025 | Add: "the videos were in fact child-directed; per-video review is the control, not a substitute for being adult-directed" |
| 5 | CC | A | Set audience per video; never rely on a channel default | VERIFIED (sound) | Disney order requires an audience-designation program | Add the concrete Studio step: channel-level setting = "I want to review this setting for every video" |
| 6 | CC | A | If marked MFK, don't re-upload | VERIFIED (sensible) | Re-uploading to dodge a classifier risks "abuse" and the Oct 2026 re-upload demotion | none |
| 7 | CC | B | FTC requires objective claims to be substantiated before they're made; it has acted on kids' educational-benefit claims and false privacy-seal claims | VERIFIED | Landing report §Claims: Jungle Rangers (~2015, commentary), Miniclip 2020 (FTC official); FTC Endorsement Guides | Note the newest educational-claims case found is ~2015 |
| 8 | CC | B | Apple can act on misleading marketing outside the App Store (2.3.1(a)) | VERIFIED | App Store Review Guidelines (fetched): "marketing your app in a misleading way … whether within or outside of the App Store, is grounds for removal" | Add Google's counterpart: Play "App Promotion" policy (answer 9899004) bars deceptive promotion practices |
| 9 | CC | B | "Only Fire Trail and Dragon's Feast steer practice toward missed facts (Dragon Runes partly, Dragon Eggs not at all)" | **WRONG** | Fire Trail: engine never passed (`fire_trail_game.dart:60-69`; `problem_manager.dart:88-99` falls back to random). Feast: biases board numbers only (`dragons_feast_flame_game.dart:155-173`). Runes: one fact per level. Eggs: random. See finding 1 | Fix the app, or restrict the claim to "tracks missed facts; Dragon Runes brings one back each level". Also fix brand guide §4.4, §5.1, §5.2 |
| 10 | CC | B | "The app collects no data" (scoped) | VERIFIED | No HTTP/socket/WebView code in `lib/`. Release `AndroidManifest.xml` no longer requests INTERNET. iOS `NSAllowsArbitraryLoads` is now `false`. The only outbound path is `url_launcher` to playmathdragons.com pages behind the parental gate (`lib/core/external_links.dart`), which opens the system browser | Keep the scope; the website's analytics are the site's, not the app's |
| 11 | CC | B | Perk wording "Everyone in the beta gets the full unlock free when Math Dragons launches" | VERIFIED (matches brand guide 5.4) | Apple 2.2 bars distributing TestFlight builds "in exchange for compensation"; a thank-you to everyone is the safe pattern (landing report) | Add: testers or creators who post publicly after getting the perk should disclose it (material connection) |
| 12 | CC | B | Outcome claims in testimonials count as our claims | VERIFIED | FTC Endorsement Guides 2023 (notes §7, official FRN) | none |
| 13 | CC | C | YouTube disclosure required for realistic content: real people saying things they didn't, altered real events, realistic scenes, AI music as main focus | VERIFIED | YouTube Help 14328491 (fetched) | none |
| 14 | CC | C | YouTube exempts clearly unrealistic/animated content and cloning your own voice | VERIFIED | 14328491: "Cloning one's own voice to create voice overs or dubs" listed as not requiring disclosure; the list is "not exhaustive" | none |
| 15 | CC | C | Disclosure doesn't limit reach or monetization | VERIFIED | 14328491: "Disclosing AI content alone won't limit a video's audience or impact its eligibility to earn money" | none |
| 16 | CC | C | YouTube may auto-label C2PA content, and that label can't be removed | VERIFIED | 14328491: C2PA content "can not be adjusted" | Add: assets from OpenAI image generation (the project's `/generate-image` pipeline) and some ElevenLabs output may carry C2PA. Accept an auto-label; never strip metadata to avoid one |
| 17 | CC | C | Meta may require an AI label on photorealistic video or realistic-sounding audio; an AI-narrated reel is its example | VERIFIED (via search summary of Meta Help 1783222608822690; the direct fetch failed) | Search result quotes the help page: "a reel narrated with a realistic AI-generated voiceover" | Given that example, label Justin's clone on Facebook as **likely required**, not merely conservative (see S9) |
| 18 | CC | C | YouTube rule: tick disclosure for "any synthetic human-sounding voice that isn't Justin's clone" | NEEDS CAVEAT | YouTube doesn't require this for a non-impersonating narrator (notes §2 call it ambiguous). The same bullet exempts Tallyclaw, whose voice is synthetic, so the two parts of the bullet conflict | State explicitly: Tallyclaw = no YouTube disclosure (fictional character). Any other realistic synthetic narrator = voluntary disclosure |
| 19 | CC | D | Facebook demotes vote, react, share, tag, comment bait; repeat offenders get Page-wide demotion | VERIFIED (dated) | Facebook Newsroom, Dec 2017 "Fighting Engagement Bait" (search): post-level demotion plus stricter Page-level demotion for repeat use. The current Transparency Center page defines engagement bait as posts that "explicitly request engagement" (votes, shares, comments, tags, likes, reactions) but states no penalties | Cite the 2017 date. The current page is the definition; the Page-level penalty rests on 2017 |
| 20 | CC | D | YouTube allows asking for likes/comments/subs; bans rewards, sub-for-sub, misleading titles/thumbnails | VERIFIED | YouTube Help 2801973 (fetched) | Add: the same policy bars "content created solely to drive users off of YouTube to external sites". Promos must stand on their own as content (the strategy's "promos built as lessons" already does this) |
| 21 | CC | D | "Comment BETA" keyword-to-DM: Meta hasn't said whether it's comment bait | VERIFIED (as a gap) | Notes cta §3 gaps; "Comment YES" is Meta's own 2017 example, and "Comment BETA" has the same shape | Keep the default (not used) |
| 22 | CC | D | "Genuine questions are fine ('What's your answer?' on a real puzzle)" | NEEDS CAVEAT | Meta's 2017 exemption covered requests for help, advice or recommendations. The current definition targets posts that "explicitly request engagement". "What's your answer?" vs "comment your answer" (banned in strategy §6) is too fine a line for a reviewer to apply consistently | See S8: put the puzzle question on screen and let the caption state the puzzle, with no request to comment |
| 23 | CC | E | Meta's popular-music licenses cover personal, not business, use; Sound Collection is cleared | NEEDS CAVEAT | Notes §8 are commentary only; today's search found the same consensus but no Meta primary text | Keep the rule (it is the safe direction). Mark the source tier |
| 24 | CC | E | ElevenLabs Music on a commercial-use plan is licensed audio | NEEDS CAVEAT | Eleven Music terms (search; direct fetch 404'd): the free plan is non-commercial; paid plans allow commercial use, but Starter-Scale list "Prohibited Commercial Contexts". Some 2025 language versions include "streaming media content" and TV/radio ads; the pre-Nov-2025 English terms limited this to offline media | Before first use, save the current Eleven Music terms for the active plan in the video folder, and confirm YouTube/Facebook organic video isn't a prohibited context |
| 25 | CC | F | YouTube's inauthentic-content policy renamed July 15, 2025; removes monetization from templated channels | VERIFIED | Notes §1 (official YPP page) | Add: it is a **monetization** policy, and the channel isn't in YPP, so it is a quality signal for us, not a direct penalty |
| 26 | CC | F | YouTube's Oct 1, 2026 update reduces reach for re-uploaded content | VERIFIED (official via secondary) | Android Authority, PPC Land, Social Media Today, SEJ (search today): targets channels that mainly re-upload **others'** content; own clips are likely unaffected; primary post not found | Say it targets others' content; our own first-party footage is the safe case |
| 27 | CC | F | Meta has demoted reposts and minor edits since July 2025 | VERIFIED | Notes §3 (TechCrunch, Tubefilter, July 14-15, 2025) | none |
| 28 | CC | F | Never re-post a Short downloaded from YouTube Studio (watermark) | VERIFIED | Notes craft §7 (TechCrunch 2022, official) | none |
| 29 | CC | F | "Consecutive videos don't share the same structure (rotate formats per `format-library.md`)" | WRONG (overly strict; file missing) | YouTube's policy explicitly allows "series with similar formats where each video has a distinct storyline, focus, or concept" (notes §1). The strategy's weekly Dragon Puzzle series reuses one structure by design. `format-library.md` doesn't exist | Replace with: "each video has a distinct concept; no two consecutive videos are the same series" and mark `format-library.md` as to be written |
| 30 | CC | F | No App Store, TestFlight or Google Play badges during beta | VERIFIED | Apple Marketing Guidelines (landing report, official): badge only for apps available on the App Store; there is no TestFlight badge. Google has a pre-registration badge only | none |
| 31 | CC | F | "TestFlight" gets ® on first mention in on-screen text | NEEDS CAVEAT | Apple trademark list (fetched): "TestFlight®" (symbol confirmed). Apple Marketing Guidelines (fetched): symbols for "communications distributed only in the United States"; "Do not use trademark symbols on … communications that will be distributed outside the United States"; "Don't add symbols to headline copy" | Videos: no symbol. Website body copy: ® on first US mention, per the brand guide |
| 32 | CC | F | Apple bezels only; no iPhone and Android device side by side | VERIFIED (slightly overbroad) | Apple guidelines (fetched): "Use Apple-provided product bezels"; "Don't show an Apple product along with a competing product"; multi-platform references "only in copy or with badges"; use the latest-generation devices | Clarify: an Android-only frame in an Android-only shot isn't barred by Apple; just never mix with Apple devices. Use current-generation Apple bezels |
| 33 | CC | H | Spoken URL plain `playmathdragons.com` | VERIFIED | Brand guide §7 | none |
| 34 | CC | H | Per-video paths (`/yt012`) in "the YouTube beta-walkthrough video's description" | WRONG (mechanically impossible) | Every Short shares one walkthrough, so its description can't carry a per-Short path | YouTube attribution is per channel, not per video. Use `/yt` in the walkthrough description and channel links, plus the self-report question. Per-video paths only on Facebook |
| 35 | CC | H | The Android flow has three steps | VERIFIED | Landing report: TestFlight two steps, Play closed testing three | none |
| 36 | CC | I | Paid/gifted/connected posters must disclose; their claims need the same substantiation (FTC Endorsement Guides, 2023) | VERIFIED | Notes §7 (FTC 2023 FRN) | Add Justin's own off-channel posts (S5) and the FTC Consumer Reviews and Testimonials Rule (effective Oct 14, 2024): never buy followers, views or likes |
| 37 | CC | I | Self-promotion on our own channel needs no paid-promotion disclosure | VERIFIED (inference, sound) | YouTube's paid-promotion box covers third-party paid placements, sponsorships and endorsements; no YouTube text found on own-product promotion (search) | none |
| 38 | CC | J | Related video can only be set in Studio; the API can't set it | NEEDS CAVEAT | YouTube Help 14075157 (fetched) describes only Studio on desktop; the API point comes from vendor help docs (OpusClip, Vizard). The page also requires **advanced feature access** | Add the advanced-feature-access prerequisite to setup and to J |
| 39 | CS | 1 | Google Play: ≥12 testers opted in for 14 consecutive days; opting out and back in restarts the count | VERIFIED | Play Console Help 14151465 (fetched) | Add the scope: "personal accounts created after November 13, 2023". Confirm Justin's account falls under it |
| 40 | CS | 1 | iPhone/iPad testers have no gate | VERIFIED (loosely) | No tester-count requirement on Apple; a public link needs Beta App Review; 10,000 cap; builds expire after 90 days (notes cta §5) | Optional: mention the 90-day build expiry, since it shapes tester retention |
| 41 | CS | 1 | YouTube now counts a Shorts view on every start or replay | VERIFIED | Notes craft §1 (official, Mar 31, 2025); extended to all formats Aug 24, 2026 | none |
| 42 | CS | 2 | Shorts are judged separately from long-form | NEEDS CAVEAT | Official via secondary only (May 2025 blog, original not opened) | Mark the tier |
| 43 | CS | 2 | No clickable links in Shorts descriptions or comments since 2023 | VERIFIED | Aug 31, 2023 change (search today: Malwarebytes, Tubefilter, 9to5Google, quoting YouTube) | none |
| 44 | CS | 2 | "The only clickable link is the per-Short related video" | NEEDS CAVEAT | Channel-page links (header, near Subscribe) stay clickable and are one tap from the Short via the handle. The related video needs advanced feature access | "The only clickable link in the Short itself …; channel links are the backup" |
| 45 | CS | 2 | Long-form walkthrough 60-120 s, `playmathdragons.com` in its description | **WRONG unless landscape** | Vertical or square uploads up to 3 min have counted as Shorts since Oct 15, 2024 (notes craft §1, official) | "Upload 16:9 landscape so it is long-form with a clickable description link" |
| 46 | CS | 2 | Facebook caption links are plain text unless we pay for Meta One | VERIFIED | Notes cta §2: Meta Help "About Meta One plans" (official) | none |
| 47 | CS | 2 | Facebook Reels are "likely our best converter" | UNVERIFIABLE (hypothesis) | No data. Landing report: Facebook's in-app browser lacks a Google session and can break the Play hand-off | Label it a hypothesis and link it to the landing report's in-app-browser risk |
| 48 | CS | 3 | Pillar shares 35/25/20/20 and "about four value videos per promo" | VERIFIED (arithmetic) | 35+25+20+20 = 100; promo pillar 20% = 1:4 (run in code) | See S2 for the series conflict |
| 49 | CS | 4 | Shorts "series" feature with seasons, reported Sept 2026 by one source | NEEDS CAVEAT (now better supported) | Several secondary sources (search today) report a Made on YouTube Sep 23, 2026 announcement; YPP creators get it first | "Announced Sep 23, 2026; YPP channels first, so probably not available to us yet" |
| 50 | CS | 5 | Largest dataset (108K Shorts): median views peak at 11-20 s, fall off past 30 | VERIFIED (third-party data) | Notes craft §4 (Quso.ai, 108,138 Shorts) | Label as third-party. Note vidIQ/Nate Black found clusters near 13 s and 60 s, which supports the 45-90 s trust tier |
| 51 | CS | 5 | No end cards on Shorts: they hurt replays and completion | NEEDS CAVEAT | Inference in notes, not measured. Shorts don't support YouTube end screens anyway; "end card" here means an outro slate | "No outro slate; end on the payoff or a loop" (reasoning, not data) |
| 52 | CS | 5 | Re-hook about every 10 s | VERIFIED (as practitioner consensus) | Notes craft §4 (OpusClip) | Mark as consensus |
| 53 | CS | 6 | Promo CTA line "It's free during the beta. If you want in, it's playmathdragons.com." | VERIFIED | Matches brand guide §4.4 and §5.4 | none |
| 54 | CS | 6 | Promo CTA in the last 2-5 s | VERIFIED (practitioner) | Notes cta §3 | none |
| 55 | CS | 7 | 3 a week to start; 90 days; judge formats after 10-15 posts | VERIFIED (matches research) | Notes craft §5 inference: 3-5/week, 90+ days, 10-15 posts | See S3 for the internal fit |
| 56 | CS | 7 | YouTube said time of day isn't something it optimizes for (2023) | VERIFIED | Notes craft §5 (Todd Sherman, Creator Insider, Aug 2023; via transcript) | none |
| 57 | CS | 8 | Fibonacci Day Nov 23 (11/23: 1, 1, 2, 3); first is Nov 23, 2026 | VERIFIED | Date logic correct; 2026-11-23 is a Monday, 28 days from today (run in code) | Note it's an informal observance and the 11/23 reading is US date format |
| 58 | CS | 8 | Pi Day Mar 14 | VERIFIED | Notes math_learning_evidence #48 (HIGH) | none |
| 59 | CS | 8 | "The app works offline" | VERIFIED | No network code in `lib/`; release Android manifest has no INTERNET permission; assets bundled | none |
| 60 | CS | 10 | Micro creators get free access and a press kit, disclosed per checklist | VERIFIED (direction) | FTC Endorsement Guides: free product is a material connection | none |
| 61 | CS | 10 | Parent Facebook groups "as a participant" | NEEDS CAVEAT (missing rule) | FTC Endorsement Guides: a marketer's undisclosed promotion posing as a neutral user is deceptive | Add: "always say you built it" (S5) |
| 62 | CS | 1, 11 | Target 25-40 Android testers | VERIFIED (inference) | Notes cta §5 | none |

Doc key: CC = compliance-checklist, CS = content-strategy.

---

## Sense-read issues

### Blocking

**B1 / S0. The adaptivity claim (claim 9).** See finding 1. A teacher or parent who plays Fire Trail sees random problems. This undercuts "Correct" and "Honest", values 1 and 3 in the brand guide. It also matters for Apple 2.3.1(a): "promoting content or services that it does not actually offer". The brand guide is approved and carries the same error, so this needs Justin, not just an edit here. Recommended order: wire the engine into Fire Trail (app task, with a test that `FireTrailFlameGame.difficultyEngine` is non-null on the real screen), re-verify, then decide the claim.

**S1. The walkthrough format (claim 45).** One word ("landscape") separates a working funnel from a dead one. Put it in strategy §2, §9 step 2, and checklist J.

**S2. The weekly two-part puzzle eats the plan.** At 3/week, Dragon Puzzle part 1 + part 2 = 2 slots, which leaves 1 slot a week for pillars 2, 3 and 4 and for Tricks. Options: make Dragon Puzzle fortnightly; or put the answer in the same video (the loop reveal at the end, as §5 already recommends); or post part 2 as a YouTube community post or pinned comment rather than a video. A two-part puzzle also cuts against §5's own loop design, which wants the reveal "in the last second" of the same video.

### Should fix

**S3. Judging thresholds vs volume.** At 3/week (code check): 90 days ≈ 39 videos, giving ~13.5 / 9.6 / 7.7 / 7.7 per pillar. Pillars 3 and 4 never reach "10-15 posts". The week-4 review sees ~12 videos (2-4 per pillar) yet is told to "shift the mix". Fix: at week 4, cut only obvious failures (formats with clearly worse viewed-vs-swiped); judge pillars at day 90; judge series, not pillars, at 10-15 posts.

**S4. Render gate coverage.** Checklist line 17 runs A, C, E, F, G at render. On-screen text, captions and the corner URL are added at render, and these are exactly where claims (B), engagement-bait wording (D) and URL/CTA errors (H) creep in. README stage 5 says the render review exists because edits and captions introduce errors. Add B, D and H to the render gate.

**S5. Justin's own off-channel activity.** Add to §I: "When Justin posts or comments about Math Dragons anywhere other than our channels (parent groups, other creators' comments, Reddit), he says he built it." Also add the FTC Consumer Reviews and Testimonials Rule (2024): never buy views, followers or likes, never post or solicit fake reviews. That is the main FTC risk a growth marketer actually walks into.

**S6. YouTube attribution.** See claim 34. Once that is fixed, the metric "which video sent people to playmathdragons.com" (strategy §11) can't be answered per Short on YouTube. Say so in §11, and lean on channel-level `/yt` counts plus the self-report question.

**S7. Reconciling the CTA rules.** Fine in substance, loose in wording:
- Brand §7 and §11: "one CTA per piece, after the payoff, spoken and on screen".
- Checklist §H: "One CTA per video, after the payoff".
- Strategy §6: value videos have no spoken pitch but a permanent on-screen URL mark.

Fix all three to one rule: "At most one CTA, after the payoff. The small handle/URL corner mark is branding, not a CTA. Value videos carry no beta pitch; a share prompt may be their one CTA." Brand §3.4 "Most videos never mention the app" stays true if the mark is defined as branding. Tallyclaw never delivers the CTA (brand 4.3), so add that to checklist §H too.

**S8. Puzzle comments on Facebook.** The working distinction is whether the post *tells* people to engage. Proposed rule: the on-screen puzzle and caption state the puzzle ("Most adults get this wrong. The answer's in the next video.") with no "what's your answer?" and no "comment". People comment on puzzles anyway, so the reach isn't lost.

**S9. The Facebook AI label is closer to required than "conservative".** Meta's own example is a reel with a realistic AI voiceover, which is exactly Justin's clone. Reword open decision 2 to "label every Facebook video that uses any AI voice; Meta's example covers it". The reach effect of the label is unknown (no Meta source), so log it in metrics.

**S10. Facebook as "best converter".** The landing report found Facebook's in-app browser is the biggest technical risk for the Play hand-off. The strategy should not assume Facebook converts best until the W5 device tests pass. Link the two docs.

**S11. Stale caveats to carry.** The "re-verify rules older than six months" line is ambiguous: older than what? The engagement-bait penalty dates to 2017, and the posting-time statement to 2023. Make it: "re-verify if the cited source is more than 12 months old or the research date is more than 6 months old".

### Missing coverage (add when convenient)

- **Channel setup prerequisites:** phone verification and advanced feature access (related video, pinned comments); the channel-level audience option "review every video".
- **Google Play's App Promotion policy** (answer 9899004) alongside Apple 2.3.1(a): deceptive promotion of an app is a Play violation too.
- **Captions** belong in a craft guide, but the checklist is the only gate run on every render. Add one line: "burned-in captions present and correct" (accessibility and muted viewing; also where claim errors hide).
- **Tester and Group data:** if the "Founding Families" Facebook Group happens, the checklist's §G rules (no child details, hide personal info) apply there too, and so does moderation.

### Things checked and found sound

- MFK framing, the Disney lesson, child-free visuals and child-comment handling are accurate and sit at the right level of caution for a kids' app.
- The YouTube AI-disclosure rules, own-voice exemption and C2PA auto-label match the live help page word for word.
- Play's 12/14 rule and opt-out reset match the live help page.
- Badge, bezel and trademark-list facts match Apple's pages.
- Pillar percentages sum to 100 and match the 4:1 ratio. Cadence, 90-day commitment and length tiers match the research.
- The privacy and offline claims hold on main @ 4c04c6f. The INTERNET permission and ATS exception flagged in the brand review (S13) have since been removed.
- Prose rules: both guides have zero em-dashes, and no "not X, Y" reframes were found in either.

### Overly cautious? (growth-marketer read)

Only one rule would materially hurt reach without a basis: the "consecutive videos don't share the same structure" rule (claim 29), which would forbid recognizable series, the format both platforms reward (Facebook's "keep watching" prediction, YouTube's series feature). Everything else that is cautious (no keyword-to-DM, no trending music on Facebook, labeling the voice clone on Facebook) is either cheap or rests on a real policy.

---

Em-dash count in this review: 0. "Not X, Y" reframes: 0.
