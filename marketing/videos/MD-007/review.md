# MD-007: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS** (minor, optional precision notes)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "Make a ten" means getting one addend to ten first: 8 + 6 → 8 + 2 + 4 → 10 + 4 | TRUE | CCSS 1.OA.C.6 (thecorestandards.org/Math/Content/1/OA/, fetched): "...making ten (e.g., 8 + 6 = 8 + 2 + 4 = 10 + 4 = 14)..." | none |
| 2 | "That's the exact example in the Common Core standard for first grade." | TRUE | same text, character for character; 1.OA = grade 1 | none |
| 3 | "You may already do this in your head." | OK (hedged inference) | MLE line 182 (it uses 8 + 5; same strategy) | none |
| 4 | Ten is easy to add to, so one harder fact becomes two easy steps | OK (pedagogical reasoning, no outcome) | 8 + 2 and 10 + 4 (py) | none |
| 5 | A ten frame is a box with ten spaces (two rows of five) | TRUE | definition; WWC 2021 guide Table 3.1 lists "5 frames, 10 frames, double 10 frames" | none |
| 6 | "In studies of kids who needed extra help, pictures like this worked well." / on screen "Studies: kids who needed extra help" | TRUE, slightly loose | WWC 2021006 (Fuchs et al.), Rec 3 "Use a well-chosen set of concrete and semi-concrete representations...": **strong** evidence, **28 studies**, grades K-6, students struggling with math; ten frames listed as a semi-concrete representation in Table 3.1 (fetched). The studies tested interventions that *used* representations, not ten-frame pictures alone | Optional: "...pictures like this are part of what worked." or "a federal research guide strongly recommends pictures like this." Cite Table 3.1 in the claims list |
| 7 | The standard lists it as one of several strategies | TRUE | 1.OA.C.6 lists counting on; making ten; decomposing a number leading to a ten; using the addition/subtraction relationship; creating equivalent easier sums | none |
| 8 | Tip: ask "how many more to make ten?", then let your kid finish | OK (tip) | F3 beat 4 | none |
| 9 | (missing from list) Hook B: "your kid's worksheet turns eight plus six into ten plus four" | TRUE | py | add if Hook B is picked |
| 10 | (missing from list) Description: "first-grade math homework" | TRUE (the standard is grade 1; homework grade varies) | 1.OA | none |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-007: make a ten
8+6 = 14  10-8 = 2  2+4 = 6  8+2 = 10  10+4 = 14
chain 8+6 == 8+2+4 == 10+4 == 14: True
ten frame: 8 filled + 2 moved = 10  6-2 left = 4  ten frame cells 2x5 = 10
CCSS other examples: 13-4 == 13-3-1 == 10-1 == 9: True ; 8+4=12 -> 12-8 = 4 ; 6+7 == 6+6+1 == 12+1 == 13: True
MD-007: 58 chars, 40<=len<=65: True | "Make a ten" on your kid's homework, explained for parents
   first-comment paths: {'playmathdragons.com/fb007'}
   hashtags: #parenting #homeschool #teachers #parentingtips count 4
```
All ten exact strings check out, including the full chain `8 + 6 = 8 + 2 + 4 = 10 + 4 = 14`. Word count 128, as stated (per beat 2.0-2.75 w/s; the 0-4 s hook at 2.75 is the tightest but fine). 55-56 s total, inside F3's 30-60 s. Em-dashes: 0. X/Y reframes: 0.

Sense read:
- As a math teacher: correct, pro-teacher, and it says "one of several strategies", so it doesn't present making ten as the only way. The ten-frame beat (2 dots move from the 6 into the 8, leaving 4) matches the arithmetic. The help-at-home question is good practice: it prompts the step without doing it for the kid.
- As a parent: clear, nothing mocks "new math", and nothing raises anxiety.
- Small consistency note: `10 - 8 = 2` (and the ten-frame `6 - 2 = 4`) use an ASCII hyphen for minus, while MD-002 renders `−` (U+2212). The CCSS text itself uses a hyphen, so it's not wrong, but pick one glyph for all math cards (a visual-style decision for Justin).
- Not every state uses Common Core; "Your kid's homework says make a ten" is still true for most parents who'd see this, and the label names the standard rather than claiming universality.

Compliance (§A-H):
- A Made for Kids: PASS. "Your kid's homework" in the first spoken line, adult title ("explained for parents"), parent hashtags; recreated worksheet with no child name or handwriting; no Tallyclaw, no gameplay.
- B Claims: PASS. No app claim (the app doesn't teach strategies, and the script says nothing about it); learning-science claim scoped to "kids who needed extra help" and backed by a Strong WWC rating.
- C AI disclosure: PASS.
- D Engagement bait: PASS. "Which worksheet phrase should I decode next?" is a genuine request.
- E Audio: PASS.
- F Visuals/IP: PASS. Own layout, no publisher design.
- G Privacy: PASS (Justin's hands, nothing identifying).
- H Links/CTA: PASS (none). Cross-cutting: "Free beta" in description and first comment needs LAUNCH-CHECKLIST §7-§9 done; `/fb007` needs `website/phase-2` deployed.

Notes (optional):
1. Tighten the WWC line (claim 6) so it doesn't imply ten-frame pictures alone were tested.
2. Claims list 6: add "Table 3.1 lists ten frames" and "28 studies, K-6" with the PDF link.
3. Decide one minus glyph for all math cards.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
