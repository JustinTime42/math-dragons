---
id: MD-006
status: treatment
pillar: 1
series: Dragon Puzzle
format: F1 (part 2)
target_length_s: 30
voices: Narrator (Tallyclaw optional, still-art button card)
platforms: YouTube Shorts, Facebook Reels
promo: no
calendar_hook: none
---

# MD-006: Is zero even? (Dragon Puzzle, part 2: the answer)

## Concept
The answer to MD-004: zero is even, why "neither" is tempting, and the one rule a parent can reuse with their kid.

## Hooks
- A: Frame one: the same puzzle card as MD-004 ("0" between EVEN and ODD, "NEITHER?" below); "NEITHER?" turns fire orange. On-screen text: "Parents: the answer". Narrator: "Parents, a very common answer is neither."
- B: Frame one: "NEITHER?" crossed out in fire orange, "EVEN" glowing. On-screen text: "Zero: even, odd, or neither?" Narrator: "Parents, here's the answer to the zero puzzle, and why neither is so tempting."

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-3 s | Math card from MD-004; "NEITHER?" turns fire orange | Parents: the answer / A very common answer: neither | Narrator: Parents, a very common answer is neither. |
| 3-9 s | The "0" dims to an empty plate (illustration), then back to "0" | Zero feels like nothing | Narrator: Zero feels like nothing, and nothing doesn't seem like it could be even or odd. |
| 9-16 s | "NEITHER?" crossed out; "EVEN" glows emerald. Math card: two empty groups side by side, then `0 = 0 + 0`, then `0 ÷ 2 = 0`, `remainder 0` | 0 is even / 0 = 0 + 0 | Narrator: But zero is even. Split zero into two equal groups: zero and zero. None left over. |
| 16-22 s | Math card: `6, 4, 2, 0` appear one at a time on a number line, each landing on a gold "even" tick | 6, 4, 2, 0 | Narrator: Count down by twos: six, four, two, zero. Zero lands right where the evens go. |
| 22-28 s | Rule card returns from MD-004 with a gold check next to "0" | Even = 2 equal groups, none left over | Narrator: So the rule your kid learned still works: two equal groups, none left over. Zero passes. |
| 28-30 s | Optional Tallyclaw still (unimpressed pose) with button card; if cut, hold the rule card | Tallyclaw: "Zero. Even. Next question." | (no VO; card held 2 s or more) |

Word count: 69 Narrator words (budget about 70 for the 28 s of speech). Tallyclaw card 4 words, text only.

## Math strings (exact, rendered from code)
- `0`
- `EVEN` / `ODD` / `NEITHER?`
- `0 = 0 + 0`
- `0 ÷ 2 = 0`
- `remainder 0`
- `6, 4, 2, 0`
- `Even = 2 equal groups, none left over`

Verified (python, 2026-10-27): `0 + 0 == 0`; `0 // 2 == 0` and `0 % 2 == 0`; `list(range(6, -1, -2)) == [6, 4, 2, 0]` and each `% 2 == 0`; `2 * 0 == 0`.

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|
| 1 | Zero is even | Appendix A #40 (HIGH); Wikipedia "Parity of zero" (fetched 2026-10-27: "zero is an integer multiple of 2, namely 0 × 2, so zero is even") | HIGH |
| 2 | "A very common answer is neither" | idea-bank.review §2 (I-016 cleared): Wikipedia "Parity of zero" (fetched): UK 7-year-olds, share answering "even" fell from 45% to 32% once "neither", "both" and "don't know" were offered; 1972 study (Lichtenberg), about two thirds of prospective teachers answered "False" to "zero is even"; Appendix A #40 ("many adults and kids hesitate") | MODERATE-HIGH (supports "very common"; never "most people") |
| 3 | Zero "feels like nothing" (why it's tempting) | Framing of the common error, no factual claim | n/a |
| 4 | Split zero into two equal groups: zero and zero, none left over | py (`0 + 0 == 0`, `0 % 2 == 0`) | HIGH |
| 5 | Counting down by twos, 6, 4, 2, 0, zero lands where the evens go | py; Wikipedia "Parity of zero" (zero "is neighbored on both sides by odd numbers") | HIGH |
| 6 | The rule (two equal groups, none left over) still works for zero | Same definition as MD-004 claim 1 | HIGH |
| 7 | Optional button: "Zero. Even. Next question." | Restates claim 1 | HIGH |

Not used: the study percentages on screen (secondary source, and they'd turn a puzzle answer into a survey). No app tie-in (Dragon's Feast's even category starts at 1, `lib/games/dragons_feast/systems/category_system.dart`).

## CTA
None (value video). Corner mark only.

## Copy
- YouTube title: `Is zero even? The answer, explained for parents` (47 characters)
- Shorts description:
  ```
  Zero is even, and the rule your kid already knows proves it. Part 1 is in the Dragon Puzzle playlist.
  Free beta: playmathdragons.com
  #parenting #homeschool #teachers
  ```
- Facebook caption: "Zero is even, and the rule your kid already knows proves it. Did anyone at your house say neither?"
- Facebook first comment: `Free beta for iPhone, iPad and Android: playmathdragons.com/fb006`
- Hashtags: #parenting #homeschool #teachers

## Production notes
- **Reuse MD-004's puzzle and rule cards** exactly, so part 2 reads as the answer to part 1.
- **Colors:** "NEITHER?" in fire orange then crossed out; "EVEN" emerald glow behind cream text (visual-style §6).
- **Tallyclaw (optional):** unimpressed still pose from `04_stone_dragon.png` / `09_stone_face.png`; text card only. Cut it if the still art isn't ready; the video stands without it.
- **Music:** `assets/audio/music/hub_theme.ogg`, same as part 1. SFX: the game's correct chime when "EVEN" glows.
- **Cover frame:** 9-16 s, "NEITHER?" crossed out and "0 is even" visible.
- Post early in week 2, then switch MD-004's related video to this one.

## Upload
- YouTube related video: beta walkthrough (MD-001)
- Playlist: Dragon Puzzle
- Audience: "No, it's not made for kids", set per video
- AI disclosure: YouTube no (Justin's own voice clone, animation, still art) / Facebook yes (realistic AI voice, compliance §C)
- Facebook first-comment path: /fb006
- After upload: set MD-004's YouTube related video to MD-006.

## Gate checklist (script-standards §9)
- [x] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [x] One idea; follows its format's beats (F1 part 2: same puzzle, "a very common answer", why tempting, step by step, reusable takeaway, optional Tallyclaw button)
- [x] Word count within budget for the target length (69 vs about 70)
- [x] Voice checklist passed (brand §11): adult address; "a very common answer", never "most people"; zero em-dashes; zero X/Y reframes
- [x] Every number and equation listed as an exact string
- [x] Claims list complete, with sources and confidence
- [x] At most one CTA, correctly placed and worded (none)
- [x] Titles and copy written to §7 (caption question is genuine)
- [x] Compliance checklist §A-H passed
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off
