# Spec: Adaptive Practice Across All Four Games

- Status: DRAFT, awaiting Justin's approval of the interface proposals (section 7) and open questions (section 12)
- Date: 2026-10-26
- Owner: Justin
- Gates: every adaptivity claim in `marketing/` (see `marketing/PLAN.md:70`, `:77`) and `docs/store-listing.md:7`, `:26`, `:134`
- Hierarchy: this spec constrains the interfaces in section 7, which constrain the tests in section 9, which constrain the implementation in section 10. Nothing in section 7 may be implemented until Justin approves it.

---

## 0. Decisions log

- 2026-10-26 (Justin): **Phase 1 approved**, which approves interface proposals **I-1, I-2, I-3, I-8**. Other proposals remain proposals.
- 2026-10-26 (Justin): **Q11 answered: publish each claim as its phase ships** (after merge, release, and the claim's section 9.5 tests pass).

## 1. Goal

Make Math Dragons choose practice items for each player from that player's own history, in all four games, so that these statements are literally true:

1. Missed facts are recorded accurately, under one key per fact, from every game.
2. A missed fact comes back sooner and more often than an unmissed one, until the player gets it right on the first try twice in a row.
3. Weak facts are always mixed with facts the player already knows, and never make up more than 40% of a session.
4. Facts that were known but have not been seen for a while come back for review on a schedule (1, 3 and 7 days by mastery band).

Visible level progression (worlds, levels, number ranges, operations, speed) stays fixed, as the design docs require (`docs/MOBILE_APP_PLAN.md:585` "Levels are NOT adaptive"). Adaptation happens inside the level's eligible content. Whether levels themselves should adapt is open question Q3.

## 2. Marketing claims

### 2.1 Claims this spec must make true (literal wording for marketing)

| ID | Claim (use verbatim) | True after |
|---|---|---|
| C1 | "Math Dragons keeps track of the math facts your kid misses." | Phase 1 |
| C2-FT | "In Fire Trail, facts your kid misses come back more often until they get them right." | Phase 1 |
| C2 | "It brings missed facts back more often, mixed in with facts your kid already knows, until they get them right." | Phase 2 (Fire Trail), Phase 3 and 4 (Dragon Eggs, Dragon Runes) |
| C3 | "Facts your kid already knows come back for a quick review every few days, so they stick." | Phase 2 |
| C4 | "All four games adapt to your kid." / "Every game adapts practice to your kid." | Phase 5 plus the sign-off in Phase 6 |
| C5 | "Dragon's Feast brings back the numbers your kid sorts wrong." | Phase 5 |

Each claim is only publishable after its phase is merged, released, and the claim-specific tests in section 9.5 pass. C4 also requires the Phase 6 checklist.

### 2.2 Claims that must NOT be made, even after this work

- Anything saying the **level or difficulty adjusts automatically** ("adjusts to your child's skill level", "difficulty that grows with you", "adaptive levels"). Levels are fixed checkpoints and advance on completion (`lib/core/reward_service.dart:129`). This kills the current store-listing lines `docs/store-listing.md:7`, `:26`, `:134` unless Q3 is answered "yes" and built.
- "AI", "machine learning", "smart tutor", "knows exactly what your child needs".
- "Personalized curriculum" or "learning path". The curriculum (what content each level allows) is the same for every child.
- "Proven", "research-backed results", "improves test scores", or any outcome claim. The design follows research guidance (spacing, interleaving, a cap on weak items), but there is no outcome evidence for this app.
- "Teaches" new concepts. The games give practice and feedback; there is no instruction.
- "Tracks speed" or "builds fluency". Response times are recorded but Fire Trail sends 0 today (`lib/games/fire_trail/fire_trail_game.dart:83`) and nothing in this spec uses speed for selection beyond a minor tie-break.
- Any **parent report or dashboard**. No UI reads fact history (`FactTracker.getStatusCounts()` has no caller in `lib/`).
- "Dragon's Feast practices your kid's times tables / facts". Feast practices number properties (even, multiples, primes, squares).
- Anything implying progress follows the child across devices or survives uninstall. History lives in a local Hive box (`lib/storage/local_storage.dart:11`, `:53`).
- Unverified social proof such as "Teachers and homeschooling families use Math Dragons" (`docs/store-listing.md:42`). Out of scope here, but it sits next to the adaptivity lines.

---

## 3. Current state (verified 2026-10-26)

### 3.1 Infrastructure

**Provider wiring.** One `FactTracker` and one `DifficultyEngine` are created in `lib/app.dart:70-73` and `:85`, and provided at `lib/app.dart:167` and `:171`. The engine is a single app-wide instance, so its in-memory session state is shared by every game.

**FactTracker** (`lib/core/fact_tracker.dart`)
- Subscribes to every `AnswerGiven` on the `EventBus` (`:149`) and writes one `FactRecord` per normalized key (`:153-163`).
- Key normalization (`:166-172`) only strips spaces, maps `×`→`x` and `÷`→`/`, and removes `=`. It does not strip the result, does not map `−` (U+2212), and does not canonicalize operand order. It never rejects a key.
- `FactRecord` (`:27-...`, Hive typeId 3, fields 0-7) stores presented, correct, streak, last presented, last incorrect, average and total response time. Every `AnswerGiven` counts as a new presentation, including retries on the same prompt.
- `FactRecord.status` (`:69-74`): mastered = 90% accuracy with 5+ presentations. Used by `masteredFactCount` (`:185`), which feeds evolution stage 5 (`lib/core/progression_manager.dart:236`, `:261`) and achievements (`lib/core/achievement_tracker.dart:133`).
- There is no per-operation accuracy record anywhere.

**DifficultyEngine** (`lib/core/difficulty_engine.dart`) has two independent selection algorithms:
1. `selectNext` (`:40-75`), the legacy bucket algorithm from `docs/MOBILE_APP_PLAN.md:627-631`: weighted random over needs-practice 40% / reinforcing 30% / mastered 15% / new 15% (`:170-175`), empty-bucket redistribution, a 40% clamp on the needs-practice weight (`:199-213`), no-repeat within 3 (`:21`, `:64-70`), a 3x weight for facts not seen in 7+ days (`:232-258`, uses `DateTime.now()` directly, not injectable). The "re-present incorrect within 5" queue (`:43-45`, `:117-138`) only works if someone calls `recordIncorrect` (`:87`). **Nothing in `lib/` calls `recordIncorrect`**, so this path is dead in production.
2. `selectBlueprint` (`:82-84`), which delegates to `ProblemScheduler` (`lib/games/shared/problem_generation.dart:195-388`). This is a strict-priority lane scheduler, not weighted random: correction (score 100) > due review (80+) > needs practice (70+) > new (55) > reinforcement (40+) > maintenance (20+) (`:252-260`, `:351-372`). Mastery bands come from `MasteryEstimate` (`:84-121`): mastered needs 8+ attempts, 90%+ accuracy and a Wilson lower bound of 0.60 or more (`:140-151`). Spaced review intervals: 1 day for needs practice, 3 for reinforcing, 7 for mastered (`:129-138`). A fact "needs correction" while `lastIncorrect != null && currentStreak == 0` (`:123-127`).

What the scheduler actually computes, and its gaps:
- **The 40% cap leaks.** Only `correction` and `needsPractice` reasons count toward it (`:383-386`) and are filtered by it (`:322-325`). A weak fact that is due for review gets reason `dueReview` (`:293-295`), which is neither counted nor filtered.
- **Known facts are starved.** Because lanes are strict priority, maintenance (mastered) facts are chosen only when every higher lane is empty. In a level that still has new facts, a player sees weak, new, new, weak, new... and no known facts, which contradicts "mix weak and known".
- **Correction never fires in direct-prompt games.** In Fire Trail the player must eventually eat the right gem, so a miss is always followed by a correct retry on the same prompt. The retry sets `currentStreak` to 1 (`lib/core/fact_tracker.dart` `recordCorrect`), which clears `needsCorrection`. One miss plus one retry also leaves the fact at 2 attempts, which is still the `newFact` band (`problem_generation.dart:145`). So a single miss gives the fact no extra priority at all.
- The first selection in a session ignores the cap (`:311`).
- `ProblemScheduler` accepts injected `Random` and `now` (`:205-211`), but `DifficultyEngine` does not expose `now` or `GenerationConstraints` (`difficulty_engine.dart:26-33`).
- Session state is reset only by `DifficultyEngine.resetSession()`, which only Dragon's Feast calls (`lib/games/dragons_feast/dragons_feast_flame_game.dart:172`), on every Feast level start. That also wipes any other game's session state.

**SessionManager** (`lib/core/session_manager.dart`) tracks app and game timing only. It has no link to the engine.

**ProgressionManager** (`lib/core/progression_manager.dart`) handles evolution and game suggestions. It reads `masteredFactCount` only. It does not select levels.

**Level advancement.** `RewardService._onLevelCompleted` sets `currentLevel = levelNumber + 1` on any `LevelCompleted` (`lib/core/reward_service.dart:129-131`). `DifficultyProfile` (`lib/core/game_interface.dart:124-132`, getter `:28`) is declared by every registration and read by nothing.

**Tests today.** `test/core/difficulty_engine_test.dart` covers `selectNext` only. `test/games/shared/problem_scheduler_test.dart` has 4 scheduler tests. `test/core/fact_tracker_test.dart` covers `FactRecord` only, not the event handler. `test/games/fire_trail/problem_manager_test.dart:207-244` tests the engine path of `ProblemManager` in isolation. No test pumps any game screen, so nothing checks that the real screens pass the engine. The 81 tests in these files pass (run 2026-10-26).

### 3.2 Per game

| Game | Engine used? | Evidence | Fact keys recorded |
|---|---|---|---|
| Dragon Eggs | **No.** `DragonEggsFlameGame` declares `difficultyEngine` (`dragon_eggs_flame_game.dart:35`, `:81`) and never reads it. `DragonEggsScreen` does not pass one (`dragon_eggs_game.dart:53-63`). | Board numbers: 20% of number spawns are a component of a uniformly random pool fact (`systems/egg_field_planner.dart:279-288`), otherwise random in range (`:291-301`). Helper spawns pick the best completion candidate by board fit, random among ties, excluding the last 12 solved (`:178-238`, `:167-172`). | Correct format (`models/equation.dart:37-47`). But see the bugs below. |
| Fire Trail | **No.** `ProblemManager` has a working engine path (`systems/problem_manager.dart:88-100`) and `FireTrailFlameGame` forwards the engine (`fire_trail_flame_game.dart:28`, `:77`, `:110`, `:353`), but `FireTrailScreen._createGame` never passes it (`fire_trail_game.dart:59-70`). | Every problem comes from `_generateRandom` (`problem_manager.dart:102-144`). Even with an engine, `_generateUniqueProblem` asks the engine once and falls back to random on an answer collision (`:247-260`), and a vetoed selection is still recorded by the scheduler. | Correct format (`problem_manager.dart:38-46`). `responseTimeMs: 0` always (`fire_trail_game.dart:83`) though `getResponseTimeMs()` exists (`fire_trail_flame_game.dart:357`). A wrong gem and the correct retry are both counted as presentations. |
| Dragon Runes | **One fact per level**, via legacy `selectNext` (`dragon_runes_game.dart:72-87`). | The fact only seeds the first number family, clamped to range (`systems/level_generator.dart:102-116`). `_pickTargets` (`:242-279`) picks targets randomly, so the seeded fact may not even be a target. | **Corrupt.** It emits `target.displayText` such as `"2 + 3 = 5"` (`dragon_runes_game.dart:150`), which normalizes to `"2+35"`; subtraction keeps U+2212 (`"7−34"`). Invalid chains are recorded as a fact literally named `"invalid"` (`:173`). These keys never match any pool fact, so Runes history is invisible to selection. |
| Dragon's Feast | **Bias only.** Asks `selectNext` 5 times for add/multiply facts (`dragons_feast_flame_game.dart:156-173`, pool `:731-738`) and seeds up to 30% of correct tiles with those operands and results (`systems/board_generator.dart:127-139`, respawn `:206-215`), then resets the shared engine (`:172`). | The child sorts numbers by property; the arithmetic facts used for bias are unrelated to what the child is doing. | **Wrong unit.** Keys are `"<category>:correct"` / `"<category>:wrong"` (`dragons_feast_game.dart:94`). `"even:correct"` becomes a "mastered fact" after 5 correct eats and inflates `masteredFactCount`. The number that was mis-sorted is not recorded. |

**Related data bugs found during verification:**
- **Dragon Eggs accepts non-integral division as correct.** `EquationResult` uses integer division (`models/equation.dart:32-33`) and only checks `result > 0` (`:20-21`), so building `7 ÷ 2 = 3` scores as correct and records fact `"7/2"`.
- **Dragon Eggs records nonsense equations as misses**, for example `"3-7"` (result ≤ 0). Harmless to selection (never in a pool) but it pollutes history.

### 3.3 Verdict on the 2026-10-26 review claims

All four claims hold. Corrections and additions:
- Dragon Eggs is worse than "random": the flame game already has an unused `difficultyEngine` field, and the planner's only fact-aware behavior is a 20% uniform draw.
- Simply passing the engine into Fire Trail (the one-line fix proposed in `marketing/guides/compliance-and-strategy.review.md:30`) makes weak-accuracy facts preferred, but **does not make a single missed fact come back**, because of the retry problem above. Phase 1 has to fix first-attempt accounting too.
- Dragon Runes "uses the engine for one fact per level" understates the problem: its history never feeds selection at all because of the corrupt keys.
- Dragon's Feast also corrupts the mastered-fact count used for evolution.

---

## 4. Docs and code disagreements (flagged, not resolved)

Each of these needs a decision on which side is the source of truth. This spec assumes the code is current and the docs are stale, except where noted.

1. `README.md:35` claims "per-operation accuracy tracking, adaptive level selection, performance windows". None of these exist.
2. `README.md:249` links `docs/STEP_08_ADAPTIVE_DIFFICULTY.md`, which does not exist (the file is `STEP_08_DIFFICULTY_AND_PROGRESSION.md`).
3. `docs/STEP_08_DIFFICULTY_AND_PROGRESSION.md:95-99` acceptance criteria say all four games call the engine. False for Eggs and Fire Trail.
4. STEP_08 `:1337-1385` describes an `EggSpawner.focusFact` field and "tier advances every 10 correct (1-6)". The code has no `focusFact` and uses 50 per-level tiers (`lib/games/dragon_eggs/models/difficulty_config.dart:26`, `:85`).
5. STEP_08 `:176` and `:1863` say the engine is stateless. It holds session state (`difficulty_engine.dart:16-19`, `ProblemScheduler` `:201-203`).
6. STEP_08 rule "re-present incorrect within 5" relies on `recordIncorrect`, which nothing calls.
7. Two selection algorithms coexist: `MOBILE_APP_PLAN.md:627-636` and STEP_08 describe weighted buckets (`selectNext`), while `MATH_PROBLEM_GENERATION_DESIGN.md:73-90` describes the lane scheduler (`selectBlueprint`). Runes and Feast use the first, Fire Trail's dormant path uses the second. This spec standardizes on a revised scheduler (section 6.1) and deprecates `selectNext`.
8. `MATH_PROBLEM_GENERATION_DESIGN.md:100` lists "difficulty band" in a blueprint; `ProblemBlueprint` (`problem_generation.dart:169-181`) has none. `:90` (interleaving) and `:34` (no runs of weak facts in high-pressure games) are not implemented. `:49-54` (`property.*` components) is not implemented. `:154` (a target from the scheduled family) is not guaranteed.
9. `MOBILE_APP_PLAN.md:650-656` and STEP_08 `:100` say advancing needs 60% accuracy and a minimum score. Code advances on any `LevelCompleted` (`reward_service.dart:129`), and Dragon Eggs forces at least 1 star on completion (`dragon_eggs_flame_game.dart:400`).
10. `fact_tracker.dart:26` documents keys like `"prime:17"` and `"mult3:12"`; Feast actually writes `"even:correct"`.
11. Two definitions of "mastered": `FactRecord.status` (5+ presentations, 90%+) vs `MasteryEstimate` (8+ attempts, 90%+, Wilson ≥ 0.60). Open question Q6.
12. Age range: `spec.md:12`, `:21` say 5-9 (`spec.md` is the landing-page brief, not an app spec), `docs/store-listing.md:42` says 6-12, STEP_08 US-8.7 says 7-14, `marketing/PLAN.md:84` decided 5-12. Not blocking here.
13. `DifficultyProfile` is part of the `MathDragonsGame` contract (`game_interface.dart:28`) but unused.

---

## 5. Definitions

These terms are used normatively in sections 6 and 9.

- **Practice item**: the smallest thing a game asks about. Arithmetic: a canonical `MathFact` key (`"7x8"`, `"13-4"`, `"12/3"`, `"3+5"`; commutative operands smallest first, `lib/games/shared/math_problem.dart:13-22`). Number property: `"<categoryId>:<n>"`, for example `"mult_3:12"`, `"prime:17"`.
- **Eligible pool**: the items the current level allows (`FactPool.forLevel`, `lib/games/shared/difficulty_config.dart:5-24`, or the Feast category range). Selection never leaves the pool.
- **Presentation**: one prompt shown for one item. Retries on the same prompt are part of the same presentation.
- **First attempt**: the first answer given to a presentation. Only first attempts change mastery counts.
- **Miss**: a first attempt that is wrong.
- **Open miss**: an item whose most recent miss has not yet been followed by `cleanAnswersToCloseMiss` (default 2) consecutive correct first attempts. With first-attempt accounting this equals `lastIncorrect != null && currentStreak < 2`.
- **Weak (W)**: open miss, or mastery band `needsPractice` (3+ attempts, accuracy < 70%), regardless of whether it is also due for review. Weak items count against the weak cap.
- **New (N)**: fewer than 3 attempts and not weak.
- **Known (K)**: band `reinforcing` or `mastered` and not weak.
- **Due (D)**: a known item past its review interval (1 / 3 / 7 days by band, existing `isDueForReview`). D is a subset of K.
- **Session**: one game screen's lifetime, from opening the game to leaving it, across all levels played in that sitting. Owned by one game.
- **Selection**: one item handed to a game by its session. A vetoed candidate is not a selection.

---

## 6. Target behavior

### 6.1 Shared selection policy (engine)

Replaces the strict-priority lanes in `ProblemScheduler.select` (`problem_generation.dart:213-265`). All numbers below are the defaults of `GenerationConstraints` (section 7, I-6) and may be overridden per game.

Let `n` be selections so far in the session, `w` weak selections so far, `nw` new selections so far.

**Hard rules** (must hold for every selection when an alternative exists; tested as invariants):

- H1 **Scope**: every selected item is in the eligible pool and passes the game's `accept` predicate.
- H2 **No repeat**: an item is not selected again within the last `repeatWindow` (3) selections.
- H3 **Weak cap**: a weak item may be selected only if `w + 1 <= floor(weakCap * (n + 1))` with `weakCap = 0.40`. Consequence: `w <= floor(0.40 * n)` after every selection, and the first selection of a session is never weak. This closes the due-review leak because weakness is judged by item state, not by due reason.
- H4 **No weak runs**: no more than `maxConsecutiveWeak` (1) weak selections in a row.
- H5 **New cap**: a new item may be selected only if `nw + 1 <= ceil(newCap * (n + 1))` with `newCap = 0.30`, unless no weak-eligible or known item is available.
- H6 **Cool-down**: an item with `maxSessionMissesPerItem` (3) misses in this session is not selected again in this session. It returns through spaced review on a later day.
- H7 **Determinism**: given the same pool, records, constraints, `Random` seed and `now()`, the sequence of selections is identical.

**Ordering** (which item, among those the hard rules allow):

1. If a weak pick is allowed (H3, H4): take the open miss whose miss is oldest and whose gap since its last presentation is at least `repeatWindow`. If no open miss is eligible, take the weak item with the lowest accuracy. Ties broken by `Random`.
2. Otherwise, if any due item exists: the most overdue one (largest `now - lastPresented` beyond its interval). Ties by `Random`.
3. Otherwise, choose between new and known by weighted random: new weight 0.35 (if H5 allows), known weight 0.65. Within known, weight items not seen for 7+ days 3x (carries over the stale boost from `difficulty_engine.dart:232-258`), slower average response time breaks ties.
4. If nothing is allowed (every remaining item is blocked by H2-H6), relax in this order: H5, H2, H4, H3. H1 is never relaxed. Record which rule was relaxed in `SelectionTrace` (I-5) for tests.

**Return-after-miss guarantee** (the core of claim C2): with one open miss in an otherwise non-weak pool, the missed item is selected again after at least `repeatWindow` (3) and at most `correctionMaxGap` (5) other selections, as long as it stays eligible. It keeps coming back on that rhythm until it is closed (2 clean first attempts) or cooled down (H6).

**Struggle guard** (prevents kids getting stuck): track first-attempt accuracy over the last `struggleWindow` (8) outcomes in the session. If it falls below 60%, set the effective weak cap to 0.20 and prefer known items in step 3 (known weight 0.85). Exit when accuracy over the last 8 is 75% or more. This adjusts difficulty inside the level without changing the level.

**Mixing guarantee** (claim C2 "mixed in with facts your kid already knows"): when the pool contains at least 3 known items, every window of 10 consecutive selections contains at least 3 known selections. Follows from H3 (≤ 4 weak per 10) and H5 (≤ 3 new per 10) plus step 3's known weight; it is tested directly.

**Spaced reintroduction across sessions** (claim C3): unchanged review intervals (`problem_generation.dart:129-138`), now reached through step 2 for known items and step 1 for weak ones.

**Outcome input**: sessions learn outcomes from `AnswerGiven` events for their own `gameId` on the `EventBus` (the same events `FactTracker` already consumes), so games report once. Mastery state is still read from `FactTracker` records. Alternative (explicit `recordOutcome` calls) is Q9.

### 6.2 Fire Trail

Mechanics that constrain it: each level pre-places `answerGemCount` (4 to 6) answer gems at once, one per problem, and the active prompt is the first remaining gem's problem (`fire_trail_flame_game.dart:268-283`, `problem_manager.dart:207-241`). Answers on the grid must be unique. The player cannot leave a prompt without eating its gem, unless the flame dies.

Target:
- FT-a `FireTrailScreen` passes the engine (Phase 1) and later a `PracticeSession` (Phase 2) into `FireTrailFlameGame`. The session is opened in `initState` and survives `_nextLevel` (`fire_trail_game.dart:237-255`), which recreates the flame game; the pool is updated with `updateEligible`.
- FT-b Each level's problems come from one `nextBatch(answerGemCount, accept: uniqueAnswer)` call. Random generation (`_generateRandom`) is used only when the pool cannot supply that many distinct answers, and that fallback is reported in the trace.
- FT-c A fact missed in level L is in level L+1's batch if it is still eligible and H3 allows. With `n = 4` per level, at most 1 weak per level early in the session, rising to 2 as `n` grows (H3 is per session).
- FT-d The first answer to each prompt is `firstAttempt: true`; any later answer to the same prompt is `firstAttempt: false`. A wrong gem eaten counts against the active prompt (current behavior, `fire_trail_flame_game.dart:202`).
- FT-e `AnswerGiven.responseTimeMs` uses `getResponseTimeMs()` instead of 0.
- FT-f Problem order inside a level: the batch order. The first problem of a session is never weak (H3).

### 6.3 Dragon Eggs

Mechanics that constrain it: the player assembles `left op right = answer` from falling eggs (`systems/equation_builder.dart`), so the game cannot dictate which fact is answered. The board is the prompt. `MATH_PROBLEM_GENERATION_DESIGN.md:123-125` says it must not keep dropping the same target fact until the player solves it. The field must stay solvable (planner repair logic, `egg_field_planner.dart:52-92`, `:94-144`).

Target:
- EG-a A **focus set** of `focusSize` (3) items, chosen by the session with `nextBatch(3)`. The focus set is the thing the engine adapts; selection quotas apply to focus picks.
- EG-b Normal number spawns: with probability `focusShare` (0.35, up from today's uniform 0.20) the spawned number is a component of a focus fact (left, right or result), choosing the least crowded value. Otherwise current behavior.
- EG-c Helper spawns: among completion candidates with the top completion score (`egg_field_planner.dart:223-237`), prefer a focus fact. Board solvability rules are unchanged and win over focus.
- EG-d **Rotation**: a focus slot is refilled with `next()` when its fact is solved, or after `focusMaxSpawns` (8) number spawns without being solved. That satisfies the "do not keep dropping the same target" rule.
- EG-e A fact the player built and answered wrong (for example `7 × 8 = 54`) becomes an open miss. Because H3 ordering puts open misses first, it enters the focus set at the next rotation at which a weak pick is allowed.
- EG-f Only valid facts are recorded: `EquationResult` must reject non-integral division (fixes `7 ÷ 2 = 3`), and equations with result ≤ 0 or non-integral division emit `AnswerGiven` with `factKey: null`, which `FactTracker` ignores (I-2). Gameplay outcome (wrong, penalty) is unchanged.
- EG-g Every built equation is a first attempt (there is no retry on the same prompt).

What "adapts" means here, stated plainly: Dragon Eggs makes missed and due facts far more likely to be buildable on the board. It cannot force the child to build them. Marketing claim C2 is still accurate for Eggs because missed facts "come back more often" on the board, but per-game copy must not say Eggs "asks" the missed fact.

### 6.4 Dragon Runes

Mechanics that constrain it: the whole puzzle is generated up front from 1 to 3 number families; targets are equations from those families (`level_generator.dart:15-89`). Non-variety levels require families to be adjacent within `adjacencySpread` (`:134-156`). The child finds targets; wrong chains are possible but carry no data today (`systems/equation_validator.dart:9-11`).

Target:
- RU-a Per level, call `nextBatch(numberOfFamilies, accept: ...)` on a session whose pool is the level's `FactPool`. Each selected fact becomes a family `(min(left,right), max(left,right))`, using the operands of the fact as written for its family: `a + b`, `a × b` directly; `c − a` and `c ÷ a` map to family `(a, b)` where `b = c − a` or `c ÷ a`.
- RU-b On non-variety levels, the `accept` predicate enforces adjacency against families already chosen. If the first selection cannot be placed, it is still used as the first family (anchor) and later families follow adjacency.
- RU-c `_pickTargets` must include at least one equation derived from each selected fact, preferring the exact selected fact (for example `13 − 4 = 9` if `13-4` was selected), then fill as today. This satisfies `MATH_PROBLEM_GENERATION_DESIGN.md:154`.
- RU-d `AnswerGiven` for a found target carries `factKey` built from the target's operands and operator (`"4 × 3 = 12"` → `"3x4"`, `"13 − 4 = 9"` → `"13-4"`, `"12 ÷ 3 = 4"` → `"12/3"`). Multi-operator bonus chains carry `factKey: null`.
- RU-e `InvalidEquation` gains the parsed `left op right = rhs` when the chain has exactly that shape and the left side is a valid fact; that emits a miss with that fact's key. Any other invalid chain emits `factKey: null`.
- RU-f Whether a target found after a hint counts as a clean first attempt is Q7. Default in this spec: hinted targets emit `firstAttempt: false` (they do not count toward mastery).

### 6.5 Dragon's Feast

Mechanics that constrain it: one category per level, fixed by level number (`systems/category_system.dart:118-...`); a 5x5 board of correct and wrong tiles (`board_generator.dart:80-120`); the child eats tiles. A wrong eat is a mis-sort of a specific number. Leaving a correct tile uneaten is not observable until game over.

Target:
- FE-a Practice items are number-property items `"<categoryId>:<n>"` (`NumberPropertyItem`, I-4). The pool for a level is every `n` in the category's range, split into positives (`predicate(n)`) and negatives.
- FE-b Eating tile `n` emits `AnswerGiven(factKey: "<categoryId>:n", correct: predicate(n))`. Correct eats of positives are correct first attempts; eating a negative is a miss on that negative.
- FE-c Board generation draws **both** partitions through the session: `nextBatch(correctTileCount)` over positives and `nextBatch(25 - correctTileCount)` over negatives, with H3 applied per partition. A negative the child ate before (open miss) returns as a distractor on the next board where H3 allows. Respawns (`generateSingleCorrect`, `generateSingleWrong`, `board_generator.dart:206-240`) use `next()` on the matching partition.
- FE-d The arithmetic bias path is removed: no `selectNext` calls, no `_buildSimpleFactPool` (`dragons_feast_flame_game.dart:156-173`, `:731-738`), and no `resetSession()` on the shared engine.
- FE-e Category order per level stays fixed. Adapting which category comes next would change level structure (Q3).
- FE-f Property items do not count toward `masteredFactCount` unless Q5 says they should.

---

## 7. Interface changes (PROPOSALS, need Justin's approval)

Per project rules, shared types are read-only until approved. Nothing below is implemented. Each proposal lists the files it touches.

| ID | Change | Touches (shared contract?) | Phase |
|---|---|---|---|
| I-1 | `AnswerGiven` gains optional `factKey` and `firstAttempt` | `lib/core/game_events.dart:17-32` (yes, event contract) | 1 |
| I-2 | `FactTracker` honors `factKey`/`firstAttempt`, rejects invalid keys | `lib/core/fact_tracker.dart:153-172` (behavior of a core service) | 1 |
| I-3 | New `PracticeKey` grammar | new `lib/core/practice_key.dart` | 1 |
| I-4 | `PracticeItem` interface; `MathFact implements PracticeItem`; new `NumberPropertyItem` | `lib/games/shared/math_problem.dart:4-37`, `lib/games/shared/problem_generation.dart` | 2 (MathFact), 5 (property) |
| I-5 | `PracticeSession` interface, `SelectionTrace` | new `lib/core/practice_session.dart` | 2 |
| I-6 | `GenerationConstraints` fields; `ProblemScheduler` generic over `PracticeItem`; `ProblemBlueprint<T>` | `lib/games/shared/problem_generation.dart:169-191`, `:195-388` | 2 |
| I-7 | `DifficultyEngine` opens sessions; takes `EventBus` and `now`; deprecates `selectNext`/`recordIncorrect` | `lib/core/difficulty_engine.dart:26-33`, `lib/app.dart:85` | 2 |
| I-8 | Phase 1 only: `selectBlueprint(..., accept:)` | `lib/core/difficulty_engine.dart:82-84` | 1 |
| I-9 | Runes `InvalidEquation` carries the attempted fact | `lib/games/dragon_runes/systems/equation_validator.dart:9-11` (game-internal) | 4 |

Not touched: `MathDragonsGame`, `GameLevel`, `DifficultyParams`, `DifficultyProfile` (`lib/core/game_interface.dart`). `DifficultyProfile` stays unused; Q3 decides whether it gets a job.

### I-1 `AnswerGiven`

```dart
class AnswerGiven extends GameEvent {
  final String problem;
  final String playerAnswer;
  final String correctAnswer;
  final bool correct;
  final int responseTimeMs;

  /// Canonical practice-item key (see PracticeKey). When non-null, FactTracker
  /// uses it verbatim. When null, FactTracker falls back to normalizing
  /// [problem] and drops the event if the result is not a valid PracticeKey.
  final String? factKey;

  /// False for any answer after the first one to the same prompt.
  /// Defaults to true so existing emitters keep compiling.
  final bool firstAttempt;

  AnswerGiven({
    required super.gameId,
    required this.problem,
    required this.playerAnswer,
    required this.correctAnswer,
    required this.correct,
    required this.responseTimeMs,
    this.factKey,
    this.firstAttempt = true,
  });
}
```

`RewardService` (`lib/core/reward_service.dart:82`) and `AudioService` (`lib/core/audio_service.dart:319`) are unaffected; scales still pay per correct answer, retries included.

### I-2 `FactTracker` behavior

- Resolve `key = event.factKey ?? _normalizeFactKey(event.problem)`.
- If `!PracticeKey.isValid(key)`: ignore the event (debug-assert in debug builds when `factKey` was non-null).
- If `!event.firstAttempt`: ignore the event for `FactRecord` purposes.
- Otherwise update as today (`recordCorrect` / `recordIncorrect`).
- Public query methods (`getFact`, `getAllFacts`, `getFactsByStatus`, `getStatusCounts`, `masteredFactCount`, `factsNotSeenSince`) keep their signatures. If Q5 excludes property items from mastery, `masteredFactCount` filters to arithmetic keys.

### I-3 `PracticeKey`

```dart
// lib/core/practice_key.dart
abstract final class PracticeKey {
  /// "7x8", "13-4", "12/3", "3+5". Commutative ops have left <= right.
  static final RegExp arithmetic = RegExp(r'^(\d{1,3})([+\-x/])(\d{1,3})$');

  /// "mult_3:12", "prime:17", "range_10_20:15".
  static final RegExp property = RegExp(r'^([a-z][a-z0-9_]*):(\d{1,3})$');

  static bool isValid(String key);         // matches either grammar AND, for
                                           // arithmetic, is canonical, has a
                                           // positive integer result, and
                                           // divides evenly with divisor >= 2
  static bool isArithmetic(String key);
  static bool isProperty(String key);
  static String forFact(MathFact fact) => fact.factKey;
  static String forProperty(String categoryId, int n) => '$categoryId:$n';
}
```

### I-4 `PracticeItem`

```dart
// lib/games/shared/problem_generation.dart
abstract interface class PracticeItem {
  String get key;                       // a valid PracticeKey
  KnowledgeComponent get component;
}

// lib/games/shared/math_problem.dart
class MathFact implements PracticeItem {
  // existing fields unchanged
  @override String get key => factKey;
  @override KnowledgeComponent get component => KnowledgeComponent.forFact(this);
}

// lib/games/shared/problem_generation.dart (Phase 5)
class NumberPropertyItem implements PracticeItem {
  final String categoryId;
  final int number;
  final bool matches;                   // category.predicate(number)
  const NumberPropertyItem({required this.categoryId, required this.number, required this.matches});
  @override String get key => PracticeKey.forProperty(categoryId, number);
  @override KnowledgeComponent get component => KnowledgeComponent('property.$categoryId');
}
```

### I-5 `PracticeSession`

```dart
// lib/core/practice_session.dart
abstract interface class PracticeSession<T extends PracticeItem> {
  String get gameId;

  /// Next item under the section 6.1 policy, or null if the pool is empty or
  /// every item is vetoed. Items rejected by [accept] are not recorded as
  /// selections.
  ProblemBlueprint<T>? next({bool Function(T item)? accept});

  /// Up to [count] distinct items in presentation order, equivalent to
  /// [count] calls of next(). [accept] also receives the items already chosen
  /// in this batch (for example, to keep answer values unique).
  List<ProblemBlueprint<T>> nextBatch(
    int count, {
    bool Function(T item, List<T> chosen)? accept,
  });

  /// Replace the eligible pool (level change) without resetting quotas,
  /// open-miss tracking or the repeat window.
  void updateEligible(List<T> eligible);

  /// Read-only view for tests and debug overlays.
  SessionStats get stats;
  List<SelectionTrace> get trace;

  /// Stop listening to events. Further calls throw StateError.
  void close();
}

class SessionStats {
  final int selections;
  final int weakSelections;
  final int newSelections;
  final int knownSelections;
  final double recentFirstAttemptAccuracy; // last struggleWindow outcomes
  final bool struggling;
  const SessionStats({...});
}

class SelectionTrace {
  final String key;
  final ItemClass itemClass;            // weak, newItem, known, due
  final ProblemDueReason reason;
  final List<String> relaxedRules;      // e.g. ['H5'] when step 4 applied
  const SelectionTrace({...});
}

enum ItemClass { weak, newItem, known, due }
```

### I-6 Scheduler and constraints

```dart
class GenerationConstraints {
  final int repeatWindow;               // 3 (existing)
  final double needsPracticeSessionCap; // 0.40 (existing name kept; now = weakCap, H3)
  final double newCap;                  // 0.30 (H5)
  final int maxConsecutiveWeak;         // 1 (H4)
  final int correctionMaxGap;           // 5
  final int cleanAnswersToCloseMiss;    // 2
  final int maxSessionMissesPerItem;    // 3 (H6)
  final int struggleWindow;             // 8
  final double struggleEnterBelow;      // 0.60
  final double struggleExitAtOrAbove;   // 0.75
  final double struggleWeakCap;         // 0.20
  const GenerationConstraints({...});   // all with the defaults above
}

class ProblemBlueprint<T extends PracticeItem> {
  final T item;
  final KnowledgeComponent component;
  final MasteryEstimate mastery;
  final ProblemDueReason dueReason;
  const ProblemBlueprint({...});
}

extension FactBlueprint on ProblemBlueprint<MathFact> {
  MathFact get fact => item;            // keeps existing call sites compiling
}

class ProblemScheduler<T extends PracticeItem> { /* policy of section 6.1 */ }
```

`MasteryEstimate.needsCorrection` changes to `lastIncorrect != null && currentStreak < cleanAnswersToCloseMiss`; it therefore needs the constraint value (make it a method taking the threshold, or move the check into the scheduler).

### I-7 `DifficultyEngine`

```dart
class DifficultyEngine {
  DifficultyEngine({
    required FactTracker factTracker,
    required EventBus eventBus,          // new: sessions listen to AnswerGiven
    Random? random,
    DateTime Function()? now,            // new: deterministic tests
  });

  PracticeSession<MathFact> openFactSession({
    required String gameId,
    required List<MathFact> eligible,
    GenerationConstraints constraints = const GenerationConstraints(),
  });

  PracticeSession<NumberPropertyItem> openPropertySession({
    required String gameId,
    required List<NumberPropertyItem> eligible,
    GenerationConstraints constraints = const GenerationConstraints(),
  });

  @Deprecated('Use openFactSession') MathFact? selectNext(List<MathFact> eligibleFacts);
  @Deprecated('Sessions learn outcomes from AnswerGiven') void recordIncorrect(String factKey);
  @Deprecated('Close the session instead') void resetSession();
}
```

`lib/app.dart:85` passes `eventBus: _eventBus`. Deprecated members are deleted in Phase 6 once no caller remains.

### I-8 Phase 1 stopgap

```dart
ProblemBlueprint? selectBlueprint(
  List<MathFact> eligibleFacts, {
  bool Function(MathFact fact)? accept,  // vetoed facts are not recorded
});
```

Superseded by I-5 in Phase 2.

### I-9 Runes `InvalidEquation`

```dart
class InvalidEquation extends EquationResult {
  /// Set when the chain is exactly `a op b = c` with a valid fact on the left.
  final MathFact? attemptedFact;
  final int? attemptedAnswer;
  const InvalidEquation({this.attemptedFact, this.attemptedAnswer});
}
```

Note: Runes has its own `MathOp` enum (`lib/games/dragon_runes/models/dragon_runes_config.dart:5`) separate from the shared one (`lib/games/dragon_eggs/models/egg_data.dart:8`); the existing mapper (`dragon_runes_game.dart:469-480`) is reused.

---

## 8. Data and persistence

**Does FactTracker record everything needed?** Not today:
- Runes and Feast keys are unusable (section 3.2).
- Retries are counted as presentations, so missing and then correcting looks like 50% accuracy on a "new" fact and clears the open-miss signal.
- Fire Trail response times are 0.

After I-1 to I-3 the existing `FactRecord` fields (Hive typeId 3, fields 0-7, `lib/core/fact_tracker.dart:27-59`) are sufficient. Open misses use `lastIncorrect` and `currentStreak`; spacing uses `lastPresented`; session-level counts (misses this session, cool-down) live in memory in the session.

**No Hive schema change is required by this spec.** If one is added later:
- Registered typeIds in use: 0 `PlayerProfile`, 1 `GameStats`, 2 `PlayerSettings` (`lib/core/player_profile.dart:5`, `:214`, `:320`), 3 `FactRecord`, 4 `FactStatus` (`lib/core/fact_tracker.dart:27`, `:10`), 5 `UnlockedAchievement` (`lib/core/achievement.dart:97`), 6 `DailyChallengeState` (`lib/core/daily_challenge.dart:51`). Next free typeId is **7**. Never reuse 0-6.
- `FactRecord` field numbers 0-7 are used. Next free is **8**. New fields must use `@HiveField(8, defaultValue: ...)` so existing records load. Never renumber.
- `FactStatus` values are Hive fields 0-3; do not reorder.
- Regenerate adapters with `dart run build_runner build --delete-conflicting-outputs` and commit the `.g.dart`.

**Semantic change without schema change.** From Phase 1, records count first attempts only. Existing records keep their retry-inflated counts. Effect: some facts look slightly weaker or more practiced than they are, and the bias washes out after a few presentations. No migration needed for this.

**Corrupt historical records** (Runes `"2+35"`, `"7−34"`, `"invalid"`; Feast `"even:correct"`; Eggs `"3-7"`, `"7/2"`). They never match a pool item, so they do not affect selection, but they inflate `masteredFactCount` (evolution stage 5, achievements). Proposed, pending Q4: `MigrationRunner` v4 (`lib/storage/migration.dart:5`, bump `currentVersion` 3 → 4, add `_migrateToV4` to the map at `:26-30`) deletes every `fact_history` record whose key fails `PracticeKey.isValid`, or whose arithmetic operands exceed 15 (no game's pool goes above 15: Runes max `dragon_runes_config.dart` world 4-5 `numberMax` 15, Fire Trail 12, Eggs 12). Known residual: a Runes record like `"1+12"` (from `1 + 1 = 2`) collides with a real fact and survives. `LocalStorage` needs a `deleteFact(String key)` method for this (small addition to `lib/storage/local_storage.dart`). Extend `test/storage/migration_test.dart`.

**Performance.** The largest arithmetic pool is about 4 ops x 11 x 11 ≈ 300 facts (Runes worlds 4-5 range 2-15 with `resultMax` 144 is similar). One selection evaluates one `MasteryEstimate` per pool item from Hive's in-memory cache: well under 1 ms (STEP_08 verification target `:1896`). Dragon Eggs calls the session only on focus rotation, not per spawn. Feast pools are at most 144 numbers. No new disk writes beyond the existing one per answer.

---

## 9. Test plan

All selection tests are deterministic: inject `Random(seed)`, `now: () => fixedTime`, and fake `FactTracker` records (the `FakeFactTracker` pattern in `test/core/difficulty_engine_test.dart:468-509` and `test/games/fire_trail/problem_manager_test.dart:282-328`). Statistical assertions run over seeds 0-49 and must hold for every seed (they are invariants), except where a rate is stated.

Contract tests (9.1, 9.2) define the boundaries. Per project rules, Justin reviews and approves them before implementation starts; after that they are not edited to fit the implementation.

### 9.1 Contract: `FactTracker` and `AnswerGiven` (new file `test/core/fact_tracker_events_test.dart`)

Uses a real `EventBus` and a fake `LocalStorage` (implements `getFact`/`saveFact`; or Hive in a temp dir). Await `pumpEventQueue()` after each emit because the bus is an async broadcast stream (`lib/core/event_bus.dart`).

- TR-1 `factKey: "3x4"` is stored under `"3x4"`, regardless of `problem`.
- TR-2 `firstAttempt: false` changes no record.
- TR-3 A miss followed by a `firstAttempt: false` correct answer leaves `currentStreak == 0` and `lastIncorrect != null`.
- TR-4 Keys failing `PracticeKey.isValid` create no record: `"invalid"`, `"even:correct"`, `"7−34"` (U+2212), `"7/2"` (non-integral), `"3-7"` (result ≤ 0), `"4x3"` (non-canonical order). Note that a corrupt Runes key such as `"2+35"` is grammatical and passes; it can only be stopped at the source (RU-d) or cleaned by migration (section 8).
- TR-5 Legacy event without `factKey` and with `problem: "7 × 8"` still records `"7x8"`.

### 9.2 Contract: selection policy (`test/core/practice_session_contract_test.dart`)

Fixture A: pool = multiplication 2-9 x 2-9 canonical (36 facts). All known (10 attempts, 9 correct, streak 3, last presented 1 hour before `now`).

- SP-1 Scope (H1): every selection over 200 is in the pool and passes `accept`.
- SP-2 No repeat (H2): no key appears twice within any 4 consecutive selections.
- SP-3 Return after miss: emit a miss on `"7x8"` after selection 1 (where 7x8 was selected). 7x8 is selected again at selection index in [5, 7] (at least 3 and at most 5 others between). After two more correct first attempts on 7x8, it is no longer weak.
- SP-4 Frequency lift (claim C2): over the 20 selections after a single miss on 7x8 with recovery, 7x8 appears at least 3 times. Baseline for an unmissed known fact in the same run: at most 2 times in 20 for every seed. (Uniform expectation is 20/36 ≈ 0.56.)
- SP-5 Weak cap (H3): Fixture B = 36 facts, 30 weak (10 attempts, 4 correct), 6 known. Over 100 selections, after every selection `w <= floor(0.40 * n)`. First selection is not weak.
- SP-6 Cap leak closed: Fixture C = weak facts whose `lastPresented` is 2 days old (due for review). Same bound as SP-5.
- SP-7 No weak runs (H4): no two consecutive weak selections in fixtures B and C while known items exist.
- SP-8 New cap (H5): Fixture D = 30 new, 6 known. After every selection, `nw <= ceil(0.30 * n)` while known items remain eligible.
- SP-9 Mixing: Fixture E = 12 weak, 12 new, 12 known. Every 10-selection window contains at least 3 known selections.
- SP-10 Cool-down (H6): 7x8 answered wrong on every presentation is selected at most 3 times in the session.
- SP-11 Struggle guard: feed 8 outcomes with 4 correct (50%). The next 20 selections have weak share ≤ 0.20 + 1/20. After 8 more correct outcomes, the cap returns to 0.40.
- SP-12 Spaced review: a mastered fact last seen 8 days ago is selected within the first 3 selections of a session in Fixture A (due ordering, step 2).
- SP-13 Determinism (H7): two sessions with identical inputs and seed produce identical key sequences.
- SP-14 `accept` veto: vetoed items do not count toward `stats.selections` or the repeat window.
- SP-15 Pool exhaustion: a pool of 2 items returns items (relaxing H2) and records `relaxedRules`.
- SP-16 Session isolation: misses emitted with `gameId: "dragon_eggs"` do not affect a `"fire_trail"` session's in-session state (records are still shared through `FactTracker`, by design).

Existing tests: `test/games/shared/problem_scheduler_test.dart:53-79` ("prioritizes a fact that needs correction") assumes the first selection can be the correction fact. Under H3 it cannot. This is a deliberate behavior change from this spec, so that test is updated as part of approving H3, not to fit the implementation. `:81-125` keeps passing (its bound is 0.45). `test/core/difficulty_engine_test.dart` keeps testing the deprecated `selectNext` until Phase 6 removes it.

### 9.3 Per-game behavioral tests

**Fire Trail** (`test/games/fire_trail/`)
- FTT-1 (widget, new `fire_trail_screen_test.dart`): pump `FireTrailScreen` inside the providers from `lib/app.dart:162-176` (fakes are fine); `tester.widget<GameWidget<FireTrailFlameGame>>(...).game!.difficultyEngine` is non-null (Phase 1) / the game has a session (Phase 2). This is the test the review asked for (`compliance-and-strategy.review.md:117`).
- FTT-2 `placeLevelAnswerGems` with a session: returns `answerGemCount` gems, unique positive answers, all keys from the pool, no random fallback when the pool has enough distinct answers (trace shows none).
- FTT-3 Carry-over: miss `"2+3"` (first attempt) in level L; level L+1 with the same pool contains `"2+3"`.
- FTT-4 Weak per level: with 10 weak and 10 known facts, each 4-gem level has at most `floor(0.4 * n_total)` cumulative weak.
- FTT-5 Attempt flags: wrong gem then correct gem on the same prompt emits `(correct: false, firstAttempt: true)` then `(correct: true, firstAttempt: false)`, both with `responseTimeMs > 0`.

**Dragon Eggs** (`test/games/dragon_eggs/`)
- EGT-1 With focus `{7x8, 6x9, 3x4}`, a solvable field and `Random(seed)`, over 400 normal spawns the share of number spawns that are components of focus facts is at least 0.30 (target 0.35 plus least-crowded effects), versus a measured baseline of the current planner for the same seeds.
- EGT-2 Helper spawn picks a focus fact when it ties for the best completion score.
- EGT-3 Rotation: an unsolved focus fact is replaced after 8 number spawns; a solved one is replaced immediately.
- EGT-4 A miss on `7x8` (built `7 × 8 = 54`) puts `7x8` into the focus set at the first rotation where H3 allows.
- EGT-5 `EquationResult(left: 7, op: divide, right: 2, playerAnswer: 3).isCorrect` is false; its `AnswerGiven` has `factKey: null`. Same for `3 − 7`.
- EGT-6 Solvability invariants from `test/games/dragon_eggs/egg_field_planner_test.dart` still pass with a focus set.

**Dragon Runes** (`test/games/dragon_runes/`)
- RUT-1 Key mapping: `"4 × 3 = 12"` → `"3x4"`, `"13 − 4 = 9"` → `"13-4"`, `"12 ÷ 3 = 4"` → `"12/3"`, `"2 + 3 = 5"` → `"2+3"`.
- RUT-2 With selected facts given, every selected fact has at least one derived target (`level_generator.dart` `_pickTargets`), over levels 1-50 and seeds 0-49.
- RUT-3 Adjacency still holds on non-variety levels (existing test `level_generator_test.dart:126-163` keeps passing).
- RUT-4 Invalid chain `3 + 5 = 9` yields `InvalidEquation(attemptedFact: 3+5, attemptedAnswer: 9)` and an `AnswerGiven(correct: false, factKey: "3+5")`. Chain `3 + = 5` yields `factKey: null`.
- RUT-5 An open miss on `"3+5"` in an eligible level appears as a family in the next level when H3 allows.

**Dragon's Feast** (`test/games/dragons_feast/`)
- FET-1 Eating 14 on `mult_3` emits `factKey: "mult_3:14"`, `correct: false`; eating 12 emits `"mult_3:12"`, `correct: true`.
- FET-2 With `"mult_3:14"` an open miss, the next generated board contains 14 as a wrong tile (for every seed where H3 allows one weak negative, which it does for 15 negatives).
- FET-3 Board invariants from `board_generator_test.dart` (25 cells, predicate correctness, 8-12 correct tiles) still pass.
- FET-4 `DragonsFeastFlameGame` no longer calls `DifficultyEngine.selectNext` or `resetSession` (fake engine records zero calls).
- FET-5 (if Q5 = exclude) property records do not change `masteredFactCount`.

### 9.4 Regression

`flutter analyze` clean; full `flutter test` passes (613 tests per `marketing/PLAN.md:71`, plus new ones); `flutter build appbundle --release` builds.

### 9.5 Claim tests (gate for marketing)

A claim is publishable only when its tests pass on the release commit:
- C1: TR-1 to TR-5, FTT-5, EGT-5, RUT-1, RUT-4, FET-1.
- C2-FT: FTT-1, FTT-3, SP-3 (Phase 1 version against `selectBlueprint`).
- C2: SP-3, SP-4, SP-9, FTT-3, EGT-4, RUT-5.
- C3: SP-12.
- C4: all of section 9, plus a manual play check of each game by Justin (section 10, Phase 6).
- C5: FET-1, FET-2.

---

## 10. Phased implementation plan

Effort assumes one developer (agent or Justin) familiar with the repo, including tests.

### Phase 1: Fire Trail adapts, and history is clean (1.5 to 2 days)

**Status (2026-10-26): implemented on branch `app/adaptive-phase-1`, not yet merged or released.** All items below are done; `flutter analyze` clean, full suite 660 tests passing. C1 and C2-FT stay unpublished until merge, release and the 9.5 tests pass on the release commit (decision Q11).

Smallest change that makes C1 and C2-FT true.
1. [x] Approve I-1, I-2, I-3, I-8.
2. [x] `FireTrailScreen._createGame` passes `difficultyEngine: context.read<DifficultyEngine>()` (`fire_trail_game.dart:60-69`); call `resetSession()` in `initState` (stopgap until Phase 2).
3. [x] `ProblemManager`: loop `selectBlueprint(accept: uniqueAnswer)` to fill the level, random only on exhaustion (`problem_manager.dart:207-260`).
4. [x] Fire Trail first-attempt flag per prompt and real response time (`fire_trail_game.dart:72-85`). Response time is measured from when the prompt became active, and from GO for the first prompt (the countdown is excluded).
5. [x] `FactTracker` honors `factKey` and `firstAttempt`, drops invalid keys.
6. [x] Emit correct keys from Runes (RU-d) and Feast (FE-b) so they stop writing junk now, even before they adapt.
7. [x] Dragon Eggs: reject non-integral division; `factKey: null` for invalid equations (EG-f).
8. [x] Tests: 9.1 (`test/core/fact_tracker_events_test.dart`), FTT-1 and FTT-5 (`test/games/fire_trail/fire_trail_screen_test.dart`), FTT-3 (`test/games/fire_trail/level_carry_over_test.dart`), Phase 1 version of SP-3 (`test/core/select_blueprint_phase1_test.dart`), EGT-5 (`test/games/dragon_eggs/equation_validity_test.dart`), RUT-1 (`test/games/dragon_runes/fact_key_test.dart`), FET-1 (`test/games/dragons_feast/answer_event_test.dart`).

Unlocks C1 and C2-FT. Not yet "mixed with known facts" (known-fact starvation remains).

### Phase 2: Selection policy v2 and sessions (2 to 3 days)

1. Approve I-4 (MathFact part), I-5, I-6, I-7.
2. Rewrite `ProblemScheduler.select` to section 6.1; generic over `PracticeItem`; struggle guard; cool-down; traces.
3. `DifficultyEngine.openFactSession`, `EventBus` subscription, `now` injection; update `lib/app.dart:85`.
4. Migrate Fire Trail to a session owned by `_FireTrailScreenState`, surviving `_nextLevel`.
5. Tests: all of 9.2, FTT-2, FTT-4; update `problem_scheduler_test.dart:53-79` per the approved H3.

Unlocks C2 for Fire Trail and C3.

### Phase 3: Dragon Eggs (2 days)

Focus set, focus-weighted spawns, helper tie-break, rotation (6.3). Session owned by `_DragonEggsScreenState` and passed into `DragonEggsFlameGame` (replacing the unused `difficultyEngine` field) and on to `EggSpawner`/`EggFieldPlanner`. Tests EGT-1 to EGT-6.

### Phase 4: Dragon Runes (1.5 days)

Approve I-9. Session-selected families with adjacency `accept`, guaranteed targets, miss attribution from invalid chains, hint policy per Q7. Replace the `selectNext` call at `dragon_runes_game.dart:72-87`. Tests RUT-1 to RUT-5.

### Phase 5: Dragon's Feast (2 days)

Approve I-4 (`NumberPropertyItem`). Property pools, two-partition board selection, respawn through the session, remove the arithmetic bias path and the shared-engine reset. Tests FET-1 to FET-5. Unlocks C5.

### Phase 6: Cleanup, docs, claim sign-off (0.5 to 1 day)

1. Migration v4 per Q4, with `test/storage/migration_test.dart`.
2. Remove deprecated `selectNext`, `recordIncorrect`, `resetSession`, and the legacy tests for them.
3. Doc updates (section 13).
4. Manual check: play each game for one session with a fresh profile, deliberately miss two facts, confirm they return (debug overlay from `PracticeSession.trace` behind `kDebugMode`, optional).
5. Mark claims C1 to C5 as verified in `marketing/PLAN.md`.

Unlocks C4.

**Total: about 9.5 to 11.5 days.** Phases 3, 4 and 5 are independent after Phase 2 and can run in parallel (separate directories: `lib/games/dragon_eggs`, `lib/games/dragon_runes`, `lib/games/dragons_feast`), because the shared interfaces will exist by then.

---

## 11. Risks

| Risk | Where | Mitigation in this spec |
|---|---|---|
| **Difficulty spikes.** Weak facts are hard by definition; Fire Trail has a flame meter and Feast has lives, so clustered weak facts end runs. | Fire Trail, Feast | H3 cap, H4 no weak runs, first selection never weak, struggle guard drops the cap to 20%. Consider a lower cap for high-pressure games (Q1). |
| **Kids stuck on one hard fact.** A fact that keeps coming back and keeps being missed is demoralizing. | All | H6 cool-down after 3 session misses; spaced review brings it back on a later day instead. |
| **Motor errors counted as math misses.** Steering into the wrong gem or tile is not always a math error. | Fire Trail, Feast | Accept the noise; a miss only needs 2 clean answers to close, so false misses are cheap. Revisit if testers report repetition. |
| **Eggs adaptation is indirect.** The child picks what to build; focus facts may be ignored. | Dragon Eggs | Copy must not say Eggs "asks" missed facts (6.3). Rotation prevents board clutter. |
| **Runes adjacency vs weak facts.** A weak fact far from the anchor cannot sit in an adjacent family. | Dragon Runes | Weak fact becomes the anchor (first family); variety levels take any fact. |
| **Pools change across worlds.** A fact missed in world 1 may not be eligible in world 2, so it only returns on replay. | Fire Trail, Runes, Eggs | Hard rule H1 (never inject out-of-scope content). Claims say "comes back more often", not "in the next level". |
| **Async event delivery.** Sessions and `FactTracker` see `AnswerGiven` a microtask later. | All | Fire Trail and Runes select per level, Eggs per rotation, Feast per board, so outcomes land before the next selection. Tests use `pumpEventQueue()`. |
| **Shared singleton state.** Feast's `resetSession()` wipes other games' state today. | Engine | Per-game sessions (I-5); Feast stops calling `resetSession` (FE-d). |
| **Semantic drift in existing records.** Old records counted retries. | FactTracker | Washes out after a few presentations; optional cleanup in Q4. |
| **Claim drift.** Marketing publishes before the phase ships. | Marketing | Section 9.5 gate; `marketing/PLAN.md:70` already gates claims on this spec. |
| **Performance.** | Engine | ≤ 300-item pools, in-memory reads, selection per level or rotation; well under 1 ms. |

---

## 12. Open questions for Justin

1. **Weak cap.** Keep 40% everywhere (current docs), or lower it for Fire Trail and Feast (for example 34%) because of their fail states? Research on interleaved drill generally keeps unknown items as a minority; 40% is the existing documented ceiling.
2. **Closing a miss.** Is 2 consecutive clean first attempts the right bar, or 3?
3. **Should levels adapt?** The docs say no (`MOBILE_APP_PLAN.md:585`). If yes (auto step-back after repeated failure, or skipping ahead), that is a separate spec, would give `DifficultyProfile` a job, and is the only way the store-listing phrase "adjusts to your child's skill level" could become true.
4. **Corrupt history.** Delete invalid keys with the v4 heuristic (small collision residue), wipe all fact history once (closed-test user base is small), or leave it (only affects mastered counts)?
5. **Property items and mastery.** Should Feast items count toward "Master 100 facts" (evolution stage 5) and fact achievements? Default here: no.
6. **One definition of mastered.** Unify `FactRecord.status` (5 attempts) and `MasteryEstimate` (8 attempts plus confidence bound)? Changing `FactRecord.status` changes evolution and achievement timing for existing players.
7. **Runes hints.** Does a target found after a hint count as a clean first attempt? Default here: no.
8. **Eggs nonsense equations.** Ignore them for fact history (this spec), or record them as misses on the nearest valid fact?
9. **Outcome plumbing.** Sessions subscribe to `AnswerGiven` (this spec, single source of truth) vs games calling `session.recordOutcome(...)` explicitly (simpler to test, risk of double reporting)?
10. **Parent view.** A simple parent-gated "facts to practice" list would let parents verify C1 themselves and would make the claim stronger. In or out of scope?
11. **Claim rollout.** Publish per-game claims as phases ship (C2-FT after Phase 1), or hold all adaptivity copy until C4?

---

## 13. Documentation updates required with the implementation

- `docs/MATH_PROBLEM_GENERATION_DESIGN.md`: replace the scheduling contract (`:73-90`) with section 6.1; update game adapters (`:104-167`) to sections 6.2-6.5; note that "difficulty band" (`:100`) is not a blueprint field.
- `docs/STEP_08_DIFFICULTY_AND_PROGRESSION.md`: mark the bucket algorithm historical; fix `:95-99`, `:176`, `:1337-1385`, `:1863`.
- `docs/MOBILE_APP_PLAN.md` §8: point the selection algorithm at this spec.
- `README.md:35` and `:249`: correct the feature claims and the broken link.
- `lib/core/fact_tracker.dart:26`: key examples to `"mult_3:12"`, `"prime:17"`.
- `docs/store-listing.md:7`, `:26`, `:134`: replace with approved claim wording from section 2.1.
- `marketing/PLAN.md:70`, `:77`: record which claims are unlocked.
