# MD-014: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (cut the perk sentence, or at minimum fix its on-screen paraphrase; correct the code citations; Justin still picks the final origin wording)

App claims checked against the installable build 1.0.3 (8) = `28d6638` (`docs/RELEASES.md`), extracted with `git archive 28d6638`. `main` differs from it in 13 `lib/` files (adaptive Phase 1, 1.0.4 (9), not released), including `fire_trail_flame_game.dart`. The optional C1 line is verbatim §2.1 and correctly gated: 1.0.4 (9) isn't in `RELEASES.md`, so it can't be published yet.

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "my daughter was struggling with math facts" | OK (author's story) | Justin-confirmed origin line (`marketing/website/LAUNCH-CHECKLIST.md:32`) | None. "my daughter" only, no name (§G) |
| 2 | "Every math app we tried was a worksheet with a costume on. The math was the chore you did to get back to the fun." | OK (author's experience) | §5.6 approved line 1, verbatim; scoped to "we tried", no app named or implied | None |
| 3 | "A real game has risk" (Dragon Eggs, eggs near the danger line) | VERIFIED (build 8) | Dragon Eggs: `_checkGameOver()` ends the game when an active egg reaches the danger line, `dragon_eggs_flame_game.dart:324-334` (cited lines match build 8). Fire Trail: the flame loses 20% per wrong answer (`flame_intensity.dart` `onWrongAnswer`) and the game ends at zero; self-collision also ends it | **Citation fix:** the treatment's Fire Trail lines (`:171-175`, `:244-257`) are `main`'s line numbers. In build 8 they are `fire_trail_flame_game.dart:161-169` (wall hit, no-wrap levels only) and `:232-247` (wrong answer, flame out). Behavior is the same in both |
| 4 | "a clock you're racing" (Fire Trail, dragon at speed) | VERIFIED as a description; NOTE on wording | There is no per-question timer in build 8. Fire Trail's "countdown" (`countdown_overlay.dart`, `GamePhase.countdown`) is the 3-2-1 before play starts. The real clocks are: the dragon never stops moving, at a per-level speed (`fire_trail_config.dart:34-46` `speedForLevel`, used as `stepsPerSecond`), and Dragon Eggs spawns eggs on a timer, twice as fast during a wrong-answer penalty (`egg_spawner.dart:47`), falling under gravity (`egg_physics.dart:35`). "A clock you're racing" is fair for both | None to the script. Note for Justin: `format-library.md` F7 cites "Fire Trail's countdown" as a timed-answer mechanic; it's a start countdown, so that guide line overstates slightly (guide change, Justin's call) |
| 5 | "a reward that feels earned" (scales counter, evolution) | VERIFIED (mechanics); opinion ("feels") | Scales per correct answer (`reward_service.dart:88-90`) and per level, plus a 3-star bonus (`:104-109`); the scales counter is in the in-game HUD (`games/shared/game_shell.dart:197-217`); evolution stages 0-5 (`progression_manager.dart:19`, `:51-70`) | Production: confirm an evolution is reachable on a fresh test profile in reasonable time, or show the counter only. Don't fake an evolution |
| 6 | "A worksheet only has the reward at the end." | OK (opinion) | §5.6 line 2 | None |
| 7 | "So I built games where solving the problem is the fun part." | OK (design statement) | In each game you answer through the action (registration descriptions in build 8: "Hatch dragon eggs with math equations", "Blaze a trail of correct answers", "Connect ancient runes to cast spells", "Feast on the right numbers"); §5.3 #2 | None. The treatment correctly dropped "every move a real math problem" (idea-bank.review I-119) |
| 8 | "Four dragon games." / on-screen "4 games" | VERIFIED | `lib/app.dart:108-111` registers four games in build 8 | None |
| 9 | "No ads." | VERIFIED | `ad_manager.dart` is a TODO stub; no ad SDK in `pubspec.yaml` | None |
| 10 | "No accounts." | VERIFIED | No auth packages; `home:` is `HubScreen` | None |
| 11 | "The app collects no data." | VERIFIED | No network/analytics packages; no INTERNET permission in the release manifest | None |
| 12 | "It's free during the beta." | VERIFIED | §5.2, §5.4 | None |
| 13 | "Everyone in the beta gets the full unlock free when Math Dragons launches." (VO) | Wording exact (§5.4); **delivery not ready** | See "Perk question" below | **Recommended: cut it from this video** |
| 14 | On-screen "Full unlock free at launch" | **FAILS §5.4 / compliance §B** | §5.4: the perk is used "in exactly these words". The callout drops "Everyone in the beta", so on its own it reads as "the full unlock is free at launch" for anyone, which is false | If the perk stays, the on-screen text must be the exact sentence (13 words, so it can't be a ≤7-word callout; it needs a text card as in MD-001/MD-002). Cutting the perk removes the problem |
| 15 | URL `playmathdragons.com` | VERIFIED | `website/src/config/site.ts` | None |
| 16 | Hook B "every math app we tried was a worksheet with a costume on" | OK | As 2 | None |
| 17 | Description, caption | VERIFIED | As 2, 7-11 | None |

Claims list: complete, except row 14 (the on-screen perk paraphrase isn't listed as its own claim; it should be).

### The perk question

**Recommendation: leave the perk sentence out of MD-014.** Reasons:
1. **The I14 condition isn't met yet.** `pages-v1.review.md` I14 said not to use the sentence in more places "until the delivery path is built". What exists now is the *record*, not the delivery path. `FoundingTester.record()` runs on every launch in build 8 (`lib/main.dart:26`) and stores a flag on the device only (cutoff placeholder 2099-01-01). The delivery (the store-native unlock at paid launch: StoreKit `AppTransaction` grandfathering, Apple offer codes, Play promo codes) isn't built, and the App Store 3.1.1 pre-check is still open (`marketing/PLAN.md:73`). The flag is also lost on clear-data or uninstall without a backup restore, or on a new device without a restore, while the sentence says "everyone". The flag makes the promise *more* keepable than it was at I14, but it doesn't close I14.
2. **Viewers already meet it where it belongs.** The perk is on the website and in MD-001 and MD-002, and every Short's related video is MD-001. Leaving it out of MD-014 costs almost nothing in conversion and keeps the promise in three places instead of four, on Facebook Reels that can't be unlisted (protocol §5).
3. **It breaks the CTA rule.** content-strategy §6: one CTA "in the last 2-5 seconds". With the perk the CTA runs 35-43 s (8 s), and its on-screen paraphrase fails §5.4 (row 14).
4. **Nothing requires it.** script-standards §5: "The perk, *if* mentioned, uses the exact sentence." The treatment's "required when the beta is mentioned" isn't in any guide.

Without it the VO is 92 words (≈37 s at 2.5 words/s), and the CTA is the standard "It's free during the beta. If you want in, it's playmathdragons.com." Revisit once the paid-launch unlock path is built and the 3.1.1 check is closed.

### Origin wording (for Justin's choice)

- **Default (as in the treatment):** passes. It uses §5.6 lines 1 and 2 almost verbatim, minus line 2's "with every move a real math problem" (an overstatement; idea-bank.review I-119).
- **Candidate 3 as approved in §5.6** ("I wanted the pull of the games kids can't put down, …"): fails §6.2's "addictive, kids can't put it down". This is the rule's intent, not a technicality (see summary). Minimal fix keeping Justin's meaning: **"I wanted the pull of the games kids love, pointed at something good: a real math workout that feels like playing."** (only "can't put down" → "love"). The treatment's alternative ("the pull of a great phone game … real math practice …") also passes, but changes more words than needed.
- The source notes' "addicting", "hooked" and "brain chemistry" language stays out of every version. Correct.

Math recomputed: `4 games` = 4 registrations (`lib/app.dart:108-111`, build 8). No other strings; check every equation visible in captured gameplay at the render gate. Word count recomputed: 105 (claimed 105), 2.44 words/s over 43 s, budget 107; 92 without the perk. Title "Why I Built a Math Game Where Solving Is the Fun Part" = 53 chars.

Sense read:
- **Skeptical parent:** the story is believable and specific, and the app facts are plain. Two things would bother me: an "every app we tried" line could feel like a dig (it's scoped to "we tried" and names nothing; OK), and an on-screen "Full unlock free at launch" that sounds like a sales line (row 14).
- **Teacher:** "solving is the fun part" is a design claim, not an outcome claim. No learning promise is made. OK.
- "A real game has risk" over Dragon Eggs stacking toward the danger line: true, and the visual shows it. Pick a Fire Trail clip where the speed is visible (a mid-world level), since the "clock" in Fire Trail is the dragon's pace, not a timer.

Compliance (§A-H):
- A: PASS. "Parents," first word; a parent's decision story; gameplay as a demo.
- B: app claims are §5.2 and true in build 8; no adaptivity claim in the default; no outcome claims; privacy scoped. **Perk: on-screen paraphrase fails (row 14); recommended cut.**
- C: YouTube no; Facebook yes. PASS.
- D: caption question "What makes a learning game feel like a real game to your kid?" is genuine. PASS.
- E: game's own music/SFX. PASS.
- F: own footage; no code walls; no Dragon Runes world names; no store placeholder. PASS.
- G: "my daughter" only; no "Alaska". PASS.
- H: one CTA after the payoff; spoken URL plain; `/fb014` first comment. Length of the CTA fails the 2-5 s guide with the perk, passes without it.

Voice (§11): Narrator first person, adult address, zero em-dashes, zero X/Y reframes; no "addictive", "hooked" or "dopamine". PASS (default script).

Justin sign-off (including the final origin wording and the perk decision):

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
