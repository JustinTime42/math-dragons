# Math Dragons: Art Asset Integration Plan

> Comprehensive plan for replacing all procedural Canvas drawing and emoji graphics
> with AI-generated art assets across the entire Math Dragons codebase.
> Reference: `docs/step12/ART_GENERATION_PROMPTS.md` (75 total images)

---

## Table of Contents

1. [Complete Asset-to-Code Mapping](#1-complete-asset-to-code-mapping)
2. [Hub Screen Art Integration](#2-hub-screen-art-integration)
3. [Game-Specific Art Integration](#3-game-specific-art-integration)
4. [Flame Sprite Loading Patterns](#4-flame-sprite-loading-patterns)
5. [Flutter Image Widget Patterns](#5-flutter-image-widget-patterns)
6. [Multi-Density Asset Handling](#6-multi-density-asset-handling)
7. [Migration Strategy](#7-migration-strategy)
8. [Performance Considerations](#8-performance-considerations)
9. [pubspec.yaml Changes](#9-pubspecyaml-changes)
10. [Fallback Strategy](#10-fallback-strategy)

---

## 1. Complete Asset-to-Code Mapping

This section maps every one of the 75 planned art assets to the exact Dart file, current rendering approach, replacement technique, and code changes required.

### 1.1 Dragon Evolution Portraits (12 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 1 | `dragons/dragon_egg.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{1F95A}` in `_evolutionEmojis[0]`, rendered as `Text(emoji)` inside a circular `Container` | `Image.asset()` inside the circular container | Replace `Text(emoji)` with `Image.asset('assets/images/dragons/dragon_egg.png', width: 28, height: 28)`. Also used in evolution dialog (L162-168). |
| 2 | `dragons/dragon_egg_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{1F95A}` at index 0 of `_evolutionEmojis`, rendered as `Text(emoji, style: TextStyle(fontSize: size * 0.7))` with breathing animation | `Image.asset()` widget replacing the `Text` widget, keeping the `AnimatedBuilder` breathing + glow animation | Replace `Text(emoji, ...)` at L86-89 with `Image.asset('assets/images/dragons/dragon_egg_hub.png', width: size, height: size)`. Keep `Transform.scale` and `BoxShadow` glow intact. |
| 3 | `dragons/dragon_hatchling.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{1F423}` in `_evolutionEmojis[1]` | `Image.asset()` | Same pattern as #1, index 1 |
| 4 | `dragons/dragon_hatchling_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{1F423}` at index 1 | `Image.asset()` | Same pattern as #2, index 1 |
| 5 | `dragons/dragon_fledgling.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{1F425}` in `_evolutionEmojis[2]` | `Image.asset()` | Same pattern as #1, index 2 |
| 6 | `dragons/dragon_fledgling_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{1F409}` at index 2 | `Image.asset()` | Same pattern as #2, index 2 |
| 7 | `dragons/dragon_young.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{1F525}` in `_evolutionEmojis[3]` | `Image.asset()` | Same pattern as #1, index 3 |
| 8 | `dragons/dragon_young_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{1F525}` at index 3 | `Image.asset()` | Same pattern as #2, index 3 |
| 9 | `dragons/dragon_adult.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{2694}` in `_evolutionEmojis[4]` | `Image.asset()` | Same pattern as #1, index 4 |
| 10 | `dragons/dragon_adult_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{2694}` at index 4 | `Image.asset()` | Same pattern as #2, index 4 |
| 11 | `dragons/dragon_elder.png` | `lib/hub/profile_bar.dart` L12-19 | Emoji `\u{1F451}` in `_evolutionEmojis[5]` | `Image.asset()` | Same pattern as #1, index 5 |
| 12 | `dragons/dragon_elder_hub.png` | `lib/hub/dragon_companion.dart` L26-33 | Emoji `\u{1F451}` at index 5 | `Image.asset()` | Same pattern as #2, index 5 |

### 1.2 Hub Environment (5 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 13 | `hub/hub_background.png` | `lib/hub/hub_screen.dart` L59-63 | `Container` with `BoxDecoration(gradient: DragonColors.lairGradient)` -- a 3-stop LinearGradient (deepVoid -> dragonPurple -> nightSurface) | `DecorationImage` inside `BoxDecoration` with the gradient as a fallback | Replace `gradient: DragonColors.lairGradient` with `image: DecorationImage(image: AssetImage('assets/images/hub/hub_background.png'), fit: BoxFit.cover)`. Optionally keep the gradient as a `color` overlay. |
| 14 | `hub/hub_rune_portal.png` | `lib/hub/hub_screen.dart` L168-169 via `game_card.dart` L115-123 | `Container` with circular shape + `Icon(Icons.auto_awesome, ...)` Material icon inside color-tinted circle | `Image.asset()` replacing the icon container | In `hub_screen.dart` `_buildGameCards()`, replace `icon: Icons.auto_awesome` with an image path. In `game_card.dart`, add conditional rendering: if image path is provided, use `Image.asset()` instead of `Icon`. |
| 15 | `hub/hub_fire_tunnel.png` | `lib/hub/hub_screen.dart` L175 via `game_card.dart` L115-123 | `Icon(Icons.local_fire_department, ...)` Material icon | `Image.asset()` | Same pattern as #14 |
| 16 | `hub/hub_egg_nest.png` | `lib/hub/hub_screen.dart` L182 via `game_card.dart` L115-123 | `Icon(Icons.egg, ...)` Material icon | `Image.asset()` | Same pattern as #14 |
| 17 | `hub/hub_feast_table.png` | `lib/hub/hub_screen.dart` L189 via `game_card.dart` L115-123 | `Icon(Icons.restaurant, ...)` Material icon | `Image.asset()` | Same pattern as #14 |

### 1.3 Game Backgrounds (4 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 18 | `games/runes/runes_background.png` | `lib/games/dragon_runes/dragon_runes_game.dart` L313-316 | `GameWidget.backgroundBuilder` returns `Container(decoration: BoxDecoration(gradient: DragonColors.nightSky))` | `DecorationImage` in background builder | Replace the gradient with `DecorationImage(image: AssetImage('assets/images/games/runes/runes_background.png'), fit: BoxFit.cover)` in the `backgroundBuilder`. |
| 19 | `games/fire_trail/fire_trail_background.png` | `lib/games/fire_trail/components/grid_renderer.dart` L14-24 | Canvas-drawn `LinearGradient` (Night Sky colors: 0xFF0D0D1A -> 0xFF1A1A2E -> 0xFF16213E) filling a rect, plus grid lines drawn with `Paint` | `SpriteComponent` loaded in `FireTrailFlameGame.onLoad()`, rendered below the grid lines | Load the background image as a `Sprite` in `onLoad()` and add it as a `SpriteComponent` at priority -1. Keep the grid line rendering on top. |
| 20 | `games/dragon_eggs/dragon_eggs_background.png` | `lib/games/dragon_eggs/dragon_eggs_game.dart` (game screen wrapper) | The Flame game's `backgroundColor()` returns transparent (L451); the game screen wrapper likely uses a gradient | `DecorationImage` in the game screen wrapper's background | Add `DecorationImage` to the game screen's container background. |
| 21 | `games/dragons_feast/feast_background.png` | `lib/games/dragons_feast/components/feast_grid.dart` L23-56 | Canvas-drawn `LinearGradient` cells (0xFF1A2744 -> 0xFF16213E) with border strokes per cell | `SpriteComponent` for full background, grid borders drawn on top | Load background sprite in the Flame game's `onLoad()`, add at lowest priority. Keep the per-cell border rendering on top for grid visibility. |

### 1.4 Dragon Runes Game Assets (3 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 22 | `games/runes/rune_node_inactive.png` | `lib/games/dragon_runes/components/rune_node.dart` L34-87 | Canvas draws: `RadialGradient` circle (colors vary by node type -- number/operator/equals), `Paint` border stroke, `ParagraphBuilder` text | `SpriteComponent` base with text overlay | Load inactive node sprite in `DragonRunesFlameGame.onLoad()`. In `RuneNode.render()`, draw the sprite first, then overlay the text. Keep state-based glow (`_drawGlow`) and border color changes for inChain/correct/incorrect/hinted states. |
| 23 | `games/runes/rune_node_active.png` | `lib/games/dragon_runes/components/rune_node.dart` L34-87 | Same as above but with `NodeState.inChain` applying cyan glow | `SpriteComponent` swapped when node is in active chain | When `state == NodeState.inChain`, render the active sprite instead of inactive. |
| 24 | `games/runes/rune_spell_particle.png` | `lib/games/dragon_runes/components/spell_particle_effect.dart` L67-78 | Canvas `drawCircle()` for each particle with fading alpha | `SpriteComponent` per particle | Replace `canvas.drawCircle()` with drawing the particle sprite at each particle position. Use `Paint` color tinting for gold/purple variation. |

### 1.5 Fire Trail Game Assets (3 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 25 | `games/fire_trail/fire_dragon_head.png` | `lib/games/fire_trail/components/dragon_head.dart` L20-79 | Canvas draws: `RadialGradient` circle (ember to red based on intensity), white dot eye, directional triangle indicator via `Path` | `SpriteComponent` replacing the Canvas drawing | Load head sprite in `FireTrailFlameGame.onLoad()`. In `DragonHeadComponent`, render the sprite rotated based on `facing` direction (0/90/180/270 degrees). Apply `Paint` color tinting based on `flameIntensity` (lerp from dim to bright). Remove eye and triangle drawing. |
| 26 | `games/fire_trail/fire_gem_correct.png` | `lib/games/fire_trail/components/answer_gem.dart` L18-68 | Canvas draws: `LinearGradient` rounded rect (teal: 0xFF2D6E74 -> 0xFF1A4A4F), stroke border, `ParagraphBuilder` text for the number value | `SpriteComponent` base with text overlay | Load gem sprites in `onLoad()`. In `AnswerGemComponent.render()`, draw sprite first, then overlay the number text. All gems look the same to the player (cannot distinguish correct from wrong by appearance). |
| 27 | `games/fire_trail/fire_gem_wrong.png` | `lib/games/fire_trail/components/answer_gem.dart` L18-68 | Same rendering as correct gem (intentionally identical to player) | `SpriteComponent` base with text overlay | Same approach as #26. Since gems must look identical to the player, consider using the same sprite for both but keeping separate asset files for potential future differentiation. |

### 1.6 Dragon Eggs Game Assets (9 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 28 | `games/dragon_eggs/egg_cream.png` | `lib/games/dragon_eggs/components/egg_component.dart` L58-121 | Canvas draws: `RadialGradient` circle using `baseColor` (which is `DragonColors.eggCream` = 0xFFF5E6CA), white oval shine highlight, stroke border. Pop animation uses `canvas.scale()`. | `SpriteComponent` with tint, keeping pop animation | Load egg sprites by color in `DragonEggsFlameGame.onLoad()`. Map `baseColor` to the correct sprite. Keep the pop animation (`canvas.save/scale/restore`) and selection border logic. The text overlay for number values stays. |
| 29 | `games/dragon_eggs/egg_blue.png` | `lib/games/dragon_eggs/components/egg_component.dart` | Same as above with `DragonColors.eggBlue` (0xFFAED6F1) | `SpriteComponent` | Same pattern as #28, different sprite |
| 30 | `games/dragon_eggs/egg_green.png` | `lib/games/dragon_eggs/components/egg_component.dart` | Same with `DragonColors.eggGreen` (0xFFA9DFBF) | `SpriteComponent` | Same pattern as #28 |
| 31 | `games/dragon_eggs/egg_orange.png` | `lib/games/dragon_eggs/components/egg_component.dart` | Same with `DragonColors.eggOrange` (0xFFF5CBA7) | `SpriteComponent` | Same pattern as #28 |
| 32 | `games/dragon_eggs/egg_operator.png` | `lib/games/dragon_eggs/components/egg_component.dart` | Same with `DragonColors.eggOperator` (0xFFF4D03F) for operator eggs | `SpriteComponent` | Same pattern as #28 |
| 33 | `games/dragon_eggs/egg_division.png` | `lib/games/dragon_eggs/components/egg_component.dart` | Same with `DragonColors.eggDivision` (0xFF8E44AD) for division operator eggs | `SpriteComponent` | Same pattern as #28 |
| 34 | `games/dragon_eggs/egg_crack_1.png` | Not yet implemented | Currently eggs go straight from active to popping; no crack stage exists in the current code | New feature: add cracking visual state before pop | Add `EggState.cracking1` state. In `EggComponent.render()`, when state is cracking1, draw the crack_1 sprite overlaid on the egg sprite. |
| 35 | `games/dragon_eggs/egg_crack_2.png` | Not yet implemented | No crack stage 2 in current code | New feature | Add `EggState.cracking2` state, draw crack_2 sprite. |
| 36 | `games/dragon_eggs/baby_dragon_fly.png` | `lib/games/dragon_eggs/components/egg_pop_effect.dart` L1-71 | Particle burst effect: 8-13 particles using `canvas.drawCircle()` with gold/warm colors, gravity, fade | Sprite-based particle + baby dragon sprite flying upward | After the pop particle effect, spawn a small `SpriteComponent` with the baby dragon sprite that flies upward and fades out over ~1 second. The existing particle effect can stay as-is or use the particle sprite. |

### 1.7 Dragon's Feast Game Assets (12 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 37 | `games/dragons_feast/feast_dragon.png` | `lib/games/dragons_feast/components/dragon_character.dart` L22-105 | Canvas draws: `RadialGradient` circle body (color changes: green normally, gold with wings, blue with shield), white/black dot eye, horn lines via `drawLine()`, shield ring stroke | `SpriteComponent` with power-up state variants | Load the base dragon sprite plus tinted variants for wings (gold) and shield (blue) states. In `DragonCharacter.render()`, select sprite based on `hasWings`/`hasShield` state. Keep invulnerability flicker by modulating sprite opacity. Remove all Canvas drawing code. |
| 38 | `games/dragons_feast/feast_enemy_guardian.png` | `lib/games/dragons_feast/components/enemy_guardian.dart` L23-125 | Canvas draws: `RadialGradient` circle body (red for chaser, purple for wanderer; ice tints when frozen), white/black dot eyes, fang triangles (chaser) or glasses circles (wanderer) | `SpriteComponent` with chaser/wanderer variants | Load 2 enemy sprites (or use a single sprite with color tinting). Map `EnemyType.chaser` and `EnemyType.wanderer` to different sprites or tints. Apply ice-blue tint when `isFrozen`. Remove Canvas drawing code. |
| 39 | `games/dragons_feast/feast_gem_blue.png` | `lib/games/dragons_feast/components/feast_tile.dart` L41-128 | Canvas draws: `LinearGradient` rounded rect (0xFF1E2744 -> 0xFF16213E), border stroke, `TextPainter` number text. Flash states use solid color fills (green for correct, red for wrong). | `SpriteComponent` base with number overlay | Load gem sprites by category color. In `FeastTile.render()`, draw the appropriate gem sprite, then overlay the number text. Keep flash animation logic (correctFlash/wrongFlash as color overlays on top of the sprite). |
| 40 | `games/dragons_feast/feast_gem_purple.png` | Same as #39 | Same | Same | Same pattern, different sprite |
| 41 | `games/dragons_feast/feast_gem_gold.png` | Same as #39 | Same | Same | Same |
| 42 | `games/dragons_feast/feast_gem_teal.png` | Same as #39 | Same | Same | Same |
| 43 | `games/dragons_feast/feast_gem_red.png` | Same as #39 | Same | Same | Same |
| 44 | `games/dragons_feast/feast_gem_green.png` | Same as #39 | Same | Same | Same |
| 45 | `games/dragons_feast/feast_powerup_freeze.png` | `lib/games/dragons_feast/components/power_up_tile.dart` L27-83 | Canvas draws: pulsing glow rect via `MaskFilter.blur`, color-tinted background rect, `TextPainter` with single-char icon ('*' for freeze, 'W' for wings, 'S' for shield) | `SpriteComponent` with pulsing glow animation | Load power-up sprites by type. In `PowerUpTileComponent.render()`, draw the sprite. Add a pulsing glow overlay (existing `pulseTimer` logic). Remove text icons. |
| 46 | `games/dragons_feast/feast_powerup_wings.png` | Same as #45 | Same with icon 'W' | `SpriteComponent` | Same pattern |
| 47 | `games/dragons_feast/feast_powerup_shield.png` | Same as #45 | Same with icon 'S' | `SpriteComponent` | Same pattern |
| 48 | (no separate chaser/wanderer assets -- use #38 with tinting) | `lib/games/dragons_feast/components/enemy_guardian.dart` | Chaser: red body + fangs; Wanderer: purple body + glasses | Color tinting on single sprite or 2 separate sprites | See #38 |

### 1.8 UI Elements (7 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 49 | `ui/app_icon.png` | Android `mipmap` / iOS `Assets.xcassets` | Default Flutter placeholder | Platform icon sets | Export to all required sizes and place in `android/app/src/main/res/mipmap-*` and `ios/Runner/Assets.xcassets/AppIcon.appiconset/`. |
| 50 | `ui/badge_frame.png` | `lib/hub/achievement_screen.dart` L115-123 | Circular `Container` with color fill + emoji `Text(achievement.iconEmoji)` | `Image.asset()` badge frame with emoji overlaid on top | Wrap the badge icon container with a `Stack`: badge_frame image behind, emoji or custom icon in front. |
| 51 | `ui/icon_star_filled.png` | `lib/games/shared/result_screen.dart` L233-234 | `Icon(Icons.star, color: DragonColors.dragonGold, size: 40)` Material icon | `Image.asset()` | Replace `Icon(Icons.star)` with `Image.asset('assets/images/ui/icon_star_filled.png', width: 40, height: 40)`. Also used in `game_card.dart` L159-165 (size: 14) and `level_select_screen.dart` L191-197 (size: 12). |
| 52 | `ui/icon_star_empty.png` | `lib/games/shared/result_screen.dart` L233-234 | `Icon(Icons.star_border, color: DragonColors.disabled, size: 40)` | `Image.asset()` | Replace `Icon(Icons.star_border)` with `Image.asset('assets/images/ui/icon_star_empty.png', ...)`. Same files as #51. |
| 53 | `ui/icon_scale.png` | `lib/hub/profile_bar.dart` L118-119, `lib/games/shared/game_shell.dart` L179-180, `lib/games/shared/result_screen.dart` L335, `lib/monetization/store_screen.dart` L151-152 | `Icon(Icons.diamond, color: DragonColors.dragonGold, size: 16)` Material diamond icon used as currency indicator | `Image.asset()` | Replace all `Icons.diamond` instances with `Image.asset('assets/images/ui/icon_scale.png', width: size, height: size)`. Multiple sizes needed: 10, 14, 16, 18, 20. |
| 54 | `ui/icon_streak_flame.png` | `lib/hub/daily_challenge_card.dart` L158-160, `lib/games/fire_trail/widgets/flame_meter.dart` | `Icon(Icons.local_fire_department, color: DragonColors.fireOrange, size: 14)` Material icon | `Image.asset()` | Replace `Icons.local_fire_department` in streak indicators with `Image.asset('assets/images/ui/icon_streak_flame.png', width: 14, height: 14)`. |
| 55 | `ui/feature_graphic.png` | Not in app code | Used only for Google Play Store listing | N/A -- store asset only | Place in `assets/images/ui/` for reference; primarily used in Play Store console upload. |

### 1.9 Store / Cosmetic Assets (20 images)

| # | Asset File | Dart File | Current Rendering | Replacement | Code Changes |
|---|-----------|-----------|-------------------|-------------|--------------|
| 56-63 | `dragons/dragon_color_variant_*.png` (8 files) | `lib/monetization/store_screen.dart` L355-365 | `Container` with `previewColor` fill + emoji `Text(item.previewEmoji)` inside 48x48 circle | `Image.asset()` in the preview circle | In `_CosmeticTile`, replace the emoji+color circle with `Image.asset('assets/images/dragons/dragon_color_variant_${item.id.replaceFirst('color_', '')}.png', width: 48, height: 48)`. Map item IDs to file names. |
| 64-69 | `dragons/acc_*.png` (6 files) | `lib/monetization/store_screen.dart` L355-365 | Same pattern: emoji `Text(item.previewEmoji)` inside container | `Image.asset()` | Replace emoji with `Image.asset('assets/images/dragons/${item.id}.png', width: 48, height: 48)`. The store code's `CosmeticItem.previewEmoji` field can be deprecated or kept as fallback. |

### 1.10 Particle Effects and Supplementary Components

These existing Flame components use Canvas-drawn particles. They can optionally be enhanced with sprite particles but are lower priority since the procedural approach already looks good.

| Component | Dart File | Current Rendering | Optional Enhancement |
|-----------|-----------|-------------------|---------------------|
| GemSparkleEffect | `lib/games/fire_trail/components/gem_sparkle_effect.dart` | `drawCircle()` particles with gold color, gravity, fade | Could use `rune_spell_particle.png` as particle texture |
| SpellParticleEffect | `lib/games/dragon_runes/components/spell_particle_effect.dart` | `drawCircle()` particles in gold/purple | Could use `rune_spell_particle.png` |
| EggPopEffect | `lib/games/dragon_eggs/components/egg_pop_effect.dart` | `drawCircle()` particles in gold/warm colors | Keep procedural; add baby_dragon_fly sprite after |
| MunchEffect | `lib/games/dragons_feast/components/munch_effect.dart` | `drawCircle()` particles green/red | Keep procedural |
| CaughtEffect | `lib/games/dragons_feast/components/caught_effect.dart` | Expanding ring via `drawCircle()` stroke | Keep procedural |
| HintHighlight | `lib/games/dragon_runes/components/hint_highlight.dart` | Pulsing gold blur circle | Keep procedural |
| DangerLine | `lib/games/dragon_eggs/components/danger_line.dart` | `LinearGradient` red + dashed line | Keep procedural |
| TrailSegment | `lib/games/fire_trail/components/trail_segment.dart` | Color-lerped rounded rect, fading from head to tail | Keep procedural (trail rendering is dynamic and color-dependent) |

---

## 2. Hub Screen Art Integration

### 2.1 Hub Background

**File**: `lib/hub/hub_screen.dart`
**Current** (L59-63):
```dart
Container(
  decoration: const BoxDecoration(
    gradient: DragonColors.lairGradient,
  ),
  child: SafeArea( ... ),
)
```

**Replacement**:
```dart
Container(
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/hub/hub_background.png'),
      fit: BoxFit.cover,
      alignment: Alignment.center,
    ),
  ),
  child: SafeArea( ... ),
)
```

**Notes**:
- The `lairGradient` can be kept as a fallback overlay for darkening the top and bottom edges where UI sits.
- Consider a `Stack` with the background image underneath and a semi-transparent gradient overlay on top for readability.
- The image at 1920x1080 is large; use `filterQuality: FilterQuality.medium` for smooth display.

### 2.2 Dragon Companion

**File**: `lib/hub/dragon_companion.dart`
**Current** (L25-33, L62-94):
```dart
static const _evolutionEmojis = [
  '\u{1F95A}', // egg
  '\u{1F423}', // hatching chick
  '\u{1F409}', // dragon
  '\u{1F525}', // fire
  '\u{2694}',  // swords
  '\u{1F451}', // crown
];
// ...
Text(emoji, style: TextStyle(fontSize: size * 0.7))
```

**Replacement**:
```dart
static const _evolutionAssets = [
  'assets/images/dragons/dragon_egg_hub.png',
  'assets/images/dragons/dragon_hatchling_hub.png',
  'assets/images/dragons/dragon_fledgling_hub.png',
  'assets/images/dragons/dragon_young_hub.png',
  'assets/images/dragons/dragon_adult_hub.png',
  'assets/images/dragons/dragon_elder_hub.png',
];
// ...
Image.asset(
  _evolutionAssets[stage],
  width: size,
  height: size,
  filterQuality: FilterQuality.medium,
)
```

**Preserved behavior**: The `AnimatedBuilder` with `_breathAnimation` (scale 1.0 to 1.03) and `_glowAnimation` (gold BoxShadow pulsing) remain unchanged -- they wrap the image widget instead of the text widget.

### 2.3 Game Card Portal Icons

**File**: `lib/hub/game_card.dart`
**Current** (L115-123):
```dart
Container(
  width: 52, height: 52,
  decoration: BoxDecoration(
    color: widget.accentColor.withValues(alpha: 0.15),
    shape: BoxShape.circle,
  ),
  child: Icon(widget.icon, color: widget.accentColor, size: 28),
)
```

**Replacement approach**: Add an optional `imageAsset` field to `GameCard`. When provided, render an image instead of an icon.

```dart
// In GameCard widget:
final String? imageAsset;

// In build method:
Container(
  width: 52, height: 52,
  decoration: BoxDecoration(
    color: widget.accentColor.withValues(alpha: 0.15),
    shape: BoxShape.circle,
  ),
  child: widget.imageAsset != null
    ? ClipOval(
        child: Image.asset(
          widget.imageAsset!,
          width: 48, height: 48,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      )
    : Icon(widget.icon, color: widget.accentColor, size: 28),
)
```

**Hub screen changes** (`lib/hub/hub_screen.dart` L163-206): Add `imageAsset` to each game record:
```dart
(
  id: 'dragon_runes',
  imageAsset: 'assets/images/hub/hub_rune_portal.png',
  // ...
)
```

### 2.4 Profile Bar Evolution Indicator

**File**: `lib/hub/profile_bar.dart`
**Current** (L12-19, L61-66):
```dart
static const _evolutionEmojis = [ ... ];
// ...
Text(evolutionEmoji, style: const TextStyle(fontSize: 20))
```

**Replacement**:
```dart
static const _evolutionAssets = [
  'assets/images/dragons/dragon_egg.png',
  'assets/images/dragons/dragon_hatchling.png',
  'assets/images/dragons/dragon_fledgling.png',
  'assets/images/dragons/dragon_young.png',
  'assets/images/dragons/dragon_adult.png',
  'assets/images/dragons/dragon_elder.png',
];
// ...
Image.asset(
  _evolutionAssets[stage],
  width: 28, height: 28,
  filterQuality: FilterQuality.medium,
)
```

### 2.5 Scale Currency Icon

**Files**: Multiple -- `profile_bar.dart` L118, `game_shell.dart` L179, `result_screen.dart` L335, `store_screen.dart` L151

**Current**: `Icon(Icons.diamond, color: DragonColors.dragonGold, size: N)`

**Replacement**: Create a helper widget:
```dart
class ScaleIcon extends StatelessWidget {
  final double size;
  const ScaleIcon({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ui/icon_scale.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
    );
  }
}
```

Replace all `Icon(Icons.diamond, ...)` instances with `ScaleIcon(size: N)`.

---

## 3. Game-Specific Art Integration

### 3.1 Fire Trail

#### Background
**File**: `lib/games/fire_trail/components/grid_renderer.dart`

The `GridRenderer` currently draws a Night Sky gradient as the background and subtle grid lines. The background image replaces only the gradient fill.

```dart
class GridRenderer extends PositionComponent {
  Sprite? backgroundSprite; // Add field

  @override
  void render(Canvas canvas) {
    final fieldSize = gridSize * cellSize;

    // Draw background image if available, else fall back to gradient
    if (backgroundSprite != null) {
      backgroundSprite!.render(
        canvas,
        size: Vector2(fieldSize, fieldSize),
      );
    } else {
      // Original gradient code
      final bgPaint = Paint()
        ..shader = const LinearGradient( ... ).createShader( ... );
      canvas.drawRect( ... , bgPaint);
    }

    // Grid lines remain unchanged
    // ...
  }
}
```

In `FireTrailFlameGame.onLoad()`:
```dart
final bgImage = await images.load('games/fire_trail/fire_trail_background.png');
final gridRenderer = GridRenderer(gridSize: gridSize, cellSize: cellSize);
gridRenderer.backgroundSprite = Sprite(bgImage);
add(gridRenderer);
```

#### Dragon Head
**File**: `lib/games/fire_trail/components/dragon_head.dart`

```dart
class DragonHeadComponent extends PositionComponent {
  Sprite? sprite; // Add
  Direction facing;
  double flameIntensity;

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);

      // Rotate based on facing direction
      final angle = switch (facing) {
        Direction.right => 0.0,
        Direction.down  => pi / 2,
        Direction.left  => pi,
        Direction.up    => -pi / 2,
      };
      canvas.rotate(angle);
      canvas.translate(-size.x / 2, -size.y / 2);

      // Tint based on flame intensity
      final brightness = 0.5 + flameIntensity * 0.5;
      final paint = Paint()
        ..colorFilter = ColorFilter.mode(
          Color.lerp(const Color(0xFF8B2500), Colors.white, brightness)!,
          BlendMode.modulate,
        );

      sprite!.render(canvas, size: size, overridePaint: paint);
      canvas.restore();
    } else {
      // Fallback: original Canvas drawing
      // ...
    }
  }
}
```

#### Answer Gems
**File**: `lib/games/fire_trail/components/answer_gem.dart`

```dart
class AnswerGemComponent extends PositionComponent {
  Sprite? sprite; // Add -- same sprite for correct and wrong
  final int value;
  final bool isCorrect;

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      _drawText(canvas, '$value'); // Keep text overlay
    } else {
      // Fallback: original Canvas drawing
    }
  }
}
```

### 3.2 Dragon Runes

#### Rune Nodes
**File**: `lib/games/dragon_runes/components/rune_node.dart`

The node rendering is complex with state-dependent glows and borders. The sprite replaces only the background circle, not the glow or border logic.

```dart
class RuneNode extends PositionComponent {
  Sprite? inactiveSprite;
  Sprite? activeSprite;

  @override
  void render(Canvas canvas) {
    const center = Offset(0, 0);

    // 1. Draw state-based glow (KEEP -- this is overlay logic)
    if (state == NodeState.inChain) {
      _drawGlow(canvas, center, const Color(0xFF66E3FF), 0.3);
    }
    // ... other states

    // 2. Draw node background (REPLACE)
    final nodeSprite = (state == NodeState.inChain)
        ? activeSprite
        : inactiveSprite;

    if (nodeSprite != null) {
      nodeSprite.render(
        canvas,
        position: Vector2(-nodeRadius, -nodeRadius),
        size: Vector2.all(nodeRadius * 2),
      );
    } else {
      // Fallback: original RadialGradient circle
    }

    // 3. Draw state border (KEEP)
    // ... unchanged border code

    // 4. Draw text (KEEP)
    _drawText(canvas, data.value, textColor);
  }
}
```

#### Background
**File**: `lib/games/dragon_runes/dragon_runes_game.dart` L313-316

Replace the `backgroundBuilder` gradient:
```dart
backgroundBuilder: (_) => Container(
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/games/runes/runes_background.png'),
      fit: BoxFit.cover,
    ),
  ),
),
```

### 3.3 Dragon Eggs

#### Egg Sprites
**File**: `lib/games/dragon_eggs/components/egg_component.dart`

The egg component is the most complex replacement because it has physics-driven positioning, tap handling, selection states, and pop animations.

```dart
class EggComponent extends PositionComponent with TapCallbacks {
  Sprite? sprite; // Add

  @override
  void render(Canvas canvas) {
    if (state == EggState.dead) return;

    final center = Offset(radius, radius);
    double scale = 1.0;

    // Pop animation (KEEP)
    if (state == EggState.popping) {
      // ... existing scale logic
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(scale);
      canvas.translate(-center.dx, -center.dy);
    }

    // Draw egg (REPLACE body + shine + highlight)
    if (sprite != null) {
      sprite!.render(canvas, size: Vector2.all(radius * 2));
    } else {
      // Fallback: original gradient circle + shine
    }

    // Draw selection border (KEEP -- visual feedback)
    if (state == EggState.selected) {
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = DragonColors.dragonGold;
      canvas.drawCircle(center, radius, borderPaint);
    }

    // Draw value text (KEEP)
    if (state != EggState.popping) {
      _drawText(canvas, center);
    }

    if (state == EggState.popping) canvas.restore();
  }
}
```

**Sprite loading in `DragonEggsFlameGame.onLoad()`**:
```dart
final eggSprites = <Color, Sprite>{};
eggSprites[DragonColors.eggCream] = Sprite(
  await images.load('games/dragon_eggs/egg_cream.png'));
eggSprites[DragonColors.eggBlue] = Sprite(
  await images.load('games/dragon_eggs/egg_blue.png'));
eggSprites[DragonColors.eggGreen] = Sprite(
  await images.load('games/dragon_eggs/egg_green.png'));
eggSprites[DragonColors.eggOrange] = Sprite(
  await images.load('games/dragon_eggs/egg_orange.png'));
eggSprites[DragonColors.eggOperator] = Sprite(
  await images.load('games/dragon_eggs/egg_operator.png'));
eggSprites[DragonColors.eggDivision] = Sprite(
  await images.load('games/dragon_eggs/egg_division.png'));
```

Then pass the appropriate sprite to each `EggComponent` when spawned.

### 3.4 Dragon's Feast

#### Player Character
**File**: `lib/games/dragons_feast/components/dragon_character.dart`

```dart
class DragonCharacter extends PositionComponent {
  Sprite? normalSprite;
  Sprite? wingsSprite;  // Gold-tinted variant
  Sprite? shieldSprite; // Blue-tinted variant

  @override
  void render(Canvas canvas) {
    final sprite = hasWings ? wingsSprite
        : hasShield ? shieldSprite
        : normalSprite;

    if (sprite != null) {
      // Invulnerability flicker
      final paint = isInvulnerable
          ? (Paint()..color = Color.fromRGBO(255, 255, 255,
              (DateTime.now().millisecondsSinceEpoch % 200) > 100 ? 1.0 : 0.4))
          : null;

      sprite.render(
        canvas,
        position: Vector2(-cellSize * 0.4, -cellSize * 0.4),
        size: Vector2.all(cellSize * 0.8),
        overridePaint: paint,
      );

      // Shield ring overlay (KEEP if hasShield)
      if (hasShield) { /* ... existing shield ring code */ }
    } else {
      // Fallback: original Canvas drawing
    }
  }
}
```

#### Enemy Guardian
**File**: `lib/games/dragons_feast/components/enemy_guardian.dart`

```dart
class EnemyGuardian extends PositionComponent {
  Sprite? chaserSprite;
  Sprite? wandererSprite;
  Sprite? chaserFrozenSprite; // Blue-tinted chaser
  Sprite? wandererFrozenSprite; // Light purple-tinted wanderer

  @override
  void render(Canvas canvas) {
    final sprite = switch ((data.type, isFrozen)) {
      (EnemyType.chaser, true)   => chaserFrozenSprite,
      (EnemyType.chaser, false)  => chaserSprite,
      (EnemyType.wanderer, true) => wandererFrozenSprite,
      (EnemyType.wanderer, false) => wandererSprite,
    };

    if (sprite != null) {
      sprite.render(
        canvas,
        position: Vector2(-cellSize * 0.35, -cellSize * 0.35),
        size: Vector2.all(cellSize * 0.7),
      );
    } else {
      // Fallback: original Canvas drawing
    }
  }
}
```

#### Power-Up Tiles
**File**: `lib/games/dragons_feast/components/power_up_tile.dart`

```dart
class PowerUpTileComponent extends PositionComponent {
  Sprite? freezeSprite;
  Sprite? wingsSprite;
  Sprite? shieldSprite;

  @override
  void render(Canvas canvas) {
    final sprite = switch (type) {
      PowerUpType.freeze => freezeSprite,
      PowerUpType.wings  => wingsSprite,
      PowerUpType.shield => shieldSprite,
    };

    final rect = Rect.fromLTWH(0, 0, cellSize, cellSize);
    final pulse = 0.8 + 0.2 * sin(pulseTimer * 4);

    // Pulsing glow (KEEP)
    final glowColor = /* ... existing color logic ... */;
    final glowPaint = Paint()
      ..color = glowColor.withAlpha((0.3 * pulse * 255).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      glowPaint,
    );

    // Sprite (REPLACE text icon)
    if (sprite != null) {
      sprite.render(canvas, size: Vector2.all(cellSize));
    } else {
      // Fallback: existing TextPainter icon code
    }
  }
}
```

---

## 4. Flame Sprite Loading Patterns

### 4.1 Loading Sprites in FlameGame.onLoad()

Flame provides an `images` cache on every `FlameGame` instance. All game sprites should be loaded in `onLoad()`.

```dart
class FireTrailFlameGame extends FlameGame {
  // Pre-loaded sprites
  late final Sprite dragonHeadSprite;
  late final Sprite gemSprite;
  late final Sprite backgroundSprite;

  @override
  Future<void> onLoad() async {
    // Load all sprites during game initialization
    final headImage = await images.load('games/fire_trail/fire_dragon_head.png');
    dragonHeadSprite = Sprite(headImage);

    final gemImage = await images.load('games/fire_trail/fire_gem_correct.png');
    gemSprite = Sprite(gemImage);

    final bgImage = await images.load('games/fire_trail/fire_trail_background.png');
    backgroundSprite = Sprite(bgImage);

    // ... rest of onLoad
  }
}
```

**Important**: Flame's `images.load()` loads from the `assets/images/` directory by default. The path passed is relative to `assets/images/`. So `images.load('games/fire_trail/fire_dragon_head.png')` loads from `assets/images/games/fire_trail/fire_dragon_head.png`.

### 4.2 SpriteComponent for Static Images

For background images that do not change, use `SpriteComponent`:

```dart
final background = SpriteComponent(
  sprite: backgroundSprite,
  size: size, // game viewport size
  priority: -1, // render behind everything
);
add(background);
```

### 4.3 Rendering Sprites in Custom Components

For components with custom `render()` methods (like `DragonHeadComponent`), render the sprite directly on the canvas:

```dart
@override
void render(Canvas canvas) {
  sprite.render(
    canvas,
    size: size,
    overridePaint: customPaint, // optional tinting/opacity
  );
}
```

### 4.4 Sprite Tinting

To change sprite color (e.g., frozen enemies, flame intensity):

```dart
final tintPaint = Paint()
  ..colorFilter = ColorFilter.mode(
    Colors.blue.withAlpha(128),
    BlendMode.srcATop,
  );

sprite.render(canvas, size: size, overridePaint: tintPaint);
```

### 4.5 Sprite Rotation

For directional sprites (dragon head facing different directions):

```dart
canvas.save();
canvas.translate(size.x / 2, size.y / 2);
canvas.rotate(angleInRadians);
canvas.translate(-size.x / 2, -size.y / 2);
sprite.render(canvas, size: size);
canvas.restore();
```

Or use `SpriteComponent.angle`:
```dart
final component = SpriteComponent(sprite: headSprite, size: cellSize)
  ..angle = directionAngle;
```

### 4.6 SpriteAnimationComponent (Future Use)

If sprite sheets are created later for animated characters:

```dart
final spriteSheet = SpriteSheet(
  image: await images.load('dragon_walk_sheet.png'),
  srcSize: Vector2(64, 64),
);

final animation = spriteSheet.createAnimation(
  row: 0,
  stepTime: 0.1,
  to: 8, // 8 frames
);

add(SpriteAnimationComponent(
  animation: animation,
  size: Vector2(64, 64),
));
```

---

## 5. Flutter Image Widget Patterns

### 5.1 Image.asset() for Hub Screen Elements

```dart
// Basic usage
Image.asset(
  'assets/images/hub/hub_rune_portal.png',
  width: 48,
  height: 48,
  filterQuality: FilterQuality.medium,
)

// With error handling (fallback if asset missing)
Image.asset(
  'assets/images/dragons/dragon_egg_hub.png',
  width: size,
  height: size,
  filterQuality: FilterQuality.medium,
  errorBuilder: (context, error, stackTrace) {
    // Fallback to emoji or icon
    return Text('\u{1F95A}', style: TextStyle(fontSize: size * 0.7));
  },
)
```

### 5.2 DecorationImage for Backgrounds

```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/hub/hub_background.png'),
      fit: BoxFit.cover,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(
        Colors.black.withAlpha(40), // slight darkening overlay
        BlendMode.darken,
      ),
    ),
  ),
  child: /* ... */,
)
```

### 5.3 Precaching Images

For hub screen images that must appear immediately without flicker:

```dart
// In hub_screen.dart initState or the app's main initialization
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(
    const AssetImage('assets/images/hub/hub_background.png'),
    context,
  );
  precacheImage(
    const AssetImage('assets/images/dragons/dragon_egg_hub.png'),
    context,
  );
  // ... other frequently used images
}
```

### 5.4 ClipOval for Circular Portraits

```dart
ClipOval(
  child: Image.asset(
    'assets/images/dragons/dragon_young.png',
    width: 40,
    height: 40,
    fit: BoxFit.cover,
  ),
)
```

---

## 6. Multi-Density Asset Handling

### 6.1 Directory Structure

Flutter supports automatic resolution-aware asset loading. For images that need to be crisp on high-density displays, provide multiple density variants:

```
assets/images/ui/icon_scale.png          <- 1x (32x32)
assets/images/ui/1.5x/icon_scale.png     <- 1.5x (48x48)
assets/images/ui/2.0x/icon_scale.png     <- 2.0x (64x64)
assets/images/ui/3.0x/icon_scale.png     <- 3.0x (96x96)
assets/images/ui/4.0x/icon_scale.png     <- 4.0x (128x128)
```

### 6.2 Which Assets Need Multi-Density

**High priority** (displayed at small sizes on all screens):
- `ui/icon_scale.png` (16-32dp, used on every screen)
- `ui/icon_star_filled.png` (12-40dp, used on many screens)
- `ui/icon_star_empty.png` (12-40dp)
- `ui/icon_streak_flame.png` (14-24dp)

**Medium priority** (displayed at moderate sizes):
- Dragon evolution portraits in profile bar (28dp)
- Hub companion images (64-104dp)
- Game portal images in game cards (48dp)

**Low priority** (already large enough or only displayed at one size):
- Game backgrounds (1920x1080 -- already high-res)
- Flame game sprites (rendered at Flame canvas resolution, not Flutter density)
- Store variant portraits (128px -- large enough for 3x screens)

### 6.3 Flutter's Automatic Resolution

When you register only the base directory in `pubspec.yaml`:
```yaml
assets:
  - assets/images/ui/
```

Flutter automatically looks for density variants in subdirectories (`2.0x/`, `3.0x/`, etc.). You do NOT need to register each density directory separately.

### 6.4 Flame Assets and Density

Flame loads images from `assets/images/` and does NOT use Flutter's density resolution. All Flame sprites should be loaded at their maximum desired resolution (typically 1x). Since Flame games render to a canvas that is scaled independently, a single high-resolution asset is sufficient. Do not provide multi-density variants for Flame game sprites.

---

## 7. Migration Strategy

### Phase 1: Hub Screen (Most Visible, Easiest) -- Priority HIGH

**Estimated effort**: 2-3 hours
**Risk level**: Low (no game logic affected)

**Steps**:
1. Place `hub_background.png` in `assets/images/hub/`.
2. Replace the `lairGradient` in `hub_screen.dart` with `DecorationImage`.
3. Replace all 6 `_evolutionEmojis` in `dragon_companion.dart` with `_evolutionAssets` image paths.
4. Replace all 6 `_evolutionEmojis` in `profile_bar.dart` with image paths.
5. Replace the emoji in the evolution dialog (`_showEvolutionDialog`).
6. Replace `Icons.diamond` with `ScaleIcon` widget across `profile_bar.dart`, `game_shell.dart`, `result_screen.dart`, `store_screen.dart`.
7. Add `imageAsset` parameter to `GameCard` and pass hub portal images.
8. Test on multiple screen sizes.

**Validation**: Visual comparison on hub screen. No logic changes, only rendering.

### Phase 2: Game Backgrounds (Non-Interactive, Low Risk) -- Priority HIGH

**Estimated effort**: 1-2 hours
**Risk level**: Low (background images do not interact with game logic)

**Steps**:
1. Place all 4 game background images in their respective `assets/images/games/` directories.
2. Fire Trail: Load background sprite in `FireTrailFlameGame.onLoad()`, pass to `GridRenderer`.
3. Dragon Runes: Replace `backgroundBuilder` gradient with `DecorationImage`.
4. Dragon Eggs: Add `DecorationImage` background to the game screen wrapper.
5. Dragon's Feast: Load background sprite in the Feast Flame game's `onLoad()`.
6. Test each game to ensure backgrounds render correctly and do not interfere with game elements.

**Validation**: Play each game briefly to confirm backgrounds display, game elements remain visible.

### Phase 3: Game Sprites (Interactive, Needs Testing) -- Priority MEDIUM

**Estimated effort**: 6-8 hours
**Risk level**: Medium (sprites must match hitboxes, sizes, and positions exactly)

**Steps**:
1. **Fire Trail** (simplest Flame game):
   a. Load `fire_dragon_head.png` in `onLoad()`, pass to `DragonHeadComponent`.
   b. Load gem sprites, pass to `AnswerGemComponent`.
   c. Test: movement, direction facing, gem collision, gem eating, pop effects.

2. **Dragon Runes**:
   a. Load `rune_node_inactive.png` and `rune_node_active.png` in `onLoad()`.
   b. Pass to `RuneNode` components.
   c. Test: node rendering, drag-to-connect, state transitions (idle/chain/correct/incorrect/hinted).

3. **Dragon Eggs**:
   a. Load all 6 egg color sprites in `onLoad()`.
   b. Map `baseColor` to the corresponding sprite in `EggSpawner`.
   c. Pass sprite to each `EggComponent` on creation.
   d. Test: spawning, physics, tapping, selection, pop animation, game over detection.

4. **Dragon's Feast** (most complex):
   a. Load player dragon, enemy, power-up, and gem sprites in `onLoad()`.
   b. Pass to `DragonCharacter`, `EnemyGuardian`, `PowerUpTileComponent`, `FeastTile`.
   c. Test: player movement, enemy AI, collisions, power-up activation, invulnerability, tile eating.

**Validation**: Run full test suite (`flutter test`). Play each game through multiple levels. Verify hitboxes align with sprite visuals.

### Phase 4: UI Elements and Store Assets (Stars, Badges, Icons) -- Priority LOW

**Estimated effort**: 2-3 hours
**Risk level**: Low

**Steps**:
1. Replace `Icons.star` / `Icons.star_border` with custom star image widgets in `result_screen.dart`, `game_card.dart`, `level_select_screen.dart`.
2. Replace `Icons.local_fire_department` streak icons in `daily_challenge_card.dart`.
3. Replace emoji previews in `store_screen.dart` with variant portrait images.
4. Replace emoji previews for accessories with accessory images.
5. Add badge frame image to `achievement_screen.dart`.
6. Replace app icon in Android/iOS platform directories.
7. Test store purchase/equip flow, achievement display, result screen animations.

**Validation**: Visual inspection of all UI screens. Verify star animations still work.

---

## 8. Performance Considerations

### 8.1 Image Caching in Flame

Flame's `FlameGame.images` provides a built-in image cache. Once `images.load('path')` is called, the image is cached in memory for the lifetime of the game instance.

**Best practice**: Load all game sprites in `onLoad()` before gameplay begins. This prevents mid-game loading stutter.

```dart
@override
Future<void> onLoad() async {
  // Load ALL sprites upfront
  final futures = [
    images.load('games/fire_trail/fire_dragon_head.png'),
    images.load('games/fire_trail/fire_gem_correct.png'),
    images.load('games/fire_trail/fire_trail_background.png'),
  ];
  final loaded = await Future.wait(futures);
  dragonHeadSprite = Sprite(loaded[0]);
  gemSprite = Sprite(loaded[1]);
  backgroundSprite = Sprite(loaded[2]);
}
```

### 8.2 Memory Budget

**Estimated per-game memory usage**:

| Asset Type | Size | Memory (RGBA) | Count | Total |
|-----------|------|--------------|-------|-------|
| Background (1920x1080) | 1920x1080 | ~8 MB | 1 | ~8 MB |
| Player sprite (64x64) | 64x64 | ~16 KB | 1-3 | ~48 KB |
| Game element sprites (48-64px) | 64x64 | ~16 KB | 5-10 | ~160 KB |
| **Per-game total** | | | | **~8.2 MB** |

**Hub screen memory**:

| Asset Type | Size | Memory | Count | Total |
|-----------|------|--------|-------|-------|
| Hub background (1920x1080) | 1920x1080 | ~8 MB | 1 | ~8 MB |
| Hub companion (256x256) | 256x256 | ~256 KB | 1 | ~256 KB |
| Portal images (256x256) | 256x256 | ~256 KB | 4 | ~1 MB |
| Evolution portraits (512x512) | 512x512 | ~1 MB | 1 | ~1 MB |
| UI icons (32x32) | 32x32 | ~4 KB | 6 | ~24 KB |
| **Hub total** | | | | **~10.3 MB** |

**Total peak memory** (hub + one game): ~18.5 MB of image data. This is well within mobile device limits (most devices have 2-8 GB RAM; apps typically budget 100-200 MB).

### 8.3 Lazy Loading Per Game Screen

Only load game sprites when entering a game screen. Dispose when leaving.

```dart
// In the game screen (e.g., FireTrailScreen)
@override
void dispose() {
  // Flame's game.images cache is tied to the game instance.
  // When the FlameGame is removed, its image cache is eligible for GC.
  super.dispose();
}
```

For the hub screen, precache images in `didChangeDependencies()` since the hub is visited frequently.

### 8.4 Image Compression

Before bundling assets, optimize PNG files:

- **pngquant**: Lossy PNG compression, reduces file size by 50-70% with minimal visual quality loss.
- **optipng**: Lossless PNG optimization.
- **Target file sizes**:
  - Backgrounds: < 2 MB each (use pngquant with quality 65-80)
  - Game sprites: < 50 KB each
  - UI icons: < 10 KB each
  - Total app asset increase: ~15-20 MB

### 8.5 Disposing Images When Leaving Screens

Flutter `Image.asset()` widgets are cached by the framework's `ImageCache` (default 1000 images, 100 MB). This is generally fine for our asset count.

For Flame games, images are cached per `FlameGame` instance. When the game widget is disposed, its images become eligible for garbage collection. No manual disposal is needed.

If memory becomes a concern on low-end devices, consider:
```dart
// Force clear Flutter's image cache when leaving a game
PaintingBinding.instance.imageCache.clear();
PaintingBinding.instance.imageCache.clearLiveImages();
```

---

## 9. pubspec.yaml Changes

### Current Asset Registration

```yaml
flutter:
  assets:
    - assets/images/dragons/
    - assets/images/hub/
    - assets/images/games/
    - assets/images/ui/
    - assets/animations/
    - assets/sounds/music/
    - assets/sounds/sfx/
```

### Required Changes

The current asset directories are already registered at the top level. However, Flame loads images relative to `assets/images/`, so subdirectories within `assets/images/games/` need to exist and contain the files. Flutter's asset bundler includes all files in registered directories and their subdirectories.

**Add game-specific subdirectories** (these are technically included by the `- assets/images/games/` entry, but being explicit helps clarity):

```yaml
flutter:
  assets:
    - assets/images/dragons/
    - assets/images/hub/
    - assets/images/games/
    - assets/images/games/runes/
    - assets/images/games/fire_trail/
    - assets/images/games/dragon_eggs/
    - assets/images/games/dragons_feast/
    - assets/images/ui/
    - assets/animations/
    - assets/sounds/music/
    - assets/sounds/sfx/
```

**Important note on Flutter asset bundling**: Registering `- assets/images/games/` only bundles files directly in that directory, NOT in subdirectories. You MUST register each subdirectory explicitly:

```yaml
    - assets/images/games/runes/
    - assets/images/games/fire_trail/
    - assets/images/games/dragon_eggs/
    - assets/images/games/dragons_feast/
```

**For multi-density UI assets**, add density subdirectories:
```yaml
    - assets/images/ui/
    - assets/images/ui/1.5x/
    - assets/images/ui/2.0x/
    - assets/images/ui/3.0x/
    - assets/images/ui/4.0x/
```

### Directory Creation

Before placing assets, ensure all directories exist:

```
assets/images/dragons/          <- evolution portraits, color variants, accessories
assets/images/hub/              <- hub background, game portals
assets/images/games/runes/      <- rune node sprites, runes background
assets/images/games/fire_trail/ <- dragon head, gems, fire trail background
assets/images/games/dragon_eggs/<- egg sprites, dragon eggs background
assets/images/games/dragons_feast/ <- feast sprites, feast background
assets/images/ui/               <- app icon, stars, scale, streak, badge
assets/images/ui/2.0x/          <- 2x density UI icons
assets/images/ui/3.0x/          <- 3x density UI icons
```

---

## 10. Fallback Strategy

### 10.1 Design Principle

Every art replacement should have a graceful fallback to the existing procedural rendering. This allows incremental migration -- the app works correctly even if only some assets are ready.

### 10.2 Flutter Widget Fallback Pattern

Use `Image.asset()` with `errorBuilder` to fall back to the current rendering:

```dart
Widget _buildDragonPortrait(int stage) {
  final assetPath = _evolutionAssets[stage];
  final emoji = _evolutionEmojis[stage]; // Keep old list

  return Image.asset(
    assetPath,
    width: 28,
    height: 28,
    filterQuality: FilterQuality.medium,
    errorBuilder: (context, error, stackTrace) {
      // Fallback: original emoji rendering
      return Text(emoji, style: const TextStyle(fontSize: 20));
    },
  );
}
```

### 10.3 Flame Component Fallback Pattern

Use nullable sprite fields with null-check rendering:

```dart
class DragonHeadComponent extends PositionComponent {
  Sprite? sprite; // null if asset not yet available

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      // New: sprite-based rendering
      sprite!.render(canvas, size: size);
    } else {
      // Fallback: original Canvas procedural drawing
      final center = Offset(size.x / 2, size.y / 2);
      final radius = size.x * 0.4;
      // ... existing gradient circle + eye + direction indicator code
    }
  }
}
```

### 10.4 Asset Existence Checking

For a more robust approach, check asset existence at startup:

```dart
class ArtAssetManager {
  final Map<String, bool> _available = {};

  /// Check if an art asset exists by trying to load it.
  Future<bool> isAvailable(String path) async {
    if (_available.containsKey(path)) return _available[path]!;
    try {
      await rootBundle.load('assets/images/$path');
      _available[path] = true;
      return true;
    } catch (e) {
      _available[path] = false;
      return false;
    }
  }

  /// Load a Flame sprite, returning null if not available.
  Future<Sprite?> tryLoadSprite(Images images, String path) async {
    if (!await isAvailable(path)) return null;
    final image = await images.load(path);
    return Sprite(image);
  }
}
```

### 10.5 Migration Tracking

Create a simple registry to track which assets have been integrated:

```dart
/// Tracks which art assets have been generated and integrated.
/// Set entries to true as assets are completed.
class ArtAssetStatus {
  // Hub
  static bool hubBackground = false;
  static bool hubRunePortal = false;
  static bool hubFireTunnel = false;
  static bool hubEggNest = false;
  static bool hubFeastTable = false;

  // Dragon Evolution
  static bool dragonEggPortrait = false;
  static bool dragonEggHub = false;
  // ... etc for all 75 assets

  /// Returns true if all assets for a given category are ready.
  static bool hubComplete() =>
    hubBackground && hubRunePortal && hubFireTunnel &&
    hubEggNest && hubFeastTable;
}
```

### 10.6 Feature Flag Approach

For production builds, use a simple feature flag to toggle between art modes:

```dart
class AppConfig {
  /// Set to true once all art assets are generated, placed, and tested.
  static const bool useArtAssets = false;
}
```

Then in rendering code:
```dart
if (AppConfig.useArtAssets && sprite != null) {
  sprite!.render(canvas, size: size);
} else {
  // Original procedural rendering
}
```

This ensures the shipped app always works, even if some assets are not yet finalized.

---

## Appendix A: Complete File Change List

Every Dart file that needs modification, organized by migration phase:

### Phase 1: Hub Screen
| File | Changes |
|------|---------|
| `lib/hub/hub_screen.dart` | Replace `lairGradient` with `DecorationImage`; add `imageAsset` to game card data |
| `lib/hub/dragon_companion.dart` | Replace `_evolutionEmojis` list with `_evolutionAssets` list; replace `Text()` with `Image.asset()` |
| `lib/hub/profile_bar.dart` | Replace `_evolutionEmojis` list with `_evolutionAssets` list; replace `Text()` with `Image.asset()`; replace `Icons.diamond` with `ScaleIcon` |
| `lib/hub/game_card.dart` | Add optional `imageAsset` parameter; render `Image.asset()` when provided instead of `Icon()` |
| `lib/hub/daily_challenge_card.dart` | Replace `Icons.local_fire_department` with streak flame image |
| `lib/hub/achievement_screen.dart` | Add badge frame image behind achievement emoji |
| `lib/monetization/store_screen.dart` | Replace emoji previews with `Image.asset()` for color variants and accessories; replace `Icons.diamond` with `ScaleIcon` |
| `lib/games/shared/game_shell.dart` | Replace `Icons.diamond` with `ScaleIcon` |
| `lib/games/shared/result_screen.dart` | Replace `Icons.star`/`Icons.star_border` with star images; replace `Icons.diamond` with `ScaleIcon` |
| `lib/games/shared/level_select_screen.dart` | Replace star icons with star images |

### Phase 2: Game Backgrounds
| File | Changes |
|------|---------|
| `lib/games/fire_trail/components/grid_renderer.dart` | Add `backgroundSprite` field; render sprite before grid lines |
| `lib/games/fire_trail/fire_trail_flame_game.dart` | Load background sprite in `onLoad()` |
| `lib/games/dragon_runes/dragon_runes_game.dart` | Replace `backgroundBuilder` gradient with `DecorationImage` |
| `lib/games/dragon_eggs/dragon_eggs_game.dart` | Add background image to game screen wrapper |
| `lib/games/dragons_feast/components/feast_grid.dart` | Add `backgroundSprite` field or convert to image-based rendering |

### Phase 3: Game Sprites
| File | Changes |
|------|---------|
| `lib/games/fire_trail/fire_trail_flame_game.dart` | Load all Fire Trail sprites in `onLoad()`; pass to components |
| `lib/games/fire_trail/components/dragon_head.dart` | Add `sprite` field; render sprite with rotation; keep fallback |
| `lib/games/fire_trail/components/answer_gem.dart` | Add `sprite` field; render sprite with text overlay; keep fallback |
| `lib/games/dragon_runes/dragon_runes_flame_game.dart` | Load rune node sprites in `onLoad()`; pass to node components |
| `lib/games/dragon_runes/components/rune_node.dart` | Add `inactiveSprite`/`activeSprite` fields; render sprites with state overlays |
| `lib/games/dragon_eggs/dragon_eggs_flame_game.dart` | Load all egg sprites in `onLoad()`; map colors to sprites; pass to spawned eggs |
| `lib/games/dragon_eggs/components/egg_component.dart` | Add `sprite` field; render sprite with text overlay and pop animation |
| `lib/games/dragons_feast/components/dragon_character.dart` | Add sprite fields for normal/wings/shield states; render with invulnerability logic |
| `lib/games/dragons_feast/components/enemy_guardian.dart` | Add sprite fields for chaser/wanderer/frozen variants; render based on state |
| `lib/games/dragons_feast/components/feast_tile.dart` | Add sprite-based rendering for tile backgrounds with number overlay |
| `lib/games/dragons_feast/components/power_up_tile.dart` | Add sprite fields for freeze/wings/shield; render with pulsing glow |

### Phase 4: UI Elements
| File | Changes |
|------|---------|
| New file: `lib/widgets/scale_icon.dart` | Create `ScaleIcon` widget wrapping `Image.asset()` |
| New file: `lib/widgets/star_icon.dart` | Create `StarIcon` widget for filled/empty star images |
| Android `mipmap-*` directories | Replace default icons with app_icon.png variants |
| iOS `Assets.xcassets` | Replace default icons with app_icon.png variants |

### pubspec.yaml
| Change |
|--------|
| Add explicit game subdirectory registrations |
| Add multi-density UI subdirectory registrations |

---

## Appendix B: Testing Checklist

After each migration phase, run these checks:

### Automated
- [ ] `flutter analyze` -- zero warnings/errors
- [ ] `flutter test` -- all 535+ tests pass
- [ ] `flutter build apk --debug` -- build succeeds

### Manual (Phase 1)
- [ ] Hub screen background image displays correctly
- [ ] Dragon companion shows correct evolution image at each stage (0-5)
- [ ] Profile bar shows correct small evolution portrait
- [ ] All 4 game portal images display in game cards
- [ ] Scale currency icon displays at all sizes across all screens
- [ ] Store screen shows dragon color variant images
- [ ] Store screen shows accessory images
- [ ] Achievement screen shows badge frame image
- [ ] Streak flame icon displays in daily challenge card
- [ ] Evolution dialog shows correct stage portrait

### Manual (Phase 2)
- [ ] Fire Trail background image visible behind grid
- [ ] Dragon Runes background image visible behind nodes
- [ ] Dragon Eggs background image visible behind egg play field
- [ ] Dragon's Feast background image visible behind grid
- [ ] Game elements remain clearly visible on top of backgrounds
- [ ] No performance issues (FPS remains smooth)

### Manual (Phase 3)
- [ ] Fire Trail dragon head sprite renders, rotates correctly with direction changes
- [ ] Fire Trail gem sprites render with number text overlay
- [ ] Dragon Runes node sprites change between inactive/active states
- [ ] Dragon Eggs: all 6 egg color sprites render correctly
- [ ] Dragon Eggs: selection border appears on tap
- [ ] Dragon Eggs: pop animation works with sprite
- [ ] Dragon's Feast: player sprite renders, changes with power-up states
- [ ] Dragon's Feast: enemy sprites render, distinguish chaser vs wanderer
- [ ] Dragon's Feast: power-up sprites render with pulsing glow
- [ ] Dragon's Feast: tile sprites show number overlay
- [ ] All games: hitbox/collision detection still works correctly
- [ ] All games: game-over conditions still trigger correctly

### Manual (Phase 4)
- [ ] Star images render at all sizes (12dp, 14dp, 40dp)
- [ ] Star fill animation in result screen works
- [ ] App icon appears correctly on device home screen

---

*Document created: 2026-02-16*
*Project: Math Dragons (Flutter 3.41.1, Dart 3.11.0, Flame 1.14)*
*Reference: `docs/step12/ART_GENERATION_PROMPTS.md` for the 75 planned art assets*
