# Math Dragons: Animation Framework Research & Technical Reference

> Comprehensive analysis of animation approaches for a Flutter + Flame engine
> mobile game targeting budget Android devices. Covers framework selection,
> per-animation recommendations, particle system design, sprite sheet workflow,
> and performance budgets.
>
> Research date: February 2026

---

## Table of Contents

1. [Animation Framework Options](#1-animation-framework-options-for-flutter-games)
2. [Recommended Approach per Animation Type](#2-recommended-approach-for-each-animation-type)
3. [Particle System Design](#3-particle-system-design)
4. [Sprite Sheet Workflow](#4-sprite-sheet-workflow)
5. [Performance Budgets](#5-performance-budgets)

---

## 1. Animation Framework Options for Flutter Games

### 1.1 Rive (formerly Flare)

**Overview:** Rive is a real-time interactive design and animation tool that exports
a compact binary `.riv` format. Its standout feature is the **State Machine** system,
which allows complex interactive animations that respond to runtime inputs (booleans,
numbers, triggers) without any code-side animation logic. Rive replaced Flare in 2020
and has become the leading choice for interactive animations in Flutter.

**Pricing (as of Feb 2026):**

| Plan | Cost | Key Features |
|------|------|-------------|
| Free | $0 | Unlimited personal files, 3 collaborative files, 1 project. Community forum support. |
| Cadet | $9/month | Unlimited exports, tags, folders, early access features. Aimed at individual shippers. |
| Voyager | ~$14-25/seat/month | Up to 25 seats, Libraries, CDN hosting, collaboration at scale, extended support. |
| Enterprise | Custom | Dedicated Slack, onboarding, training, SSO, best-practice reviews. |

For Math Dragons (a solo/small-team indie project), the **Free tier** is sufficient
for creating and testing animations. The **Cadet plan at $9/month** would be needed
once you ship to production, as the free tier has export limitations in collaborative
contexts.

**Flutter Integration:**
- `rive` package on pub.dev (currently `^0.12.x` or later)
- `flame_rive` bridge package provides `RiveComponent` for embedding Rive animations
  directly inside Flame game components
- `StateMachineController` allows code to find and modify inputs at runtime
- Already planned in Math Dragons pubspec (commented out: `# rive: ^0.12.4`)

**Strengths:**
- **File size:** `.riv` binary files are 10-15x smaller than equivalent Lottie JSON.
  A 240KB Lottie animation recreates at ~16KB in Rive. A 181KB Lottie becomes ~18KB.
- **Performance:** Renders at ~60 FPS on both JS and UI threads, compared to Lottie's
  ~17 FPS. Paused Rive graphics consume negligible resources.
- **State Machines:** The killer feature. Define idle/react/evolve states with
  transitions in the editor, then drive them from code with simple input changes.
  Perfect for dragon companion behavior.
- **Interactive:** Responds to user input (tap, hover, scroll) natively.
- **All-in-one editor:** No dependency on After Effects or external tools.

**Weaknesses:**
- Learning curve is moderate (new editor to learn, state machine concepts).
- The Rive GameKit (for full scene rendering) currently only supports iOS/macOS in
  technical preview. Android support is in development. This means we use Rive for
  individual animation components, not as a full game renderer.
- Requires an artist/designer comfortable with Rive's vector-based workflow.
- Image/audio/font assets embedded in `.riv` files can bloat size if not optimized.

**Quality Output:** Professional, vector-based, resolution-independent. Scales perfectly
across all device sizes without quality loss.

**Learning Curve:** Medium. The Rive editor has good documentation and tutorials.
State machines add complexity but are well worth it.

**File Size Impact:** Minimal. Typical character animations: 5-50KB per `.riv` file.
Total animation asset budget likely under 500KB for all Math Dragons animations.

**Performance on Budget Android:** Excellent. Rive's C++-based renderer is highly
optimized. The key concern is memory for assets embedded within `.riv` files --
keep images optimized and dynamically load/unload animations.

---

### 1.2 Lottie (via lottie_flutter)

**Overview:** Lottie renders After Effects animations exported as JSON via the
Bodymovin plugin. It was the standard for lightweight UI animations for years.
The `lottie` package on pub.dev handles rendering in Flutter.

**Pricing:** Free and open source. After Effects requires an Adobe Creative Cloud
subscription (~$23/month for the single app, ~$60/month for the full suite).
Free alternative: Haiku Animator or LottieFiles editor for simple animations.

**Flutter Integration:**
- `lottie` package on pub.dev
- No official Flame bridge package -- Lottie animations are Flutter widgets, not
  Flame components. Embedding Lottie inside a Flame game requires widget overlays
  or a Flutter-layer approach, adding complexity.

**Strengths:**
- Massive library of pre-made animations on LottieFiles.com (many free).
- Well-established After Effects workflow familiar to motion designers.
- Good for UI-layer animations (loading spinners, success checkmarks, etc.).
- dotLottie format reduces file sizes via compression.

**Weaknesses:**
- **Performance on Android is poor.** Multiple reports of laggy playback on
  entry-level Android devices (e.g., Samsung M14). Full-screen animations drop
  frames significantly. Lottie plays at ~17 FPS vs Rive's ~60 FPS.
- **No interactivity.** Lottie is timeline-only: play, pause, seek. No state
  machines, no runtime input responses. For a game needing reactive dragon
  animations, this is a significant limitation.
- **File size:** JSON format is verbose. Animations with image assets get large.
  A typical character animation can be 100-400KB in Lottie vs 10-40KB in Rive.
- **No Flame integration.** Must be rendered as a Flutter widget overlay, breaking
  the Flame rendering pipeline.
- **Requires After Effects** for creating new animations (expensive).

**Quality Output:** High for pre-rendered, non-interactive animations. Limited to
what After Effects can produce.

**Learning Curve:** Low if you already know After Effects. Low for consuming
pre-made animations.

**File Size Impact:** Moderate to high. JSON-based format inflates file sizes.

**Performance on Budget Android:** **Poor.** This is the primary disqualifier for
Math Dragons. Budget Android devices ($150 range) will struggle with multiple
concurrent Lottie animations.

---

### 1.3 Spine 2D

**Overview:** Spine is the industry-standard skeletal animation tool for 2D games.
It uses a bone-based system where characters are rigged with a skeleton, and
animations move the bones. This produces smooth, memory-efficient animations
from minimal texture data.

**Pricing (one-time purchase):**

| Edition | Cost | Key Features |
|---------|------|-------------|
| Essential | $69 | All basic features, all export formats. No meshes, no advanced features. |
| Professional | $369 | Meshes, weights, deform, IK constraints, path constraints, clipping. |

For Math Dragons' relatively simple dragon character, **Essential ($69)** may
suffice. Mesh deformation (Professional) would be needed for fluid wing/body
animation, which would significantly improve the dragon companion quality.

**Flutter/Flame Integration:**
- `spine_flutter` package on pub.dev
- `flame_spine` bridge package provides `SpineComponent` for direct Flame integration
- Supports loading `.atlas` + `.skel`/`.json` files
- All Spine features supported except tint black and screen blend mode
- Version of spine_flutter must match Spine Editor major.minor version

**Strengths:**
- Industry-standard skeletal animation for 2D games.
- Extremely memory efficient: one texture atlas serves hundreds of animation frames.
- Smooth interpolation between keyframes (not frame-by-frame).
- Great for character animations with many states (idle, walk, attack, react).
- Mesh deformation (Pro) enables organic, fluid motion.
- One-time purchase, not subscription.
- Native Flame integration via `flame_spine`.

**Weaknesses:**
- Higher upfront cost ($69-$369) and steeper learning curve than Rive.
- Requires artistic skill to rig characters with skeletons.
- Less suited for UI animations, particle effects, or motion graphics.
- The editor is desktop-only (no web editor like Rive).
- Community/ecosystem is smaller in the Flutter space than in Unity/Unreal.

**Quality Output:** Professional game-quality character animation. Used in countless
commercial games.

**Learning Curve:** High. Skeletal rigging, mesh weighting, and IK constraints
require significant learning investment.

**File Size Impact:** Very low. A complete dragon character with 10+ animations
might be 200-500KB total (texture atlas + skeleton data).

**Performance on Budget Android:** Excellent. Spine's C-based runtime is
battle-tested across mobile platforms. Skeletal animation is inherently
lightweight compared to sprite sheet frame-by-frame.

---

### 1.4 Flame's Built-in SpriteAnimation

**Overview:** Flame provides `SpriteAnimation` for flip-book style frame-by-frame
animation from sprite sheets. Sprites are loaded from a single image containing
all frames in a grid layout.

**Pricing:** Free (part of Flame engine, already a dependency).

**Flutter/Flame Integration:** Native. `SpriteAnimationComponent` is a first-class
Flame component.

**Strengths:**
- Zero additional dependencies.
- Simple and predictable: each frame is exactly what you drew.
- Perfect for pixel art or hand-drawn animation styles.
- `flame_texturepacker` plugin supports TexturePacker atlas format.
- Well-documented, many tutorials available.
- Frame-perfect control.

**Weaknesses:**
- Memory intensive: every frame is a full image. A 10-frame animation at 128x128
  is 10x the memory of a single frame.
- No interpolation: smoothness requires more frames (higher memory cost).
- No interactivity or state machines -- just plays frames in sequence.
- Creating high-quality sprite sheets requires an artist with animation skill.
- Scaling changes quality (raster, not vector).

**Quality Output:** Depends entirely on the source art. Can range from charming
pixel art to professional hand-drawn animation.

**Learning Curve:** Very low. Load sprite sheet, set frame count, play.

**File Size Impact:** Medium to high depending on frame count and resolution.
A 12-frame 128x128 sprite sheet is ~100-300KB as PNG. Multiple animations
for one character could reach 1-2MB.

**Performance on Budget Android:** Good for moderate use. GPU texture memory
is the constraint. Keep sprite sheets under 2048x2048 pixels.

---

### 1.5 Flutter's Built-in Animation Framework

**Overview:** Flutter's animation system (`AnimationController`, `Tween`,
`AnimatedBuilder`, `Hero`, implicit animations) handles UI-layer animations.
These run on the Flutter widget tree, not inside Flame's game loop.

**Pricing:** Free (part of Flutter SDK).

**Strengths:**
- No additional dependencies.
- Deeply integrated with Flutter's widget system.
- `Curves` library provides easing (the Visual Design Guide already defines
  timing curves using `Curves.easeOut`, `Curves.easeOutBack`, etc.).
- Perfect for screen transitions, dialog animations, UI element animations.
- `AnimatedContainer`, `AnimatedOpacity`, `SlideTransition`, `ScaleTransition`
  handle common patterns with minimal code.
- Can be combined with `CustomPainter` for complex effects.

**Weaknesses:**
- Cannot be used inside Flame game components directly.
- Not suited for in-game particle effects or character animation.
- Complex multi-step animations require careful choreography with multiple
  controllers and listeners.

**Quality Output:** Clean, consistent with Flutter's design system.

**Learning Curve:** Low to medium. Well-documented in Flutter's official guides.

**File Size Impact:** Zero. No additional assets needed.

**Performance on Budget Android:** Excellent for UI animations. Key optimization:
use `const` constructors, narrow rebuild scope, avoid `Opacity` widget (use
`AnimatedOpacity` instead), and use `AnimatedBuilder` child parameter to avoid
rebuilding static subtrees.

---

### 1.6 Custom Canvas Painting (Flame + Flutter)

**Overview:** Direct `Canvas` drawing using Flame's `render()` method or Flutter's
`CustomPainter`. This is what Math Dragons already uses for particle effects
(see `GemSparkleEffect`, `SpellParticleEffect`, `MunchEffect`).

**Pricing:** Free.

**Strengths:**
- Maximum control over every pixel.
- Zero asset dependencies (procedurally generated).
- Perfect for particle systems, procedural effects, and simple geometric animations.
- Can be highly optimized with batched draw calls and object pooling.
- Already proven in the Math Dragons codebase.

**Weaknesses:**
- Requires programming-driven animation (no visual editor).
- Complex characters are impractical to draw procedurally.
- Each effect must be coded from scratch.
- Harder to iterate on visual design without a visual tool.

**Quality Output:** Great for effects and particles. Not practical for character
animation.

**Learning Curve:** Medium for basic effects. High for complex particle systems.

**File Size Impact:** Zero. All procedural.

**Performance on Budget Android:** Excellent when well-optimized. Key techniques:
- Reuse `Paint` objects (avoid instantiation per frame).
- Use `drawRawAtlas`/`drawRawPoints` for batched rendering.
- Object pool particles instead of creating/destroying.
- Keep particle counts within budget (see Section 5).
- Impeller engine (default on Android since Flutter 3.27) significantly improves
  Canvas rendering performance, with 50% faster rasterization and consistent 60 FPS.

---

### 1.7 Comparison Summary

| Factor | Rive | Lottie | Spine 2D | Flame Sprite | Flutter Anim | Custom Canvas |
|--------|------|--------|----------|-------------|-------------|---------------|
| **Cost** | Free/$9mo | Free+AE$ | $69-369 | Free | Free | Free |
| **File Size** | Tiny (5-50KB) | Large (100-400KB) | Small (200-500KB) | Medium (100KB-2MB) | Zero | Zero |
| **FPS on Android** | ~60 | ~17 | ~60 | ~60 | ~60 | ~60 |
| **Interactivity** | State Machines | None | Skeleton blend | None | Callbacks | Programmatic |
| **Flame Integration** | flame_rive | None | flame_spine | Native | Overlay only | Native |
| **Learning Curve** | Medium | Low | High | Very Low | Low | Medium |
| **Best For** | Interactive chars | UI polish | Character anim | Pixel art | Screen transitions | Particles/FX |
| **Worst For** | Particles/FX | Games/Android | UI animations | Complex chars | In-game | Characters |

---

### 1.8 Recommended Stack for Math Dragons

Use a **layered approach** combining multiple frameworks for their strengths:

| Layer | Framework | What It Handles |
|-------|-----------|----------------|
| **Characters** | **Rive** | Dragon companion (idle, react, evolve), hub dragon display |
| **In-Game FX** | **Custom Canvas (Flame)** | All particle effects, sparkles, bursts, trails |
| **UI Transitions** | **Flutter Animations** | Screen transitions, dialog animations, achievement popups |
| **UI Polish** | **Flutter Animations** | Score float, streak pulse, shimmer effects, countdown |
| **Ambient BG** | **Custom Canvas (Flame)** | Floating embers, background glow, star twinkle |

**Why not Spine:** The dragon character design is relatively simple (one dragon with
a few states), not a complex multi-limbed character needing IK chains. Rive's state
machine approach is more cost-effective and the file sizes are smaller. Spine would
be overkill unless the dragon animations become very complex in future versions.

**Why not Lottie:** The 17 FPS performance on Android is disqualifying for a game
targeting budget devices. Lottie's lack of Flame integration also makes it impractical
for in-game use.

---

## 2. Recommended Approach for Each Animation Type

### 2.1 Character Animations

#### Dragon Companion Idle (Hub) -- Gentle breathing, wing stretch (4-6s cycle)

| Attribute | Value |
|-----------|-------|
| **Framework** | Rive |
| **Approach** | Create a `.riv` file with a "Breathing" state and "WingStretch" state in the state machine. Breathing loops continuously (4s). Wing stretch triggers randomly every 15-30s via a Dart timer firing a Rive trigger input. |
| **Flame Integration** | Use `flame_rive`'s `RiveComponent` if rendering inside a Flame game widget, or use the `rive` package's `RiveAnimation` widget directly in the Flutter hub screen. |
| **Complexity** | Medium. Requires creating the dragon art in Rive and rigging the state machine. |
| **Asset Requirements** | One `.riv` file (~20-40KB) containing the dragon artboard with all hub states. |
| **Estimated Dev Time** | 4-6 hours for Rive asset creation + 2-3 hours for integration code. |

#### Dragon Reaction -- Looks toward tapped game

| Attribute | Value |
|-----------|-------|
| **Framework** | Rive |
| **Approach** | Add a Number input "LookDirection" (-1 = left, 0 = center, 1 = right) to the dragon's state machine. When a game card is tapped, set the input value based on the card's position relative to the dragon. The state machine transitions to a "Looking" state with head/eye bone rotation. |
| **Complexity** | Low (if built into the same `.riv` file as idle). |
| **Asset Requirements** | Same `.riv` file as idle. |
| **Estimated Dev Time** | 1-2 hours additional Rive work + 1 hour integration. |

#### Dragon Evolution Transition -- Bright flash, morph, new form reveal (2.5s)

| Attribute | Value |
|-----------|-------|
| **Framework** | Rive + Flutter Animations (layered) |
| **Approach** | The Rive state machine has a "PreEvolution" (current form vibrates) → "Flash" (white overlay opacity keyframes) → "PostEvolution" (new form fades in) sequence triggered by a boolean input. The bright flash overlay is a Flutter `AnimatedOpacity` widget layered on top for precise timing with haptic feedback. |
| **Complexity** | High. The most complex animation in the app. |
| **Asset Requirements** | One `.riv` file per dragon evolution stage, OR one `.riv` file with multiple artboards (one per stage). Recommend the latter for efficient loading. ~50-80KB. |
| **Estimated Dev Time** | 6-8 hours Rive work + 3-4 hours integration and choreography. |

---

### 2.2 In-Game Animations

#### Correct Answer -- Pulse green, +score float, particles (600ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas (particles) + Flutter Animations (score float) |
| **Approach** | Three simultaneous effects: (1) Green glow pulse on the answer element via a `ScaleEffect` or manual opacity cycle in Flame. (2) "+3" text floats upward using a `MoveEffect` + `OpacityEffect` on a Flame `TextComponent`. (3) Green particle burst (see Section 3.2). |
| **Complexity** | Low. Already partially implemented in the codebase (GemSparkleEffect pattern). |
| **Asset Requirements** | None. All procedural. |
| **Estimated Dev Time** | 2-3 hours per game to polish existing implementations. |

#### Wrong Answer -- Shake 3px 3 cycles, flash red (400ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flame `MoveEffect` / custom shake |
| **Approach** | Apply a shake effect: oscillate x-position by +/- 3 logical pixels, 3 full cycles over 400ms using a sinusoidal curve. Simultaneously flash the element red using `ColorEffect` or a manual tint overlay. Already implemented in existing games. |
| **Complexity** | Very low. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | 1 hour per game to standardize. |

#### Streak Increment -- Flame pulse, number bounce (300ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter Animations (if HUD is Flutter) or Flame effects (if HUD is Flame) |
| **Approach** | Scale the streak counter from 1.0 to 1.15 and back with `Curves.easeOutBack` over 300ms. Simultaneously pulse the flame icon opacity from 1.0 to 0.7 and back. Use an `AnimationController` with a forward/reverse cycle. |
| **Complexity** | Very low. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | 1 hour. |

#### Level Complete -- Stars fill sequence, score tally (1200ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter Animations |
| **Approach** | Choreograph with staggered `AnimationController`s: (1) Star 1 scales from 0 to 1 with `Curves.elasticOut` at 0ms. (2) Star 2 at 200ms. (3) Star 3 at 400ms. (4) Score number counts up from 0 to final value over 600ms starting at 400ms using `Tween<int>`. (5) Gold particles fly to counter (see Section 3.1) starting at 800ms. |
| **Complexity** | Medium. Multiple synchronized animations. |
| **Asset Requirements** | Star icon (Material Icons or custom SVG). |
| **Estimated Dev Time** | 3-4 hours. |

#### Scales Earned -- Gold particles fly to counter (800ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas (Flame or Flutter `CustomPainter`) |
| **Approach** | Spawn 8-12 gold circle particles at the source position. Each particle follows a bezier curve path toward the scales counter position (top-right of screen). Stagger spawn times by 30-50ms each. Each particle shrinks as it approaches the target. On arrival, bump the counter with a scale bounce. See Section 3.1 for full spec. |
| **Complexity** | Medium. Path-following particles require bezier math. |
| **Asset Requirements** | None (circles), or a tiny gold scale sprite (16x16). |
| **Estimated Dev Time** | 3-4 hours. |

#### Achievement Unlock -- Badge slides down, holds 2s, slides up (3000ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter Animations |
| **Approach** | Already implemented as `AchievementPopupOverlay` in Step 9 using `AnimationController` with `Curves.easeOutBack` for the slide-down (500ms), a 2s hold, and a reverse slide-up. This is a Flutter widget overlay, not a Flame component. |
| **Complexity** | Already implemented. |
| **Asset Requirements** | Badge icon per achievement. |
| **Estimated Dev Time** | Done (polish only: 1 hour). |

#### Egg Hatch -- Crack lines, shell break, baby dragon flies (1000ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flame SpriteAnimation + Custom Canvas particles |
| **Approach** | Three phases: (1) Crack lines appear as overlaid sprites (crack_1.png, crack_2.png) at 0ms and 300ms. (2) Shell breaks: sprite disappears, replaced by 8-12 shell fragment particles (white/cream colored) flying outward with gravity at 500ms. (3) Baby dragon sprite scales up from 0 with `Curves.elasticOut` at 600ms, then floats upward and fades at 800ms. |
| **Complexity** | Medium-high. Multiple coordinated phases. |
| **Asset Requirements** | `egg_crack_1.png`, `egg_crack_2.png`, `baby_dragon_fly.png` (already in asset naming convention). |
| **Estimated Dev Time** | 4-5 hours. |

#### Snake Eat -- Chomp, gem dissolves to sparkles (300ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas particles (existing `GemSparkleEffect`) |
| **Approach** | Already implemented. On correct gem collision: gem shrinks to 0 over 150ms while spawning 20 gold sparkle particles that radiate outward. The existing `GemSparkleEffect` in `gem_sparkle_effect.dart` handles this. |
| **Complexity** | Already implemented. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | Done. |

#### Rune Connect -- Line draws between nodes, glow (200ms/node)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas (Flame render) |
| **Approach** | Already implemented in Dragon Runes. When dragging between nodes, a line is drawn on the Canvas from the previous node to the current touch position. On valid connection: line color transitions from purple to gold-purple gradient. Node glow intensifies via a radial gradient with increasing radius over 200ms. Existing `SpellParticleEffect` fires on completion. |
| **Complexity** | Already implemented. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | Done (polish: 1-2 hours for glow intensity animation). |

#### Feast Munch -- Bite, gem shatters to particles (250ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas particles (existing `MunchEffect`) |
| **Approach** | Already implemented. Dragon position moves to tile, tile disappears, 15 particles burst outward (green for correct, red for wrong). Particles have slight gravity and fade over 300-600ms. |
| **Complexity** | Already implemented. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | Done. |

---

### 2.3 Screen Transitions

#### Hub to Game: Fade + scale up (400ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `PageRouteBuilder` |
| **Approach** | Custom `PageRouteBuilder` with `FadeTransition` + `ScaleTransition` (scale from 0.85 to 1.0). Use `Curves.easeInOutCubic` over 400ms. The "portal opening" effect. |
| **Complexity** | Low. Standard Flutter route transition. |
| **Estimated Dev Time** | 1-2 hours for all four transition types. |

```dart
// Example implementation pattern
PageRouteBuilder(
  transitionDuration: const Duration(milliseconds: 400),
  pageBuilder: (_, __, ___) => const GameScreen(),
  transitionsBuilder: (_, animation, __, child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0)
            .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
        child: child,
      ),
    );
  },
)
```

#### Game to Hub: Fade + scale down (300ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `PageRouteBuilder` |
| **Approach** | Reverse of Hub-to-Game. Scale from 1.0 to 0.85 with fade-out. Use `reverseTransitionDuration: 300ms`. |
| **Complexity** | Low. |

#### Game to Result: Slide up (350ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `SlideTransition` |
| **Approach** | Results panel slides up from `Offset(0, 1)` to `Offset(0, 0)` with `Curves.easeOutCubic` over 350ms. Can use a `showModalBottomSheet` with custom animation or a `PageRouteBuilder`. |
| **Complexity** | Very low. |

#### Any to Dialog: Fade + scale from 0.9 (250ms)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `showGeneralDialog` |
| **Approach** | Custom `showGeneralDialog` with `FadeTransition` + `ScaleTransition` (0.9 to 1.0). `Curves.easeOutBack` gives the slight overshoot feel. Background barrier fades in simultaneously. |
| **Complexity** | Very low. |

---

### 2.4 Ambient Animations

#### Hub Floating Embers -- Slow particle drift (continuous)

| Attribute | Value |
|-----------|-------|
| **Framework** | Custom Canvas (Flutter `CustomPainter` or Flame if hub uses Flame) |
| **Approach** | Pool of 15-25 ember particles. Each particle drifts upward (vy: -10 to -30 px/s) with slight horizontal sine wave oscillation (amplitude: 5-15px, period: 3-6s). Particles are tiny (2-4dp radius), warm orange/gold with random alpha (0.2-0.6). When a particle exits the top of screen, reset it to a random position at the bottom. |
| **Complexity** | Low. Simple particle pool with sine-wave motion. |
| **Asset Requirements** | None (circles), or a tiny 8x8 ember sprite for added quality. |
| **Performance Notes** | 15-25 particles with simple circle draws is negligible load. Use a single `CustomPainter` with `AnimationController` ticker, not individual widgets. |
| **Estimated Dev Time** | 2-3 hours. |

#### Background Glow -- Subtle pulse (8s cycle)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `AnimatedBuilder` + `CustomPainter` |
| **Approach** | A large radial gradient centered behind the dragon area. The gradient's outer radius oscillates between 60% and 75% of screen width over an 8-second sine cycle. The gradient uses Dragon Purple (#2D1B69) at center to transparent at edges, with opacity pulsing between 0.1 and 0.25. |
| **Complexity** | Very low. Single animated gradient. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | 1 hour. |

#### Currency Shimmer -- Gold counter sparkle (3s cycle)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `ShaderMask` + `AnimationController` |
| **Approach** | Apply a diagonal linear gradient sweep across the scales counter text/icon. The gradient has a narrow band of brighter gold that slides from left to right over 3 seconds, then resets. This is the classic "shimmer" effect. Use `ShaderMask` with a `LinearGradient` whose `begin`/`end` points are animated. |
| **Complexity** | Low. Well-documented shimmer pattern. |
| **Asset Requirements** | None. |
| **Estimated Dev Time** | 1-2 hours. |

#### Star Twinkle -- Random sparkle (5-10s interval)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `AnimationController` |
| **Approach** | For each earned star on game cards, run a delayed loop: wait random 5-10s, then scale the star from 1.0 to 1.2 and back over 300ms with a brief white opacity flash. Stagger the timers so stars don't all twinkle simultaneously. Use `Future.delayed` to schedule twinkling. |
| **Complexity** | Very low. |
| **Asset Requirements** | None (uses existing star widgets). |
| **Estimated Dev Time** | 1 hour. |

---

### 2.5 Loading/Transition States

#### Splash Screen Animation

| Attribute | Value |
|-----------|-------|
| **Framework** | Rive (preferred) OR Flutter Animations (simpler) |
| **Approach Option A (Rive):** | A single `.riv` file with the Math Dragons logo. Dragon letters glow, a small dragon silhouette flies across, flames trace the text. 2-3 second total animation. The Rive state machine auto-plays the "Intro" animation, then triggers a completion callback to navigate to the hub. ~15-30KB file. |
| **Approach Option B (Flutter):** | Simpler: "Math Dragons" text fades in with `Curves.easeOut` over 800ms, a gold underline draws from left to right over 600ms (using `CustomPainter` with `animation.value` controlling the line width), then the whole screen fades out. |
| **Complexity** | Option A: Medium. Option B: Low. |
| **Estimated Dev Time** | Option A: 3-4 hours. Option B: 1-2 hours. |

#### Game Loading Spinner

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter `AnimationController` |
| **Approach** | A custom dragon-egg-shaped spinner. An ellipse rotates 360 degrees over 1.2s with `Curves.linear`. Add a subtle fire trail behind the rotating egg using 3-4 fading copies at previous rotation angles. Alternatively, use a simple `CircularProgressIndicator` themed with Dragon Gold. |
| **Complexity** | Very low. |
| **Estimated Dev Time** | 30 minutes to 1 hour. |

#### Countdown Overlay (3-2-1-GO)

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter Animations |
| **Approach** | Already implemented in Fire Trail. Each number scales from 2.0 to 1.0 with `Curves.easeOutBack` over 700ms, holds briefly, then fades. "GO!" uses a different color (gold) and larger scale. The overlay is a Flutter widget layered on top of the Flame game, using `AnimatedBuilder` with an `AnimationController`. |
| **Complexity** | Already implemented. |
| **Estimated Dev Time** | Done (standardize across games: 1 hour). |

---

## 3. Particle System Design

### 3.0 Architecture Overview

Math Dragons already uses a consistent custom particle architecture across three games.
The pattern is:

1. A `PositionComponent` subclass that owns a list of lightweight particle data objects
2. Particles spawned in `onLoad()` with random velocities, lifetimes, and colors
3. `update(dt)` applies velocity, gravity, and aging
4. `render(canvas)` draws circles with fading alpha
5. Self-removal when all particles are dead

This pattern should be formalized into a **reusable base class** to avoid duplication
and enable consistent optimization.

### 3.0.1 Proposed Base Particle Effect

```dart
/// Base particle data class (keep lightweight, no inheritance overhead).
class ParticleData {
  double x, y;          // position relative to effect origin
  double vx, vy;        // velocity
  final double life;    // total lifetime in seconds
  double age = 0;       // current age in seconds
  final Color color;
  final double startSize;

  ParticleData({
    this.x = 0, this.y = 0,
    required this.vx, required this.vy,
    required this.life,
    required this.color,
    this.startSize = 3.0,
  });

  double get progress => (age / life).clamp(0.0, 1.0);
  bool get isDead => age >= life;
}

/// Base effect that manages particle lifecycle.
abstract class BaseParticleEffect extends PositionComponent {
  final List<ParticleData> particles = [];
  final Paint _paint = Paint();  // reuse single Paint object

  double gravity = 40.0;  // px/s^2 downward
  double sizeDecay = 0.5; // how much size shrinks over lifetime (0-1)

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += gravity * dt;
      p.age += dt;
    }
    particles.removeWhere((p) => p.isDead);
    if (particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in particles) {
      final alpha = (1.0 - p.progress).clamp(0.0, 1.0);
      final size = p.startSize * (1.0 - p.progress * sizeDecay);
      _paint.color = p.color.withAlpha((alpha * 255).round());
      canvas.drawCircle(Offset(p.x, p.y), size, _paint);
    }
  }
}
```

---

### 3.1 Gold Sparkle (Scales Earned)

**Trigger:** Player earns scales (correct answer, level complete, daily challenge).

**Visual Description:** Golden particles burst from the source, then arc upward
toward the scales counter in the HUD. Creates a sense of "collecting" currency.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 8-12 | Modest count, path-following is more expensive |
| Colors | `#F4A261` (Dragon Gold), `#F7C08A` (Warm Glow), `#D4843A` (Aged Gold) | Random selection per particle |
| Start size | 3-5dp | Slightly larger than standard particles |
| End size | 1-2dp | Shrink as they approach target |
| Lifetime | 800ms | Matches Visual Design Guide spec |
| Spawn position | Center of earning event (correct answer tile, level complete dialog) |
| Target position | Scales counter (top-right HUD area) |
| Path | Quadratic bezier curve with random control point offset | Creates natural arc |
| Trail | Each particle leaves 2-3 fading "ghost" copies behind | Creates comet-tail look |
| Spawn stagger | 30-50ms between each particle | Cascading effect |
| Gravity | 0 (path-following, not physics-based) | |

**Implementation Approach:** Path-following particles (not physics). Each particle
follows a bezier curve from spawn to target:

```
Control point = midpoint + random offset (-40..40, -80..-40)
Progress along bezier = easeInCubic(age / lifetime)
```

---

### 3.2 Green Burst (Correct Answer)

**Trigger:** Player answers correctly in any game.

**Visual Description:** A radial burst of emerald-green particles from the
answer element. Quick, satisfying, not overwhelming.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 15-20 | Matches existing `GemSparkleEffect` (20) |
| Colors | `#2A9D8F` (Emerald Flame), `#3CC4B1` (lighter variant) | 70/30 split |
| Start size | 2.5-3.5dp | |
| End size | 0.5dp | Rapid shrink for sparkle feel |
| Lifetime | 400-700ms | Random per particle |
| Speed | 80-240 px/s | Radial outward |
| Gravity | 50 px/s^2 downward | Slight droop for natural feel |
| Angle | Random 0-360 degrees | Full radial burst |
| Size decay | 0.5 | Half size at end of life |

**Implementation:** Already implemented in the codebase as `GemSparkleEffect`.
Standardize across all games using the base class. Consider adding a brief
green glow circle (radius 20dp, 200ms fade) behind the particles for extra punch.

---

### 3.3 Red Burst (Wrong Answer)

**Trigger:** Player answers incorrectly.

**Visual Description:** Smaller, sharper red burst. Should feel "wrong" and brief,
not celebratory.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 8-12 | Fewer than correct (less celebratory) |
| Colors | `#E76F51` (Fire Orange), `#C0392B` (darker red) | 60/40 split |
| Start size | 2.0-3.0dp | |
| End size | 0.5dp | |
| Lifetime | 250-450ms | Shorter than correct |
| Speed | 60-150 px/s | Slower, less energetic |
| Gravity | 80 px/s^2 | Heavier gravity, particles "fall" quickly |
| Angle | Random 0-360 degrees | |
| Size decay | 0.7 | Shrinks faster |

**Implementation:** Variant of the green burst with different color, count, and
physics. Already partially implemented in `MunchEffect` (isCorrect: false path).

---

### 3.4 Purple/Gold Spell Effect (Dragon Runes Completion)

**Trigger:** Player completes a valid equation in Dragon Runes.

**Visual Description:** Magical purple and gold particles burst from each node in
the completed equation chain. Creates a "spell casting" feeling.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 8 per node | Already implemented in `SpellParticleEffect` |
| Colors | `#BB8FCE` (Rune glow purple, 60%), `#F4A261` (Dragon Gold, 40%) | |
| Start size | 3.0dp | |
| End size | 1.5dp | |
| Lifetime | 500-900ms | Longer than standard for magical feel |
| Speed | 60-240 px/s | Mix of slow drifting and fast shooting |
| Gravity | 40 px/s^2 | Light gravity |
| Spawn positions | Each node position in the completed chain | Multi-source |
| Special | Add 3-5 "sparkle" particles per node that don't move but flash in/out | Stationary twinkle |

**Implementation:** Already implemented in `SpellParticleEffect`. Enhancement
opportunity: add stationary sparkle particles at node positions that flash
opacity 0-1-0 over 300ms for added magic feel.

---

### 3.5 Fire Trail Particles

**Trigger:** Continuous emission from the dragon's trail in Fire Trail game.

**Visual Description:** The fire trail behind the dragon should feel alive with
small ember particles drifting off the trail segments.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 2-4 per trail segment per second | Continuous emission, pooled |
| Max alive particles | 30-50 | Pool cap to prevent buildup |
| Colors | `#E74C3C` (30%), `#F4A261` (40%), `#FFF3B0` (30%) | Fire gradient |
| Start size | 2.0-3.0dp | |
| End size | 0.5dp | |
| Lifetime | 600-1000ms | |
| Speed | 10-40 px/s | Slow drift, mostly upward/sideways |
| Gravity | -20 px/s^2 | Negative! Embers rise. |
| Spawn offset | Random +-5px from trail segment center | |

**Implementation:** New continuous emitter system. Unlike burst effects, this
needs a particle pool with continuous spawning. Spawn rate should scale with
game speed (faster dragon = more particles) but cap at max alive count.

**Performance Note:** This is the highest-particle-count effect in the game.
Must pool particles (reuse dead particles instead of creating new ones) and
cap the alive count strictly. On budget devices, reduce to 1-2 per segment per
second and max 20-30 alive.

---

### 3.6 Ember Drift (Hub Ambient)

**Trigger:** Continuous, always present on hub screen.

**Visual Description:** Slow-moving, gently floating ember particles that drift
upward through the hub screen. Creates a warm, living atmosphere.

**Specification:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Particle count | 15-25 total | Fixed pool, no creation/destruction |
| Colors | `#F4A261` at alpha 0.15-0.4, `#E76F51` at alpha 0.1-0.3 | Very subtle |
| Size | 1.5-3.5dp | Random per particle |
| Speed Y | -10 to -30 px/s | Slow upward drift |
| Speed X | Sine wave, amplitude 5-15px, period 3-6s | Gentle horizontal wave |
| Lifetime | Infinite (recycle when off-screen) | |
| Gravity | 0 | |
| Opacity variation | Sine wave, period 4-8s, amplitude 0.1-0.2 | Breathing glow |

**Implementation:** Fixed particle pool, no spawning/despawning overhead.
When a particle exits the top of the visible area, reset its Y to below the
bottom of the screen with a new random X position and parameters. Use sine
functions for both horizontal movement and opacity breathing.

**Performance Note:** This effect runs continuously while the hub is visible.
It must be extremely lightweight. 15-25 `drawCircle` calls per frame is
negligible. Pause the animation when the hub is not visible (app backgrounded,
game screen active). Use `WidgetsBindingObserver` lifecycle hooks.

---

### 3.7 Pre-rendered vs Real-time Particles

| Approach | Pros | Cons | When to Use |
|----------|------|------|-------------|
| **Real-time (Canvas draw)** | Zero asset size, fully dynamic, can react to game state, unlimited variation | CPU cost per frame, requires programming | Default choice for Math Dragons. All current effects use this. |
| **Pre-rendered sprite sheets** | Consistent look, no CPU computation for complex effects, designer-controlled | Fixed size/color/direction, asset memory cost, cannot react to game state | Use ONLY if a specific effect is too complex for real-time (e.g., detailed fire/explosion with transparency). Not needed for Math Dragons' simple particle effects. |
| **Sprite-based particles** | Each particle is a tiny sprite instead of a circle. Looks more detailed. | Small texture memory cost per sprite. | Optional enhancement: replace circle particles with a 4x4 or 8x8 ember/sparkle sprite for more visual richness. Minimal memory impact. |

**Recommendation for Math Dragons:** Stay with real-time Canvas-drawn particles
for all effects. The existing circle-based approach is clean, fast, and consistent
with the game's abstract visual style. The only potential enhancement is adding
a tiny 8x8 sprite particle for the gold scales effect to make it look more
"coin-like" rather than circular.

---

## 4. Sprite Sheet Workflow

### 4.1 Best Tools for Creating Sprite Sheets

#### Aseprite -- Recommended for Pixel Art Style

| Attribute | Value |
|-----------|-------|
| **Cost** | $19.99 one-time (Steam or itch.io) |
| **Platforms** | Windows, macOS, Linux |
| **Strengths** | Purpose-built for pixel art and animation. Real-time preview, onion skinning, layers, tags for animation states. Native sprite sheet export to PNG + JSON. |
| **Export** | Direct sprite sheet export in horizontal strip, vertical strip, or grid formats. JSON data file compatible with Flame's expected format. |
| **Best For** | Creating the source animations frame by frame. |
| **Free Alternative** | LibreSprite (open-source fork), Pixelorama (Godot-based, free). |

#### TexturePacker -- Recommended for Atlas Optimization

| Attribute | Value |
|-----------|-------|
| **Cost** | $39.99 one-time (Essential), $59.99 (Pro) |
| **Platforms** | Windows, macOS, Linux |
| **Strengths** | Automatic sprite sheet packing, trimming transparent pixels, rotation optimization, PNG-8 conversion (75% size reduction). Auto-detects animation sequences from numbered files. Watches folders for changes and re-packs automatically. |
| **Flame Integration** | `flame_texturepacker` package reads TexturePacker's atlas format directly. |
| **Export Formats** | JSON (Array), JSON (Hash), XML, and many engine-specific formats. |
| **Best For** | Taking individual frames from Aseprite and packing them into optimized atlases. |
| **Free Alternative** | free-tex-packer.com (web-based), ShoeBox (Adobe AIR, free). |

#### Recommended Workflow

```
1. Create animation frames in Aseprite (pixel art) or Rive (vector)
   - Save as individual PNGs or Aseprite sprite sheet

2. Import into TexturePacker
   - Pack multiple animations into one atlas
   - Enable "Trim" to remove transparent borders
   - Enable "Max size 2048x2048" for mobile compatibility
   - Export as PNG-8 if alpha precision isn't critical
   - Export JSON data file in "JSON (Array)" format

3. Load in Flame using flame_texturepacker
   - TexturePackerAtlas.load('atlas.json')
   - Create SpriteAnimation from atlas frames
```

### 4.2 Recommended Frame Rates

| Animation Type | Frame Rate | Rationale |
|----------------|-----------|-----------|
| **Idle breathing** | 12 fps | Slow, subtle movement. Traditional animation standard for slow actions. |
| **Walking/moving** | 12-15 fps | Smooth enough for locomotion. Disney standard for walk cycles. |
| **Fast action (attack, eat)** | 15-20 fps | Snappier feel for quick actions. |
| **UI micro-animations** | Not applicable | Use tweened transforms, not sprite sheets. |
| **Particle effects** | Not applicable | Real-time, runs at game frame rate (60 fps). |

**Key Principle:** Animation frame rate should divide evenly into the game's
frame rate (60 fps). This means ideal rates are: 10, 12, 15, 20, 30, or 60 fps.

| Anim FPS | Frames per Game Frame | Works Cleanly? |
|----------|-----------------------|----------------|
| 10 | Every 6th frame | Yes |
| 12 | Every 5th frame | Yes |
| 15 | Every 4th frame | Yes |
| 20 | Every 3rd frame | Yes |
| 24 | Every 2.5 frames | **No** (judder) |
| 30 | Every 2nd frame | Yes |

**Recommendation:** Use **12 fps** for most sprite animations. This is the
traditional standard for 2D game animation, aligns perfectly with 60 fps,
and keeps frame counts (and thus memory usage) reasonable.

### 4.3 Sprite Sheet Format for Flame

Flame's `SpriteAnimation` expects either:

**Option A: Single-row strip (simplest)**
```
┌─────┬─────┬─────┬─────┬─────┬─────┐
│ F1  │ F2  │ F3  │ F4  │ F5  │ F6  │
└─────┴─────┴─────┴─────┴─────┴─────┘
Width = frameWidth * frameCount
Height = frameHeight
```

Load with:
```dart
final animation = await SpriteAnimation.load(
  'dragon_idle_spritesheet.png',
  SpriteAnimationData.sequenced(
    amount: 6,        // frame count
    stepTime: 1/12,   // seconds per frame (12 fps)
    textureSize: Vector2(128, 128),  // single frame size
  ),
);
```

**Option B: Grid layout (for many frames)**
```
┌─────┬─────┬─────┬─────┐
│ F1  │ F2  │ F3  │ F4  │
├─────┼─────┼─────┼─────┤
│ F5  │ F6  │ F7  │ F8  │
├─────┼─────┼─────┼─────┤
│ F9  │ F10 │ F11 │ F12 │
└─────┴─────┴─────┴─────┘
```

Load with:
```dart
final animation = await SpriteAnimation.load(
  'dragon_walk_spritesheet.png',
  SpriteAnimationData.sequenced(
    amount: 12,
    stepTime: 1/12,
    textureSize: Vector2(128, 128),
    amountPerRow: 4,  // wraps to next row after 4 frames
  ),
);
```

**Option C: TexturePacker atlas (most flexible)**
```dart
// Requires flame_texturepacker package
final atlas = await TexturePackerAtlas.load('animations.json');
final frames = atlas.findSpritesByName('dragon_idle');
final animation = SpriteAnimation.spriteList(frames, stepTime: 1/12);
```

### 4.4 Size Optimization for Mobile

**Maximum Sprite Sheet Dimensions:**
- **Hard limit:** 4096x4096 (GPU max texture size on most devices)
- **Recommended limit:** 2048x2048 (safe for all budget Android GPUs)
- **Preferred:** 1024x1024 or smaller per sheet

**Memory Calculation:**

```
Memory = width * height * 4 bytes (RGBA)

Examples:
  512x512   = 1.0 MB in GPU memory
  1024x1024 = 4.0 MB in GPU memory
  2048x2048 = 16.0 MB in GPU memory
  4096x4096 = 64.0 MB in GPU memory  (too much for budget devices!)
```

**Optimization Techniques:**

1. **Trim transparent pixels** (TexturePacker does this automatically). A 128x128
   frame where the sprite only occupies 80x100 can be trimmed to 80x100 with offset
   metadata. Easily saves 30-40% texture area.

2. **Use PNG-8 indexed color** where full alpha isn't needed. Reduces PNG file size
   by ~75%. GPU memory usage stays the same (decoded to RGBA), but download/load
   time improves significantly.

3. **Share atlases across animation states.** Pack idle, walk, and react frames into
   one atlas rather than separate images. Reduces texture switches during rendering.

4. **Limit frame count.** A 12-frame idle cycle at 128x128 = 12 * 128 * 128 * 4 =
   786KB GPU memory. A 24-frame cycle doubles that. 12 frames at 12 fps = 1 second
   of animation; extend perceived length by ping-ponging.

5. **Scale sprites to render size.** If the dragon displays at 64x64 dp on screen,
   the sprite frames should be 128x128 px (2x for high-DPI) at most. There is no
   benefit to shipping 512x512 frames that are downscaled to 64dp.

**Budget Android Sprite Sheet Memory Target:**
- Total sprite sheet GPU memory: under 8MB across all loaded sheets.
- Per-screen sprite sheet budget: under 4MB.
- This allows roughly: two 1024x1024 sheets + several 512x512 sheets.

---

## 5. Performance Budgets

### 5.1 Target Device Profile

**Budget Android phone (~$150 USD, 2024-2025 vintage):**

| Spec | Typical Value |
|------|---------------|
| SoC | MediaTek Dimensity 6100+ or Snapdragon 4 Gen 2 |
| GPU | Mali-G57 MC2 or Adreno 613 |
| RAM | 4-6 GB |
| Screen | 6.5" 720p or 1080p, 60Hz |
| Android | 13 or 14, API 33-34 |
| Available app memory | ~200-300MB before pressure |

Examples: Samsung Galaxy A15, Xiaomi Redmi 13, Motorola Moto G14.

### 5.2 Frame Rate Targets

| Scenario | Target FPS | Max Frame Time | Notes |
|----------|-----------|----------------|-------|
| Hub screen (idle) | 60 fps | 16.6ms | Ambient particles + dragon idle |
| Hub screen (transition) | 60 fps | 16.6ms | Screen transition animation |
| In-game (normal play) | 60 fps | 16.6ms | Game logic + rendering + HUD |
| In-game (heavy particles) | 45-60 fps | 16.6-22ms | Briefly acceptable during bursts |
| Level complete sequence | 60 fps | 16.6ms | Stars + score tally + gold particles |

**The Impeller advantage (Flutter 3.27+):** As of Flutter 3.27, Impeller is the
default rendering engine on Android API 29+. Impeller eliminates shader compilation
jank (the #1 source of first-run stuttering), achieves 50% faster frame rasterization,
and reduces jank frames from ~12% (Skia) to ~1.5%. This dramatically improves
animation smoothness on budget devices.

**Ensure Impeller is enabled.** For Flutter 3.41.1 (Math Dragons' version),
Impeller should be default on Android. Verify with:
```bash
flutter run --verbose 2>&1 | grep -i impeller
```

### 5.3 Particle Count Budgets

Based on research into Flutter/Flame particle performance:

| Budget Level | Max Simultaneous Particles | Notes |
|-------------|---------------------------|-------|
| **Comfortable** | Under 100 | Smooth 60 fps on all devices |
| **Moderate** | 100-300 | 60 fps on most budget devices |
| **Heavy** | 300-500 | May drop to 45-50 fps on budget devices |
| **Danger zone** | 500-1000 | Frame drops likely on budget Android |
| **Unacceptable** | 1000+ | Visible jank, possible ANR |

**Key finding from research:** Flutter Canvas rendering works well below 1,000
particles, starts degrading from 3,000, and becomes unusable around 4,000+.
With Impeller, these thresholds are somewhat higher, but budget devices have
weaker GPUs.

**Math Dragons particle budgets by effect:**

| Effect | Particles per Instance | Max Concurrent Instances | Max Total |
|--------|----------------------|-------------------------|-----------|
| Green burst (correct) | 15-20 | 1 | 20 |
| Red burst (wrong) | 8-12 | 1 | 12 |
| Gold sparkle (scales) | 8-12 | 1 | 12 |
| Spell effect (runes) | 8/node * 3-5 nodes | 1 | 40 |
| Munch effect (feast) | 15 | 1 | 15 |
| Fire trail embers | 30-50 (pooled) | 1 | 50 |
| Hub ambient embers | 15-25 (pooled) | 1 | 25 |
| **Worst case total** | | | **~90-130** |

This is well within the "comfortable" zone. The worst case is roughly
90-130 particles, which is under 100 in practice because burst effects
are short-lived (300-800ms) and don't overlap with continuous effects from
different screens.

### 5.4 Memory Budget for Animation Assets

| Category | Budget | Notes |
|----------|--------|-------|
| **Rive files (all)** | 200-500KB on disk, <2MB decoded | Dragon companion all states + splash |
| **Sprite sheets (all)** | 2-4MB on disk, <8MB GPU memory | All game sprites, UI sprites |
| **Fonts** | ~500KB | Already loaded (Cinzel, Nunito, JetBrains Mono) |
| **Sound effects** | 1-2MB | WAV files for SFX |
| **Music** | 5-10MB | MP3 background tracks |
| **Total animation-related** | ~3-7MB on disk, ~10MB runtime | |

**Total app memory target:** Under 150MB runtime on budget devices.
Animation assets are a small fraction of this.

### 5.5 Tips for Avoiding Jank During Animation

#### Rendering Pipeline

1. **Use Impeller.** Confirm it is active. Impeller eliminates shader compilation
   jank, which is the most common cause of first-frame stuttering in Flame games.

2. **Reuse Paint objects.** Every `Paint()` allocation puts pressure on the garbage
   collector. Create `Paint` instances once and modify their properties per frame.
   The existing particle effects already do this well in some cases but not all
   (`GemSparkleEffect` creates a new `Paint()` per particle per frame -- should be
   fixed).

3. **Pool particles.** For continuous effects (fire trail, hub embers), maintain a
   fixed-size pool. When a particle "dies," reset its properties and reuse it.
   Never allocate/deallocate particle objects during gameplay.

4. **Batch draw calls.** For particles of the same color/size, use
   `canvas.drawRawPoints(PointMode.points, positions, paint)` instead of individual
   `drawCircle` calls. This can reduce draw call overhead by 10-50x.

5. **Avoid `saveLayer`/`clipPath` during animation.** These trigger off-screen
   rendering passes. Use `ClipRect` only when essential, never per-frame.

#### Widget Layer (Flutter Animations)

6. **Narrow rebuild scope.** Use `AnimatedBuilder` with a `child` parameter for
   static subtrees. Never put non-animated widgets inside the `builder` function.

7. **Use `const` constructors.** Allows Flutter to skip rebuilding unchanged widgets.

8. **Avoid `Opacity` widget.** It triggers `saveLayer` on every frame. Use
   `AnimatedOpacity` or `FadeTransition` instead, which optimize internally.

9. **`RepaintBoundary` for animated regions.** Wrap particle effect areas and
   animated HUD elements in `RepaintBoundary` to prevent them from triggering
   repaints of the entire widget tree.

#### Asset Loading

10. **Pre-load Rive files during splash/loading.** Don't load `.riv` files on
    demand during gameplay. Load all needed animations during the loading screen
    and cache the artboards.

11. **Lazy-load game-specific assets.** Don't load Fire Trail sprites while on
    the hub screen. Load them when the user taps the game card, during the
    screen transition.

12. **Dispose animations when leaving screens.** Release Rive controllers,
    stop AnimationControllers, and remove particle effects when navigating away
    from a screen. Use `dispose()` and `removeFromParent()` properly.

#### Profiling

13. **Always profile in Release mode.** Debug mode is 10-50x slower for rendering.
    Profile mode preserves debugging info but uses release-level optimizations.

14. **Use Flutter DevTools Timeline.** Check that frame rendering times stay under
    16ms. Look for spikes during animation start/end.

15. **Test on the target device.** Budget Android performance cannot be estimated
    from a flagship phone or desktop. Test on a $100-150 phone early and often.

---

## Summary: Implementation Priority

Based on impact, complexity, and the current state of Math Dragons:

### Phase 1: Quick Wins (1-2 days)

- [ ] Standardize existing particle effects into reusable `BaseParticleEffect`
- [ ] Fix Paint object reuse in `GemSparkleEffect`
- [ ] Add screen transitions (Hub/Game/Dialog) using `PageRouteBuilder`
- [ ] Add streak pulse animation (Flutter `AnimationController`)
- [ ] Standardize countdown overlay across all games

### Phase 2: UI Polish (2-3 days)

- [ ] Level complete star fill sequence
- [ ] Scales earned gold particles (bezier path-following)
- [ ] Currency shimmer effect
- [ ] Background glow pulse
- [ ] Hub ambient embers
- [ ] Star twinkle

### Phase 3: Rive Integration (3-5 days)

- [ ] Set up Rive package (`rive: ^0.12.4`, `flame_rive`)
- [ ] Create dragon companion idle animation in Rive editor
- [ ] Integrate dragon idle on hub screen with state machine
- [ ] Add dragon reaction (look toward tapped game)
- [ ] Create splash screen animation

### Phase 4: Major Animations (3-5 days)

- [ ] Dragon evolution transition (Rive + Flutter layered)
- [ ] Egg hatch sequence (sprite + particles)
- [ ] Fire trail continuous ember emitter with particle pooling

### Phase 5: Optimization Pass (1-2 days)

- [ ] Profile on budget Android device
- [ ] Implement particle pooling for continuous effects
- [ ] Verify Impeller is active
- [ ] Add RepaintBoundary around animated regions
- [ ] Lazy-load/dispose game assets on screen transitions

**Total estimated effort: 10-17 days**

---

## Sources

- [Rive Pricing](https://rive.app/pricing)
- [Rive State Machine Overview](https://help.rive.app/editor/state-machine)
- [Rive's $9/mo Cadet Plan Announcement](https://rive.app/blog/rive-s-new-9-mo-plan)
- [Rive Free Unlimited Personal Files](https://rive.app/blog/no-cap-free-unlimited-personal-files-for-individual-creators)
- [Rive Best Practices](https://rive.app/docs/getting-started/best-practices)
- [Rive vs Lottie Comparison](https://rive.app/blog/rive-as-a-lottie-alternative)
- [Rive GameKit Overview](https://help.rive.app/rive-gamekit/overview)
- [Why Rive Chose Flutter for GameKit](https://rive.app/blog/why-we-chose-flutter-for-the-rive-gamekit)
- [flame_rive Package Documentation](https://docs.flame-engine.org/latest/bridge_packages/flame_rive/rive.html)
- [flame_spine Package Documentation](https://docs.flame-engine.org/latest/bridge_packages/flame_spine/flame_spine.html)
- [spine-flutter Runtime Documentation](http://en.esotericsoftware.com/spine-flutter)
- [Spine 2D Purchase Page](https://esotericsoftware.com/spine-purchase)
- [Flame Particles Documentation](https://docs.flame-engine.org/latest/flame/rendering/particles.html)
- [Lottie Flutter Package](https://pub.dev/packages/lottie)
- [Lottie Performance Degradation Issue](https://github.com/xvrh/lottie-flutter/issues/98)
- [Lottie vs Rive: Optimizing Mobile App Animation (Callstack)](https://www.callstack.com/blog/lottie-vs-rive-optimizing-mobile-app-animation)
- [Rive vs Lottie: Animation Frameworks for Flutter (TillItsDone)](https://tillitsdone.com/blogs/rive-vs-lottie--flutter-animations/)
- [TexturePacker Flame Engine Tutorial](https://www.codeandweb.com/texturepacker/tutorials/how-to-create-sprite-sheets-and-animations-with-flame-engine)
- [flame_texturepacker Package](https://pub.dev/packages/flame_texturepacker)
- [Aseprite Official Site](https://www.aseprite.org/)
- [Flutter Flame Optimization Techniques](https://asgalex.medium.com/flutter-flame-simplest-optimization-techniques-372dbe6815f)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter Impeller Rendering Engine](https://docs.flutter.dev/perf/impeller)
- [Flutter Improving Rendering Performance](https://docs.flutter.dev/perf/rendering-performance)
- [Flutter App Performance: Profiling, Fixing Jank (2026)](https://startup-house.com/blog/flutter-app-performance)
- [Flame Engine: Is It a Real Competitor in 2025?](https://genieee.com/flutter-game-development-is-flame-a-real-competitor-in-2025/)
- [Flutter Custom Painters Deep Dive](https://dasroot.net/posts/2026/01/flutter-custom-painters-advanced-graphics-deep-dive/)
- [High-Performance Canvas Rendering (Plugfox)](https://plugfox.dev/high-performance-canvas-rendering/)
- [Flutter FPS Drops with 4k+ Particles Issue](https://github.com/flutter/flutter/issues/46841)

---

*Document created: 2026-02-16*
*Status: Research complete. Ready for implementation planning.*
