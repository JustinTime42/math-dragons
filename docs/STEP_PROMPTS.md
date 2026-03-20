# Math Dragons: Step Prompts

> Copy-paste these prompts into a fresh Claude Code session to execute each step.
> Each prompt is self-contained — it tells the agent what to read, what to build,
> and how to verify the work.
>
> **Before each step:** Make sure the previous step compiles and runs cleanly.
> **After each step:** Run `flutter analyze` and `flutter run` to verify.

---

## Step 1: Project Scaffold, Boilerplate & Design System

```
Read these planning documents in my repo:
- docs/STEP_01_SCAFFOLD_AND_DESIGN.md
- docs/VISUAL_DESIGN_GUIDE.md
- docs/MOBILE_APP_PLAN.md

Your task: Execute Step 1 completely. Create the Flutter project and implement everything specified in STEP_01_SCAFFOLD_AND_DESIGN.md.

Specifically:
1. Create the Flutter project `math_dragons` in this repo's root directory
2. Set up the complete folder structure from section 3 of the step doc
3. Write pubspec.yaml with all dependencies (uncommented ones only — leave Firebase/IAP/etc commented out)
4. Download the 3 font families (Cinzel, Nunito, JetBrains Mono) from Google Fonts and place them in assets/fonts/
5. Implement the full theme system: dragon_theme.dart, dragon_colors.dart, dragon_spacing.dart — matching the Visual Design Guide exactly
6. Implement main.dart and app.dart with theme, localization, and routing
7. Implement the core interfaces: game_interface.dart, game_events.dart, game_registry.dart, player_profile.dart
8. Set up localization: l10n.yaml + app_en.arb with all strings from the step doc
9. Build the placeholder hub screen: hub_screen.dart, game_card.dart, profile_bar.dart
10. Build the game shell and 4 placeholder game screens
11. Build the stub settings screen
12. Create all stub files listed in the "Stub Files Checklist" section
13. Create empty asset directories with .gitkeep files

After building everything, run `flutter analyze` and fix any issues. Then run `flutter build apk --debug` to verify it compiles. Walk me through anything that doesn't work.
```

---

## Step 2: Core Services & Data Layer

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 2 section)
- docs/STEP_01_SCAFFOLD_AND_DESIGN.md (section 9, for the interfaces you're building on)
- MOBILE_APP_PLAN.md (sections 5, 6, and 8)

Also read the existing code in math_dragons/lib/core/ and math_dragons/lib/theme/ to understand what's already built.

Your task: Implement Step 2 — Core Services & Data Layer. Build the foundational services that all games and screens will depend on.

Specifically:
1. **PlayerProfile data model** (core/player_profile.dart): Full implementation with serialization (toJson/fromJson), including nested GameStats per game, settings, inventory. Use the Firestore data model from MOBILE_APP_PLAN.md section 6 as the schema reference. Make it immutable with copyWith.

2. **Local storage layer** (storage/local_storage.dart): Implement using Hive. Initialize boxes for player profile, fact history, achievements, and settings. Provide typed read/write methods. Include schema version tracking.

3. **Storage migration** (storage/migration.dart): Simple migration system that checks schema version and can run upgrade functions between versions. v1 is the only version for now, but the infrastructure must exist.

4. **Event bus** (core/game_events.dart already has the event types): Create an EventBus class using Dart streams. Games emit events, listeners subscribe by event type. Support multiple listeners per event type. Include dispose/cleanup.

5. **Game registry** (core/game_registry.dart): Flesh out the existing stub. Add methods to get all games, get by ID, get games sorted by last played, check if any games are registered. The registry should be a singleton or provided via Provider.

6. **RewardService** (core/reward_service.dart): Implement the currency earning logic from MOBILE_APP_PLAN.md section 9 "Dragon Scales Currency - Earning Rates" table. Subscribe to the event bus for AnswerGiven, StreakAchieved, LevelCompleted events. Calculate and award scales. Persist via local storage.

7. **FactTracker** (core/fact_tracker.dart): Implement the FactRecord and FactStatus model from MOBILE_APP_PLAN.md section 8. Track per-fact accuracy, streak, response time, and status (new/learning/familiar/mastered). Persist to Hive. Don't implement the problem selection algorithm yet — just the tracking/storage.

8. **SessionManager** (core/session_manager.dart): Track session start/end times, current game, session duration. Simple class that games call into when starting/ending.

9. **HapticsService** (core/haptics.dart): Implement the haptic feedback map from the Visual Design Guide section 11. Wrap Flutter's HapticFeedback with named methods (onCorrectAnswer, onWrongAnswer, onStreakMilestone, etc). Read the haptics-enabled setting before firing.

10. **Wire up Provider**: Set up a MultiProvider in app.dart that provides GameRegistry, RewardService, FactTracker, SessionManager, and the local storage layer to the widget tree.

Write unit tests for:
- PlayerProfile serialization round-trip
- RewardService scale calculations
- FactTracker status transitions
- EventBus subscription and emission

Run `flutter analyze` and `flutter test` when done. Fix any issues.
```

---

## Step 3: Hub Screen & Navigation

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 3 section)
- docs/VISUAL_DESIGN_GUIDE.md (sections 8.1-8.5 for component specs)
- MOBILE_APP_PLAN.md (section 13 "Hub Screen Design" and section 9 "Session Design")

Read the existing code in math_dragons/lib/hub/ and math_dragons/lib/core/ to understand what's already built.

Your task: Implement Step 3 — replace the placeholder hub with a polished, fully navigable hub screen, and build the game shell wrapper that all games will use.

Specifically:
1. **Hub screen overhaul** (hub/hub_screen.dart): Replace the simple placeholder with the full "Dragon's Lair" layout. Gradient background, animated feel. The 4 game cards in a 2-column grid. Pull game data from GameRegistry instead of hardcoded values. Add a daily challenge card placeholder at the bottom.

2. **Game card upgrade** (hub/game_card.dart): Match the Visual Design Guide section 8.2 "Game Card" spec. Show game title (Cinzel), description, level indicator, star rating (placeholder ★★☆), progress bar. Card border uses game's accent color. Add a subtle glow effect on the border. Tap animation (scale down slightly on press, bounce back).

3. **Profile bar upgrade** (hub/profile_bar.dart): Read actual PlayerProfile from local storage (via Provider). Show dragon evolution emoji/placeholder based on evolution stage. Show real scales count from profile. Dragon name display. Scales counter with JetBrains Mono font and gold styling per the design guide.

4. **Dragon companion placeholder** (hub/dragon_companion.dart): For now, a simple animated widget — a pulsing/breathing egg or dragon emoji that scales slightly on a loop (use AnimationController with a sine curve). This will be replaced with Rive animations in Step 12.

5. **Daily challenge card** (hub/daily_challenge_card.dart): Static placeholder card at bottom of hub showing "Today's Challenge" with example tasks. Styled per Visual Design Guide section 8.2 "Daily Challenge Card". Not functional yet — just visual.

6. **Settings screen** (hub/settings_screen.dart): Full settings with toggles for sound, music, haptics. Read/write settings to local storage. Dragon name text field. "About" section with app version. Style with the dragon theme (gradient background, proper switches using gold active color).

7. **Game shell wrapper** (games/shared/game_shell.dart): The shared wrapper every game screen uses. Includes:
   - Top HUD bar (back button, game title, scales counter, level/star display)
   - Pause overlay (tap pause → dim overlay with Resume/Settings/Quit buttons)
   - SessionManager integration (call start/end on mount/unmount)
   - Semi-transparent dark top bar that doesn't obscure game content

8. **Result screen** (games/shared/result_screen.dart): Post-game results screen shown after a game round. Display: score, accuracy %, streak, scales earned (with animated counter), star rating. Two buttons: "Play Again" (primary gold) and "Back to Hub" (secondary outline). "Play Again" is the larger, more prominent button per the "just one more" design.

9. **Placeholder game screens**: Update all 4 placeholder game screens to use the new GameShell wrapper properly. Each should show a centered message and a "Start Game" button that does nothing yet (it will trigger the real game in Steps 4-7).

10. **Navigation polish**: Implement the screen transition animations from the Visual Design Guide section 10.2. Hub→Game: fade + scale up. Game→Hub: fade + scale down. Use PageRouteBuilder for custom transitions. Replace named routes with these custom transitions.

Run `flutter analyze` and `flutter run` when done. The app should feel like a real (if content-empty) game launcher. Verify all navigation paths work: hub → each game → back, hub → settings → back, game → pause → resume/quit.
```

---

## Step 4: Game Port — Dragon Eggs (Bubble Pop)

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 4 section)
- MOBILE_APP_PLAN.md (sections 1.3, 7.3, 8, and 9)
- docs/VISUAL_DESIGN_GUIDE.md (section 9.3 for Dragon Eggs palette)

Read the existing HTML5 source code for the game being ported:
- BubblePop/bubble-pop.html (this is the complete original game — read ALL of it)

Read the existing Flutter code:
- math_dragons/lib/core/game_interface.dart (the contract to implement)
- math_dragons/lib/core/game_events.dart (events to emit)
- math_dragons/lib/core/fact_tracker.dart (to integrate with)
- math_dragons/lib/games/shared/game_shell.dart (wrapper to use)
- math_dragons/lib/games/shared/result_screen.dart (to show after game)

Your task: Port Bubble Pop to Flutter/Flame as "Dragon Eggs". This is the most physics-heavy game and serves as the proof-of-concept for the Flame engine.

Study the original bubble-pop.html source carefully. Understand every mechanic:
- How bubbles are generated and fall
- The physics (gravity, collision, bounce, settling)
- How the player selects 4 bubbles to form an equation
- How equations are validated
- The combo system and multiplier
- The difficulty tiers and auto-leveling
- The spaced repetition fact tracking

Then rebuild it in Flame:

1. **DragonEggsGame class**: Implement MathDragonsGame interface. Register with GameRegistry. Define all 5 worlds with levels per the plan.

2. **Physics engine**: Port the bubble physics to Flame components. Gravity, collision between eggs, bounce off walls and floor, settling behavior. Eggs should feel weighty and satisfying, not floaty.

3. **Egg rendering**: Flame SpriteComponent or custom-painted circles for now (real sprites come in Step 12). Color eggs by number range per the Visual Design Guide (cream for 1-3, blue for 4-6, green for 7-9, orange for 10-12). Operator eggs get a gold tint. Division eggs (level 5+) get purple.

4. **Touch interaction**: Tap to select eggs. Selected eggs highlight with a glow. Player taps 4 eggs in sequence to form "number operator number = number". Show the building equation at the top of the screen.

5. **Equation validation**: Validate the 4-egg sequence as a valid equation. Support +, -, ×. Add ÷ at level 5+ (integer results only). Show correct/wrong feedback with color flash and haptics.

6. **Combo system**: Port the combo multiplier from the original. Consecutive correct equations build combo. Show combo counter with escalating visual feedback.

7. **Difficulty tiers**: Implement all 6 tiers from the original, mapped to the 5-world structure. Auto-level every 10 correct answers within a session. Level 1: add 1-5, slow. Level 6: all ops 2-12, 1.4x speed.

8. **Division support**: At world 4+ (level 31+), division eggs appear. Only generate division problems with integer results (12÷3=4, never 7÷3). Division eggs are visually distinct (purple).

9. **Fact tracker integration**: On every answer, emit AnswerGiven events through the event bus. Track which math facts are presented and whether they were answered correctly. Use FactTracker to record results.

10. **Event bus integration**: Emit GameStarted, AnswerGiven, StreakAchieved, LevelCompleted, and GameEnded events at the appropriate times. RewardService will pick these up to award scales.

11. **Score and HUD**: Display score, current level, combo multiplier, and eggs hatched in the game shell HUD. Use JetBrains Mono for the score counter.

12. **Game flow**: Start → play → game over (or level complete) → show ResultScreen with stats → "Play Again" or "Back to Hub".

Test the game thoroughly on the emulator. It should be genuinely fun to play. The physics should feel satisfying. Adjust gravity, bounce, and fall speed until the eggs feel right.

Run `flutter analyze` when done.
```

---

## Step 5: Game Port — Fire Trail (Math Snake)

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 5 section)
- MOBILE_APP_PLAN.md (sections 1.2, 7.2, 8, and 9)
- docs/VISUAL_DESIGN_GUIDE.md (section 9.2 for Fire Trail palette)

Read the existing HTML5 source code:
- snakeGame.html (the complete original game — read ALL of it)

Read the existing Flutter code:
- math_dragons/lib/core/game_interface.dart
- math_dragons/lib/core/game_events.dart
- math_dragons/lib/games/shared/game_shell.dart
- math_dragons/lib/games/shared/result_screen.dart
- math_dragons/lib/games/dragon_eggs/ (reference for how Dragon Eggs was structured)

Your task: Port Math Snake to Flutter/Flame as "Fire Trail".

Study snakeGame.html carefully. Understand:
- Grid-based movement (21x21)
- Math problem display and answer tile placement
- Speed mechanics
- Life system
- Touch d-pad controls
- Wrap mode

Rebuild in Flame:

1. **FireTrailGame class**: Implement MathDragonsGame interface. Register with GameRegistry. Define 5 worlds with levels.

2. **Grid and movement**: Flame game with a grid overlay. Dragon head moves in 4 directions. Flame trail follows (replaces snake body). Movement is step-based, timed by speed setting.

3. **Dragon head**: Custom-painted or sprite dragon head facing the direction of movement. Flame trail segments behind it using the fire gradient (orange → gold → light yellow).

4. **Math problems**: Display the current math problem as large text in the center/top of the screen. Scatter answer tiles on the grid — one correct, several incorrect. Tiles are gem/crystal shapes.

5. **Flame intensity mechanic**: Replace the 5-life system with flame intensity. Start at 100%. Wrong answers reduce by 20%. Correct answers restore 10% (cap at 100%). At 0%, game over. Show as a flame bar on the HUD. Flame trail visually dims as intensity drops.

6. **Touch controls**: D-pad overlay in the bottom portion of the screen. 4 directional buttons, large touch targets (min 60dp each). Semi-transparent so they don't obscure the grid. Also support swipe gestures as an alternative input method.

7. **Speed and difficulty**: Speed increases with levels. World 1 is slow (3-4 steps/sec). World 5 is fast (12+ steps/sec). Configurable per level via DifficultyParams.

8. **Wrap mode**: At World 5, enable wrap mode — going off one edge appears on the opposite side. In earlier worlds, hitting the wall costs flame intensity.

9. **Answer generation**: Generate problems based on current level's allowed operations and number ranges. Place the correct answer and 3-5 wrong answers as gems on the grid. Wrong answers should be plausible (e.g., off by 1-3, or the result of a different operation).

10. **Event bus integration**: Emit all game events. Track facts via FactTracker.

11. **Visual effects**: Particle trail behind the dragon. Gem collection sparkle on correct answer. Red flash on wrong answer. Different flame colors unlock at higher levels (orange → blue → white).

12. **Game flow**: Start → play → game over (flame reaches 0%) → ResultScreen → Play Again / Hub.

Test on emulator. The game should feel smooth at all speed levels. The d-pad must be responsive without accidental inputs. Verify flame intensity mechanic is balanced — wrong answers sting but the game doesn't end too quickly.

Run `flutter analyze` when done.
```

---

## Step 6: Game Port — Dragon Runes (Number Links)

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 6 section)
- MOBILE_APP_PLAN.md (sections 1.1, 7.1, 8, and 9)
- docs/VISUAL_DESIGN_GUIDE.md (section 9.1 for Dragon Runes palette)

Read the existing HTML5 source code:
- numberLinks.html (the complete original game — read ALL of it)

Read the existing Flutter code:
- math_dragons/lib/core/game_interface.dart
- math_dragons/lib/games/shared/game_shell.dart
- math_dragons/lib/games/shared/result_screen.dart

Your task: Port Number Links to Flutter/Flame as "Dragon Runes".

Study numberLinks.html carefully. Understand:
- Circular node layout and how equations are formed
- Drag-to-connect mechanics
- Equation validation including order of operations
- The level generation algorithm (number families, valid equations)
- Hint system (3 per level)
- Streak bonuses
- How difficulty scales across 99+ levels

Rebuild in Flame:

1. **DragonRunesGame class**: Implement MathDragonsGame interface. Define 5 worlds (50+ levels). Port the level generation logic — each level defines number families, operations, and node count.

2. **Rune node layout**: Circular arrangement of nodes (numbers and operators). Nodes are circular with rune-stone styling. Inactive nodes are dark stone (#3D3D5C with purple border). Selected/active nodes glow purple.

3. **Drag-to-connect**: Touch a node → drag across adjacent nodes to form a chain. The chain builds an equation. Visual connection line draws between connected nodes using the purple→gold gradient. Validate the equation on release.

4. **Equation validation**: Port the equation parser from the original. Support order of operations (multiply/divide before add/subtract). Validate that the chain forms a valid equation (e.g., "3 + 2 = 5"). Show valid/invalid feedback.

5. **Level generation**: Port the algorithm that generates solvable puzzles. Given a level's parameters (number range, operations, family count), generate a set of nodes that contain at least one valid equation path. This is the most complex part — study the original carefully.

6. **Hint system**: 3 hints per level. Tapping the hint button highlights one node that's part of a valid equation path. Visual sparkle effect on the hinted node.

7. **Streak tracking**: Track consecutive correct equations. Display streak counter with fire visual. Emit StreakAchieved events at milestones (5, 10, 15...).

8. **Spell completion effect**: When an equation is completed correctly, play a "spell casting" visual effect — purple and gold particles burst from the equation, connection lines pulse brightly. The dragon companion (in the corner or top) reacts with a small animation.

9. **World progression**: Map the original 99+ levels to 5 themed worlds. World 1: addition 1-5. World 5: all four operations, numbers 2-15, complex layouts.

10. **Event bus integration**: Emit all standard game events.

11. **Game flow**: Level-based. Complete a level → show level results (score, stars, scales earned) → "Next Level" or "Back to Hub". Levels unlock sequentially. Star rating based on accuracy and time.

Test thoroughly. The drag-to-connect must feel smooth and responsive. Level generation must always produce solvable puzzles. Verify equation validation handles edge cases (order of operations, division).

Run `flutter analyze` when done.
```

---

## Step 7: Game Port — Dragon's Feast (Merged Muncher)

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 7 section)
- MOBILE_APP_PLAN.md (sections 1.4, 7.4, 8, and 9)
- docs/VISUAL_DESIGN_GUIDE.md (sections 9.4 and 9.5 for Dragon's Feast palette)

Read the existing HTML5 source code — read BOTH versions:
- SuperMooseMan/muncher.js (primary architecture base — read ALL)
- SuperMooseMan/MooseMan.js (player character — read ALL)
- SuperMooseMan/enemies.js (enemy AI — read ALL)
- SuperMooseMan/categories.json (category definitions — read ALL)
- MooseMuncher/muncher.js (original for comparison)
- MooseMuncher/enemies.js (original enemy AI for comparison)

Read the existing Flutter code:
- math_dragons/lib/core/game_interface.dart
- math_dragons/lib/games/shared/game_shell.dart
- math_dragons/lib/games/shared/result_screen.dart

Your task: Port the merged Muncher games to Flutter/Flame as "Dragon's Feast". Use SuperMooseMan as the architecture base. Drop ALL word categories — math only.

Study both Muncher implementations. Understand:
- 5x5 grid navigation and tile eating mechanics
- Enemy AI movement patterns and behavior
- Category system and how tiles are generated
- Power-up mechanics (freeze)
- Score system and level progression
- The differences between MooseMuncher and SuperMooseMan

Rebuild in Flame:

1. **DragonsFeastGame class**: Implement MathDragonsGame interface. Define 5 worlds.

2. **Grid system**: 5x5 grid of numbered tiles. Dragon character navigates with d-pad or swipe. Each cell shows a number. Some numbers match the current category, others don't.

3. **Math-only categories**: Implement ALL of these (drop every word category):
   - Multiples of 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
   - Prime numbers (within displayed range)
   - Composite numbers
   - Even numbers / Odd numbers
   - Perfect squares
   - Factors of N (e.g., "Factors of 24")
   - Numbers greater than N / less than N
   - Numbers in a range (e.g., "Between 10 and 25")

4. **Category display**: Current category shown prominently at the top of the screen. E.g., "Multiples of 7" or "Prime Numbers". Category changes each level.

5. **Dragon character**: Dragon sprite navigates the grid. Eating correct tiles: dragon glows, satisfying munch animation. Eating wrong tiles: dragon winces, red flash, score penalty.

6. **Enemy AI**: Port the enemy movement patterns. Enemies are rival dragons or treasure guardians. They move on the grid on a timer. Touching an enemy costs a life. Start with 3 lives.

7. **Power-ups**: Implement dragon abilities:
   - Fire breath (freezes all enemies for 5 seconds)
   - Wings (fly over enemies safely for 3 seconds)
   - Shield (invulnerability for 3 seconds)
   Power-ups spawn randomly on the grid as special tiles.

8. **Scoring**: +100 for correct eat, -50 for wrong eat, +500 for clearing a level (eating all correct tiles). Level complete when all matching tiles are eaten.

9. **Tile generation**: When a level starts, populate the 5x5 grid with numbers. Ensure a reasonable number of tiles match the category (8-12 out of 25). Remaining tiles should be plausible non-matches to require actual thinking.

10. **Level progression**: Category difficulty increases across worlds. World 1: even/odd, multiples of 2 and 5. World 5: mixed categories, faster enemies, harder number ranges.

11. **Touch controls**: D-pad overlay (same as Fire Trail) or swipe to move one cell at a time. Eating happens automatically when you move onto a tile.

12. **Event bus integration**: Emit AnswerGiven (correct/wrong eat), LevelCompleted, etc.

13. **Game flow**: Clear all matching tiles → level complete → results → next level or hub. Lose all lives → game over → results.

Test on emulator. Enemy AI should be challenging but fair. Categories must be correctly evaluated (especially primes and factors). Touch controls should feel crisp for grid-based movement.

Run `flutter analyze` when done.
```

---

## Step 8: Adaptive Difficulty & Progression System

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 8 section)
- MOBILE_APP_PLAN.md (sections 8 and 9 — read these VERY carefully, they are the core spec)
- docs/VISUAL_DESIGN_GUIDE.md (sections 8.5 for progress bars)

Read the existing Flutter code:
- math_dragons/lib/core/fact_tracker.dart (your data model from Step 2)
- math_dragons/lib/core/difficulty_engine.dart (stub to implement)
- math_dragons/lib/core/game_interface.dart (GameLevel, DifficultyParams)
- math_dragons/lib/core/player_profile.dart (dragon evolution fields)
- All 4 game implementations in math_dragons/lib/games/

Your task: Implement Step 8 — the adaptive difficulty engine and progression system. This is the educational backbone of the app.

Specifically:

1. **Problem Selection Algorithm** (core/difficulty_engine.dart): Implement the full algorithm from MOBILE_APP_PLAN.md section 8 "Problem Selection Algorithm":
   - Determine eligible fact pool for the current level
   - Categorize into 4 buckets: Needs Practice (40%), Reinforcing (30%), Mastered (15%), New (15%)
   - Weighted random selection from buckets
   - Spacing rules: no repeat within 3 problems, re-present incorrect facts within 5 problems, boost facts not seen in 7+ days
   - The 40% cap on "needs practice" — enforce this even when many facts are weak

2. **Wire into all 4 games**: Each game's problem generation should call the difficulty engine instead of purely random selection. The engine suggests which math facts to present; the game formats them into its specific gameplay (equations for Dragon Eggs, answer tiles for Fire Trail, etc.).

3. **Level advancement criteria** (shared/difficulty_config.dart): Implement the advancement logic:
   - Minimum score threshold (per game)
   - Minimum 60% accuracy
   - Minimum problems attempted (varies by level)
   - Star rating: 1★ = completed, 2★ = 75%+ accuracy AND above-median score, 3★ = 90%+ accuracy AND above-high score
   - Next level unlocks at 1 star

4. **Star tracking**: Persist star ratings per level per game in PlayerProfile. Display in game cards on hub and in level select (if you add a level select screen — recommended).

5. **Level select screen** (games/shared/level_select_screen.dart): New screen between hub and game. Shows all levels in the current world, grouped by world. Locked levels are dimmed. Unlocked levels show star rating. Tap to play. This gives players a sense of progression and lets them replay for better stars.

6. **Dragon evolution system**: Implement the 6-stage evolution from MOBILE_APP_PLAN.md section 9. Check requirements against actual player data:
   - Stage 1 (Hatchling): Level 3 in any game + 100 scales
   - Stage 2 (Fledgling): Level 8 in 2 games + 750 scales + 5 achievements
   - Stage 3 (Young Dragon): Level 15 in 3 games + 3000 scales + 15 achievements + 10 three-star levels
   - Stage 4 (Adult): Level 25 in all 4 + 10000 scales + 30 achievements + 30 three-star levels + 10 daily challenges
   - Stage 5 (Elder): Level 35 in all 4 + 25000 scales + 50 achievements + 60 three-star levels + 30-day streak + 100 mastered facts
   Store evolution stage in profile. Check on every profile update. Show evolution progress in hub.

7. **Evolution progress UI**: In the hub profile bar, show current evolution stage and progress toward next stage. Use the gold shimmer progress bar from the design guide. Show what requirements are remaining ("Need: Level 8 in 1 more game, 200 more scales").

8. **Difficulty rebalancing**: Review all 4 games' level definitions. Make sure World 1 of every game starts easy enough for a 7-year-old (addition 1-5, slow speeds, forgiving). Make sure World 5 challenges a 14-year-old. Adjust DifficultyParams as needed.

Write unit tests for:
- Problem selection algorithm (verify bucket weights, spacing rules, 40% cap)
- Level advancement criteria
- Dragon evolution requirement checking
- Star rating calculation

Run `flutter analyze` and `flutter test` when done.
```

---

## Step 9: Currency, Achievements & Daily Challenges

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 9 section)
- MOBILE_APP_PLAN.md (section 9 — ALL of it: currency, evolution, achievements, daily challenges, session design)
- docs/VISUAL_DESIGN_GUIDE.md (sections 8.2, 8.3, 10.3 for achievement/reward UI)

Read the existing Flutter code:
- math_dragons/lib/core/reward_service.dart (scales earning logic from Step 2)
- math_dragons/lib/core/player_profile.dart
- math_dragons/lib/hub/hub_screen.dart
- math_dragons/lib/games/shared/result_screen.dart

Your task: Implement Step 9 — the full reward loop. Earning, spending, achievements, and daily challenges.

Specifically:

1. **Scales earning verification**: Verify RewardService awards scales at the correct rates per the plan. Correct answer: 1-3 scales. Streak bonus: +1 per consecutive, cap +5. Level completion: 10-30. 3-star: +15. First time playing new game: 50. Daily challenge: 25. Ensure all these are working and tested.

2. **Scales spending — Cosmetics store** (monetization/store_screen.dart): Build the store screen accessible from the hub. Display purchasable dragon cosmetics:
   - Dragon color variants: 50-200 scales each (list 6-8 colors)
   - Dragon accessories (hat, scarf, crown, glasses): 100-500 scales each
   Show current scales balance. Purchase button disabled if insufficient scales. Purchase deducts scales and saves to profile. Show owned items with a checkmark.

3. **Dragon customization**: Let the player apply purchased cosmetics. Store equipped items in profile. Show equipped items on the dragon companion in the hub. For now, cosmetics are just color tints and emoji/icon accessories — real art comes in Step 12.

4. **Achievement system**: Implement the full achievement system:
   - Define all achievements from MOBILE_APP_PLAN.md section 9 (per-game, cross-game, milestone)
   - Achievement data model: id, title, description, category, requirement check function, scales reward, unlocked status
   - Achievement checker: runs after every game event, checks all locked achievements, unlocks any whose requirements are met
   - Persist unlocked achievements to local storage
   - Achievement popup: when an achievement unlocks during gameplay, show a banner notification that slides down from the top, holds for 2 seconds, slides up. Show badge icon, achievement name, and "+X scales" reward. Use haptics (triple tap).

5. **Achievement display screen**: New screen showing all achievements in 3 tabs (Per-Game, Cross-Game, Milestones). Unlocked achievements are full color with gold border. Locked achievements are greyed out with progress indicator if applicable.

6. **Daily challenge system** (core/daily_challenge.dart): Implement the lightweight v1 system:
   - Generate 2-3 tasks deterministically from the current date (use date as seed)
   - Task templates: "Score X in [Game]", "Complete N levels of [Game]", "Get a N-streak in any game", "Play N different games"
   - Track completion locally
   - Show in hub via the daily challenge card (already has a placeholder from Step 3)
   - Award 25 scales on completion + streak bonus (+5 per consecutive day, cap +25)
   - Track daily challenge streak in profile

7. **Daily challenge card** (hub/daily_challenge_card.dart): Replace the placeholder with a functional card. Show today's tasks with checkboxes. Completed tasks have green checkmarks. Show streak fire icon with streak count. Show reward amount.

8. **"Just one more" session flow**: Update the result screen (games/shared/result_screen.dart):
   - "Play Again" button is gold/primary, larger, and prominent
   - "Back to Hub" button is secondary/outline, smaller
   - If player nearly beat their high score or nearly completed a level, show encouraging text: "So close! Just 2 more correct answers to clear this level."
   - After 3 sessions in the same game, show a gentle suggestion: "Your dragon is hungry! Try Dragon's Feast for bonus scales."
   - Never force a game switch

9. **Animated scales counter**: When scales are earned, animate the counter in the HUD (number ticks up). Show "+X" floating text that fades upward. Gold particles fly toward the counter. Use the spring animation curve.

Run `flutter analyze` when done. Play through a few games and verify the full loop: play game → earn scales → see counter animate → check achievements → visit store → buy cosmetic → see it on dragon → check daily challenge progress.
```

---

## Step 10: Firebase & Cloud Backend

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 10 section)
- MOBILE_APP_PLAN.md (section 6 — ALL of it: offline-first architecture, auth flow, Firestore data model, costs)

Read the existing Flutter code:
- math_dragons/lib/storage/local_storage.dart
- math_dragons/lib/core/player_profile.dart
- math_dragons/lib/auth/ (stubs)
- math_dragons/lib/storage/ (stubs)
- math_dragons/pubspec.yaml (uncomment Firebase dependencies)

Your task: Implement Step 10 — Firebase integration with offline-first cloud sync.

Specifically:

1. **Firebase project setup**: Guide me through creating the Firebase project (or create the configuration files if I provide the project details). Uncomment the Firebase dependencies in pubspec.yaml. Add the Firebase configuration files (google-services.json for Android). Initialize Firebase in main.dart.

2. **Anonymous auth** (auth/anonymous_auth.dart): Auto-sign-in anonymously on first launch. Silent, invisible to user. Store the UID. If the user already has a local profile, link it to the anonymous UID. This should happen before the hub screen loads.

3. **Auth service** (auth/auth_service.dart): Wrapper around Firebase Auth. Expose current user, auth state stream, sign-in method (anonymous, Google). Handle auth state changes.

4. **Account upgrade** (auth/account_upgrade.dart): "Back up your progress" flow. User taps in settings → Google Sign-In → Firebase Auth links anonymous account to Google account. All existing Firestore data transfers automatically (same UID). Show success confirmation. Trigger this prompt gently after dragon reaches evolution stage 2.

5. **Firestore sync** (storage/cloud_sync.dart): Background sync between local Hive storage and Firestore. Follow the data flow diagram from the plan:
   - Local storage is ALWAYS written first
   - Cloud sync happens in background when connectivity is available
   - No feature degrades without internet
   - Queue writes during offline periods
   Use the Firestore data model from section 6: users/{uid}/profile, factHistory/, achievements/, dailyChallenges/

6. **Conflict resolution** (storage/sync_resolver.dart): "Latest write wins per field" for scalar fields. Merge strategy for additive data (achievements, fact history — union, never delete). Timestamp comparison for conflicts. Log conflicts for debugging.

7. **Connectivity handling**: Listen for connectivity changes. When coming online after being offline, trigger a sync. Show a subtle sync indicator in the profile bar (small cloud icon). Don't show errors for failed syncs — just retry later.

8. **Firestore security rules**: Write security rules that:
   - Users can only read/write their own data (users/{uid}/**)
   - Validate data shape on writes
   - Reject writes larger than reasonable limits
   - Allow anonymous users same access as linked users

9. **Profile backup prompt**: After reaching dragon evolution stage 2 (and not yet linked an account), show a non-blocking bottom sheet: "Your dragon is growing! Back up your progress so you never lose it." with a "Sign In" button and "Not Now" dismiss. Show at most once per week.

10. **Migration from local-only**: If a user has been playing offline and then connects, ensure all existing local data syncs up cleanly on first connection.

Test scenarios:
- Fresh install → anonymous auth → play → data in Firestore
- Turn off internet → play → turn on → data syncs
- Sign in with Google → verify data persists
- Install on second device → sign in → verify data restores

Run `flutter analyze` when done.
```

---

## Step 11: Monetization & Compliance

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 11 section)
- docs/GOOGLE_PLAY_PUBLISHING.md (Families Policy and Data Safety sections)
- MOBILE_APP_PLAN.md (sections 10, 11, and 12 — monetization, app store, legal/COPPA)

Read the existing Flutter code:
- math_dragons/lib/monetization/ (stubs)
- math_dragons/pubspec.yaml (uncomment IAP dependencies)

Your task: Implement Step 11 — in-app purchases, freemium content gating, parental gate, and kids-only compliance.

**Important: This is a kids-only app.** The app is listed in Apple's Kids Category
and Google Play's Families program as children-only. Revenue comes from freemium
IAP only.

Specifically:

1. **RevenueCat setup** (monetization/iap_manager.dart): Uncomment purchases_flutter in pubspec. Initialize RevenueCat. Configure products:
   - Dragon Pack (full unlock): $4.99, non-consumable. Unlocks all 4 games, all worlds, all evolution stages, all cosmetics + 500 bonus scales + exclusive fire dragon color.
   - Scale Pouch: $0.99, consumable. 200 scales.
   - Scale Hoard: $2.99, consumable. 750 scales.
   Check purchase status on app launch. Restore purchases support. Enable Family Sharing.

2. **Freemium content gating**: Implement a PremiumManager service that tracks whether the Dragon Pack has been purchased. Gate the following behind premium:
   - Dragon Eggs game (locked with a friendly "Unlock with Dragon Pack!" overlay)
   - Dragon's Feast game (same overlay)
   - Worlds 3-5 in Dragon Runes and Fire Trail (show lock icon, tapping shows upgrade prompt)
   - Dragon evolution stages 3-6 (Young Dragon through Elder Dragon)
   - Premium cosmetics (dragon colors beyond the 3 free ones, all accessories)
   - The free tier must feel generous: 2 full games, 2 worlds each (~20+ levels), 2 evolution stages, 3 colors, daily challenges for free games.

3. **Store screen** (monetization/store_screen.dart): Update the store from Step 9 to include IAP products alongside cosmetics. Show real prices from RevenueCat. The Dragon Pack should be prominently featured at the top with a clear value proposition ("Unlock all 4 games, all levels, and all dragon cosmetics!"). Purchase flow: tap → parental gate → confirmation → payment → fulfill.

4. **Parental IAP gate** (monetization/parental_gate.dart): Before ANY purchase, show a multiplication problem: "To continue, solve: 23 × 17 = ?" with a number input field. This prevents young children from making purchases. Must be solved correctly to proceed to payment. Generate a random hard multiplication each time (two 2-digit numbers).

5. **Privacy policy link**: Add a link to the privacy policy (https://apps.routeworks.app/math-dragons/privacy) in the settings screen. This is required by both app stores.

6. **SDK audit**: Verify that the final build contains NO unapproved SDKs, NO analytics SDKs, and NO crash reporting SDKs. Run `flutter pub deps` and check the full dependency tree. Any SDK that transmits data off-device must be verified as compliant with children-only app requirements.

Run `flutter analyze` when done. Test the parental gate. Test IAP purchase flow (use sandbox/test products). Test that gated content shows lock overlays correctly.
```

---

## Step 12: Art, Sound & Polish

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 12 section)
- docs/VISUAL_DESIGN_GUIDE.md (ALL of it — this is your primary reference)
- MOBILE_APP_PLAN.md (sections 7, 13, and the haptic table in section 13)

Read the existing Flutter code — skim all game implementations and the hub to understand what assets are needed where.

Your task: Implement Step 12 — replace all placeholder art with themed assets, add sound, add haptics, polish animations, and add tutorials.

This step is more creative than technical. The goal is to transform the functional app into something that FEELS like a polished game.

Specifically:

1. **AI-generated art assets**: Using the art style described in the plan and Visual Design Guide, generate (or help me generate prompts for) all required art:
   - Dragon companion at all 6 evolution stages (egg, hatchling, fledgling, young, adult, elder)
   - Hub background ("Dragon's Lair" cave with warm lighting)
   - 4 game environment thumbnails for game cards
   - Game-specific assets (rune stones, eggs, gems, dragon head for Fire Trail, feast items)
   - UI elements (custom buttons, card borders, badge frames)
   - App icon (512x512 for Play Store)
   For now, create placeholder colored shapes/gradients for anything we can't generate immediately. Document exactly what assets are still needed.

2. **Dragon companion in hub** (hub/dragon_companion.dart): Replace the emoji placeholder with an animated dragon. Use Rive or a simple sprite animation. Idle animation: gentle breathing (scale 1.0 → 1.02 on a 4-second cycle), occasional wing stretch. When a game card is tapped, dragon looks toward it briefly. Different appearance per evolution stage.

3. **Hub visual upgrade**: Apply the hub background art. Game portals should feel like environmental objects (glowing rune circle, fire tunnel, egg nest, feast table). Add floating ember particles drifting slowly across the hub. Subtle ambient glow pulsing.

4. **Haptic feedback**: Wire up the HapticsService from Step 2 into all games and UI. Call the appropriate haptic method at every event listed in the Visual Design Guide section 11. Verify haptics respect the settings toggle.

5. **Sound effects**: Add royalty-free sound effects for:
   - Correct answer (satisfying chime)
   - Wrong answer (soft buzz/thud)
   - Streak milestone (ascending tones)
   - Level complete (triumphant fanfare)
   - Achievement unlock (special jingle)
   - Scales earned (coin clink)
   - Egg crack/hatch (cracking + baby dragon chirp)
   - Dragon roar (evolution, special events)
   - Munch (Dragon's Feast correct eat)
   - Button tap (subtle click)
   Use flame_audio or audioplayers package. Respect sound toggle in settings.

6. **Background music**: Add ambient background tracks:
   - Hub theme (warm, magical, looping)
   - One track per game (matching the game's energy level)
   Royalty-free sources: Pixabay, freesound.org, incompetech.com. Music should loop seamlessly. Respect music toggle. Lower music volume during gameplay vs hub.

7. **Screen transition animations**: Implement the transitions from Visual Design Guide section 10.2:
   - Hub → Game: fade + scale up (400ms)
   - Game → Hub: fade + scale down (300ms)
   - Dialogs: fade in + scale from 0.9

8. **In-game animation polish**: For each game, add/improve:
   - Correct answer: green pulse + floating "+X" text + particles
   - Wrong answer: shake animation (3px, 3 cycles) + red flash
   - Streak counter: pulse on increment
   - Level complete: stars fill in sequence, score tallies up
   - Scales earned: gold particles fly to counter

9. **Result screen polish**: Animate the result screen entrance. Stars fill in one by one. Score counts up like a slot machine. Scales rain into the counter. Achievement popup if any unlocked during the session.

10. **Tutorial overlays**: First time a player enters each game, show a brief tutorial overlay:
    - 2-3 screens explaining the basic mechanic
    - Simple illustrations or annotated screenshots
    - "Got it!" button to dismiss
    - Never shown again after first dismissal (persisted to local storage)
    - Keep it SHORT — 3 screens max, clear and visual

11. **Loading states**: Add a brief, themed loading indicator for any transitions that take time. Dragon egg that pulses, or a flame that flickers. Never show a blank screen.

Run `flutter analyze` when done. Play through the entire app end-to-end. Every interaction should have visual + audio + haptic feedback. The app should feel ALIVE.
```

---

## Step 13: Testing, Beta & Launch

```
Read these planning documents in my repo:
- docs/DEVELOPMENT_STEPS.md (Step 13 section)
- MOBILE_APP_PLAN.md (sections 11, 12, 15, and 18 — publishing, compliance, beta, risks)

Read the existing Flutter code — you'll need the full picture for final QA.

Your task: Implement Step 13 — final testing, beta setup, store preparation, and launch.

This step is less about writing code and more about verifying, optimizing, and preparing for release.

Specifically:

1. **Performance audit**: Build a release APK (`flutter build apk --release`). Profile performance:
   - Measure startup time (target: < 3 seconds to hub)
   - Test all 4 games on an emulator configured as a budget device (2GB RAM, slower CPU)
   - Identify any frame drops or jank in games
   - Check APK size (target: < 50MB without large assets, < 100MB total)
   - Fix any performance issues found

2. **Device compatibility**: Test on at least 3 screen configurations:
   - Small phone (360dp width)
   - Standard phone (400dp)
   - Large phone (440dp+)
   Verify nothing is cut off, overlapping, or too small on any size.

3. **Offline testing**: Enable airplane mode and verify:
   - All 4 games play normally
   - Scores and progress save locally
   - No crashes or error messages about connectivity
   - When connectivity returns, data syncs

4. **Edge case testing**:
   - Rapid button tapping (no double-navigation, no double-purchases)
   - Rotate device (should be locked to portrait, verify)
   - Background/foreground cycling (app state preserved)
   - Low memory (does the app recover gracefully?)
   - First-ever launch flow (hub → first game)

5. **Kids-only compliance check**: Verify:
   - No unapproved SDKs bundled
   - Parental gate appears before all purchases
   - Privacy policy is accessible from settings
   - No data collection beyond anonymous profile + gameplay stats (local + optional cloud)
   - No external links within the app
   - No social features or user-to-user communication
   - Freemium gating works correctly (locked games show friendly upgrade prompt)

6. **Google Play Console setup**: Walk me through:
   - Creating the developer account ($25)
   - Creating the app listing
   - Writing the store description (short: 80 chars, full: up to 4000 chars)
   - What screenshots I need and at what sizes
   - Feature graphic requirements (1024x500)
   - IARC content rating questionnaire answers
   - Families program declaration
   - Setting up IAP products in the console
   - Configuring the internal testing track

7. **Build and sign**: Create a release build:
   - Generate a signing key (keystore)
   - Configure signing in build.gradle
   - Build a signed AAB (`flutter build appbundle --release`)
   - Verify the AAB works on a test device via bundletool

8. **Internal testing track**: Upload the signed AAB to the internal testing track. Share the link for testing. This doesn't require Google review and is available in minutes.

9. **Store listing assets**: Help me create or list exactly what I need:
   - App icon (512x512) — should already exist from Step 12
   - Feature graphic (1024x500)
   - Screenshots (at least 2, ideally 6-8 showing all games + hub)
   - Short description (80 chars): "Dragon-powered math games that are actually fun!"
   - Full description (4000 chars): cover all 4 games, adaptive difficulty, dragon evolution, age range
   - Privacy policy URL

10. **Beta plan**: Set up the closed testing track. Write a beta tester recruitment message for Discord/email. Create a feedback form or template for bug reports. List the key things to test with beta users (from the plan).

11. **Pre-launch checklist**:
    - [ ] All 4 games playable and fun
    - [ ] No crashes on any tested device
    - [ ] No unapproved SDKs in dependency tree
    - [ ] IAP purchases work (sandbox)
    - [ ] Freemium gating works (locked content shows upgrade prompt)
    - [ ] Parental gate works on all purchases
    - [ ] Privacy policy live and linked
    - [ ] Offline mode fully functional
    - [ ] Cloud sync working
    - [ ] All text localized (no hardcoded strings)
    - [ ] Performance acceptable on budget devices
    - [ ] APK/AAB size reasonable
    - [ ] Signing key backed up securely

Help me go through this checklist systematically. Flag anything that's not ready.
```

---

_Created: 2026-02-14_
