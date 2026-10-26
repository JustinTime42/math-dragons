---
status: draft (awaiting accuracy review + Justin's approval)
guide: script-standards
created: 2026-10-26
sources:
  - marketing/reports/Faceless short form video playbook.md
  - marketing/guides/brand-and-voice.md, compliance-checklist.md, content-strategy.md, format-library.md
---

# Script Standards

How a Stage 3 treatment is written and what it must pass. A treatment is everything needed to make and publish one video: script, on-screen text, visuals per beat, claims list, titles and copy. It lives at `videos/MD-###/treatment.md` (template in §8).

## 1. The hook (first second)

- **Content on frame one.** No logo, intro card, "hey guys", or "in this video".
- **Stack three signals at once:** something to look at (puzzle, hands mid-trick, Tallyclaw mid-line, gameplay), a few words of on-screen text, and the first spoken words.
- **Address the adult** in the text or the first spoken line ("Parents:", "Your kid's homework…", "Try this with your kid").
- **Open a loop:** a question, a surprising claim (that's true), or a result shown before the method.
- Write two alternative hooks in every treatment. Justin picks one; the other can open a later video. Never re-upload a video just to swap its hook.

## 2. Structure

- **One idea per video.** If there are two, it's two videos.
- Follow the format's beats (`format-library.md`).
- **Visual change every 1-3 seconds** (practitioner consensus; no hard data). **Re-hook about every 10 seconds** in anything over 30 seconds.
- **Design the ending for the loop:** the reveal lands in the final second, or the last line runs into the first. No end cards on Shorts.

## 3. Words

House rules (our own working numbers, not research findings; adjust once we see real retention data):
- **Pace:** Narrator about 2.5 words per second (roughly 150 a minute): a 20-second video holds about 50 words of VO, 30 seconds about 75, 45 seconds about 110. **Tallyclaw is slower** (gravelly, with pauses): budget about 2 words per second for his lines. Count them.
- **Reading level:** 5th-7th grade. Short words, short sentences. (Unbounce's 2024 data supports this for landing pages; for video it's a house rule.)
- Voice per `brand-and-voice.md`: the Narrator in first person ("I built"), Tallyclaw in character, both talking to adults.
- Zero em-dashes. At most one "not X, it's Y" reframe per script (default zero).
- Spoken numbers are written the way they're said ("seven times eight"); on-screen numbers as digits ("7 × 8 = 56").

## 4. On-screen text and math

- **Captions:** burned in, 2-4 words at a time, matching the VO's words, except that numbers and equations display as digits and symbols ("7 × 8 = 56" for "seven times eight is fifty-six"). Accessibility: at least 4.5:1 contrast against what's behind them, no flashing more than 3 times a second, and on YouTube also upload the caption file.
- **Text callouts (house rule):** at most about 7 words, held long enough to read twice.
- **Every number, equation and answer on screen** is written in the treatment as an exact string and rendered from code. The accuracy review recomputes each one by running code.
- Placement follows the safe zones in `visual-style.md` (to be written). Until then, keep text and key visuals out of roughly the top 14%, the bottom 35% and 6% on each side (commonly cited figures derived from Meta's ad specs, not an official organic number), and confirm with one private test upload on each app.

## 5. Claims

- Every factual statement, number, date, attribution and joke premise goes in the treatment's **claims list**, each with its source (research notes, trivia bank item, app code path) and confidence level.
- **HIGH:** state plainly. **MODERATE:** "researchers think…", "often called…". **LOW / legend:** "legend says…", or don't use it.
- App claims only from `brand-and-voice.md` §5.2. The adaptivity claim may appear in a script but is published only after the adaptive-practice fix ships.
- The perk, if mentioned, uses the exact sentence.

## 5b. Audio and cover frame

- **Mix:** the voice always wins. Music sits well under the VO and ducks further during speech; SFX only where they add meaning (a correct-answer chime, a dragon roar on the button line). Audio sources per `compliance-checklist.md` §E.
- **Cover frame:** pick a frame that reads as a clear, adult-addressed promise with the on-screen text visible, and set it as the cover on Facebook (and YouTube, where Shorts covers can be chosen). No clickbait covers.

## 6. CTA

- At most one per video, after the payoff (`content-strategy.md` §6). Value videos usually have none.
- Spoken URL: plain `playmathdragons.com`.
- Never a CTA that's engagement bait on Facebook (`compliance-checklist.md` §D).

## 7. Titles and copy

- **YouTube title (house rule):** 40-65 characters, the payload in the first 40, in parent language. Delivers exactly what the video does.
- **Shorts description:** one or two sentences to parents, then `Free beta: playmathdragons.com` (text only; Shorts descriptions don't link), then a few (house rule: 3-5) parent/teacher/homeschool hashtags.
- **Facebook caption:** one or two sentences to parents, a genuine question if the video invites one. No link in the caption.
- **Facebook first comment:** `Free beta for iPhone, iPad and Android: playmathdragons.com/fb###`.

## 8. Treatment template

Copy into `videos/MD-###/treatment.md`:

```markdown
---
id: MD-###
status: treatment
pillar: 1 | 2 | 3 | 4
series: Dragon Puzzle | Tricks They Didn't Teach Us | Homework Decoder | Tallyclaw Was There | Dad Dev Diary | none
format: F1-F8
target_length_s:
voices: Narrator | Tallyclaw | both
platforms: YouTube Shorts, Facebook Reels
promo: yes | no
calendar_hook: (optional)
---

# MD-###: <working title>

## Concept
<one sentence: what the viewer gets>

## Hooks
- A: <first frame / on-screen text / first spoken words>
- B: <alternative>

## Script
| Time | Visual (block + description) | On-screen text | VO (speaker: line) |
|---|---|---|---|
| 0-1 s | | | |

Word count: <n> (budget <n>)

## Math strings (exact, rendered from code)
- `7 × 8 = 56`

## Claims list
| # | Claim (as written) | Source | Confidence |
|---|---|---|---|

## CTA
<none | the one line>

## Copy
- YouTube title:
- Shorts description:
- Facebook caption:
- Facebook first comment:
- Hashtags:

## Production notes
<gameplay to capture, art needed, Tallyclaw lines, music/SFX source, cover frame>

## Upload
- YouTube related video: <beta walkthrough | puzzle part 2>
- Playlist:
- AI disclosure: YouTube <yes/no, why> / Facebook <yes/no, why>
- Facebook first-comment path: /fb###
```

## 9. Script gate checklist (Stage 3)

- [ ] Hook: content on frame one, three stacked signals, adult address, open loop; two alternatives written
- [ ] One idea; follows its format's beats
- [ ] Word count within budget for the target length
- [ ] Voice checklist passed (`brand-and-voice.md` §11)
- [ ] Every number and equation listed as an exact string
- [ ] Claims list complete, with sources and confidence
- [ ] At most one CTA, correctly placed and worded
- [ ] Titles and copy written to §7
- [ ] Compliance checklist §A-H passed (`compliance-checklist.md`)
- [ ] Independent accuracy and sense review passed (`marketing/README.md`), results in `review.md`
- [ ] Justin's sign-off
