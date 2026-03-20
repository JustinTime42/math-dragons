# Math Dragons

Dragon-powered math games that are actually fun! A collection of four math mini-games wrapped in a whimsical dragon fantasy world, built with Flutter.

## Current Status

**Step 10 complete** — Firebase integration with anonymous auth, optional Google Sign-In, offline-first Firestore cloud sync, conflict resolution, and backup prompt system.

- [x] Flutter project with full directory structure
- [x] Theme/design system (colors, typography, spacing)
- [x] Core interfaces (`MathDragonsGame`, event types, reward config)
- [x] **PlayerProfile data model** with Hive persistence (scales, evolution, game stats)
- [x] **EventBus** for decoupled game-to-service communication
- [x] **RewardService** with full scale earning logic
- [x] **FactTracker** tracking per-fact accuracy and mastery
- [x] **SessionManager** tracking app and game session state
- [x] **HapticsService** with named haptic patterns
- [x] **LocalStorage** (Hive) with profile, fact history, and meta boxes
- [x] **Schema migration system** (forward-only, versioned)
- [x] **Enhanced GameRegistry** with sorted queries and storage dependency
- [x] **Provider wiring** — all services accessible from any widget
- [x] **Hub screen** — data-driven from PlayerProfile, scrollable layout
- [x] **Dragon companion** — animated pulsing egg/dragon on hub screen
- [x] **Game cards** — show real level, star count, world progress, tap animation
- [x] **Profile bar** — dragon name, evolution stage name, formatted scales counter
- [x] **Daily challenge card** — static placeholder with example tasks
- [x] **Settings screen** — dragon name text field, sound/music/haptics toggles, about section
- [x] **Game shell** — shared HUD (scales, level), pause overlay (Resume/Settings/Quit), SessionManager integration
- [x] **Result screen** — animated stars, scales counter tick-up, stats grid, Play Again/Back to Hub
- [x] **Custom navigation transitions** — fade+scale for games, slide for settings
- [x] **Dragon Eggs** (Step 4) — Bubble Pop port with falling eggs, equation builder, 6 difficulty tiers, combo system, auto-leveling, Flame engine
- [x] **Fire Trail** (Step 5) — Math Snake port with grid movement, D-pad + swipe controls, flame intensity mechanic, 5 worlds (40 levels), answer gems, sparkle effects, countdown
- [x] **Dragon Runes** (Step 6) — Number Links port with circular node layout, drag-to-connect chain mechanics, equation validation, level generation, hint system, spell-casting particle effects, 5 worlds (50 levels)
- [x] **Dragon's Feast** (Step 7) — Merged Muncher port with 5x5 grid navigation, 26+ math categories (even/odd, multiples, primes, composites, perfect squares, factors, ranges), enemy AI (chasers + wanderers), power-ups (freeze/wings/shield), 5 worlds (40 levels)
- [x] **Adaptive Difficulty** (Step 8) — DifficultyEngine with per-operation accuracy tracking, adaptive level selection, performance windows, EventBus integration
- [x] **ProgressionManager** (Step 8) — Dragon evolution stages (Egg→Elder Dragon), XP system, evolution thresholds, cross-game progress tracking
- [x] **Achievement System** (Step 9) — 52 achievements across 3 categories (per-game, cross-game, milestones), reactive EventBus-based unlocking, achievement popup overlay, tabbed browser screen
- [x] **Daily Challenges** (Step 9) — 2-3 deterministic tasks per day, 5 challenge types, streak tracking with bonus scales, hub card with live progress
- [x] **Cosmetics Store** (Step 9) — 8 dragon colors + 6 accessories purchasable with Dragon Scales, store screen with purchase/equip flow
- [x] **Animated Scales Counter** (Step 9) — Tick-up animation with gold particle effects for scale rewards
- [x] **Achievement Popup** (Step 9) — Slide-down banner notification with sequential queue, haptic feedback
- [x] **Firebase Auth** (Step 10) — Anonymous auth on first launch (invisible), optional Google Sign-In upgrade for cross-device backup
- [x] **Cloud Sync** (Step 10) — Offline-first Firestore sync (profile, facts, achievements, daily challenges), debounced writes, background sync on connectivity change
- [x] **Conflict Resolution** (Step 10) — Per-field max for scalars, union for additive data, merge for game stats and level stars
- [x] **Backup Prompt** (Step 10) — Non-blocking bottom sheet at evolution stage 2+, 7-day cooldown, Google Sign-In flow
- [x] **Sync Indicator** (Step 10) — Cloud status icon in profile bar (synced/syncing/offline)
- [x] **Connectivity Monitor** (Step 10) — Auto-retry Firebase init and sync on network reconnection
- [x] **Firestore Security Rules** (Step 10) — User-scoped access with data validation
- [x] **535 unit tests** — all passing
- [x] `flutter analyze` passes clean
- [x] `flutter test` passes — all green
- [x] `flutter build apk --debug` succeeds
- [ ] Step 11+: Monetization, art & polish, launch

## Games

| Game | Theme | Math Skills | Status |
|------|-------|-------------|--------|
| **Dragon Runes** | Ancient rune puzzles | Equation building, all 4 operations | **Playable** |
| **Fire Trail** | Dragon flight | Mental math under time pressure | **Playable** |
| **Dragon Eggs** | Egg hatching | Equation assembly from falling eggs | **Playable** |
| **Dragon's Feast** | Treasure feast | Number properties, categorization | **Playable** |

## Prerequisites

- **Flutter SDK** 3.41+ (Dart 3.11+)
- **Android SDK** with platform tools
- An Android emulator or physical device (for running the app)

### Installing Flutter (Windows, via Scoop)

```bash
scoop bucket add extras
scoop install extras/flutter
```

Verify installation:

```bash
flutter --version
flutter doctor
```

## Building & Running Locally

### 1. Get dependencies

```bash
cd math_dragons
flutter pub get
```

### 2. Generate Hive adapters and localization files

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 3. Run static analysis

```bash
flutter analyze
```

This should report **no issues**.

### 4. Run tests

```bash
flutter test
```

All 535 tests should pass.

### 5. Build a debug APK

```bash
flutter build apk --debug
```

The APK will be at `build/app/outputs/flutter-apk/app-debug.apk`.

### 6. Run on a connected device or emulator

```bash
# List available devices
flutter devices

# Run on the default device
flutter run

# Run on a specific device
flutter run -d <device-id>
```

## Project Structure

```
math_dragons/
├── lib/
│   ├── main.dart                 # App entry point (initializes Hive, runs app)
│   ├── app.dart                  # StatefulWidget with MultiProvider + lifecycle
│   ├── core/
│   │   ├── game_interface.dart   # MathDragonsGame contract
│   │   ├── game_events.dart      # Sealed GameEvent types
│   │   ├── game_registry.dart    # Game discovery + sorted queries
│   │   ├── event_bus.dart        # Stream-based typed pub/sub
│   │   ├── player_profile.dart   # PlayerProfile, GameStats, PlayerSettings (Hive)
│   │   ├── reward_service.dart   # Scales earning logic + EventBus listener
│   │   ├── fact_tracker.dart     # FactRecord model + tracking service
│   │   ├── session_manager.dart  # App/game session tracking
│   │   ├── haptics.dart          # Named haptic patterns
│   │   ├── difficulty_engine.dart# Adaptive difficulty engine
│   │   ├── progression_manager.dart # Dragon evolution + XP system
│   │   ├── achievement.dart      # Achievement data model + 52 definitions
│   │   ├── achievement_tracker.dart # EventBus listener + unlock logic
│   │   ├── daily_challenge.dart  # Daily challenge data model
│   │   └── daily_challenge_manager.dart # Challenge generation + tracking
│   ├── storage/
│   │   ├── local_storage.dart    # Hive wrapper (profiles, facts, meta)
│   │   ├── migration.dart        # Schema migration runner (v2)
│   │   ├── cloud_sync.dart       # Offline-first Firestore sync manager
│   │   ├── sync_resolver.dart    # Conflict resolution (max/union/merge)
│   │   └── connectivity_monitor.dart # Network state monitoring + auto-retry
│   ├── auth/
│   │   ├── auth_service.dart     # Firebase Auth wrapper (anonymous + Google)
│   │   ├── anonymous_auth.dart   # UID ↔ PlayerProfile linkage manager
│   │   └── account_upgrade.dart  # Google Sign-In upgrade flow
│   ├── hub/                      # Hub screen, game cards, profile bar, settings
│   ├── navigation/               # Custom page route transitions
│   ├── games/
│   │   ├── shared/               # Game shell, result screen, shared components
│   │   ├── dragon_runes/         # Number Links port (Flame game)
│   │   │   ├── components/       # Rune nodes, connection line, particles, hints
│   │   │   ├── models/           # RuneNodeData, EquationTarget, config, equations
│   │   │   ├── systems/          # Chain manager, equation validator, level generator, scoring, hints
│   │   │   └── widgets/          # Target panel, chain display, hint button, score display
│   │   ├── fire_trail/           # Math Snake port (Flame game)
│   │   │   ├── components/       # Dragon head, trail segments, gems, grid, sparkles
│   │   │   ├── models/           # GridPosition, Direction, FlameIntensity, config
│   │   │   ├── systems/          # Movement, problem generation, trail management
│   │   │   └── widgets/          # D-pad, flame meter, problem display, countdown
│   │   ├── dragon_eggs/          # Bubble Pop port (Flame game)
│   │   │   ├── components/       # Eggs, danger line, equation, toast, sparkle
│   │   │   └── models/           # Egg data, difficulty, math problems, scoring
│   │   └── dragons_feast/        # Merged Muncher port (Flame game)
│   │       ├── components/       # Grid, tiles, dragon, enemies, power-ups, effects
│   │       ├── models/           # GridCell, MathCategory, EnemyType, FeastConfig
│   │       ├── systems/          # Category system, board generator, enemy AI, power-ups, collision
│   │       └── widgets/          # Category display, lives, score, D-pad, transitions
│   ├── monetization/
│   │   └── store_screen.dart    # Cosmetics store (scales purchasing)
│   ├── widgets/
│   │   ├── achievement_popup.dart    # Slide-down achievement notification
│   │   ├── animated_scales_counter.dart # Animated counter with particles
│   │   └── cosmetic_preview.dart     # Dragon cosmetic display widget
│   ├── rewards/                  # Palace builder (v2 stub)
│   ├── l10n/                     # Localization (ARB + generated)
│   └── theme/                    # Colors, typography, spacing
├── assets/
│   ├── fonts/                    # Cinzel, Nunito, JetBrains Mono
│   ├── images/                   # Dragons, hub, games, UI (placeholders)
│   ├── animations/               # Rive/Lottie files (placeholder)
│   └── sounds/                   # Music + SFX (placeholder)
├── test/
│   ├── core/                     # Unit tests for models and services
│   ├── storage/                  # Storage/migration tests
│   ├── hub/                      # Hub widget unit tests (profile bar, etc.)
│   ├── navigation/               # Route mapping tests
│   ├── games/shared/             # Game shell and result screen tests
│   ├── games/dragon_eggs/        # Dragon Eggs game tests (75 tests)
│   ├── games/fire_trail/         # Fire Trail game tests (69 tests)
│   ├── games/dragon_runes/       # Dragon Runes game tests (61 tests)
│   ├── games/dragons_feast/      # Dragon's Feast game tests (90 tests)
│   ├── monetization/             # Store screen tests
│   └── integration/              # Integration tests (placeholder)
├── docs/                         # Planning documents
└── pubspec.yaml
```

## Hive Type ID Registry

| typeId | Class | File |
|--------|-------|------|
| 0 | `PlayerProfile` | `core/player_profile.dart` |
| 1 | `GameStats` | `core/player_profile.dart` |
| 2 | `PlayerSettings` | `core/player_profile.dart` |
| 3 | `FactRecord` | `core/fact_tracker.dart` |
| 4 | `FactStatus` (enum) | `core/fact_tracker.dart` |
| 5 | `UnlockedAchievement` | `core/achievement.dart` |
| 6 | `DailyChallengeState` | `core/daily_challenge.dart` |

## Design Documents

- [Step 1: Scaffold & Design](../docs/STEP_01_SCAFFOLD_AND_DESIGN.md)
- [Step 2: Core Services](../docs/STEP_02_CORE_SERVICES.md)
- [Step 3: Hub Screen & Navigation](../docs/STEP_03_HUB_SCREEN.md)
- [Step 4: Dragon Eggs Game](../docs/STEP_04_DRAGON_EGGS.md)
- [Step 5: Fire Trail Game](../docs/STEP_05_FIRE_TRAIL.md)
- [Step 6: Dragon Runes Game](../docs/STEP_06_DRAGON_RUNES.md)
- [Step 7: Dragon's Feast Game](../docs/STEP_07_DRAGONS_FEAST.md)
- [Step 8: Adaptive Difficulty & Progression](../docs/STEP_08_ADAPTIVE_DIFFICULTY.md)
- [Step 9: Currency, Achievements & Daily Challenges](../docs/STEP_09_REWARDS_AND_ACHIEVEMENTS.md)
- [Step 10: Firebase & Cloud Backend](../docs/STEP_10_FIREBASE.md)
- [Visual Design Guide](../docs/VISUAL_DESIGN_GUIDE.md)
- [Mobile App Plan](../docs/MOBILE_APP_PLAN.md)

## Tech Stack

- **Framework:** Flutter 3.41 / Dart 3.11
- **Game Engine:** Flame (included, used in later steps)
- **State Management:** Provider
- **Local Storage:** Hive (with code-generated adapters)
- **Cloud Backend:** Firebase (Auth + Firestore, offline-first sync)
- **Auth:** Firebase Anonymous Auth + optional Google Sign-In upgrade
- **Fonts:** Cinzel (headings), Nunito (body), JetBrains Mono (counters)

## Firebase Setup (Cloud Sync)

The app works fully offline without Firebase. To enable cloud sync:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Anonymous + Google sign-in methods)
3. Enable **Cloud Firestore** (production mode)
4. Register an Android app with package name `com.mathdragonsgame.math_dragons`
5. Download `google-services.json` and place it at `android/app/google-services.json`
6. For Google Sign-In, register your debug SHA-1 fingerprint in Firebase Console
7. Deploy `firestore.rules` from the project root via Firebase CLI or the console

Without `google-services.json`, the app gracefully falls back to local-only mode -- no crash, no error dialogs, all features work.

## Notes

- **Windows Developer Mode** is recommended for plugin builds. Enable via `start ms-settings:developers`.
- The app is dark-themed by default (dragon's lair aesthetic).
- All user-facing strings go through Flutter's localization system -- no hardcoded strings.
- After modifying Hive-annotated classes, run `dart run build_runner build --delete-conflicting-outputs` to regenerate adapters.
- After modifying ARB files, run `flutter gen-l10n` to regenerate localization classes.
