# Math Dragons: Development Steps Master Plan

> Each step below is scoped to be completable in a single focused session.
> Each has (or will have) a dedicated planning document with full specs,
> user stories, and code examples.

---

## Step 1: Project Scaffold, Boilerplate & Visual Design System
**Planning Doc:** `STEP_01_SCAFFOLD_AND_DESIGN.md`
**Visual Guide:** `VISUAL_DESIGN_GUIDE.md`

**Scope:**
- Create the Flutter project (`math_dragons`)
- Full folder structure per architecture plan
- `pubspec.yaml` with all v1 dependencies
- Theme system (`dragon_theme.dart`, `dragon_colors.dart`)
- Core abstract classes / interfaces (contracts only, no implementation)
- Localization scaffold with initial `app_en.arb`
- App entry point (`main.dart`, `app.dart`) with theme + routing shell
- Complete visual design document (colors, typography, spacing, components)

**Deliverable:** A runnable Flutter app that shows a themed placeholder hub screen.

---

## Step 2: Core Services & Data Layer
**Planning Doc:** `STEP_02_CORE_SERVICES.md`

**Scope:**
- `PlayerProfile` data model (Dart classes with serialization)
- Local storage layer using Hive (init, read, write, migration)
- Event bus (streams-based, typed game events)
- Game registry (register/discover games)
- `MathDragonsGame` interface (the extensibility contract)
- `RewardService` (currency earning logic, no UI yet)
- `FactTracker` (per-fact accuracy model, no selection algorithm yet)
- `SessionManager` (session timing)

**Deliverable:** All core services wired up and testable. Unit tests for models and services.

---

## Step 3: Hub Screen & Navigation
**Planning Doc:** `STEP_03_HUB_SCREEN.md`

**Scope:**
- Hub screen layout (Dragon's Lair)
- Game card widgets (4 cards, tap to navigate)
- Profile bar (scales counter, dragon evolution indicator)
- Settings screen (sound, music, haptics toggles)
- Navigation flow (hub -> game shell -> game, and back)
- Game shell wrapper (shared HUD, pause overlay, back button)
- Result screen template (post-game, scales earned)
- Placeholder game screens (just show "Dragon Runes" etc. with a back button)

**Deliverable:** Full navigation flow with themed hub, settings, and game shell. Games are placeholder.

---

## Step 4: Game Port — Dragon Eggs (Bubble Pop)
**Planning Doc:** `STEP_04_DRAGON_EGGS.md`

**Scope:**
- Port Bubble Pop to Flame `FlameGame`
- Physics engine (gravity, collision, bounce, settling)
- Bubble/egg rendering with touch selection
- Equation assembly mechanic (tap 4 to form `a op b = c`)
- Submit/validate equation logic
- 6 difficulty tiers + division at level 5+
- Combo system with multiplier
- Spaced repetition fact tracking integration
- Wire up event bus emissions (AnswerGiven, LevelCompleted, etc.)
- Level progression (5 worlds)

**Deliverable:** Fully playable Dragon Eggs game within the app shell.

---

## Step 5: Game Port — Fire Trail (Math Snake)
**Planning Doc:** `STEP_05_FIRE_TRAIL.md`

**Scope:**
- Port Math Snake to Flame
- Grid-based movement with dragon head + flame trail
- Math problem display + answer tile spawning
- Touch d-pad controls
- Flame intensity mechanic (replaces lives)
- Speed progression across levels
- Wrap mode at higher levels
- 5 worlds of progression
- Event bus integration

**Deliverable:** Fully playable Fire Trail game within the app shell.

---

## Step 6: Game Port — Dragon Runes (Number Links)
**Planning Doc:** `STEP_06_DRAGON_RUNES.md`

**Scope:**
- Port Number Links to Flame
- Circular rune node layout with drag-to-connect
- Equation validation (order of operations)
- Hint system (3 per level)
- Streak bonus tracking
- Particle/spell effects on completion
- 5 worlds, 50+ levels
- Event bus integration

**Deliverable:** Fully playable Dragon Runes game within the app shell.

---

## Step 7: Game Port — Dragon's Feast (Merged Muncher)
**Planning Doc:** `STEP_07_DRAGONS_FEAST.md`

**Scope:**
- Port merged Muncher to Flame (SuperMooseMan architecture base)
- 5x5 grid navigation with dragon character
- Math-only categories (multiples, primes, composites, even/odd, etc.)
- Enemy AI (rival dragons/guardians)
- Power-ups (fire breath freeze, wings fly-over, shield)
- Dynamic category loading
- 5 worlds of progression
- Event bus integration

**Deliverable:** Fully playable Dragon's Feast game within the app shell.

---

## Step 8: Adaptive Difficulty & Progression System
**Planning Doc:** `STEP_08_DIFFICULTY_AND_PROGRESSION.md`

**Scope:**
- Fact tracker implementation (FactRecord, FactStatus enum)
- Problem selection algorithm (weighted buckets, spacing rules)
- Wire fact tracker into all 4 games
- Level advancement criteria (score + accuracy + attempts)
- Star rating system (1-3 stars)
- Dragon evolution system (6 stages with requirement checks)
- Evolution visual state management
- Cross-game progression tracking
- "40% cap" guardrail on needs-practice problems

**Deliverable:** All 4 games use adaptive difficulty. Dragon evolves. Stars track per level.

---

## Step 9: Currency, Achievements & Daily Challenges
**Planning Doc:** `STEP_09_REWARDS_AND_ACHIEVEMENTS.md`

**Scope:**
- Dragon Scales earning (per-action rates from plan)
- Scales spending UI (cosmetics store screen)
- Dragon color variants + accessories
- Achievement definitions (per-game, cross-game, milestone)
- Achievement unlock detection + popup UI
- Achievement display in profile
- Daily challenge generation (deterministic from date)
- Daily challenge tracking + streak counter
- Daily challenge card in hub
- "Just one more" session flow (play again vs. back to hub)

**Deliverable:** Full reward loop working. Earn scales, buy cosmetics, unlock achievements, daily challenges.

---

## Step 10: Firebase & Cloud Backend
**Planning Doc:** `STEP_10_FIREBASE.md`

**Scope:**
- Firebase project setup (Firestore + Auth)
- Anonymous auth (auto on first launch)
- Account upgrade flow (Google Sign-In)
- Firestore data model (users/{uid}/profile, factHistory, achievements)
- Offline-first local→cloud sync manager
- Conflict resolution (latest-write-wins per field, merge for additive data)
- Firestore security rules
- Background sync on connectivity change
- "Back up your progress" prompt at dragon stage 2

**Deliverable:** Cloud backup working. Play offline, sync when online. Optional Google sign-in.

---

## Step 11: Monetization & Compliance
**Planning Doc:** `STEP_11_MONETIZATION.md`

**Scope:**
- RevenueCat integration
- IAP products (Dragon Pack full unlock $4.99, Scale Pouch $0.99, Scale Hoard $2.99)
- Freemium content gating (free: Dragon Runes + Fire Trail, first 2 worlds;
  premium: all 4 games, all worlds, all evolution stages, all cosmetics)
- Parental IAP gate (multiplication problem)
- Privacy policy (hosted at apps.routeworks.app)
- Verify zero unapproved SDKs bundled (kids-only compliance)

**Deliverable:** IAP purchasable, freemium gating working, parental gate working, privacy policy live.

---

## Step 12: Art, Sound & Polish
**Planning Doc:** `STEP_12_ART_AND_POLISH.md`

**Scope:**
- AI-generated art assets (dragon evolutions, environments, game assets, UI)
- Apply themed art to hub and all games
- Dragon companion animation in hub (idle, reactions)
- Dragon evolution transition animations
- Haptic feedback implementation (all events from plan)
- Haptics toggle in settings
- Sound effects (correct/wrong/streak/level complete/etc.)
- Background music per game (royalty-free)
- Sound/music toggles in settings
- Transition animations between screens
- Loading states and micro-interactions
- Tutorial overlays (first play of each game)

**Deliverable:** Fully themed, polished app with art, sound, haptics, and tutorials.

---

## Step 13: Testing, Beta & Launch
**Planning Doc:** `STEP_13_LAUNCH.md`

**Scope:**
- Multi-device testing (3+ Android devices including budget)
- Performance profiling and optimization
- Google Play Console setup ($25 account)
- Internal testing track upload
- Store listing (title, descriptions, screenshots, feature graphic)
- IARC content rating questionnaire
- Closed beta via Discord + email
- Beta feedback collection and bug fixes
- Difficulty curve adjustments from tester feedback
- Production submission
- Post-launch monitoring plan

**Deliverable:** App live on Google Play Store.

---

## Step Dependencies

```
Step 1 (Scaffold)
  └─> Step 2 (Core Services)
       └─> Step 3 (Hub & Navigation)
            ├─> Step 4 (Dragon Eggs)     ─┐
            ├─> Step 5 (Fire Trail)      ─┤
            ├─> Step 6 (Dragon Runes)    ─┤ (these 4 are independent of each other)
            └─> Step 7 (Dragon's Feast)  ─┘
                      │
                      ▼
                Step 8 (Difficulty & Progression)
                      │
                      ▼
                Step 9 (Rewards & Achievements)
                      │
                      ▼
                Step 10 (Firebase)
                      │
                      ▼
                Step 11 (Monetization)
                      │
                      ▼
                Step 12 (Art & Polish)
                      │
                      ▼
                Step 13 (Launch)
```

Steps 4-7 (game ports) can be done in any order and are independent of each other.
All other steps are sequential.

---

*Created: 2026-02-14*
