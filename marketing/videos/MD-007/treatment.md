---
id: MD-007
status: treatment
pillar: 2
series: Homework Decoder
format: F3
target_length_s: 55
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook: none (back-to-school or report-card season also fits)
---

# MD-007: Make a ten, decoded

## Concept
A parent learns what "make a ten" on their kid's homework means, using the exact example in Common Core 1.OA.C.6 (8 + 6 = 8 + 2 + 4 = 10 + 4 = 14), why teachers use it, and one question that helps at home without taking over.

## Hooks
- A: Frame one: a recreated worksheet line in our own layout, "Make a ten to add: 8 + 6 = ___". On-screen text: "Make a ten?" Narrator: "Your kid's homework says make a ten. Here's what that means."
- B: Frame one: a ten frame with 8 dots and 2 empty spaces glowing. On-screen text: "Why 8 + 6 becomes 10 + 4". Narrator: "Parents, here's why your kid's worksheet turns eight plus six into ten plus four."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-4 s | Recreated worksheet line (our layout, Nunito, no publisher design) on a cream card | Make a ten to add: 8 + 6 = ___ | Narrator: Your kid's homework says make a ten. Here's what that means. |
| 4-9 s | Math card: `8 + 6`; then `10 - 8 = 2` small beneath | 8 + 6 / 8 needs 2 more to make 10 | Narrator: Take eight plus six. Eight is two away from ten. |
| 9-13 s | Math card: the 6 splits into 2 and 4 | 6 = 2 + 4 | Narrator: So split the six into two and four. |
| 13-18 s | Math card: `8 + 2 = 10`, then `10 + 4 = 14` | 8 + 2 = 10 / 10 + 4 = 14 | Narrator: Eight plus two makes ten. Ten plus four is fourteen. |
| 18-21 s | Hands (Justin's, overhead) tap the paper | You may already do this | Narrator: You may already do this in your head. |
| 21-26 s | Full chain card, one step at a time; small label "Common Core 1.OA.C.6, grade 1" | 8 + 6 = 8 + 2 + 4 = 10 + 4 = 14 | Narrator: That's the exact example in the Common Core standard for first grade. |
| 26-33 s | Re-hook. Math card: "hard fact" box splits into two "easy step" boxes | Why teach it? / 1 harder fact → 2 easy steps | Narrator: Why teach it? Ten is easy to add to, so one harder fact becomes two easy steps. |
| 33-44 s | Illustration: a ten frame (two rows of five). 8 gold dots, 2 dots slide in from a second frame of 6, leaving 4 | Ten frame: a box with 10 spaces / Studies: kids who needed extra help | Narrator: Here it is as a ten frame, a box with ten spaces. In studies of kids who needed extra help, pictures like this were part of what worked. |
| 44-48 s | The standard's strategies listed briefly, "making ten" highlighted | One of several strategies | Narrator: The standard lists it as one of several strategies. |
| 48-55 s | Hands write "How many more to make 10?" on paper, then put the pen down and slide the paper away (the kid finishes) | Ask: "How many more to make 10?" | Narrator: To help at home, ask one question: how many more to make ten? Then let your kid finish. |
| 55-56 s | Back to the worksheet line, now filled: `8 + 6 = 14` (loops to frame one) | 8 + 6 = 14 | (no VO) |

Word count: 131 (budget about 135 for 54 s of speech at 2.5 words/s). F3 target 30-60 s.

## Math strings (exact, rendered from code)
- `Make a ten to add: 8 + 6 = ___`
- `8 + 6`
- `10 - 8 = 2`
- `6 = 2 + 4`
- `8 + 2 = 10`
- `10 + 4 = 14`
- `8 + 6 = 8 + 2 + 4 = 10 + 4 = 14`
- `8 + 6 = 14`
- Ten frame: 8 filled + 2 moved = 10; 6 - 2 = 4 left over
- Label: `Common Core 1.OA.C.6, grade 1`

Verified (python, 2026-10-27): `8 + 6 == 14`; `10 - 8 == 2`; `6 == 2 + 4`; `8 + 2 == 10`; `10 + 4 == 14`; `8 + 6 == 8 + 2 + 4 == 10 + 4 == 14` is True; `8 + 2 == 10` and `6 - 2 == 4` (ten frame).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | "Make a ten" means getting one addend to ten first (8 + 6 → 8 + 2 + 4 → 10 + 4) | CCSS 1.OA.C.6 (thecorestandards.org/Math/Content/1/OA/, fetched 2026-10-27: lists "making ten" with the example "8 + 6 = 8 + 2 + 4 = 10 + 4 = 14"); py | HIGH |
| 2 | "That's the exact example in the Common Core standard for first grade." | Same fetch (confirmed the example reads "8 + 6 = 8 + 2 + 4 = 10 + 4 = 14"); idea-bank.review §1a I-041 fix (this replaces the wrong 8 + 5 version) | HIGH |
| 3 | "You may already do this in your head." | MLE inference (making ten is what fluent adults do mentally); worded as "may" | LOW-MODERATE (inference, hedged) |
| 4 | Ten is easy to add to, so one harder fact becomes two easy steps | Pedagogical reasoning behind the strategy (CCSS lists it among strategies for adding within 20); not a research claim | Reasoning, no outcome claimed |
| 5 | A ten frame is a box with ten spaces | Definition (shown on screen as two rows of five) | HIGH |
| 6 | "In studies of kids who needed extra help, pictures like this were part of what worked." | WWC 2021 practice guide (2021006, Fuchs et al.), Rec 3 (concrete and semi-concrete representations, Strong, 28 studies, grades K-6; Table 3.1 lists "5 frames, 10 frames, double 10 frames" as semi-concrete representations; https://ies.ed.gov/ncee/WWC/Docs/PracticeGuide/WWC-PraxGuide-Elementary-Math-Summary-508c.pdf). The studies tested interventions that used representations, not ten-frame pictures alone, hence "part of what worked"; evidence row "Representations" (HIGH); wording scoped per idea-bank.review §1a (guide covers K-6 students struggling with math) | HIGH, scoped wording |
| 7 | The standard lists it as one of several strategies | CCSS 1.OA.C.6 (fetched: counting on, making ten, decomposing a number leading to ten, relationship between addition and subtraction, easier equivalent sums) | HIGH |
| 8 | Help-at-home tip: ask "how many more to make ten?", then let your kid finish | F3 beat 4 ("help without taking over"); tip, no outcome claim | Tip |
| 9 | Hook B (if picked): "your kid's worksheet turns eight plus six into ten plus four" | py: `8 + 6 == 10 + 4 == 14`; CCSS 1.OA.C.6 | HIGH |

Cut: "the same thing every fluent adult does" (unsourced generalization; hedged to "you may"); any claim that teachers "often" use ten frames (no fetched source; the ten frame is shown as our own picture); any claim the app teaches making ten (F6 note: the app drills facts, it doesn't teach strategies).

## CTA
None (value video). Corner mark only.

## Copy
- YouTube title: `"Make a ten" on your kid's homework, explained for parents` (58 characters)
- Shorts description:
  ```
  What "make a ten" means on first-grade math homework, using the exact example from the Common Core standard: 8 + 6 = 8 + 2 + 4 = 10 + 4 = 14.
  Free beta: playmathdragons.com
  #parenting #homeschool #teachers #parentingtips
  ```
- Facebook caption: "What 'make a ten' means on your kid's math homework, with the exact example from the standard. Which worksheet phrase should I decode next?"
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb007`
- Hashtags: #parenting #homeschool #teachers #parentingtips

## Production notes
- **Recreated worksheet:** our own layout and type only, never a photo of a real child's worksheet and nothing resembling a publisher's page or branding (F3 rules). No child's name or handwriting.
- **Math cards:** Manim, one step at a time, numbers cream, operators and equals signs gold (visual-style §6); each step held long enough to read twice. The full chain card must show exactly `8 + 6 = 8 + 2 + 4 = 10 + 4 = 14`.
- **Ten frame:** Manim, two rows of five, gold dots; the 2 dots visibly move from the 6-frame into the 8-frame.
- **Hands:** Justin's, overhead on a dark purple cloth; no rings, nothing identifying (visual-style §10).
- **Tone:** calm and pro-teacher; never mocks "new math"; the "one of several strategies" line keeps it from sounding like the only right way.
- **No gameplay, no Tallyclaw.**
- **Music:** `assets/audio/music/dragon_eggs.ogg`, under the VO. SFX: the game's correct chime on `= 14`.
- **Cover frame:** 21-26 s, the full chain card with "Make a ten?" text, or 0-4 s with the worksheet line.
- Week 2, post 2. Note for Justin: `format-library.md` F3's example already says 8 + 6 (corrected 2026-10-26), so this matches the guide.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: Homework Decoder
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own voice clone, animation, real hands) / Facebook yes (realistic AI voice, compliance §C)
- Facebook first-comment path: /fb007

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address ("Your kid's homework"), open loop; two alternatives written
- [x] One idea; follows its format's beats (F3: worksheet phrase, method on math cards, why teachers teach it at the evidence level, one way to help at home)
- [x] Word count within budget for the target length (131 vs about 135)
- [x] Voice checklist passed (brand §11): calm, pro-teacher, no "only way", WWC claim scoped, zero em-dashes, zero X/Y reframes
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7 (caption question is genuine)
- [x] Compliance checklist §A-H passed (recreated worksheet, no publisher design, no kids, no app claim)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (PASS, optional notes):
- 33-44 s VO: "pictures like this worked well" became "pictures like this were part of what worked" (the WWC studies tested interventions using representations, not ten-frame pictures alone). The beat is now 29 words in 11 s (2.6 w/s). Word count 128 to 131 (budget about 135).
- Claim 6: added WWC Table 3.1 (ten frames listed), 28 studies, K-6, and the PDF link. Claims list: added Hook B.
- Minus glyph: left as the ASCII hyphen (`10 - 8 = 2`, as the CCSS text writes it). MD-002 uses `−` (U+2212). Picking one glyph for all math cards is a visual-style decision for Justin.
- Math rechecked in python (`8 + 6 == 8 + 2 + 4 == 10 + 4 == 14`, ten frame 2 × 5 = 10, 10 - 8 = 2, 6 - 2 = 4).
