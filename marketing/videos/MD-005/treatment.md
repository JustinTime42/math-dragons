---
id: MD-005
status: treatment
pillar: 2
series: none
format: F5
target_length_s: 44
voices: Narrator (Tallyclaw as a still-art text card)
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook: none
---

# MD-005: Fingers aren't cheating

## Concept
A parent of a five- or six-year-old learns one thing to do tonight (let them count on their fingers and ask how they got it), and why: a French study where teaching a finger strategy raised addition accuracy, plus a second, observational study suggesting kids who used fingers early and later stopped did best at addition.

## Hooks
- A: Frame one: illustrated small hands (no real child) holding up three fingers, then four. On-screen text: "Counting on fingers at 5 or 6?" Narrator: "Parents, if your five- or six-year-old counts on their fingers, good."
- B: Frame one: the same illustrated hands next to a gold "37% → 77%" card. On-screen text: "Fingers at 5? Keep them." Narrator: "Parents, a study in France taught five- and six-year-olds a finger-counting strategy. On purpose."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-4 s | Illustration: small cartoon hands counting (no face, no real child) on a dark purple cloth | Counting on fingers at 5 or 6? | Narrator: Parents, if your five- or six-year-old counts on their fingers, good. |
| 4-10 s | Hands (Justin's, overhead) mime "show me how" next to a paper with 3 + 4 | Tonight: let them count / Ask how they got it | Narrator: Don't ask them to stop. Let them count, then ask how they got it. |
| 10-17 s | Re-hook. Illustration: a flat map of France, a classroom drawn as dragon-world tables (no people); callout card | One study, France / 328 kids, ages 5-6 / 6 short lessons, 2 weeks | Narrator: In one study in France, teachers gave five- and six-year-olds six short finger-counting lessons over two weeks. |
| 17-24 s | Math card: bar grows from 37% to 77% in emerald | Kids not using fingers yet: 37% → 77% | Narrator: Kids who weren't using their fingers before went from about thirty-seven percent right on addition to seventy-seven. |
| 24-29 s | Math card: second bar, 40% to 48%, in cream, beside the first | No lessons: 40% → 48% | Narrator: Similar kids without the lessons went from about forty to forty-eight. |
| 29-38 s | Hard cut to a new card (keeps the two studies visibly separate): a three-year timeline, a fingers icon that appears early and fades out | A second study / 3 years / Used fingers, then stopped: did best | Narrator: A second study followed kids for three years. It suggests the ones who used fingers early, then stopped, did best at addition. |
| 38-41 s | Tallyclaw still (pointing claw pose), text card beside him | Tallyclaw: "Fingers aren't cheating. They're tools." | (no VO; card held 3 s) |
| 41-44 s + loop | Illustrated hands from frame one, five-word recap | Let them count. Ask how. | Narrator: So tonight: let them count. Ask how. |

Word count: 99 Narrator words (budget about 103 for the 41 s of speech; total 44 s with the 3 s Tallyclaw card). F5 target is 30-45 s.

## Math strings (exact, rendered from code)
- `Counting on fingers at 5 or 6?`
- `328 kids, ages 5-6`
- `6 short lessons, 2 weeks`
- `37% → 77%`
- `40% → 48%`
- `3 years`

Verified (python, 2026-10-27): `round(37.3) == 37`, `round(77.1) == 77`, `round(39.6) == 40`, `round(47.8) == 48` (the paper's figures rounded to whole percents, so the VO says "about"). 328 = 191 experimental + 137 control (py: `191 + 137 == 328`). Second study span: 7.5 - 4.5 = 3.0 years (py), so "three years" / `3 years`. Six lessons: six 10-minute sessions (paper).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Hook scoped to five- and six-year-olds: "if your five- or six-year-old counts on their fingers, good" | idea-bank.review §1a fix for I-055 (scope to 5-6); evidence row "Finger counting" (MODERATE-HIGH / MODERATE) | MODERATE-HIGH (for this age only) |
| 2 | Tip: don't ask them to stop; let them count, then ask how they got it | Evidence row "Finger counting", safe framing "Fingers are a tool"; MLE inference ("Fingers are a tool, not cheating") | Tip (no outcome claimed) |
| 3 | One study in France; teachers gave five- and six-year-olds six short finger-counting lessons over two weeks | Poletti et al., *Child Development* 2025, 96(1):251-268, doi 10.1111/cdev.14146 (online 2024-09-18), Experiment 1 (PMC11693818, fetched 2026-10-27): 328 children analyzed, ages 5 to 6½, teacher-led, six 10-minute whole-class sessions over two weeks; evidence row "Finger counting" | MODERATE-HIGH, framed as "In one study" |
| 4 | On screen: 328 kids, ages 5-6 | PMC11693818 (Experiment 1: 328 analyzed; age range 60-77 months, i.e. 5 to 6½) | HIGH (as reported) |
| 5 | Kids who weren't using fingers before went from about 37% right on addition to 77% (on screen: "Kids not using fingers yet") | PMC11693818: non-finger users at pre-test, experimental group 37.3% → 77.1% (pre-test to immediate post-test); gains held at the 6-week delayed test (75.1%, per review); bank I-055 | MODERATE-HIGH |
| 6 | Similar kids without the lessons went from about 40 to 48 | PMC11693818: passive control, non-finger users, 39.6% → 47.8% | MODERATE-HIGH |
| 7 | A second study followed kids for three years; it suggests the ones who used fingers early, then stopped, did best at addition | Krenger & Thevenot, "The Role of Children's Finger Counting History on their Addition Skills", *Developmental Psychology*, 2025, doi 10.1037/dev0002099: 211 Swiss children followed from 4½ to 7½, observational; from age 6 on, former finger users outperformed never-users and current users at addition. The Sector (2025-11-28) only as the pointer. Evidence row and MLE line 121 corrected upstream. 7½ is when the study ended, not a recommended stopping age, so the script names no age | MODERATE (observational), framed as "suggests" |
| 8 | Tallyclaw card: "Fingers aren't cheating. They're tools." | brand §4.4 sample line (accuracy-reviewed 2026-10-19), first use; evidence row safe framing | Framing, consistent with claims 3-7 |

Kept separate on screen: the Poletti figures (10-29 s) and the longitudinal study (29-38 s) are on different cards with a hard cut and "A second study" label (review fix). Cut: "most kids phase them out around 7-8" (an inference in the notes, not a measured finding); the "first study ever" claim (true per the authors, but it adds a claim without helping the parent); any claim about kids over seven still using fingers.

## CTA
None (value video). Corner mark only.

## Copy
- YouTube title: `Your 5-year-old counts on fingers? What one study found` (55 characters)
- Shorts description:
  ```
  In one French study, five- and six-year-olds who weren't using their fingers went from 37% to 77% right on addition after six short finger-counting lessons. Try this tonight: let them count, then ask how.
  Free beta: playmathdragons.com
  #parenting #parentingtips #homeschool #teachers
  ```
- Facebook caption: "In one French study, teaching five- and six-year-olds a finger strategy helped their addition. Did your kid count on fingers at that age?"
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb005`
- Hashtags: #parenting #parentingtips #homeschool #teachers

## Production notes
- **No real child, ever.** The small hands are illustration only (bank I-055; compliance §G). Justin's overhead hands only in the 4-10 s beat, with no rings or anything identifying (visual-style §10).
- **Tallyclaw still:** pointing-claw pose from `04_stone_dragon.png` / `09_stone_face.png`; placed to one side, never covering the bars. His line is the video's one X/Y-style reframe (allowed max one).
- **Math cards:** Manim bars with exact labels above; the two studies on separate cards with distinct backgrounds.
- **Music:** `assets/audio/music/hub_theme.ogg`, calm, under the VO.
- **Cover frame:** 17-24 s, "37% → 77%" bar with "Kids not using fingers yet" label; or 0-4 s with the hook text.
- **Review note:** the study is about kindergarteners learning a finger strategy, so the hook, title and caption all stay scoped to ages 5-6. Don't widen it in edits.
- Slot per INDEX: week 1, post 3 (the review suggested post 2; see MD-004 note).

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: none (series: none; optional "Parent Playbook" playlist if Justin creates one)
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own voice clone, illustration, real hands) / Facebook yes (realistic AI voice, compliance §C)
- Facebook first-comment path: /fb005

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows its format's beats (F5: parent moment, one step tonight, why with confidence wording, the step again in five words)
- [x] Word count within budget for the target length (99 vs about 103)
- [x] Voice checklist passed (brand §11): adult address, no guilt, study confidence wording ("In one study", "suggests"), zero em-dashes, one X/Y reframe (Tallyclaw's card)
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7 (caption question is genuine)
- [x] Compliance checklist §A-H passed (no real child, illustrated hands only; learning-science claims carry confidence; no outcome claims about the app; no app mention)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (PASS WITH FIXES) and the coordinator's source correction:
- 29-38 s (second study) rewritten: "A second study followed kids for three years. It suggests the ones who used fingers early, then stopped, did best at addition." On screen "A second study / 3 years / Used fingers, then stopped: did best". The "about seven and a half" stopping age is gone (7½ was when the study ended). Claim 7 now cites Krenger & Thevenot 2025, *Developmental Psychology* (211 Swiss children, 4½ to 7½, observational, former finger users best from age 6 on); The Sector is the pointer only. Math string `about 7½` replaced by `3 years` (7.5 - 4.5 = 3.0, python).
- Shorts description: the 37% → 77% figure is now scoped to kids who weren't using their fingers, after six short lessons.
- Timing: 4-10 s tip trimmed to "Don't ask them to stop. Let them count, then ask how they got it." so the closing line gets 3 s (41-44 s); total 44 s, inside F5's 30-45 s. Word count 102 to 99.
- 10-17 s: "a few short" became "six short" lessons; on screen adds "6 short lessons, 2 weeks".
- On-screen label "Kids new to fingers" became "Kids not using fingers yet" (also in the cover-frame note).
- Hook B: "taught five- and six-year-olds a finger-counting strategy. On purpose."
- Claims list: full Poletti citation (2025, 96(1):251-268, doi 10.1111/cdev.14146) and gains held at the 6-week delayed test.
- Percent figures rechecked in python (37, 77, 40, 48; 191 + 137 = 328).
