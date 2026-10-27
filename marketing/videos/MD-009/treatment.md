---
id: MD-009
status: treatment
pillar: 1
series: Tricks They Didn't Teach Us
format: F2
target_length_s: 30
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook:
---

# MD-009: The 9s finger trick

## Concept
Parents learn the finger trick for 9 × 1 through 9 × 10, and the one-line reason it works, so they can show their kid tonight.

## Hooks
- A: First frame: two hands flat on the purple cloth, the seventh finger already folding down. On-screen text: "9 × 7 on your fingers". VO (Narrator): "Parents, here's nine times seven, on your fingers."
- B: First frame: same hands, finger folded, the result card "63" already showing (result before method). On-screen text: "Your fingers know the 9s". VO (Narrator): "Parents, your kid's fingers already know the nine times table."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-3 s | Hands, overhead: both hands flat, palms down; the left pinky is finger 1, the right pinky is finger 10 (as seen by the camera); finger 7 starts folding | "9 × 7 on your fingers" | Narrator: "Parents, here's nine times seven, on your fingers." |
| 3-8 s | Hands flat again; small gold numerals 1 to 10 pop above each finger, left to right | "1 2 3 4 5 6 7 8 9 10" | Narrator: "Hands flat. Number the fingers one to ten, from the left." |
| 8-11 s | Punch-in: finger 7 (right index) folds down | "Fold finger 7" | Narrator: "For nine times seven, fold down finger seven." |
| 11-15 s | Gold bracket over the 6 fingers left of the fold, cream bracket over the 3 on the right; math card overlay | "6 \| 3" then "9 × 7 = 63" | Narrator: "Six fingers on the left. Three on the right. Sixty-three." |
| 15-19 s | Hands reset; finger 3 (left middle) folds; brackets 2 and 7 | "9 × 3 = 27" | Narrator: "Nine times three. Fold finger three. Two, then seven. Twenty-seven." |
| 19-22 s | Quick montage, one fold per beat: 1, 5, 10, with each result card | "Works for 9 × 1 to 9 × 10" | Narrator: "It works from nine times one up to nine times ten." |
| 22-28 s | Math card: `9 × 7 = 70 − 7 = 63`. The "70" appears as seven stacks of ten; then 7 ones are taken off the end, so six full tens and 3 ones remain; a final caption beat ties it back to the fingers (6 \| 3) | "9 × 7 = 70 − 7 = 63" then "6 tens + 3 = 63" | Narrator: "Why? Nine is one less than ten. So nine sevens is seventy, minus seven." |
| 28-30 s | Back to the opening hands with finger 7 folded (loop) | "9 × 7 = 63" | (no VO; the loop runs into "Parents, here's nine times seven") |

Word count: 72 Narrator words (budget about 75 at 2.5 words/s for 30 s; F2 range 20-30 s)

Origin beat: **skipped.** No source for where the trick comes from (idea-bank I-020; F2 rule: "the origin is unknown" is itself a claim).

## Math strings (exact, rendered from code)
Verified by running `python3 -I verify.py` (scratchpad, 2026-10-27): for n = 1..10, `9 × n = 10 × (n − 1) + (10 − n) = 10n − n`, all true.
- `9 × 7 on your fingers`
- `1 2 3 4 5 6 7 8 9 10`
- `Fold finger 7`
- `6 | 3`
- `9 × 7 = 63`
- `9 × 3 = 27` (bracket split `2 | 7`)
- `9 × 1 = 9` (split `0 | 9`)
- `9 × 5 = 45` (split `4 | 5`)
- `9 × 10 = 90` (split `9 | 0`)
- `Works for 9 × 1 to 9 × 10`
- `9 × 7 = 70 − 7 = 63`
- `70 − 7 = 60 + 3 = 63` (the stacks visual: seven tens, take away 7, leaves six tens and 3)
- `6 tens + 3 = 63`

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Folding finger n leaves n − 1 fingers on the left (tens) and 10 − n on the right (ones), giving 9 × n | Appendix A #47; py (all n = 1..10) | HIGH |
| 2 | "Six fingers on the left. Three on the right. Sixty-three." | py: 9 × 7 = 63, split 6 \| 3 | HIGH |
| 3 | "Fold finger three. Two, then seven. Twenty-seven." | py: 9 × 3 = 27, split 2 \| 7 | HIGH |
| 4 | "It works from nine times one up to nine times ten." (range stated) | py: holds for n = 1..10; 9 × 11 = 99 cannot be shown on ten fingers | HIGH |
| 5 | "Nine is one less than ten. So nine sevens is seventy, minus seven." | A#47 ("works because 9n = 10n − n"); py | HIGH |
| 5b | Visual 22-28 s: seven stacks of ten minus 7 ones leaves six tens and 3 ones (= 63, matching the 6 \| 3 on the fingers) | py: 70 − 7 = 63 = 6 × 10 + 3 | HIGH |
| 6 | Implied: this is a trick, not a replacement for knowing the facts (stated in the description) | A#47 caveat ("party trick, not a substitute for knowing facts") | HIGH |
| 7 | Hashtag/title "Tricks they didn't teach us" framing: no claim that schools don't teach it | Title avoids that claim | n/a |

## CTA
None (value video). Corner mark `playmathdragons.com` only.

## Copy
- YouTube title: The 9 Times Table on Your Fingers (9 × 1 to 9 × 10) (51 chars)
- Shorts description: A quick finger trick for 9 × 1 through 9 × 10, and why it works. A fun way to check an answer, not a replacement for knowing the facts. Free beta: playmathdragons.com #mathforparents #homeschool #parentingtips #teachertips
- Facebook caption: Nine times seven, on your fingers. It works for 9 × 1 through 9 × 10. Did anyone show you this one as a kid?
- Facebook first comment: Free beta for iPhone, iPad and Android: playmathdragons.com/fb009
- Hashtags: #mathforparents #homeschool #parentingtips #teachertips

## Production notes
- **Hands footage** (`visual-style.md` §10): Justin's hands, overhead, phone camera, plain deep purple cloth, good light. No rings, watch, mail or screens in frame. Palms down so the camera's view matches the parent's own hands; left pinky = finger 1. Check the first take for mirroring before shooting the rest (a front camera would flip it).
- Shots: flat hands (hold), each fold for n = 7, 3, 1, 5, 10, one clean take per fold, 2 s each.
- **Math cards:** Manim, from the exact strings above; numbers cream, operators gold; the finger numerals 1-10 are rendered graphics tracked over the fingers, not handwritten.
- **Music:** `assets/audio/music/hub_theme.ogg`, low. SFX: `assets/audio/sfx/correct.wav` on each result card.
- **Cover frame:** 11-15 s, finger 7 folded with "9 × 7 = 63" and the 6 | 3 brackets visible.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: Tricks They Didn't Teach Us
- AI disclosure: YouTube no (own cloned voice, real hands) / Facebook yes (realistic AI voice)
- Facebook first-comment path: /fb009

## Gate checklist (script-standards §9, self-check)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows F2 beats (origin beat skipped for lack of a source, per F2 rule)
- [x] Word count within budget for the target length
- [x] Voice checklist passed (`brand-and-voice.md` §11)
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7
- [x] Compliance checklist §A-H passed
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (script gate, PASS WITH FIXES):
- **Wrong visual fixed (22-28 s):** was "seven stacks of ten, one stack trimmed by one" (that shows 69). Now seven stacks of ten with 7 ones taken off the end, leaving six tens and 3 ones, plus a caption beat `6 tens + 3 = 63` that ties the "why" back to the fingers.
- Added the visual's math (`70 − 7 = 60 + 3 = 63`, `6 tens + 3 = 63`) to the math strings and the claims list (row 5b).
- Softened the most count-along-shaped line: "Put both hands flat. Count your fingers from the left, one to ten." became "Hands flat. Number the fingers one to ten, from the left." (a demonstration, not an instruction to the viewer).
- Word count 74 to 72 (budget 75).
