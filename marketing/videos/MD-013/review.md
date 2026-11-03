# MD-013: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (claims-list additions only; no script change required)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "one of math's most famous numbers" | OK (opinion) | Widely known, largely through Google | None; "a famous number" is a safe fallback if anyone objects |
| 2 | "Mathematician Edward Kasner" | VERIFIED | MacTutor Kasner biography (fetched 2026-10-27) | None |
| 3 | "asked his nine-year-old nephew … to name a really big number" | VERIFIED (age, relationship); "Kasner asked" is ours | MacTutor quoting *Mathematics and the Imagination* (Kasner & Newman, 1940): the name was invented by "a child (Dr Kasner's nine-year-old nephew) who was asked to think up a name for a very big number, namely, 1 with a hundred zeros after it." The book is passive about who asked. Since Kasner co-wrote the book and it's his nephew, "Kasner asked" is the natural reading and is how secondary sources tell it | None required. Most literal alternative if Justin wants zero inference: "Edward Kasner's nine-year-old nephew, Milton Sirotta, was asked to name a really big number" |
| 4 | Name "Milton Sirotta" | VERIFIED (secondary) | MacTutor doesn't name him. Wikipedia "Googol" (1911-1981); Appendix A #21 (HIGH) | None |
| 5 | "a one with a hundred zeros after it" / `10¹⁰⁰` / `googol = 10¹⁰⁰` | VERIFIED | Book via MacTutor; py | None |
| 6 | "Milton called it a googol." | VERIFIED | As 3 | None |
| 7 | "He named a bigger one too, the googolplex." | VERIFIED | MacTutor/book: "At the same time that he suggested 'googol' he gave a name for a still larger number: 'Googolplex.'" | None |
| 8 | "The first idea for it: a one, followed by writing zeros until you get tired." | VERIFIED | Book: "It was suggested that a googolplex should be 1, followed by writing zeros until you get tired." The script doesn't say who suggested it. Wikipedia "Googolplex" credits that first definition to Milton; the book's passive wording doesn't say. Leaving it unattributed is the cautious choice | None |
| 9 | "It was later pinned down as a one followed by a googol zeros." / `googolplex = 10^googol` / `1 followed by a googol zeros` | VERIFIED | MacTutor's transcription of the book: "The googolplex then, is a specific finite number, with so many zeros after the 1 that the number is a googol." Read literally that sentence is garbled (the number of *zeros* is a googol; I believe the printed book says so but could not fetch the book text to confirm). Wikipedia "Googolplex" (fetched 2026-10-27) gives the standard definition 10^googol = 10^(10^100), a 1 followed by a googol zeros, which is what the script says | In the claims list, cite the standard definition (Wikipedia "Googolplex") beside the MacTutor quote, so a later reviewer doesn't trip on the transcription |
| 10 | "And Google's name? A play on googol." / "googol → Google" / title "…and Google Borrowed It" | VERIFIED (primary) | about.google/our-story (fetched 2026-10-27): "The name was a play on the mathematical expression for the number 1 followed by 100 zeros". Brin & Page (1998) also say they chose Google "because it is a common spelling of googol" | None. "Borrowed" is fair for a play on the word; the fallback title in the treatment is fine if Justin prefers |
| 11 | No year stated | CORRECT | 1920 isn't in the primary source (idea-bank.review I-089) | None |
| 12 | "Tallyclaw approves of this one." / "Tallyclaw is still jealous he didn't name it." | OK | Character devices aimed at his own vanity | None |
| 13 | Speech bubble "Nine. I've named nothing that good." | OK, **not in claims list** | Joke premise (his vanity); no fact | Add to claims list |
| 14 | Hook B "Google's name started with a number, and a nine-year-old named it." | OK, **not in claims list** | Covered by 6 and 10 | Add to claims list |

Math recomputed (python3 -I, 2026-10-27):
```
str(10**100): length 101, leading '1', 100 zeros, nothing else after the 1: True
zeros in rows of 20: 5 rows
```
`googol = 10¹⁰⁰`, `10¹⁰⁰`, `googolplex = 10^googol`, `1 followed by a googol zeros`, `Named by a 9-year-old`, `nephew Milton, 9` all correct. Word count recomputed: 96 (claimed 96), 2.40 words/s over 40 s, budget 100. Title "A 9-Year-Old Named the Googol, and Google Borrowed It" = 53 chars.

Sense read:
- **Skeptical parent:** delightful and accurate; nothing to roll eyes at. The only line a pedant might poke is "one of math's most famous numbers" (opinion; fine).
- **Math teacher:** definitions are exact. Good that the zeros are generated from code in countable rows of 20, and that googolplex is never written out.
- The speech bubble (row 13) and the VO (row 12) say different jokes at the same moment. Viewers read the bubble and hear the VO at once; consider making the bubble match the VO or cutting one. Production call, not a fact issue.

Compliance (§A-H):
- A (Made for Kids): PASS, with care. A story about a nine-year-old is kid-appealing, but it's told to parents ("Parents," first word), no child is depicted (Milton is a text card only), Tallyclaw speaks to nobody, and hashtags are parent/teacher/homeschool. The caption question ("Has your kid ever invented a name for a giant number?") is to the parent. OK.
- B: no app claims. PASS.
- C: YouTube no; Facebook yes. PASS.
- D: genuine question; no bait. PASS.
- E: game's own music/SFX. PASS.
- F: "Google" as text only, no logo or brand colors; no person depicted. PASS.
- G: no real child shown (Milton is a historical figure, named as a text card; that's fine). PASS.
- H: no CTA, `/fb013` first comment. PASS.

Voice (§11): adult address, one idea, zero em-dashes, zero X/Y reframes; Tallyclaw stays dry and self-deprecating. PASS.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
