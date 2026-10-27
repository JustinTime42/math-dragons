---
id: MD-004
status: treatment
pillar: 1
series: Dragon Puzzle
format: F1 (part 1)
target_length_s: 18
voices: Narrator
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook: none
---

# MD-004: Is zero even? (Dragon Puzzle, part 1)

## Concept
A parent gets a one-number puzzle to try with their kid tonight (is zero even, odd, or neither?), with the rule stated so it's solvable, and the answer in part 2 (MD-006).

## Hooks
- A: Frame one: a big cream "0" between gold "EVEN" and "ODD", with "NEITHER?" under it. On-screen text: "Parents: is 0 even, odd, or neither?" Narrator: "Parents, is zero even, odd, or neither? Ask your kid. Then ask yourself."
- B: Frame one: the same "0" alone on purple, "EVEN" and "ODD" sliding in from each side. On-screen text: "Even or odd: 0". Narrator: "Try this with your kid tonight. Is zero even?"

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-5 s | Math card: big "0" centered; "EVEN" left, "ODD" right, "NEITHER?" below, each pulses as it's spoken | Parents: is 0 even, odd, or neither? | Narrator: Parents, is zero even, odd, or neither? Ask your kid. Then ask yourself. |
| 5-13 s | Math card: the rule. Six dots split into two equal groups of three (an example that isn't zero), then the "0" returns | Even = 2 equal groups, none left over | Narrator: Use the usual rule: a number is even if it splits into two equal groups, with none left over. |
| 13-16 s | Thinking beat: the "0" alone, a dragon-fire bar burns down across the bottom of the safe area (no numbers, no countdown voice) | (none) | (silence, music only) |
| 16-18 s | The opening frame returns exactly (loop) | Answer in part two | Narrator: Answer in part two. |

Word count: 36 (budget about 37 for the 15 s of speech; total 18 s with the 3 s thinking beat). The closing line is "Answer in part two." rather than format-library F1's "Answer in the next video.", because MD-005 posts between the two parts; it stays true whatever goes up in between.

## Math strings (exact, rendered from code)
- `0`
- `EVEN` / `ODD` / `NEITHER?`
- Rule card: six dots as `3 + 3` (shown as dots, label `6 = 3 + 3`)
- `Even = 2 equal groups, none left over`

Verified (python, 2026-10-27): `6 % 2 == 0`, `6 == 3 + 3`; `0 % 2 == 0` (the part-2 answer; not shown here).

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | "A number is even if it splits into two equal groups, with none left over" (the usual rule, stated as the puzzle's assumption) | Standard definition: Wikipedia "Parity of zero" (fetched 2026-10-27: an even number is an integer multiple of 2); Appendix A #40 | HIGH |
| 2 | The puzzle has one answer (even), so it is solvable and not rage-bait | Appendix A #40 (HIGH); idea-bank.review §2 (I-016 cleared) | HIGH |
| 3 | 6 = 3 + 3 (example on the rule card) | py | HIGH |
| 4 | Hook premise "Ask your kid. Then ask yourself." (adults find it hard too) | Lichtenberg 1972, *The Arithmetic Teacher*, via Wikipedia "Parity of zero" (fetched 2026-10-27): about two thirds of prospective elementary teachers answered "False" to "Zero is an even number"; Appendix A #40 ("many adults and kids hesitate") | MODERATE-HIGH (implied, not stated as a number) |

No app tie-in: Dragon's Feast's "even" category starts at 1 (`n > 0 && n % 2 == 0`, `lib/games/dragons_feast/systems/category_system.dart`), so the app would contradict the answer. Nothing in this video shows or mentions the app.

## CTA
None. The puzzle itself is the CTA ("Answer in part two"; content-strategy §6). Corner mark only.

## Copy
- YouTube title: `Parents: is zero even, odd, or neither? Ask your kid` (52 characters)
- Shorts description:
  ```
  Try this one with your kid tonight, then see if you agree. Answer: see the Dragon Puzzle playlist.
  Free beta: playmathdragons.com
  #parenting #homeschool #teachers
  ```
- Facebook caption: "Try this one with your kid tonight. Is zero even, odd, or neither, and did you two agree?"
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb004`
- Hashtags: #parenting #homeschool #teachers

## Production notes
- **All math cards** in Manim from the strings above: "0" in cream, "EVEN"/"ODD" in gold, "NEITHER?" in warm glow. Nothing coloured as right or wrong in part 1.
- **Thinking beat:** a burning fire bar, not a numbered countdown (no count-along, compliance §A).
- **Loop:** the last frame is the first frame, so the replay starts on the question.
- **No gameplay, no Tallyclaw** (part 1 is Narrator only per F1).
- **Music:** `assets/audio/music/hub_theme.ogg`, low; it carries the 3 s silence. (Not `dragons_feast.ogg`, so nothing hints at Dragon's Feast.)
- **Cover frame:** 0-1 s, the "0" with EVEN / ODD / NEITHER? and the "Parents:" text.
- Slot per INDEX: week 1, post 2. (idea-bank.review §4 suggested I-055 before I-016 part 1, i.e. swap with MD-005; Justin's call.) Part 2 (MD-006) goes up early in week 2.

## Upload
- YouTube related video: beta walkthrough (MD-001) at first; **switch to MD-006 (part 2) once it's live** (F1 linking rule)
- Playlist: Dragon Puzzle
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own voice clone, animation) / Facebook yes (realistic AI voice, compliance §C)
- Facebook first-comment path: /fb004

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address (text and first spoken word: "Parents"), open loop; two alternatives written
- [x] One idea; follows its format's beats (F1 part 1: puzzle on frame one, pose, 3 s thinking beat, "Answer in part two" in place of F1's "Answer in the next video", loops)
- [x] Word count within budget for the target length (36 vs about 37)
- [x] Voice checklist passed (brand §11): addressed to the parent, not the child; zero em-dashes; zero X/Y reframes
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (the puzzle)
- [x] Titles and copy written to §7 (caption question is genuine, not "comment your answer")
- [x] Compliance checklist §A-H passed (no count-along; solvable, assumption stated; no app claim; game soundtrack)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off

## Fixes applied (2026-10-27)
From `review.md` (PASS, optional notes) and the coordinator:
- Closing line changed from "Answer in the next video." to "Answer in part two." (VO and on-screen text), because MD-005 posts between the parts. This departs from format-library F1's prescribed wording; the guide itself is unchanged (Justin's call whether to update it). Word count 37 to 36.
- Claims list: added the hook premise (adults hesitate too: Lichtenberg 1972 via Wikipedia).
- Slot order (review note 2) left as INDEX has it: week 1, post 2. Justin's call.
