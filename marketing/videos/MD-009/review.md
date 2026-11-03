# MD-009: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (one wrong visual, one recommended wording change)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Fold finger n: n − 1 fingers left (tens), 10 − n right (ones) = 9 × n | VERIFIED | py, all n = 1..10 (below); Appendix A #47 | None |
| 2 | "Six fingers on the left. Three on the right. Sixty-three." | VERIFIED | py: fold 7 → 6 \| 3 = 63. With palms down and the left pinky as finger 1, finger 7 is the right index finger and the six fingers to its left include both thumbs | None |
| 3 | "Fold finger three. Two, then seven. Twenty-seven." | VERIFIED | py: fold 3 → 2 \| 7 = 27; finger 3 = left middle finger | None |
| 4 | "It works from nine times one up to nine times ten." | VERIFIED | py: holds for n = 1..10; 9 × 1 shows 0 \| 9, 9 × 10 shows 9 \| 0 | None |
| 5 | "Nine is one less than ten. So nine sevens is seventy, minus seven." | VERIFIED (arithmetic) | 9 × 7 = 10 × 7 − 7 = 70 − 7 = 63 | See row 6 and sense read: it proves 9 × 7 = 63, not why the fingers work |
| 6 | Visual 22-28 s: "the '70' built from seven stacks of ten, one stack trimmed by one" | **WRONG** | Seven stacks of ten with one stack trimmed by one is 69, not 63. 70 − 7 needs either all seven stacks trimmed by one (seven nines) or one 7 taken away | Show seven stacks of ten, then take 7 off the end so six full tens and 3 ones remain. That is 63 and it is also the 6 \| 3 on the fingers, which closes the "why" gap (see sense read) |
| 7 | Description "A fun way to check an answer, not a replacement for knowing the facts" | OK | A#47 caveat ("party trick, not a substitute for knowing facts") | None. This is the piece's one "X, not Y" construction; fine at max one |
| 8 | Title/series "Tricks They Didn't Teach Us" | OK | No claim that schools don't teach it is made in VO or title | None |
| 9 | Origin beat skipped | CORRECT | F2 rule; no source (idea-bank I-020) | None |

Claims list: complete. Add row 6's visual (it's a math claim drawn on screen) to the math strings, e.g. `70 − 7 = 60 + 3 = 63`, so the render gate checks it.

Math recomputed (python3 -I, 2026-10-27):
```
9 x  1 =  9  fold 1: left 0 | right 9 -> 9 OK
9 x  2 = 18  fold 2: left 1 | right 8 -> 18 OK
9 x  3 = 27  fold 3: left 2 | right 7 -> 27 OK
9 x  4 = 36  fold 4: left 3 | right 6 -> 36 OK
9 x  5 = 45  fold 5: left 4 | right 5 -> 45 OK
9 x  6 = 54  fold 6: left 5 | right 4 -> 54 OK
9 x  7 = 63  fold 7: left 6 | right 3 -> 63 OK
9 x  8 = 72  fold 8: left 7 | right 2 -> 72 OK
9 x  9 = 81  fold 9: left 8 | right 1 -> 81 OK
9 x 10 = 90  fold 10: left 9 | right 0 -> 90 OK
70 - 7 = 63; 9 x 11 = 99 (would need 11 fingers)
```
All listed strings (`9 × 7 = 63`, `9 × 3 = 27`, `9 × 1 = 9`, `9 × 5 = 45`, `9 × 10 = 90`, splits `6 | 3`, `2 | 7`, `0 | 9`, `4 | 5`, `9 | 0`, `9 × 7 = 70 − 7 = 63`) are correct. Word count recomputed: 74 (claimed 74), 2.47 words/s over 30 s, budget 75. Title "The 9 Times Table on Your Fingers (9 × 1 to 9 × 10)" = 51 chars.

Sense read:
- **Math teacher:** the "why" line explains why 9 × 7 is 63, but a parent who wants to explain *the fingers* to a kid still has no bridge. The fix in row 6 gives it for free: 70 − 7 leaves 6 tens and 3 ones, and the fingers show 6 and 3. One extra caption beat (`6 tens + 3 = 63`) would make it explicit without extra VO. Not blocking once the visual is fixed.
- **Skeptical parent:** easy to follow; the mirroring note in production (front camera flips) matters, because if the footage is mirrored, "count from the left" will be backwards for the viewer. Keep that check.
- "Put both hands flat. Count your fingers from the left, one to ten." is an instruction a child can follow along with. It's addressed to the parent (the line before says "Parents"), so it's not a violation, but it's the most count-along-shaped line in the batch. **Recommended:** "Hands flat. Number the fingers one to ten, from the left." (11 words, two fewer than now) keeps it a demonstration rather than an instruction to the viewer.

Compliance (§A-H):
- A (Made for Kids): PASS, with the note above. "Parents," in the first spoken line; parent hashtags (#mathforparents #homeschool #parentingtips #teachertips); adult hands only. A finger trick for the 9s is the most kid-adjacent topic in the batch, so keep the description and caption parent-voiced (they are).
- B: no app claims. Learning claim (trick vs knowing facts) carries its caveat. PASS.
- C: YouTube no, Facebook yes. PASS.
- D: caption question "Did anyone show you this one as a kid?" is genuine. PASS.
- E: game's own music/SFX. PASS.
- F: own footage, Manim cards. PASS.
- G: Justin's hands, nothing identifying (rings, watch removed). PASS.
- H: no CTA (value video), corner mark only, `/fb009` in first comment. PASS.

Voice (§11): adult address, one idea, zero em-dashes, one X/Y construction (description). PASS.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
