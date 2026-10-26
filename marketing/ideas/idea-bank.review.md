---
status: review complete (awaiting Justin)
doc: idea-bank.review
reviewed: marketing/ideas/idea-bank.md (draft, 2026-10-26)
reviewer: independent agent (no authoring context), 2026-10-26
method: marketing/README.md "Accuracy and sense review"; guides/fact-check-protocol.md; guides/idea-scoring-rubric.md
---

# Idea Bank: Independent Review

## Verdict: PASS WITH FIXES

The bank is sound. Every score total matches the weights, every tier matches its total, the coverage counts are right, and all puzzle answers recompute correctly. The gates were applied carefully: the dropped list is right, and so are the adaptivity tags except for one.

It is not clean, though. I found **2 wrong facts** (I-041's "exact example the standard uses", I-099's "six decimal places") and **1 rule that is false as stated** (I-030). There is **1 gate failure** on app claims (I-110 publishes a number that is not a §2.1 claim). About 20 ideas need a caveat before scripting. Three of the caveats hit the suggested first batch (I-041, I-083, I-089). All three can be fixed in the treatment, so the first batch can stand with edits.

## 1. Issues

Verdicts: **WRONG** (the fact as written is false), **NEEDS CAVEAT** (true only with a qualifier, or the visual or wording misleads), **GATE FAIL** (fails G1-G5 as written), **SCORE ISSUE**.

### 1a. Facts and math

| ID | Problem | Verdict | Evidence | Fix |
|---|---|---|---|---|
| **I-041** (first batch) | Says 8 + 5 is "the exact example" in Common Core 1.OA.C.6. It isn't. The standard's making-ten example is **8 + 6 = 8 + 2 + 4 = 10 + 4 = 14**. `format-library.md` F3 makes the same error, so the bank inherited it. | WRONG | thecorestandards.org/Math/Content/1/OA/ (1.OA.C.6, fetched 2026-10-26): examples are 8 + 6, 13 - 4, 8 + 4 = 12 → 12 - 8, 6 + 7. | Either use 8 + 6 = 14 and say "the example in the standard itself", or keep 8 + 5 and say "the standard names this strategy, 'making ten'". Fix `format-library.md` F3 too (a guide change, so Justin's call). |
| **I-099** | "right to about six decimal places" is wrong. 1;24,51,10 = 1.4142130 and √2 = 1.4142136. They agree to **five** decimal places (1.41421), and rounded to six places they differ (1.414213 vs 1.414214). Appendix A says "six decimal *digits*", which is a different claim. | WRONG | py: 1.414212963 − 1.414213562 = −6.0e-7. | "Right to about six digits (1.41421)" or "five decimal places". |
| **I-030** | "6 times an even number ends in that same digit, and the tens digit is half of it" is only true for 2, 4, 6, 8. The ones-digit part holds for every even number. The half part fails from 10 up: 6 × 10 = 60, 6 × 12 = 72. A math teacher will comment on it. | WRONG (as a general rule) | py over n = 2..14 (see §5). | Scope it on screen: "6 × 2, 4, 6 or 8". Lower A from 5 to 4 (total 51, B). |
| **I-033** | The rule "multiply the upper fingers for the ones" breaks for 6 × 6 (upper 4 × 4 = 16) and 6 × 7 (3 × 4 = 12). You have to carry, so writing the digits side by side gives 216 and 312. The trick works for all 25 pairs only if the two parts are *added* (tens × 10 + product). | NEEDS CAVEAT | py: the method is correct for all 25 pairs; the carry cases are (6,6) and (6,7). | Script says "add them" with a math card (20 + 16 = 36). Or demo only pairs with no carry and say so. |
| **I-080** | "reached Europe through Fibonacci's *Liber Abaci*" overstates it. Hindu-Arabic numerals were already known in Europe before 1202 (for example the Codex Vigilanus, 976). Fibonacci *popularized* them, which is the wording Appendix A #13 uses. | NEEDS CAVEAT | Appendix A #13 ("popularized"); MacTutor Fibonacci. | "...and were popularized in Europe by Fibonacci's *Liber Abaci* (1202)." |
| **I-083** (first batch) | "Why an hour has 60 minutes: Babylonian base 60" hands a kid's question a one-cause answer that historians would correct. The *hour* (12 + 12 parts of the day) is Egyptian. 24 equal hours come from Hipparchus. The 60-part "minute" and "second" come from Ptolemy splitting the *degree* with Babylonian base-60 fractions. Clocks only showed minutes from the late 1500s. "Babylonian base 60 survives in 60 minutes" is fine as a legacy claim (A#3, MacTutor). Saying Babylon *answers why the hour has 60 minutes* is the simplification that misleads. This is the same base-60 territory the README warns about. | NEEDS CAVEAT | Scientific American, "Why is a minute divided into 60 seconds..." (Egyptian sundials c. 1500 BCE; Hipparchus' equinoctial hours; Ptolemy's *Almagest* divides degrees into 60 and 60 again; minute-hand clocks late 16th c.); A#3. | Script chain: "Egypt split the day into hours. Babylon counted in sixties. Greek astronomers used those sixties to cut circles into minutes and seconds, and clocks borrowed them much later." Keep the 2, 3, 4, 5, 6 divisors line (true; py). A should be 3-4, not 4 (see §3). |
| **I-089** (first batch) | "in 1920" isn't in the primary source. Kasner and Newman (*Mathematics and the Imagination*, 1940) say only that his "nine-year-old nephew" named it. 1920 comes from Wikipedia (secondary), and some popular accounts give a later year. | NEEDS CAVEAT | MacTutor Kasner (quotes the 1940 book: "Dr Kasner's nine-year-old nephew"); Wikipedia Googol (1920). | Drop the year: "Mathematician Edward Kasner's nine-year-old nephew, Milton Sirotta, named it." Google's name plays on "googol" (fine). |
| **I-098** | (1) The planned visual "3 4 5 glowing" on Plimpton 322 shows something the tablet doesn't contain. Its first row is the triple 119, 120, 169. (2) c. 1800 BCE vs Pythagoras (c. 570-495 BCE) is about 1,200-1,300 years, so "about 1,000 years" understates it. A#5 says "~1,000"; that's harmless but loose. | NEEDS CAVEAT | py: 119² + 120² = 169² = 28561; MacTutor Babylonian Pythagoras. | Show 119, 120, 169 (or a schematic tablet with no numbers). Say "more than 1,000 years before Pythagoras". |
| **I-023** | "Islamic, Indian and Renaissance European": the earliest documented lattice method is Ibn al-Banna (Maghreb, late 13th c.) and the earliest European one is an English treatise c. 1300 (medieval, not Renaissance). The Indian link rests on one mention (a *Lilavati* commentary). It is often wrongly credited to Fibonacci or al-Khwarizmi. | NEEDS CAVEAT | Wikipedia "Lattice multiplication" (history section); Napier's bones 1617 is fine. | "Used for at least 700 years, in the Islamic world and in medieval and Renaissance Europe, and the idea behind Napier's bones (1617)." Drop "Indian" unless sourced. |
| **I-022** | "there's no clear evidence it's from Japan" is a claim about the evidence, and our notes have no source for it. AppB: "(no reliable source found)". F2's own rule: "origin unknown" needs a source. | NEEDS CAVEAT | Playbook evidence table "origin unknown"; AppB. | Say "often called Japanese multiplication" (the name is checkable) and skip the origin beat, or source it first. |
| **I-050** | (1) WeAreTeachers is verified (Kimmie Fink, M.Ed., 2023-02-16) but it's tier 4. (2) The claim "the odd strategies aren't in the standards" is overstated. The standards *do* name making ten (1.OA.C.6) and area models (4.NBT.B.5). What they don't do is dictate methods or worksheets. | NEEDS CAVEAT | WeAreTeachers article (fetched); CCSS FAQ (primary): the standards "do not dictate how teachers should teach" and "are not curricula". | Cite the CCSS FAQ as primary: "The standards say what kids should learn, not how teachers must teach it." Drop "aren't in the standards". This clears `needs:fresh-source`; A can go from 2 to 3. |
| **I-055** (first batch) | The data checks out (Poletti et al., *Child Development* 2024: Experiment 1, non-finger users at pre-test, 37.3% → 77.1% vs control 39.6% → 47.8%; training was given to whole classes). But the hook "if your kid still counts on their fingers, good" is aimed at a 5-12 audience, while the same idea says kids who dropped fingers by about 7.5 did best. "Good" for a 10-year-old isn't supported. | NEEDS CAVEAT | PMC11693818 (fetched); The Sector 2025 (secondary, MODERATE). | Scope the hook to young kids: "If your five- or six-year-old counts on their fingers, good." Keep the two studies separate on screen. |
| **I-056** | "Any board game with numbered squares in a straight line helps young kids": the samples were small groups of low-income preschoolers (4-5), measuring number-line estimation and related skills. That's too broad for a 5-12 channel. | NEEDS CAVEAT | Evidence table "HIGH (small samples)"; Siegler & Ramani 2008. | "In studies with preschoolers, a simple 1-10 race game improved number sense." |
| **I-024, I-042, I-043, I-044, I-045, I-046, I-051, I-059** | WWC "Strong" is accurate: the 2021 summary rates all six recommendations Strong (Rec 3: 28 studies, Rec 4: 14, Rec 6 timed activities: 27). But the guide is *Assisting Students Struggling with Mathematics: Intervention in the Elementary Grades* (K-6, kids with low scores). A "why teachers teach it" beat that implies it covers all kids overstates the evidence. | NEEDS CAVEAT | WWC 2021006 summary PDF, "Summary of Evidence by Recommendation" (fetched; text extracted). | Wording: "In studies of kids who needed extra help, pictures like this worked well." |
| **I-058** | Partly verified. AAP's 2026 policy ("Digital Ecosystems, Children, and Adolescents", *Pediatrics*, Feb 2026) gives no hour figure for school-age kids, and HealthyChildren.org still recommends a Family Media Plan. I haven't read the exact policy text. The hook "changed this year" will be wrong after December 2026. | NEEDS CAVEAT | healthychildren.org AAP 2026 news page; EdSurge 2026-02-05. | Keep `needs:fresh-source` until the *Pediatrics* text is read. Say "in 2026", not "this year". |
| **I-087, I-088** | Etymonline and Merriam-Webster both return 403 to automated fetches. Wiktionary agrees (digit < Latin *digitus*; eleven < Proto-Germanic *ainalif* "one left"), but Wiktionary is tier 4. | NEEDS CAVEAT | Wiktionary "digit", "eleven" (fetched). | Justin checks Etymonline or OED by hand before scripting (the Appendix A note still applies). The substance looks right. |
| **F1 puzzles: I-004, I-005, I-006, I-009, I-012, I-013, I-015** | Each is labeled "Common wrong" with no source. The bank's own legend says unsourced ones should say "tempting wrong", and F1 part 2 opens with "A very common answer is...", which is itself a claim. The CRT-based ones (I-001 widgets 100 min, I-002 bat-and-ball 10, I-003 lily pads 24) and I-016 have documented wrong answers. | NEEDS CAVEAT | Bank legend ("Reading the table"); format-library F1 part 2. | Use "a tempting answer is..." in part 2 for every unsourced puzzle. |
| **I-014** | The tempting-wrong explanation is garbled: "11" doesn't follow from "forgetting the 90s". | NEEDS CAVEAT (minor) | py: 20 is correct. | Use 19 (forgetting 99 has two nines) and 10 (counting only ones digits). |
| **I-104** | The lesson is "odd + odd is even", but Dragon's Feast sorts single numbers as even or odd. It never tests sums. F6: "Say only what the app does." | NEEDS CAVEAT | `category_system.dart` (even/odd predicates on single n > 0). | VO payoff: "...and in Dragon's Feast she sorts even and odd numbers," not "practices this rule". |

### 1b. Gates and app claims

| ID | Problem | Verdict | Evidence | Fix |
|---|---|---|---|---|
| **I-110** | Plans to publish "weak facts never make up more than 40% of a session". That's spec §1 *goal 3*, not a §2.1 claim. Only §2.1 wording is publishable, and verbatim. It also implies a precision that parents will read as a guarantee. | GATE FAIL (G3) | `docs/specs/adaptive-practice.md` §2.1 (C1-C5), §1. | Drop the 40% line. Use C2 verbatim ("mixed in with facts your kid already knows"), which is true after Phase 2 for Fire Trail. C4 for "all four" after Phase 6. |
| **I-117** | Tagged `needs:adaptive-P2`, but "adaptation happens inside a level" with no game named implies all games. That's C4 (Phase 6). | NEEDS CAVEAT | spec §2.1, §10. | Name Fire Trail only (P2), or retag `needs:adaptive-P6`. |
| **I-118** | "Delete the app and progress is gone, and it doesn't follow your kid to another device" isn't reliably true. Hive lives in the app documents directory (`Hive.initFlutter()`, `lib/storage/local_storage.dart:39`), which iCloud device backup includes. The Android manifest doesn't set `allowBackup="false"`, so Android Auto Backup is on by default. A restore or new-phone transfer can bring progress back. The website review already flagged the same issue for the founding-tester flag (`pages-v1.review` I14). | NEEDS CAVEAT | `android/app/src/main/AndroidManifest.xml` (no backup attributes); `local_storage.dart`. | "There's no account, so there's nothing to log into on a new device. Progress lives on the phone or tablet (and in its backup, if you use one)." Or set backup rules first. |
| **I-119** | "every move in the games is an answer" overstates it. Flying in Fire Trail and moving around the board in Feast aren't answers. Eating a gem or a tile is. | NEEDS CAVEAT | `lib/games/*`. | "The math *is* the action: you answer by eating the right gem." |
| **I-112** | "ask why a kids' app would [need internet]" hints that online apps are suspect. Many legitimate apps need a connection, so it reads as a veiled competitor dig (brand-and-voice §8: never punch at other apps). The offline claim itself is verified: no network packages, and build 1.0.3 has no Android INTERNET permission (`docs/RELEASES.md`). | NEEDS CAVEAT | `pubspec.yaml`; `RELEASES.md` 1.0.3. | Keep the useful lesson ("check which apps work offline before the flight") and drop the "ask why" jab. |
| **I-052 / I-066** | Same tip twice: short, calm, stop at the timer. | GATE FAIL (G5) | Both cite Ev: Parent transmission, same step. | Keep I-052. Fold back-to-school into I-052 as its calendar slot, or give I-066 a different step (a fixed time and place). |
| **I-034 / I-073** | Same pairing method (1 to 10 vs 1 to 100). One is framed as a trick, one as the legend. | NEEDS CAVEAT (G5 borderline) | | Fine as a pair; never in the same cycle. Better: I-073 links to I-034 as its follow-up. |
| **I-004 / I-005** | Same off-by-one insight. The author dropped the tower-floors puzzle for duplicating them, but kept both. | NEEDS CAVEAT (G5 borderline) | Dropped list row 1. | Keep both but space them at least 3 cycles apart, or drop one for consistency. |
| **I-123 / I-125** | Two F8b "what you get" Shorts with heavily overlapping content. | NEEDS CAVEAT (G5 borderline) | | Make I-125 a later remake ("the beta, honestly", for after the first tester feedback), not a second launch Short. |
| **I-101** | 0.999... = 1 is unambiguous math, so G4 passes. But it's a famous comment-war topic, and "friendships end" invites the fight. | PASS, note | | In part 2 / replies, answer calmly with one proof. Don't seed the argument. |

Everything else passed G1-G5. No idea needs a child on screen or child-directed lines: all hooks address "Parents", and I-055's hands are illustrated, not a real child. No competitor is named, and the Prodigy and nostalgia drops were correct. All adaptivity ideas carry a `needs:adaptive-P#` tag, and each matches spec §2.1 (I-108 C2-FT P1, I-109 C3 P2, I-111 C5 P5, I-115/I-116 P1) except I-110 and I-117 above.

### 1c. Scores

All 125 totals recompute exactly from H×3, S×3, A×2, E×2, P×2, F×1, Fit×1. The tiers match the bands, and the coverage table (40/31/32/22; A 48, B 73, C 4), the format counts, the 82 dependency-free ideas, the 20 still-art ideas and the 15 calendar ideas all match (py, §5).

| ID | Problem | Verdict | Effect |
|---|---|---|---|
| I-020 | Our edge E = 3 for a finger trick that every math channel posts. Should be 2. | SCORE ISSUE (inflated) | 64 → 62, still A, still the top F2. |
| I-072 | E = 5 ("only Math Dragons could make it"). Einstein myth-busts are common; Tallyclaw is the edge, but only as still art. 4 is fairer. | SCORE ISSUE (mild) | 64 → 62, still A. |
| I-083 | A = 4 given the history nuance above. Should be 3 until the script is fixed. | SCORE ISSUE | 62 → 60, still A. |
| I-016 | E = 3 with no unique asset. 2 is fairer. | SCORE ISSUE (mild) | 63 → 61, still A. |
| I-030 | A = 5 for a rule that's false past 8. | SCORE ISSUE | 53 → 51, drops to B. Not in the batch. |
| I-099 | A = 5 with the decimal-places error. | SCORE ISSUE | 52 → 50 until fixed. |
| I-078, I-090 | Look slightly deflated relative to I-083. I-078's core fact is verified at primary level (Bartlett, Sibley & Sibley 2019, *Nexus Network Journal*: 80 Smithsonian shells, genus mean 1.310). | SCORE ISSUE (deflated, mild) | Good swaps for the first batch (§4). |
| I-050, I-103, I-065 | Fresh sources found (CCSS FAQ; Palais 2001 and Hartl 2010; Natural Math 2009). A can rise by 1 each. | SCORE ISSUE (deflated) | I-050 → 52 B; I-103 → 43 B; I-065 → 50 B. |

None of these changes the first batch's composition.

### 1d. Calendar dates (author's open item)

| Hook | Verdict | Evidence |
|---|---|---|
| Pi Day Mar 14; Larry Shaw, Exploratorium, 1988; US House resolution 2009 | VERIFIED | A#48 (Wikipedia) |
| International Day of Mathematics, Mar 14 (UNESCO) | VERIFIED | proclaimed by UNESCO in 2019, first held 2020 |
| Math and Statistics Awareness Month, April (US) | VERIFIED | JPBM (AMS, ASA, MAA, SIAM); week since 1986, month since 1999, renamed 2017 |
| Gauss, Apr 30 (1777) | VERIFIED | MacTutor Gauss |
| Tau Day, Jun 28 | VERIFIED | Hartl, *The Tau Manifesto* (2010); Palais, "π is wrong!", *Math Intelligencer* 23(3), 2001 |
| Katherine Johnson, Aug 26 (1918) | VERIFIED | MacTutor Johnson |
| Math Storytelling Day, Sep 25 | VERIFIED | Started 2009 by Maria Droujkova's Natural Math community (naturalmath.com) |
| Ada Lovelace Day, 2nd Tuesday of October | VERIFIED | findingada.com. 2026's was Oct 13 (passed); next is **2027-10-12** (py) |
| Fibonacci Day, Nov 23 | VERIFIED (date convention) | 11/23 = 1, 1, 2, 3 |
| Ramanujan, Dec 22 (1887); National Mathematics Day (India) | VERIFIED | Declared 2011, observed from 2012 |
| Thanksgiving 2026 = Nov 26 | VERIFIED | py (4th Thursday) |

## 2. First batch: verified and cleared

The app was checked against the installable build: `docs/RELEASES.md` lists 1.0.3 (8) at commit `28d6638`, and `git diff 28d6638 HEAD -- lib pubspec.yaml` is empty, so `main`'s `lib/` is the tester build.

| Slot | ID | Status | What was checked |
|---|---|---|---|
| 1-2 | I-016 Is zero even? | **CLEARED** | Definition (0 = 2 × 0). "Neither" as a common answer is documented: UK 7-year-olds were only 32% correct once "neither" was an option, and two-thirds of prospective teachers in a 1972 study said zero isn't even (Wikipedia "Parity of zero"). Part 2 says "a very common answer", never "most people". Correctly not tied to Feast: Feast's even category is `n > 0 && n % 2 == 0`. |
| 3 | I-072 Einstein didn't fail math | **CLEARED** | AppB HIGH (TIME; 1935 Ripley's). The inconvenient detail (non-science sections of the Polytechnic entrance exam, age 16) is included. |
| 4 | I-055 Fingers aren't cheating | **CLEARED WITH FIX** | Poletti et al. figures match the PMC text. Fix: scope the hook to 5-6-year-olds (§1a). |
| 5 | I-041 Make a ten | **CLEARED WITH FIX** | Math correct (py). Fix the 1.OA.C.6 claim (§1a). |
| 6 | I-113 Three questions before installing | **CLEARED** | No ads: `ad_manager.dart` is an empty stub and there's no ad SDK in `pubspec.yaml`. No accounts: no auth code or packages. The app collects no data: no network packages, no Firebase, no Android INTERNET permission in 1.0.3, and external links open the browser behind the parental gate (`external_links.dart`). Keep the "the app" scoping. Needs ordinary capture only. |
| 7 | I-020 9s finger trick | **CLEARED** | py: 9n = 10n - n, all n = 1..10. Origin beat skipped (correct). |
| 8 | I-083 Why 60 minutes | **CLEARED WITH FIX** | Divisors of 60 verified (py). Fix the causal chain (§1a). |
| 9 | I-053 Math-anxious parents | **CLEARED** | Maloney et al. 2015 (*Psych Science*): effect only with frequent homework help; MODERATE framing kept; "never stop helping" kept. |
| 10 | I-025 55, not 100 | **CLEARED** | py: 55 unordered pairs from 1-10 (with squares); 36 for 2-9. Definition: facts 1×1 to 10×10, turnarounds counted once. Note for the later Fire Trail tie-in: if Fire Trail's multiplication goes past 10, the "55" framing doesn't describe the app. |
| 11 | I-089 Googol | **CLEARED WITH FIX** | Nine-year-old nephew confirmed in Kasner's own book (via MacTutor). Fix: drop "1920" (§1a). |
| 12 | I-114 Origin story | **CLEARED (dependency)** | The line matches `marketing/website/LAUNCH-CHECKLIST.md:32` (confirmed by Justin). It still needs Justin to name the problems (`needs:justin-story`). |

## 3. Sense read

**As a skeptical parent.** The bank reads as calm and on my side. The puzzles are fair and state their assumptions, and the history items carry their inconvenient details. Three things would make me roll my eyes:

1. "If your kid still counts on their fingers, good" when my kid is nine (I-055).
2. An "hour has 60 minutes because Babylon" answer that my kid's teacher corrects (I-083).
3. Any app promo hinting that other apps are sketchy (I-112's "ask why").

Fix those and I'd send most of the A-tier to my partner.

**As a math teacher.** The places I'd post a correction are I-041 (the standard's example is 8 + 6), I-030 (6 × 12 = 72) and I-099 (decimal places). I-033 needs a carry, and I-050 ("not in the standards"; the standards do name making ten and area models) would draw the same reply. I'd also check whether any part 2 says "most people" about a wrong answer nobody measured.

**As a short-form producer.**
- I-016 is a strong debut topic, but **a part-1 puzzle is a weak very first post** for a channel with no audience to come back for part 2. Lead week 1 with I-072 (the strongest hook, and it shows Tallyclaw), then post the puzzle.
- I-113 in week 2 needs the gameplay-capture pipeline working by then. If capture slips, swap I-113 and I-114 (I-114 to week 2, I-113 to week 4).
- Every Short's related video is the F8a walkthrough, so F8a, the live site and YouTube advanced features are hard prerequisites before slot 1 (`content-strategy.md` §9). The batch note says so; the schedule should show it as week 0.
- F1 is banked 19 deep for one slot per cycle (about 19 cycles, or 76 weeks). The next round of ideas should go to F3 and F6, not more puzzles.

**Guide inconsistency found (not in the bank).** `format-library.md` F1 says Dragon Puzzle runs "every other week". The same file's cycle table and `content-strategy.md` §4 say once per 4-week cycle. The bank follows the cycle. Justin should pick one.

## 4. Suggested first-batch changes

The composition stands: 4/3/3/2 is correct (P1: F1 ×2 slots + F2 ×2; P2: F3 + F5 ×2; P3: F4 ×3; P4: F6 + F7). Each week has three different pillars, and Tallyclaw appears in about 4 of 12. Changes:

1. **Apply the three fixes** before treatment: I-041 (8 + 6 or "names the strategy"), I-083 (the Egypt → Babylon → Greek astronomers chain), I-089 (drop 1920). Also apply I-055's hook scope.
2. **Reorder week 1**: I-072 first, then I-055, then I-016 part 1. Keep part 2 early in week 2.
3. **Optional swap, if Justin wants zero-risk history in week 3:** I-078 (nautilus, verified at primary level, still art) or I-090 (equals sign, A#23, still art) for I-083. I'd keep I-083 with the fixed chain, since its hook is the stronger parent question.
4. **Pillar 4 fallback**: I-120 (dependency-free, sourced: Benavides-Varela 2020, 15 RCTs, 1,073 children) if Justin's problem list for I-114 isn't ready. This agrees with the author.
5. **November start**: I-079 for I-089 (Fibonacci Day, Nov 23) is good. For Thanksgiving, I prefer keeping I-053 and using I-064 in a later cycle. If a holiday tie-in is wanted in pillar 2, I-064 can replace I-055 rather than I-053: I-053 has the stronger research.

## 5. Recomputation (python)

```
I-001 5 min | I-002 helmet 5 | I-003 day 47 | I-004 11 posts | I-005 28 min (7 cuts × 4)
I-006 10 | I-007 3 | I-008 6 dragons, 4 knights | I-009 day 8 | I-010 32,767 (day 15: 16,384)
I-011 Wednesday (100 mod 7 = 2) | I-012 14 | I-013 9 | I-014 20 | I-015 11 overlaps (k·12/11 h, k = 0..10)
I-018 15 | I-019 31 | I-021 digit sums of 9..90 all 9 | I-022 156 (crossings 1 / 5 / 6) | I-023 918
I-024 56 | I-025 55 (1-10), 36 (2-9); 78 for 1-12 | I-026 253, 858; rule holds for all 10-99
I-027 70 | I-028 14, 28, 56 | I-030 ones digit holds for all evens; "tens = half" only n = 2, 4, 6, 8
I-031 1225; n·(n+1) then 25 holds for all x5 to 995 | I-032 400 | I-033 correct for all 25 pairs; carry at (6,6), (6,7)
I-034 55, 5050 | I-035 471 = 3 × 157 | I-036 76 | I-039 150 | I-040 798 vs 800
I-041 8 + 5 = 13; standard's example 8 + 6 = 14 | I-043 92 | I-044 5 | I-045 322 | I-046 4 | I-048 2
I-075 3.140845 < π < 3.142857 | I-093 1³ + 12³ = 9³ + 10³ = 1729; Ta(3) = 87,539,319 (search)
I-099 1;24,51,10 = 1.414212963 vs √2 1.414213562 (error 6.0e-7; 5 decimal places)
I-100 digits of 2^136,279,841 − 1 = 41,024,320; /3000 = 13,675 pages; still the record per Wikipedia "as of Oct 2026"
I-103 τ = 6.283185 | I-105 51 = 3 × 17, factors 1, 3, 17, 51 | I-106 squares to 144
Plimpton row 1: 119² + 120² = 169² | divisors of 60: 1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60
Scores: 125/125 totals and tiers match; P1/P2/P3/P4 = 40/31/32/22; A/B/C = 48/73/4; dependency-free 82
```

## 6. Sources fetched for this review

- Common Core 1.OA.C.6: thecorestandards.org/Math/Content/1/OA/ ; CCSS FAQ: thecorestandards.org/about-the-standards/frequently-asked-questions/
- WWC 2021006 practice guide summary (evidence table p. 13): ies.ed.gov/ncee/WWC/Docs/PracticeGuide/WWC-PraxGuide-Elementary-Math-Summary-508c.pdf
- Poletti et al. 2024: pmc.ncbi.nlm.nih.gov/articles/PMC11693818/
- Berkowitz et al. 2015 (once a week, 587): news.uchicago.edu/story/math-story-time-home-bolsters-achievement-school
- WeAreTeachers (Fink, 2023): weareteachers.com/common-core-math/
- Googol: MacTutor Kasner; Wikipedia Googol
- Hour and minute history: scientificamerican.com/article/experts-time-division-days-hours-minutes/
- Nautilus: Bartlett, Sibley & Sibley 2019, *Nexus Network Journal* (link.springer.com/10.1007/s00004-018-0419-3); Falbo 2005 (California Academy of Sciences shells, about 1.33)
- Lattice multiplication history: en.wikipedia.org/wiki/Lattice_multiplication
- Parity of zero: en.wikipedia.org/wiki/Parity_of_zero
- AAP 2026: healthychildren.org (AAP 2026 media recommendations); EdSurge 2026-02-05
- Calendar: findingada.com; naturalmath.com (Math Storytelling Day); JPBM / amstat.org (Math and Statistics Awareness Month); Tau Day (Palais 2001, Hartl 2010)
- Etymology: Wiktionary "digit", "eleven" (tier 4; Etymonline and Merriam-Webster blocked with 403)
- Largest known prime: Wikipedia "Largest known prime number" (as of October 2026)
