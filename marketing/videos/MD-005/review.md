# MD-005: review

## Script gate (2026-10-27, independent reviewer: Claude subagent, no authoring context)

Verdict: **PASS WITH FIXES** (the second study is mis-described and mis-sourced; the Shorts description drops the subgroup; the last beat's timing is impossible)

| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
| 1 | Hook "if your five- or six-year-old counts on their fingers, good" | SUPPORTED for this age | Poletti et al. (below), kindergarteners 5 to 6½; scoped per idea-bank.review §1a | none |
| 2 | Tip: don't ask them to stop; let them count, then ask them to show you how | OK as a tip, see sense read | Evidence row "Finger counting"; no outcome claimed | none required |
| 3 | One study in France; teachers gave 5-6-year-olds "a few short finger-counting lessons over two weeks" | TRUE, imprecise | Poletti et al., *Child Development* 2025, 96:251-268, doi 10.1111/cdev.14146, PMC11693818 (fetched): Experiment 1, teachers in French kindergarten classrooms, "six 10-min collective teaching sessions (i.e., 3 sessions per week over 2 weeks)" | "a few" for six: say "six short lessons" (same word count) |
| 4 | On screen "328 kids, ages 5-6", "2 weeks" | TRUE | PMC: "328 children (191 from the experimental group and 137 from the control group) aged from 5 to 6½ years ... range from 60 to 77 months" | none |
| 5 | Kids not using fingers before: about 37% right on addition to 77% | TRUE (immediate post-test) | PMC abstract: "accuracy from 37.3% to 77.1%"; held at the 6-week delayed test (75.1%) | Label "Kids new to fingers" is a stretch (they were non-users at pre-test, not necessarily new to fingers): use "Kids not using fingers yet" |
| 6 | Similar kids without the lessons: about 40 to 48 | TRUE | PMC: passive control "39.6% to 47.8%" | none |
| 7 | "A second, longer study suggests the kids who used fingers early, then dropped them by about seven and a half, did best." / on screen "Dropped fingers by about 7½: did best" | **PARTLY WRONG; wrong source** | Primary paper: Krenger & Thevenot, "The Role of Children's Finger Counting History on their Addition Skills", *Developmental Psychology*, online 2025-11-20, doi 10.1037/dev0002099 (APA/Newswise press release fetched; full paper not reachable). 211 Swiss children followed from 4½ to 7½, tested twice a year on addition. "From age 6 on, these former finger users outperformed both" never-users and current users. **7½ is when the study ended, not a stopping age**; the treatment cites The Sector (secondary, and not itself fetched by this review). Observational, so "suggests" is the right verb | Rewrite the beat (fix 1); cite the primary paper |
| 8 | Tallyclaw card "Fingers aren't cheating. They're tools." | OK (framing, the video's one allowed X/Y reframe) | consistent with 3-7; brand §4.4 sample line | none |
| 9 | Shorts description: "teaching five- and six-year-olds a finger strategy raised addition accuracy from 37% to 77%" | **MISLEADING** | 37.3 → 77.1 is the **non-finger-user subgroup** only. The whole experimental group went 59.6% → 84.7% (PMC) | Fix 2 |
| 10 | Facebook caption: "teaching five- and six-year-olds a finger strategy helped their addition" | TRUE | PMC (both overall and subgroup gains vs control) | none |
| 11 | Hook B: "a study in France taught five- and six-year-olds to count on their fingers. On purpose." | TRUE-ish | the study taught a specific finger strategy for addition | if Hook B is picked: "...taught five- and six-year-olds a finger-counting strategy. On purpose." |
| 12 | Title: "Your 5-year-old counts on fingers? What one study found" | TRUE | as 3-5 | none |

Math recomputed (python, `python3 -I recompute.py`, scratchpad):
```
--- MD-005: Poletti et al. figures
37.3->77.1: rounded 37->77, gain 39.8 pts
39.6->47.8: rounded 40->48, gain 8.2 pts
191+137 = 328
60..77 months in years: 5.0 6.416666666666667
7.5 years = 15/2 shown as 7½ -> 7½ ==7.5: True
MD-005: 55 chars, 40<=len<=65: True | Your 5-year-old counts on fingers? What one study found
   first-comment paths: {'playmathdragons.com/fb005'}
   hashtags: #parenting #parentingtips #homeschool #teachers count 4
```
Per-beat pace:
```
0-4 s    11 w / 4s = 2.75 w/s
4-11 s   16 w / 7s = 2.29 w/s
11-19 s  18 w / 8s = 2.25 w/s
19-26 s  17 w / 7s = 2.43 w/s
26-31 s  11 w / 5s = 2.20 w/s
31-40 s  22 w / 9s = 2.44 w/s
40-43 s  (no VO; card 3 s)
43-44 s   7 w / 1s = 7.00 w/s  <-- impossible
TOTAL 102 words
```
"So tonight: let them count. Ask how." needs about 3 s, so the real length is about 46-47 s, over F5's 30-45 s target and the frontmatter's 44. Em-dashes: 0. X/Y reframes: 1 (Tallyclaw's card; the maximum).

Sense read:
- As a math teacher: the first study is reported accurately and with the right hedge ("In one study"). The second study is where I'd push back: "dropped them by about seven and a half" reads as a recommended stopping age, and the study doesn't say that. It also needs a primary citation, not a news site.
- As a parent: the tip is sensible and calm. One honest gap: the study *taught* a finger strategy in class; the tip is "let them count and ask how". That's consistent with the study but not what it tested, and the script doesn't claim otherwise. Fine as is.
- The two studies are kept visibly separate (hard cut, "A second study" label), as the earlier review asked.
- The parent of a 9-year-old who still counts on fingers gets no message here. That's right (the scope stays 5-6), but the revised second-study line must not imply "stopping late is bad", which the data, being correlational, can't support.
- Nothing is said to a child. Small hands are illustrated, not a real child.

Compliance (§A-H):
- A Made for Kids: PASS. "Parents" first spoken word; adult-addressed text; illustrated hands, no child; parent hashtags (#parentingtips is parent-oriented).
- B Claims: PASS WITH FIX. Learning-science claims carry their confidence ("In one study", "suggests"), but the description overstates the effect (claim 9) and the second study's wording (claim 7) goes beyond the source.
- C AI disclosure: PASS.
- D Engagement bait: PASS. "Did your kid count on fingers at that age?" is genuine.
- E Audio: PASS.
- F Visuals/IP: PASS.
- G Privacy: PASS (Justin's hands, nothing identifying).
- H Links/CTA: PASS (none). Cross-cutting: "Free beta" description and first comment need LAUNCH-CHECKLIST §7-§9 done; `/fb005` needs `website/phase-2` deployed.

Fixes:
1. **Required.** 31-40 s: VO "A second study followed kids for three years. The ones who used fingers early, then stopped, did best at addition." (19 words, about 7.6 s; keep "suggests" if wanted: "...suggests the ones who used fingers early, then stopped, did best at addition."). On screen: "A second study / Used fingers, then stopped: did best". Drop `about 7½` from the math strings. Claims list 7: cite Krenger & Thevenot 2025, *Developmental Psychology*, doi 10.1037/dev0002099 (211 Swiss children, ages 4½-7½, observational), with The Sector only as the pointer. Update the evidence-table row in the research report and MLE line 121 at their next edit (Justin's call).
2. **Required.** Shorts description: "In one French study, five- and six-year-olds who weren't using their fingers went from 37% to 77% right on addition after six short finger-counting lessons. Try this tonight: let them count, then ask how." (Or drop the numbers and use the Facebook caption's wording.)
3. **Required.** Re-time the ending: 43-46 s for "So tonight: let them count. Ask how." and set the total to about 46 s (or trim about 3 words earlier, e.g. 4-11 s "Don't ask them to stop. Let them count, then ask how they got it." to land at 45 s). Update target_length_s and the word-count line.
4. Recommended. 11-19 s VO "a few short" to "six short"; 19-26 s label "Kids new to fingers" to "Kids not using fingers yet" (also on the cover-frame note).
5. Claims list: record the full Poletti et al. citation (2025, vol 96, doi 10.1111/cdev.14146) and that gains held at the 6-week delayed test.

Justin sign-off: 2026-11-03 (script gate approved)

## Render gate (date, reviewer)
Verdict:
Checked on file:
Issues:
Justin sign-off:
