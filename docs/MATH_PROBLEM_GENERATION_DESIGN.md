# Math Problem Generation Design

This document defines the methodology for generating math practice in Math
Dragons. It is the source of truth for future changes to problem selection,
solvability, difficulty progression, and game-specific adapters.

## Goals

- Generate only problems that are valid for the current level scope.
- Guarantee game-level solvability before presenting a problem or puzzle.
- Use retrieval practice, spaced review, interleaving, and immediate correction.
- Track progress as evidence of accuracy, fluency, and retention, not raw score.
- Make new levels data-driven: add curriculum nodes and adapter constraints, not
  one-off random branches.

## Learning Model

The app separates visible level progression from adaptive fact selection.

Visible progression determines what content may appear:

- number range
- operation set
- game speed and pressure
- puzzle size
- required problem count

Adaptive selection determines which eligible fact or property should appear next:

- facts answered incorrectly recently are scheduled for correction soon
- due facts are reviewed after spacing intervals
- new facts are introduced gradually
- mastered facts stay in low-frequency maintenance rotation
- high-pressure games avoid overloading the child with too many weak facts in a row

## Knowledge Components

A `KnowledgeComponent` is the smallest skill unit the scheduler can reason about.
Examples:

- `add.within_10`
- `add.make_10`
- `sub.within_20`
- `mul.2`
- `mul.5`
- `mul.10`
- `mul.3_4`
- `div.fact_family`
- `property.even`
- `property.multiple_7`
- `property.prime`

Arithmetic facts keep their concrete fact key, such as `7x8`, but also map to a
component. Property games may track category keys, such as `property.prime`.

## Mastery Evidence

Mastery is not a single lifetime accuracy percentage. A fact or component has:

- attempts
- correct attempts
- current streak
- average response time
- last presented
- last incorrect
- inferred mastery band
- due reason

Current implementation uses existing `FactRecord` fields and computes a
conservative mastery estimate. Future storage can add richer per-KC records
without changing game adapters.

## Scheduling Contract

For a level session, the scheduler builds a queue of `ProblemBlueprint`s.

Hard guarantees:

- every blueprint belongs to the eligible level scope
- no fact repeats inside the configured repeat window when enough alternatives exist
- recently incorrect facts are represented in a correction lane
- needs-practice facts cannot exceed the configured session cap when alternatives exist
- each generated blueprint is validated before use

Soft priorities:

- due review before new material
- weak facts before mastered facts, within the cap
- stale mastered facts before recently mastered facts
- operation/category interleaving when the level permits multiple skills

## Problem Blueprint

A `ProblemBlueprint` is game-neutral. It describes the learning target:

- fact
- knowledge component
- due reason
- mastery estimate
- difficulty band

Game adapters convert blueprints into playable objects.

## Game Adapters

### Fire Trail

Direct equation prompt. The adapter converts one blueprint into one visible
equation and answer gem set.

Validation:

- operation is allowed
- operands are inside level bounds
- answer is valid and positive
- exactly one correct answer value exists among visible gems
- distractors are unique and incorrect

### Dragon Eggs

Equation construction under time pressure. The adapter should generate a
free-form field of numbers and operators, then repair the field when needed so
at least one valid equation is buildable. Unlike direct-prompt games, it should
not keep dropping the same target fact until the player solves it. The active
screen state is the prompt.

Validation:

- active eggs contain all required equation components
- at least one valid equation is possible
- helper spawns add a missing component, not a random egg
- normal spawns avoid over-crowding the same few values
- recent solved facts are de-prioritized so the board does not fill with one
  repeated equation

Pacing:

- levels last long enough to build a sustained action-game rhythm
- base number ranges step up by level
- occasional number perturbations introduce nearby larger values
- drop speed and spawn rate increase both across levels and within a level as
  progress approaches completion

### Dragon Runes

Puzzle construction from fact families. The adapter should convert one or more
blueprints into number families, then generate targets and nodes from those
families.

Validation:

- every target can be constructed from the node multiset
- target count is in bounds
- at least one target uses the scheduled family when possible

### Dragon's Feast

Category/property recognition. This game should use property knowledge
components directly, not arithmetic fact components except where a category is
explicitly related to that fact family.

Validation:

- correct tiles satisfy the active category
- wrong tiles fail the active category
- board has the required number of correct tiles
- contrast examples are pedagogically meaningful

## Extension Rules

Adding harder content should follow this sequence:

1. Add or expand curriculum components.
2. Add level-scope data that enables those components.
3. Add adapter constraints for how the game presents the content.
4. Add invariant tests for the new scope.
5. Only then tune game feel parameters such as speed, density, or enemy pressure.

Randomness is allowed for variety, but it must operate inside validated
constraints.
