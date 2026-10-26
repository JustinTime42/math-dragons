---
review_of:
  - marketing/guides/visual-style.md (draft 2026-10-26)
  - marketing/guides/production-pipeline.md (draft 2026-10-26)
  - marketing/guides/metrics-and-learning.md (draft 2026-10-26)
  - marketing/guides/fact-check-protocol.md (draft 2026-10-26)
reviewer: independent accuracy-and-sense reviewer (fresh agent, no authoring context)
date: 2026-10-26
method: marketing/README.md "Accuracy and sense review". Claims checked against app code and assets, the approved guides and earlier *.review.md files, both research reports and notes, and primary sources fetched today. Geometry and contrast computed in Python. The guides were not edited.
---

# Review: the final four guides

## Verdicts

| Guide | Verdict | Must-fix items |
|---|---|---|
| `visual-style.md` | **PASS WITH FIXES** | V-1 Tallyclaw "lower third" sits outside the safe area; V-2 the 85% gameplay rule can't fit the safe area; V-3 "all three fonts" lists two; V-4 right-side margin probably too thin |
| `production-pipeline.md` | **FAIL** (fixable) | P-1 DaVinci Resolve free on Linux can't import or export H.264/AAC, so Phase A breaks at steps 5, 6, 8 and 10 as written; P-2 no workable Phase A caption path (word highlight, timestamps into Resolve); P-3 the game soundtrack's provenance is undocumented, so "owned" is unproven; P-4 ElevenLabs Music's individual plans are "For Individual Use Only" while the app is published by an LLC |
| `metrics-and-learning.md` | **PASS WITH FIXES** | M-1 Play Console doesn't show per-tester 14-day counts; M-2 the 12-tester gate may not apply (docs say the Play account is an Organization); M-3 Umami "has to be added" vs open decision 2; M-4 redirect paths are invisible to client-side analytics unless built carefully |
| `fact-check-protocol.md` | **PASS WITH FIXES** | F-1 "or Justin for small videos" at the render gate contradicts the README's mandatory independent review; F-2 no rule for which build "testers can install today" maps to (no git tags exist); F-3 render-gate checks are underspecified |

The production guide gets FAIL because the first video would hit P-1 on day one: footage from scrcpy and the phone camera wouldn't import, and the specified export can't be produced from Resolve free on Linux. The fix is a rewrite of §3 steps 5-10 (sketched under P-1), so it doesn't need a full redraft.

## Claims table

Docs: VS = visual-style, PP = production-pipeline, ML = metrics-and-learning, FC = fact-check-protocol.

| # | Doc | Section | Claim | Verdict | Evidence | Fix |
|---|---|---|---|---|---|---|
| 1 | VS | 3 | Hex values for Deep Void, Dragon Purple, Midnight Blue, Text Primary, Dragon Gold, Warm Glow, Emerald Flame, Fire Orange | VERIFIED | `lib/theme/dragon_colors.dart`: 0xFF1A0F3D, 0xFF2D1B69, 0xFF1A1A2E, 0xFFF0E6D3, 0xFFF4A261, 0xFFF7C08A, 0xFF2A9D8F, 0xFFE76F51. `correct = emeraldFlame`, `incorrect = fireOrange` | none |
| 2 | VS | 3 | Each game has its own accent color | VERIFIED | `dragon_colors.dart` runes/fireTrail/dragonEggs/dragonsFeast accents | Optional: list the four hexes so editors don't guess |
| 3 | VS | 4 | Operators and equals sign in gold, numbers cream, math in Nunito Bold, "as in the app" | VERIFIED | `docs/VISUAL_DESIGN_GUIDE.md:167-181` | none |
| 4 | VS | 4 | "All three fonts are already in assets/fonts/ (Cinzel and Nunito are free, SIL OFL)" | NEEDS CAVEAT | `assets/fonts/` holds Cinzel, Nunito **and JetBrains Mono**; the table lists only two families. Cinzel, Nunito and JetBrains Mono are all OFL 1.1 (Google Fonts / JetBrains). The OFL text itself isn't bundled in `assets/fonts/` (an app-repo hygiene item; rendering glyphs into video is permitted) | Say "Cinzel and Nunito (both in `assets/fonts/`, SIL OFL)", or add a JetBrains Mono row (scores, counters) to match the design guide |
| 5 | VS | 4, 6 | Nunito can set the math | VERIFIED | `fc-query` on `Nunito-Bold.ttf`: × (U+00D7), ÷ (U+00F7), − (U+2212), ≠ (U+2260), ½ all present | Add: use U+2212 for minus and U+00D7 for times in math strings, never hyphen or letter x |
| 6 | VS | 2 | Top 14%, bottom 35%, 6% sides; "commonly cited, derived from Meta's ad specs, not an official organic number" | VERIFIED (as labeled) | Third-party Meta-ad safe-zone tools agree on 14/35/6 (adnova, socialync, revid); Meta's own page wasn't retrievable; one tool widens the right side to 120 px, another to 15% for the button column | Keep the label. See V-4 on the right margin |
| 7 | VS | 2 | Safe rectangle about x 65-1015, y 270-1250 on 1080 × 1920 | VERIFIED | Computed: 0.06 × 1080 = 64.8; 1080 − 64.8 = 1015.2; 0.14 × 1920 = 268.8; 0.65 × 1920 = 1248 | Optional: write y 269-1248 |
| 8 | VS | 5 | Captions at 55-65% of frame height | VERIFIED (geometry) | y 1056-1248, inside the safe rectangle, touching its bottom edge | Note that this band is shared with Tallyclaw and math cards (V-1) |
| 9 | VS | 5 | Cream caption with dark outline reaches 4.5:1 | VERIFIED | Computed WCAG ratios: cream on Deep Void 14.4, on Dragon Purple 11.5, on Midnight Blue 13.8. Gold on those 6.9-8.6 | none |
| 10 | VS | 5 | Current word highlighted in gold | NEEDS CAVEAT | Gold vs cream is only 1.67:1, so the highlight works by hue alone and is weak for some color-vision types. Fine as an enhancement, since the word is still readable | Add a second cue (slight scale-up or underline) or accept it as decoration only |
| 11 | VS | 6 | Correct answers glow emerald | NEEDS CAVEAT | Emerald on Dragon Purple is 4.29:1, under 4.5 for normal text; it passes the 3:1 large-text bar at 120-160 px. Earlier review asked for "never color as the only signal" | Add a check mark or "✓" beside correct answers (wrong answers already get a cross-out) |
| 12 | VS | 5 | No flashing more than 3 times a second (WCAG 2.3.1) | VERIFIED | WCAG 2.3.1 Three Flashes or Below Threshold (w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold) | Add: applies to gameplay particle effects and rapid bright/dark cuts too; check spell and egg-pop effects in captured footage |
| 13 | VS | 7 | "The app runs in portrait" | VERIFIED | `lib/main.dart:10-13` locks portraitUp/portraitDown. (`ios/Runner/Info.plist` still lists landscape, but the Dart lock wins at runtime) | none |
| 14 | VS | 7 | "A capture fills a 9:16 frame naturally" | NEEDS CAVEAT | Modern phones are about 19.5:9 (research note `ai_production_pipeline.md` §5), taller than 9:16, so a full capture needs a crop or pillarbox | Say "close to 9:16; expect a small top/bottom crop or side bars" |
| 15 | VS | 7 | Scale gameplay to about 85% and center it inside the safe area | WRONG (geometry) | 85% of 1080 × 1920 is 918 × 1632; the safe rectangle is 950 × 979. It would need about 51% scale to fit by height | See V-2 |
| 16 | VS | 8 | Nine Rhubarb mouth shapes, A-H plus X | VERIFIED | Rhubarb README: basic A-F, extended G, H, X (extended are optional, chosen with `--extendedShapes`) | Add: "G, H and X are optional in Rhubarb; draw all nine anyway" |
| 17 | VS | 8, 13 | Style-bible variants amethyst, verdant, stone, tidal, ember; anchor at `approved/01_style_anchor.png` | VERIFIED | `assets/style_bible/approved/01-11` | none |
| 18 | VS | 1 | 60 fps allowed for gameplay-heavy videos | NEEDS CAVEAT | Conflicts with PP §3.10 ("30 fps" only). YouTube recommends 12 Mbps for 1080p60 vs 8 Mbps at 30 | Make PP's export say "30 fps (or 60 fps when the timeline is 60)" |
| 19 | PP | 2 | Instant cloning needs a short sample; professional needs much more audio and a higher plan | VERIFIED | ElevenLabs docs: IVC about 1-2 min; PVC 30 min minimum, 2-3 h optimal, Creator or above, voice verification required, own voice only | Put the numbers in: "IVC: 1-2 min; PVC: 30+ min, Creator plan" |
| 20 | PP | 2 | Commercial use requires Starter or above | VERIFIED, with caveat | elevenlabs.io/pricing: commercial license from Starter; Free has none. Output made while subscribed stays usable (secondary) | See P-4 for the LLC question |
| 21 | PP | 2 | YouTube exempts your own cloned voice; Facebook needs the AI label | VERIFIED | Consistent with approved `compliance-checklist.md` §C and its review | none |
| 22 | PP | 3.3, 4 | "Word timestamps (ElevenLabs' timestamp output)" | NEEDS CAVEAT | The `/with-timestamps` endpoint returns **character-level** `alignment` (`character_start_times_seconds`), not words. Timestamps also go stale once takes are trimmed or reordered in the edit | Say "character timestamps, grouped into words by script"; for Phase A, align the final edited VO stem instead (P-2) |
| 23 | PP | 3.4 | Manim (Python) for math cards | VERIFIED | Manim Community LICENSE: MIT | Add setup: install Nunito to `~/.local/share/fonts` so Manim's `Text(font="Nunito")` finds it; render with `--transparent` (ProRes 4444 .mov), which also avoids the H.264 import problem |
| 24 | PP | 3.5 | `scrcpy --record` avoids the on-device 3-minute limit | VERIFIED | `adb screenrecord` 3-min cap (Google Issue Tracker 198237873, via notes); scrcpy records on the PC | Add: audio capture needs Android 11+ (screen unlocked at start on 11); default audio is Opus; scrcpy isn't installed on this machine yet |
| 25 | PP | 3.8 | DaVinci Resolve "free, runs natively on Linux" | NEEDS CAVEAT | Blackmagic officially supports only Rocky/RHEL with NVIDIA; Fedora 44 is community-supported (this machine has an RTX 3060 Ti on the proprietary driver, which helps). Free version: up to 60 fps UHD, 8-bit, no AI tools (Blackmagic compare page) | Say "free; Linux build is officially Rocky-only, runs on Fedora with community steps (or in a Rocky container)" |
| 26 | PP | 3.5, 3.6, 3.8 | Gameplay and phone footage go into Resolve | WRONG (on this OS) | Resolve free on Linux has no H.264/H.265 decode or encode and no AAC (tal.org Resolve 20 guide, 2025; NixOS wiki; Blackmagic forum). scrcpy (H.264 + Opus), phone cameras (H.264/HEVC + AAC) and Manim's default MP4 are all affected | See P-1 |
| 27 | PP | 3.10 | Export H.264 MP4, AAC 48 kHz, from the Resolve timeline | WRONG (on this OS) | Same sources: no H.264/AAC export in Resolve free on Linux | Export DNxHR HQ + PCM from Resolve, then encode with ffmpeg (this machine's ffmpeg has `libx264`, `h264_nvenc`, `aac`, `libfdk_aac`) |
| 28 | PP | 3.10 | 1080 × 1920, 30 fps, 16-20 Mbps, AAC 48 kHz stereo | VERIFIED, with caveat | YouTube help 1722171: H.264 High, MP4 with moov at front, 48 kHz AAC-LC, 8 Mbps recommended for 1080p30 SDR, "no bitrate limit". Facebook: 1080 × 1920, H.264/AAC 48 kHz commonly cited (third-party; Meta page not retrieved). 16-20 Mbps is above the recommendation and allowed | Add `-pix_fmt yuv420p -movflags +faststart` and BT.709 tags; note 16-20 Mbps is headroom, not a platform requirement |
| 29 | PP | 3.9 | About -14 LUFS integrated is a common social target | NEEDS CAVEAT | Third-party consensus for YouTube (approx. -14 LUFS, YouTube turns loud audio down, not quiet audio up); Meta figures conflict (-13 to -14) and none are official | Add "-1 dBTP true peak" and measure with ffmpeg `loudnorm` (two-pass) or Resolve's Fairlight loudness meter |
| 30 | PP | 3 end | 45-90 min per video once templated | VERIFIED (as labeled) | `ai_production_pipeline.md` §8 inference | none |
| 31 | PP | 4 | Remotion free for individuals and companies up to 3 people | VERIFIED | Remotion LICENSE.md: free for "an individual" or "a for-profit organization with up to 3 employees"; "In Remotion 5.0, the license will slightly change" | Add "re-check at Remotion 5" |
| 32 | PP | 4, 6 | Rhubarb turns VO into mouth timings | VERIFIED | Rhubarb README/LICENSE: MIT; input must be WAV or Ogg Vorbis; `-d dialog.txt` improves recognition | Add: convert ElevenLabs MP3 to WAV first and always pass the script line with `-d` (a gravelly voice will hurt recognition) |
| 33 | PP | 4 | Scripted capture with a Flutter integration test and a fixed seed | NEEDS CAVEAT | The games use unseeded `Random()` (e.g. `egg_spawner.dart:18`, `dragon_runes_flame_game.dart:52`); only `daily_challenge_manager.dart` seeds. Only `integration_test/app_launch_test.dart` exists | Mark as needing an app-side change (injectable seed), owned by app work, not marketing |
| 34 | PP | 7 | Sora API shut down 2026-09-24 | VERIFIED (secondary) | OpenAI deprecation notice of 2026-03-24 per research and multiple outlets today; OpenAI's page not retrieved | none |
| 35 | PP | 7 | Veo output carries SynthID | VERIFIED | Google DeepMind SynthID page (via notes) | none |
| 36 | PP | 7 | YouTube may auto-label AI content it detects | VERIFIED | YouTube Help 14328491 (via notes): GenAI tools, C2PA, or "content its systems detect"; May 2026 coverage says Shorts labels now overlay the video | none |
| 37 | PP | 8 | Game soundtrack "owned" | UNVERIFIABLE | No provenance record. `docs/step12/MASTER_IMPLEMENTATION_PLAN.md:77,385` planned Suno Pro; the `generate-music` skill calls an unofficial Suno reseller API (`apibox.erweima.ai`). The six loops in `assets/audio/music/` are each exactly 22.0 s, and the `.ogg` files are actually MP3 | See P-3 |
| 38 | PP | 8 | ElevenLabs Music on a plan whose terms allow social video | VERIFIED, with caveat | ElevenLabs Music Model-Specific Terms (updated 2026-05-26): "All online and offline commercial use permitted, except film, TV, radio, and Studio Games" from Free up; **Free/Starter/Creator/Pro "For Individual Use Only"**, Scale for entities under 10 employees; streaming distribution barred on Free/Starter | See P-4 |
| 39 | PP | 8 | Never register AI music with Content ID | VERIFIED (as policy) | YouTube Help 1311402: Content ID requires exclusive rights; non-exclusively licensed music is ineligible | none |
| 40 | PP | 9 | DaVinci Resolve, Manim, Remotion, Rhubarb, scrcpy free | VERIFIED | Licenses above; scrcpy Apache-2.0 | none |
| 41 | ML | 1 | Viewed vs swiped away ("how many chose to view") is the Studio hook metric | VERIFIED (official via secondary) | `algorithms_and_craft.md:15` quoting YouTube Help; some guides call the viewed side "Stayed to watch" | Add "(label may read 'Stayed to watch')" |
| 42 | ML | 1 | Since March 31, 2025 a Shorts view counts every start or replay; engaged views kept | VERIFIED | TechCrunch 2025-03-26 (official via secondary); engaged views in Advanced mode | Add: since Aug 24, 2026 the same applies to long-form, so judge the F8a walkthrough on engaged views too |
| 43 | ML | 1 | Facebook metrics: average watch time, shares per reach, reach from non-followers, follows | NEEDS CAVEAT | Third-party reports of a Feb 2026 Meta notice replacing "reach" with "viewers" and "watch time" with "minutes viewed"; Meta's own help page not retrieved | Log whatever label the dashboard shows, note label changes in the CSV, and don't compare across a rename |
| 44 | ML | 1 | Android testers opted in from Play Console; "track the 14-day clock" | NEEDS CAVEAT | Play Help 14151465: the 12-tester / 14-day rule is stated for **personal accounts created after 2023-11-13**. `docs/GOOGLE_PLAY_PUBLISHING.md:27` says register as an Organization (LLC). Earlier review (compliance-and-strategy #39) already asked to confirm the account type; still open | See M-2 |
| 45 | ML | 3.1 | "Is anyone's 14-day count at risk?" | UNVERIFIABLE (likely unworkable) | Play Console shows aggregate opted-in counts on the production-access checklist (third-party guides); no source shows per-tester opt-in dates | See M-1 |
| 46 | ML | 1 | TestFlight: invites accepted, installs, sessions | VERIFIED, with caveat | App Store Connect Help: public-link metrics show viewed and accepted; builds show Installs, Sessions (last 7 days), Crashes, Feedback; public-link testers are **anonymous** and missing from CSV exports | Say "public-link views and accepts; per-build installs and 7-day sessions" |
| 47 | ML | 1 | The site has no analytics yet | VERIFIED | `website/README.md:5`, `src/pages/privacy.astro:109` ("no ads, no analytics, no cookies and no forms"); grep finds no analytics script | none |
| 48 | ML | 1 | Umami approved 2026-10-19 | VERIFIED | `marketing/PLAN.md:97` (Umami Cloud free) | none |
| 49 | ML | 1 | Visits by path `/fb###`, `/yt` | NEEDS CAVEAT | No such paths exist; `website/public/` has `_headers` but no `_redirects`, and the site has no Worker | See M-4 |
| 50 | ML | 4 | Pillar after 8-10 posts, series after 10+, channel at 90 days, rubric after 10-15 | VERIFIED | Matches `content-strategy.md` §7 and `idea-scoring-rubric.md` | none |
| 51 | FC | 1 | Render gate: "Independent reviewer (or Justin for small videos)" | WRONG (contradicts spec) | README: an independent reviewer "that did not write the piece" runs at both Stage 3 and Stage 5, then Justin signs off. Justin can't be both the independent check and the sign-off | See F-1 |
| 52 | FC | 2.5 | Adaptivity claims need phase merged, released, §9.5 tests passing | VERIFIED | `docs/specs/adaptive-practice.md:14, 40, 591` | none |
| 53 | FC | 2.5 | Check app claims against "the build testers can install today, not main" | NEEDS CAVEAT | Sound rule, but the repo has no git tags; `pubspec.yaml` is `1.0.3+8` with no release log mapping builds to commits | See F-2 |
| 54 | FC | 3 | Trivia bank is research report Appendix A | VERIFIED | `reports/Faceless short form video playbook.md:224` | none |
| 55 | FC | 5 | Make a wrong video "private or unlisted" | NEEDS CAVEAT | Works on YouTube. Facebook Reels have no "unlisted"; the Page options are delete or hide | Split by platform |
| 56 | FC | 5 | A lightly edited re-upload is treated as unoriginal | NEEDS CAVEAT | Platform originality rules target reposts of others' content and templated output; re-uploading your own corrected video is lower risk. The rule matches `format-library.md` (never re-upload to swap a hook), so it's a sensible house rule | Label it a house rule. Note YouTube Studio's editor can trim or blur a segment in place, which fixes some errors without a re-upload |

## Sense-read issues and fixes

### Visual style

**V-1. Tallyclaw's placement contradicts the safe area.** §8 says "usually the lower third ... inside the safe area." The lower third is y 1280-1920, entirely inside the bottom 35% the guide tells us to keep clear. Fix: "lower-middle or one side, inside y 269-1248; his body may run off the bottom edge as background art, but his face and mouth stay above y 1248." Then sort out the band at 55-65% height, which the guide currently gives to captions, Tallyclaw and math cards at once. Suggested layout: math card in y 300-800, Tallyclaw beside or below it, captions in y 1056-1248.

**V-2. The 85% gameplay rule can't be done.** See claim 15. Two workable options: (a) run gameplay full-height and check that the moment that matters (problem and answer tiles) sits in the safe band; or (b) crop to the region of interest (e.g. the problem and answer row) and scale that up inside the safe rectangle. Drop "85%".

**V-3. Fonts sentence.** See claim 4.

**V-4. Right margin.** YouTube and Facebook both stack like/comment/share buttons on the right. A 65 px right margin is the thinnest of the published figures (others give 120 px or 15%). Use about 120 px on the right for text until the test upload shows otherwise.

**V-5. No safe zone for the 16:9 F8a walkthrough.** Long-form landscape has fewer overlays, but the progress bar and title still cover the bottom and top. A line saying "standard title-safe 5-10% margins" would do.

**V-6. Long equations at 120-160 px.** "7 × 8 = 56" fits on one line; "8 + 2 + 3 = 10 + 3 = 13" at 120 px is about 1,400 px wide and doesn't fit in 950 px. Add a line-break rule (break after an equals sign, one step per line), which also matches "one step at a time".

**V-7. Puppet art is the same hard problem as the accessory blocker.** Separate layers, nine mouth shapes and a blink frame consistent with painterly 3/4 art is what project memory calls the long-running accessory-art blocker (needs Track A diff-extract with a Gemini/fal key, or hand work). "Clean it up by hand" assumes illustration skill. Add a fallback to the open decisions: commission a freelance illustrator for the puppet sheet, or a simpler cut-out style.

### Production pipeline

**P-1. Resolve free on Linux and H.264/AAC (the blocking issue).** Rewrite Phase A around an intake/outtake step with ffmpeg, which is already installed with the right encoders:
- *Intake:* transcode every H.264/HEVC/AAC/Opus/MP3 source to an editable format before import, e.g. `ffmpeg -i in.mp4 -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le out.mov`. Apply this to scrcpy recordings, phone footage and ElevenLabs MP3s (or download WAV where the plan offers it). Manim: render with `--transparent` (ProRes 4444), which Resolve on Linux decodes.
- *Outtake:* export DNxHR HQ + PCM from Resolve, then `ffmpeg -i master.mov -c:v libx264 -preset slow -b:v 16M -maxrate 20M -bufsize 32M -pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709 -c:a aac -b:a 320k -ar 48000 -af loudnorm=I=-14:TP=-1:LRA=11 -movflags +faststart out.mp4` (use two-pass loudnorm for accuracy).
- *Or change the editor:* Kdenlive (open source, in Fedora's repos) handles H.264/AAC on Linux natively and supports styled subtitles. Put this in open decision 3 with the trade-off spelled out. Resolve Studio (one-time purchase, price not checked today) adds H.264 decode and NVENC encode on Linux but still no AAC.
- Also note installing Resolve on Fedora 44 (unofficial; community scripts or a Rocky container) and that scrcpy isn't installed yet.

**P-2. Captions in Phase A have no workable path.** Resolve free imports SRT into a subtitle track and styles it globally, but per-word gold highlighting needs Studio's animated subtitles (Resolve 20 feature, not confirmed for free) or Fusion work per caption. "Create subtitles from audio" is Studio-only. Recommended Phase A path:
1. Run forced alignment of the **script text** against the final edited VO stem (e.g. WhisperX or `faster-whisper` with `word_timestamps=True`, then snap to the treatment's words). Use the script's words, never Whisper's transcription: captions must equal the treatment strings, and Whisper will spell "Tallyclaw" and numbers its own way.
2. A small script groups words into 2-4-word cues and swaps spoken numbers for the treatment's digit strings.
3. Either import the SRT into Resolve (no word highlight in Phase A; accept that), or render the captions as a transparent overlay with ffmpeg/libass (ASS `\k` karaoke tags give the gold current word) or a minimal Remotion composition, and lay that clip over the timeline.
4. Export the same SRT for YouTube's caption upload, which `script-standards.md` §4 requires and the pipeline omits. Add it to step 12.

**P-3. "Owned" game soundtrack.** Before the first video uses it, record where each track came from (Suno plan and date, or library and license) in `assets/audio/` or `marketing/production/`. If it came from Suno through a third-party reseller, check that Suno's ownership terms ("downloaded while subscribed") actually covered it. The six music loops are identical-length 22 s files, which may be placeholders; confirm they're final. Approved `compliance-checklist.md` §E also leans on this, so the fix belongs there too.

**P-4. ElevenLabs plans and the LLC.** The app is published by an LLC (`docs/GOOGLE_PLAY_PUBLISHING.md:27`, `docs/APPLE_APP_STORE_PUBLISHING.md:29`). ElevenLabs Music terms label Free through Pro "For Individual Use Only" and start entity eligibility at Scale ($299/mo). The general TTS terms weren't checked for the same wording. Add to open decision 1: confirm with ElevenLabs (or the current terms) whether marketing an LLC's app on an individual plan is allowed, for both voice and music. If not, prefer the game soundtrack or Meta's Sound Collection for music.

**P-5. Smaller gaps.**
- Brand guide §4.2 and §12 say lock the voice IDs "in `production-pipeline.md`"; this guide puts them in `marketing/production/voices.md`. Pick one and update the other.
- Gameplay must come from the build testers can install (release or profile mode, no debug banner), so the footage matches what the claims describe (`fact-check-protocol.md` step 5). Say so in step 5.
- "Fresh test profile" is ambiguous on Android: say "fresh install or cleared app data, on a device user/profile with no personal notifications".
- Color: set the Resolve project to Rec.709 gamma 2.4 and tag the encode BT.709 (above), or the app's hexes shift slightly on phones. 4:2:0 encoding softens thin gold-on-purple strokes, so keep operators bold.
- Rive's commercial terms weren't checked; add "check plan terms" beside it.
- Research suggests capturing game SFX from the app's own files (`assets/audio/sfx/`) rather than device audio for a clean mix; worth a line in step 5.

### Metrics and learning

**M-1. The per-tester 14-day clock can't be tracked.** Play Console shows an aggregate (opted-in count and the production-access checklist), and testers who joined via the Google Group are not listed with opt-in dates. Replace "Is anyone's 14-day count at risk?" with "Has the opted-in count stayed at 12+ every day since the clock started? Log the checklist's day count weekly."

**M-2. The 12-tester gate may not apply.** If the Play developer account is an Organization (as the publishing doc says), Google's stated rule (personal accounts after 2023-11-13) may not bind it. Justin should check the Play Console dashboard. If there's no gate, keep the tester target for feedback reasons but drop the 14-day machinery here and in `content-strategy.md` §1.

**M-3. Umami: requirement or decision?** §1 says Umami "has to be added before the first post"; §5 asks whether to add it. Make §1 say "recommended before the first post (decision 2)", or close decision 2.

**M-4. Redirect paths and analytics.** If `/fb012` is a Cloudflare `_redirects` 301 to `/`, client-side Umami never sees `/fb012` (no page loads there). Either redirect to `/?ref=fb012` (or UTM parameters) so the landing pageview carries the source, or serve a real page at each path. Join-button clicks need Umami custom events (`data-umami-event`) on the outbound TestFlight and Play links. The privacy policy must change first (it promises that at `privacy.astro:122`).

**M-5. YouTube promo videos can't be judged per video.** YouTube attribution is per channel (`/yt` in the walkthrough), and Play/TestFlight opt-ins carry no referrer, so "Pillar 4 judged on beta traffic and opt-ins" works per video on Facebook only. Say that YouTube promos are judged in aggregate (and by timing against opt-in spikes). The walkthrough's own Studio traffic-source report may show how many views came from Shorts (not verified today; worth checking once live).

**M-6. Small-sample medians.** At 3 a week, "our own channel's median" rests on 3-12 videos for the first month. Add: no decisions on medians from fewer than about 10 videos, matching the decision rules in §4.

### Fact-check protocol

**F-1. Render-gate exception.** Delete "(or Justin for small videos)". If a lighter render check is wanted for low-risk videos, define it (e.g. a fresh agent checks only caption-vs-treatment strings, VO-vs-script, and upload settings) and keep the reviewer independent. "Small" is undefined either way.

**F-2. Author and build identity.** Add two rules:
- The author never reviews, whoever the author is. When Justin writes a treatment (e.g. a Dad Dev Diary story), the independent reviewer is still a fresh agent, and Justin's sign-off is not the review.
- Record which build testers have (version, build number, commit) in a release log, and cite it in every `review.md` that makes app claims. Tag each release in git.

**F-3. The render gate needs its own checklist.** The template's render section is just "Issues". The README says edits, captions and VO introduce new errors; list the checks:
- Listen to the VO against the script word for word (TTS drops words and misreads numbers: "1729", "1/2", "×").
- Captions equal the treatment strings; every on-screen math string matches the math list.
- Safe zones on a phone preview; no flashing over 3/s (gameplay effects included).
- Music source and receipt on file; loudness measured.
- Final title, description, first comment and upload settings (MFK, AI label) re-checked, since copy often changes after the script gate.

**F-4. Volatile facts.** Add to step 6: the tester join flow and step counts, the perk sentence, what the current tester build does (game features, offline), the 12-tester rule and account type, tool and plan terms if a video mentions them, and the compliance checklist's "re-verify rules older than six months".

**F-5. Source tier note.** The research notes' HIGH items are themselves built on cited sources; for anything volatile, the reviewer should open the original cited source, not just the note.

## Cross-guide consistency notes

- `visual-style.md` §1 allows 60 fps; `production-pipeline.md` §3.10 exports 30 fps only (claim 18).
- `brand-and-voice.md` §4.2/§12 vs `production-pipeline.md` §2 on where voice IDs live (P-5).
- `compliance-checklist.md` §E approves "the game's own soundtrack" on the same unproven provenance as PP §8 (P-3).
- In passing (approved guide, not under review): `format-library.md` F1 says Dragon Puzzle runs "every other week", while `content-strategy.md` §4 and the format mix say once every 4 weeks.
- `content-strategy.md` §11 and `idea-scoring-rubric.md` still say `metrics-and-learning.md` is "to be written", and `script-standards.md` §4 says the same of `visual-style.md`; update those references when these guides are approved.

## Sources fetched or searched today

- Rhubarb Lip Sync README and LICENSE.md (github.com/DanielSWolf/rhubarb-lip-sync)
- Manim Community LICENSE (github.com/ManimCommunity/manim)
- Remotion LICENSE.md (github.com/remotion-dev/remotion)
- ElevenLabs pricing (elevenlabs.io/pricing), PVC/IVC docs (elevenlabs.io/docs/product-guides/voices/voice-cloning/professional-voice-cloning), TTS with-timestamps API reference, Eleven Music Model-Specific Terms (elevenlabs.io/eleven-music-model-specific-terms)
- Blackmagic Resolve compare page; tal.org "Blackmagic DaVinci Resolve on Linux" (Resolve 20.2); NixOS wiki DaVinci Resolve; Blackmagic forum threads on Linux H.264/AAC; Resolve 20 subtitle guides (Larry Jordan, Storyblocks, Miracamp)
- YouTube Help 1722171 (upload encoding), 1311402 (Content ID eligibility), 14328491 (via notes)
- Google Play Console Help 14151465 (testing requirements)
- App Store Connect Help (tester information; build status and metrics)
- scrcpy audio docs (github.com/Genymobile/scrcpy/blob/master/doc/audio.md)
- WCAG 2.1 Understanding 2.3.1
- Third-party: Meta safe-zone tools (adnova, socialync, revid, poster.ly), Facebook Reels insights (Sirency, ContentStudio), loudness guides (vloggingpro, Opus Pro), Sora shutdown coverage
