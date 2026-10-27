# MD-003: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS WITH FIXES** (one wording error the video's own "correct" brand can't carry: "non-science part")

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Einstein did not fail math | TRUE | TIME, Isaacson, "Making the Grade", 2007-04-05 (fetched): "'I never failed in mathematics,' he replied, correctly." Wikipedia "Albert Einstein" (fetched) | none |
| 2 | In 1896 he finished school in Switzerland | TRUE | Wikipedia: Matura "awarded to him in September 1896", Argovian cantonal school, Aarau | see sense read (it's the Aarau school, after the failed exam) |
| 3 | Six was the top grade; he got sixes in algebra and geometry | TRUE (incomplete, fine) | Wikipedia certificate caption "6 = very good ... 1 = very poor"; "top grade of 6 for history, physics, algebra, geometry, and descriptive geometry" | none required |
| 4 | In 1935 a rabbi in Princeton showed him a Ripley's Believe It or Not clipping | TRUE | TIME (fetched): "In 1935, a rabbi in Princeton showed him a clipping of the Ripley's column" | none. Note: TIME dates the showing, not the column; Appendix B's "1935 Ripley's column" is looser than the source. The script correctly says "showed him... in 1935" |
| 5 | Headline "Greatest living mathematician failed in mathematics" | TRUE | TIME quotes it verbatim | none |
| 6 | Reply "I never failed in mathematics." | TRUE | TIME, direct quote | none |
| 7a | At 16 he failed a university entrance exam in Zurich | TRUE (simplified) | Wikipedia: 1895, age 16, Swiss Federal Polytechnic; MacTutor: "In 1895 Einstein failed an examination..." "University" for the Polytechnic (today ETH Zurich) is an acceptable simplification | optional: "entrance exam for a Zurich college" |
| 7b | "He fell short on the general, **non-science** part." (VO) | **NOT SUPPORTED, likely wrong** | Wikipedia's term is "the general part of the test". Secondary accounts of its subjects include zoology, botany and/or chemistry alongside French and literature, i.e. science subjects; Reiser (1930, via arXiv 1205.4335) says inadequate results "in linguistic and historical ones". No fetched primary source supports "non-science". Appendix B's "non-science sections" is the origin of the error | Change VO to "He fell short on the general part, things like languages." or simply "He fell short on the exam's general part." On-screen "General part: failed" is fine as is |
| 8 | In math and physics he did very well | TRUE | Wikipedia: "performed with distinction in physics and mathematics" | none |
| 9 | He went to school in Aarau, then got into that same Zurich school, and graduated in 1900 | TRUE | MacTutor: attended secondary school at Aarau "planning to use this route to enter the ETH"... "graduating in 1900 as a teacher of mathematics and physics"; Wikipedia: enrolled 1896 at 17 | none |
| 10 | "One bad exam at sixteen didn't decide his story." | OK (framing) | follows from 7-9 | none |
| 11 | Tallyclaw "was there" | OK (conceit, changes no fact) | brand §4.2 | none |
| 12 | "So where did the story come from?" answered with the 1935 clipping | **OVERSTATED** | TIME reports the anecdote; it doesn't establish Ripley's as the myth's origin, and other origin stories (the grading-scale confusion, which the treatment rightly cut) circulate. Appendix B's "traced to" is our research summary, not a primary finding | Soften: "So where did the story come from? One famous version: in 1935, a rabbi..." or "It was already going around by 1935, when a rabbi..." |
| 13 | (missing from list) Hook B: "the man who supposedly failed math got the top grade in algebra" | TRUE | as 3 | add if Hook B is picked |
| 14 | (missing from list) Description: "at 16 he did fail part of an entrance exam. Just not the math." | TRUE | as 7a/8 | add to claims list |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-003: Einstein dates
ETH entrance exam: 1895, age at year-end 16
Aarau Matura: 1896, age at year-end 17
ETH diploma: 1900, age at year-end 21
Ripley's clipping shown: 1935, age at year-end 56
exam Oct 1895: age 16? True
Matura scale 1..6, top= 6
sequence 1895<1896<1900<1935: True
MD-003: 54 chars, 40<=len<=65: True | Einstein didn't fail math. Here's what really happened
   first-comment paths: {'playmathdragons.com/fb003'}
   hashtags: #parenting #homeschool #teachers count 3
```
(Born 14 March 1879; the exam was in October 1895, so 16 is right.) Word count 139, as stated (per-beat 2.0-2.56 w/s, realistic; 60 s total). Em-dashes: 0. X/Y reframes: 0. Strings `1896`, `Top grade: 6`, `Algebra: 6`, `Geometry: 6`, `1935`, `Age 16`, `1895`, `Graduated 1900` all match the sources.

Sense read:
- As a math teacher: the "non-science" line is the one I'd correct in the comments (the general part reportedly included zoology and botany). Fix 1.
- Chronology: the script presents the 1896 sixes first, then the 1895 failure, then "He went to school in Aarau". A viewer can easily think these are two different schools and that the failure came after the sixes. They are the same school, and the sixes were earned *after* the failure, which is the better story. Fix 3.
- Possible missing context: commenters often say he sat the exam younger than usual. I could not confirm a usual entry age in a fetched source (Wikipedia gives only "at the age of sixteen"; the TIME piece doesn't cover the exam), so don't add it without a source.
- As a parent: calm, clear, a nice "one bad exam" takeaway. Nothing is said to a child.

Compliance (§A-H):
- A Made for Kids: PASS. "Parents" first spoken word; Tallyclaw as still art, text addressed to the parent; parent/teacher/homeschool hashtags. Animated character, so re-read §A at upload (noted).
- B Claims: PASS. No app claim; history claims sourced (after fix 1).
- C AI disclosure: PASS (YouTube no: illustration, no realistic depiction of Einstein; Facebook yes).
- D Engagement bait: PASS. "Where did you first hear the myth?" is genuine.
- E Audio: PASS (game soundtrack).
- F Visuals/IP: PASS. Recreated certificate and clipping in our own layout; no Ripley's logo or art; Einstein only in flat style if at all.
- G Privacy: PASS.
- H Links/CTA: PASS (no CTA; corner mark). Cross-cutting: the description's "Free beta" and the first comment's "Free beta for iPhone, iPad and Android" are untrue until LAUNCH-CHECKLIST §7-§9 are done, and `/fb003` only resolves after `website/phase-2` is deployed.

Fixes:
1. **Required.** 31-41 s VO: replace "He fell short on the general, non-science part." with "He fell short on the exam's general part." (or "...the general part, things like languages."). Update claims list 7 and the Concept line ("general, non-science part") to match. Also correct Appendix B's "non-science sections" wording at its next edit (Justin's call; it's the research report).
2. **Required.** 15-24 s: soften the origin claim: "So where did the story come from? One famous version: in nineteen thirty-five, a rabbi in Princeton showed him a Ripley's Believe It or Not clipping." (+3 words; still about 2.9 w/s in 9 s, so trim "Believe It or Not" from the VO and keep it on screen, or take a second from the 53-57 s beat.)
3. Recommended. Make the chronology explicit at 45-53 s: "He went to school in Aarau, where he earned those sixes, then got into that same Zurich school and graduated in nineteen hundred." Re-time (about 22 words in 8 s is fast; take 1-2 s from the awe beat).
4. Optional, only with a fetched primary or reputable source for the usual entry age: mention that he sat the exam younger than usual. Otherwise leave it out.
5. Claims list: add Hook B and the description line; record the Isaacson TIME date (2007-04-05) and that the column's own date is unknown.

Justin sign-off:

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
