# Step 1: Project Scaffold, Boilerplate & Design System

> **Goal:** Create the Flutter project with complete folder structure, all
> dependencies, the theme/design system in code, core interface contracts,
> localization scaffold, and a runnable app that displays a themed placeholder
> hub screen.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Flutter SDK installed, Android Studio or VS Code with Flutter
> plugin, Android emulator or device available.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Project Creation & Structure](#3-project-creation--structure)
4. [Dependencies (pubspec.yaml)](#4-dependencies-pubspecyaml)
5. [Font Assets](#5-font-assets)
6. [Theme System Implementation](#6-theme-system-implementation)
7. [Color System Implementation](#7-color-system-implementation)
8. [App Entry Point](#8-app-entry-point)
9. [Core Interfaces (Contracts Only)](#9-core-interfaces-contracts-only)
10. [Localization Scaffold](#10-localization-scaffold)
11. [Placeholder Hub Screen](#11-placeholder-hub-screen)
12. [Placeholder Game Shell](#12-placeholder-game-shell)
13. [Routing](#13-routing)
14. [Verification Checklist](#14-verification-checklist)

---

## 1. User Stories

### US-1.1: Developer Project Setup
**As a** developer,
**I want** a Flutter project with the complete folder structure defined in the architecture plan,
**so that** I have a clear, organized codebase where every file has an obvious home.

### US-1.2: Themed App Shell
**As a** developer,
**I want** the app to launch with the Math Dragons visual theme applied (colors, fonts, dark background),
**so that** all future screens inherit the design system automatically.

### US-1.3: Placeholder Hub
**As a** developer,
**I want** a placeholder hub screen that shows 4 game cards (one per game) with the correct accent colors,
**so that** I can verify navigation and theming work before building real content.

### US-1.4: Design Tokens in Code
**As a** developer,
**I want** all colors, fonts, and spacing defined as constants in dedicated files,
**so that** the entire app references a single source of truth for visual styling.

### US-1.5: Core Contracts
**As a** developer,
**I want** the abstract interfaces (`MathDragonsGame`, event types, reward config) defined as Dart abstract classes,
**so that** future game implementations can be built against stable contracts.

### US-1.6: Localization Ready
**As a** developer,
**I want** all user-facing strings in the placeholder screens to go through Flutter's localization system,
**so that** we never have to retroactively extract hardcoded strings.

---

## 2. Acceptance Criteria

- [ ] `flutter run` launches the app successfully on Android emulator or device
- [ ] App displays a themed splash/hub screen with Math Dragons branding
- [ ] 4 game cards visible, each with the correct game name and accent color
- [ ] Tapping a game card navigates to a placeholder game screen
- [ ] Back button returns to hub
- [ ] All colors match the Visual Design Guide
- [ ] Cinzel font displays for headings, Nunito for body text
- [ ] All visible strings are sourced from ARB localization files
- [ ] Folder structure matches the architecture plan (empty placeholder files where needed)
- [ ] `flutter analyze` passes with no errors
- [ ] Core interfaces compile (abstract classes, enums, data classes)

---

## 3. Project Creation & Structure

### 3.1 Create Project

```bash
flutter create --org com.mathdragonsgame math_dragons
cd math_dragons
```

### 3.2 Directory Structure

Create the full directory tree. Empty directories get a placeholder file. Files
that will be implemented in later steps get a minimal stub (just enough to compile).

```
math_dragons/
├── lib/
│   ├── main.dart                          ← App entry point
│   ├── app.dart                           ← MaterialApp with theme + routing
│   │
│   ├── core/
│   │   ├── game_registry.dart             ← Stub: GameRegistry class
│   │   ├── game_interface.dart            ← Full: MathDragonsGame abstract class
│   │   ├── game_events.dart               ← Full: Event type definitions
│   │   ├── reward_service.dart            ← Stub: RewardService placeholder
│   │   ├── player_profile.dart            ← Stub: PlayerProfile data class
│   │   ├── difficulty_engine.dart         ← Stub: placeholder
│   │   ├── fact_tracker.dart              ← Stub: placeholder
│   │   ├── daily_challenge.dart           ← Stub: placeholder
│   │   ├── haptics.dart                   ← Stub: HapticsService placeholder
│   │   └── session_manager.dart           ← Stub: placeholder
│   │
│   ├── storage/
│   │   ├── local_storage.dart             ← Stub
│   │   ├── cloud_sync.dart                ← Stub
│   │   ├── sync_resolver.dart             ← Stub
│   │   └── migration.dart                 ← Stub
│   │
│   ├── auth/
│   │   ├── auth_service.dart              ← Stub
│   │   ├── anonymous_auth.dart            ← Stub
│   │   └── account_upgrade.dart           ← Stub
│   │
│   ├── hub/
│   │   ├── hub_screen.dart                ← Full: Placeholder hub layout
│   │   ├── game_card.dart                 ← Full: Game card widget
│   │   ├── profile_bar.dart               ← Full: Top bar placeholder
│   │   ├── dragon_companion.dart          ← Stub: placeholder widget
│   │   ├── daily_challenge_card.dart      ← Stub: placeholder widget
│   │   └── settings_screen.dart           ← Stub: basic settings scaffold
│   │
│   ├── games/
│   │   ├── shared/
│   │   │   ├── game_shell.dart            ← Stub: wrapper scaffold
│   │   │   ├── math_problem.dart          ← Stub
│   │   │   ├── result_screen.dart         ← Stub
│   │   │   └── difficulty_config.dart     ← Stub
│   │   ├── dragon_runes/
│   │   │   └── dragon_runes_game.dart     ← Stub: placeholder screen
│   │   ├── fire_trail/
│   │   │   └── fire_trail_game.dart       ← Stub: placeholder screen
│   │   ├── dragon_eggs/
│   │   │   └── dragon_eggs_game.dart      ← Stub: placeholder screen
│   │   └── dragons_feast/
│   │       └── dragons_feast_game.dart    ← Stub: placeholder screen
│   │
│   ├── monetization/
│   │   ├── iap_manager.dart               ← Stub
│   │   ├── store_screen.dart              ← Stub
│   │   └── parental_gate.dart             ← Stub
│   │
│   ├── rewards/
│   │   └── placeholder.dart               ← Stub for v2 palace builder
│   │
│   ├── l10n/
│   │   └── app_en.arb                     ← English strings for Step 1 UI
│   │
│   └── theme/
│       ├── dragon_theme.dart              ← Full: ThemeData configuration
│       ├── dragon_colors.dart             ← Full: All color constants
│       └── dragon_spacing.dart            ← Full: Spacing constants
│
├── assets/
│   ├── fonts/
│   │   ├── Cinzel-Regular.ttf
│   │   ├── Cinzel-Bold.ttf
│   │   ├── Nunito-Regular.ttf
│   │   ├── Nunito-SemiBold.ttf
│   │   ├── Nunito-Bold.ttf
│   │   ├── JetBrainsMono-Regular.ttf
│   │   └── JetBrainsMono-Bold.ttf
│   ├── images/
│   │   ├── dragons/
│   │   ├── hub/
│   │   ├── games/
│   │   └── ui/
│   ├── animations/
│   └── sounds/
│       ├── music/
│       └── sfx/
│
├── test/
│   ├── core/
│   ├── games/
│   └── integration/
│
└── pubspec.yaml
```

---

## 4. Dependencies (pubspec.yaml)

All v1 dependencies, pinned to compatible versions. Dependencies not needed
until later steps are included but commented out so the full list is documented.

```yaml
name: math_dragons
description: Dragon-powered math games that are actually fun!
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

  # Game Engine (Step 4+)
  flame: ^1.14.0

  # Local Storage (Step 2)
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1

  # State Management
  provider: ^6.1.1

  # Firebase (Step 10)
  # firebase_core: ^2.24.0
  # firebase_auth: ^4.16.0
  # cloud_firestore: ^4.14.0

  # Auth (Step 10)
  # google_sign_in: ^6.2.1

  # IAP (Step 11)
  # purchases_flutter: ^6.17.0

  # Audio (Step 12)
  # flame_audio: ^2.1.6

  # Animations (Step 12)
  # rive: ^0.12.4

  # Utilities
  equatable: ^2.0.5
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.7

flutter:
  uses-material-design: true
  generate: true  # For localization

  assets:
    - assets/images/dragons/
    - assets/images/hub/
    - assets/images/games/
    - assets/images/ui/
    - assets/animations/
    - assets/sounds/music/
    - assets/sounds/sfx/

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

### Localization Config (l10n.yaml)

Create `l10n.yaml` in project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

---

## 5. Font Assets

Download these free fonts and place in `assets/fonts/`:

| Font | Source | Files Needed |
|------|--------|-------------|
| Cinzel | [Google Fonts](https://fonts.google.com/specimen/Cinzel) | Regular, Bold |
| Nunito | [Google Fonts](https://fonts.google.com/specimen/Nunito) | Regular, SemiBold, Bold |
| JetBrains Mono | [Google Fonts](https://fonts.google.com/specimen/JetBrains+Mono) | Regular, Bold |

---

## 6. Theme System Implementation

### `lib/theme/dragon_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dragon_colors.dart';

class DragonTheme {
  DragonTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: DragonColors.dragonPurple,
        onPrimary: DragonColors.textPrimary,
        secondary: DragonColors.dragonGold,
        onSecondary: DragonColors.deepVoid,
        surface: DragonColors.nightSurface,
        onSurface: DragonColors.textPrimary,
        onSurfaceVariant: DragonColors.textSecondary,
        error: DragonColors.fireOrange,
        onError: DragonColors.textPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: DragonColors.midnightBlue,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: DragonColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: DragonColors.textSecondary,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        // Display — Cinzel for fantasy headings
        displayLarge: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: 0.3,
          color: DragonColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.2,
          color: DragonColors.textPrimary,
        ),

        // Headline — mixed
        headlineLarge: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: DragonColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: DragonColors.textPrimary,
        ),

        // Title — Nunito
        titleLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.4,
          color: DragonColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: DragonColors.textPrimary,
        ),

        // Body — Nunito
        bodyLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: DragonColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: DragonColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.2,
          color: DragonColors.textSecondary,
        ),

        // Label — Nunito
        labelLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textPrimary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.5,
          color: DragonColors.textSecondary,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: DragonColors.nightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button (Primary / Gold)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DragonColors.dragonGold,
          foregroundColor: DragonColors.deepVoid,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button (Secondary / Purple outline)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DragonColors.textPrimary,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: DragonColors.amethyst, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: DragonColors.nightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: DragonColors.divider, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: DragonColors.textPrimary,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DragonColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return DragonColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DragonColors.dragonGold;
          }
          return DragonColors.disabled;
        }),
      ),
    );
  }
}
```

---

## 7. Color System Implementation

### `lib/theme/dragon_colors.dart`

```dart
import 'package:flutter/material.dart';

/// All color constants for the Math Dragons app.
/// See VISUAL_DESIGN_GUIDE.md for full documentation.
class DragonColors {
  DragonColors._();

  // ──── Primary Palette ────
  static const dragonPurple = Color(0xFF2D1B69);
  static const amethyst = Color(0xFF4A2D8F);
  static const deepVoid = Color(0xFF1A0F3D);
  static const dragonGold = Color(0xFFF4A261);
  static const warmGlow = Color(0xFFF7C08A);
  static const agedGold = Color(0xFFD4843A);
  static const emeraldFlame = Color(0xFF2A9D8F);
  static const fireOrange = Color(0xFFE76F51);
  static const midnightBlue = Color(0xFF1A1A2E);
  static const nightSurface = Color(0xFF16213E);
  static const twilight = Color(0xFF1F2F50);

  // ──── Semantic Colors ────
  static const correct = emeraldFlame;
  static const incorrect = fireOrange;
  static const warning = dragonGold;
  static const info = Color(0xFF5B8DEF);
  static const disabled = Color(0xFF4A4A6A);
  static const textPrimary = Color(0xFFF0E6D3);
  static const textSecondary = Color(0xFFA89DB8);
  static const textOnGold = deepVoid;
  static const divider = Color(0xFF2A2A4A);

  // ──── Game Accent Colors ────
  static const runesAccent = Color(0xFF9B59B6);
  static const runesAccentLight = Color(0xFFBB8FCE);
  static const runesAccentDark = Color(0xFF6C3483);

  static const fireTrailAccent = Color(0xFFE74C3C);
  static const fireTrailAccentLight = Color(0xFFF1948A);
  static const fireTrailAccentDark = Color(0xFFC0392B);

  static const dragonEggsAccent = Color(0xFF3498DB);
  static const dragonEggsAccentLight = Color(0xFF85C1E9);
  static const dragonEggsAccentDark = Color(0xFF2471A3);

  static const dragonsFeastAccent = Color(0xFF27AE60);
  static const dragonsFeastAccentLight = Color(0xFF82E0AA);
  static const dragonsFeastAccentDark = Color(0xFF1E8449);

  // ──── Dragon Eggs: Egg Colors ────
  static const eggCream = Color(0xFFF5E6CA);
  static const eggBlue = Color(0xFFAED6F1);
  static const eggGreen = Color(0xFFA9DFBF);
  static const eggOrange = Color(0xFFF5CBA7);
  static const eggDivision = Color(0xFF8E44AD);
  static const eggOperator = Color(0xFFF4D03F);

  // ──── Gradients ────
  static const lairGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepVoid, dragonPurple, nightSurface],
  );

  static const goldShimmer = LinearGradient(
    colors: [agedGold, dragonGold, warmGlow],
  );

  static const fireGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [fireOrange, dragonGold, Color(0xFFFFF3B0)],
  );

  static const nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0D1A), midnightBlue, nightSurface],
  );

  // ──── Opacity Helpers ────
  static Color overlayHeavy(Color c) => c.withValues(alpha: 0.8);
  static Color overlayMedium(Color c) => c.withValues(alpha: 0.6);
  static Color overlayLight(Color c) => c.withValues(alpha: 0.3);
  static Color disabledOpacity(Color c) => c.withValues(alpha: 0.4);
}
```

### `lib/theme/dragon_spacing.dart`

```dart
/// Spacing constants based on a 4dp base unit.
/// See VISUAL_DESIGN_GUIDE.md Section 4 for full documentation.
class DragonSpacing {
  DragonSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // Common padding presets
  static const screenPadding = base;
  static const cardPadding = md;
  static const sectionGap = lg;
}
```

---

## 8. App Entry Point

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode (games are designed for portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1A2E),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MathDragonsApp());
}
```

### `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'theme/dragon_theme.dart';
import 'hub/hub_screen.dart';

class MathDragonsApp extends StatelessWidget {
  const MathDragonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Dragons',
      debugShowCheckedModeBanner: false,
      theme: DragonTheme.darkTheme,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],

      home: const HubScreen(),
    );
  }
}
```

---

## 9. Core Interfaces (Contracts Only)

These are the abstract contracts that all future code builds against. They
compile and define the shape of the system, but have no implementation.

### `lib/core/game_interface.dart`

```dart
import 'package:flutter/material.dart';

/// The contract every mini-game must implement.
/// Adding a new game = implement this + register in GameRegistry.
abstract class MathDragonsGame {
  // ── Identity ──
  String get gameId;
  String get displayName;
  String get description;
  String get iconAsset;
  String get environmentAsset;
  Color get accentColor;

  // ── Difficulty / Levels ──
  List<GameLevel> get levels;
  GameLevel currentLevel(PlayerGameStats stats);

  // ── Rewards ──
  RewardConfig get rewardConfig;

  // ── Math skills this game teaches ──
  List<MathSkill> get mathSkills;

  // ── The actual game widget ──
  Widget buildGame(GameContext context);

  // ── Difficulty engine hook ──
  DifficultyProfile get difficultyProfile;
}

/// A single level within a game.
class GameLevel {
  final int levelNumber;
  final String name;
  final String worldName;
  final DifficultyParams params;
  final int starsRequired;

  const GameLevel({
    required this.levelNumber,
    required this.name,
    required this.worldName,
    required this.params,
    this.starsRequired = 0,
  });
}

/// Difficulty parameters for a level. Games extend this with game-specific params.
class DifficultyParams {
  final int numberMin;
  final int numberMax;
  final Set<MathOperation> operations;
  final double speedMultiplier;

  const DifficultyParams({
    required this.numberMin,
    required this.numberMax,
    required this.operations,
    this.speedMultiplier = 1.0,
  });
}

/// Math operations available in games.
enum MathOperation { addition, subtraction, multiplication, division }

/// Math skills tracked across games.
enum MathSkill {
  addition,
  subtraction,
  multiplication,
  division,
  equationBuilding,
  mentalMathSpeed,
  numberProperties,
  categorization,
}

/// Configuration for how a game awards currency.
class RewardConfig {
  final int baseScalesPerCorrect;
  final int streakBonusCap;
  final int levelCompletionBonus;
  final int threeStarBonus;

  const RewardConfig({
    required this.baseScalesPerCorrect,
    required this.streakBonusCap,
    required this.levelCompletionBonus,
    required this.threeStarBonus,
  });
}

/// Per-game stats for a player. Used to determine current level.
class PlayerGameStats {
  final int currentLevel;
  final int highScore;
  final int totalStars;
  final int timesPlayed;
  final int bestStreak;
  final double accuracy;

  const PlayerGameStats({
    this.currentLevel = 1,
    this.highScore = 0,
    this.totalStars = 0,
    this.timesPlayed = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
  });
}

/// Context passed to a game when it's launched.
class GameContext {
  final GameLevel level;
  final PlayerGameStats stats;

  const GameContext({
    required this.level,
    required this.stats,
  });
}

/// Profile for adaptive difficulty. Games define their difficulty parameters.
class DifficultyProfile {
  final double minAccuracyForAdvance;
  final int minProblemsPerLevel;

  const DifficultyProfile({
    this.minAccuracyForAdvance = 0.6,
    this.minProblemsPerLevel = 10,
  });
}
```

### `lib/core/game_events.dart`

```dart
/// Events emitted by games through the event bus.
/// Listeners (RewardService, FactTracker, CloudSync, etc.) subscribe independently.

sealed class GameEvent {
  final String gameId;
  final DateTime timestamp;

  GameEvent({required this.gameId}) : timestamp = DateTime.now();
}

class GameStarted extends GameEvent {
  final int levelNumber;

  GameStarted({required super.gameId, required this.levelNumber});
}

class AnswerGiven extends GameEvent {
  final String problem;
  final String playerAnswer;
  final String correctAnswer;
  final bool correct;
  final int responseTimeMs;

  AnswerGiven({
    required super.gameId,
    required this.problem,
    required this.playerAnswer,
    required this.correctAnswer,
    required this.correct,
    required this.responseTimeMs,
  });
}

class StreakAchieved extends GameEvent {
  final int streakLength;

  StreakAchieved({required super.gameId, required this.streakLength});
}

class LevelCompleted extends GameEvent {
  final int levelNumber;
  final int score;
  final int stars;
  final double accuracy;

  LevelCompleted({
    required super.gameId,
    required this.levelNumber,
    required this.score,
    required this.stars,
    required this.accuracy,
  });
}

class GameEnded extends GameEvent {
  final int finalScore;
  final Duration duration;

  GameEnded({
    required super.gameId,
    required this.finalScore,
    required this.duration,
  });
}
```

### `lib/core/game_registry.dart` (stub)

```dart
import 'game_interface.dart';

/// Central registry of all available games.
/// Games register themselves here; the hub screen discovers them.
class GameRegistry {
  final List<MathDragonsGame> _games = [];

  List<MathDragonsGame> get games => List.unmodifiable(_games);

  void register(MathDragonsGame game) {
    _games.add(game);
  }

  MathDragonsGame? getById(String gameId) {
    try {
      return _games.firstWhere((g) => g.gameId == gameId);
    } catch (_) {
      return null;
    }
  }
}
```

### `lib/core/player_profile.dart` (stub)

```dart
/// Player profile data model. Full implementation in Step 2.
class PlayerProfile {
  final String id;
  final String dragonName;
  final int dragonEvolution; // 0=egg through 5=elder
  final int totalScales;
  final int totalCorrectAnswers;
  final int totalPlayTimeMinutes;
  final int dailyChallengeStreak;

  const PlayerProfile({
    required this.id,
    this.dragonName = 'Dragon',
    this.dragonEvolution = 0,
    this.totalScales = 0,
    this.totalCorrectAnswers = 0,
    this.totalPlayTimeMinutes = 0,
    this.dailyChallengeStreak = 0,
  });
}
```

---

## 10. Localization Scaffold

### `lib/l10n/app_en.arb`

```json
{
  "@@locale": "en",

  "appTitle": "Math Dragons",
  "@appTitle": { "description": "The app name shown in the title bar" },

  "hubTitle": "Dragon's Lair",
  "@hubTitle": { "description": "Title of the hub/home screen" },

  "dragonRunes": "Dragon Runes",
  "@dragonRunes": { "description": "Name of the Number Links game" },

  "dragonRunesDescription": "Connect ancient runes to cast spells",
  "@dragonRunesDescription": { "description": "Short description of Dragon Runes" },

  "fireTrail": "Fire Trail",
  "@fireTrail": { "description": "Name of the Math Snake game" },

  "fireTrailDescription": "Blaze a trail of flame across the sky",
  "@fireTrailDescription": { "description": "Short description of Fire Trail" },

  "dragonEggs": "Dragon Eggs",
  "@dragonEggs": { "description": "Name of the Bubble Pop game" },

  "dragonEggsDescription": "Hatch dragon eggs with math equations",
  "@dragonEggsDescription": { "description": "Short description of Dragon Eggs" },

  "dragonsFeast": "Dragon's Feast",
  "@dragonsFeast": { "description": "Name of the Muncher game" },

  "dragonsFeastDescription": "Feast on treasures matching the right properties",
  "@dragonsFeastDescription": { "description": "Short description of Dragon's Feast" },

  "settings": "Settings",
  "@settings": { "description": "Settings screen title" },

  "sound": "Sound",
  "@sound": { "description": "Sound effects toggle label" },

  "music": "Music",
  "@music": { "description": "Background music toggle label" },

  "haptics": "Haptics",
  "@haptics": { "description": "Vibration feedback toggle label" },

  "backToHub": "Back to Hub",
  "@backToHub": { "description": "Button text to return to hub" },

  "play": "Play",
  "@play": { "description": "Play button text" },

  "level": "Level {number}",
  "@level": {
    "description": "Level indicator",
    "placeholders": {
      "number": { "type": "int" }
    }
  },

  "scalesCount": "{count} Scales",
  "@scalesCount": {
    "description": "Dragon scales currency display",
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "comingSoon": "Coming Soon",
  "@comingSoon": { "description": "Placeholder text for upcoming features" },

  "gamePlaceholder": "Game Coming Soon!\nThis game will be built in a future step.",
  "@gamePlaceholder": { "description": "Placeholder text shown in stub game screens" }
}
```

---

## 11. Placeholder Hub Screen

### `lib/hub/hub_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import 'game_card.dart';
import 'profile_bar.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.lairGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Profile bar at top
              const ProfileBar(),

              const SizedBox(height: DragonSpacing.sm),

              // Hub title
              Text(
                l10n.hubTitle,
                style: Theme.of(context).textTheme.displayMedium,
              ),

              const SizedBox(height: DragonSpacing.lg),

              // Game cards grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DragonSpacing.base,
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: DragonSpacing.sm,
                    mainAxisSpacing: DragonSpacing.sm,
                    childAspectRatio: 0.75,
                    children: [
                      GameCard(
                        gameId: 'dragon_runes',
                        title: l10n.dragonRunes,
                        description: l10n.dragonRunesDescription,
                        accentColor: DragonColors.runesAccent,
                        icon: Icons.auto_awesome,
                        level: 1,
                      ),
                      GameCard(
                        gameId: 'fire_trail',
                        title: l10n.fireTrail,
                        description: l10n.fireTrailDescription,
                        accentColor: DragonColors.fireTrailAccent,
                        icon: Icons.local_fire_department,
                        level: 1,
                      ),
                      GameCard(
                        gameId: 'dragon_eggs',
                        title: l10n.dragonEggs,
                        description: l10n.dragonEggsDescription,
                        accentColor: DragonColors.dragonEggsAccent,
                        icon: Icons.egg,
                        level: 1,
                      ),
                      GameCard(
                        gameId: 'dragons_feast',
                        title: l10n.dragonsFeast,
                        description: l10n.dragonsFeastDescription,
                        accentColor: DragonColors.dragonsFeastAccent,
                        icon: Icons.restaurant,
                        level: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### `lib/hub/game_card.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

class GameCard extends StatelessWidget {
  final String gameId;
  final String title;
  final String description;
  final Color accentColor;
  final IconData icon;
  final int level;

  const GameCard({
    super.key,
    required this.gameId,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.icon,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/game/$gameId');
      },
      child: Container(
        decoration: BoxDecoration(
          color: DragonColors.nightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(DragonSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 32),
              ),

              const SizedBox(height: DragonSpacing.md),

              // Game title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Cinzel',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: DragonSpacing.xs),

              // Description
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Level indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DragonSpacing.sm,
                  vertical: DragonSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: DragonColors.twilight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### `lib/hub/profile_bar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.base,
        vertical: DragonSpacing.sm,
      ),
      child: Row(
        children: [
          // Dragon evolution indicator (placeholder)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: DragonColors.dragonGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: DragonColors.dragonGold,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                '🥚',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          const SizedBox(width: DragonSpacing.sm),

          // Dragon name
          Expanded(
            child: Text(
              'Dragon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          // Scales counter
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: DragonColors.dragonGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DragonColors.dragonGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.diamond,
                  color: DragonColors.dragonGold,
                  size: 16,
                ),
                const SizedBox(width: DragonSpacing.xs),
                Text(
                  l10n.scalesCount(0),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: DragonColors.dragonGold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: DragonSpacing.sm),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings, color: DragonColors.textSecondary),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 12. Placeholder Game Shell

### `lib/games/shared/game_shell.dart`

A simple wrapper used by all game placeholder screens until real games are built.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';

class GameShell extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Widget child;

  const GameShell({
    super.key,
    required this.title,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.nightSky,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top HUD bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DragonSpacing.sm,
                  vertical: DragonSpacing.xs,
                ),
                color: DragonColors.deepVoid.withValues(alpha: 0.8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: DragonColors.textSecondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: accentColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Placeholder for scales counter
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Game content area
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Placeholder game screens (one per game)

Each game gets a simple placeholder. Example for Dragon Runes:

#### `lib/games/dragon_runes/dragon_runes_game.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/dragon_colors.dart';
import '../shared/game_shell.dart';

class DragonRunesScreen extends StatelessWidget {
  const DragonRunesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GameShell(
      title: l10n.dragonRunes,
      accentColor: DragonColors.runesAccent,
      child: Center(
        child: Text(
          l10n.gamePlaceholder,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
```

Repeat the same pattern for:
- `lib/games/fire_trail/fire_trail_game.dart` (uses `fireTrailAccent`, `l10n.fireTrail`)
- `lib/games/dragon_eggs/dragon_eggs_game.dart` (uses `dragonEggsAccent`, `l10n.dragonEggs`)
- `lib/games/dragons_feast/dragons_feast_game.dart` (uses `dragonsFeastAccent`, `l10n.dragonsFeast`)

---

## 13. Routing

### Update `lib/app.dart` to include routes:

```dart
// Add to MaterialApp in app.dart:
routes: {
  '/settings': (context) => const SettingsScreen(),
  '/game/dragon_runes': (context) => const DragonRunesScreen(),
  '/game/fire_trail': (context) => const FireTrailScreen(),
  '/game/dragon_eggs': (context) => const DragonEggsScreen(),
  '/game/dragons_feast': (context) => const DragonsFeastScreen(),
},
```

### `lib/hub/settings_screen.dart` (stub)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _hapticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.lairGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(DragonSpacing.base),
          children: [
            SwitchListTile(
              title: Text(l10n.sound),
              value: _soundEnabled,
              onChanged: (v) => setState(() => _soundEnabled = v),
            ),
            SwitchListTile(
              title: Text(l10n.music),
              value: _musicEnabled,
              onChanged: (v) => setState(() => _musicEnabled = v),
            ),
            SwitchListTile(
              title: Text(l10n.haptics),
              value: _hapticsEnabled,
              onChanged: (v) => setState(() => _hapticsEnabled = v),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 14. Verification Checklist

After completing this step, verify:

- [ ] **`flutter run` succeeds** — app launches on emulator/device
- [ ] **Hub screen displays** — gradient background, "Dragon's Lair" title in Cinzel font
- [ ] **4 game cards visible** — each with correct name, icon, accent color border
- [ ] **Tap a game card** — navigates to placeholder game screen
- [ ] **Back button works** — returns to hub from game screen
- [ ] **Settings accessible** — gear icon → settings screen with toggles
- [ ] **Localization working** — change a string in `app_en.arb`, rebuild, see it update
- [ ] **Theme consistent** — dark background, warm white text, gold accents throughout
- [ ] **`flutter analyze` clean** — no errors or warnings
- [ ] **Folder structure matches plan** — all directories exist, stub files in place
- [ ] **Core interfaces compile** — `game_interface.dart`, `game_events.dart` have no errors
- [ ] **Fonts render correctly** — Cinzel for headings, Nunito for body, verify visually
- [ ] **Colors match Visual Design Guide** — compare screenshots against hex values

### Quick Smoke Test Script

```bash
cd math_dragons
flutter analyze
flutter test
flutter build apk --debug
```

---

## Stub Files Checklist

These files need to exist with minimal content (empty class or TODO comment)
to satisfy the folder structure. They'll be implemented in later steps:

| File | Content | Implemented In |
|------|---------|---------------|
| `core/reward_service.dart` | Empty class stub | Step 2 |
| `core/difficulty_engine.dart` | Empty class stub | Step 8 |
| `core/fact_tracker.dart` | Empty class stub | Step 2 |
| `core/daily_challenge.dart` | Empty class stub | Step 9 |
| `core/haptics.dart` | Empty class stub | Step 12 |
| `core/session_manager.dart` | Empty class stub | Step 2 |
| `storage/local_storage.dart` | Empty class stub | Step 2 |
| `storage/cloud_sync.dart` | Empty class stub | Step 10 |
| `storage/sync_resolver.dart` | Empty class stub | Step 10 |
| `storage/migration.dart` | Empty class stub | Step 2 |
| `auth/auth_service.dart` | Empty class stub | Step 10 |
| `auth/anonymous_auth.dart` | Empty class stub | Step 10 |
| `auth/account_upgrade.dart` | Empty class stub | Step 10 |
| `hub/dragon_companion.dart` | Empty widget stub | Step 12 |
| `hub/daily_challenge_card.dart` | Empty widget stub | Step 9 |
| `games/shared/math_problem.dart` | Empty class stub | Step 4 |
| `games/shared/result_screen.dart` | Empty widget stub | Step 3 |
| `games/shared/difficulty_config.dart` | Empty class stub | Step 8 |
| `monetization/iap_manager.dart` | Empty class stub | Step 11 |
| `monetization/store_screen.dart` | Empty widget stub | Step 11 |
| `monetization/parental_gate.dart` | Empty widget stub | Step 11 |
| `rewards/placeholder.dart` | Empty class stub | v2 |

### Stub Template

Every stub file follows this pattern:

```dart
// TODO: Implement in Step N
// See docs/STEP_0N_NAME.md for requirements
```

---

*Document created: 2026-02-14*
*Status: Ready for implementation*
