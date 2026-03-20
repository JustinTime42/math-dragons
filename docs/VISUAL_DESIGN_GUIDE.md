# Math Dragons: Visual Design Guide

> The complete design language for Math Dragons. This document is the single
> source of truth for all visual decisions — colors, typography, spacing,
> components, iconography, and motion. Every screen, widget, and game element
> in the app should reference this guide.

---

## Table of Contents

1. [Design Philosophy](#1-design-philosophy)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Layout](#4-spacing--layout)
5. [Elevation & Shadows](#5-elevation--shadows)
6. [Border Radius & Shapes](#6-border-radius--shapes)
7. [Iconography](#7-iconography)
8. [Component Library](#8-component-library)
9. [Game-Specific Palettes](#9-game-specific-palettes)
10. [Motion & Animation](#10-motion--animation)
11. [Haptic Feedback Map](#11-haptic-feedback-map)
12. [Responsive Breakpoints](#12-responsive-breakpoints)
13. [Accessibility](#13-accessibility)
14. [Asset Naming Conventions](#14-asset-naming-conventions)
15. [Dark Mode (Future)](#15-dark-mode-future)

---

## 1. Design Philosophy

### Core Principles

1. **Fantasy, Not Classroom.** Every visual element should feel like it belongs in
   a dragon's world. No graph paper, no chalkboards, no pencils. Rune stones,
   treasure, fire, scales, crystals.

2. **Warm and Inviting.** The palette is rich but warm. Glowing golds, deep purples,
   warm oranges. Even the darker tones feel cozy, not threatening. A dragon's lair
   should feel like a place you want to be.

3. **Readable First.** Fantasy styling never compromises readability. Numbers and
   operators must be instantly legible at a glance. Math content uses high-contrast,
   clean type. Decorative flourishes stay in borders and backgrounds.

4. **Age-Spanning.** The art style must appeal to ages 7 through 14+. This means:
   not baby/chibi, not grimdark. Think animated movie quality — appealing to kids,
   not embarrassing for teens. Wings of Fire meets Clash Royale.

5. **Consistent but Varied.** Each game has its own color accent and environmental
   theme, but they all clearly belong to the same world. Shared UI chrome, shared
   typography, shared component styles.

6. **Performance-Conscious.** Gradients and effects should be achievable with
   Flutter's rendering. Avoid effects that require complex shaders or that would
   hurt performance on budget Android devices.

---

## 2. Color System

### 2.1 Primary Palette

These are the foundational brand colors used across the entire app.

| Role | Name | Hex | RGB | Usage |
|------|------|-----|-----|-------|
| **Primary** | Dragon Purple | `#2D1B69` | 45, 27, 105 | App bars, primary buttons, hub background base |
| **Primary Light** | Amethyst | `#4A2D8F` | 74, 45, 143 | Hover/focus states, lighter surfaces |
| **Primary Dark** | Deep Void | `#1A0F3D` | 26, 15, 61 | Status bar, deepest backgrounds |
| **Secondary** | Dragon Gold | `#F4A261` | 244, 162, 97 | Currency display, highlights, CTAs, stars |
| **Secondary Light** | Warm Glow | `#F7C08A` | 247, 192, 138 | Gold accents, soft highlights |
| **Secondary Dark** | Aged Gold | `#D4843A` | 212, 132, 58 | Pressed gold buttons, darker accents |
| **Accent 1** | Emerald Flame | `#2A9D8F` | 42, 157, 143 | Success states, correct answers, XP bars |
| **Accent 2** | Fire Orange | `#E76F51` | 231, 111, 81 | Warnings, wrong answers, streak fire |
| **Background** | Midnight Blue | `#1A1A2E` | 26, 26, 46 | App background, game backgrounds |
| **Surface** | Night Surface | `#16213E` | 22, 33, 62 | Cards, dialogs, overlays |
| **Surface Light** | Twilight | `#1F2F50` | 31, 47, 80 | Elevated surfaces, input fields |

### 2.2 Semantic Colors

| Role | Hex | Usage |
|------|-----|-------|
| **Correct / Success** | `#2A9D8F` (Emerald Flame) | Correct answers, level complete, positive feedback |
| **Incorrect / Error** | `#E76F51` (Fire Orange) | Wrong answers, error states |
| **Warning** | `#F4A261` (Dragon Gold) | Caution states, low lives/flame |
| **Info** | `#5B8DEF` | Hints, tips, informational badges |
| **Disabled** | `#4A4A6A` | Disabled buttons, inactive elements |
| **Text Primary** | `#F0E6D3` | Main body text, headings (warm white) |
| **Text Secondary** | `#A89DB8` | Subtitle text, labels, descriptions |
| **Text on Primary** | `#F0E6D3` | Text on purple/dark backgrounds |
| **Text on Gold** | `#1A0F3D` | Text on gold/bright backgrounds |
| **Divider** | `#2A2A4A` | Subtle dividers between sections |

### 2.3 Gradient Definitions

Gradients are used sparingly for key surfaces. All gradients are linear.

| Name | Colors | Direction | Usage |
|------|--------|-----------|-------|
| **Lair Gradient** | `#1A0F3D` → `#2D1B69` → `#16213E` | Top to bottom | Hub background |
| **Gold Shimmer** | `#D4843A` → `#F4A261` → `#F7C08A` | Left to right | Currency bar, reward popups |
| **Fire Gradient** | `#E76F51` → `#F4A261` → `#FFF3B0` | Bottom to top | Flame effects, fire accents |
| **Success Glow** | `#1A6B60` → `#2A9D8F` → `#3CC4B1` | Center out (radial) | Correct answer burst |
| **Night Sky** | `#0D0D1A` → `#1A1A2E` → `#16213E` | Top to bottom | Game backgrounds |

### 2.4 Opacity Scale

| Token | Value | Usage |
|-------|-------|-------|
| `overlay-heavy` | 80% | Modal backdrops, pause overlay |
| `overlay-medium` | 60% | Semi-transparent panels |
| `overlay-light` | 30% | Subtle tinting, glass effects |
| `disabled` | 40% | Disabled elements |
| `hint` | 60% | Placeholder text |

---

## 3. Typography

### 3.1 Font Families

| Role | Font | Fallback | Weight Range | Usage |
|------|------|----------|--------------|-------|
| **Display** | **Cinzel** | Serif system | 700 (Bold) | App title, dragon names, world names, level names |
| **Heading** | **Cinzel** | Serif system | 400 (Regular), 700 (Bold) | Section headers, game titles, achievement names |
| **Body** | **Nunito** | Sans-serif system | 400, 600, 700 | All body text, descriptions, labels, UI text |
| **Math** | **Nunito** | Sans-serif system | 700 (Bold) | Numbers, operators, equations in gameplay |
| **Mono** | **JetBrains Mono** | Monospace system | 400, 700 | Score counters, timers, stat numbers |

**Why these fonts:**
- **Cinzel:** A serif with classical, engraved stone quality — perfect for runes, dragon
  lore, and fantasy headings. Reads well at display sizes. Free on Google Fonts.
- **Nunito:** Rounded sans-serif that's friendly and highly legible. Perfect for body
  text and math content. Great at small sizes on mobile. Free on Google Fonts.
- **JetBrains Mono:** Tabular (fixed-width) numerals make score counters and timers
  align perfectly. Numbers don't jump around when values change. Free.

### 3.2 Type Scale

All sizes in logical pixels (dp). Scale factor 1.0 = base.

| Token | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|----------------|-------|
| `displayLarge` | 40 | Cinzel Bold | 1.2 | 0.5 | App title "Math Dragons" only |
| `displayMedium` | 32 | Cinzel Bold | 1.2 | 0.3 | World names, dragon evolution stage names |
| `displaySmall` | 28 | Cinzel Regular | 1.2 | 0.2 | Game titles on hub cards |
| `headlineLarge` | 24 | Cinzel Bold | 1.3 | 0.1 | Screen titles, level names |
| `headlineMedium` | 20 | Nunito Bold | 1.3 | 0 | Section headers, achievement names |
| `headlineSmall` | 18 | Nunito SemiBold | 1.3 | 0 | Subsection headers |
| `titleLarge` | 18 | Nunito Bold | 1.4 | 0 | Card titles, dialog titles |
| `titleMedium` | 16 | Nunito SemiBold | 1.4 | 0.1 | List item titles |
| `titleSmall` | 14 | Nunito SemiBold | 1.4 | 0.1 | Small titles, tags |
| `bodyLarge` | 16 | Nunito Regular | 1.5 | 0 | Primary body text |
| `bodyMedium` | 14 | Nunito Regular | 1.5 | 0 | Secondary body text, descriptions |
| `bodySmall` | 12 | Nunito Regular | 1.5 | 0.2 | Captions, fine print |
| `labelLarge` | 16 | Nunito Bold | 1.0 | 0.5 | Button text, tabs |
| `labelMedium` | 14 | Nunito SemiBold | 1.0 | 0.5 | Small button text, chips |
| `labelSmall` | 12 | Nunito SemiBold | 1.0 | 0.5 | Tiny labels, badges |

### 3.3 Math Content Typography

Math content in gameplay has special requirements for instant legibility:

| Element | Font | Size | Weight | Color | Notes |
|---------|------|------|--------|-------|-------|
| **Problem numbers** | Nunito | 32-48 | Bold | `#F0E6D3` | Large, clear, centered |
| **Operators (+, -, x, /)** | Nunito | 28-40 | Bold | `#F4A261` (gold) | Operators are gold to distinguish from numbers |
| **Equals sign** | Nunito | 28-40 | Bold | `#F4A261` | Same as operators |
| **Answer options** | Nunito | 24-36 | Bold | `#F0E6D3` | On game tiles/bubbles/eggs |
| **Score counter** | JetBrains Mono | 20 | Bold | `#F4A261` | Tabular nums, right-aligned |
| **Timer** | JetBrains Mono | 18 | Regular | `#A89DB8` | Tabular nums |
| **Streak counter** | JetBrains Mono | 24 | Bold | `#E76F51` → `#F4A261` | Gradient text for active streaks |
| **Category label** | Nunito | 16 | SemiBold | `#F0E6D3` | Dragon's Feast category display |

### 3.4 Number Rendering Rules

1. Numbers in gameplay are ALWAYS **Nunito Bold** — never use the display font for math.
2. Minimum touch target for any number: **44x44dp** (accessibility requirement).
3. Numbers on colored backgrounds must pass WCAG AA contrast (4.5:1 ratio minimum).
4. Operators are always gold (`#F4A261`) to visually separate from number values.
5. Score/counter numbers use **JetBrains Mono** so digits don't shift horizontally.

---

## 4. Spacing & Layout

### 4.1 Spacing Scale

Based on a 4dp base unit. Use these tokens exclusively — no arbitrary pixel values.

| Token | Value | Usage |
|-------|-------|-------|
| `xxs` | 2dp | Hairline gaps, icon padding |
| `xs` | 4dp | Tight spacing, within compact components |
| `sm` | 8dp | Standard inner padding, between related items |
| `md` | 12dp | Card internal padding |
| `base` | 16dp | Default spacing between sections, screen padding |
| `lg` | 24dp | Between major sections |
| `xl` | 32dp | Between screen regions |
| `xxl` | 48dp | Top/bottom screen padding, hero spacing |
| `xxxl` | 64dp | Major visual breaks |

### 4.2 Screen Layout

```
┌──────────────────────────────────────┐
│ Status Bar (system)                  │  System-managed
├──────────────────────────────────────┤
│ App Bar (56dp)                       │  Dragon Scales | Title | Settings
│ ═══════════════════════════════════  │
│                                      │
│  ┌──────────────────────────────┐   │  ← 16dp horizontal padding
│  │                              │   │
│  │     Content Area             │   │
│  │                              │   │
│  │                              │   │
│  │                              │   │
│  │                              │   │
│  └──────────────────────────────┘   │
│                                      │
├──────────────────────────────────────┤
│ Bottom Bar (50-60dp)                 │  Optional
├──────────────────────────────────────┤
│ Navigation Bar (system)              │  System-managed
└──────────────────────────────────────┘
```

### 4.3 Grid System

- **Hub screen:** No strict grid. Organic, environment-based layout.
- **Game cards:** 2-column grid with `sm` (8dp) gap.
- **Settings:** Single column, full width list items.
- **Store:** 2-column grid for items, single column for featured.
- **Game HUD:** Fixed position elements (score top-right, back top-left, category top-center).

### 4.4 Safe Areas

- **Top safe area:** Respect system status bar + 8dp padding.
- **Bottom safe area:** Respect system navigation bar + 8dp padding.
- **Game content:** Must not be obscured by HUD elements. Maintain 56dp clear at top,
  60dp clear at bottom (if bottom bar is showing).
- **Touch targets:** Minimum 44x44dp for all interactive elements. 48x48dp preferred.

---

## 5. Elevation & Shadows

Flutter's Material elevation system, customized for the dark fantasy theme.

| Level | Elevation | Shadow Color | Usage |
|-------|-----------|-------------|-------|
| **Ground** | 0 | None | Background, flat surfaces |
| **Card** | 2 | `#000000` @ 30% | Game cards, info panels |
| **Raised** | 4 | `#000000` @ 35% | Buttons, floating elements |
| **Overlay** | 8 | `#000000` @ 40% | Dialogs, bottom sheets |
| **Modal** | 12 | `#000000` @ 50% | Modal dialogs, pause overlay |
| **Top** | 16 | `#000000` @ 50% | Tooltips, snackbars |

### Glow Effects

Instead of traditional shadows, key interactive elements use colored glow:

| Element | Glow Color | Radius | Usage |
|---------|-----------|--------|-------|
| **Active game card** | Game accent @ 30% | 12dp | Card hover/selected state |
| **Correct answer** | `#2A9D8F` @ 40% | 16dp | Flash on correct answer |
| **Wrong answer** | `#E76F51` @ 40% | 16dp | Flash on wrong answer |
| **Gold button** | `#F4A261` @ 25% | 8dp | Primary CTA glow |
| **Dragon companion** | `#F4A261` @ 15% | 24dp | Subtle ambient glow |
| **Currency counter** | `#F4A261` @ 20% | 8dp | Scales display glow |

---

## 6. Border Radius & Shapes

| Token | Value | Usage |
|-------|-------|-------|
| `none` | 0 | Sharp edges (rarely used) |
| `sm` | 4dp | Small chips, tags, badges |
| `md` | 8dp | Buttons, input fields, small cards |
| `lg` | 12dp | Cards, dialogs, panels |
| `xl` | 16dp | Large cards, featured content |
| `xxl` | 24dp | Bottom sheets, modal panels |
| `full` | 9999dp | Circular elements (avatars, FABs, bubbles) |

### Special Shapes

- **Game cards on hub:** `lg` (12dp) radius with a 2dp border in the game's accent color.
- **Eggs (Dragon Eggs game):** Oval/ellipse, rendered as sprites not CSS.
- **Rune nodes (Dragon Runes):** Circular with `full` radius.
- **Grid cells (Dragon's Feast, Fire Trail):** `sm` (4dp) radius or none.
- **Buttons:** `md` (8dp) radius. Gold buttons have a 1dp gold border.
- **Achievement badges:** Hexagonal shape (rendered as image/SVG).

---

## 7. Iconography

### 7.1 Icon Style

- **Style:** Filled icons with a slight rounded quality. Not outline/wireframe.
- **Base size:** 24dp (standard), 20dp (compact), 32dp (featured).
- **Color:** Inherit from text color or use gold for active/important icons.
- **Source:** Flutter's built-in Material Icons + custom dragon-themed icons as SVG.

### 7.2 Custom Icons Needed

| Icon | Description | Sizes Needed | Usage |
|------|-------------|-------------|-------|
| **Dragon Scale** (currency) | Single golden scale | 16, 24, 32 | Currency display throughout app |
| **Star** (filled, empty, half) | Fantasy-styled star | 16, 24, 32 | Level rating, 1-3 stars |
| **Dragon Egg** | Oval egg with cracks | 24, 48 | Dragon Eggs game icon |
| **Flame** | Stylized fire | 24, 48 | Fire Trail game icon |
| **Rune Stone** | Circular stone with glyph | 24, 48 | Dragon Runes game icon |
| **Treasure/Feast** | Goblet or gem | 24, 48 | Dragon's Feast game icon |
| **Achievement Badge** | Hexagonal frame | 48, 64 | Achievement display |
| **Streak Fire** | Flame with number | 24 | Streak indicator |
| **Hint Sparkle** | Magical sparkle/eye | 24 | Hint button in Dragon Runes |
| **Pause** | Dragon-themed pause | 24 | In-game pause button |
| **Settings Gear** | Gear with dragon tooth | 24 | Settings button |
| **Back Arrow** | Dragon-wing styled arrow | 24 | Navigation back |

### 7.3 Navigation Icons

Use standard Material Icons for system-level navigation to maintain familiarity:
- `Icons.arrow_back` — Back navigation
- `Icons.settings` — Settings (until custom icon is ready)
- `Icons.volume_up` / `Icons.volume_off` — Sound toggle
- `Icons.music_note` / `Icons.music_off` — Music toggle
- `Icons.vibration` — Haptics toggle

---

## 8. Component Library

### 8.1 Buttons

#### Primary Button (Gold)
```
┌─────────────────────────────┐
│                             │  Height: 48dp
│    ✦  PLAY AGAIN  ✦        │  Padding: 16dp horizontal
│                             │  Radius: 8dp
└─────────────────────────────┘  Background: Gold Shimmer gradient
                                  Text: Deep Void (#1A0F3D), Nunito Bold 16
                                  Border: 1dp #D4843A
                                  Shadow: Gold glow @ 25%, 8dp radius
```

#### Secondary Button (Purple Outline)
```
┌─────────────────────────────┐
│                             │  Height: 48dp
│      BACK TO HUB            │  Padding: 16dp horizontal
│                             │  Radius: 8dp
└─────────────────────────────┘  Background: Transparent
                                  Text: #F0E6D3, Nunito SemiBold 16
                                  Border: 1.5dp #4A2D8F
```

#### Icon Button (Circular)
```
  ┌───┐
  │ ⚙ │   Size: 44x44dp
  └───┘   Background: Surface (#16213E) @ 80%
          Icon: 24dp, #A89DB8
          Radius: full (circular)
```

#### Danger Button (Red)
```
Used only for destructive actions (delete save data, etc.)
Background: #C0392B
Text: White
Radius: 8dp
```

### 8.2 Cards

#### Game Card (Hub Screen)
```
┌───────────────────────────────┐
│  ┌─────────────────────────┐  │  Outer: 12dp radius, 2dp accent border
│  │                         │  │
│  │    [Game Environment     │  │  Image area: 60% of card height
│  │     Thumbnail]          │  │
│  │                         │  │
│  ├─────────────────────────┤  │
│  │  🔥 Fire Trail          │  │  Title: displaySmall (Cinzel 28)
│  │  Level 12 • ★★☆        │  │  Subtitle: bodyMedium (Nunito 14)
│  │  ▓▓▓▓▓▓▓▓░░░ 73%      │  │  Progress bar: 4dp height, accent color
│  └─────────────────────────┘  │
└───────────────────────────────┘
  Border color = game's accent color
  Background: Surface (#16213E)
  Glow on tap: accent @ 30%
```

#### Achievement Card
```
┌──────────────────────────────────┐
│  ⬡  Chain Lightning              │  Badge: 48dp hexagonal icon
│     Build a 10-streak            │  Title: titleMedium (Nunito SemiBold 16)
│     🟡 +50 scales               │  Desc: bodySmall (12)
│     ▓▓▓▓▓▓▓░░░ 7/10             │  Progress if not yet unlocked
└──────────────────────────────────┘
  Locked: muted colors, badge greyed out
  Unlocked: full color, gold border, subtle glow
```

#### Daily Challenge Card
```
┌──────────────────────────────────┐
│  ☀ TODAY'S CHALLENGE        🔥5  │  Streak flame + count
│  ──────────────────────────────  │
│  ☐ Score 200 in Dragon Runes    │  Checkbox items
│  ☑ Play Dragon Eggs             │  Checked = green
│  ☐ Get a 5-streak in any game   │
│  ──────────────────────────────  │
│  Reward: 25 + 10 streak bonus 🟡│  Gold text
└──────────────────────────────────┘
  Background: Surface with subtle gold top border
```

### 8.3 HUD Elements (In-Game)

#### Top Bar (In-Game)
```
┌──────────────────────────────────────┐
│  ←   "Multiples of 7"    🟡 1,234   │  Height: 48dp
│      World 3 • Level 4    ★★☆       │  Semi-transparent background
└──────────────────────────────────────┘
  Back button: left
  Category/Level: center (Nunito SemiBold 14)
  Scales: right (JetBrains Mono Bold 20, gold)
  Stars: right-aligned below scales
  Background: #1A0F3D @ 80%
```

#### Score Popup (Floating)
```
  +3 🟡     Font: JetBrains Mono Bold 20
             Color: Gold, fading to transparent
             Animation: Float up 40dp over 800ms, fade out
```

#### Streak Indicator
```
  🔥 x7      Font: JetBrains Mono Bold 24
              Color: Fire gradient (orange → gold)
              Animation: Pulse scale 1.0 → 1.1 on increment
              Position: Below score, right side
```

### 8.4 Dialogs

#### Standard Dialog
```
┌──────────────────────────────────┐
│                                  │  Radius: 16dp
│     ✦ Level Complete! ✦         │  Background: Surface (#16213E)
│                                  │  Border: 1dp #2A2A4A
│     ★ ★ ★                       │  Overlay: 80% black behind
│     Score: 2,450                 │
│     Accuracy: 94%                │
│     Streak: 12                   │
│                                  │
│     +45 🟡                       │
│                                  │
│  ┌──────────┐  ┌──────────────┐  │
│  │   HUB    │  │ ✦ NEXT LEVEL │  │  Secondary left, Primary right
│  └──────────┘  └──────────────┘  │
└──────────────────────────────────┘
```

#### Pause Overlay
```
Full screen, #1A0F3D @ 85%
Center content:
  ⏸ PAUSED (Cinzel Bold 32)
  [Resume]  ← Primary gold button
  [Settings] ← Secondary button
  [Quit to Hub] ← Secondary button
```

### 8.5 Progress Bars

#### Level Progress (in card)
```
  ▓▓▓▓▓▓▓░░░░  73%
  Height: 4dp
  Background: #2A2A4A
  Fill: game's accent color
  Radius: full (2dp)
```

#### Dragon Evolution (hub)
```
  ▓▓▓▓▓▓▓▓░░░░░░  Stage 2 → 3
  Height: 8dp
  Background: #2A2A4A
  Fill: Gold Shimmer gradient
  Radius: full (4dp)
  Label below: "Young Dragon — 450/750 scales"
```

#### XP/Accuracy Bar (result screen)
```
  ▓▓▓▓▓▓▓▓▓░  94% Accuracy
  Height: 12dp
  Background: #2A2A4A
  Fill: Emerald (#2A9D8F) for good, Fire Orange for poor
  Radius: 6dp
  Animated fill from 0% to value over 1 second
```

### 8.6 Input Components

#### Parental Gate (Purchase Verification)
```
Standard Flutter text input (number keyboard)
Background: Surface (#16213E)
Text: #F0E6D3
Border: 1dp #4A2D8F
Radius: 8dp
Label: "To continue, solve: 23 × 17 = ?" (bodyLarge)
Context: Cinzel heading "Parent Check"
Submit button: Primary action style
```

#### Text Input (Dragon Name)
```
Background: Surface Light (#1F2F50)
Text: #F0E6D3
Placeholder: #A89DB8 @ 60%
Border: 1dp #4A2D8F, 2dp #F4A261 on focus
Radius: 8dp
Height: 48dp
```

#### Toggle Switch
```
Active: Gold (#F4A261) track, white thumb
Inactive: #4A4A6A track, #A89DB8 thumb
```

---

## 9. Game-Specific Palettes

Each game has a unique accent color and environmental theme while sharing the
global design system.

### 9.1 Dragon Runes (Number Links)

| Role | Hex | Usage |
|------|-----|-------|
| **Accent** | `#9B59B6` (Mystic Purple) | Card border, UI accents, progress bars |
| **Accent Light** | `#BB8FCE` | Rune glow, magical effects |
| **Accent Dark** | `#6C3483` | Pressed states, shadows |
| **Environment** | Ancient stone chamber with glowing purple runes | |
| **Rune node (inactive)** | `#3D3D5C` with `#9B59B6` border | Stone appearance |
| **Rune node (selected)** | `#9B59B6` glow, `#BB8FCE` fill | Activated rune |
| **Connection line** | `#BB8FCE` → `#F7C08A` gradient | Magical energy |
| **Spell completion** | Purple + gold particle burst | |

### 9.2 Fire Trail (Math Snake)

| Role | Hex | Usage |
|------|-----|-------|
| **Accent** | `#E74C3C` (Dragon Red) | Card border, UI accents |
| **Accent Light** | `#F1948A` | Flame highlights |
| **Accent Dark** | `#C0392B` | Pressed states |
| **Environment** | Night sky with clouds, stars, volcanic glow | |
| **Dragon head** | Sprite, warm orange/red tones | Player character |
| **Flame trail** | `#E74C3C` → `#F4A261` → `#FFF3B0` gradient | Body trail |
| **Answer gems (correct)** | `#2A9D8F` sparkle | Emerald gems |
| **Answer gems (wrong)** | `#E76F51` dull | Dark crystals |
| **Grid lines** | `#2A2A4A` @ 30% | Subtle grid |

### 9.3 Dragon Eggs (Bubble Pop)

| Role | Hex | Usage |
|------|-----|-------|
| **Accent** | `#3498DB` (Sky Blue) | Card border, UI accents |
| **Accent Light** | `#85C1E9` | Egg highlights |
| **Accent Dark** | `#2471A3` | Pressed states |
| **Environment** | Cliff-side nests, morning sky, clouds | |
| **Number eggs** | Various warm colors (see below) | Number-containing eggs |
| **Operator eggs** | Gold tint to all operator eggs | Operators stand out |
| **Division eggs** | `#8E44AD` (distinct purple) | Visual distinction at level 5+ |
| **Hatch animation** | Crack → white flash → baby dragon sprite | |
| **Combo indicator** | Rainbow gradient cycling | Active combo |

**Egg color by number range:**
| Range | Egg Color | Hex |
|-------|-----------|-----|
| 1-3 | Warm Cream | `#F5E6CA` |
| 4-6 | Soft Blue | `#AED6F1` |
| 7-9 | Soft Green | `#A9DFBF` |
| 10-12 | Soft Orange | `#F5CBA7` |
| Operators | Gold Tint | `#F4D03F` border |

### 9.4 Dragon's Feast (Muncher)

| Role | Hex | Usage |
|------|-----|-------|
| **Accent** | `#27AE60` (Treasure Green) | Card border, UI accents |
| **Accent Light** | `#82E0AA` | Correct eat glow |
| **Accent Dark** | `#1E8449` | Pressed states |
| **Environment** | Treasure cavern with gem-studded walls | |
| **Dragon character** | Sprite, green/gold tones | Player character |
| **Grid cells** | `#16213E` with subtle gem texture | Board |
| **Correct items** | Glowing gold border when eaten | Flash effect |
| **Wrong items** | Red flash when eaten | |
| **Enemy guardians** | Dark red/purple tones | Contrasts with player |
| **Power-up: freeze** | Ice blue (`#AED6F1`) | Fire breath effect |
| **Power-up: wings** | Gold shimmer | Fly-over effect |

### 9.5 Category-Specific Gem Colors (Dragon's Feast)

| Category Type | Gem Style | Color Hint |
|---------------|-----------|------------|
| Multiples | Round gems | `#3498DB` blue |
| Primes | Diamond-cut | `#9B59B6` purple |
| Even/Odd | Split gems | `#27AE60` / `#E67E22` |
| Perfect squares | Square gems | `#F39C12` gold |
| Factors of N | Clustered gems | `#1ABC9C` teal |
| Greater/Less than | Arrow gems | `#E74C3C` red |

---

## 10. Motion & Animation

### 10.1 Timing Curves

| Token | Curve | Duration | Usage |
|-------|-------|----------|-------|
| `quick` | `Curves.easeOut` | 150ms | Button press, icon change |
| `standard` | `Curves.easeInOut` | 250ms | Panel slide, card flip |
| `emphasis` | `Curves.easeOutBack` | 350ms | Achievement popup, scale bounce |
| `dramatic` | `Curves.easeInOutCubic` | 500ms | Screen transitions, dragon evolution |
| `slow` | `Curves.easeInOut` | 800ms | Background transitions, ambient |
| `spring` | `Curves.elasticOut` | 600ms | Bounce effects, correct answer celebration |

### 10.2 Screen Transitions

| Transition | Type | Duration | Usage |
|------------|------|----------|-------|
| Hub → Game | Fade + scale up | 400ms | Game portal opens outward |
| Game → Hub | Fade + scale down | 300ms | Return to hub |
| Game → Result | Slide up | 350ms | Results panel slides up from bottom |
| Result → Game | Slide down | 250ms | Play again, panel dismisses |
| Any → Dialog | Fade in + scale from 0.9 | 250ms | Dialog appearance |
| Dialog → Dismiss | Fade out + scale to 0.9 | 200ms | Dialog dismissal |

### 10.3 In-Game Animations

| Animation | Description | Duration |
|-----------|-------------|----------|
| **Correct answer** | Element pulses green, +score floats up, particles | 600ms |
| **Wrong answer** | Element shakes (3px, 3 cycles), flashes red | 400ms |
| **Streak increment** | Flame icon pulses, number bounces | 300ms |
| **Level complete** | Stars fill in sequence, score tallies up | 1200ms |
| **Scales earned** | Gold particles fly from center to counter | 800ms |
| **Achievement unlock** | Badge slides down from top, holds 2s, slides up | 3000ms total |
| **Dragon evolution** | Bright flash, silhouette morphs, new form reveals | 2500ms |
| **Egg hatch** | Crack lines appear, shell breaks, baby dragon flies | 1000ms |
| **Snake eat** | Quick chomp, gem dissolves into sparkles | 300ms |
| **Rune connect** | Line draws between nodes, glow intensifies | 200ms per node |
| **Feast munch** | Dragon bites, gem shatters into particles | 250ms |

### 10.4 Ambient Animations

| Animation | Description | Loop |
|-----------|-------------|------|
| **Dragon idle (hub)** | Gentle breathing, occasional wing stretch | 4-6s cycle |
| **Dragon reaction** | Looks toward tapped game, small animation | On interaction |
| **Hub particles** | Floating ember particles, slow drift | Continuous |
| **Background glow** | Subtle pulsing light in hub environment | 8s cycle |
| **Currency shimmer** | Gold scales counter has subtle shimmer | 3s cycle |
| **Star twinkle** | Earned stars occasionally sparkle | Random, 5-10s |

---

## 11. Haptic Feedback Map

All haptics are toggleable via Settings. When enabled:

| Event | Haptic Type | Flutter API | Intensity |
|-------|------------|-------------|-----------|
| **Correct answer** | Light impact | `HapticFeedback.lightImpact()` | Subtle, satisfying |
| **Wrong answer** | Heavy impact | `HapticFeedback.heavyImpact()` | Brief sharp buzz |
| **Streak milestone (5, 10)** | Double tap | 2x `lightImpact()` 100ms apart | Celebratory |
| **Level complete** | Medium + light | `mediumImpact()` then `lightImpact()` | Positive |
| **Dragon evolution** | Selection click x3 | 3x `selectionClick()` 150ms apart | Momentous |
| **Achievement unlocked** | Heavy + medium + light | Descending sequence | Attention |
| **Scales earned** | Selection click | `HapticFeedback.selectionClick()` | Background |
| **Egg hatch** | Medium impact | `HapticFeedback.mediumImpact()` | Cracking feel |
| **Egg select** | Selection click | `HapticFeedback.selectionClick()` | Soft tap |
| **Munch (Feast)** | Light impact | `HapticFeedback.lightImpact()` | Quick nom |
| **Rune node select** | Selection click | `HapticFeedback.selectionClick()` | Light pulse |
| **Snake direction** | Selection click | `HapticFeedback.selectionClick()` | Directional |
| **Button press** | Selection click | `HapticFeedback.selectionClick()` | Standard |
| **Error/invalid** | Heavy impact | `HapticFeedback.heavyImpact()` | Warning buzz |

---

## 12. Responsive Breakpoints

Math Dragons is mobile-first. Tablet is a nice-to-have for v1.

| Breakpoint | Width | Layout Adjustments |
|------------|-------|-------------------|
| **Small phone** | < 360dp | Reduce spacing by 25%, smaller fonts for non-math content |
| **Standard phone** | 360-411dp | Default sizing (this guide's base values) |
| **Large phone** | 412-599dp | Slightly more generous spacing |
| **Tablet (future)** | 600dp+ | 2-column hub, larger game area, bigger touch targets |

### Game Canvas Scaling

Each game's play area scales to fill available width while maintaining aspect ratio:
- **Fire Trail:** Square grid, centered. Side margins on wide screens.
- **Dragon Eggs:** Full width, height-limited. Eggs scale proportionally.
- **Dragon Runes:** Circular layout, centered. Scales to smallest dimension.
- **Dragon's Feast:** 5x5 grid, square. Centered with margins.

---

## 13. Accessibility

### Contrast Ratios (WCAG AA Minimum)

All color combinations used for text must meet these minimums:

| Combination | Ratio | Passes? |
|-------------|-------|---------|
| Text Primary (#F0E6D3) on Background (#1A1A2E) | 11.3:1 | AA, AAA |
| Text Primary (#F0E6D3) on Surface (#16213E) | 9.8:1 | AA, AAA |
| Text Secondary (#A89DB8) on Background (#1A1A2E) | 4.7:1 | AA |
| Gold (#F4A261) on Background (#1A1A2E) | 6.2:1 | AA, AAA |
| Gold (#F4A261) on Surface (#16213E) | 5.4:1 | AA |
| Text on Gold (#1A0F3D) on Gold (#F4A261) | 7.1:1 | AA, AAA |
| Emerald (#2A9D8F) on Background (#1A1A2E) | 4.8:1 | AA |
| Fire Orange (#E76F51) on Background (#1A1A2E) | 4.6:1 | AA |

### Touch Targets

- **Minimum:** 44x44dp for all interactive elements (WCAG 2.1 AA)
- **Preferred:** 48x48dp for primary actions
- **Game tiles:** Sized to game grid, but never below 44dp
- **Spacing between targets:** Minimum 8dp to prevent accidental taps

### Screen Reader Support

- All game screens provide a text summary via `Semantics` widget
- Achievement badges have descriptive labels
- Score and progress are announced on change
- Non-interactive decorative elements are excluded from semantics tree

---

## 14. Asset Naming Conventions

### File Naming

All asset files use `snake_case` with descriptive, hierarchical names:

```
assets/
├── images/
│   ├── dragons/
│   │   ├── dragon_egg.png
│   │   ├── dragon_hatchling.png
│   │   ├── dragon_fledgling.png
│   │   ├── dragon_young.png
│   │   ├── dragon_adult.png
│   │   ├── dragon_elder.png
│   │   ├── dragon_idle_spritesheet.png
│   │   └── dragon_color_variant_red.png
│   ├── hub/
│   │   ├── hub_background.png
│   │   ├── hub_rune_portal.png
│   │   ├── hub_fire_tunnel.png
│   │   ├── hub_egg_nest.png
│   │   └── hub_feast_table.png
│   ├── games/
│   │   ├── runes/
│   │   │   ├── rune_node_inactive.png
│   │   │   ├── rune_node_active.png
│   │   │   └── rune_spell_particle.png
│   │   ├── fire_trail/
│   │   │   ├── fire_dragon_head.png
│   │   │   ├── fire_gem_correct.png
│   │   │   └── fire_gem_wrong.png
│   │   ├── dragon_eggs/
│   │   │   ├── egg_cream.png
│   │   │   ├── egg_blue.png
│   │   │   ├── egg_green.png
│   │   │   ├── egg_orange.png
│   │   │   ├── egg_division.png
│   │   │   ├── egg_operator.png
│   │   │   ├── egg_crack_1.png
│   │   │   ├── egg_crack_2.png
│   │   │   └── baby_dragon_fly.png
│   │   └── dragons_feast/
│   │       ├── feast_dragon.png
│   │       ├── feast_gem_blue.png
│   │       ├── feast_gem_purple.png
│   │       ├── feast_gem_gold.png
│   │       ├── feast_enemy_guardian.png
│   │       └── feast_powerup_freeze.png
│   └── ui/
│       ├── btn_primary.9.png
│       ├── btn_secondary.9.png
│       ├── icon_scale.png
│       ├── icon_star_filled.png
│       ├── icon_star_empty.png
│       ├── icon_streak_flame.png
│       ├── badge_frame.png
│       └── card_border.9.png
├── animations/
│   ├── dragon_idle.riv
│   ├── dragon_evolution.riv
│   ├── scales_earn.riv
│   └── achievement_unlock.riv
└── sounds/
    ├── music/
    │   ├── hub_theme.mp3
    │   ├── game_runes.mp3
    │   ├── game_fire_trail.mp3
    │   ├── game_eggs.mp3
    │   └── game_feast.mp3
    └── sfx/
        ├── correct.wav
        ├── wrong.wav
        ├── streak.wav
        ├── level_complete.wav
        ├── achievement.wav
        ├── scales_earn.wav
        ├── egg_crack.wav
        ├── egg_hatch.wav
        ├── dragon_roar.wav
        ├── munch.wav
        ├── button_tap.wav
        └── evolution.wav
```

### Color Constants Naming

In code, color constants follow this pattern:
```dart
// Primary palette
static const dragonPurple = Color(0xFF2D1B69);
static const dragonGold = Color(0xFFF4A261);

// Game accents
static const runesAccent = Color(0xFF9B59B6);
static const fireTrailAccent = Color(0xFFE74C3C);
static const dragonEggsAccent = Color(0xFF3498DB);
static const dragonsFeastAccent = Color(0xFF27AE60);
```

---

## 15. Dark Mode (Future)

The app is already "dark mode" by default (dark fantasy backgrounds). If a
light mode is ever added:

- Swap background to warm parchment (`#FDF6E3`)
- Swap text to dark brown (`#3C2415`)
- Keep gold, emerald, and fire orange accents
- Lighten purple to work on light backgrounds
- Game canvases remain dark (games always have dark environments)

This is **not** planned for v1 or v2. Noted here for future reference only.

---

## Implementation Notes

### Flutter Theme Data Mapping

The design tokens in this guide map to Flutter's `ThemeData` as follows:

| Design Token | Flutter Property |
|-------------|-----------------|
| Primary | `colorScheme.primary` |
| Secondary | `colorScheme.secondary` |
| Background | `colorScheme.surface` (Material 3) |
| Surface | `colorScheme.surfaceContainer` |
| Text Primary | `colorScheme.onSurface` |
| Text Secondary | `colorScheme.onSurfaceVariant` |
| Error | `colorScheme.error` |
| Display fonts | `textTheme.displayLarge`, etc. |
| Body fonts | `textTheme.bodyLarge`, etc. |

### Font Loading

All three font families (Cinzel, Nunito, JetBrains Mono) should be bundled in
the app assets, not loaded from Google Fonts at runtime. This ensures:
- Fonts are available offline
- No flash of unstyled text
- Consistent experience on first launch

Add to `pubspec.yaml`:
```yaml
fonts:
  - family: Cinzel
    fonts:
      - asset: assets/fonts/Cinzel-Regular.ttf
      - asset: assets/fonts/Cinzel-Bold.ttf
        weight: 700
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Regular.ttf
      - asset: assets/fonts/Nunito-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Nunito-Bold.ttf
        weight: 700
  - family: JetBrainsMono
    fonts:
      - asset: assets/fonts/JetBrainsMono-Regular.ttf
      - asset: assets/fonts/JetBrainsMono-Bold.ttf
        weight: 700
```

---

*Document created: 2026-02-14*
*Status: Complete for v1 development*
