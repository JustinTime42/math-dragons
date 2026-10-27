---
id: MD-010
status: treatment
pillar: 3
series: Tallyclaw Was There
format: F4
target_length_s: 56
voices: Narrator (Tallyclaw as still art, per F4 until the puppet exists)
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook:
---

# MD-010: Why an hour has 60 minutes

## Concept
Parents get the real answer to "why is an hour sixty minutes?": a relay from Egypt's twelve-and-twelve day, through Babylonian base 60 and Greek astronomers, to clocks of the late 1500s, plus why sixty is handy.

## Hooks
- A: First frame: still Tallyclaw (stone, unimpressed pose) beside a clock face with only a minute hand. On-screen text: "Why 60 minutes?" VO (Narrator): "Parents, when your kid asks why an hour has sixty minutes, here's the real answer."
- B: First frame: math card "60 ÷ 2, 3, 4, 5, 6" with every result whole, Tallyclaw (smug) at the side. On-screen text: "Why not 100 minutes?" VO (Narrator): "Parents, why isn't an hour a hundred minutes? Blame some very old astronomers."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-6 s | Still Tallyclaw, unimpressed pose, left of a clock face (minute hand only) | "Why 60 minutes?" | Narrator: "Parents, when your kid asks why an hour has sixty minutes, here's the real answer." |
| 6-10 s | Tallyclaw, pointing-claw pose; a dotted path with four labelled stops (labels added in the edit, no text inside the art): "Egypt", "Babylon", "Greek astronomers" (a label, not a pin on Greece: Ptolemy worked in Alexandria), "Europe's clocks" | "Tallyclaw was there." | Narrator: "Tallyclaw says he was there. It took about three thousand years." |
| 10-19 s | Illustration: Egyptian sundial, daylight split into 12 wedges; then a night sky with 12 star markers; math card `12 + 12 = 24` | "Egypt: 12 + 12 = 24" | Narrator: "First, Egypt. About thirty-five hundred years ago, they split the daylight into twelve parts, and the night into twelve more." |
| 19-23 s | Illustration: Babylonian clay tablet (schematic, no fake cuneiform) | "Babylon: base 60" | Narrator: "The sixty comes from Babylon. Their astronomers counted in sixties." |
| 23-31 s | Illustration: a Greek astronomer's circle diagram (flat style, no realistic face); one degree zooms open into 60 slices, one slice into 60 more | "1 degree → 60 → 60" | Narrator: "Greek astronomers borrowed that to cut each degree of a circle into sixty parts, and each part into sixty more." |
| 31-37 s | Text cards in Cinzel: "pars minuta prima" → "minute"; "pars minuta secunda" → "second" | "minute" / "second" | Narrator: "In Latin, the first small part became the minute. The second became, well, the second." |
| 37-43 s | Illustration: an hourglass-style hour icon splitting into 60, then a late-1500s clock gaining a minute hand | "Hours: same split" / "Minute hands: late 1500s" | Narrator: "Later, hours got the same split. Clocks didn't show minutes until the late fifteen hundreds." |
| 43-52 s | Math card, re-hook: `60 ÷ 2 = 30`, `60 ÷ 3 = 20`, `60 ÷ 4 = 15`, `60 ÷ 5 = 12`, `60 ÷ 6 = 10` stack in one at a time, glowing emerald; then `100 ÷ 3 = 33.33…` in fire orange | "Why 60? Nobody's sure." | Narrator: "Why sixty? Nobody knows for sure. But sixty splits evenly by two, three, four, five and six. A hundred won't split into thirds." |
| 52-56 s | Tallyclaw, smug pose, back beside the clock face from frame one (loop) | Speech bubble: "Whoever picked 60 knew their business." | Narrator: "Tallyclaw's verdict: whoever picked sixty knew their business." |

Word count: 137 Narrator words (budget about 140 at 2.5 words/s for 56 s; F4 range 30-60 s). The full corrected chain fits inside 60 s; no extra length needed.

## Math strings (exact, rendered from code)
Verified by running `python3 -I verify.py` (scratchpad, 2026-10-27).
- `Why 60 minutes?`
- `12 + 12 = 24`
- `1 degree → 60 → 60`
- `60 ÷ 2 = 30`
- `60 ÷ 3 = 20`
- `60 ÷ 4 = 15`
- `60 ÷ 5 = 12`
- `60 ÷ 6 = 10`
- `100 ÷ 3 = 33.33…` (py: 33.333…, remainder 1)
- `Hours: same split`
- `Minute hands: late 1500s`
- `Whoever picked 60 knew their business.`

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | "It took about three thousand years." (c. 1500 BCE to the late 1500s CE) | Scientific American, "Why is a minute divided into 60 seconds, an hour into 60 minutes, yet there are only 24 hours in a day?" (scientificamerican.com/article/experts-time-division-days-hours-minutes/, fetched 2026-10-27): sundials "by about 1500 B.C."; minute clocks "near the end of the 16th century"; py: ~3,000 years | HIGH |
| 2 | "About thirty-five hundred years ago, they split the daylight into twelve parts, and the night into twelve more." | Sci Am: "As early as 1500 B.C. ... calibrated to divide the interval between sunrise and sunset into 12 parts"; night marked by 12 stars, "12 divisions of night"; py 2026 + 1500 ≈ 3,500 | HIGH |
| 3 | `12 + 12 = 24` (the 24 hours' origin) | Sci Am (as above); idea-bank I-083 corrected chain ("24-hour day from Egypt"); py. Note: these were not yet equal hours; Hipparchus later proposed 24 equal hours (Sci Am). Script doesn't claim they were equal | HIGH |
| 4 | "The sixty comes from Babylon. Their astronomers counted in sixties." | Sci Am: "The Babylonians made astronomical calculations in the sexagesimal (base 60) system they inherited from the Sumerians"; Appendix A #3 (HIGH legacy). Script does not say Babylon invented it (brand-and-voice §4.4 caveat) | HIGH |
| 5 | "Greek astronomers borrowed that to cut each degree of a circle into sixty parts, and each part into sixty more." | Sci Am (Ptolemy): "Each degree was divided into 60 parts, each of which was again subdivided into 60 smaller parts"; idea-bank.review I-083 fix | HIGH |
| 6 | "In Latin, the first small part became the minute. The second became, well, the second." | Sci Am: "partes minutae primae, or first minute, became known simply as the 'minute'"; "partes minutae secundae, or 'second minute,' became known as the second." On-screen uses the singular "pars minuta prima / secunda" (reviewer: confirm singular vs plural form; switch to Sci Am's plural "partes minutae primae / secundae" if in doubt) | HIGH (reviewer confirmed: Wikipedia "Minute" gives the singular *pars minuta prima* / *secunda*; keep the singular) |
| 7 | "Later, hours got the same split." / "Hours: same split" (no date given) | Wikipedia "Minute" (via review, 2026-10-27): al-Biruni "first subdivided the hour sexagesimally into minutes, seconds, thirds and fourths in 1000 CE"; Roger Bacon 1267; Sci Am: the hour wasn't commonly understood as 60 minutes until clocks showed minutes; present-day 1 h = 60 min = 3,600 s (py 60 × 60 = 3600) | HIGH (that it came later); no date claimed |
| 8 | "Clocks didn't show minutes until the late fifteen hundreds." | Sci Am: "the first mechanical clocks that displayed minutes appeared near the end of the 16th century" | HIGH |
| 9 | "Why sixty? Nobody knows for sure." | Appendix A #3 caveat ("Why 60 was chosen is debated"); brand-and-voice §4.4 | HIGH (that it's debated) |
| 10 | "Sixty splits evenly by two, three, four, five and six." | py: divisors of 60 = 1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60 | HIGH |
| 11 | "A hundred won't split into thirds." (evenly, in whole numbers) | py: 100 mod 3 = 1 | HIGH |
| 12 | "Whoever picked sixty knew their business." (joke premise: 60 is convenient; no inventor credited) | brand-and-voice §4.4 calibrated line (reworded, not reused verbatim) | HIGH |
| 12b | Map visual 6-10 s: stops labelled "Egypt", "Babylon", "Greek astronomers", "Europe's clocks" | Rows 2-8; Ptolemy worked in Alexandria (Roman Egypt), so the Greek stop is a label for the astronomers, not a place pin | HIGH |
| 13 | "Tallyclaw says he was there." (eyewitness conceit; no fact bent) | brand-and-voice §4.2 | n/a (character device) |

Facts cut: Hipparchus's name and dates (147-127 BCE) and the equal-hours detail (true, Sci Am, but they'd push the script past budget and add a second thread); the Sumerian origin line (kept implicit by "Nobody knows for sure"); 360 degrees.

## CTA
None (value video). Corner mark `playmathdragons.com` only.

## Copy
- YouTube title: Why an Hour Has 60 Minutes (the Real History) (45 chars)
- Shorts description: The real answer to "why is an hour sixty minutes?" takes about 3,000 years: Egypt, Babylon, Greek astronomers, then clocks. Free beta: playmathdragons.com #mathforparents #homeschool #homeschooling #teachertips
- Facebook caption: Your kid asks why an hour has 60 minutes. Here's the short version of a 3,000-year answer. What's the hardest "why" question your kid has asked you?
- Facebook first comment: Free beta for iPhone, iPad and Android: playmathdragons.com/fb010
- Hashtags: #mathforparents #homeschool #homeschooling #teachertips

## Production notes
- **Tallyclaw still poses** (stone variant, from `assets/style_bible/approved/04_stone_dragon.png` and `09_stone_face.png`, weathered, `visual-style.md` §8): unimpressed (0-6 s), pointing claw (6-10 s), smug (51-55 s). Mid-height, one side, inside the safe area, never over the math. Subtle push-in on each still so there's motion every 1-3 s.
- **Illustrations** (style-bible look, no text inside AI images, all labels added in the edit): sundial with 12 daylight wedges; night sky with 12 star markers; schematic clay tablet (no invented cuneiform); flat circle-and-degree diagram with a generic, non-realistic astronomer figure or none; a late-1500s style clock gaining a minute hand. No real person depicted photoreal; no named person depicted at all.
- **Math cards:** Manim, exact strings above; correct splits glow emerald, the 100 ÷ 3 card in fire orange.
- **Tallyclaw's line** is a speech bubble (Nunito Bold, within 7 words) read by the Narrator; Tallyclaw's own voice isn't locked yet and F4 runs with the Narrator until the puppet exists.
- **Music:** `assets/audio/music/dragon_runes.ogg` (ancient feel), low. SFX: `assets/audio/sfx/rune_connect.wav` lightly on each 60 ÷ n card; `dragon_roar.wav` very soft under the button line (optional).
- **Cover frame:** 0-6 s, Tallyclaw beside the clock with "Why 60 minutes?" visible.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: Tallyclaw Was There
- AI disclosure: YouTube no (own cloned voice; illustrated, clearly unrealistic history) / Facebook yes (realistic AI voice)
- Facebook first-comment path: /fb010

## Gate checklist (script-standards §9, self-check)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows F4 beats (cold open, what happened, awe beat at 41 s, button echoing the opening)
- [x] Word count within budget for the target length
- [x] Voice checklist passed (`brand-and-voice.md` §11): eyewitness conceit bends no fact; no single inventor credited
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7
- [x] Compliance checklist §A-H passed
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (script gate, PASS WITH FIXES):
- **Required sense fix:** added "Later, hours got the same split." (no date) before the clock line, with an on-screen "Hours: same split", so the chain reaches the hour and not just the degree. Claim 7 now cites Wikipedia "Minute" (al-Biruni c. 1000 CE; Roger Bacon 1267) and Sci Am.
- Dropped "even" from "Clocks didn't even show minutes" and "A hundred won't even split into thirds" to stay in budget: 137 words over 56 s (budget about 140).
- Map stop labelled "Greek astronomers" (not a pin on Greece; Ptolemy worked in Alexandria); map visual added to the claims list (row 12b).
- Claim 6: singular Latin form confirmed by the reviewer; kept.
- Not applied: the optional "came by way of Babylon" rewording (+2 words would break the budget; "Nobody knows for sure" already covers the origin debate).
