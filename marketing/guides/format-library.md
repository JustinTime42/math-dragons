---
status: draft (awaiting accuracy review + Justin's approval)
guide: format-library
created: 2026-10-26
sources:
  - marketing/reports/Faceless short form video playbook.md
  - marketing/guides/brand-and-voice.md, content-strategy.md, compliance-checklist.md
---

# Format Library

Reusable video templates. Every idea in the idea bank names one of these formats; every script follows its beat structure. Formats are skeletons: each video still needs its own concept and point of view (`compliance-checklist.md` §F).

All formats are **vertical 9:16** unless marked otherwise. Timings are targets, not rules.

## Shared building blocks

| Block | What it is | Source |
|---|---|---|
| **Math card** | Exact numbers and equations animated on screen | Rendered from code (Manim or Remotion), never by an AI video model. The script contains the exact strings; the review checks them by running code |
| **Gameplay** | Real Math Dragons footage | Captured on a physical device (scrcpy) or a scripted integration-test run |
| **Hands** | Justin's hands demonstrating (finger tricks, paper, a phone) | Phone camera, overhead. Never faces, never kids, nothing identifying in frame (rings, mail, window views) |
| **Tallyclaw** | The mascot, talking | Rigged 2D puppet from style-bible art, mouth shapes from Rhubarb Lip Sync, ElevenLabs dragon voice |
| **Illustration** | Dragon-world art, scenes, history moments | Style-bible art and generated images in the same style; short text-free AI motion shots only where tested. Real historical people appear only in the flat illustration style, never photoreal and never speaking |
| **Narrator** | Justin's cloned voice | ElevenLabs |
| **Captions** | Burned-in, 2-4 words at a time | Assembly step |
| **Corner mark** | Small `playmathdragons.com` | Branding on every video, not a CTA |

## F1. Dragon Puzzle (two parts)

- **Pillar / series:** 1 / Dragon Puzzle (every other week)
- **Length:** part 1: 13-20 s; part 2: 20-30 s
- **Voices:** Narrator; Tallyclaw optional in part 2
- **Part 1 beats:**
  1. 0-1 s: the puzzle is already on screen. Text and the first spoken words address the parent: "Parents, try this with your kid."
  2. 1-8 s: pose it in one or two sentences.
  3. 8-12 s: a visible 3-second thinking beat.
  4. Final second: "Answer in the next video." Last frame is the puzzle again, so it loops.
- **Part 2 beats:**
  1. 0-2 s: same puzzle, "A very common answer is [wrong answer]." (Don't claim "most people" without a source.)
  2. 2-15 s: why that answer is tempting, then the right answer step by step (math cards).
  3. 15-25 s: the one-line takeaway a parent can reuse.
  4. Optional: a dry Tallyclaw button line.
- **Rules:** genuinely solvable and unambiguous (no order-of-operations rage-bait), with every assumption stated. Pitched so a parent and a 7-12-year-old can try it together, but always addressed to the parent. Facebook caption asks a genuine question, never "comment your answer".
- **Linking part 1 to part 2 on YouTube:** both go in the Dragon Puzzle playlist. Part 1's related video starts as the beta walkthrough; once part 2 is live, switch part 1's related video to part 2. Part 1's description says "Answer: see the Dragon Puzzle playlist." Part 2's related video is the walkthrough.
- **Example concept:** "5 dragons eat 5 cakes in 5 minutes. Every dragon eats at the same speed. How long do 100 dragons take to eat 100 cakes?" (A very common wrong answer: 100 minutes. Answer: 5 minutes. Adapted from the "widgets" item in Frederick's 2005 Cognitive Reflection Test.)

## F2. Tricks They Didn't Teach Us

- **Pillar / series:** 1 / Tricks They Didn't Teach Us
- **Length:** 20-30 s
- **Voices:** Narrator
- **Beats:**
  1. 0-1 s: the result first ("9 × 7 on your fingers.") with hands already in position.
  2. 1-15 s: the demo, slow enough to follow.
  3. 15-22 s: why it works, in one sentence.
  4. 22-28 s: honest origin, at the confidence the sources support. "The origin is unknown" is itself a claim and needs a source; if there's no good source, skip the origin beat.
  5. Final second: the trick's answer on screen again, so it loops.
- **Rules:** only tricks that are pedagogically sound or clearly presented as a fun shortcut. Origin claims carry their confidence level ("often called Japanese multiplication, though there's no clear evidence it's from Japan").
- **Example concept:** the finger trick for the 9 times table (9 × 1 through 9 × 10).

## F3. Homework Decoder

- **Pillar / series:** 2 / Homework Decoder
- **Length:** 30-60 s
- **Voices:** Narrator
- **Beats:**
  1. 0-2 s: the worksheet phrase on screen, recreated in our own style (never a photo of a real child's worksheet). VO: "Your kid's homework says 'make a ten.' Here's what that means."
  2. 2-20 s: the method, shown with math cards.
  3. 20-35 s: why teachers teach it, at the evidence level the research supports.
  4. 35-50 s: one way to help at home without taking over.
- **Rules:** calm and pro-teacher. Never mocks "new math". Never claims a method is the only right way. Recreated worksheets use our own layout: never copy a publisher's page design or branding.
- **Example concept:** "Make a ten": 8 + 5 becomes 8 + 2 + 3 = 10 + 3 = 13. (The Common Core grade 1 standard 1.OA.C.6 uses this exact strategy as its example.)

## F4. Tallyclaw Was There

- **Pillar / series:** 3 / Tallyclaw Was There
- **Length:** 30-60 s (history stories up to 3 min later)
- **Voices:** Tallyclaw leads; Narrator optional for the takeaway
- **Beats:**
  1. 0-2 s: Tallyclaw cold open with the myth or the moment ("Einstein failed math? I was there.").
  2. 2-25 s: what actually happened, with illustration and math cards.
  3. 25-40 s: one awe beat (why it matters, what it changed).
  4. Final line: a dry button that echoes the opening, so it loops.
- **Rules:** the eyewitness conceit never changes the facts. Legends are called legends. Every claim comes from the verified trivia bank (research report Appendix A) or passes a fresh accuracy review. Include the inconvenient detail when there is one, so commenters can't say we hid it.
- **Dependency:** needs the Tallyclaw puppet and voice. Until they exist, F4 runs with still Tallyclaw art and the Narrator, or waits.
- **Example concept:** Einstein didn't fail math. (He did fail the non-science sections of a university entrance exam at 16; the script says so.)

## F5. Parent Playbook Tip

- **Pillar / series:** 2 / none (or a later "Calm Math" series)
- **Length:** 30-45 s
- **Voices:** Narrator
- **Beats:**
  1. 0-2 s: the parent's moment, stated plainly ("Homework turned into tears again?").
  2. 2-15 s: one small, concrete step to try tonight.
  3. 15-30 s: why it helps, at the evidence level the research supports ("In one big study…"; "Researchers think…").
  4. 30-40 s: the step again, in five words.
- **Rules:** one tip only. No guilt, no lectures. Learning-science claims carry their confidence label from the research notes.
- **Example concept:** keep math practice short and stop while it's still fun.

## F6. Gameplay Payoff (promo as a lesson)

- **Pillar / series:** 4 / none
- **Length:** 20-40 s
- **Voices:** Narrator; Tallyclaw optional
- **Beats:**
  1. 0-2 s: a parent problem or a trick (as in F2, F3 or F5).
  2. 2-15 s: the useful part, complete on its own.
  3. 15-30 s: "Here's the game I built where she practices facts like 8 + 5." Gameplay as the payoff. (The app drills facts; it doesn't teach strategies like making ten or the finger trick, and a parent can't choose a single times table. Say only what the app does.)
  4. Last 2-5 s: the one CTA: "It's free during the beta. If you want in, it's playmathdragons.com."
- **Rules:** the video still teaches something if you stop before the gameplay. App claims only from `brand-and-voice.md` §5.2, and adaptivity only once the fix has shipped.

## F7. Dad Dev Diary

- **Pillar / series:** 4 / Dad Dev Diary
- **Length:** 20-45 s
- **Voices:** Narrator
- **Beats:**
  1. 0-2 s: the moment ("The first thing testers asked me to change" / "My daughter found a bug…"). Every premise is checked against the app: for example, the games do time answers (Dragon Eggs' falling eggs, Fire Trail's countdown and dragon speed).
  2. 2-25 s: the decision and the reasoning, with screen capture or gameplay.
  3. Last few seconds: a soft CTA (or none).
- **Rules:** true stories only. No code-on-screen walls; the audience is parents. Never a child's face, name or voice.

## F8. Join the Beta

- **F8a, walkthrough (horizontal 16:9, 60-120 s, long-form):** the destination for every Short's related-video link. Shows both join flows step by step (iPhone/iPad and Android, including the same-Google-account warning). `playmathdragons.com/yt` in the first line of the description. Featured on the channel.
- **F8b, "How to join" Short (vertical, 20-30 s):** what you get, who it's for, "it's free during the beta, playmathdragons.com". Points to F8a like every other Short.
- **Rules:** remake whenever the join flow changes. Never promise a step count or time that isn't true.

## Format mix: a 4-week cycle (12 slots at 3 a week)

| Pillar | Slots | Share | Formats |
|---|---|---|---|
| 1. Puzzles and tricks | 4 | 33% | Dragon Puzzle part 1 + part 2 (once a cycle), Tricks They Didn't Teach Us ×2 |
| 2. Parent playbook | 3 | 25% | Homework Decoder ×1, Parent Playbook Tip ×2 |
| 3. Tallyclaw was there | 3 | 25% | Tallyclaw Was There ×3 |
| 4. Math Dragons in action | 2 | 17% | Gameplay Payoff ×1, then Dad Dev Diary or the "How to join" Short (alternating cycles) |

- **Value to promo:** 10 to 2, about 5:1 (on the value-heavy side of the approved "about 4:1").
- **Tallyclaw:** hosts the 3 pillar-3 videos and cameos in Dragon Puzzle part 2, so about 4 of 12 (1 in 3, per the brand guide). Until his puppet exists, pillar 3 uses still art with the Narrator.
- **Over 90 days** (about 39 videos): roughly 13 / 10 / 10 / 6. Pillar 4 is judged on beta clicks and opt-ins rather than its post count.
- **Two-hook testing:** the alternate hook goes on a later video. Never re-upload the same video with a new hook (platforms treat that as unoriginal).
