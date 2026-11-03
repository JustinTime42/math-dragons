# MD-004: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS** (no required fixes; two minor notes)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "A number is even if it splits into two equal groups, with none left over" (the stated rule) | TRUE (standard school definition, equivalent to "a multiple of 2" for whole numbers) | Wikipedia "Parity of zero" (fetched): "In mathematics, zero is an even number"; 0 = (2 × 0) + 0. Appendix A #40 (HIGH) | none |
| 2 | The puzzle has one answer (even), so it's solvable and not rage-bait | TRUE | Rule stated on screen gives a unique answer: 0 = 0 + 0, remainder 0 (py) | none |
| 3 | 6 = 3 + 3 (rule card example) | TRUE | py | none |
| 4 | Joke/premise in hook "Ask your kid. Then ask yourself." (implies adults find it hard too) | TRUE | Lichtenberg 1972 (via Wikipedia, fetched): about two thirds of prospective elementary teachers answered "False" to "Zero is an even number" | add to claims list (it's a premise) |
| 5 | No app tie-in, because Dragon's Feast's "even" category excludes 0 | TRUE | `28d6638:lib/games/dragons_feast/systems/category_system.dart:31` `predicate: (n) => n > 0 && n % 2 == 0` (py: predicate at 0 is False) | none. Note for Justin: the app's category is labeled "Numbers divisible by 2" yet rejects 0. Fine for gameplay if 0 never appears, but worth a look before any video ties Feast to parity |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-004/MD-006: parity of zero
6 % 2 = 0  6 == 3+3: True
0 % 2 = 0  0//2 = 0  divmod(0,2) = (0, 0)  0 == 0+0: True  0 == 2*0: True
range(6,-1,-2): [6, 4, 2, 0] all even: True
neighbours of 0 odd: 1 1
Dragon's Feast even predicate n>0 and n%2==0 at n=0: False
MD-004: 52 chars, 40<=len<=65: True | Parents: is zero even, odd, or neither? Ask your kid
   first-comment paths: {'playmathdragons.com/fb004'}
   hashtags: #parenting #homeschool #teachers count 3
```
Word count 37, as stated (0-5 s 13 w = 2.6 w/s; 5-13 s 19 w = 2.38 w/s; 16-18 s 5 w = 2.5 w/s), plus 3 s silent thinking beat = 18 s, inside F1's 13-20 s. Em-dashes: 0. X/Y reframes: 0.

Sense read:
- As a parent: a fair puzzle. Stating the rule turns it from a trick into a reasoning question, which is right for F1 ("every assumption stated").
- As a math teacher: the rule is the school definition, and it settles the answer. A pedant might want "a whole number", but the puzzle is only about 0 and 6, so it isn't misleading.
- Child-directed check: "Ask your kid" and "Try this with your kid" go through the parent. The fire bar is a silent visual timer, not a count-along. OK.
- "Answer in the next video": on the channel, the next upload is MD-005, not part 2 (part 2 comes early in week 2). The F1 phrase is prescribed, and the description points to the playlist, so this is acceptable. It's still the one line a viewer could feel misled by. See note 1.

Compliance (§A-H):
- A Made for Kids: PASS. "Parents" in the first spoken word, frame-one text and title; no child-directed language; no Tallyclaw, no gameplay.
- B Claims: PASS (no app or learning-science claim).
- C AI disclosure: PASS (YouTube no; Facebook yes).
- D Engagement bait: PASS. "Is zero even, odd, or neither, and did you two agree?" is a genuine question. Not a deliberately ambiguous puzzle.
- E Audio: PASS (hub theme).
- F Visuals/IP: PASS.
- G Privacy: PASS.
- H Links/CTA: PASS (the puzzle is the CTA). Cross-cutting: "Free beta" in the description and first comment is untrue until LAUNCH-CHECKLIST §7-§9 are done; `/fb004` needs `website/phase-2` deployed.

Notes (not required):
1. Consider "Answer in part two." on screen and in VO (same word count, same length), which stays true whatever posts in between. It's a format-library wording change, so Justin's call.
2. Slot order: the idea-bank review (§4) recommended I-055 (MD-005) before this puzzle; the INDEX keeps the puzzle as post 2. Justin's call; nothing in the script depends on it.
3. Claims list: add the hook premise (item 4 above).

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
