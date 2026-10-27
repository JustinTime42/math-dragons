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
A parent of a five- or six-year-old learns one thing to do tonight (let them count on their fingers and ask how they got it), and why: a French study where teaching a finger strategy raised addition accuracy, plus a second study suggesting early finger users who later drop them do best.

## Hooks
- A: Frame one: illustrated small hands (no real child) holding up three fingers, then four. On-screen text: "Counting on fingers at 5 or 6?" Narrator: "Parents, if your five- or six-year-old counts on their fingers, good."
- B: Frame one: the same illustrated hands next to a gold "37% → 77%" card. On-screen text: "Fingers at 5? Keep them." Narrator: "Parents, a study in France taught five- and six-year-olds to count on their fingers. On purpose."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-4 s | Illustration: small cartoon hands counting (no face, no real child) on a dark purple cloth | Counting on fingers at 5 or 6? | Narrator: Parents, if your five- or six-year-old counts on their fingers, good. |
| 4-11 s | Hands (Justin's, overhead) mime "show me how" next to a paper with 3 + 4 | Tonight: let them count / Ask them to show you how | Narrator: Tonight, don't ask them to stop. Let them count, then ask them to show you how. |
| 11-19 s | Re-hook. Illustration: a flat map of France, a classroom drawn as dragon-world tables (no people); callout card | One study, France / 328 kids, ages 5-6 / 2 weeks | Narrator: In one study in France, teachers gave five- and six-year-olds a few short finger-counting lessons over two weeks. |
| 19-26 s | Math card: bar grows from 37% to 77% in emerald | Kids new to fingers: 37% → 77% | Narrator: Kids who weren't using their fingers before went from about thirty-seven percent right on addition to seventy-seven. |
| 26-31 s | Math card: second bar, 40% to 48%, in cream, beside the first | No lessons: 40% → 48% | Narrator: Similar kids without the lessons went from about forty to forty-eight. |
| 31-40 s | Hard cut to a new card (keeps the two studies visibly separate): a timeline, fingers icon fading out at "about 7½" | A second study / Dropped fingers by about 7½: did best | Narrator: A second, longer study suggests the kids who used fingers early, then dropped them by about seven and a half, did best. |
| 40-43 s | Tallyclaw still (pointing claw pose), text card beside him | Tallyclaw: "Fingers aren't cheating. They're tools." | (no VO; card held 3 s) |
| 43-44 s + loop | Illustrated hands from frame one, five-word recap | Let them count. Ask how. | Narrator: So tonight: let them count. Ask how. |

Word count: 102 Narrator words (budget about 103 for the 41 s of speech; total about 44-46 s with the 3 s Tallyclaw card). F5 target is 30-45 s.

## Math strings (exact, rendered from code)
- `Counting on fingers at 5 or 6?`
- `328 kids, ages 5-6`
- `2 weeks`
- `37% → 77%`
- `40% → 48%`
- `about 7½`

Verified (python, 2026-10-27): `round(37.3) == 37`, `round(77.1) == 77`, `round(39.6) == 40`, `round(47.8) == 48` (the paper's figures rounded to whole percents, so the VO says "about"). 328 = 191 experimental + 137 control (py: `191 + 137 == 328`).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Hook scoped to five- and six-year-olds: "if your five- or six-year-old counts on their fingers, good" | idea-bank.review §1a fix for I-055 (scope to 5-6); evidence row "Finger counting" (MODERATE-HIGH / MODERATE) | MODERATE-HIGH (for this age only) |
| 2 | Tip: don't ask them to stop; let them count and ask them to show you how | Evidence row "Finger counting", safe framing "Fingers are a tool"; MLE inference ("Fingers are a tool, not cheating") | Tip (no outcome claimed) |
| 3 | One study in France; teachers gave five- and six-year-olds a few short finger-counting lessons over two weeks | Poletti et al., *Child Development* 2024/25, Experiment 1 (PMC11693818, fetched 2026-10-27): 328 children analyzed, ages 5 to 6½, teacher-led, six 10-minute whole-class sessions over two weeks; evidence row "Finger counting" | MODERATE-HIGH, framed as "In one study" |
| 4 | On screen: 328 kids, ages 5-6 | PMC11693818 (Experiment 1: 328 analyzed; age range 60-77 months, i.e. 5 to 6½) | HIGH (as reported) |
| 5 | Kids who weren't using fingers before went from 37% right on addition to 77% | PMC11693818: non-finger users at pre-test, experimental group 37.3% → 77.1% (pre-test to immediate post-test); bank I-055 | MODERATE-HIGH |
| 6 | Similar kids without the lessons went from about 40 to 48 | PMC11693818: passive control, non-finger users, 39.6% → 47.8% | MODERATE-HIGH |
| 7 | A second, longer study suggests kids who used fingers early, then dropped them by about 7½, did best (at addition) | The Sector, 2025-11-28 (secondary; longitudinal, 200+ children: early users who stopped by about 7.5 outperformed never-users and persistent users); MLE line 121; evidence row | MODERATE, framed as "suggests" |
| 8 | Tallyclaw card: "Fingers aren't cheating. They're tools." | brand §4.4 sample line (accuracy-reviewed 2026-10-19), first use; evidence row safe framing | Framing, consistent with claims 3-7 |

Kept separate on screen: the Poletti figures (11-31 s) and the longitudinal study (31-40 s) are on different cards with a hard cut and "A second study" label (review fix). Cut: "most kids phase them out around 7-8" (an inference in the notes, not a measured finding); the "first study ever" claim (true per the authors, but it adds a claim without helping the parent); any claim about kids over seven still using fingers.

## CTA
None (value video). Corner mark only.

## Copy
- YouTube title: `Your 5-year-old counts on fingers? What one study found` (55 characters)
- Shorts description:
  ```
  In one French study, teaching five- and six-year-olds a finger strategy raised addition accuracy from 37% to 77%. Try this tonight: let them count, then ask how.
  Free beta: playmathdragons.com
  #parenting #parentingtips #homeschool #teachers
  ```
- Facebook caption: "In one French study, teaching five- and six-year-olds a finger strategy helped their addition. Did your kid count on fingers at that age?"
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb005`
- Hashtags: #parenting #parentingtips #homeschool #teachers

## Production notes
- **No real child, ever.** The small hands are illustration only (bank I-055; compliance §G). Justin's overhead hands only in the 4-11 s beat, with no rings or anything identifying (visual-style §10).
- **Tallyclaw still:** pointing-claw pose from `04_stone_dragon.png` / `09_stone_face.png`; placed to one side, never covering the bars. His line is the video's one X/Y-style reframe (allowed max one).
- **Math cards:** Manim bars with exact labels above; the two studies on separate cards with distinct backgrounds.
- **Music:** `assets/audio/music/hub_theme.ogg`, calm, under the VO.
- **Cover frame:** 19-26 s, "37% → 77%" bar with "Kids new to fingers" label; or 0-4 s with the hook text.
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
- [x] Word count within budget for the target length (102 vs about 103)
- [x] Voice checklist passed (brand §11): adult address, no guilt, study confidence wording ("In one study", "suggests"), zero em-dashes, one X/Y reframe (Tallyclaw's card)
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7 (caption question is genuine)
- [x] Compliance checklist §A-H passed (no real child, illustrated hands only; learning-science claims carry confidence; no outcome claims about the app; no app mention)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off
