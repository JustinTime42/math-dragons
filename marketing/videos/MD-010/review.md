# MD-010: review

## Script gate (2026-10-27, independent reviewer: Claude agent, no authoring context)

Verdict: **PASS WITH FIXES** (one required sense fix: the chain never reaches the hour)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | "It took about three thousand years." | VERIFIED | Sci Am (fetched 2026-10-27): Egyptian sundial "As early as 1500 B.C."; minute-displaying clocks "near the end of the 16th century". py: 1500 BCE to 1590 CE = 3,089 years | None |
| 2 | "About thirty-five hundred years ago, they split the daylight into twelve parts, and the night into twelve more." | VERIFIED | Sci Am: sundial "calibrated to divide the interval between sunrise and sunset into 12 parts"; night "marked by the remaining 12 stars, again resulting in 12 divisions of night". py: 1500 BCE to 2026 = 3,525 years | None |
| 3 | On-screen "Egypt: 12 + 12 = 24" | VERIFIED (with the caveat the treatment notes) | Same. These were seasonal, unequal hours; Hipparchus "proposed dividing the day into 24 equinoctial hours" (Sci Am). The script doesn't claim they were equal | None |
| 4 | "The sixty comes from Babylon. Their astronomers counted in sixties." | VERIFIED (as transmission) | Sci Am: "The Babylonians made astronomical calculations in the sexagesimal (base 60) system they inherited from the Sumerians"; A#3. Greek astronomy did take its sexagesimal fractions from Babylonian astronomy, so "comes from Babylon" is right as the route. It could be heard as "Babylon invented it", which brand §4.4 warns about; "Nobody knows for sure" at 41 s softens it | Optional: "The sixty came by way of Babylon. Their astronomers counted in sixties." (+2 words) |
| 5 | "Greek astronomers borrowed that to cut each degree of a circle into sixty parts, and each part into sixty more." | VERIFIED | Sci Am (Ptolemy): "Each degree was divided into 60 parts, each of which was again subdivided into 60 smaller parts." | Map label: Ptolemy worked in Alexandria (Roman Egypt). Label the stop "Greek astronomers", not a pin on Greece, so no historian can say we put him in the wrong country |
| 6 | "In Latin, the first small part became the minute. The second became, well, the second." / on-screen "pars minuta prima", "pars minuta secunda" | VERIFIED | Wikipedia "Minute" (etymology): *pars minuta prima* "first small part"; "second small part" (*pars minuta secunda*). Sci Am uses the plural *partes minutae primae / secundae*. Both forms are attested; the singular matches "the first small part" in the VO | None. Keep the singular |
| 7 | Implied: the hour got the same 60 and 60 split | **GAP (sense)** | The script explains why a *degree* has 60 minutes, then jumps to clocks. It never says the hour got the same split. Historically that happened later: Wikipedia "Minute": al-Biruni "first subdivided the hour sexagesimally into minutes, seconds, thirds and fourths in 1000 CE"; Roger Bacon 1267. Sci Am: "the hour was not commonly understood to be the duration of 60 minutes" until clocks showed minutes | **Required:** add a no-date bridge before the clock line, e.g. "Later, hours got the same split." (6 words). Budget: drop "even" from "Clocks didn't even show minutes" and from "A hundred won't even split into thirds" (−2), so the total is 137 words, inside the 137.5 budget for 55 s |
| 8 | "Clocks didn't even show minutes until the late fifteen hundreds." / "Minute hands: late 1500s" | VERIFIED | Sci Am: "The first mechanical clocks that displayed minutes appeared near the end of the 16th century." Wikipedia "Minute": Jost Bürgi's clock for Tycho Brahe, 1577, the first minute hand. A search for an earlier claim (a 1475 manuscript) found nothing that supports it | None |
| 9 | "Why sixty? Nobody knows for sure." | VERIFIED | A#3 caveat ("Why 60 was chosen is debated") | None |
| 10 | "Sixty splits evenly by two, three, four, five and six." | VERIFIED | py: divisors of 60 = 1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60 | None |
| 11 | "A hundred won't even split into thirds." / `100 ÷ 3 = 33.33…` | VERIFIED | py: 100 mod 3 = 1; 100/3 = 33.333… The on-screen decimal makes "evenly" clear | None |
| 12 | "Whoever picked sixty knew their business." | OK | Joke premise: 60 is convenient; no inventor named. Consistent with "Nobody knows for sure" | None |
| 13 | "Tallyclaw says he was there." | OK | Character device; bends no fact | None |
| 14 | Title, description ("about 3,000 years: Egypt, Babylon, Greek astronomers, then clocks"), caption ("a 3,000-year answer") | VERIFIED | As 1-8 | None |

Claims list: complete for VO and copy. Add the map visual (row 5) so the render gate checks the labels.

Math recomputed (python3 -I, 2026-10-27):
```
12+12 = 24
divisors of 60: [1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60]
60/2 = 30, 60/3 = 20, 60/4 = 15, 60/5 = 12, 60/6 = 10
100/3 = 33.333333333333336, remainder 1; divisors of 100: [1, 2, 4, 5, 10, 20, 25, 50, 100]
60*60 = 3600
1500 BCE -> 2026 CE: 3525 years (no year 0); 1500 BCE -> 1590 CE: 3089 years
```
All math strings correct. Word count recomputed: 133 (claimed 133), 2.42 words/s over 55 s. After the row 7 fix: 137. Title "Why an Hour Has 60 Minutes (the Real History)" = 45 chars.

Sense read:
- **Skeptical parent:** the story is clear and the "nobody knows for sure" honesty helps. The one thing I'd notice: "so that's why a *circle* has minutes; what about the hour?" Row 7 fixes it.
- **Math teacher / historian:** happy with Egypt → Babylon (as a route) → Greek astronomers → Latin → clocks. "pars minuta prima" is correct. Would object to anything implying Babylon invented base 60 (it doesn't, but see row 4's optional wording) or to Ptolemy pinned on Greece (row 5).
- Tallyclaw appears as still art with the Narrator reading for him, which F4 allows until the puppet exists. His bubble line is dry, aimed at adults, at nobody's expense.

Compliance (§A-H):
- A: PASS. "Parents, when your kid asks…" first line; a parent's question; Tallyclaw addresses nobody directly and invites no child. Parent/teacher/homeschool hashtags only.
- B: no app claims. PASS.
- C: YouTube no (own clone, illustration clearly unrealistic); Facebook yes. PASS.
- D: caption question "What's the hardest 'why' question your kid has asked you?" is genuine. PASS.
- E: game's own music/SFX. PASS.
- F: no realistic or named person depicted; no invented cuneiform; no text in AI images. PASS.
- G: n/a. PASS.
- H: no CTA, corner mark only, `/fb010` first comment. PASS.

Voice (§11): adult address, one idea, zero em-dashes, zero X/Y reframes. PASS.

Justin sign-off:

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
