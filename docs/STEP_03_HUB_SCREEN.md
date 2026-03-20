# Step 3: Hub Screen & Navigation

> **Goal:** Transform the placeholder hub into a polished, data-driven Dragon's Lair
> launcher. Build the shared game shell with pause overlay and HUD. Create the result
> screen template. Wire up real navigation with custom transitions. The app should feel
> like a real (if content-empty) game launcher after this step.
>
> **Estimated effort:** Single session
>
> **Prerequisite:** Step 2 complete. All core services wired via Provider. `flutter analyze`
> clean. `flutter test` green (36 tests). `flutter build apk --debug` succeeds.

---

## Table of Contents

1. [User Stories](#1-user-stories)
2. [Acceptance Criteria](#2-acceptance-criteria)
3. [Architecture Overview](#3-architecture-overview)
4. [Hub Screen Overhaul](#4-hub-screen-overhaul)
5. [Game Card Upgrade](#5-game-card-upgrade)
6. [Profile Bar Upgrade](#6-profile-bar-upgrade)
7. [Dragon Companion Placeholder](#7-dragon-companion-placeholder)
8. [Daily Challenge Card Placeholder](#8-daily-challenge-card-placeholder)
9. [Settings Screen Upgrade](#9-settings-screen-upgrade)
10. [Game Shell Wrapper](#10-game-shell-wrapper)
11. [Result Screen](#11-result-screen)
12. [Placeholder Game Screen Updates](#12-placeholder-game-screen-updates)
13. [Navigation & Transitions](#13-navigation--transitions)
14. [Localization Updates](#14-localization-updates)
15. [Unit Tests](#15-unit-tests)
16. [Verification Checklist](#16-verification-checklist)

---

## 1. User Stories

### US-3.1: Inviting Hub Screen
**As a** player,
**I want** the home screen to feel like a dragon's lair with glowing game portals,
**so that** I'm excited to explore and play before I even tap a game.

### US-3.2: Real Progress on Game Cards
**As a** player,
**I want** each game card to show my current level, star rating, and progress,
**so that** I can see how far I've come and choose what to play next.

### US-3.3: Dragon Companion Presence
**As a** player,
**I want** to see my dragon companion on the hub screen with a gentle idle animation,
**so that** the hub feels alive and I have a persistent connection to my dragon.

### US-3.4: Smooth Game Entry
**As a** player,
**I want** tapping a game card to smoothly transition into the game with a satisfying animation,
**so that** the experience feels polished and responsive.

### US-3.5: In-Game HUD
**As a** player,
**I want** a consistent top bar during gameplay showing my score, level, and a back button,
**so that** I always know my progress and can return to the hub easily.

### US-3.6: Pause and Resume
**As a** player,
**I want** to pause my game and see options for Resume, Settings, or Quit to Hub,
**so that** I can handle interruptions without losing my place.

### US-3.7: Post-Game Results
**As a** player,
**I want** a results screen after each game round showing my score, accuracy, stars, and scales earned,
**so that** every session ends with a satisfying summary of my accomplishment.

### US-3.8: "Just One More" Flow
**As a** player,
**I want** a prominent "Play Again" button on the results screen (bigger than "Back to Hub"),
**so that** it's easy to keep playing when I'm having fun.

### US-3.9: Settings with Dragon Name
**As a** player,
**I want** to name my dragon and see that name throughout the app,
**so that** my dragon feels like my own personal companion.

### US-3.10: Daily Challenge Awareness
**As a** player,
**I want** to see today's challenge on the hub screen (even if not yet functional),
**so that** I'm aware daily challenges exist and can look forward to them.

---

## 2. Acceptance Criteria

- [ ] Hub screen pulls game list from GameRegistry (not hardcoded)
- [ ] Game cards show real level, star count, and progress from PlayerProfile
- [ ] Profile bar shows real dragon name, evolution stage emoji, and scales count from storage
- [ ] Dragon companion widget shows an animated pulsing egg/dragon in the hub
- [ ] Daily challenge card is visible at the bottom of the hub (static placeholder)
- [ ] Settings screen has dragon name text field that persists across restarts
- [ ] Settings screen has "About" section with app version
- [ ] Game shell has a working pause overlay with Resume / Settings / Quit buttons
- [ ] Game shell integrates with SessionManager (start/end game on mount/unmount)
- [ ] Game shell HUD shows scales counter (JetBrains Mono, gold) and level indicator
- [ ] Result screen displays score, accuracy %, stars (1-3), and scales earned
- [ ] Result screen has gold "Play Again" button (primary) and outline "Back to Hub" (secondary)
- [ ] Hub -> Game transition uses fade + scale up animation (400ms)
- [ ] Game -> Hub transition uses fade + scale down animation (300ms)
- [ ] All new strings are in `app_en.arb` (no hardcoded text)
- [ ] `flutter analyze` passes clean
- [ ] `flutter test` passes (existing + new tests)
- [ ] `flutter build apk --debug` succeeds
- [ ] All navigation paths work: hub -> each game -> back, hub -> settings -> back,
      game -> pause -> resume, game -> pause -> quit, game -> result -> play again,
      game -> result -> hub

---

## 3. Architecture Overview

### What Changes in Step 3

Step 3 is a **UI-focused** step. No new services or data models — we upgrade existing
widgets to use the services built in Step 2, and add the game shell / result screen
that games will use in Steps 4-7.

```
┌──────────────────────────────────────────────────────────────┐
│                   Step 3 Changes                              │
│                                                               │
│  hub_screen.dart ──────── Reads GameRegistry, uses real data │
│  game_card.dart ────────── Shows level, stars, progress bar   │
│  profile_bar.dart ──────── Real name, evolution, scales       │
│  dragon_companion.dart ── Animated pulsing egg/dragon          │
│  daily_challenge_card.dart ── Static placeholder card         │
│  settings_screen.dart ──── Dragon name field, About section   │
│  game_shell.dart ────────── Pause overlay, HUD, SessionMgr   │
│  result_screen.dart ─────── NEW: post-game summary            │
│  dragon_routes.dart ─────── NEW: custom page transitions      │
│  All 4 game screens ─────── Updated to use new GameShell      │
└──────────────────────────────────────────────────────────────┘
```

### Key Patterns

1. **Data-driven hub.** Game cards read from `GameRegistry` and `PlayerProfile`
   via Provider. No hardcoded game data in the hub widget.
2. **Stateful game shell.** The `GameShell` is a `StatefulWidget` that calls
   `SessionManager.startGame()` on init and `endGame()` on dispose.
3. **Result screen callback.** The result screen receives game results as parameters
   and calls back to the parent on "Play Again" or "Back to Hub."
4. **Custom transitions.** A `DragonPageRoute` helper creates the themed transitions
   defined in the Visual Design Guide.

---

## 4. Hub Screen Overhaul

### `lib/hub/hub_screen.dart`

Replace the current implementation. The key changes:
- Read game list from `GameRegistry` via Provider instead of hardcoding 4 cards
- Read profile from `LocalStorage` for the companion and scales
- Add dragon companion widget between title and game cards
- Add daily challenge card below the game grid
- Make the layout scrollable (SingleChildScrollView) so it works on smaller screens

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../core/game_registry.dart';
import '../storage/local_storage.dart';
import 'game_card.dart';
import 'profile_bar.dart';
import 'dragon_companion.dart';
import 'daily_challenge_card.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final registry = context.read<GameRegistry>();
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    // Map game IDs to their display info for cards.
    // In Steps 4-7 when real games register, this becomes:
    //   registry.games.map((game) => GameCard.fromGame(game, profile))
    // For now, we still define the 4 known games but pull stats from profile.
    final gameCards = _buildGameCards(context, l10n, profile);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.lairGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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

                const SizedBox(height: DragonSpacing.base),

                // Dragon companion (animated)
                DragonCompanion(
                  evolutionStage: profile.dragonEvolution,
                ),

                const SizedBox(height: DragonSpacing.base),

                // Game cards grid
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DragonSpacing.base,
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: DragonSpacing.sm,
                    mainAxisSpacing: DragonSpacing.sm,
                    childAspectRatio: 0.72,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: gameCards,
                  ),
                ),

                const SizedBox(height: DragonSpacing.lg),

                // Daily challenge card
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DragonSpacing.base,
                  ),
                  child: DailyChallengeCard(),
                ),

                const SizedBox(height: DragonSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGameCards(
    BuildContext context,
    AppLocalizations l10n,
    PlayerProfile profile,
  ) {
    // Game definitions — these become dynamic once real games register in Steps 4-7
    final games = [
      _GameDef(
        gameId: 'dragon_runes',
        title: l10n.dragonRunes,
        description: l10n.dragonRunesDescription,
        accentColor: DragonColors.runesAccent,
        icon: Icons.auto_awesome,
      ),
      _GameDef(
        gameId: 'fire_trail',
        title: l10n.fireTrail,
        description: l10n.fireTrailDescription,
        accentColor: DragonColors.fireTrailAccent,
        icon: Icons.local_fire_department,
      ),
      _GameDef(
        gameId: 'dragon_eggs',
        title: l10n.dragonEggs,
        description: l10n.dragonEggsDescription,
        accentColor: DragonColors.dragonEggsAccent,
        icon: Icons.egg,
      ),
      _GameDef(
        gameId: 'dragons_feast',
        title: l10n.dragonsFeast,
        description: l10n.dragonsFeastDescription,
        accentColor: DragonColors.dragonsFeastAccent,
        icon: Icons.restaurant,
      ),
    ];

    return games.map((g) {
      final stats = profile.gameStats[g.gameId];
      return GameCard(
        gameId: g.gameId,
        title: g.title,
        description: g.description,
        accentColor: g.accentColor,
        icon: g.icon,
        level: stats?.currentLevel ?? 1,
        totalStars: stats?.totalStars ?? 0,
        timesPlayed: stats?.timesPlayed ?? 0,
      );
    }).toList();
  }
}

class _GameDef {
  final String gameId;
  final String title;
  final String description;
  final Color accentColor;
  final IconData icon;

  const _GameDef({
    required this.gameId,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.icon,
  });
}
```

---

## 5. Game Card Upgrade

### `lib/hub/game_card.dart`

Upgrade to match the Visual Design Guide section 8.2 "Game Card" spec. New features:
- Star rating display (show earned stars out of 3 for the current level)
- Progress bar showing completion percentage within current world
- Tap animation (scale down on press, bounce back)
- Accept `totalStars` and `timesPlayed` from profile data
- Navigate using custom dragon page route transition

```dart
import 'package:flutter/material.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../navigation/dragon_routes.dart';

class GameCard extends StatefulWidget {
  final String gameId;
  final String title;
  final String description;
  final Color accentColor;
  final IconData icon;
  final int level;
  final int totalStars;
  final int timesPlayed;

  const GameCard({
    super.key,
    required this.gameId,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.icon,
    required this.level,
    this.totalStars = 0,
    this.timesPlayed = 0,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _tapController.reverse();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  void _onTap() {
    // Navigate using custom transition
    Navigator.of(context).push(
      DragonPageRoute.gameTransition(
        context: context,
        gameId: widget.gameId,
      ),
    );
  }

  /// Calculate progress within current world (each world = 10 levels).
  double get _worldProgress {
    final levelInWorld = ((widget.level - 1) % 10) + 1;
    return levelInWorld / 10;
  }

  /// Current world number (1-indexed).
  int get _currentWorld => ((widget.level - 1) ~/ 10) + 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _onTap,
        child: Container(
          decoration: BoxDecoration(
            color: DragonColors.nightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.accentColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.2),
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
                    color: widget.accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: widget.accentColor, size: 32),
                ),

                const SizedBox(height: DragonSpacing.sm),

                // Game title (Cinzel)
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Cinzel',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: DragonSpacing.xs),

                // Description
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Star rating row
                _buildStarRow(),

                const SizedBox(height: DragonSpacing.xs),

                // Progress bar
                _buildProgressBar(),

                const SizedBox(height: DragonSpacing.xs),

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
                    'Level ${widget.level}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: widget.accentColor,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRow() {
    // Show stars earned for the most recently completed level.
    // For now, show total stars as a simple count.
    // Full per-level star display comes with the level select screen in Step 8.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 14,
          color: widget.totalStars > 0
              ? DragonColors.dragonGold
              : DragonColors.disabled,
        ),
        const SizedBox(width: 2),
        Text(
          '${widget.totalStars}',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: widget.totalStars > 0
                ? DragonColors.dragonGold
                : DragonColors.disabled,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: _worldProgress,
            backgroundColor: DragonColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(widget.accentColor),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 2),
        // World label
        Text(
          'World $_currentWorld',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: DragonColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
```

**Note:** `AnimatedBuilder` is used above, but the actual Flutter class name is
`AnimatedBuilder`. If the analyzer flags it, verify the import. Alternatively, a
`ScaleTransition` widget can be used directly.

---

## 6. Profile Bar Upgrade

### `lib/hub/profile_bar.dart`

The existing profile bar already reads from `LocalStorage` via Provider and shows
real data. Upgrade it with:
- Dragon name from profile (not hardcoded "Dragon")
- Tap on the dragon name/avatar area opens a future profile screen (for now, no-op)
- Evolution stage emoji mapping refined
- Animated scales counter (optional: animate when value changes)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../storage/local_storage.dart';
import '../navigation/dragon_routes.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({super.key});

  /// Map evolution stage to emoji representation.
  /// Replaced with real art in Step 12.
  static const _evolutionEmojis = ['🥚', '🐣', '🐉', '🔥', '⚔️', '👑'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    final evolutionEmoji = _evolutionEmojis[
      profile.dragonEvolution.clamp(0, _evolutionEmojis.length - 1)
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.base,
        vertical: DragonSpacing.sm,
      ),
      child: Row(
        children: [
          // Dragon evolution indicator
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
            child: Center(
              child: Text(
                evolutionEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          const SizedBox(width: DragonSpacing.sm),

          // Dragon name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.dragonName,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _evolutionStageName(profile.dragonEvolution),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DragonColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
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
                  _formatScales(profile.totalScales),
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
              Navigator.of(context).push(
                DragonPageRoute.settingsTransition(
                  const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _evolutionStageName(int stage) {
    const names = ['Egg', 'Hatchling', 'Fledgling', 'Young Dragon', 'Adult Dragon', 'Elder Dragon'];
    return names[stage.clamp(0, names.length - 1)];
  }

  /// Format large scale counts with comma separators.
  String _formatScales(int scales) {
    if (scales < 1000) return '$scales';
    final str = scales.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
```

**Note:** The `SettingsScreen` import will need to be added. The `DragonPageRoute`
import references the new navigation helper created in [Section 13](#13-navigation--transitions).

---

## 7. Dragon Companion Placeholder

### `lib/hub/dragon_companion.dart`

Replace the stub. A simple animated widget that shows a pulsing/breathing egg
or dragon emoji based on the evolution stage. Uses `AnimationController` with a
sine-like breathing effect. Will be replaced with Rive animations in Step 12.

```dart
import 'package:flutter/material.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Animated dragon companion for the hub screen.
/// Shows a pulsing egg or dragon based on evolution stage.
/// Replaced with Rive animation in Step 12.
class DragonCompanion extends StatefulWidget {
  final int evolutionStage;

  const DragonCompanion({
    super.key,
    this.evolutionStage = 0,
  });

  @override
  State<DragonCompanion> createState() => _DragonCompanionState();
}

class _DragonCompanionState extends State<DragonCompanion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnimation;
  late final Animation<double> _glowAnimation;

  static const _evolutionEmojis = ['🥚', '🐣', '🐉', '🔥', '⚔️', '👑'];
  static const _evolutionSizes = [64.0, 72.0, 80.0, 88.0, 96.0, 104.0];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    // Subtle scale breathing: 1.0 -> 1.03
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Glow opacity pulsing: 0.1 -> 0.25
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.25).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.evolutionStage.clamp(0, _evolutionEmojis.length - 1);
    final emoji = _evolutionEmojis[stage];
    final size = _evolutionSizes[stage];

    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: Container(
            width: size + 32,
            height: size + 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: DragonColors.dragonGold
                      .withValues(alpha: _glowAnimation.value),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: size * 0.7),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 8. Daily Challenge Card Placeholder

### `lib/hub/daily_challenge_card.dart`

Replace the stub. Static placeholder card showing an example daily challenge.
Not functional yet — visual only. Will be connected to `DailyChallenge` service
in Step 9.

```dart
import 'package:flutter/material.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Static placeholder for the daily challenge card.
/// Becomes functional in Step 9.
class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DragonSpacing.base),
      decoration: BoxDecoration(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DragonColors.divider),
        // Subtle gold top border accent
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0, 0.15),
          colors: [
            Color(0x33F4A261), // dragonGold @ ~20%
            DragonColors.nightSurface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Icon(
                Icons.wb_sunny,
                color: DragonColors.dragonGold,
                size: 20,
              ),
              const SizedBox(width: DragonSpacing.sm),
              Text(
                l10n.dailyChallengeTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DragonColors.dragonGold,
                ),
              ),
              const Spacer(),
              // Streak indicator (placeholder)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DragonSpacing.sm,
                  vertical: DragonSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: DragonColors.fireOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: DragonColors.fireOrange,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '0',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: DragonColors.fireOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: DragonSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: DragonSpacing.sm),

          // Example tasks (static placeholder)
          _buildTask(context, l10n.dailyTaskExample1, false),
          const SizedBox(height: DragonSpacing.xs),
          _buildTask(context, l10n.dailyTaskExample2, false),
          const SizedBox(height: DragonSpacing.xs),
          _buildTask(context, l10n.dailyTaskExample3, false),

          const SizedBox(height: DragonSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: DragonSpacing.sm),

          // Reward line
          Row(
            children: [
              Text(
                l10n.dailyChallengeReward,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DragonColors.dragonGold,
                ),
              ),
              const Spacer(),
              Text(
                l10n.comingSoon,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DragonColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask(BuildContext context, String text, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_box : Icons.check_box_outline_blank,
          size: 18,
          color: completed ? DragonColors.emeraldFlame : DragonColors.disabled,
        ),
        const SizedBox(width: DragonSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: completed
                  ? DragonColors.textSecondary
                  : DragonColors.textPrimary,
              decoration: completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 9. Settings Screen Upgrade

### `lib/hub/settings_screen.dart`

Upgrade from the existing implementation. The current version already persists
toggles via `LocalStorage`. Add:
- Dragon name text field (editable, persists on change)
- "About Math Dragons" section with version
- Styled section headers
- Gradient background (already present)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../storage/local_storage.dart';
import '../core/haptics.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _musicEnabled;
  late bool _hapticsEnabled;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();
    _soundEnabled = profile.settings.soundEnabled;
    _musicEnabled = profile.settings.musicEnabled;
    _hapticsEnabled = profile.settings.hapticsEnabled;
    _nameController = TextEditingController(text: profile.dragonName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateSettings({
    bool? sound,
    bool? music,
    bool? haptics,
  }) {
    final storage = context.read<LocalStorage>();
    storage.updateProfile((p) => p.copyWith(
      settings: p.settings.copyWith(
        soundEnabled: sound,
        musicEnabled: music,
        hapticsEnabled: haptics,
      ),
    ));
    setState(() {
      if (sound != null) _soundEnabled = sound;
      if (music != null) _musicEnabled = music;
      if (haptics != null) _hapticsEnabled = haptics;
    });
  }

  void _onNameChanged(String name) {
    if (name.trim().isEmpty) return;
    final storage = context.read<LocalStorage>();
    storage.updateProfile((p) => p.copyWith(dragonName: name.trim()));
  }

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
            // ── Dragon Name Section ──
            _buildSectionHeader(context, l10n.dragonNameLabel),
            const SizedBox(height: DragonSpacing.sm),
            TextField(
              controller: _nameController,
              onChanged: _onNameChanged,
              style: const TextStyle(
                color: DragonColors.textPrimary,
                fontFamily: 'Nunito',
                fontSize: 16,
              ),
              maxLength: 20,
              decoration: InputDecoration(
                filled: true,
                fillColor: DragonColors.twilight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: DragonColors.amethyst),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: DragonColors.dragonGold,
                    width: 2,
                  ),
                ),
                counterStyle: const TextStyle(
                  color: DragonColors.textSecondary,
                ),
                hintText: l10n.dragonNameHint,
                hintStyle: TextStyle(
                  color: DragonColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),

            const SizedBox(height: DragonSpacing.lg),

            // ── Sound & Haptics Section ──
            _buildSectionHeader(context, l10n.settingsSoundSection),
            const SizedBox(height: DragonSpacing.sm),
            _buildToggle(
              context,
              icon: Icons.volume_up,
              title: l10n.sound,
              subtitle: l10n.soundDescription,
              value: _soundEnabled,
              onChanged: (v) => _updateSettings(sound: v),
            ),
            _buildToggle(
              context,
              icon: Icons.music_note,
              title: l10n.music,
              subtitle: l10n.musicDescription,
              value: _musicEnabled,
              onChanged: (v) => _updateSettings(music: v),
            ),
            _buildToggle(
              context,
              icon: Icons.vibration,
              title: l10n.haptics,
              subtitle: l10n.hapticsDescription,
              value: _hapticsEnabled,
              onChanged: (v) => _updateSettings(haptics: v),
            ),

            const SizedBox(height: DragonSpacing.lg),

            // ── About Section ──
            _buildSectionHeader(context, l10n.aboutTitle),
            const SizedBox(height: DragonSpacing.sm),
            Container(
              padding: const EdgeInsets.all(DragonSpacing.base),
              decoration: BoxDecoration(
                color: DragonColors.nightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DragonColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  const SizedBox(height: DragonSpacing.xs),
                  Text(
                    l10n.version('1.0.0'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: DragonSpacing.sm),
                  Text(
                    l10n.aboutDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: DragonColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DragonSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: DragonColors.dragonGold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: DragonSpacing.xs),
      decoration: BoxDecoration(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: DragonColors.textSecondary, size: 22),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
```

---

## 10. Game Shell Wrapper

### `lib/games/shared/game_shell.dart`

Replace the existing stub wrapper. The new game shell:
- Integrates with `SessionManager` (start/end game on lifecycle)
- Has a working pause overlay with Resume / Settings / Quit
- HUD shows scales counter (real from profile), level, and game title
- Accepts a `gameId` and `level` for session tracking
- Emits `GameStarted` event on mount

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../../core/session_manager.dart';
import '../../core/event_bus.dart';
import '../../core/game_events.dart';
import '../../core/haptics.dart';
import '../../storage/local_storage.dart';

/// Shared wrapper for all game screens.
/// Provides HUD, pause overlay, and session management.
class GameShell extends StatefulWidget {
  final String gameId;
  final String title;
  final Color accentColor;
  final int level;
  final Widget child;

  /// Optional callback when the user taps "Play Again" from the result screen.
  final VoidCallback? onPlayAgain;

  /// Optional callback when pause state changes.
  final ValueChanged<bool>? onPauseChanged;

  const GameShell({
    super.key,
    required this.gameId,
    required this.title,
    required this.accentColor,
    required this.child,
    this.level = 1,
    this.onPlayAgain,
    this.onPauseChanged,
  });

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Start the game session
    final session = context.read<SessionManager>();
    session.startGame(widget.gameId);

    // Emit GameStarted event
    final eventBus = context.read<EventBus>();
    eventBus.emit(GameStarted(
      gameId: widget.gameId,
      levelNumber: widget.level,
    ));
  }

  @override
  void dispose() {
    // End the game session
    final session = context.read<SessionManager>();
    session.endGame();
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    widget.onPauseChanged?.call(_isPaused);
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    widget.onPauseChanged?.call(false);
  }

  void _quitToHub() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DragonColors.nightSky,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content: HUD + game area
              Column(
                children: [
                  // Top HUD bar
                  _buildHUD(context, l10n, profile),

                  // Game content area
                  Expanded(child: widget.child),
                ],
              ),

              // Pause overlay
              if (_isPaused) _buildPauseOverlay(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD(
    BuildContext context,
    AppLocalizations l10n,
    PlayerProfile profile,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DragonSpacing.sm,
        vertical: DragonSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.8),
      ),
      child: Row(
        children: [
          // Back / pause button
          IconButton(
            icon: const Icon(Icons.pause, size: 22),
            color: DragonColors.textSecondary,
            onPressed: _togglePause,
            tooltip: l10n.pause,
          ),

          // Game title and level
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: widget.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.level(widget.level),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DragonColors.textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Scales counter
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DragonSpacing.sm,
              vertical: DragonSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: DragonColors.dragonGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.diamond,
                  color: DragonColors.dragonGold,
                  size: 14,
                ),
                const SizedBox(width: DragonSpacing.xxs),
                Text(
                  '${profile.totalScales}',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DragonColors.dragonGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: DragonColors.deepVoid.withValues(alpha: 0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Paused title
            Text(
              l10n.paused,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Cinzel',
              ),
            ),

            const SizedBox(height: DragonSpacing.xxl),

            // Resume button (primary / gold)
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: _resume,
                child: Text(l10n.resume),
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Settings button (secondary)
            SizedBox(
              width: 220,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                },
                child: Text(l10n.settings),
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Quit to hub button (secondary)
            SizedBox(
              width: 220,
              child: OutlinedButton(
                onPressed: _quitToHub,
                child: Text(l10n.quitToHub),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 11. Result Screen

### `lib/games/shared/result_screen.dart`

Replace the stub. Post-game results shown after a game round ends. This is the
"just one more" hook — the "Play Again" button is larger and more prominent than
"Back to Hub."

```dart
import 'package:flutter/material.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';

/// Data class holding game results to display.
class GameResults {
  final String gameId;
  final int score;
  final double accuracy; // 0.0 - 1.0
  final int streak;
  final int scalesEarned;
  final int stars; // 1-3
  final int levelNumber;
  final int problemsAttempted;
  final int problemsCorrect;

  const GameResults({
    required this.gameId,
    required this.score,
    required this.accuracy,
    required this.streak,
    required this.scalesEarned,
    required this.stars,
    required this.levelNumber,
    this.problemsAttempted = 0,
    this.problemsCorrect = 0,
  });
}

/// Post-game results screen.
/// "Play Again" is the primary CTA; "Back to Hub" is secondary.
class ResultScreen extends StatefulWidget {
  final GameResults results;
  final Color accentColor;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToHub;

  /// Optional encouraging message when the player was close to a goal.
  final String? encouragement;

  /// Optional suggestion to try a different game.
  final String? gameSuggestion;

  const ResultScreen({
    super.key,
    required this.results,
    required this.accentColor,
    required this.onPlayAgain,
    required this.onBackToHub,
    this.encouragement,
    this.gameSuggestion,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _starsController;
  late final AnimationController _scalesController;

  @override
  void initState() {
    super.initState();

    // Slide-up entrance
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Stars fill-in sequence
    _starsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scales counter
    _scalesController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Start animations in sequence
    _slideController.forward().then((_) {
      _starsController.forward().then((_) {
        _scalesController.forward();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _starsController.dispose();
    _scalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final r = widget.results;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: DragonColors.nightSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          border: Border.all(color: DragonColors.divider),
        ),
        padding: const EdgeInsets.all(DragonSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DragonColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: DragonSpacing.lg),

            // Title
            Text(
              r.stars >= 1 ? l10n.levelComplete : l10n.gameOver,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamily: 'Cinzel',
                color: r.stars >= 1
                    ? DragonColors.dragonGold
                    : DragonColors.fireOrange,
              ),
            ),

            const SizedBox(height: DragonSpacing.base),

            // Star rating (animated fill)
            _buildStars(),

            const SizedBox(height: DragonSpacing.lg),

            // Stats grid
            _buildStatsGrid(context, l10n, r),

            const SizedBox(height: DragonSpacing.base),

            // Scales earned (animated counter)
            _buildScalesEarned(context, l10n, r),

            // Encouragement text (if provided)
            if (widget.encouragement != null) ...[
              const SizedBox(height: DragonSpacing.base),
              Text(
                widget.encouragement!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DragonColors.dragonGold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Game suggestion (if provided)
            if (widget.gameSuggestion != null) ...[
              const SizedBox(height: DragonSpacing.sm),
              Text(
                widget.gameSuggestion!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DragonColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: DragonSpacing.lg),

            // Action buttons — "Play Again" is primary (larger)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: widget.onPlayAgain,
                icon: const Icon(Icons.replay),
                label: Text(l10n.playAgain),
              ),
            ),

            const SizedBox(height: DragonSpacing.sm),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: widget.onBackToHub,
                child: Text(l10n.backToHub),
              ),
            ),

            // Bottom safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, _) {
        final filledStars = (_starsController.value * widget.results.stars)
            .ceil()
            .clamp(0, 3);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isFilled = index < filledStars;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedScale(
                scale: isFilled ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  color: isFilled
                      ? DragonColors.dragonGold
                      : DragonColors.disabled,
                  size: 40,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    GameResults r,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.scoreLabel,
            value: '${r.score}',
            color: DragonColors.textPrimary,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.accuracyLabel,
            value: '${(r.accuracy * 100).round()}%',
            color: r.accuracy >= 0.9
                ? DragonColors.emeraldFlame
                : r.accuracy >= 0.7
                    ? DragonColors.dragonGold
                    : DragonColors.fireOrange,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            label: l10n.streakLabel,
            value: '${r.streak}',
            color: DragonColors.fireOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: DragonColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildScalesEarned(
    BuildContext context,
    AppLocalizations l10n,
    GameResults r,
  ) {
    return AnimatedBuilder(
      animation: _scalesController,
      builder: (context, _) {
        final displayScales = (_scalesController.value * r.scalesEarned).round();
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DragonSpacing.lg,
            vertical: DragonSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: DragonColors.goldShimmer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.diamond,
                color: DragonColors.deepVoid,
                size: 20,
              ),
              const SizedBox(width: DragonSpacing.sm),
              Text(
                '+$displayScales',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: DragonColors.deepVoid,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Usage Pattern (for future game implementations in Steps 4-7)

Games will show the result screen as a bottom sheet after a round ends:

```dart
// Inside a game widget, when the round ends:
void _showResults() {
  final results = GameResults(
    gameId: 'dragon_eggs',
    score: _score,
    accuracy: _correctCount / _totalCount,
    streak: _bestStreak,
    scalesEarned: _scalesThisRound,
    stars: _calculateStars(),
    levelNumber: _currentLevel,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (_) => ResultScreen(
      results: results,
      accentColor: DragonColors.dragonEggsAccent,
      onPlayAgain: () {
        Navigator.pop(context); // dismiss sheet
        _restartGame();
      },
      onBackToHub: () {
        Navigator.pop(context); // dismiss sheet
        Navigator.pop(context); // go back to hub
      },
      encouragement: _wasCloseToGoal ? "So close! Just 2 more to clear this level." : null,
      gameSuggestion: _session.shouldSuggestDifferentGame
          ? "Your dragon is hungry! Try Dragon's Feast for bonus scales."
          : null,
    ),
  );
}
```

---

## 12. Placeholder Game Screen Updates

### Update all 4 game placeholder screens

Each placeholder should use the **new** `GameShell` (with `gameId` and `level`
parameters) and include a demo button to test the result screen.

#### `lib/games/dragon_runes/dragon_runes_game.dart`

```dart
import 'package:flutter/material.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../../theme/dragon_colors.dart';
import '../../theme/dragon_spacing.dart';
import '../shared/game_shell.dart';
import '../shared/result_screen.dart';

class DragonRunesScreen extends StatelessWidget {
  const DragonRunesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GameShell(
      gameId: 'dragon_runes',
      title: l10n.dragonRunes,
      accentColor: DragonColors.runesAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: DragonColors.runesAccent.withValues(alpha: 0.5),
            ),
            const SizedBox(height: DragonSpacing.base),
            Text(
              l10n.gamePlaceholder,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DragonSpacing.xl),
            // Demo button to test result screen
            OutlinedButton(
              onPressed: () => _showDemoResults(context),
              child: Text(l10n.testResultScreen),
            ),
          ],
        ),
      ),
    );
  }

  void _showDemoResults(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ResultScreen(
        results: const GameResults(
          gameId: 'dragon_runes',
          score: 1250,
          accuracy: 0.87,
          streak: 8,
          scalesEarned: 35,
          stars: 2,
          levelNumber: 3,
          problemsAttempted: 15,
          problemsCorrect: 13,
        ),
        accentColor: DragonColors.runesAccent,
        onPlayAgain: () {
          Navigator.pop(context); // dismiss sheet
        },
        onBackToHub: () {
          Navigator.pop(context); // dismiss sheet
          Navigator.pop(context); // back to hub
        },
        encouragement: "So close to 3 stars! Just a bit more accuracy.",
      ),
    );
  }
}
```

Repeat the same pattern for the other 3 games:
- `fire_trail_game.dart` — uses `gameId: 'fire_trail'`, `fireTrailAccent`,
  `Icons.local_fire_department`, `l10n.fireTrail`
- `dragon_eggs_game.dart` — uses `gameId: 'dragon_eggs'`, `dragonEggsAccent`,
  `Icons.egg`, `l10n.dragonEggs`
- `dragons_feast_game.dart` — uses `gameId: 'dragons_feast'`, `dragonsFeastAccent`,
  `Icons.restaurant`, `l10n.dragonsFeast`

Each should have different demo result values so testing covers variety.

---

## 13. Navigation & Transitions

### `lib/navigation/dragon_routes.dart` (new file)

Custom page route transitions matching the Visual Design Guide section 10.2.

```dart
import 'package:flutter/material.dart';
import '../games/dragon_runes/dragon_runes_game.dart';
import '../games/fire_trail/fire_trail_game.dart';
import '../games/dragon_eggs/dragon_eggs_game.dart';
import '../games/dragons_feast/dragons_feast_game.dart';

/// Custom page route transitions for Math Dragons.
/// See Visual Design Guide section 10.2.
class DragonPageRoute {
  DragonPageRoute._();

  /// Hub -> Game: fade + scale up (400ms)
  static Route<T> gameTransition<T>({
    required BuildContext context,
    required String gameId,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return _gameScreenForId(gameId);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Forward: fade + scale up from 0.9
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final scaleIn = Tween<double>(begin: 0.9, end: 1.0).animate(fadeIn);

        // Reverse: fade + scale down to 0.9
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInCubic,
        );
        final scaleOut = Tween<double>(begin: 1.0, end: 0.95).animate(fadeOut);

        return FadeTransition(
          opacity: fadeIn,
          child: ScaleTransition(
            scale: scaleIn,
            child: ScaleTransition(
              scale: scaleOut,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Standard slide-in from right for non-game screens (settings, etc.)
  static Route<T> settingsTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        return SlideTransition(
          position: slideIn,
          child: child,
        );
      },
    );
  }

  /// Dialog appearance: fade + scale from 0.9 (250ms)
  static Route<T> dialogTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final scale = Tween<double>(begin: 0.9, end: 1.0).animate(curved);

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }

  /// Map a game ID to its screen widget.
  static Widget _gameScreenForId(String gameId) {
    switch (gameId) {
      case 'dragon_runes':
        return const DragonRunesScreen();
      case 'fire_trail':
        return const FireTrailScreen();
      case 'dragon_eggs':
        return const DragonEggsScreen();
      case 'dragons_feast':
        return const DragonsFeastScreen();
      default:
        throw ArgumentError('Unknown game ID: $gameId');
    }
  }
}
```

### Update `lib/app.dart` — Remove named routes for games

Since we now use custom `DragonPageRoute.gameTransition()` for game navigation,
the named routes for games in `app.dart` can be removed. Keep only the `/settings`
route (or migrate that too).

**Updated routes section in `app.dart`:**

```dart
// In the MaterialApp:
// Remove game routes — they now use DragonPageRoute.gameTransition()
// Keep settings for backward compatibility or also migrate it.
routes: {
  '/settings': (context) => const SettingsScreen(),
},
```

The game cards in `hub_screen.dart` now navigate using:
```dart
Navigator.of(context).push(
  DragonPageRoute.gameTransition(context: context, gameId: gameId),
);
```

---

## 14. Localization Updates

### Add new strings to `lib/l10n/app_en.arb`

Add these strings for Step 3 features:

```json
{
  "pause": "Pause",
  "@pause": { "description": "Pause button tooltip" },

  "paused": "Paused",
  "@paused": { "description": "Pause overlay title" },

  "resume": "Resume",
  "@resume": { "description": "Resume button on pause overlay" },

  "quitToHub": "Quit to Hub",
  "@quitToHub": { "description": "Quit game and return to hub" },

  "playAgain": "Play Again",
  "@playAgain": { "description": "Play another round button on result screen" },

  "levelComplete": "Level Complete!",
  "@levelComplete": { "description": "Title on result screen after completing a level" },

  "gameOver": "Game Over",
  "@gameOver": { "description": "Title on result screen when game ends without completing level" },

  "scoreLabel": "Score",
  "@scoreLabel": { "description": "Label for score stat on result screen" },

  "accuracyLabel": "Accuracy",
  "@accuracyLabel": { "description": "Label for accuracy stat on result screen" },

  "streakLabel": "Best Streak",
  "@streakLabel": { "description": "Label for streak stat on result screen" },

  "testResultScreen": "Test Result Screen",
  "@testResultScreen": { "description": "Demo button text on placeholder game screens" },

  "dailyChallengeTitle": "Today's Challenge",
  "@dailyChallengeTitle": { "description": "Title on the daily challenge card" },

  "dailyChallengeReward": "Reward: 25 scales",
  "@dailyChallengeReward": { "description": "Reward text on daily challenge card" },

  "dailyTaskExample1": "Score 200 in Dragon Runes",
  "@dailyTaskExample1": { "description": "Example daily challenge task 1" },

  "dailyTaskExample2": "Play Dragon Eggs",
  "@dailyTaskExample2": { "description": "Example daily challenge task 2" },

  "dailyTaskExample3": "Get a 5-streak in any game",
  "@dailyTaskExample3": { "description": "Example daily challenge task 3" },

  "dragonNameHint": "Name your dragon...",
  "@dragonNameHint": { "description": "Placeholder text for dragon name input" },

  "settingsSoundSection": "Sound & Haptics",
  "@settingsSoundSection": { "description": "Section header for sound settings" },

  "soundDescription": "Sound effects for game actions",
  "@soundDescription": { "description": "Subtitle text for sound toggle" },

  "musicDescription": "Background music in games and hub",
  "@musicDescription": { "description": "Subtitle text for music toggle" },

  "hapticsDescription": "Vibration feedback for answers and milestones",
  "@hapticsDescription": { "description": "Subtitle text for haptics toggle" },

  "aboutDescription": "Dragon-powered math games that are actually fun! Practice addition, subtraction, multiplication, and division through genuinely engaging gameplay.",
  "@aboutDescription": { "description": "About section description text" }
}
```

---

## 15. Unit Tests

### Test Files

Step 3 is UI-focused, so tests are lighter than Step 2. Focus on:
- Result screen data model
- Navigation route mapping
- Scales formatting

### `test/games/shared/result_screen_test.dart`

```dart
// Test cases:
// 1. GameResults default values are correct
//    - Verify all required fields are set, optional fields default to 0
//
// 2. GameResults with perfect score
//    - accuracy: 1.0, stars: 3, verify display calculations work
//
// 3. GameResults with zero values
//    - score: 0, accuracy: 0.0, stars: 0 — should not cause division errors
```

### `test/navigation/dragon_routes_test.dart`

```dart
// Test cases:
// 1. _gameScreenForId returns correct widget for each game ID
//    - 'dragon_runes' → DragonRunesScreen
//    - 'fire_trail' → FireTrailScreen
//    - 'dragon_eggs' → DragonEggsScreen
//    - 'dragons_feast' → DragonsFeastScreen
//
// 2. _gameScreenForId throws for unknown game ID
//    - 'unknown_game' → ArgumentError
```

### `test/hub/profile_bar_test.dart`

```dart
// Test cases:
// 1. Scales formatting
//    - 0 → "0"
//    - 999 → "999"
//    - 1000 → "1,000"
//    - 12345 → "12,345"
//    - 1234567 → "1,234,567"
//
// 2. Evolution stage name mapping
//    - 0 → "Egg"
//    - 1 → "Hatchling"
//    - 5 → "Elder Dragon"
//    - Out of range (6) → clamped to "Elder Dragon"
```

---

## 16. Verification Checklist

After completing this step, verify:

- [ ] **Hub pulls from GameRegistry** — games are driven by data, not hardcoded widgets
- [ ] **Game cards show real stats** — level, stars, world progress from PlayerProfile
- [ ] **Profile bar shows real data** — dragon name, evolution emoji, scales count
- [ ] **Dragon companion animates** — visible breathing/pulsing on hub screen
- [ ] **Daily challenge card visible** — static placeholder at bottom of hub
- [ ] **Settings: dragon name** — text field persists name across app restarts
- [ ] **Settings: about section** — shows app title (Cinzel), version, description
- [ ] **Game shell: pause overlay** — tap pause → overlay with Resume/Settings/Quit
- [ ] **Game shell: resume** — tap Resume → overlay dismisses, game visible
- [ ] **Game shell: quit** — tap Quit → returns to hub
- [ ] **Game shell: settings from pause** — tap Settings → navigates to settings, back returns to paused game
- [ ] **Game shell: HUD** — shows game title, level, and scales counter
- [ ] **Result screen: displays** — tap "Test Result Screen" on any placeholder game
- [ ] **Result screen: stars animate** — stars fill in one by one
- [ ] **Result screen: scales animate** — counter ticks up from 0 to earned amount
- [ ] **Result screen: Play Again** — gold button, larger than Back to Hub
- [ ] **Result screen: Back to Hub** — outline button, returns to hub
- [ ] **Transition: hub → game** — fade + scale up animation
- [ ] **Transition: game → hub** — fade + scale down animation
- [ ] **All strings localized** — no hardcoded English text anywhere
- [ ] **`flutter analyze` clean** — no errors or warnings
- [ ] **`flutter test` passes** — existing + new tests green
- [ ] **`flutter build apk --debug` succeeds**
- [ ] **Scrollable hub** — works on small screens without overflow

### Quick Smoke Test

```bash
cd math_dragons
set PATH=%USERPROFILE%\scoop\apps\flutter\current\bin;%PATH%
flutter analyze
flutter test
flutter build apk --debug
```

### Full Navigation Test

Walk through every path:

```
1. Hub → tap Dragon Runes card → see game shell with pause button → tap pause
   → see Resume/Settings/Quit → tap Resume → game visible → tap pause
   → tap Quit → back at hub

2. Hub → tap Fire Trail card → tap "Test Result Screen" → see animated results
   → tap "Play Again" → back at game → tap "Test Result Screen"
   → tap "Back to Hub" → back at hub

3. Hub → tap settings gear → see dragon name field, toggles, about section
   → change dragon name → go back → verify name shows in profile bar

4. Hub → verify dragon companion animates (pulsing)
   → verify daily challenge card visible at bottom (scroll down if needed)
   → verify all 4 game cards show Level 1, 0 stars
```

---

## Files Modified in This Step

| File | Action | Description |
|------|--------|-------------|
| `lib/hub/hub_screen.dart` | **Replace** | Data-driven hub with GameRegistry, scrollable, companion + daily card |
| `lib/hub/game_card.dart` | **Replace** | Stars, progress bar, tap animation, custom route navigation |
| `lib/hub/profile_bar.dart` | **Replace** | Real dragon name, evolution stage name, scales formatting |
| `lib/hub/dragon_companion.dart` | **Replace** | Animated pulsing dragon/egg widget |
| `lib/hub/daily_challenge_card.dart` | **Replace** | Static placeholder with example tasks |
| `lib/hub/settings_screen.dart` | **Replace** | Dragon name field, section headers, about section |
| `lib/games/shared/game_shell.dart` | **Replace** | Pause overlay, HUD with scales, SessionManager integration |
| `lib/games/shared/result_screen.dart` | **Replace** | Full post-game results with animations |
| `lib/games/dragon_runes/dragon_runes_game.dart` | **Modify** | Use new GameShell, add result screen demo |
| `lib/games/fire_trail/fire_trail_game.dart` | **Modify** | Use new GameShell, add result screen demo |
| `lib/games/dragon_eggs/dragon_eggs_game.dart` | **Modify** | Use new GameShell, add result screen demo |
| `lib/games/dragons_feast/dragons_feast_game.dart` | **Modify** | Use new GameShell, add result screen demo |
| `lib/navigation/dragon_routes.dart` | **Create** | Custom page route transitions |
| `lib/l10n/app_en.arb` | **Modify** | Add ~20 new localization strings |
| `lib/app.dart` | **Modify** | Remove game named routes (now use DragonPageRoute) |

---

## What This Step Does NOT Include

These are explicitly out of scope for Step 3:

- **Real game mechanics** — Steps 4-7 (games are still placeholder screens)
- **Level select screen** — Step 8 (comes with the progression system)
- **Achievement display** — Step 9
- **Functional daily challenges** — Step 9
- **Cloud sync / Firebase** — Step 10
- **IAP / store** — Steps 9 and 11
- **Real art assets** — Step 12 (still using emoji and Material Icons)
- **Sound effects or music** — Step 12
- **Haptic feedback wiring** — Step 12 (service exists but not called from UI yet)

Step 3 builds the **navigational skeleton** and **UI polish layer** that all future
steps plug into. After this step, adding a real game in Steps 4-7 means:
1. Create a Flame game widget
2. Wrap it in `GameShell`
3. Show `ResultScreen` when the round ends
4. Emit events to the `EventBus`

That's it — the shell, HUD, pause, results, and navigation are all handled.

---

*Document created: 2026-02-15*
*Status: Ready for implementation*
