# Haptics Integration Audit

## Overview

This document audits every location in the Math Dragons codebase where `HapticsService` methods are currently called versus where they **should** be called. The `HapticsService` is defined in `lib/core/haptics.dart` and provides 14 named haptic feedback methods. It is registered as a `Provider<HapticsService>` in `lib/app.dart` (line 163).

---

## HapticsService Method Inventory

| Method | Pattern | Description |
|---|---|---|
| `onCorrectAnswer()` | lightImpact | Satisfying tap on correct answer |
| `onWrongAnswer()` | heavyImpact | Sharp buzz on wrong answer |
| `onStreakMilestone()` | lightImpact x2 (100ms gap) | Celebratory double tap at streak milestones |
| `onLevelComplete()` | mediumImpact + lightImpact (100ms gap) | Positive sequence on level completion |
| `onDragonEvolution()` | selectionClick x3 (150ms gap) | Momentous triple click on evolution |
| `onAchievementUnlocked()` | heavyImpact + mediumImpact + lightImpact (100ms gaps) | Descending intensity on achievement |
| `onScalesEarned()` | selectionClick | Subtle click when scales awarded |
| `onButtonPress()` | selectionClick | Standard selection click for UI buttons |
| `onError()` | heavyImpact | Warning buzz for errors/invalid actions |
| `onEggSelect()` | selectionClick | Soft tap on egg selection (Dragon Eggs) |
| `onEggHatch()` | mediumImpact | Cracking impact on egg hatch (Dragon Eggs) |
| `onMunch()` | lightImpact | Quick light nom (Dragon's Feast) |
| `onRuneSelect()` | selectionClick | Light pulse on rune node select (Dragon Runes) |
| `onDirectionChange()` | selectionClick | Directional click (Fire Trail) |

---

## Current Call Sites (Implemented)

Only **1** location in the entire codebase currently calls any `HapticsService` method:

| Method | File | Line | Context |
|---|---|---|---|
| `onAchievementUnlocked()` | `lib/widgets/achievement_popup.dart` | 68 | Called via `context.read<HapticsService>()` when an achievement popup is shown |

---

## Missing Call Sites (Full Audit)

### 1. `onCorrectAnswer()` -- Missing Everywhere

| Game | File | Line(s) | Event / Handler | Notes |
|---|---|---|---|---|
| Fire Trail | `lib/games/fire_trail/fire_trail_game.dart` | 71 | `_onAnswerEaten()` when `isCorrect == true` | Callback from Flame game on correct gem eaten |
| Fire Trail | `lib/games/fire_trail/fire_trail_flame_game.dart` | 194-228 | `_handleGemEaten()` when `gem.isCorrect` | Inner Flame game -- no BuildContext access, must call from Flutter wrapper |
| Dragon Runes | `lib/games/dragon_runes/dragon_runes_game.dart` | 132 | `_onEquationValidated()` on `TargetMatchEquation` case | Correct equation matched |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_game.dart` | 78 | `_onTileEaten()` when `isCorrect == true` | Correct category tile eaten |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_flame_game.dart` | 417-428 | `_checkTileAtPosition()` when `isCorrect` | Inner Flame game -- no BuildContext, call from Flutter |
| Dragon Eggs | `lib/games/dragon_eggs/dragon_eggs_game.dart` | 51 | `_onEquationResult()` when `result.isCorrect` | Correct equation evaluated |
| Dragon Eggs | `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | 233 | `_onCorrectAnswer()` | Inner Flame game -- no BuildContext |

### 2. `onWrongAnswer()` -- Missing Everywhere

| Game | File | Line(s) | Event / Handler | Notes |
|---|---|---|---|---|
| Fire Trail | `lib/games/fire_trail/fire_trail_game.dart` | 71 | `_onAnswerEaten()` when `isCorrect == false` | Wrong gem eaten |
| Fire Trail | `lib/games/fire_trail/fire_trail_flame_game.dart` | 230-248 | `_handleGemEaten()` wrong branch | Inner Flame game |
| Fire Trail | `lib/games/fire_trail/fire_trail_flame_game.dart` | 154-161 | Wall collision in `_step()` | Inner Flame game |
| Dragon Runes | `lib/games/dragon_runes/dragon_runes_game.dart` | 154 | `_onEquationValidated()` on `InvalidEquation` case | Invalid equation attempted |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_game.dart` | 78 | `_onTileEaten()` when `isCorrect == false` | Wrong category tile eaten |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_flame_game.dart` | 435-444 | `_checkTileAtPosition()` wrong branch | Inner Flame game |
| Dragon Eggs | `lib/games/dragon_eggs/dragon_eggs_game.dart` | 51 | `_onEquationResult()` when `!result.isCorrect` | Wrong equation evaluated |
| Dragon Eggs | `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | 266 | `_onWrongAnswer()` | Inner Flame game |

### 3. `onStreakMilestone()` -- Missing Everywhere

| Game | File | Line(s) | Event / Handler | Notes |
|---|---|---|---|---|
| Fire Trail | `lib/games/fire_trail/fire_trail_game.dart` | 87-92 | `_onAnswerEaten()` when `streak % 5 == 0` | Already emits StreakAchieved event, should also call haptic |
| Dragon Runes | `lib/games/dragon_runes/dragon_runes_game.dart` | 147-152 | `_onEquationValidated()` when `_scoring.streak % 5 == 0` | Already emits StreakAchieved event |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_game.dart` | 93-98 | `_onTileEaten()` when `streak % 5 == 0` | Already emits StreakAchieved event |
| Dragon Eggs | `lib/games/dragon_eggs/dragon_eggs_game.dart` | 64-71 | `_onEquationResult()` when `_flameGame.streak % 5 == 0` | Already emits StreakAchieved event |

### 4. `onLevelComplete()` -- Missing Everywhere

| Game | File | Line(s) | Event / Handler | Notes |
|---|---|---|---|---|
| Fire Trail | `lib/games/fire_trail/fire_trail_game.dart` | 118-143 | `_onLevelComplete()` | Emits LevelCompleted + GameEnded, no haptic |
| Dragon Runes | `lib/games/dragon_runes/dragon_runes_game.dart` | 183-208 | `_onLevelComplete()` | Emits LevelCompleted, no haptic |
| Dragon's Feast | `lib/games/dragons_feast/dragons_feast_game.dart` | 123-142 | `_onLevelComplete()` | Emits LevelCompleted, no haptic |

Note: Dragon Eggs is an endless mode game without distinct level completions, so `onLevelComplete()` does not apply there.

### 5. `onDragonEvolution()` -- Missing

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/core/progression_manager.dart` | 64-67 | `checkEvolution()` when `req.isMet()` is true | Evolution stage incremented in storage. No haptic triggered. However, `ProgressionManager` does not hold a reference to `HapticsService`. Needs architectural decision (inject service or use EventBus). |

### 6. `onAchievementUnlocked()` -- IMPLEMENTED

| File | Line | Status | Notes |
|---|---|---|---|
| `lib/widgets/achievement_popup.dart` | 67-68 | **Implemented** | Called when achievement popup is shown via `context.read<HapticsService>()` |

### 7. `onScalesEarned()` -- Missing Everywhere

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/core/reward_service.dart` | 166-171 | `_awardScales()` | Central method that awards all scales. No BuildContext available -- `RewardService` is a pure Dart service. Needs architectural decision. |
| `lib/monetization/store_screen.dart` | 255-263 | `_purchase()` | Scales are spent (negative), could use `onScalesEarned()` or a dedicated haptic |

### 8. `onError()` -- Missing Everywhere

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/games/fire_trail/fire_trail_game.dart` | 158-163 | `_onWrongFlash()` | Red flash on wrong answer -- could use `onError()` |
| `lib/games/dragons_feast/dragons_feast_game.dart` | 175-179 | `_onWrongFlash()` | Red flash on wrong answer |
| `lib/games/dragon_runes/dragon_runes_flame_game.dart` | 239-241 | `_triggerShake()` | Shake animation on invalid equation -- inner Flame game |
| `lib/games/dragons_feast/dragons_feast_flame_game.dart` | 659-690 | `_handleCaught()` | Player caught by enemy guardian |
| `lib/hub/settings_screen.dart` | 74-76 | `_upgradeAccount()` on `UpgradeResult.failed` | Account upgrade failure notification |
| `lib/hub/backup_prompt.dart` | 133-135 | `_startUpgrade()` on `UpgradeResult.failed` | Backup failure notification |

### 9. `onButtonPress()` -- Missing Everywhere

All `onPressed` and `onTap` handlers for interactive buttons are missing haptic feedback. Major locations:

| File | Line(s) | Widget / Handler | Notes |
|---|---|---|---|
| **Hub Screen** | | | |
| `lib/hub/hub_screen.dart` | 99 | Achievements quick-access button `onTap` | `_QuickAccessButton` GestureDetector |
| `lib/hub/hub_screen.dart` | 113 | Dragon Store quick-access button `onTap` | `_QuickAccessButton` GestureDetector |
| `lib/hub/game_card.dart` | 67 | `_onTap()` -- game card navigation | Main game card tap handler |
| `lib/hub/profile_bar.dart` | 74 | Evolution indicator `onTap` | Opens evolution dialog |
| `lib/hub/profile_bar.dart` | 147-149 | Settings button `onPressed` | IconButton navigating to settings |
| `lib/hub/profile_bar.dart` | 245 | Evolution dialog Close button `onPressed` | TextButton in dialog |
| **Settings Screen** | | | |
| `lib/hub/settings_screen.dart` | 90 | Sign-out cancel button `onPressed` | Dialog TextButton |
| `lib/hub/settings_screen.dart` | 94 | Sign-out confirm button `onPressed` | Dialog FilledButton |
| `lib/hub/settings_screen.dart` | 200 | Sign-out button `onPressed` | TextButton in account section |
| `lib/hub/settings_screen.dart` | 208 | Sign-in button `onPressed` | FilledButton in account section |
| **Game Shell (Pause Menu)** | | | |
| `lib/games/shared/game_shell.dart` | 138 | Pause button `onPressed` | IconButton in HUD |
| `lib/games/shared/game_shell.dart` | 223 | Resume button `onPressed` | ElevatedButton in pause overlay |
| `lib/games/shared/game_shell.dart` | 234 | Settings button `onPressed` | OutlinedButton in pause overlay |
| `lib/games/shared/game_shell.dart` | 247 | Quit to Hub button `onPressed` | OutlinedButton in pause overlay |
| **Result Screen** | | | |
| `lib/games/shared/result_screen.dart` | 193 | Play Again button `onPressed` | ElevatedButton.icon |
| `lib/games/shared/result_screen.dart` | 206 | Back to Hub button `onPressed` | OutlinedButton |
| **Level Select Screen** | | | |
| `lib/games/shared/level_select_screen.dart` | 107 | Level tile `onTap` | GestureDetector on level tiles |
| **Store Screen** | | | |
| `lib/monetization/store_screen.dart` | 310 | Cosmetic tile `onTap` | Buy/equip cosmetic items |
| **Backup Prompt** | | | |
| `lib/hub/backup_prompt.dart` | 95 | Sign In button `onPressed` | FilledButton.icon |
| `lib/hub/backup_prompt.dart` | 112 | Not Now button `onPressed` | TextButton |
| **Dragon Runes** | | | |
| `lib/games/dragon_runes/dragon_runes_game.dart` | 385 | Hint button `onTap` | Uses hint, highlight nodes |
| `lib/games/dragon_runes/widgets/hint_button.dart` | 19 | HintButton `onTap` passthrough | GestureDetector wrapping hint icon |
| **Dragon Eggs** | | | |
| `lib/games/dragon_eggs/widgets/equation_display.dart` | 63 | Equals button `onTap` | InkWell triggering equation evaluation |

### 10. `onEggSelect()` -- Missing

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | 154-169 | `_onEggTapped()` | Called when an egg is tapped and accepted by the equation builder |
| `lib/games/dragon_eggs/components/egg_component.dart` | 165-167 | `onTapDown()` -> `onTapped?.call(this)` | Flame component tap -- no BuildContext. Must call from Flutter wrapper or pass service. |

Note: Dragon Eggs was built in Step 4 (which was skipped in sequence but the code exists). The `_onEggTapped` handler in the Flame game has no haptic call.

### 11. `onEggHatch()` -- Missing / Not Applicable

Dragon Eggs does not currently have an explicit "hatch" animation. However, the egg pop effect on correct answers (`_onCorrectAnswer` at line 240-245 of `dragon_eggs_flame_game.dart`) is the closest equivalent. If egg hatching is added in the future, `onEggHatch()` should be called there.

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | 240-245 | `_onCorrectAnswer()` -- egg pop | Could call `onEggHatch()` when eggs pop on correct answer |

### 12. `onMunch()` -- Missing

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/games/dragons_feast/dragons_feast_flame_game.dart` | 414 | `_checkTileAtPosition()` when `cell.isEaten = true` | Tile is consumed -- should trigger munch haptic |
| `lib/games/dragons_feast/dragons_feast_game.dart` | 78 | `_onTileEaten()` | Flutter callback when tile eaten -- best place to call |
| `lib/games/dragons_feast/dragons_feast_flame_game.dart` | 459-461 | `_triggerMunchEffect()` | Visual munch effect added -- haptic should accompany |

### 13. `onRuneSelect()` -- Missing

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| `lib/games/dragon_runes/dragon_runes_flame_game.dart` | 103-110 | `onPanStart()` when `nearest != null` | Node selected to start chain -- no BuildContext in Flame |
| `lib/games/dragon_runes/dragon_runes_flame_game.dart` | 121-127 | `onPanUpdate()` when `action != ChainAction.ignored` | Node extended into chain |
| `lib/games/dragon_runes/dragon_runes_game.dart` | 116-120 | `_onChainChanged()` | Flutter callback when chain changes -- best place to call |

### 14. `onDirectionChange()` -- Missing

| File | Line(s) | Event / Handler | Notes |
|---|---|---|---|
| **Fire Trail** | | | |
| `lib/games/fire_trail/fire_trail_game.dart` | 368 | D-pad `onDirection` callback | `DPadControls(onDirection: (dir) => _flameGame.setDirection(dir))` |
| `lib/games/fire_trail/fire_trail_game.dart` | 254-258 | Swipe detection in `_onSwipeUpdate()` | Swipe resolves to a direction change |
| `lib/games/fire_trail/fire_trail_game.dart` | 283-285 | Keyboard arrow handler `_handleKeyEvent()` | Key press resolves to direction |
| `lib/games/fire_trail/widgets/dpad_controls.dart` | 27, 37, 47, 57 | Individual D-pad button `onPressed` callbacks | Each calls `onDirection(Direction.xxx)` |
| **Dragon's Feast** | | | |
| `lib/games/dragons_feast/dragons_feast_game.dart` | 404 | D-pad `onDirection` callback | `FeastDPadControls(onDirection: (dir) => _flameGame.movePlayer(dir))` |
| `lib/games/dragons_feast/dragons_feast_game.dart` | 277-281 | Swipe detection in `_onSwipeUpdate()` | Swipe resolves to direction change |
| `lib/games/dragons_feast/dragons_feast_game.dart` | 306-308 | Keyboard arrow handler `_handleKeyEvent()` | Key press resolves to direction |
| `lib/games/dragons_feast/widgets/feast_dpad_controls.dart` | 27, 37, 47, 57 | Individual D-pad button `onPressed` callbacks | Each calls `onDirection(Direction.xxx)` |

---

## Summary Matrix

| HapticsService Method | Total Expected Call Sites | Currently Implemented | Missing |
|---|---|---|---|
| `onCorrectAnswer()` | 4 (one per game Flutter wrapper) | 0 | **4** |
| `onWrongAnswer()` | 4 (one per game Flutter wrapper) | 0 | **4** |
| `onStreakMilestone()` | 4 (one per game Flutter wrapper) | 0 | **4** |
| `onLevelComplete()` | 3 (Fire Trail, Dragon Runes, Dragon's Feast) | 0 | **3** |
| `onDragonEvolution()` | 1 (ProgressionManager) | 0 | **1** |
| `onAchievementUnlocked()` | 1 (AchievementPopupOverlay) | **1** | 0 |
| `onScalesEarned()` | 1 (RewardService or central location) | 0 | **1** |
| `onError()` | ~6 (wrong flashes, caught, failures) | 0 | **~6** |
| `onButtonPress()` | ~22 (all onPressed/onTap handlers) | 0 | **~22** |
| `onEggSelect()` | 1 (Dragon Eggs egg tap) | 0 | **1** |
| `onEggHatch()` | 1 (Dragon Eggs egg pop on correct) | 0 | **1** |
| `onMunch()` | 1 (Dragon's Feast tile eaten) | 0 | **1** |
| `onRuneSelect()` | 1 (Dragon Runes chain change) | 0 | **1** |
| `onDirectionChange()` | 2 (Fire Trail + Dragon's Feast D-pad/swipe) | 0 | **2** |
| **TOTAL** | **~52** | **1** | **~51** |

---

## Recommendations

### Priority 1: Game Event Haptics (High Impact, Low Effort)

These are the most important because they provide immediate tactile feedback during gameplay. Each game's Flutter `State` class already has a `BuildContext`, so `context.read<HapticsService>()` is accessible.

#### Fire Trail (`lib/games/fire_trail/fire_trail_game.dart`)

```dart
// In _onAnswerEaten(), around line 71:
void _onAnswerEaten(bool isCorrect, int score, int streak) {
  final haptics = context.read<HapticsService>();
  if (isCorrect) {
    haptics.onCorrectAnswer();
  } else {
    haptics.onWrongAnswer();
  }

  // Existing streak check
  if (isCorrect && streak > 0 && streak % 5 == 0) {
    haptics.onStreakMilestone();
    // ... existing StreakAchieved emit
  }
  // ... rest of method
}

// In _onLevelComplete(), around line 118:
void _onLevelComplete() {
  context.read<HapticsService>().onLevelComplete();
  // ... existing code
}

// In _onSwipeUpdate() or DPad handler, around line 254/368:
// When direction changes:
context.read<HapticsService>().onDirectionChange();
```

#### Dragon Runes (`lib/games/dragon_runes/dragon_runes_game.dart`)

```dart
// In _onEquationValidated(), around line 122:
void _onEquationValidated(EquationResult result, List<int> chainIndices) {
  final haptics = context.read<HapticsService>();

  setState(() {
    switch (result) {
      case TargetMatchEquation(:final target):
        haptics.onCorrectAnswer();
        // ... existing code
        if (_scoring.streak > 0 && _scoring.streak % 5 == 0) {
          haptics.onStreakMilestone();
          // ... existing StreakAchieved emit
        }

      case InvalidEquation():
        haptics.onWrongAnswer();
        // ... existing code
      // ...
    }
  });
}

// In _onLevelComplete(), around line 183:
void _onLevelComplete() {
  context.read<HapticsService>().onLevelComplete();
  // ... existing code
}

// In _onChainChanged(), around line 116:
void _onChainChanged(List<String> tokens) {
  if (tokens.isNotEmpty) {
    context.read<HapticsService>().onRuneSelect();
  }
  // ... existing setState
}

// In _useHint(), around line 216:
void _useHint() {
  final indices = _hintManager.useHint();
  if (indices != null) {
    context.read<HapticsService>().onButtonPress();
    // ... existing code
  }
}
```

#### Dragon's Feast (`lib/games/dragons_feast/dragons_feast_game.dart`)

```dart
// In _onTileEaten(), around line 78:
void _onTileEaten(bool isCorrect, int score, int streak) {
  final haptics = context.read<HapticsService>();
  haptics.onMunch(); // Always munch haptic
  if (isCorrect) {
    haptics.onCorrectAnswer();
  } else {
    haptics.onWrongAnswer();
  }

  if (isCorrect && streak > 0 && streak % 5 == 0) {
    haptics.onStreakMilestone();
    // ... existing StreakAchieved emit
  }
  // ... rest of method
}

// In _onLevelComplete(), around line 123:
void _onLevelComplete() {
  context.read<HapticsService>().onLevelComplete();
  // ... existing code
}

// Direction changes -- add to D-pad handler callback, around line 404:
// FeastDPadControls(onDirection: (dir) {
//   context.read<HapticsService>().onDirectionChange();
//   _flameGame.movePlayer(dir);
// }),
```

#### Dragon Eggs (`lib/games/dragon_eggs/dragon_eggs_game.dart`)

```dart
// In _onEquationResult(), around line 51:
void _onEquationResult(EquationResult result, int responseTimeMs) {
  final haptics = context.read<HapticsService>();
  if (result.isCorrect) {
    haptics.onCorrectAnswer();
    haptics.onEggHatch(); // Egg pops on correct -- closest to "hatch"
  } else {
    haptics.onWrongAnswer();
  }

  if (result.isCorrect && _flameGame.streak > 0 && _flameGame.streak % 5 == 0) {
    haptics.onStreakMilestone();
    // ... existing StreakAchieved emit
  }
  // ... rest of method
}
```

For `onEggSelect()`, since the tapping happens inside the Flame game (`_onEggTapped`), the cleanest approach is to add an additional callback:

```dart
// In DragonEggsFlameGame, add a callback:
final void Function()? onEggSelected;

// In _onEggTapped():
void _onEggTapped(EggComponent egg) {
  // ... existing code
  onEggSelected?.call();
}

// In dragon_eggs_game.dart initState:
_flameGame = DragonEggsFlameGame(
  // ... existing params
  onEggSelected: () => context.read<HapticsService>().onEggSelect(),
);
```

### Priority 2: UI Button Haptics (Medium Impact, Medium Effort)

The most effective pattern is to create a helper extension or wrapper:

```dart
// Suggested helper in lib/core/haptics.dart or a new file:
extension HapticButton on HapticsService {
  /// Wrap a callback with onButtonPress() haptic.
  VoidCallback withButtonPress(VoidCallback callback) {
    return () {
      onButtonPress();
      callback();
    };
  }
}
```

Then use throughout:

```dart
// Example in game_shell.dart pause button:
IconButton(
  onPressed: haptics.withButtonPress(_togglePause),
  // ...
)
```

Alternatively, add `onButtonPress()` at the start of each handler method. The key locations are:

1. `lib/games/shared/game_shell.dart` -- 4 buttons (pause, resume, settings, quit)
2. `lib/games/shared/result_screen.dart` -- 2 buttons (play again, back to hub)
3. `lib/games/shared/level_select_screen.dart` -- level tile taps
4. `lib/hub/game_card.dart` -- game card tap
5. `lib/hub/hub_screen.dart` -- 2 quick-access buttons
6. `lib/hub/profile_bar.dart` -- 2 interactive elements (evolution tap, settings)
7. `lib/hub/settings_screen.dart` -- 4 buttons (sign-in, sign-out, confirm, cancel)
8. `lib/hub/backup_prompt.dart` -- 2 buttons (sign in, not now)
9. `lib/monetization/store_screen.dart` -- cosmetic tile taps
10. `lib/games/dragon_eggs/widgets/equation_display.dart` -- equals button
11. `lib/games/dragon_runes/widgets/hint_button.dart` -- hint button

### Priority 3: Service-Level Haptics (Low Impact, Architectural Decision)

These involve pure Dart services that do not have `BuildContext`:

#### `onScalesEarned()` in RewardService

**Option A: Inject HapticsService into RewardService**

```dart
class RewardService {
  final HapticsService _haptics;
  // ...

  void _awardScales(int amount) {
    _storage.updateProfile((p) => p.copyWith(
          totalScales: p.totalScales + amount,
        ));
    lastScalesAwarded.value = amount;
    _haptics.onScalesEarned();
  }
}
```

**Option B: Listen to `lastScalesAwarded` from the UI and call haptics there**

This keeps services decoupled. Add a listener in `app.dart` or the hub screen that watches `rewardService.lastScalesAwarded` and calls `haptics.onScalesEarned()`.

#### `onDragonEvolution()` in ProgressionManager

**Option A: Inject HapticsService into ProgressionManager**

```dart
// In checkEvolution():
if (req.isMet(...)) {
  _storage.updateProfile((p) => p.copyWith(dragonEvolution: nextStage));
  evolutionStage.value = nextStage;
  _haptics.onDragonEvolution(); // <-- add
}
```

**Option B: Listen to `evolutionStage` ValueNotifier from the UI**

Add a listener in the hub screen or app scaffold that watches `progressionManager.evolutionStage` and calls `haptics.onDragonEvolution()` when the value increases.

### Priority 4: Error Haptics

Add `onError()` calls to:

1. Wrong answer flash handlers (Fire Trail `_onWrongFlash`, Dragon's Feast `_onWrongFlash`)
2. Player caught by enemy (Dragon's Feast `_handleCaught` -- needs callback to Flutter)
3. Account upgrade failure handlers in settings and backup prompt
4. Store purchase failure (insufficient scales) -- currently returns silently

---

## Architectural Notes

### Flame Games and BuildContext

The Flame game classes (`FireTrailFlameGame`, `DragonRunesFlameGame`, `DragonsFeastFlameGame`, `DragonEggsFlameGame`) do not have access to Flutter's `BuildContext` and therefore cannot use `context.read<HapticsService>()`. There are two patterns to solve this:

1. **Callback pattern (recommended)**: The Flame game already uses callbacks to the Flutter `State` wrapper (e.g., `onAnswerEaten`, `onTileEaten`). Add haptic calls in these Flutter-side callbacks where `BuildContext` is available.

2. **Injection pattern**: Pass `HapticsService` directly into the Flame game constructor. This creates tighter coupling but allows haptics to fire with zero latency.

For all games, **Pattern 1 is recommended** because:
- The Flutter wrappers already exist with the correct callback structure.
- It keeps Flame games decoupled from Flutter services.
- The sub-millisecond delay of going through a callback is imperceptible.

### Direction Change Deduplication

For `onDirectionChange()`, D-pad buttons, swipe gestures, and keyboard arrows all ultimately converge on the same direction-change call. To avoid triple-firing haptics, the best approach is to add the haptic call at the convergence point (e.g., in the `onDirection` callback passed to `DPadControls`), and also in the swipe and keyboard handlers. Since only one input method is active at a time, there is no duplication risk.

---

## Testing Considerations

When adding haptic calls, the existing test suite should not break because:

1. `HapticsService` checks `_storage.getProfile().settings.hapticsEnabled` before firing.
2. In test environments, `HapticFeedback.lightImpact()` etc. are platform channel calls that are silently ignored.
3. However, `context.read<HapticsService>()` will throw if the provider is not in the widget tree during tests.

**Recommendation**: In widget tests that create game screens, ensure `HapticsService` is included in the provider tree, or mock it. For unit tests of Flame game classes (which use the callback pattern), no changes are needed.
