---
status: draft (awaiting accuracy review + Justin's approval)
guide: visual-style
created: 2026-10-26
sources:
  - docs/VISUAL_DESIGN_GUIDE.md (the app's design system: palette, type, math typography)
  - assets/style_bible/ (approved dragon art and style anchor)
  - marketing/guides/brand-and-voice.md, format-library.md, script-standards.md
  - marketing/reports/Faceless short form video playbook.md (pipeline section)
---

# Visual Style Guide (video)

The videos should look like they come from the same world as the game: the app's colors, fonts and dragons. This guide adapts `docs/VISUAL_DESIGN_GUIDE.md` to vertical video.

## 1. Canvas

| Video | Size | Frame rate |
|---|---|---|
| Shorts and Reels (everything vertical) | 1080 × 1920 (9:16) | 30 fps (60 fps allowed for gameplay-heavy videos) |
| "Join the beta" walkthrough (F8a) | 1920 × 1080 (16:9) | 30 fps |

## 2. Safe zones

Keep captions, math and anything important inside the safe area. Platform buttons, captions, usernames and progress bars cover the edges.

- **Working numbers:** leave roughly the **top 14%, bottom 35% and 6% on each side** clear. These are commonly cited figures derived from Meta's ad specs, not an official organic number.
- On a 1080 × 1920 canvas that's a safe rectangle of about **x 65-1015, y 270-1250**.
- **Confirm with one private test upload** on YouTube and on Facebook before the first real video, and adjust these numbers if needed.
- Background art and gameplay can run full-bleed; only text and the key subject must stay inside.

## 3. Color

Straight from the app (`lib/theme/dragon_colors.dart`):

| Role | Color | Hex |
|---|---|---|
| Background, deep | Deep Void | `#1A0F3D` |
| Background | Dragon Purple | `#2D1B69` |
| Background, alt | Midnight Blue | `#1A1A2E` |
| Text | Text Primary (warm cream) | `#F0E6D3` |
| Accent, operators, highlight | Dragon Gold | `#F4A261` |
| Secondary accent | Warm Glow | `#F7C08A` |
| Correct | Emerald Flame | `#2A9D8F` |
| Wrong / "common wrong answer" | Fire Orange | `#E76F51` |

Each game has its own accent color in the app; use it when a video features that game.

## 4. Type

| Use | Font | Notes |
|---|---|---|
| Titles, series names, Tallyclaw's name | Cinzel Bold | Sparingly; never for numbers |
| Captions and callouts | Nunito Bold | Cream on a dark stroke or shadow |
| Math | Nunito Bold | Numbers cream, **operators and equals sign in gold**, as in the app |

Cinzel and Nunito (plus JetBrains Mono, used in the app for counters) are already in `assets/fonts/`; all three are free under the SIL Open Font License.

## 5. Captions

- 2-4 words at a time, centered horizontally, in the lower-middle of the safe area (roughly 55-65% of the frame height).
- Nunito Bold, cream (`#F0E6D3`), with a dark outline or shadow strong enough for 4.5:1 contrast over any background.
- The current word highlighted in gold.
- Numbers display as digits and symbols ("7 × 8 = 56").
- No flashing more than 3 times a second.

## 6. Math cards

- Dark purple background (Deep Void to Dragon Purple gradient) or a dimmed scene.
- Nunito Bold, large: equations about 120-160 px tall on the 1080-wide canvas, so they read on a small phone.
- Numbers cream, operators gold. Correct answers glow emerald (emerald on Dragon Purple is about 4.3:1, so use it only at large sizes or as a glow behind cream text); a "common wrong answer" is shown in fire orange and then crossed out.
- Animate one step at a time. Each step stays on screen long enough to read twice.
- Rendered from code (Manim or Remotion) from the exact strings in the treatment. Never typed into an AI image or video model.

## 7. Gameplay

- The app runs in portrait, so a capture fills a 9:16 frame naturally.
- Platform UI covers the bottom and right of the screen, where the game's own controls may sit. By default gameplay runs **full-bleed**, with captions and math kept inside the safe area. When a key game element would sit under platform UI, either **crop and zoom** to the part that matters, or place the gameplay in a framed window inside the safe area (at most about 550 × 979 px, keeping its 9:16 shape) on a branded background.
- No debug banners, no notification bar clutter, no personal data on screen.
- Captured on a physical device (the dev machine's emulator renders in software and drops frames).

## 8. Tallyclaw

The game's dragon art is painterly and in 3/4 view; a talking puppet needs its own art.

- **Look:** an ancient, battle-scarred veteran. Age shows in weathered scales, a chipped horn, an old healed scar; never gore. Gruff, proud expression at rest. Built from the style bible (`assets/style_bible/`) so he's clearly from the same world. **Color: the stone variant** (`04_stone_dragon.png`), weathered (Justin, 2026-10-26).
- **Puppet build:** a front-facing or slight 3/4 bust, in separate layers: body, head, jaw/mouth, eyes (with a blink frame), brows. **Nine mouth shapes** matching Rhubarb Lip Sync's set (A-H plus X for rest). Three or four poses: neutral, smug, pointing claw, unimpressed.
- **Motion:** subtle idle breathing and blinks; mouth driven by Rhubarb from his voice track. No full-body animation needed.
- **Placement:** usually one side of the frame at mid-height, inside the safe area, never covering the math. (Not the lower third: that falls in the bottom 35% no-text zone.)
- **Until the puppet exists:** still Tallyclaw art (one or two poses) with the Narrator, per `format-library.md` F4.

## 9. Illustration and AI imagery

- Match the style bible: generate with the style anchor (`assets/style_bible/approved/01_style_anchor.png`) as reference, and reject anything off-model.
- **No text inside AI-generated images.** Add all text in the edit.
- Real historical people appear only as flat illustrations, never photoreal and never speaking.
- AI motion (image-to-video) only for short, text-free hero shots (about 3-6 seconds), and only after a test with style-bible art shows the model keeps the look.
- No realistic people, children, classrooms or photoreal scenes (`compliance-checklist.md` §C).

## 10. Hands footage

- Overhead, well lit, on a plain dark surface (a deep purple cloth ties it to the palette).
- Hands only: no faces, rings, mail, screens with personal info, or window views.
- Clean, simple props: paper, a marker, a phone running the app.

## 11. Motion and pacing

- Cuts, not flashy transitions: a hard cut or a quick punch-in zoom.
- A visual change every 1-3 seconds (house rule, `script-standards.md` §2).
- Respect the eye: no strobing, no shaking text, no more than one moving element competing with the math.

## 12. Branding

- **Corner mark:** small `playmathdragons.com` in Nunito Bold, cream at about 70% opacity, top-left inside the safe area. On every video; it's branding, not a CTA.
- **Cover frame:** a clear, adult-addressed promise with the on-screen text visible (`script-standards.md` §5b).
- **F8a walkthrough thumbnail:** Tallyclaw or the game's dragon, "Join the free beta", the two platforms named in text (no store badges during the beta).

## 13. Open decisions (Justin)

Resolved 2026-10-26 (Justin): Tallyclaw is the stone variant.

Still open:
1. Caption style: approve the cream-with-gold-highlight look, or test two styles on the first videos?
