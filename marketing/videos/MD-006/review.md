# MD-006: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS** (claims-list precision only)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Zero is even | TRUE | Wikipedia "Parity of zero" (fetched): "In mathematics, zero is an even number." 0 = 2 × 0 (py) | none |
| 2 | "A very common answer is neither" | SUPPORTED (MODERATE-HIGH) | Wikipedia (fetched), citing Frobisher (1999): in a 1992 survey of nearly 400 Year 2 (6-7-year-old) English children, 45% chose even; once "neither", "both" and "don't know" were offered, it fell to 32%. Lichtenberg (1972, *The Arithmetic Teacher* 19(7)): about two thirds of prospective elementary teachers answered "False" to "Zero is an even number". Neither source gives the exact share choosing "neither", so "very common" is the right strength. Never "most people" (held) | Claims list says "UK 7-year-olds"; make it "nearly 400 English Year 2 children (ages 6-7), Frobisher 1999, via Wikipedia" |
| 3 | Zero "feels like nothing" (why "neither" is tempting) | OK (framing) | none | none |
| 4 | Split zero into two equal groups: zero and zero, none left over | TRUE | py: `divmod(0, 2) == (0, 0)` | none |
| 5 | Counting down by twos, 6, 4, 2, 0, zero lands where the evens go | TRUE | py; Wikipedia: zero is between -1 and 1, both odd | none |
| 6 | The rule your kid learned still works | TRUE | same rule as MD-004 | none |
| 7 | Tallyclaw card "Zero. Even. Next question." | TRUE | restates 1 | none |
| 8 | (missing from list) Description/caption: "the rule your kid already knows proves it" | TRUE (with the stated rule) | as 4/6 | add to claims list |
| 9 | (missing from list) Description: "Part 1 is in the Dragon Puzzle playlist" | TRUE at upload if MD-004 is in the playlist | F1 linking rule | none |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-004/MD-006: parity of zero
6 % 2 = 0  6 == 3+3: True
0 % 2 = 0  0//2 = 0  divmod(0,2) = (0, 0)  0 == 0+0: True  0 == 2*0: True
range(6,-1,-2): [6, 4, 2, 0] all even: True
neighbours of 0 odd: 1 1
MD-006: 47 chars, 40<=len<=65: True | Is zero even? The answer, explained for parents
   first-comment paths: {'playmathdragons.com/fb006'}
   hashtags: #parenting #homeschool #teachers count 3
```
Strings `0 = 0 + 0`, `0 ÷ 2 = 0`, `remainder 0`, `6, 4, 2, 0`, rule card: all correct. Word count 69, as stated (per beat 2.29-2.67 w/s; 28 s speech + 2 s card = 30 s, inside F1 part 2's 20-30 s). Em-dashes: 0. X/Y reframes: 0 ("But zero is even" is a plain correction, not a reframe construction).

Sense read:
- As a math teacher: correct and well ordered: name the error, say why it's tempting, show two independent reasons (the grouping rule and the even/odd alternation). No simplification misleads. "Zero lands right where the evens go" is the alternation argument stated gently.
- As a parent: the takeaway ("the rule your kid learned still works") is reusable and calm, and it doesn't shame anyone who said neither.
- "Count down by twos: six, four, two, zero." is a demonstration in the Narrator's voice, not an invitation to count along. OK, but keep the delivery explanatory (no pause for the viewer to join in).

Compliance (§A-H):
- A Made for Kids: PASS. "Parents" first spoken word and frame-one text; parent title ("explained for parents"); Tallyclaw text card addresses no one in particular and invites nothing.
- B Claims: PASS. No app claim; Feast correctly kept out (its even category excludes 0, `category_system.dart:31` at `28d6638`).
- C AI disclosure: PASS.
- D Engagement bait: PASS. "Did anyone at your house say neither?" is genuine.
- E Audio: PASS.
- F Visuals/IP: PASS (reuses our own MD-004 cards).
- G Privacy: PASS.
- H Links/CTA: PASS (no CTA). Cross-cutting: "Free beta" in description and first comment needs LAUNCH-CHECKLIST §7-§9 done; `/fb006` needs `website/phase-2` deployed. After upload, switch MD-004's related video (noted).

Fixes:
1. Claims list 2: correct the study description (Year 2, ages 6-7, nearly 400, 1992 survey, Frobisher 1999; Lichtenberg 1972 in *The Arithmetic Teacher*). Both are via Wikipedia (a secondary source pointing to the primaries); fine for "very common", which is all the script claims.
2. Claims list: add the description/caption line (item 8).

Justin sign-off:

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
