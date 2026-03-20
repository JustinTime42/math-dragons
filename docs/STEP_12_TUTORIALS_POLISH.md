# Step 12: Tutorials, Onboarding, Loading States & Micro-interactions

> Implementation guide for Math Dragons tutorial system, splash/loading screens,
> empty states, and interaction polish. Every recommendation is tailored to the
> existing codebase (Flame 1.14, Provider, Hive, Flutter 3.41.1 / Dart 3.11).

---

## Table of Contents

1. [Tutorial Design Patterns for Kids Games](#1-tutorial-design-patterns-for-kids-games)
2. [Flutter Implementation Approaches](#2-flutter-implementation-approaches)
3. [Tutorial Content Per Game](#3-tutorial-content-per-game)
4. [Loading States & Splash Screen](#4-loading-states--splash-screen)
5. [Empty States](#5-empty-states)
6. [Micro-interactions Catalog](#6-micro-interactions-catalog)

---

## 1. Tutorial Design Patterns for Kids Games

### 1.1 Coach Marks vs. Interactive Tutorials vs. Guided First-Play

There are three dominant patterns for game onboarding. Here is how each maps to
Math Dragons:

| Pattern | Description | Pros | Cons | Fit for Math Dragons |
|---------|-------------|------|------|----------------------|
| **Coach marks** | Semi-transparent overlay highlights one UI element at a time with a tooltip | Fast to implement, low dev cost | Passive — kids tap through without learning | Good for Hub tutorial only |
| **Interactive tutorial** | Guided steps where the player must perform the action to advance | High comprehension, learn-by-doing | More complex to build, must handle edge cases | Best for in-game tutorials |
| **Guided first-play** | The first level IS the tutorial with reduced complexity and hand-held prompts | Feels natural, no "tutorial mode" | Harder to maintain separately | Best for Fire Trail and Dragon's Feast |

**Recommendation for Math Dragons:** Use a **hybrid approach**.
- **Hub Screen:** Coach-mark style with dragon dialogue bubbles (3-4 steps).
- **Each mini-game:** Interactive guided first-play. Level 1 of World 1 doubles as
  the tutorial. A simplified overlay appears only on the first play, pausing the
  game at key moments and requiring the player to perform the action before
  advancing.

### 1.2 Tap-to-Continue vs. Auto-Advance

Research from Apple's game onboarding guidelines shows that tap-to-continue is
strongly preferred for kids ages 7-14 because:

- Children read at different speeds. Auto-advance frustrates slow readers and
  bores fast ones.
- Tap-to-continue provides agency — kids feel in control.
- It is simpler to implement accessibly (a single large tap target).

**Recommendation:** All tutorial steps use tap-to-continue with a large
(minimum 48dp), clearly visible "Next" or right-arrow button. Include a subtle
pulsing animation on the tap target so kids know where to press.

### 1.3 Optimal Tutorial Length

According to the American Academy of Pediatrics, a child's focused attention
span is roughly 3-5 minutes per year of age. For ages 7-14, that translates
to approximately 21-70 minutes of sustained focus. However, **tutorial
tolerance** is much shorter than gameplay tolerance.

Research from mobile game analytics (Adrian Crook & Associates) shows:
- **3-5 steps** is the sweet spot for a single tutorial sequence.
- Each step should take **3-8 seconds** to read and process.
- Total tutorial time should be **under 30 seconds** for any single game.
- If more explanation is needed, split it across multiple contextual moments
  (e.g., introduce power-ups on the first level that has them, not in an
  upfront tutorial).

Clash Royale divides onboarding into five short tutorials delivered at
relevant moments, each introducing one new concept. This is the model to
follow.

**Recommendation for Math Dragons:**
- Hub tutorial: **4 steps** (dragon, games, scales, daily challenges) = ~20s
- Each game tutorial: **3-4 steps** (controls, goal, one mechanic) = ~15-20s
- Advanced mechanics (power-ups, hints, etc.): **1-2 contextual tooltips**
  when first encountered

### 1.4 Dragon Character as Guide vs. Pure UI Highlights

For educational games targeting children, character-driven onboarding
consistently outperforms pure UI highlights:

- A friendly mascot (the dragon companion) turns instructions into a
  conversation, not a lecture.
- Dialogue bubbles feel like the dragon is teaching the player, which
  reinforces the fantasy theme ("Fantasy, Not Classroom" design principle).
- Pre-literate or struggling readers benefit from short, simple sentences
  paired with visual demonstrations.
- Sesame Street, Prodigy Math, and DragonBox all use mascot-guided tutorials
  to great effect.

**Recommendation:** Use the existing `DragonCompanion` widget as the tutorial
guide. Tutorial steps appear as speech bubbles emanating from the dragon (or
a small dragon head avatar for in-game tutorials). The dragon's dialogue
should be:
- **Short:** 1-2 sentences max per step.
- **Encouraging:** "Let me show you something cool!" not "You must learn this."
- **In character:** The dragon speaks as a friendly companion, not an
  instructor. Use phrases like "Watch this!", "Try it!", "You got it!"
- **Age-appropriate:** No baby talk. Conversational tone suitable for ages
  7-14.

### 1.5 When to Show Tutorials

| Trigger | What Shows | Condition |
|---------|------------|-----------|
| First app launch ever | Hub tutorial (4 steps) | `tutorial_hub_seen == false` in Hive meta box |
| First play of a game | Game-specific tutorial (3-4 steps) | `tutorial_{gameId}_seen == false` in Hive meta box |
| First encounter of a mechanic | Contextual tooltip (1 step) | e.g., `tutorial_powerups_seen == false` for Dragon's Feast power-ups |
| Player taps "?" help button | Full tutorial replay | Always available in pause menu |

### 1.6 Handling Returning Players Who Skip Tutorials

- **Never block gameplay.** Every tutorial step has a visible "Skip" button
  (top-right corner, text-only, subdued color) that immediately dismisses
  the entire tutorial and marks it as seen.
- **Help button in pause menu.** The GameShell pause overlay should include a
  "How to Play" option that replays the tutorial for the current game.
- **Reset tutorials in Settings.** The SettingsScreen should have a "Reset
  Tutorials" toggle that clears all `tutorial_*_seen` flags, useful if a
  younger sibling takes over the device.
- **First-play detection is per-game, per-device.** Stored in the Hive meta
  box alongside schema version, not in the player profile (so it survives
  profile resets).

---

## 2. Flutter Implementation Approaches

### 2.1 Package Comparison

#### tutorial_coach_mark

- **What it does:** Creates spotlight overlays that highlight specific widgets
  using `GlobalKey` targets. Supports custom content widgets per target,
  animated transitions, and programmatic step control.
- **Strengths:** Highly customizable, supports both circular and rectangular
  cutouts, built-in animations, well-maintained (1000+ likes on pub.dev).
- **Weaknesses:** Designed for standard Flutter widgets, not Flame game
  canvases. Cannot highlight Flame components (they are not Flutter widgets
  with `GlobalKey`s). Requires the target widget to be visible and laid out.
- **Verdict for Math Dragons:** Suitable for the Hub tutorial and any
  pure-Flutter screens (settings, achievements, store). NOT suitable for
  in-game tutorials.

#### showcaseview

- **What it does:** Similar to tutorial_coach_mark. Step-by-step feature
  discovery using `Showcase` wrapper widgets.
- **Strengths:** Version 5.0+ has excellent performance (0.6 MB memory, 88
  FPS). Supports custom tooltip widgets, auto-scroll to off-screen targets,
  and multi-highlight mode.
- **Weaknesses:** Same fundamental limitation — wraps Flutter widgets, cannot
  target Flame components. Also requires wrapping each target widget in a
  `Showcase` widget, which adds wrapper overhead throughout the codebase.
- **Verdict for Math Dragons:** Similar capability to tutorial_coach_mark but
  the wrapper pattern is more invasive. Not recommended.

#### Custom Overlay Approach (Stack + Overlay Widget)

- **What it does:** A hand-built tutorial system using Flutter's `Stack`,
  `Positioned`, and semi-transparent `Container` widgets, with cutout holes
  achieved via `CustomPainter` or `ColorFiltered`.
- **Strengths:** Complete control over visuals. Can position tutorial elements
  relative to both Flutter widgets AND Flame game coordinates (by converting
  game coordinates to screen coordinates). Fits the existing `GameShell`
  `Stack` pattern perfectly. No external dependencies.
- **Weaknesses:** More code to write initially.
- **Verdict for Math Dragons:** Best approach for in-game tutorials.

#### Flame Overlay System

- **What it does:** `game.overlays.add('tutorialStep1')` adds a named Flutter
  widget overlay that renders on top of the Flame game canvas. Overlays are
  registered in the `GameWidget.overlayBuilderMap`.
- **Strengths:** Purpose-built for showing Flutter UI over Flame games. The
  Math Dragons codebase already uses `GameWidget` with overlays for feedback
  messages and level-complete screens. Can pause the game while showing the
  overlay.
- **Weaknesses:** The overlay is a full Flutter widget — it does not
  automatically know about Flame component positions. You must manually
  calculate screen positions from game coordinates.
- **Verdict for Math Dragons:** Good complement to the custom overlay
  approach. Use Flame overlays for tutorial steps that need to pause the game
  and show dialogue.

### 2.2 Recommended Architecture

**Use a two-layer system:**

1. **`TutorialOverlay` widget** (for Hub and pure-Flutter screens):
   A reusable widget that uses `tutorial_coach_mark` OR a custom `Stack`-based
   spotlight system to highlight Flutter widgets by `GlobalKey`.

2. **`GameTutorialOverlay`** (for in-game tutorials):
   A Flame overlay registered in each game's `GameWidget.overlayBuilderMap`.
   It displays a semi-transparent backdrop with a dragon dialogue bubble and
   an optional highlight zone. The game pauses while the overlay is active.

**Shared infrastructure:**

```
lib/
  tutorial/
    tutorial_service.dart        # Checks/sets seen flags in Hive meta box
    tutorial_step.dart           # Data model: text, highlight region, action
    tutorial_overlay.dart        # Hub/Flutter screen coach marks
    game_tutorial_overlay.dart   # Flame overlay for in-game tutorials
    dragon_dialogue.dart         # Dragon speech bubble widget (reusable)
```

### 2.3 First-Play Detection

Use the existing `LocalStorage` meta box (Hive `Box<dynamic>` named
`app_meta`):

```dart
// In tutorial_service.dart
class TutorialService {
  final LocalStorage storage;

  TutorialService({required this.storage});

  bool hasSeenTutorial(String tutorialId) {
    return storage.getMeta('tutorial_${tutorialId}_seen') == true;
  }

  void markTutorialSeen(String tutorialId) {
    storage.setMeta('tutorial_${tutorialId}_seen', true);
  }

  void resetAllTutorials() {
    final keys = storage.metaKeys
        .where((k) => k.toString().startsWith('tutorial_'));
    for (final key in keys) {
      storage.deleteMeta(key);
    }
  }
}
```

Tutorial IDs: `hub`, `dragon_runes`, `fire_trail`, `dragon_eggs`,
`dragons_feast`, `powerups`, `hints`.

### 2.4 Dragon Dialogue Widget Spec

```dart
/// A speech bubble emanating from a dragon avatar.
/// Used in all tutorial overlays.
class DragonDialogue extends StatelessWidget {
  final String text;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final int currentStep;
  final int totalSteps;

  // Widget tree:
  // Column
  //   Row: [Dragon avatar (40x40 emoji), SizedBox(8), Expanded speech bubble]
  //   Row: [Step dots, Spacer, Skip button, Next button]
  //
  // Speech bubble: Container with DragonColors.nightSurface bg,
  //   border: DragonColors.dragonGold.withAlpha(60),
  //   borderRadius: 12, padding: DragonSpacing.md
  //
  // Text style: Nunito, 15sp, DragonColors.textPrimary
  // Dragon avatar: Small dragon emoji matching current evolution stage
  // Next button: Gold, 44dp height, "Next" or "Got it!" on last step
  // Skip button: TextButton, DragonColors.textSecondary, "Skip"
  // Step dots: Row of circles, gold for current, gray for others
}
```

---

## 3. Tutorial Content Per Game

### 3.1 Hub Tutorial (First App Launch) — 4 Steps

Triggered when `tutorial_hub_seen == false`. Shown after the hub screen first
renders with a 500ms delay.

**Step 1: "Meet Your Dragon"**
- **Highlight:** DragonCompanion widget (center of hub)
- **Dragon says:** "Hey there! I'm your dragon companion. Play games to help
  me grow stronger!"
- **Visual:** Spotlight on the dragon with a gentle pulse effect.

**Step 2: "Choose a Game"**
- **Highlight:** Game card grid area
- **Dragon says:** "Pick any game to start. Each one teaches math in a
  different way!"
- **Visual:** Spotlight expands to cover the 2x2 game grid.

**Step 3: "Earn Scales"**
- **Highlight:** Scales counter in the ProfileBar (top-right area)
- **Dragon says:** "Earn scales by playing. Use them in the Dragon Store for
  cool stuff!"
- **Visual:** Spotlight on the scales display. Optionally animate a few
  floating scales.

**Step 4: "Daily Challenges"**
- **Highlight:** DailyChallengeCard (bottom of hub)
- **Dragon says:** "Check back every day for new challenges. Streaks earn
  bonus scales!"
- **Visual:** Spotlight on the daily challenge card.
- **Button text:** "Got it!" (replaces "Next" on last step)

### 3.2 Dragon Runes Tutorial (First Play) — 4 Steps

Triggered when `tutorial_dragon_runes_seen == false`. Shown after the Flame
game loads but before the player can interact.

**Step 1: "Target Spells"**
- **Highlight:** TargetPanel widget (top of screen)
- **Dragon says:** "These are the spells you need to cast. Each one is a math
  equation!"
- **Game state:** Paused. Targets are visible but nodes are dimmed.

**Step 2: "Connect the Runes"**
- **Highlight:** Center game area (Flame canvas)
- **Dragon says:** "Drag between rune stones to build an equation. Numbers
  and operators!"
- **Game state:** Paused. A brief animated hand gesture shows a drag from
  one node to another (use a dotted arrow overlay).

**Step 3: "Cast Your Spell"**
- **Highlight:** Center game area
- **Dragon says:** "When your chain makes a correct equation, the spell
  is cast!"
- **Game state:** Paused. Show an example chain highlight on existing nodes.

**Step 4: "Need Help?"**
- **Highlight:** HintButton (bottom-right)
- **Dragon says:** "Stuck? Tap the hint rune to reveal part of an answer.
  You get 3 per level."
- **Button text:** "Let's play!"
- **Game state:** Unpause after dismissal.

### 3.3 Fire Trail Tutorial (First Play) — 3 Steps

Triggered when `tutorial_fire_trail_seen == false`. Shown during the countdown
phase (before the 3-2-1 countdown starts).

**Step 1: "Control Your Dragon"**
- **Highlight:** DpadControls widget (bottom of screen)
- **Dragon says:** "Use the D-pad to steer me, or swipe anywhere on the
  screen!"
- **Game state:** Countdown paused at pre-start.

**Step 2: "Eat the Right Answer"**
- **Highlight:** ProblemDisplay (top) + answer gems on grid
- **Dragon says:** "See the math problem? Eat the gem with the correct
  answer. Avoid the wrong ones!"
- **Game state:** Still paused. Briefly flash the correct gem green.

**Step 3: "Keep the Flame Alive"**
- **Highlight:** FlameMeter widget (side of screen)
- **Dragon says:** "Wrong answers shrink my flame. If it goes out, game
  over! Right answers make it grow."
- **Button text:** "Let's go!"
- **Game state:** After dismissal, start the 3-2-1 countdown normally.

### 3.4 Dragon Eggs Tutorial (First Play) — 4 Steps

Triggered when `tutorial_dragon_eggs_seen == false`. Shown before eggs start
falling.

**Step 1: "Catch the Eggs"**
- **Highlight:** Game play area (center)
- **Dragon says:** "Eggs are falling! Each one has a number or operator
  inside."
- **Game state:** Paused, no eggs falling yet.

**Step 2: "Build an Equation"**
- **Highlight:** EquationDisplay widget (bottom area)
- **Dragon says:** "Tap eggs to grab them. Build an equation like
  3 + 4 = 7!"
- **Game state:** Show a mock equation appearing in the display area.

**Step 3: "Submit Your Answer"**
- **Highlight:** Submit button area
- **Dragon says:** "When your equation is complete, hit submit! Get it
  right to earn points."
- **Game state:** Still paused.

**Step 4: "Watch the Danger Line"**
- **Highlight:** DangerLine component (upper portion of screen)
- **Dragon says:** "Don't let eggs pile up past the danger line, or it's
  game over!"
- **Button text:** "I'm ready!"
- **Game state:** Start egg spawning after dismissal.

### 3.5 Dragon's Feast Tutorial (First Play) — 4 Steps

Triggered when `tutorial_dragons_feast_seen == false`. Shown before enemies
begin moving.

**Step 1: "Read the Category"**
- **Highlight:** CategoryDisplay widget (top of screen)
- **Dragon says:** "The board shows a math category. Right now it's: Even
  Numbers!"
- **Game state:** Paused. Board is visible with tiles but enemies frozen.

**Step 2: "Eat Matching Tiles"**
- **Highlight:** Grid area with a correct tile briefly highlighted
- **Dragon says:** "Move to tiles that match the category and eat them!
  Use the D-pad or swipe."
- **Game state:** Still paused. Briefly pulse a correct tile green.

**Step 3: "Avoid the Guardians"**
- **Highlight:** Enemy guardian positions on grid
- **Dragon says:** "Watch out for guardians! If they catch you, you lose
  a life."
- **Game state:** Still paused. Briefly flash enemies red.

**Step 4: "Power-Ups Help" (Contextual)**
- **Note:** This step is NOT shown in the initial tutorial. Instead, it
  appears as a single contextual tooltip on the first even-numbered level
  (Level 2), when `tutorial_powerups_seen == false`.
- **Dragon says:** "Grab power-ups for special abilities! Freeze, wings,
  or shield."
- **Trigger:** When the first power-up tile spawns on an even level.

---

## 4. Loading States & Splash Screen

### 4.1 Native Splash Screen (flutter_native_splash)

The native splash screen is what the OS shows immediately when the app process
starts, before Flutter has initialized. It must be a static image because no
Dart code is running yet.

**Package:** `flutter_native_splash: ^2.4.0`

**Configuration (add to `pubspec.yaml` or `flutter_native_splash.yaml`):**

```yaml
flutter_native_splash:
  color: "#1A0F3D"                    # DragonColors.deepVoid
  image: assets/images/splash/dragon_logo.png
  color_dark: "#1A0F3D"
  image_dark: assets/images/splash/dragon_logo.png

  android_12:
    color: "#1A0F3D"
    icon_background_color: "#1A0F3D"
    image: assets/images/splash/dragon_logo_android12.png
```

**Asset requirements:**
- `dragon_logo.png`: 512x512 centered dragon egg/logo on transparent bg.
- `dragon_logo_android12.png`: 288x288 (fits in Android 12's 240dp circle).
  Simpler version with just the egg silhouette.

**Integration with `main.dart`:**

```dart
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // ... existing initialization (Hive, Firebase, Auth) ...

  FlutterNativeSplash.remove(); // Remove native splash BEFORE runApp
  runApp(MathDragonsApp(...));
}
```

The `preserve` call keeps the native splash visible while async initialization
happens. The `remove` call transitions to the Flutter-rendered UI.

### 4.2 Animated Splash (Flutter-Rendered)

After the native splash, show a brief animated splash (1.5-2s) while the
hub screen builds. This provides a polished transition and can show a loading
indicator if initialization takes longer than expected.

**Implementation:** Replace the current `home: AchievementPopupOverlay(child: HubScreen())`
with a `SplashGate` widget that shows the animated splash first:

```dart
class SplashGate extends StatefulWidget {
  final Widget child;
  const SplashGate({super.key, required this.child});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleUp;
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
    );
    _scaleUp = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Transition to hub after animation + brief hold
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showChild = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showChild) {
      return widget.child;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: DragonColors.lairGradient),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeIn.value,
                child: Transform.scale(
                  scale: _scaleUp.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dragon egg/logo with gold glow
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: DragonColors.dragonGold.withAlpha(80),
                              blurRadius: 32,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Text(
                          '\u{1F525}', // fire/dragon emoji
                          style: TextStyle(fontSize: 72),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: DragonSpacing.lg),
                      Text(
                        'Math Dragons',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: DragonColors.dragonGold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

**Splash design:**
- Background: `DragonColors.lairGradient` (deep void to dragon purple).
- Center: Dragon egg/fire emoji (placeholder until Rive animations in Step
  12), fading in (0-400ms) with scale-up from 0.8 to 1.0 (easeOutBack).
- Below: "Math Dragons" in Cinzel Bold, 32sp, Dragon Gold.
- Gold glow box shadow pulses subtly around the logo.
- Total duration: ~2 seconds.

### 4.3 Game Loading States

Each Flame game takes a moment to initialize (layout calculation, component
creation). Use the `GameWidget.loadingBuilder` to show a themed loading state:

```dart
GameWidget(
  game: flameGame,
  loadingBuilder: (context) => Container(
    decoration: const BoxDecoration(gradient: DragonColors.nightSky),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: DragonSpacing.base),
          Text(
            'Preparing the arena...',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: DragonColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  ),
);
```

**Loading messages (rotate randomly):**
- "Preparing the arena..."
- "Sharpening the runes..."
- "Lighting the fire..."
- "The dragon awaits..."
- "Summoning numbers..."

### 4.4 Asset Preloading Strategy

Math Dragons currently uses procedurally rendered graphics (Flame's Canvas
drawing), so there are no heavy sprite sheets or audio files to preload.
When audio/Rive assets are added (Step 12 audio & animations), use this
strategy:

1. **Critical assets** (fonts, theme images): Preload in `main.dart` before
   `runApp` using `precacheImage()` or asset bundle loading. These are
   already fast because they are bundled in the APK.

2. **Game-specific assets** (sprites, sound effects): Preload in each game's
   `onLoad()` method using `Flame.images.loadAll()`. The `loadingBuilder`
   shown above covers this naturally.

3. **Audio files**: Use `FlameAudio.audioCache.loadAll()` in a dedicated
   `AudioPreloader` that runs during the animated splash.

4. **Rive animations**: Load `.riv` files in `onLoad()` and cache them.
   First-load is ~50-200ms; subsequent loads from cache are instant.

**No eager loading of all assets at startup.** Only preload what the current
screen needs. This keeps startup time under 2 seconds on mid-range Android
devices.

---

## 5. Empty States

All empty states follow a consistent pattern:
- **Illustration:** A themed emoji or icon (until real art assets exist).
- **Title:** Short, encouraging, 1 line.
- **Subtitle:** Actionable, tells the player what to do next, 1-2 lines.
- **Optional CTA button.**

### 5.1 No Achievements Unlocked Yet

Shown in `AchievementScreen` when no achievements exist in the
`_achievementsBox`.

```
    [Trophy emoji with question mark overlay]

    "Your trophy case awaits!"

    "Play any game to start earning achievements.
     Every dragon starts somewhere!"

    [Button: "Choose a Game" -> pop back to hub]
```

**Implementation location:** `lib/hub/achievement_screen.dart`, inside
`_AchievementList`. Wrap the `ListView.builder` in a check:

```dart
if (unlockedIds.isEmpty) {
  return _EmptyAchievements();
}
```

**Visual spec:**
- Icon: `Icons.emoji_events` at 64dp, color `DragonColors.dragonGold.withAlpha(80)`.
- Title: Cinzel, 20sp, `DragonColors.textPrimary`.
- Subtitle: Nunito, 14sp, `DragonColors.textSecondary`.
- CTA: Standard `ElevatedButton` with gold styling.
- Container: Centered in parent, padded `DragonSpacing.xxl` on all sides.

### 5.2 No Daily Challenge Progress

Shown in `DailyChallengeCard` when today's challenge has not been started yet
(all tasks have 0 progress). This is distinct from the "tasks visible but
incomplete" state — this is the very first view of the day.

```
    [Scroll emoji / calendar icon]

    "Today's Challenges Are Ready!"

    "Complete tasks to earn bonus scales.
     Keep your streak alive!"
```

**Note:** The `DailyChallengeCard` already shows tasks. The empty state here
is more of a "fresh" state with a brief animation. When the card first
appears for the day:
- Tasks fade in with a staggered delay (100ms between each).
- A brief gold shimmer sweeps across the card border.
- The streak badge shows "Day 1" or the current streak count.

### 5.3 First Time Opening Store

Shown in `StoreScreen` as a welcome banner at the top (not replacing the
store content — the items should still be visible below).

```
    [Dragon emoji + sparkle]

    "Welcome to the Dragon Store!"

    "Spend your hard-earned scales on colors
     and accessories for your dragon."

    [Scales count displayed prominently: "You have 0 scales"]
```

**Implementation:** Add a `_StoreWelcomeBanner` widget at the top of the
store's `ListView` that only shows when `tutorial_store_seen == false` in
the meta box. It includes a "Got it!" dismiss button that sets the flag.

**Visual spec:**
- Banner background: `DragonColors.amethyst.withAlpha(30)` with gold border.
- Dismissible with a small "x" in the top-right corner.
- Shows once, then never again (persisted via TutorialService).

### 5.4 No Game Stats Yet (First Time Viewing a Game Card)

Shown on `GameCard` widgets in the hub when `timesPlayed == 0`.

```
    [Game icon in accent color]
    [Game title]

    "Not played yet"

    "Tap to start your first adventure!"

    [Subtle pulsing glow on card border to draw attention]
```

**Current behavior:** The `GameCard` already shows `Level 1`, `0 stars`,
`0 played`. Change this to show the empty state message instead of the
stats row when `timesPlayed == 0`.

**Visual spec:**
- Replace the stats row (level/stars/played) with "Tap to begin!" text.
- Text: Nunito, 12sp, accent color, italic.
- Card border: Add a subtle pulse animation (gold glow opacity cycles
  from 0.1 to 0.3 over 2 seconds) for unplayed games only.
- After the first play, the card transitions to showing normal stats.

---

## 6. Micro-interactions Catalog

Every interactive element in Math Dragons should provide immediate, satisfying
feedback. Below is the complete catalog of micro-interactions, each with its
animation specification.

### 6.1 Button Press Feedback (Scale + Haptic)

**Applies to:** All `ElevatedButton`, `OutlinedButton`, `IconButton`,
custom tap targets (`_QuickAccessButton`, `GameCard`, `HintButton`, etc.)

| Property | Value |
|----------|-------|
| Trigger | `onTapDown` |
| Scale | 1.0 -> 0.95 |
| Duration (press) | 80ms |
| Duration (release) | 120ms |
| Curve (press) | `Curves.easeInCubic` |
| Curve (release) | `Curves.easeOutCubic` |
| Haptic | `HapticsService.lightTap()` on press |
| Visual | Slight darkening of background (overlay black at 10% opacity) |

**Implementation — reusable `TapScaleWrapper`:**

```dart
class TapScaleWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;  // default 0.95

  @override
  State<TapScaleWrapper> createState() => _TapScaleWrapperState();
}

class _TapScaleWrapperState extends State<TapScaleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Controller: duration 80ms forward, 120ms reverse
  // Tween: 1.0 -> widget.scaleDown
  // On tap down: _controller.forward()
  // On tap up / cancel: _controller.reverse()
  // On tap: widget.onTap?.call() + haptic
}
```

### 6.2 Game Card Tap Animation

**Applies to:** `GameCard` widgets in the hub grid.

| Property | Value |
|----------|-------|
| Trigger | `onTap` |
| Scale | 1.0 -> 0.96 -> 1.0 |
| Duration | 150ms total (80ms down, 70ms up) |
| Curve | `Curves.easeInOut` |
| Haptic | `HapticsService.lightTap()` |
| Extra | Card elevation shadow increases by 4dp during press. Accent color border brightens to full opacity during press. |
| Navigation | After scale returns to 1.0, push the game screen with a `Hero` transition on the card icon. |

**Hero transition spec:**
- Tag: `'game_card_$gameId'`
- The game's icon animates from its position in the GameCard to the game
  screen's title area.
- Duration: 400ms.
- Curve: `Curves.easeInOutCubic`.

### 6.3 Toggle Switch Animation

**Applies to:** All toggle switches in `SettingsScreen` (haptics on/off,
sound on/off, etc.)

| Property | Value |
|----------|-------|
| Widget | `Switch` with custom `thumbColor` and `trackColor` |
| Transition | Built-in Material switch animation (200ms) |
| Thumb color ON | `DragonColors.dragonGold` |
| Thumb color OFF | `DragonColors.disabled` |
| Track color ON | `DragonColors.dragonGold.withAlpha(80)` |
| Track color OFF | `DragonColors.disabled.withAlpha(50)` |
| Haptic | `HapticsService.lightTap()` on toggle |
| Extra | When toggling ON, a brief gold ripple expands from the switch (200ms, fade-out). |

### 6.4 Score Counter Tick-Up

**Applies to:** Score displays in all games (`ScoreStreakDisplay`,
`FeastScoreDisplay`, `score_display.dart`), and the scales counter in
`ProfileBar` and `GameShell` HUD.

| Property | Value |
|----------|-------|
| Trigger | Score value changes |
| Animation | Numeric tick-up from old value to new value |
| Duration | 400ms for small changes (<100 pts), 800ms for large changes |
| Curve | `Curves.easeOutCubic` |
| Visual | During tick-up, text scale pulses 1.0 -> 1.15 -> 1.0 (200ms, easeOutBack) |
| Color flash | Text briefly flashes `DragonColors.dragonGold` then returns to normal color over 300ms |
| Haptic | None (would be too frequent) |

**Implementation — `AnimatedScoreCounter`:**

```dart
class AnimatedScoreCounter extends StatefulWidget {
  final int value;
  final TextStyle style;

  @override
  State<AnimatedScoreCounter> createState() => _AnimatedScoreCounterState();
}

class _AnimatedScoreCounterState extends State<AnimatedScoreCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _displayValue = 0;
  int _previousValue = 0;

  // When widget.value changes:
  //   _previousValue = _displayValue;
  //   _controller.forward(from: 0);
  //
  // Animation drives _displayValue from _previousValue to widget.value
  // using IntTween. Also drives a scale pulse on the text.
}
```

**Note:** The `AnimatedScalesCounter` widget already exists in the codebase
(from Step 9). Extend it with the pulse and color flash effects, and extract
the core logic into a shared `AnimatedScoreCounter` that all game score
displays can use.

### 6.5 Star Fill Animation

**Applies to:** Star displays in `ResultScreen`, `GameCard`, and
`LevelSelectScreen`.

| Property | Value |
|----------|-------|
| Trigger | Stars awarded at level complete |
| Animation | Stars fill one at a time, left to right |
| Stagger delay | 300ms between each star |
| Fill duration | 400ms per star |
| Curve | `Curves.easeOutBack` (slight overshoot) |
| Visual | Star scales from 0.0 -> 1.2 -> 1.0 while opacity goes 0 -> 1. Gold particle burst (4-6 tiny squares) around each star as it fills. |
| Color | Empty: `DragonColors.disabled`. Filled: `DragonColors.dragonGold`. |
| Haptic | `HapticsService.mediumTap()` on each star fill. |

**Implementation — `AnimatedStarRating`:**

```dart
class AnimatedStarRating extends StatefulWidget {
  final int stars;     // 0-3
  final int maxStars;  // default 3
  final double size;   // default 32
  final bool animate;  // false for static display (e.g., in cards)

  // When animate == true and stars > 0:
  //   Stagger-animate each star with the timing above.
  // When animate == false:
  //   Render filled/empty stars immediately.
}
```

### 6.6 Progress Bar Fill Animation

**Applies to:** Achievement progress bars in `AchievementScreen`, level
progress indicators, flame intensity meter, daily challenge completion bar.

| Property | Value |
|----------|-------|
| Trigger | Progress value changes |
| Animation | Bar fills from left to right |
| Duration | 600ms |
| Curve | `Curves.easeOutCubic` |
| Visual | A bright highlight "shimmer" sweeps across the filled portion (a 20% width gradient from transparent to white at 30% opacity to transparent), traveling left to right over 400ms, starting at the 200ms mark. |
| Color | Base: game accent color at 20% opacity. Fill: game accent color at full opacity. |
| Overflow glow | When progress reaches 100%, a brief gold glow pulse (300ms, easeOut). |

**Implementation — `AnimatedProgressBar`:**

```dart
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double height;   // default 8
  final Duration duration;
  final bool showShimmer;

  // Uses AnimatedContainer for the fill width.
  // Shimmer effect uses a gradient inside a ShaderMask or
  // an overlay AnimatedPositioned Container.
}
```

### 6.7 Navigation Transitions

**Hub -> Game Screen:**

| Property | Value |
|----------|-------|
| Type | `MaterialPageRoute` with custom `PageRouteBuilder` |
| Transition | Slide up + fade in |
| Duration | 350ms |
| Curve | `Curves.easeOutCubic` |
| Visual | New screen slides up from bottom 30% while fading from 0 to 1. Old screen stays static with a subtle darkening overlay (0 to 10% black). |

**Hub -> Settings / Achievements / Store:**

| Property | Value |
|----------|-------|
| Type | `MaterialPageRoute` (standard) |
| Transition | Default Material slide-from-right |
| Duration | 300ms (Material default) |
| Curve | Material default (`Curves.easeInOut`) |

**Game Over -> Result Screen:**

| Property | Value |
|----------|-------|
| Type | `showModalBottomSheet` (already used) |
| Transition | Slide up from bottom |
| Duration | 400ms |
| Curve | `Curves.easeOutCubic` |
| Visual | The sheet's content (score, stars, buttons) fades in with a staggered delay: header (0ms), score (100ms), stars (200ms), buttons (300ms). |

**Back navigation (pop):**

| Property | Value |
|----------|-------|
| Type | Standard pop transition |
| Duration | 250ms |
| Curve | `Curves.easeIn` |
| Haptic | `HapticsService.lightTap()` on back button press |

### 6.8 Card Hover / Focus Glow (Unplayed Games)

**Applies to:** `GameCard` widgets where `timesPlayed == 0`.

| Property | Value |
|----------|-------|
| Animation | Pulsing border glow |
| Duration | 2000ms per cycle, infinite repeat with reverse |
| Border glow opacity | 0.1 -> 0.35 -> 0.1 |
| Color | Game accent color |
| Blur radius | 8dp |
| Spread radius | 1dp |

This draws the player's attention to games they have not tried yet, without
being aggressive or distracting.

### 6.9 Streak Counter Fire Effect

**Applies to:** Streak displays in all games when streak >= 3.

| Property | Value |
|----------|-------|
| Trigger | `streak >= 3` |
| Visual | Small flame emoji or fire icon appears next to streak number, with a subtle wiggle animation. |
| Wiggle | Rotation -3deg to +3deg, 400ms, `Curves.easeInOut`, infinite with reverse. |
| Scale | Streak text scales up from 1.0 -> 1.1 on increment (200ms, easeOutBack) then returns. |
| Color | Text transitions from `DragonColors.textPrimary` to `DragonColors.fireOrange` when streak >= 3, using `ColorTween` over 300ms. |

### 6.10 Achievement Popup Animation

**Applies to:** `AchievementPopupOverlay` (already exists).

Current implementation: slide-down banner, 500ms easeOutBack, 2s hold.

**Enhanced spec:**

| Property | Value |
|----------|-------|
| Entrance | Slide down from top: -80dp -> 0dp, 500ms, `Curves.easeOutBack` |
| Hold | 2500ms (increased from 2000ms for readability) |
| Exit | Slide up: 0dp -> -80dp, 300ms, `Curves.easeIn` |
| Icon | Achievement-specific icon with a brief rotation (0 -> 360deg, 600ms, easeOutCubic) on entrance |
| Haptic | `HapticsService.celebration()` on entrance |
| Gold particles | 6-8 tiny gold squares burst outward from the icon, fading over 400ms |
| Sequential queue | Already implemented — maintain 300ms gap between consecutive popups |

### 6.11 Daily Challenge Task Completion

**Applies to:** `DailyChallengeCard` task checkboxes.

| Property | Value |
|----------|-------|
| Trigger | Task completed |
| Checkbox | Scales from 0 -> 1.2 -> 1.0 (300ms, easeOutBack) |
| Checkmark color | `DragonColors.emeraldFlame` |
| Strikethrough | Task text gets a strikethrough that animates from left to right (200ms, linear) |
| Task row | Brief green flash on the row background (150ms, fade out) |
| Haptic | `HapticsService.mediumTap()` |
| All complete | When all tasks done: entire card border flashes gold (400ms), "Complete!" text scales up with confetti-like particle burst |

### 6.12 Pull-to-Refresh

**Applies to:** Not currently applicable. The hub screen uses a
`SingleChildScrollView`, not a list that fetches remote data. If cloud sync
pull-to-refresh is added:

| Property | Value |
|----------|-------|
| Indicator | `RefreshIndicator` with `color: DragonColors.dragonGold` |
| Background | `DragonColors.nightSurface` |
| Displacement | 48dp |
| Stroke width | 3dp |

---

## Summary: Implementation Priority

Recommended implementation order within this step:

| Priority | Item | Effort | Impact |
|----------|------|--------|--------|
| 1 | `TutorialService` (Hive flags) | Low | Foundation for all tutorials |
| 2 | `DragonDialogue` widget | Low | Reused by every tutorial |
| 3 | Hub tutorial (4 steps) | Medium | First-launch experience |
| 4 | `TapScaleWrapper` + button feedback | Low | Instant polish across all screens |
| 5 | `AnimatedScoreCounter` | Low | Used in all games |
| 6 | `AnimatedStarRating` | Low | Used in results and cards |
| 7 | Game tutorials (4 games) | Medium | New player retention |
| 8 | `SplashGate` animated splash | Low | Professional first impression |
| 9 | `flutter_native_splash` setup | Low | Eliminates white flash on cold start |
| 10 | Empty states | Low | Polish for first-time screens |
| 11 | `AnimatedProgressBar` with shimmer | Medium | Visual polish |
| 12 | Navigation transitions | Medium | Screen-to-screen flow |
| 13 | Game loading states | Low | Covers Flame init time |
| 14 | Streak fire effect | Low | Engagement feedback |
| 15 | Enhanced achievement popup | Low | Reward celebration |

**Total estimated effort:** 3-4 days of focused development.

---

## File Structure

```
lib/
  tutorial/
    tutorial_service.dart          # Hive-backed first-play detection
    tutorial_step.dart             # TutorialStep data model
    dragon_dialogue.dart           # Reusable dragon speech bubble widget
    tutorial_overlay.dart          # Hub/Flutter screen tutorial overlay
    game_tutorial_overlay.dart     # Flame overlay for in-game tutorials
    hub_tutorial.dart              # Hub tutorial steps definition
    dragon_runes_tutorial.dart     # Dragon Runes tutorial steps
    fire_trail_tutorial.dart       # Fire Trail tutorial steps
    dragon_eggs_tutorial.dart      # Dragon Eggs tutorial steps
    dragons_feast_tutorial.dart    # Dragon's Feast tutorial steps
  widgets/
    tap_scale_wrapper.dart         # Reusable press-scale feedback
    animated_score_counter.dart    # Tick-up score display
    animated_star_rating.dart      # Stagger-fill star display
    animated_progress_bar.dart     # Shimmer progress bar
    empty_state.dart               # Reusable empty state template
    splash_gate.dart               # Animated splash screen
```

---

## Sources

- [Adrian Crook & Associates: Best Practices For Mobile Game Onboarding](https://adriancrook.com/best-practices-for-mobile-game-onboarding/)
- [Apple Developer: Onboarding for Games](https://developer.apple.com/app-store/onboarding-for-games/)
- [Apple Developer: Human Interface Guidelines - Onboarding](https://developer.apple.com/design/human-interface-guidelines/onboarding)
- [UserGuiding: 6 Takeaways from Video Game Onboarding for UX](https://userguiding.com/blog/video-game-onboarding)
- [Acagamic: 5 Proven Game Onboarding Techniques](https://acagamic.com/newsletter/2023/04/04/dont-spook-the-newbies-unveiling-5-proven-game-onboarding-techniques/)
- [Gapsy: UX Design for Kids - The Ultimate Guide](https://gapsystudio.com/blog/ux-design-for-kids/)
- [Flame Engine: Overlays Documentation](https://docs.flame-engine.org/latest/flame/overlays.html)
- [Flame Engine: Game Loading Builder](https://medium.com/@dhanish_9850/making-games-load-better-with-flutter-flames-loading-builder-abfdc05a3ce8)
- [pub.dev: tutorial_coach_mark](https://pub.dev/packages/tutorial_coach_mark)
- [pub.dev: showcaseview](https://pub.dev/packages/showcaseview)
- [pub.dev: flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [Flutter Gems: Feature Discovery & Coach Marks Packages](https://fluttergems.dev/feature-discovery-coach-marks/)
- [Material Design: Empty States](https://m2.material.io/design/communication/empty-states.html)
- [Mobbin: Empty State UI Pattern](https://mobbin.com/glossary/empty-state)
- [Medium: Micro-Interactions in Flutter](https://kymoraa.medium.com/micro-interactions-in-flutter-be72e451e513)
- [Medium: Mastering Flutter Animations](https://medium.com/@tiger.chirag/hidden-choreography-in-flutter-f49c5298d914)
- [Flutter Docs: Hero Animations](https://docs.flutter.dev/ui/animations/hero-animations)
- [NN/g: Onboarding Tutorials vs. Contextual Help](https://www.nngroup.com/articles/onboarding-tutorials/)
- [VWO: Mobile App Onboarding Guide 2026](https://vwo.com/blog/mobile-app-onboarding-guide/)
