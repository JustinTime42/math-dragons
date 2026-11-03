# MD-012: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (math correct; three on-screen and copy fixes)

Definition checked: tables 1-10, no zeros table, a fact and its flip count once, squares included once. 55 = all such facts; 36 = those with no factor of 1 or 10 (that is, tables 2-9).

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "one times one up to ten times ten. A hundred boxes." / `1 × 1 to 10 × 10 = 100 boxes` | VERIFIED | py: 100 ordered pairs | None |
| 2 | "three times seven and seven times three are the same fact, flipped." / `3 × 7 = 7 × 3 = 21` | VERIFIED | Commutative property; py | None |
| 3 | "Count each pair once, and a hundred becomes fifty-five." / `Each pair once: 55` | VERIFIED | py: 55 unordered pairs = 10 squares + 45 flipped pairs | None |
| 4 | "Times one stays the same." / `× 1 stays the same`, `1 × 7 = 7` | VERIFIED | Identity | None |
| 5 | "Times ten puts a zero on the end." / on-screen **`× 10 adds a 0`** | VO VERIFIED (whole numbers); on-screen WORDING FIX | py: true for every product in the table. But "adds a 0" literally means "+ 0", which changes nothing; it's the phrase math teachers most often correct, and it doesn't match the VO | Change the callout to the VO's words: `× 10 puts a 0 on the end` (6 words, within 7) |
| 6 | "Now set aside the ones and the tens … That leaves thirty-six." / `55 − 19 = 36`, `36` | VERIFIED, but `19` unexplained | py: 10 facts with a 1, 10 with a 10, 1 × 10 in both, so 10 + 10 − 1 = 19; 55 − 19 = 36 = unordered pairs from 2-9. A viewer who counts "ten ones facts and ten tens facts" gets 20 and thinks the card is wrong | Either drop the `55 − 19 = 36` card (the code-driven counter already shows 55 → 36) or show `10 + 10 − 1 = 19` first. Dropping is simpler |
| 7 | Hook A "your kid doesn't have a hundred times-table facts to learn"; hook B "about half the size it looks" | VERIFIED (under the definition) | py: 55 of 100 | None |
| 8 | Title "The Times Table Is 55 Facts, Not 100 (Here's Why)" | NEEDS SCOPE | "The times table" unscoped: many US schools go to 12 × 12 (78 facts, py) and some include 0s (66, py). A teacher in a 12s district comments "wrong" | Scope it: "The 1-10 Times Table Is Only 55 Facts, Not 100" (46 chars; payload in the first 40). Description and caption already say "1-10" |
| 9 | Visual 25-29 s "the grid flickers back to full for the loop" | NOTE (render) | Script standards §4 / render gate: nothing flashes more than 3 times a second | Make it one fade or cut, not a flicker |

Claims list: complete. The "X, not Y" in hook A text and the title ("Not 100 facts. 55.") is one reframe, used once across the piece; fine.

Math recomputed (python3 -I, 2026-10-27):
```
ordered 100 unordered 55 squares 10 pairs a<b 45
unordered containing 1 or 10: 19 remaining 36
2-9 unordered: 36
with 1: 10, with 10: 10, both (1x10): 1
3x7 == 7x3 == 21: True; 1x7 = 7; 10x7 = 70; 55-19 = 36
x10 appends a zero for every product in the 1-10 table: True
0-10 table: 66; 1-12 table: 78; distinct products in 1-10: 42
```
All listed math strings are correct. Word count recomputed: 72 (claimed 72), 2.48 words/s over 29 s, budget 72.5. Title (current) 49 chars; proposed 46.

Sense read:
- **Math teacher:** the counting is right, and showing the definition on screen is the right call. My corrections would be rows 5 (adds a 0), 6 (why 19) and 8 (which table). Also expect "your kid still has to *know* 7 × 3 is 3 × 7"; the VO's "same fact, flipped" handles that.
- **Parent:** the relief message lands ("55, then 36"). Calm, no pressure language.
- Someone may comment "there are only 42 different answers". True (py) and harmless; not worth a line.
- The treatment correctly avoids tying "55" to Fire Trail.

Compliance (§A-H):
- A: PASS. "Parents," first word; math cards only; parent/teacher/homeschool hashtags.
- B: no app claims. PASS.
- C: YouTube no (own clone, code animation); Facebook yes. PASS.
- D: caption question "Which fact is the sticking point at your house?" is genuine. PASS.
- E: game's own music/SFX. PASS.
- F: code-rendered. PASS.
- G: n/a. PASS.
- H: no CTA, `/fb012` first comment. PASS.

Voice (§11): adult address, one idea, zero em-dashes, one reframe. PASS.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
