---
reviewed:
  - marketing/guides/format-library.md (draft, created 2026-10-26)
  - marketing/guides/script-standards.md (draft, created 2026-10-26)
review_date: 2026-10-26
reviewer: independent accuracy-and-sense reviewer (did not author either guide)
procedure: marketing/README.md, "Accuracy and sense review"
consistency_checked_against: brand-and-voice.md (approved), compliance-checklist.md, content-strategy.md, compliance-and-strategy.review.md
app_code_checked: main @ 814843e (lib/)
math_checked_by: python3 script (dragon puzzle rate, 9s finger trick n=1..12, make-a-ten, word budgets, fortnight mix vs pillar shares, Tallyclaw share)
---

# Accuracy and sense review: Format Library and Script Standards

## Verdicts

| Document | Verdict | Blocking fixes |
|---|---|---|
| `format-library.md` | **PASS WITH FIXES** | F-1 (the "Format mix by week" misses the pillar shares and the Tallyclaw frequency), F-2 (F6 "the game where she practices it" overstates what the app does when "it" is a strategy such as making ten or the finger trick), F-3 (F7's example "Why the dragon doesn't time your kid" is false for the current app), F-4 (puzzle part 1 has no path to part 2 on YouTube) |
| `script-standards.md` | **PASS WITH FIXES** | S-1 (unsourced craft numbers stated as rules; label them heuristics and fix the safe-zone figure), S-2 (captions "matching the VO exactly" conflicts with digits-on-screen) |

All the math in both guides is correct (run in code). The platform facts match the research and the prior review. The problems are in the seams: the format mix doesn't add up to the strategy's shares, a few example premises and app implications don't survive contact with the code, and several craft numbers read as research findings when they are house heuristics.

### Most important findings

1. **The fortnight mix misses the strategy (F-1).** Computed: with the Tricks slot, pillars land at 50 / 17 / 17 / 17% (target 35 / 25 / 20 / 20). With the Homework Decoder slot, 33 / 33 / 17 / 17%. Alternating the two: 42 / 25 / 17 / 17%. Over 90 days (39 videos) that is about 16 / 10 / 6.5 / 6.5 against the strategy's 14 / 10 / 8 / 8, so pillars 3 and 4 never reach the strategy's "judge a pillar after about 8-10 posts". The value-to-promo ratio becomes 5:1 instead of 4:1, and the F8b "How to join" Short has no slot. Tallyclaw is guaranteed in only 1 of 6 slots (17%); the brand guide says about 1 in 3.
2. **F6's "Here's the game I built where she practices it" (F-2).** The app drills facts; it does not teach or practice strategies. No game shows a ten-frame, number bond, decomposition or finger method (searched `lib/` for make-ten, number bond, ten-frame, finger: no hits). Addition facts that cross ten (like 8 + 5) are in range (Fire Trail world 2: add/subtract, numbers 1-10, `fire_trail_config.dart:86-88`), and 9s facts appear in mixed multiplication levels (numbers 2-10 or 2-12), but a parent can't choose "just the 9s". So after an F2/F3 segment on making ten or finger 9s, "the game where she practices it" implies the app practices the trick. True wording: "the game where she practices facts like 8 + 5".
3. **F7's example "Why the dragon doesn't time your kid" is false today (F-3).** Dragon Eggs ends the level when an egg reaches the danger line (`dragon_eggs_flame_game.dart:324-333`) with spawn rate rising with intensity; Fire Trail's dragon moves at a level-set speed (`fire_trail_config.dart:33-65`) after a 3-2-1 countdown; every game records response time in milliseconds, and the scheduler uses average response time (`problem_generation.dart:360-362`). There is no visible stopwatch, but the games are real-time. As a format example this will get copied into the idea bank. Replace it, or scope it to something true ("no countdown clock on the math" only if verified per game).
4. **Puzzle part 1 dead-ends on YouTube (F-4).** "Answer in the next video" has no clickable route: compliance §J sets every Short's related video to the F8a walkthrough, and part 2 doesn't exist yet when part 1 posts. Viewers have to find part 2 through the channel or the playlist.
5. **Craft numbers (S-1).** Visual change every 1-3 s is correctly labeled. The VO pace (2.5 words/s), word budgets, 40-65 character titles, "payload in first 40", 3-5 hashtags, the 7-word callout limit and the "bottom fifth" safe zone have no source in the research; most are reasonable house rules and should say so. The safe zone is too small: commonly cited Reels ad margins are about 14% top, 35% bottom and 6% sides (community-reported, ad spec only), and the guide says nothing about the top edge.

---

## Claims table

Verdict key: VERIFIED / NEEDS CAVEAT / UNVERIFIABLE / WRONG. "Notes" = `marketing/research_notes/Faceless short form video playbook/`. "Report" = `marketing/reports/Faceless short form video playbook.md`. FL = format-library, SS = script-standards.

| # | Doc | Section | Claim | Verdict | Evidence | Fix |
|---|---|---|---|---|---|---|
| 1 | FL | F1 example | 5 dragons eat 5 cakes in 5 min; 100 dragons eat 100 cakes in **5 minutes** | VERIFIED | Code: rate = 1 cake per dragon per 5 min, so 100 / (100 × 1/5) = 5. Holds whether dragons share cakes or not, as long as every dragon eats at the same steady rate | State the assumption in the pose ("every dragon eats at the same speed") so it meets the "unambiguous" rule |
| 2 | FL | F1 example | Common wrong answer: 100 minutes | VERIFIED (math), NEEDS CAVEAT (source) | Naive scaling 5 × 100 / 5 = 100. This is the "widgets" item of Frederick's 2005 Cognitive Reflection Test, where 100 is the known intuitive answer. Neither Frederick nor any frequency data is in the research notes | Add Frederick (2005) to the claims list. Part 2 beat 1 says "Most people say…": for this puzzle say "A very common answer is 100" unless a fetched source gives the share; for original puzzles there is no data, so "most people" is never usable |
| 3 | FL | F1 rules | Pitched so a parent and a 7-12-year-old can try it together | NEEDS CAVEAT | The example is a rate problem (ratios are a grade 6 standard); a 7-year-old won't solve it, which is fine for a puzzle but contradicts "pitched at 7-12". Adult-trapping puzzles also help the Made for Kids read (compliance §A: "math interesting to adults") | Reword: "interesting to adults first; an older kid (roughly 8-12) can try it alongside" |
| 4 | FL | F2 example, beat 1 | Finger trick for 9s works for 9 × 1 through 9 × 10; "9 × 7 on your fingers" | VERIFIED | Code: folding finger n leaves n-1 on the left (tens) and 10-n on the right (ones); 10(n-1) + (10-n) = 9n for n = 1..10, all correct. 9 × 7: 6 \| 3 = 63. No finger 11 or 12, so 9 × 11 and 9 × 12 are out of range (the app's harder levels go to 12) | Keep the range stated on screen. Report Appendix A #47 caveat applies: "party trick, not a substitute for knowing facts". Put that framing in F2's "fun shortcut" rule |
| 5 | FL | F2 beat 3 | "Why it works, in one sentence" | VERIFIED (feasible) | One sentence suffices: "Folding the seventh finger leaves 6 tens and 3 ones, because 9 × 7 is 70 minus 7." Grounded in 9n = 10n - n (#47) | none |
| 6 | FL | F2 beat 4 | "Nobody knows who invented this one" is a fine origin answer | NEEDS CAVEAT | "Nobody knows" is itself a claim. Finger multiplication has a documented history (finger reckoning for 6-10 is centuries old); the research notes don't cover the 9s variant's origin | Script wording: "I couldn't find who came up with it" unless a source shows nobody knows. Goes in the claims list |
| 7 | FL | F2 rules | "Often called Japanese multiplication, though there's no clear evidence it's from Japan" | VERIFIED | Report Appendix B: origin unknown; "call it line or stick multiplication"; do not say "how Japanese kids learn" | Lead with "line multiplication" as the name and mention the Japanese label only to debunk it. Watch for the notes' own hook "The trick Japanese 2nd graders learn that US kids don't" (`algorithms_and_craft.md:80`): it repeats the myth and must never be used |
| 8 | FL | F3 example | "Make a ten": 8 + 5 becomes 8 + 2 + 3 = 13 | VERIFIED | Code: 8 + 5 = 8 + 2 + 3 = 10 + 3 = 13. Common Core 1.OA.C.6 (fetched) lists "making ten (e.g., 8 + 6 = 8 + 2 + 4 = 10 + 4 = 14)" | Show the 10 + 3 step on the math card; the ten is the whole point. Use 1.OA.C.6 as the source for "your kid's homework says make a ten" (first-grade standard in Common Core states) |
| 9 | FL | F3 beat 3 | "Why teachers teach it, at the evidence level the research supports" | NEEDS CAVEAT | The notes support "number bonds, making ten, area model as pictures of the math" via WWC Rec 3 (concrete/semi-concrete representations, Strong, 28 studies). No fetched study tests making ten specifically | Safe line: "It's in the first-grade standards, and pictures of the math like this are well supported." Never "research proves make-a-ten works" |
| 10 | FL | F4 example | Einstein didn't fail math | VERIFIED | Report Appendix B and `math_learning_evidence.md:196` (HIGH): myth traced to a 1935 Ripley's column; a 6 (top grade) in algebra and geometry in his 1896 Aargau report; he failed the non-science sections of the Zurich Polytechnic entrance exam at 16 | The script must include the exam detail, or a skeptical commenter supplies it and it looks like we hid it. Note the Swiss scale (6 is top) on screen, since US viewers read 6 as low |
| 11 | FL | F4 rules | Every claim from the verified trivia bank (Appendix A) or a fresh review | VERIFIED (rule) | Appendix A has 51 items with confidence labels; Einstein is in Appendix B (myths), not A | Say "Appendix A or B" |
| 12 | FL | F4 | "Tallyclaw was there" eyewitness conceit | NEEDS CAVEAT | Brand §4.2 allows it with "the conceit never changes the facts". Compliance §C requires YouTube disclosure for "real people saying things they didn't" and realistic altered events | Add: real historical people appear only in the flat style-bible illustration style, never photoreal, never AI-animated speaking, and are quoted only with documented quotes |
| 13 | FL | F5 example | "Keep math practice short and stop while it's still fun" | NEEDS CAVEAT | No fetched study shows short sessions beat long ones (spacing/retrieval studies are listed as unsourced in the report). Supported nearby: Bedtime Math (a few minutes of fun math talk helped, HIGH-MODERATE) and Maloney 2015 (change how you help, MODERATE) | Present as advice with the Bedtime Math study as support, labeled "in one big study, a few minutes of fun math talk a week helped". Never "short sessions are proven better" |
| 14 | FL | F6 beat 3 | "Here's the game I built where she practices it" | **WRONG when "it" is a strategy**; VERIFIED when "it" is a fact family | See finding 2. Facts like 8 + 5 and 9 × 7 are in range; no strategy is taught | Change the template line to "…where she practices facts like [fact]". Also confirm the fact is in the level shown in the gameplay clip |
| 15 | FL | F6 | "she" (Justin's daughter) practices with the app | NEEDS CAVEAT | Brand §4.1 already uses "I built this for my daughter", and compliance §G bars name, face, voice, school, location, so gender alone is allowed. It's still a factual claim about a real child | Claims list item: must be true when said. Never pair her age or grade with "Alaska" or other locating details across videos |
| 16 | FL | F6 rules | Adaptivity only once the fix has shipped | VERIFIED | Matches brand §5.2 and compliance §B. Fire Trail still never passes the engine (`fire_trail_game.dart:59-70` builds `FireTrailFlameGame` with no `difficultyEngine`) | none |
| 17 | FL | F6 beat 4 | CTA "It's free during the beta. If you want in, it's playmathdragons.com." | VERIFIED | Brand §4.4, content-strategy §6 | none |
| 18 | FL | F7 example | "Why the dragon doesn't time your kid" | **WRONG** (premise) | Finding 3: Dragon Eggs loses on the danger line, Fire Trail moves at speed after a countdown, response time is recorded and used | Replace with a true example; flag it in the idea bank if it was already copied |
| 19 | FL | F7 rules | "Never a child's face, name or voice" | VERIFIED | Compliance §G | Add "school or location" to match §G exactly |
| 20 | FL | F8a | 16:9 horizontal, 60-120 s, destination for every Short's related video, `/yt` in the description's first line | VERIFIED | Vertical/square uploads up to 3 min are Shorts since Oct 15, 2024 (notes craft §1, official); Shorts descriptions don't link since Aug 31, 2023; related video needs advanced feature access (YouTube Help 14075157, prior review) | Mention advanced feature access here too |
| 21 | FL | F8a | "Same-Google-account warning" in the Android flow | VERIFIED | Landing report / brand §4.4 site line; Play closed testing via Google Group requires the same account | none |
| 22 | FL | Shared blocks | Math rendered from code (Manim or Remotion), never by an AI video model | VERIFIED | Report recommendations; brand §7 | none |
| 23 | FL | Shared blocks | Gameplay captured via scrcpy or a scripted integration-test run | VERIFIED | `ai_production_pipeline.md` §5 | Note: integration-test capture on an emulator here needs the JDK 21 workaround (project memory) |
| 24 | FL | Shared blocks | Captions 2-4 words | VERIFIED (practitioner) | `ai_production_pipeline.md:109` (inference) | Label as practice, not data |
| 25 | FL | Format mix | Fortnight mix "lands close to the pillar shares" | **WRONG** | Finding 1 (computed) | See F-1 |
| 26 | FL | Lengths | F3 30-60 s and F5 30-45 s | NEEDS CAVEAT | Content-strategy §5 sets trust content (parent playbook, deeper explainers) at 45-90 s | Align: either F3/F5 move to 45-90 s or strategy §5 says "30-90 s" |
| 27 | FL | F1 part 1 | Length 11-20 s | NEEDS CAVEAT | Its own beats (0-1, 1-8, 8-12, final second) need about 13 s minimum | "13-20 s" |
| 28 | SS | §2 | Visual change every 1-3 s (practitioner consensus; no hard data) | VERIFIED (as labeled) | `algorithms_and_craft.md:125` (OpusClip) | none |
| 29 | SS | §2 | Re-hook about every 10 s in anything over 30 s | VERIFIED (practitioner) | Same source, "on 30-60s pieces" | Add the same "practitioner consensus" label |
| 30 | SS | §2 | No end cards on Shorts | NEEDS CAVEAT | Inference in the notes (replay counting, FB completion), not measured; prior review claim 51. Note: `ai_production_pipeline.md:206` lists "end card" in the Remotion template, which contradicts this | "No outro slate (reasoning, not data)". Fix the pipeline spec when written |
| 31 | SS | §3 | 2.5 spoken words per second (~150 wpm) | UNVERIFIABLE (from research) | No pace figure in the report or notes. 150 wpm is a common conversational/broadcast figure; ElevenLabs pace varies by voice and settings | Label "starting estimate; time the actual TTS render". Tallyclaw's spec is "slow… theatrical pauses", so give him a lower budget (about 2 words/s) |
| 32 | SS | §3 | Budgets 20 s ≈ 50 words, 30 s ≈ 75, 45 s ≈ 110 | VERIFIED (arithmetic) | 20 × 2.5 = 50; 30 × 2.5 = 75; 45 × 2.5 = 112.5 | Budgets assume continuous VO. Subtract silent beats (F1's thinking beat) and gameplay-only stretches |
| 33 | SS | §3 | Reading level 5th-7th grade | NEEDS CAVEAT | Brand §7 cites Unbounce 2024 landing-page data; nothing on VO | Fine as a house rule; label it |
| 34 | SS | §3 | On-screen numbers as digits ("7 × 8 = 56") | VERIFIED | Brand §7 | Brand §7 writes "7 x 8 = 56" (letter x). Pick one: the true sign × (U+00D7) is correct, so update the brand example, and make sure the caption font has the glyph |
| 35 | SS | §4 | Captions burned in, 2-4 words, "matching the VO exactly" | NEEDS CAVEAT | Conflicts with §3 (digits on screen): exact captions would show "seven times eight" next to a math card reading "7 × 8 = 56" | "Matching the VO word for word, with numbers shown as digits" |
| 36 | SS | §4 | Text callouts at most about 7 words, held long enough to read twice | UNVERIFIABLE | Not in the research | Label as house rule |
| 37 | SS | §4 | Safe zone: keep text out of the bottom fifth and the right edge | NEEDS CAVEAT (too small) | Notes give "bottom ~20% and right-side UI" as an inference with no primary source (`ai_production_pipeline.md:109`). Widely cited Meta Reels ad margins are about 14% top, 35% bottom, 6% sides (community-reported; Meta's own help text reportedly gives no general organic figure; search 2026-10-26: [adnova](https://adnova.ai/blogs/meta-ad-safe-zones-guide), [Inro](https://www.inro.social/tools/instagram-reels-safe-zone-checker), [Billo](https://billo.app/blog/meta-ads-safe-zones)). Reels captions and Shorts titles both sit in the lower third | Interim rule: keep text out of the top ~14%, bottom ~35% and right ~10%, then verify with a test upload on both apps before `visual-style.md` locks it |
| 38 | SS | §5 | HIGH state plainly; MODERATE "researchers think", "often called"; LOW "legend says" or skip | VERIFIED | Report recommendations table, Appendix A header | none |
| 39 | SS | §5 | Adaptivity claim may appear in a script, published only after the fix ships | VERIFIED | Brand §5.2, compliance §B | none |
| 40 | SS | §6 | At most one CTA, after the payoff; value videos usually none; spoken URL plain | VERIFIED | Brand §7, content-strategy §6, compliance §H | Add "spoken and on screen" (brand §7) and "the Narrator delivers it, never Tallyclaw" (brand §4.3) |
| 41 | SS | §7 | YouTube title 40-65 characters, payload in first 40 | UNVERIFIABLE | Not in the research. YouTube's limit is 100 characters; truncation varies by surface | Label as a house heuristic and check how the title renders on a phone in the Shorts player before locking |
| 42 | SS | §7 | Shorts descriptions don't link | VERIFIED | Aug 31, 2023 change (`cta_and_funnel.md` §1; prior review 43) | none |
| 43 | SS | §7 | 3-5 parent/teacher/homeschool hashtags | NEEDS CAVEAT | No count in the research. YouTube Help 6390658: more than 60 hashtags and all are ignored ([search](https://support.google.com/youtube/answer/6390658)); no official 3-5 rule. Parent tags per `policy_and_compliance.md:123` | Label as house rule. Keep the tag-direction rule (compliance §A), which is the part that matters |
| 44 | SS | §7 | Facebook caption: no link; first comment carries `playmathdragons.com/fb###` | VERIFIED | Caption links are plain text without Meta One; comment links are clickable and were exempt from the link-cap test (`cta_and_funnel.md` §2). Per-video paths only on Facebook (compliance §H) | "Protects reach" is unproven; the guide doesn't claim it, good |
| 45 | SS | §9 | Compliance §A-H at script gate | VERIFIED | Matches compliance line 16 | none |
| 46 | FL/SS | Prose | Zero em-dashes; at most one X/Y reframe | NEEDS CAVEAT (FL) | Both files: 0 em-dashes. FL has three "X, not Y" constructions: "skeletons, not fill-in-the-blank templates" (l.12), "targets, not rules" (l.14), "Branding on every video, not a CTA" (l.27, a shared definition). SS: none | Rephrase l.12 or l.14 in FL ("Formats are skeletons; each video still needs its own concept…"; "Timings are targets.") |

---

## Sense-read issues

### Blocking

**F-1. Make the fortnight add up.** At 3 a week, the 35/25/20/20 shares need about 2.1 / 1.5 / 1.2 / 1.2 slots per fortnight, which a 6-slot fortnight can't hit exactly. Options:
- (a) Plan in 4-week blocks of 12: Dragon Puzzle ×4 (P1), Tricks ×1 (P1), Homework Decoder ×1 (P2), Parent Playbook ×2 (P2), Tallyclaw Was There ×2 (P3), Gameplay Payoff or Dad Dev Diary ×2 (P4). That gives 42 / 25 / 17 / 17%. Pillar 1 stays high because the puzzle series alone is 33%.
- (b) Accept the drift and update content-strategy §3 and §7 to the numbers the format mix actually produces, including the 5:1 promo ratio and the later pillar 3/4 judging date.
- (c) Put the puzzle answer at the end of the same video (the loop reveal both strategy §5 and the research prefer) on alternate puzzles, which frees slots.

Whichever Justin picks, state where F8b (the "How to join" Short) slots in, and which slots carry Tallyclaw so he reaches ~1 in 3 (e.g. F4 always, plus his button line in F1 part 2 counts as a cameo, plus one F6). Otherwise either the brand guide's "one in three" or the format mix has to change.

**F-2. F6 app-claim wording.** Change the template line (see claim 14). Add to F6 rules: "The gameplay shown must contain the fact type taught; say 'facts like…', never 'practices the trick'." Content-strategy §3 pillar 4 ("the making-ten trick, then the game that drills it") carries the same risk; flag it there too.

**F-3. F7 example.** Remove "Why the dragon doesn't time your kid", or replace it with a true design decision. If Justin wants that message, it needs an app change first.

**F-4. Puzzle part 1 to part 2.** Pick a route and write it into F1:
- Add part 1 and part 2 to the Dragon Puzzle playlist (the playlist label appears in the Shorts player).
- Once part 2 is live, either switch part 1's related video to part 2 (costs the beta link on that Short) or keep the walkthrough and pin a comment "Answer: the next Dragon Puzzle on the channel" (text only, not clickable).
- On Facebook, add a Page comment on part 1 with the part 2 link once it posts.
- Part 2 must stand alone for viewers who never saw part 1 (its beat 1 restating the puzzle already does this).

**S-1. Label the heuristics.** One line in script-standards near the top: "Numbers marked (house rule) are our starting heuristics, not platform data; the metrics review can change them." Apply it to pace, word budgets, callout length, title length, hashtag count and the reading level. Replace the safe zone with the larger interim figure (claim 37).

**S-2. Captions vs digits.** Claim 35.

### Should fix

**S-3. Made for Kids read on F1.** F1 is the format most likely to be classified as kid-directed: a dragon-themed puzzle, a silent thinking beat that works like a "can you solve it" pause, and a loop. "Try this with your kid" is correct (brand §6.2), but it's only on screen. Add: the first spoken line also addresses the parent ("Here's one to try with your kid at dinner"), the thinking beat carries no countdown aimed at a child, and the puzzle should be one adults get wrong (the CRT example is good for this reason).

**S-4. Hands-only footage.** Add for privacy: no rings, tattoos, or distinctive watches; nothing identifying in frame (mail, a school worksheet, a kid's drawing with a name, a window view). Overhead phone footage of a kitchen table leaks more than people expect.

**S-5. Recreated worksheets (F3).** "Recreated in our own style" solves the child-privacy problem. It doesn't solve copyright if the recreation copies a specific publisher's page (Eureka Math, Bridges, etc.). Add: generic phrasing and our own layout; never a publisher's name, logo or page design; quote at most the instruction phrase ("make a ten").

**S-6. Hook testing.** §1 "or we test both over time" must mean using the other hook on a future video. Re-uploading the same video with a new hook is the reposting pattern YouTube's Oct 2026 update and Meta's originality rules penalize (compliance §F).

**S-7. F6 timing.** Beats 1-2 give 13 seconds to deliver a complete lesson, while the same lesson in F2 takes 28. In practice F6 lessons need to be one-fact sized ("8 + 5: borrow 2 to make 10"), or F6 runs 35-45 s. Say which.

**S-8. Tallyclaw dependency.** F4 needs the rigged puppet, Rhubarb lip-sync and a locked ElevenLabs voice (brand §12 open items). Until those exist, every pillar 3 slot is blocked. Either schedule the puppet before the first F4, or allow an interim F4 variant (still illustration, Tallyclaw voice only, or the Narrator telling a "Tallyclaw says" story).

**S-9. "Soft CTA" in F7** isn't defined anywhere. Use the standard line or none.

**S-10. Treatment template gaps.** Add fields the upload gate needs, so they're decided at script time: YouTube audience setting rationale (compliance §A), AI-disclosure flags for YouTube and Facebook (§C), playlist, related video, cover frame, and the Facebook genuine question if any.

### Missing coverage

- **Cover frame / thumbnail.** Shorts and Reels both show a cover in the channel grid and on Facebook; custom Shorts thumbnails were reportedly added in July 2026 (3P changelog, unverified, `algorithms_and_craft.md:22`). Add to script-standards §7: pick a cover frame showing the hook text and the puzzle or result, adult-addressed, with no kid-directed styling (thumbnails count toward MFK and toward YouTube's misleading-thumbnail rule, compliance §D).
- **Music and SFX.** Neither guide says how audio sits in the mix. The notes give practice figures: music ducked about -18 to -24 dB under VO, final loudness around -14 LUFS, game SFX as a signature sound (`ai_production_pipeline.md:86, 148-149`; `algorithms_and_craft.md:123`). Put these in the production spec when written; for now add one line to script-standards ("music under the voice; game SFX on reveals; source per compliance §E").
- **Caption accessibility.** Add: high contrast with an outline or box, large type, never color as the only signal (e.g. red/green for right/wrong), and no flashing faster than 3 times a second (WCAG 2.3.1), which matters given the 1-3 s cut rate and spell-particle effects. Burned-in captions help muted viewers but screen readers can't read them; upload a caption file on YouTube as well, and check Facebook's auto-captions against the script.
- **Silent beats and the cut-rate rule.** F1's thinking beat and F2's slow demo look like they violate "visual change every 1-3 s". Say that slow, deliberate beats are allowed when something on screen is moving (a countdown ring, a hand), so reviewers don't flag them.

### Things checked and found sound

- All on-screen math examples are correct (dragon puzzle, 9s trick 1-10 and its limit at 10, make-a-ten 8 + 5, 9 × 7).
- Einstein and the "Japanese multiplication" origin wording match the research's HIGH and unknown-origin labels.
- Platform facts (Shorts description links, the 3-minute Shorts rule and F8a landscape, related video, Facebook first-comment links, per-video `/fb###` paths) match the notes and the prior review's fixes.
- CTA rules, adaptivity gating, perk wording, no-kids-on-screen and comment rules are consistent with the brand guide and compliance checklist.
- Hook rules (content on frame one, stacked signals, adult address) match the report.
- Script-standards has zero em-dashes and no X/Y reframes. Format-library has zero em-dashes.

---

Em-dash count in this review: 0. "X, not Y" reframes in this review's own prose: 0 (the three in claim 46 are quoted from the guide).
