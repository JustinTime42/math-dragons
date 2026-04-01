# Math Dragons: Mobile App Planning Document

> A dragon-themed mobile game app packaging a collection of legitimately fun math games
> into a cohesive, rewarding experience with progression, monetization, and future
> world-building features.

---

## Table of Contents

1. [Existing Game Inventory](#1-existing-game-inventory)
2. [Vision & Theme](#2-vision--theme)
3. [Key Decisions](#3-key-decisions)
4. [Framework: Flutter](#4-framework-flutter)
5. [App Architecture & Extensibility](#5-app-architecture--extensibility)
6. [Cloud Backend & Offline-First Architecture](#6-cloud-backend--offline-first-architecture)
7. [Game Adaptations for Dragon Theme](#7-game-adaptations-for-dragon-theme)
8. [Adaptive Difficulty Engine](#8-adaptive-difficulty-engine)
9. [Progression, Levels & Reward System](#9-progression-levels--reward-system)
10. [Monetization Strategy](#10-monetization-strategy)
11. [App Store Publishing (Android-First)](#11-app-store-publishing-android-first)
12. [Legal & Compliance (COPPA / Kids)](#12-legal--compliance-coppa--kids)
13. [Art & UI Direction](#13-art--ui-direction)
14. [Localization Architecture](#14-localization-architecture)
15. [Beta Testing Plan](#15-beta-testing-plan)
16. [v1 Scope vs v2 Roadmap](#16-v1-scope-vs-v2-roadmap)
17. [Remaining Open Questions](#17-remaining-open-questions)
18. [Risks & Mitigations](#18-risks--mitigations)
19. [Development Phases](#19-development-phases)

---

## 1. Existing Game Inventory

Five games exist in the repository, all built with HTML5 Canvas and vanilla JavaScript:

### 1.1 Number Links (`numberLinks.html`)
- **Math Concepts:** Equation building/validation, all four operations, order of
  operations
- **Gameplay:** Drag across circular nodes to chain numbers and operators into valid
  equations (e.g., `3 + 2 = 5`). Level-based progression with increasing difficulty.
- **Notable Features:** 99+ levels, configurable operations, hint system (3/level),
  streak bonuses, particle effects, persistent high score
- **Difficulty Curve:** Starts with addition 1-5, scales to 3 number families with
  range 2-15 and all operations

### 1.2 Math Snake (`snakeGame.html`)
- **Math Concepts:** Mental arithmetic under time pressure, all four operations
- **Gameplay:** Classic snake movement on a 21x21 grid. A math problem displays as a
  watermark; answer tiles are scattered on the board. Eat the correct answer to score.
  Wrong answers cost lives and grow the snake.
- **Notable Features:** Configurable speed (3-20 steps/sec), adjustable number ranges,
  operation toggles, 5-life system, wrap mode toggle, touch d-pad for mobile
- **Difficulty Curve:** Player-configured via settings (number range, operations, speed)

### 1.3 Bubble Pop (`BubblePop/bubble-pop.html`)
- **Math Concepts:** Equation assembly from physics-based falling bubbles (+, -, x).
  **Division will be added at higher levels for Math Dragons.**
- **Gameplay:** Bubbles (numbers and operators) fall with gravity and physics. Tap 4
  bubbles in sequence to form `left op right = answer`, then submit. Real physics with
  collision, bounce, and settling.
- **Notable Features:** 6 difficulty tiers, combo system with multiplier, adaptive
  difficulty via spaced repetition (tracks per-fact accuracy), "new fact" badges,
  persistent fact history, ambient particle effects
- **Difficulty Curve:** Auto-levels every 10 correct answers. Level 1: add 1-5.
  Level 6: all ops 2-12 at 1.4x speed.

### 1.4 Moose Muncher (`MooseMuncher/`) & Super Moose Man (`SuperMooseMan/`)
- **Math Concepts:** Category identification, number properties (multiples, primes,
  even/odd, perfect squares)
- **Gameplay:** Navigate a 5x5 grid, eat tiles matching the current category while
  avoiding enemies. Pac-Man meets Number Munchers.
- **Notable Features:** Enemy AI with freeze power-ups, predicate-based numeric
  categories, dynamic category loading, responsive canvas
- **For Math Dragons:** These two will be **merged into a single game** ("Dragon's
  Feast") using SuperMooseMan's architecture as the base. **Math categories only** --
  word categories will be dropped to keep the math brand clean. Plenty of rich math
  categories available: multiples (of 2-12), primes, composites, even/odd, perfect
  squares, factors of N, numbers greater/less than N, etc.

### Math Skills Coverage

| Skill | Dragon Runes | Fire Trail | Dragon Eggs | Dragon's Feast |
|---|:---:|:---:|:---:|:---:|
| Addition | x | x | x | |
| Subtraction | x | x | x | |
| Multiplication | x | x | x | |
| Division | x | x | x (higher levels) | |
| Equation Building | x | | x | |
| Mental Math Speed | | x | | |
| Number Properties | | | | x |
| Categorization | | | | x |

---

## 2. Vision & Theme

### Core Identity
**"Math Dragons"** -- a collection of genuinely fun math games wrapped in a whimsical
dragon fantasy world. Not edutainment that's secretly boring. Real games with real fun
that happen to sharpen math skills.

**Target Audience:** Ages 7+ (content spanning ages 7-14 in difficulty)

### Dragon Theme Direction
- **Art Style:** Stylized semi-realistic cartoon. Think Wings of Fire book covers meets
  Clash Royale character design. Detailed enough for teens/adults, expressive enough for
  younger players. NOT chibi/super-deformed baby dragons.
- **Color Palette:** Rich fantasy tones -- deep purples, warm golds, emerald greens,
  flame oranges. Each game has its own color accent within this palette.
- **Mascot/Guide:** A primary dragon companion that evolves visually as the player
  progresses (egg -> hatchling -> fledgling -> young dragon -> adult dragon -> elder
  dragon). This evolution is the long-term meta-progression hook.
- **World Flavor:** Each mini-game lives in a different region of the dragon's world
  (volcanic forge, crystal caves, sky islands, ancient ruins).

### Tone
- Whimsical but not silly
- Encouraging but not patronizing
- Fantasy adventure, not classroom

---

## 3. Key Decisions

Decisions locked in as of this planning session:

| Decision | Choice | Rationale |
|---|---|---|
| Framework | **Flutter** (Dart) | Flame engine, Casual Games Toolkit, Impeller renderer |
| Working Title | **Math Dragons** | Searchable, clear, memorable |
| Target Audience | **Ages 7+** (content spanning 7-14), **Kids Category** | Kids-only on both stores for discoverability and parent trust |
| Platform Priority | **Android first**, iOS later | No Mac currently available; Android has lower barrier |
| Cloud Backend | **Firebase** (Firestore + Auth) | Best offline sync, mature Flutter SDK |
| Auth Strategy | **Anonymous + optional upgrade** | Zero friction start; link Google/Apple account for backup |
| Offline Behavior | **Offline-first; cloud when available** | Everything playable without internet |
| Art Assets (v1) | **AI-generated** | Cost-effective for v1; professional art for later versions |
| Muncher Games | **Merge into one, math-only categories** | Clean brand, SuperMooseMan architecture as base |
| Division in Dragon Eggs | **Yes, at higher difficulty tiers** | Integer-result divisions only; added at level 5+ |
| Localization | **English only for v1**, architecture from day 1 | i18n wrappers on all strings from the start |
| Analytics | **Skip for v1** | Reduces COPPA complexity; add later if needed |
| Monetization | **Freemium + one-time unlock** | Kids-only, Apple Kids Category eligible, parent trust |

---

## 4. Framework: Flutter

### Why Flutter

1. **Flame Engine:** Open-source 2D game engine purpose-built for Flutter. Provides game
   loops, collision detection, sprite systems, particle effects, and input handling --
   exactly what these games need.
2. **Flutter Casual Games Toolkit:** Google's official toolkit for casual game apps,
   with templates for IAP, game services, and crash reporting.
3. **Impeller Rendering Engine:** Consistent 60/120 FPS with pixel-perfect consistency
   across platforms. No jank from shader compilation.
4. **Offline-First Firestore SDK:** Firebase's Flutter SDK has mature offline persistence
   built in -- critical for the offline-first requirement.
5. **Single Codebase:** When iOS is added later, it's the same codebase. No rewrite.

### Flutter + Flame Game Architecture

Each mini-game will be a Flame `FlameGame` component that can be embedded in a Flutter
widget tree. This allows:
- Game rendering handled by Flame (game loop, sprites, collision, particles)
- UI overlays (score, menus, settings) handled by Flutter widgets
- Seamless transitions between the Flutter hub and Flame games
- Shared services (rewards, storage) accessible from both layers

### Dart Learning Curve

Dart is syntactically similar to JavaScript/TypeScript. Key differences to learn:
- Strong typing (similar to TypeScript)
- `async`/`await` works the same way
- No prototypal inheritance; class-based like TypeScript
- Null safety is enforced (`?` and `!` operators, similar to TS strict mode)
- Package management via `pubspec.yaml` (similar to `package.json`)

Most JavaScript developers become productive in Dart within 1-2 weeks.

---

## 5. App Architecture & Extensibility

### Design Goal: Easy to Add New Games

The architecture must make adding a new game as simple as:
1. Create a new directory under `lib/games/new_game/`
2. Implement the `MathDragonsGame` interface
3. Register it in the game registry
4. It automatically appears in the hub, earns currency, tracks stats, and participates
   in the achievement/progression system

### Project Structure

```
math_dragons/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── game_registry.dart        # Game registration + discovery
│   │   ├── game_interface.dart       # Interface all games implement
│   │   ├── reward_service.dart       # Currency, achievements, events
│   │   ├── player_profile.dart       # User data model
│   │   ├── difficulty_engine.dart    # Adaptive difficulty (shared)
│   │   ├── fact_tracker.dart         # Per-fact accuracy tracking
│   │   ├── daily_challenge.dart      # Daily challenge generation
│   │   ├── haptics.dart              # Haptic feedback manager
│   │   └── session_manager.dart      # Session timing, "just one more" prompts
│   │
│   ├── storage/
│   │   ├── local_storage.dart        # SQLite / Hive local persistence
│   │   ├── cloud_sync.dart           # Firestore sync manager
│   │   ├── sync_resolver.dart        # Offline/online conflict resolution
│   │   └── migration.dart            # Schema versioning + migration
│   │
│   ├── auth/
│   │   ├── auth_service.dart         # Firebase Auth wrapper
│   │   ├── anonymous_auth.dart       # Auto anonymous sign-in
│   │   └── account_upgrade.dart      # Link Google/Apple account flow
│   │
│   ├── hub/
│   │   ├── hub_screen.dart           # Main dragon's lair launcher
│   │   ├── game_card.dart            # Per-game entry with progress
│   │   ├── profile_bar.dart          # Dragon evolution, currency display
│   │   ├── dragon_companion.dart     # Animated dragon in hub
│   │   ├── daily_challenge_card.dart # Today's challenge display
│   │   └── settings_screen.dart      # App-wide settings
│   │
│   ├── games/
│   │   ├── shared/
│   │   │   ├── game_shell.dart       # Shared wrapper (HUD, pause, rewards)
│   │   │   ├── math_problem.dart     # Problem generation utilities
│   │   │   ├── result_screen.dart    # Post-game results with rewards
│   │   │   └── difficulty_config.dart# Shared difficulty definitions
│   │   ├── dragon_runes/             # Number Links port
│   │   │   ├── dragon_runes_game.dart
│   │   │   ├── rune_node.dart
│   │   │   └── levels.dart
│   │   ├── fire_trail/               # Math Snake port
│   │   ├── dragon_eggs/              # Bubble Pop port
│   │   └── dragons_feast/            # Merged Muncher port
│   │
│   ├── monetization/
│   │   ├── iap_manager.dart          # RevenueCat integration
│   │   ├── store_screen.dart         # In-app store UI
│   │   └── parental_gate.dart        # Parental gate for purchases
│   │
│   ├── rewards/                      # v2: palace/world builder
│   │   └── placeholder.dart          # Interface stubs for future use
│   │
│   ├── l10n/                         # Localization
│   │   ├── app_en.arb                # English strings
│   │   └── l10n.dart                 # Generated localization delegates
│   │
│   └── theme/
│       ├── dragon_theme.dart         # App-wide styling, colors, typography
│       └── dragon_colors.dart        # Per-game color palettes
│
├── assets/
│   ├── images/
│   │   ├── dragons/                  # Dragon evolution sprites
│   │   ├── hub/                      # Hub environment art
│   │   ├── games/                    # Per-game themed assets
│   │   └── ui/                       # Buttons, frames, icons
│   ├── animations/                   # Rive or Lottie animation files
│   └── sounds/
│       ├── music/                    # Background tracks per game
│       ├── sfx/                      # Sound effects
│       └── dragon/                   # Dragon roars, fire, wings
│
├── test/
│   ├── core/
│   ├── games/
│   └── integration/
│
└── pubspec.yaml
```

### Game Interface (Extensibility Contract)

Every mini-game implements this interface. This is the contract that makes adding new
games trivial:

```dart
abstract class MathDragonsGame {
  // Identity
  String get gameId;
  String get displayName;
  String get description;
  String get iconAsset;
  String get environmentAsset;      // Hub scene object
  Color get accentColor;

  // Difficulty / Levels
  List<GameLevel> get levels;
  GameLevel currentLevel(PlayerGameStats stats);

  // Rewards
  RewardConfig get rewardConfig;    // base points, multipliers

  // Math skills this game teaches (for cross-game tracking)
  List<MathSkill> get mathSkills;

  // The actual game widget/component
  Widget buildGame(GameContext context);

  // Difficulty engine hook
  DifficultyProfile get difficultyProfile;
}

class RewardConfig {
  final int baseScalesPerCorrect;   // 1-3 depending on difficulty
  final int streakBonusCap;         // max bonus per streak
  final int levelCompletionBonus;   // bonus for finishing a level
  final int threeStarBonus;         // extra for perfect performance
}

class GameLevel {
  final int levelNumber;
  final String name;                // "Ember Equations", "Inferno Algebra"
  final DifficultyParams params;    // number ranges, operations, speed, etc.
  final int starsRequired;          // stars from previous levels to unlock
  final String worldTheme;          // visual theme for this level range
}
```

### Event Bus (Cross-Cutting Communication)

All games emit events through a shared event bus. This decouples games from the
reward system, cloud sync, achievements, and future features:

```dart
// Games emit these -- they don't need to know who's listening
GameStarted(gameId, levelNumber)
AnswerGiven(gameId, problem, playerAnswer, correct, responseTimeMs)
StreakAchieved(gameId, streakLength)
LevelCompleted(gameId, levelNumber, score, stars, accuracy)
GameEnded(gameId, finalScore, duration)

// Listeners handle them independently
RewardService       -> awards scales, checks achievements
FactTracker         -> updates per-fact accuracy data
DifficultyEngine    -> adjusts adaptive difficulty
CloudSync           -> queues for sync when online
DailyChallenge      -> checks daily challenge progress
// v2: PalaceBuilder -> awards building resources
```

Adding a new listener (like the v2 palace builder) requires zero changes to any game
code. Adding a new game requires zero changes to any listener code.

---

## 6. Cloud Backend & Offline-First Architecture

### Why Firebase (Firestore + Auth)

| Factor | Firebase/Firestore | Supabase |
|---|---|---|
| **Offline sync** | Built into Flutter SDK -- automatic | Requires PowerSync or custom solution |
| **Anonymous auth** | First-class support, upgrade to linked account seamlessly | Possible but less mature |
| **Google ecosystem** | Same project as auth/storage, familiar tooling | Separate systems |
| **Real-time listeners** | Excellent | Excellent |
| **Cost (early stage)** | Free tier: 50K reads, 20K writes/day | Free tier: 500MB, 50K MAU |
| **Vendor lock-in** | High (Google) | Low (open source, self-hostable) |
| **Complex queries** | Limited (no joins, limited filtering) | Full PostgreSQL |

**Recommendation: Firebase for v1.** The offline-first requirement is the deciding
factor -- Firestore's Flutter SDK handles offline caching, automatic sync on reconnect,
and conflict resolution out of the box. This is months of custom work with Supabase.

Supabase becomes more attractive for v2+ if you need complex queries (global
leaderboards, cross-player analytics, teacher dashboards). The player profile data
model works with either backend, so a migration path exists.

### Offline-First Data Flow

```
┌─────────────────────────────────────────────────┐
│                    App Layer                      │
│  Games → Event Bus → RewardService → ProfileUpdate│
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│              Local Storage (SQLite/Hive)          │
│  • Always written to first                        │
│  • Source of truth for gameplay                    │
│  • Full game functionality without internet       │
└─────────────────────┬───────────────────────────┘
                      │ (when online)
                      ▼
┌─────────────────────────────────────────────────┐
│              Cloud Sync (Firestore)               │
│  • Background sync when connectivity available    │
│  • Conflict resolution: latest timestamp wins     │
│  • Profile backup and cross-device restore        │
│  • Queued writes during offline periods           │
└─────────────────────────────────────────────────┘
```

**Key Principles:**
1. **Local storage is always written first.** The game never waits for a network call.
2. **Cloud sync is opportunistic.** Happens in the background when connectivity exists.
3. **No feature degrades without internet.** All games, progression, rewards, and
   achievements work fully offline. Only cloud backup and IAP require connectivity.
4. **Conflict resolution:** If the same profile is edited on two devices offline, the
   sync resolver uses a "latest write wins per field" strategy with a merge for
   additive data (achievements, fact history).

### Authentication Flow

```
First Launch
    │
    ▼
Anonymous Firebase Auth (automatic, invisible to user)
    │
    ▼
Assign local player profile + anonymous UID
    │
    ▼
Player uses app normally (all data stored locally + synced to Firestore under anon UID)
    │
    ▼
[Optional] Player taps "Back up your progress" in settings
    │
    ▼
Google Sign-in or Apple Sign-in
    │
    ▼
Firebase Auth links anonymous account to real account
    │
    ▼
All existing Firestore data transfers automatically (same UID)
    │
    ▼
Cross-device restore now available
```

**No sign-in wall.** Players are playing within seconds of first launch. The only
prompt to sign in is a gentle, non-blocking suggestion after they've invested time
(e.g., after reaching dragon evolution stage 2, show "Back up your dragon! Sign in
to save your progress across devices.").

### Firestore Data Model

```
users/{uid}/
  ├── profile          # PlayerProfile document
  ├── factHistory/     # Sub-collection of per-fact accuracy records
  ├── achievements/    # Sub-collection of unlocked achievements
  └── dailyChallenges/ # Sub-collection of daily challenge completions

// PlayerProfile document
{
  displayName: string,
  dragonName: string,
  dragonEvolution: int,            // 0=egg through 5=elder
  totalScales: int,
  totalCorrectAnswers: int,
  totalPlayTimeMinutes: int,
  createdAt: timestamp,
  lastPlayedAt: timestamp,
  gameStats: {
    dragon_runes: {
      currentLevel: int,
      highScore: int,
      totalStars: int,
      timesPlayed: int,
      bestStreak: int,
      accuracy: float,
      lastPlayed: timestamp,
    },
    fire_trail: { ... },
    dragon_eggs: { ... },
    dragons_feast: { ... },
  },
  inventory: [],                   // v1: empty, v2: palace items
  worldState: null,                // v1: null, v2: palace state
  dailyChallengeStreak: int,
  settings: {
    soundEnabled: bool,
    musicEnabled: bool,
    hapticsEnabled: bool,
    ageGroup: string,              // "under13" or "13plus"
  },
  schemaVersion: 1,
}
```

### Firestore Costs at Scale

At the free tier (Spark plan), you get 50K reads and 20K writes per day. For a
single-player game with background sync, this is more than sufficient for hundreds of
active users. If the app grows significantly, the Blaze (pay-as-you-go) plan costs:
- $0.06 per 100K reads
- $0.18 per 100K writes
- $0.02 per 100K deletes

A typical player session might generate 5-10 writes and 2-3 reads. Very cost-effective.

---

## 7. Game Adaptations for Dragon Theme

### 7.1 Number Links -> "Dragon Runes"
- **Theme:** Ancient dragon runes that must be connected to cast spells
- **Visual:** Rune stones in a circular formation, glowing magical connections,
  spell-casting effects on equation completion
- **Reward tie-in:** Each completed level "powers a spell" -- currency earned scales
  with level difficulty
- **Dragon connection:** Your dragon companion reacts to completed spells with
  animations (roars, breathes fire, spreads wings)
- **Haptics:** Light pulse on node selection; strong burst on successful equation

### 7.2 Math Snake -> "Fire Trail"
- **Theme:** A fire dragon leaving a trail of flame across the sky/ground
- **Visual:** Dragon head instead of snake, flame trail instead of body, answer tiles
  are treasure gems and crystals
- **Mechanic tweak:** Instead of "lives," your flame intensity shrinks on wrong answers.
  At zero flame, game over. Correct answers fuel your fire brighter.
- **Dragon connection:** Different flame colors and particle effects unlock as you
  level up (orange -> blue -> white -> prismatic)
- **Haptics:** Rhythmic pulse matching movement speed; sharp buzz on wrong answer

### 7.3 Bubble Pop -> "Dragon Eggs"
- **Theme:** Dragon eggs falling from nests above. Combine them to hatch equations.
- **Visual:** Colored eggs instead of bubbles with cracking/hatching animations on
  correct equations. Nest/cliff environment. Baby dragons fly away on success.
- **Mechanic tweak:** Correct equations hatch baby dragons (satisfying particle + flight
  animation). Combos hatch rarer dragon types. Wrong combos crack eggs with a sad puff
  of smoke.
- **Division addition:** At level 5+, division eggs appear. Only integer-result divisions
  are generated (e.g., 12 / 3 = 4, never 7 / 3). Division eggs have a distinct visual
  (different pattern/color) so players can identify them.
- **Dragon connection:** A "hatching counter" in the HUD shows total dragons hatched
- **Haptics:** Soft tap on egg selection; satisfying crunch on hatch; rumble on combo

### 7.4 Merged Muncher -> "Dragon's Feast"
- **Theme:** Your dragon is hungry and must feast on the correct items from a
  treasure hoard. Only items matching the current math property satisfy the dragon.
- **Visual:** Dragon character navigating a grid of numbered gems/treasures. Enemy
  creatures are rival dragons or treasure guardians.
- **Math categories (all math-only):**
  - Multiples of 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  - Prime numbers
  - Composite numbers
  - Even numbers / Odd numbers
  - Perfect squares
  - Factors of N (e.g., "Factors of 24")
  - Numbers greater than / less than N
  - Numbers in a range
- **Mechanic tweak:** Correct "meals" make your dragon glow with energy. Power-ups are
  dragon abilities (fire breath freezes enemies, wings let you fly over them,
  invulnerability shield).
- **Dragon connection:** Different math categories could visually change the treasure
  type (gems for primes, coins for multiples, crystals for squares)
- **Haptics:** Munch vibration on correct eat; warning buzz near enemies

### Cross-Game Consistency
- All games share the same dragon companion (visible in corner or as the player
  character depending on the game)
- Consistent UI chrome: top bar with scales counter, dragon evolution indicator,
  back-to-hub button
- Consistent reward animations: scales fly to counter, achievement popup banner
- Consistent sound design language across all games
- Shared result screen after each session: scales earned, facts practiced, streak info

---

## 8. Adaptive Difficulty Engine

This is a key differentiator. Most math game competitors either have static difficulty
or very basic level scaling. Math Dragons will have a genuinely intelligent system that
keeps players in the "zone of proximal development" -- challenged but not frustrated.

### Two Layers of Difficulty

**Layer 1: Level Progression (Visible to Player)**
Levels gate content progression and are the "macro" difficulty curve. Players see their
level, feel accomplishment advancing, and unlock new content. Levels are NOT adaptive --
they are fixed checkpoints that define what math content is available.

**Layer 2: Adaptive Fact Selection (Invisible to Player)**
Within any given level, which specific problems are presented is adaptive. The system
tracks accuracy on individual math facts and surfaces weaker ones more often. This is
the "micro" difficulty that ensures genuine learning.

### Fact Tracker System

Every math fact the player encounters is tracked:

```dart
class FactRecord {
  final String factKey;        // e.g., "7x8", "15-9", "prime:17"
  int timesPresented;
  int timesCorrect;
  double accuracy;             // timesCorrect / timesPresented
  int currentStreak;           // consecutive correct
  DateTime lastPresented;
  DateTime lastIncorrect;
  double averageResponseTimeMs;
  FactStatus status;           // new, learning, familiar, mastered
}

enum FactStatus {
  new_,        // Never seen (or seen < 3 times)
  learning,    // Seen 3+ times, accuracy < 70%
  familiar,    // Accuracy 70-89%
  mastered,    // Accuracy 90%+ with 5+ presentations
}
```

### Problem Selection Algorithm

When a game needs to generate a problem within the current level's parameters:

```
1. Determine the pool of eligible facts for this level
   (e.g., level 3 = addition/subtraction with numbers 1-10)

2. Categorize the pool:
   - "Needs Practice" bucket: facts with accuracy < 70% (weight: 40%)
   - "Reinforcing" bucket: facts with accuracy 70-89% (weight: 30%)
   - "Mastered" bucket: facts with accuracy 90%+ (weight: 15%)
   - "New" bucket: facts never presented (weight: 15%)

3. Weighted random selection from buckets
   → Player naturally sees harder facts more often
   → New facts are introduced at a steady pace
   → Mastered facts still appear occasionally (spaced repetition)

4. Spacing rules:
   - Don't repeat the exact same fact within 3 problems
   - If a fact was just answered incorrectly, re-present it within the next 5 problems
   - If a fact hasn't been seen in 7+ days, boost its selection weight
```

**Result:** Players organically get more practice on facts they struggle with, without
any visible "you got this wrong, try again" mechanics that feel punishing. They just
experience a game that always seems to have the right level of challenge.

### Level Advancement Criteria

Advancing to the next level requires demonstrating competence, not just playing enough:

```
Level Completion Requirements:
  - Minimum score threshold (varies by game)
  - Minimum accuracy: 60% (generous -- we want forward progress to feel achievable)
  - Minimum problems attempted: varies by level (ensures enough data)

Star Rating:
  ★☆☆  = Completed (met minimum requirements)
  ★★☆  = Good (75%+ accuracy AND score above median threshold)
  ★★★  = Excellent (90%+ accuracy AND score above high threshold)

Level Unlocking:
  - Next level unlocks at 1 star on current level
  - Some "bonus" levels require 2+ stars on previous levels
  - No hard gates that prevent forward progress for too long
```

### Balancing Fun vs. Education

**The Cardinal Rule:** Fun comes first. If the adaptive difficulty makes the game
feel like a chore, it's doing harm.

Specific guardrails:
- **Never interrupt flow for drill.** The adaptive system influences problem selection,
  but never pauses the game, adds extra rounds, or forces remediation.
- **Wrong answers aren't punished harshly.** Lose a life/flame/point, but the game
  continues. The adaptive system silently notes it and schedules practice.
- **Streaks are celebrated, not expected.** Streak bonuses are a fun extra, not a
  requirement for progress.
- **"Needs Practice" never exceeds 40% of problems.** Even if the player is struggling
  with many facts, no more than 40% of problems in a session are from the weak pool.
  The rest are things they can succeed at, maintaining confidence.
- **Sessions are short.** 2-5 minutes per round. Better to have a player do three
  fun 3-minute sessions than one tedious 10-minute session.
- **Mastery thresholds are achievable.** 90% accuracy for "mastered" means getting
  9 out of 10 right, not 99 out of 100. Realistic and encouraging.

---

## 9. Progression, Levels & Reward System

### Level Structure Per Game

Each game has **Worlds** (themed difficulty tiers) containing **Levels** (individual
challenges):

```
Dragon Runes (Number Links):
  World 1: "Ember Equations" (Levels 1-10)
    - Addition only, numbers 1-5
    - 2 number families per puzzle
  World 2: "Flame Formulas" (Levels 11-20)
    - Addition + subtraction, numbers 1-10
    - 2-3 number families
  World 3: "Inferno Algebra" (Levels 21-35)
    - Add + sub + multiplication, numbers 1-12
    - 3 number families, more nodes
  World 4: "Dragon's Calculus" (Levels 36-50)
    - All four operations, numbers 2-15
    - 3 number families, complex layouts
  World 5: "Elder Runes" (Levels 51+)
    - All ops, expanded ranges, bonus challenges

Fire Trail (Math Snake):
  World 1: "First Flight" (Levels 1-8)
    - Addition only, slow speed, small grid
  World 2: "Thermal Currents" (Levels 9-16)
    - Add + subtract, medium speed
  World 3: "Firestorm" (Levels 17-24)
    - Add + sub + multiply, faster
  World 4: "Inferno" (Levels 25-32)
    - All operations, fast, larger grid
  World 5: "Dragon Master" (Levels 33+)
    - Maximum difficulty, wrap mode

Dragon Eggs (Bubble Pop):
  World 1: "Nest of Addition" (Levels 1-10)
    - Addition 1-5, slow falling
  World 2: "Cracking Subtraction" (Levels 11-20)
    - Add + subtract 1-10
  World 3: "Multiplication Roost" (Levels 21-30)
    - Add + sub + multiply 2-10
  World 4: "Division Den" (Levels 31-40)
    - All operations including division (integers only)
  World 5: "Ancient Hatchery" (Levels 41+)
    - All ops 2-12, fast falling, complex combos

Dragon's Feast (Muncher):
  World 1: "Easy Pickings" (Levels 1-8)
    - Even/odd, multiples of 2 and 5
  World 2: "Growing Appetite" (Levels 9-16)
    - Multiples of 3, 4, 6
  World 3: "Refined Palate" (Levels 17-24)
    - Primes, composites, perfect squares
  World 4: "Gourmet Dragon" (Levels 25-32)
    - Factors of N, multiples of 7-12
  World 5: "Dragon King's Feast" (Levels 33+)
    - Mixed categories, faster enemies, harder numbers
```

### Dragon Scales Currency

**Earning Rates:**

| Action | Scales Earned |
|---|---|
| Correct answer (base) | 1-3 (scales with level difficulty) |
| Streak bonus (+1 per consecutive, cap +5) | 1-5 |
| Level completion | 10-30 (scales with level number) |
| 3-star completion | +15 bonus |
| First time playing a new game | 50 (one-time, encourages trying all games) |
| Daily challenge completion | 25 |
| Daily challenge streak bonus | +5 per consecutive day (caps at +25) |
| Bonus play session (3+ sessions/day) | 10 |

**Spending (v1):**
- Dragon name customization: free (just a text field)
- Dragon color variants: 50-200 scales each
- Dragon accessory items (hat, scarf, etc.): 100-500 scales each
- "Coming Soon: Dragon's Lair" teaser (no purchase, just builds anticipation)

**Spending (v2):**
- Palace rooms: 500-2000 scales
- Decorations: 100-1000 scales
- Premium dragon cosmetics: 200-1500 scales

**Pacing Target:** A typical play session (15-20 minutes, playing 3-4 rounds across
games) should earn roughly 100-200 scales. Dragon color variants (the main v1 spend)
should be achievable within 1-3 sessions, so players feel the currency is meaningful
quickly.

### Dragon Evolution (Meta-Progression)

The dragon companion evolves based on aggregate achievement across ALL games. This
is the primary reason to play multiple games instead of just grinding one.

```
Stage 0: Egg
  Requirement: None (starting state)
  Visual: A glowing, pulsing dragon egg

Stage 1: Hatchling
  Requirements:
    - Complete level 3 in any one game
    - Earn 100 total scales
  Visual: Tiny dragon, big eyes, stubby wings
  Designed to unlock FAST (within first 20-30 min of play)

Stage 2: Fledgling
  Requirements:
    - Reach level 8 in at least 2 different games
    - Earn 750 total scales
    - Unlock 5 achievements
  Visual: Slightly larger, wings starting to form, small flame

Stage 3: Young Dragon
  Requirements:
    - Reach level 15 in at least 3 different games
    - Earn 3,000 total scales
    - Unlock 15 achievements
    - 3-star at least 10 levels (any game)
  Visual: Recognizable dragon form, can fly, breathes fire

Stage 4: Adult Dragon
  Requirements:
    - Reach level 25 in all 4 games
    - Earn 10,000 total scales
    - Unlock 30 achievements
    - 3-star at least 30 levels (any game)
    - Complete 10 daily challenges
  Visual: Full majestic dragon, detailed scales, powerful presence

Stage 5: Elder Dragon
  Requirements:
    - Reach level 35 in all 4 games
    - Earn 25,000 total scales
    - Unlock 50 achievements
    - 3-star at least 60 levels (any game)
    - 30-day daily challenge streak
    - Master 100 math facts (90%+ accuracy)
  Visual: Ancient, wise dragon with glowing runes on scales, crown-like horns
```

**Design Philosophy:**
- **Stage 1 is fast.** Hook the player immediately with visible progress.
- **Stage 2 forces trying a second game.** Gentle push toward variety.
- **Stage 3 requires 3 games.** By now, the habit of variety is forming.
- **Stages 4-5 are aspirational.** Players work toward them over weeks/months.
  These are badges of genuine accomplishment.
- **Each stage unlocks new visual features** that are visible in all games and the hub.
  Social proof (if/when social features arrive in v2).

### Achievement System

Three categories of achievements:

**Per-Game Achievements (example: Dragon Runes):**
- "First Rune" -- Complete your first level
- "Rune Caster" -- Complete 10 levels
- "Rune Master" -- Complete 25 levels
- "Perfect Spell" -- 3-star a level with 100% accuracy
- "Chain Lightning" -- Build a 10-streak
- "Speed Caster" -- Complete a level in under 60 seconds
- (Similar set for each game, ~8-10 per game)

**Cross-Game Achievements:**
- "Dragon Explorer" -- Play all 4 games in one day
- "Well-Rounded" -- Earn scales in 3 different games in one session
- "Variety Pack" -- Reach level 5 in all 4 games
- "Math Olympian" -- 3-star a level in every game
- "Daily Devotion" -- Complete 7 daily challenges in a row

**Milestone Achievements:**
- "Century" -- Answer 100 problems correctly
- "Thousand Strong" -- Answer 1,000 problems correctly
- "Fact Finder" -- Master (90%+) 25 math facts
- "Times Table Titan" -- Master all multiplication facts 1-12
- "Scale Collector" -- Earn 5,000 total scales
- "Dragon Raiser" -- Reach dragon evolution stage 3

Each achievement awards a bonus of 25-100 scales and a badge displayed in the profile.

### Daily Challenge System (v1 Light)

**v1 Implementation (Architecture Present, Feature Lightweight):**

A daily challenge is generated deterministically from the date (so it's the same for
all players, enabling potential future leaderboards):

```dart
class DailyChallenge {
  final DateTime date;
  final List<ChallengeTask> tasks;  // 2-3 tasks per day
  final int bonusScales;            // 25 base + streak bonus
}

class ChallengeTask {
  final String gameId;
  final String description;         // "Score 300+ in Fire Trail"
  final bool Function(GameResult) isComplete;
}
```

**Example Daily Challenges:**
- "Score 200 in Dragon Runes + Eat 15 correct items in Dragon's Feast"
- "Complete 2 levels of Dragon Eggs + Get a 5-streak in Fire Trail"
- "Play 3 different games today"

**v1 keeps it simple:** Generate from a pool of template challenges, track completion
locally, display streak count in hub. The architecture supports v2 expansion into
seasonal challenges, friend challenges, and competitive daily leaderboards.

### Session Design ("Just One More")

**Target Session Length:** 2-5 minutes per round.

**"Just One More" Hooks:**
- After a round ends, show results with a large "Play Again" button and a smaller
  "Back to Hub" button. Default action is to play again.
- If the player just missed a personal best or level completion, show encouraging copy:
  "So close! Just 2 more correct answers to clear this level."
- After 3 sessions in the same game, gently suggest another game: "Your dragon is hungry!
  Try Dragon's Feast for bonus scales."
- Never force a game switch. Always let the player play what they want.

**Session Bookends:**
- **Start:** Quick (< 3 seconds from tap to gameplay). No loading screens, no
  tutorials on replay. Tutorials only on first play of each game.
- **End:** Satisfying result screen with scales raining into counter, streak
  celebration, achievement popups. Then immediately: "Play Again" or "Back to Hub."

---

## 10. Monetization Strategy

### Model: Freemium + One-Time Unlock

This approach enables listing in **Apple's Kids Category** and **Google Play's
Families program** (children-only target) without any compliance friction. Clean
dependency tree means simpler privacy policy and straightforward compliance.

### Free Tier vs Premium

**Free tier (unlimited, no time limits):**
- 2 full games: Dragon Runes + Fire Trail
- First 2 worlds per game (~10-16 levels each)
- Dragon companion with first 2 evolution stages (Egg → Hatchling)
- Basic dragon color customization (3 colors)
- Daily challenges (limited to free games)
- Full adaptive difficulty and fact tracking

**Premium unlock (one-time purchase):**
- All 4 games: + Dragon Eggs + Dragon's Feast
- All 5 worlds per game (full level progression)
- All 6 dragon evolution stages
- All dragon cosmetics (colors, accessories)
- All daily challenge types
- 500 bonus Dragon Scales on purchase
- Exclusive "Fire Dragon" color variant

**The free tier must be genuinely fun and complete-feeling.** Two full games with
20+ levels is a real experience, not a demo. The goal is for kids to love the free
games and for parents to see the educational value before the child naturally wants
to unlock Dragon Eggs and Dragon's Feast.

### In-App Purchases

**SDK: RevenueCat** (Flutter SDK: `purchases_flutter`)

**v1 Products:**

| Product | Type | Price | Description |
|---|---|---|---|
| Dragon Pack (Full Unlock) | One-time (non-consumable) | $4.99 | Unlock all games, all levels, all evolution stages, all cosmetics + 500 scales + exclusive fire dragon color |
| Scale Pouch | Consumable | $0.99 | 200 Dragon Scales |
| Scale Hoard | Consumable | $2.99 | 750 Dragon Scales |

**Purchase Safeguards:**
- Parental gate before any purchase (multiplication problem a young child can't solve:
  "What is 23 x 17?")
- Clear pricing displayed before payment flow
- No dark patterns or misleading "limited time" pressure
- Consumable scales are never required -- everything is earnable through gameplay
- Family Sharing enabled so one purchase covers all family devices

**v2 Purchase Expansion:**
- Premium dragon skins/evolutions
- Palace decoration packs
- New game unlocks (if premium games are added beyond the original 4)

### Revenue Projections

Assuming $4.99 one-time unlock:
- At 5% conversion (typical for well-made freemium kids apps): 1,000 installs = ~$250
- At 10% conversion (strong product-market fit): 1,000 installs = ~$500
- Scale packs provide supplemental revenue from engaged players
- No recurring costs (no subscription infrastructure)

### Beta Tester Rewards — Lifetime Premium Access

All beta testers (iOS TestFlight and Google Play) who help test before public
launch will receive free lifetime access to all current and future premium
features.

**Primary method: RevenueCat promotional entitlements**
- Once RevenueCat is integrated, grant each tester the premium entitlement
  directly via the RevenueCat dashboard
- Works cross-platform (iOS and Android) and persists across reinstalls
- Testers are identified by their RevenueCat app user ID
- Maintain a list of tester emails/IDs to ensure all are granted access

**Fallback method: In-app promo code**
- Build a hidden input in settings (behind the parental gate) that accepts a
  promo code and unlocks premium permanently
- Store the unlock flag in local storage (same as a regular purchase)
- Useful for edge cases where RevenueCat entitlements aren't practical
- Code can be shared directly with testers

### Why Not Subscriptions or Paid Upfront

| Model | Rejected because |
|---|---|
| **Subscription** | Subscription fatigue — parents already pay for multiple kid app subscriptions; a game (vs. learning platform) is a harder subscription sell; higher churn than one-time purchase |
| **Paid upfront** | Much smaller install base; no way for kids to try before parents buy; harder to get organic growth |

---

## 11. App Store Publishing (Android-First)

### Launch Strategy

**Phase 1: Google Play (Primary Launch)**
Android first, since no Mac is currently available for iOS builds.

**Phase 2: iOS (When Mac Access is Available)**
The Flutter codebase will be identical. iOS launch requires:
- A Mac (Mac Mini $599+, or cloud Mac service)
- Apple Developer account ($99/year)
- Xcode installed
- App Store Connect configuration
- Separate app review process

### Google Play Store

| Item | Details |
|---|---|
| **Developer Account** | $25 one-time fee |
| **Commission** | 15% on first $1M/year |
| **Review Timeline** | 1-7 days (longer for new accounts) |
| **Target API** | Android 15 (API 35) as of Aug 2025 |
| **App Format** | Android App Bundle (AAB) required |

**Steps to Publish:**
1. Create Google Play Developer account ($25)
2. Complete identity verification (legal name, address, phone)
3. Create app listing:
   - App title: "Math Dragons"
   - Short description (80 chars): "Dragon-powered math games that are actually fun!"
   - Full description (4000 chars): Describe all 4 games, features, age range
   - Feature graphic (1024x500)
   - App icon (512x512)
   - Screenshots: at least 2, ideally 6-8 showing all games + hub
   - Privacy policy URL
4. Complete IARC content rating questionnaire
   - Likely rating: **Everyone** or **Everyone 10+**
5. Configure pricing: Free (with IAP)
6. Set up IAP products in Google Play Console
7. Complete Families program declaration (target audience: children only)
8. Upload signed AAB
9. Submit for review
10. Set up closed beta track first (see [Beta Testing](#15-beta-testing-plan))

**Common Rejection Reasons to Avoid:**
1. Crashes on popular devices (test on 3+ real devices)
2. Missing privacy policy or incomplete Families declaration
3. Unapproved SDKs in a children-only app (ensure no unapproved SDKs are bundled)
4. Screenshots that don't match actual app
5. IAP that doesn't clearly display pricing or lacks parental gate

### Future iOS Publishing

When Mac access is available, the iOS process adds:
- Apple Developer account ($99/year)
- Enroll in Small Business Program (15% commission vs 30%)
- Create app in App Store Connect
- iOS-specific screenshots (6.7" and 5.5" displays required)
- Review tends to be stricter than Google Play -- extra attention to:
  - Privacy nutrition labels (detailed data collection disclosure)
  - Kids Category listing (strict rules: no external links, no tracking)
  - Parental gate implementation for IAP

### Things You Need

1. **Privacy Policy.** Required by both stores. Must be hosted at a public URL and
   accessible from within the app. Needs to cover: data collected (local gameplay
   stats only), Firebase usage (anonymous profile backup), children's data, COPPA
   compliance. Already written and hosted at `apps.routeworks.app/math-dragons/privacy`.

2. **App Icon.** Google requires 512x512. iOS will need 1024x1024. Should be a
   compelling dragon image that reads well at small sizes. AI-generate several options
   and pick the strongest.

3. **Screenshots.** Professional-looking screenshots significantly impact download rates.
   Show actual gameplay with the dragon theme. Consider adding text overlays highlighting
   features ("4 dragon-powered math games!", "Adaptive difficulty that grows with you").

4. **Feature Graphic (Google Play).** 1024x500 banner displayed at the top of your
   store listing. Dragon imagery with the app name.

5. **Testing Devices.** At minimum: one mid-range Android phone and one budget Android
   phone. Performance on a $150 phone is your quality floor.

6. **Tax Information.** Google requires tax setup for monetized apps. US developers:
   W-9 form. Revenue is taxable income.

---

## 12. Legal & Compliance (COPPA / Kids)

### Strategy: Kids-Only App, Both Platforms

The app targets **children only** on both stores:

- **Google Play:** Declare target audience as children only (ages 5-12) in the
  Families program. This triggers the strictest Families Policy requirements.
- **Apple App Store:** List in the **Kids Category**. This gives prime discoverability
  to parents searching for safe, educational apps.

### Implementation

1. **All users are treated as children.** No age gate, no bifurcated experience.
   Every user gets the same safe, COPPA-compliant experience.
2. **No data collection:** No analytics, no crash reporting, no third-party
   libraries that transmit data. All data stays on-device.
3. **Cloud backup (Firebase):** Anonymous auth + Firestore sync is permitted
   because it stores only gameplay data (not personal information). The sync
   is optional and initiated by the user via "Back up your progress."
4. **Parental gate for all IAP:** Multiplication problem gate (e.g., "23 x 17 = ?")
   before any purchase flow. Kids cannot accidentally make purchases.
5. **No external links in the app.** No links to websites, social media, or other
   apps that could lead children out of the safe app environment.
6. **No social features.** No chat, no friend lists, no user-generated content.

### COPPA Compliance Checklist

- [ ] No collection of personal information from children under 13
- [ ] No third-party SDKs that collect/transmit data (no analytics, no tracking)
- [ ] Parental gate on all purchase flows
- [ ] Privacy policy clearly describes data practices and children's protections
- [ ] No social features or user-to-user communication
- [ ] Firebase configured with child-directed treatment flags

### GDPR Considerations

Since both app stores are global by default:
- Include GDPR consent language in privacy policy
- For v1 (English-only, no analytics), GDPR exposure is minimal
- All data is either local-only or anonymous gameplay stats in Firestore
- No personally identifiable information is collected at any point
- If/when adding EU-specific features, may need explicit consent dialogs

---

## 13. Art & UI Direction

### v1 Art Strategy: AI-Generated Assets

For v1, AI-generated art is the cost-effective choice. Key considerations:

**Copyright Risk Mitigation:**
- Pure AI-generated images (simple prompt -> output) are NOT copyrightable in the US
- However, for a v1 launch this is acceptable risk -- the art can be replaced in later
  versions with commissioned human art if the app gains traction
- To strengthen your position: do substantial human editing/compositing of AI outputs,
  maintain a consistent style guide, and document your creative process
- Many published games already use AI-assisted art

**AI Art Workflow:**
1. **Style Bible:** Generate 20-30 dragon concepts in various styles to establish the
   exact aesthetic. Pick the best 3-5 as reference images.
2. **Character Sheet:** Generate the dragon companion at all 6 evolution stages using
   consistent style references. Edit for consistency.
3. **Environment Art:** Generate hub background, 4 game environments (volcanic forge,
   sky islands, crystal caves, ancient ruins)
4. **UI Elements:** Generate button styles, frames, borders, icons. These often need
   the most human editing to work as actual UI components.
5. **Game Assets:** Per-game themed elements (rune stones, eggs, gems, food items)

**Recommended Tools:**
- Midjourney or DALL-E 3 for initial concept generation
- Photoshop/GIMP/Figma for editing, compositing, and making game-ready assets
- Rive or Lottie for character animations (dragon companion idle, reactions, evolution
  transitions)

**Budget Estimate:** $0-200 (AI generation costs + editing time)

**v2+ Art Strategy:** If the app gains traction, commission a professional game artist
to create a cohesive, unique asset set. Budget $3,000-8,000.

### Art Style Reference

- **Color Palette:** Deep purple (#2D1B69), warm gold (#F4A261), emerald (#2A9D8F),
  flame orange (#E76F51), midnight blue (#1A1A2E)
- **Dragon Design:** Serpentine but sturdy, large expressive eyes, textured scales,
  wings with translucent membranes, varied horn/crest designs per evolution stage
- **Environment Feel:** Warm, inviting fantasy. Glowing crystals, ancient stonework,
  starlit skies. Not dark/scary -- magical and wondrous.

### Hub Screen Design

**"Dragon's Lair" Interactive Environment:**
- Scenic dragon lair/cave with warm lighting
- 4 game portals represented as interactive environment objects:
  - Glowing rune circle on the wall -> Dragon Runes
  - Flame trail leading to a tunnel -> Fire Trail
  - Nest with eggs on a high shelf -> Dragon Eggs
  - Treasure-laden feast table -> Dragon's Feast
- Dragon companion is center stage, animated (idle breathing, occasional wing stretch)
- Top bar: Dragon Scales counter, dragon evolution progress ring, settings gear
- Bottom bar: Daily Challenge card, profile/achievements button
- Tapping a game portal: dragon reacts (looks toward it, small animation) -> transition
  to game

### Haptic Feedback Design

| Event | Haptic Type | Intensity |
|---|---|---|
| Correct answer | Light impact | Subtle, satisfying |
| Wrong answer | Heavy impact | Brief sharp buzz |
| Streak milestone (5, 10) | Double tap | Celebratory |
| Level complete | Success pattern | Medium, positive |
| Dragon evolution | Long rumble | Momentous, special |
| Achievement unlocked | Triple tap | Attention-getting |
| Currency earned | Soft tick | Background reward feel |
| Egg hatch (Dragon Eggs) | Medium impact | Cracking sensation |
| Munch (Dragon's Feast) | Light impact | Quick nom |

All haptics are toggleable in settings.

---

## 14. Localization Architecture

### v1: English Only, Architecture Ready

Even though v1 is English-only, all user-facing strings go through Flutter's
localization system from day one:

**Implementation:**
- Use Flutter's official `intl` package with ARB (Application Resource Bundle) files
- All strings referenced via generated localization class:
  `AppLocalizations.of(context).levelComplete` instead of `"Level Complete!"`
- Plurals handled properly from the start:
  `AppLocalizations.of(context).scalesEarned(count)` -> "You earned 1 scale" / "You
  earned 5 scales"
- No hardcoded strings anywhere in the UI

**File Structure:**
```
lib/l10n/
  app_en.arb          # English (source of truth)
  # Future:
  # app_es.arb        # Spanish
  # app_fr.arb        # French
  # app_de.arb        # German
  # app_ja.arb        # Japanese
  # app_zh.arb        # Chinese
```

**Math-Specific Localization Notes:**
- Math symbols (+, -, x, /) are universal, but number formatting varies by locale
- Category names in Dragon's Feast ("Prime numbers", "Multiples of 5") need translation
- Dragon names and flavor text need translation
- Game instructions and tutorials need translation
- Store listing description needs separate localization per market

**Cost to Add a Language Later:** With the architecture in place, adding a new language
is primarily a translation task (~500-1000 strings). No code changes required.

---

## 15. Beta Testing Plan

### Google Play Internal/Closed Testing Track

Google Play supports multiple testing tracks before public launch:

1. **Internal Testing (Up to 100 testers)**
   - No review required -- available within minutes of upload
   - Use for initial QA and development testing
   - Testers join via email invitation

2. **Closed Testing (Up to 2,000 testers per track)**
   - Requires brief Google review
   - Create a "Beta" track for community testers
   - Testers can join via email list OR a join link you share

3. **Open Testing (Unlimited)**
   - App appears in Play Store marked as "Early Access"
   - Anyone can join
   - Use this only when confident in stability

### Recruitment & Feedback

**Discord Server:**
- Create a `#math-dragons-beta` channel
- Share the closed testing join link there
- Create a `#bug-reports` channel with a template:
  - Device model + Android version
  - What happened vs. what was expected
  - Steps to reproduce
  - Screenshot/screen recording
- Create a `#feature-requests` channel
- Create a `#general-feedback` channel

**Email List:**
- Alternative beta access for testers not on Discord
- Collect via a simple Google Form
- Send periodic update emails with new builds and what to test

**Key Things to Test With Beta Users:**
- Performance on various devices (especially budget phones)
- Difficulty curve: are levels 1-5 too easy/hard for target age range?
- Session length: do testers play for 2-5 min rounds as designed?
- Monetization feel: is the free-to-premium boundary fair? Does the unlock feel valuable?
- Dragon evolution pacing: does stage 1 unlock fast enough to feel rewarding?
- Touch controls: are all games comfortable on phone-sized screens?
- Art/theme: does the dragon aesthetic resonate across age groups?

### Beta Timeline

- **Alpha (Internal):** First 2-3 weeks of testing, developer + close friends only
- **Closed Beta:** 4-6 weeks, Discord community + email signups
- **Open Beta (optional):** 2-4 weeks if closed beta reveals issues needing broader
  testing
- **Launch:** After all critical bugs resolved and community feedback incorporated

---

## 16. v1 Scope vs v2 Roadmap

### v1: "Math Dragons" Launch

**In Scope:**
- [ ] Flutter project with Flame engine
- [ ] Hub/launcher screen (Dragon's Lair environment)
- [ ] 4 games ported and dragon-themed:
  - Dragon Runes (Number Links)
  - Fire Trail (Math Snake)
  - Dragon Eggs (Bubble Pop, with division at higher levels)
  - Dragon's Feast (merged Muncher, math categories only)
- [ ] Adaptive difficulty engine (fact tracking + weighted selection)
- [ ] Level/world progression per game (5 worlds, 8-15 levels each)
- [ ] Dragon companion with 6-stage evolution
- [ ] Dragon Scales currency (earn + spend on cosmetics)
- [ ] Achievement system (per-game + cross-game + milestone)
- [ ] Daily challenge system (lightweight, template-based)
- [ ] Haptic feedback (toggleable)
- [ ] "Just one more" session design (short rounds, easy replay)
- [ ] Firebase Auth (anonymous + optional Google sign-in upgrade)
- [ ] Firestore cloud backup (offline-first with background sync)
- [ ] RevenueCat IAP (Dragon Pack full unlock, scale packs)
- [ ] Freemium content gating (free: 2 games + 2 worlds; premium: all content)
- [ ] Parental IAP gate (multiplication problem)
- [ ] Localization architecture (all strings in ARB files)
- [ ] AI-generated art assets
- [ ] Royalty-free sound effects and music
- [ ] Privacy policy (hosted at apps.routeworks.app)
- [ ] Google Play Store launch (Families program, children-only)
- [ ] Apple App Store launch in Kids Category (when Mac available)
- [ ] Beta testing via Discord + email

**Out of Scope for v1 (but architecture supports):**
- Palace/world builder (v2)
- iOS build (pending Mac access)
- Additional games
- Social features / multiplayer
- Parental dashboard
- Season pass / battle pass
- Analytics
- Localized translations
- Custom commissioned art

### v2: "Dragon's Lair" Update

**Planned Features:**
- [ ] Dragon's Lair palace builder (earn resources from games, build rooms/decorations)
- [ ] Game-specific resource types (rune stones, fire gems, crystal shards, gold coins)
- [ ] Room/decoration catalog with functional benefits
- [ ] Expanded dragon cosmetics (premium + earnable)
- [ ] iOS launch (requires Mac)
- [ ] Apple Sign-in integration
- [ ] Additional math categories for Dragon's Feast

### v3+ Ideas
- New math games (fraction-based game, geometry puzzle, mental math race)
- Multiplayer math battles (PvP via Firebase)
- Parental dashboard (progress tracking, skill reports per child)
- Classroom/teacher mode (manage multiple students)
- Season system with rotating themes and exclusive rewards
- Global leaderboards (via Supabase for complex queries)
- Friend system (visit friend's lair, send gifts)
- Localization (Spanish, French, German as priority)

---

## 17. Remaining Open Questions

Most critical questions have been answered. These remain:

### Before Development

1. **Dart/Flutter Experience Level?**
   - How comfortable are you with Dart? Any Flutter experience?
   - If none, budget 1-2 weeks for Dart/Flutter learning before the game port begins
   - Recommend: Complete the Flutter Casual Games Toolkit codelab as a warm-up

2. **Development Pace?**
   - Full-time or side project?
   - Solo or with collaborators?
   - This significantly affects timeline estimates in [Phase 19](#19-development-phases)

3. **Budget Ceiling for v1?**
   - Fixed costs: Google Play ($25), testing devices ($150-400), privacy policy website
     (free on Vercel at apps.routeworks.app)
   - Variable costs: Royalty-free sound library subscription ($10-20/month),
     AI art generation credits ($20-50), RevenueCat (free tier covers first $2.5K/month)
   - Total minimum: ~$200-500 for a functional v1

### Before Launch

4. **Business Entity?**
   - Publishing as an individual or LLC?
   - LLC provides liability protection and looks more professional on the store
   - Affects tax filing and Apple Developer account type (when iOS launches)

5. **App Name Availability?**
   - "Math Dragons" needs to be checked on Google Play before committing
   - Also check for trademark conflicts (USPTO search)
   - Have 2-3 backup names ready

---

## 18. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Flutter/Dart learning curve | Development delays | Medium | Start with Flame tutorial + one game port as proof of concept |
| Game performance on budget Android | Bad reviews, uninstalls | Medium | Test early on a $150 phone; optimize rendering |
| AI art looks inconsistent | Unprofessional feel | Medium | Create strict style bible; edit all assets for consistency |
| COPPA violation | Legal liability, app removal | Low (no tracking) | No analytics, local-only data, parental gate on IAP, compliant privacy policy |
| Adaptive difficulty feels grindy | Player frustration, churn | Low-Medium | 40% cap on "needs practice" problems; short sessions; fun first |
| Google Play rejection | Delays launch | Medium | Follow Families policy exactly; test on real devices; complete privacy policy |
| Low conversion to paid | Revenue too low to sustain | Medium | Generous free tier hooks kids; clear value prop for parents; $4.99 price point is impulse-buy range |
| Firebase costs spike | Unexpected bills | Low | Monitor usage dashboard; free tier covers hundreds of DAU |
| Scope creep | Never ships | HIGH | v1 scope is locked. Palace builder = v2. iOS = when Mac available. Period. |
| Single developer bottleneck | Slow progress, burnout | Medium | Keep v1 scope tight; use pre-built solutions (Flame, RevenueCat, Firebase) |
| Competitor apps (Prodigy, DragonBox) | Lower market share | High | Differentiate on "genuinely fun games, not worksheets in disguise" |
| App name trademark conflict | Forced rename | Low | Search USPTO before committing to "Math Dragons" |

---

## 19. Development Phases

### Phase 0: Learning & Proof of Concept (2-3 weeks)
- [ ] Complete Flutter/Dart fundamentals (if needed)
- [ ] Complete Flame engine tutorial
- [ ] Complete Flutter Casual Games Toolkit codelab
- [ ] Set up development environment (Android Studio, Flutter SDK, emulator)
- [ ] Create project scaffold with Flame
- [ ] Port Dragon Eggs (Bubble Pop) as proof of concept -- most physics-heavy game,
      best stress test for the framework
- [ ] Test on a real Android device
- **Go/No-Go Decision:** Does Flame handle the physics and touch interactions
  acceptably? If not, evaluate alternatives before proceeding.

### Phase 1: Core Architecture & Game Ports (6-8 weeks)
- [ ] Implement game interface / registry pattern
- [ ] Implement event bus
- [ ] Implement player profile + local storage (SQLite/Hive)
- [ ] Build hub screen (placeholder art, functional navigation)
- [ ] Port remaining 3 games (Dragon Runes, Fire Trail, Dragon's Feast)
- [ ] Add division support to Dragon Eggs at higher levels
- [ ] Implement Dragon Scales currency earning
- [ ] Implement fact tracker + adaptive difficulty engine
- [ ] Set up level/world progression for all games
- [ ] Wire up localization architecture (all strings in ARB files)

### Phase 2: Firebase & Cloud (2-3 weeks)
- [ ] Set up Firebase project (Auth + Firestore)
- [ ] Implement anonymous auth with auto-sign-in
- [ ] Implement account upgrade flow (Google Sign-in)
- [ ] Implement offline-first local storage with Firestore background sync
- [ ] Implement conflict resolution for multi-device scenarios
- [ ] Test offline/online transitions thoroughly

### Phase 3: Dragon Theme & Polish (3-4 weeks)
- [ ] Generate AI art assets (dragon evolution stages, environments, game assets, UI)
- [ ] Apply dragon theme to all games and hub
- [ ] Implement dragon companion in hub (animated idle, reactions)
- [ ] Implement dragon evolution system with visual transitions
- [ ] Add haptic feedback throughout
- [ ] Add sound effects and background music (royalty-free)
- [ ] Implement achievement system
- [ ] Implement daily challenge (lightweight)
- [ ] Implement Dragon Scales spending (cosmetics)
- [ ] Polish animations and transitions
- [ ] Implement "just one more" session flow

### Phase 4: Monetization & Compliance (1-2 weeks)
- [ ] Integrate RevenueCat (purchases_flutter)
- [ ] Implement Dragon Pack full unlock ($4.99 non-consumable)
- [ ] Implement Scale Pouch ($0.99) and Scale Hoard ($2.99) consumables
- [ ] Implement freemium content gating (free: Dragon Runes + Fire Trail, first 2
      worlds each; premium: all 4 games, all worlds, all evolution stages, all cosmetics)
- [ ] Implement parental gate (multiplication problem before any purchase)
- [ ] Implement store screen showing IAP products with real prices
- [ ] Verify no unapproved SDKs are bundled (no analytics, no tracking)
- [ ] Update privacy policy at apps.routeworks.app if data practices changed
- [ ] Configure Firestore security rules for production

### Phase 5: Testing & Beta (3-4 weeks)
- [ ] Test on 3+ real Android devices (including one budget phone)
- [ ] Fix performance issues on lower-end devices
- [ ] Set up Discord server with beta channels
- [ ] Set up closed beta track on Google Play
- [ ] Recruit beta testers (Discord + email)
- [ ] Run closed beta for 3-4 weeks
- [ ] Collect and prioritize feedback
- [ ] Fix critical bugs and usability issues
- [ ] Adjust difficulty curves based on tester feedback

### Phase 6: Launch (1-2 weeks)
- [ ] Create production app listing (title, description, screenshots, feature graphic)
- [ ] Final round of QA
- [ ] Submit to Google Play production track
- [ ] Address any review feedback
- [ ] Launch!
- [ ] Monitor crash reports and user feedback
- [ ] Hot-fix any critical issues

**Estimated Total Timeline: 19-27 weeks**
- Full-time solo: closer to 19 weeks
- Part-time / side project: closer to 27+ weeks
- With a contributor helping on art/sound: could compress by 2-3 weeks

### Post-Launch Priorities
1. Monitor and fix bugs (first 2 weeks)
2. Adjust difficulty/reward pacing based on real user behavior
3. Begin iOS prep (acquire Mac access)
4. Start v2 palace builder design
5. Grow Discord community and gather feature requests

---

*Document created: 2026-02-14*
*Last updated: 2026-02-14*
*Status: Decisions locked. Ready for development.*
