# Math Dragons -- Audio Integration Plan

**Step:** 12 (Polish & Audio)
**Scope:** Background music (6 tracks) + sound effects (18 SFX), integrated with existing EventBus, settings, and Provider architecture.

---

## Table of Contents

1. [Package Selection](#1-package-selection)
2. [AudioService Class Design](#2-audioservice-class-design)
3. [Music Lifecycle Management](#3-music-lifecycle-management)
4. [Integration Points](#4-integration-points)
5. [EventBus Integration](#5-eventbus-integration)
6. [Asset File Organization](#6-asset-file-organization)
7. [Format Recommendations](#7-format-recommendations)
8. [Provider Wiring](#8-provider-wiring)
9. [Preloading Strategy](#9-preloading-strategy)
10. [Performance Considerations](#10-performance-considerations)
11. [Settings Toggle Behavior](#11-settings-toggle-behavior)
12. [Testing Strategy](#12-testing-strategy)

---

## 1. Package Selection

### Candidates Evaluated

| Package | Version | Flame Integration | Music Loops | SFX Pools | Android/iOS |
|---|---|---|---|---|---|
| `flame_audio` | 2.1.6 | Native (wraps `audioplayers`) | Yes | Yes (`FlameAudio.audioCache`) | Yes |
| `audioplayers` | 6.x | None (standalone) | Yes | Manual | Yes |
| `just_audio` | 0.9.x | None (standalone) | Yes | Manual | Yes |

### Recommendation: `flame_audio` (version 2.1.6)

**Rationale:**

1. **Already in pubspec.yaml** -- `flame_audio: ^2.1.6` is commented out and ready to uncomment. Zero dependency resolution friction.

2. **Flame-native integration** -- The four mini-games all use Flame `FlameGame`. `flame_audio` provides `FlameAudio` which is a static wrapper around `AudioPool` and `AudioCache`, designed to work inside Flame's lifecycle. Components can call `FlameAudio.play()` directly.

3. **Built-in AudioPool** -- `FlameAudio.createPool()` returns an `AudioPool` for SFX that need rapid repeated playback (e.g., `correct.wav` during fast gameplay). This eliminates the need to manually build a pooling layer.

4. **AudioCache for music** -- `FlameAudio.bgm` provides a `Bgm` class that handles music looping, volume control, pause/resume, and app lifecycle awareness. The `Bgm` class already listens to `WidgetsBindingObserver` for auto-pause on background.

5. **Thin wrapper** -- `flame_audio` adds minimal overhead over raw `audioplayers`. If fine-grained control is ever needed, the underlying `AudioPlayer` instances are still accessible.

**Decision: Uncomment `flame_audio: ^2.1.6` in `pubspec.yaml` and use it as the sole audio package.**

### Activation in pubspec.yaml

In `math_dragons/pubspec.yaml`, change:

```yaml
  # Audio (Step 12)
  # flame_audio: ^2.1.6
```

to:

```yaml
  # Audio (Step 12)
  flame_audio: ^2.1.6
```

---

## 2. AudioService Class Design

The `AudioService` follows the same pattern as `HapticsService` (`lib/core/haptics.dart`):
- Constructor takes `LocalStorage` for settings access
- Each method checks the relevant setting (`soundEnabled` / `musicEnabled`) before playing
- Named methods for every SFX and music track
- Disposable with cleanup

### File Location

```
lib/core/audio_service.dart
```

### Full Class Interface

```dart
import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import '../storage/local_storage.dart';

/// Centralized audio service for all music and SFX playback.
/// Mirrors the HapticsService pattern: check settings before playing.
class AudioService {
  final LocalStorage _storage;

  /// Currently playing music track filename (null if none).
  String? _currentMusicTrack;

  /// Whether audio assets have been preloaded.
  bool _sfxPreloaded = false;

  /// Audio pools for high-frequency SFX.
  AudioPool? _correctPool;
  AudioPool? _wrongPool;
  AudioPool? _buttonTapPool;
  AudioPool? _munchPool;

  /// Volume levels.
  static const double _musicVolume = 0.4;   // 40% -- music sits behind SFX
  static const double _sfxVolume = 0.8;      // 80% -- SFX are prominent
  static const double _uiSfxVolume = 0.5;    // 50% -- UI clicks are subtle

  /// Cross-fade duration for music transitions.
  static const Duration crossFadeDuration = Duration(milliseconds: 800);

  AudioService({required LocalStorage storage}) : _storage = storage;

  // ──────────────────────────────────────────────
  // Settings Checks
  // ──────────────────────────────────────────────

  bool get _soundEnabled => _storage.getProfile().settings.soundEnabled;
  bool get _musicEnabled => _storage.getProfile().settings.musicEnabled;

  // ──────────────────────────────────────────────
  // Initialization & Preloading
  // ──────────────────────────────────────────────

  /// Preload all SFX into AudioCache and create pools for frequent sounds.
  /// Call once during app startup (after storage is initialized).
  Future<void> preloadSfx() async {
    if (_sfxPreloaded) return;

    try {
      // Preload all SFX files into cache
      await FlameAudio.audioCache.loadAll([
        'sfx/correct.wav',
        'sfx/wrong.wav',
        'sfx/streak.wav',
        'sfx/level_complete.wav',
        'sfx/achievement.wav',
        'sfx/scales_earn.wav',
        'sfx/egg_crack.wav',
        'sfx/egg_hatch.wav',
        'sfx/dragon_roar.wav',
        'sfx/munch.wav',
        'sfx/button_tap.wav',
        'sfx/evolution.wav',
        'sfx/countdown.wav',
        'sfx/game_over.wav',
        'sfx/power_up.wav',
        'sfx/hint.wav',
        'sfx/rune_connect.wav',
        'sfx/swipe.wav',
      ]);

      // Create pools for high-frequency sounds (max 4 concurrent instances)
      _correctPool = await FlameAudio.createPool('sfx/correct.wav', maxPlayers: 4);
      _wrongPool = await FlameAudio.createPool('sfx/wrong.wav', maxPlayers: 3);
      _buttonTapPool = await FlameAudio.createPool('sfx/button_tap.wav', maxPlayers: 3);
      _munchPool = await FlameAudio.createPool('sfx/munch.wav', maxPlayers: 4);

      _sfxPreloaded = true;
    } catch (e) {
      debugPrint('AudioService: SFX preload failed: $e');
      // Non-fatal -- game works without audio
    }
  }

  // ──────────────────────────────────────────────
  // Music Methods
  // ──────────────────────────────────────────────

  /// Play the hub/home screen background music (looping).
  Future<void> playHubMusic() async {
    await _playMusic('music/hub_theme.ogg');
  }

  /// Play game-specific background music (looping).
  /// Maps gameId to the correct track.
  Future<void> playGameMusic(String gameId) async {
    final track = _musicTrackForGame(gameId);
    if (track != null) {
      await _playMusic(track);
    }
  }

  /// Play victory/result screen music (non-looping, plays once).
  Future<void> playVictoryMusic() async {
    if (!_musicEnabled) return;
    await _stopMusicInternal();
    try {
      // Must NOT use FlameAudio.bgm here: bgm.play() always forces
      // ReleaseMode.loop, so the fanfare would repeat forever. playLongAudio
      // uses ReleaseMode.release and plays a single run.
      _victoryPlayer = await FlameAudio.playLongAudio(
        'music/victory.ogg',
        volume: _musicVolume,
      );
    } catch (e) {
      debugPrint('AudioService: Victory music failed: $e');
    }
  }

  /// Stop all music playback.
  Future<void> stopMusic() async {
    await _stopMusicInternal();
  }

  /// Pause music (e.g., app backgrounded).
  Future<void> pauseMusic() async {
    try {
      FlameAudio.bgm.pause();
    } catch (e) {
      debugPrint('AudioService: Pause music failed: $e');
    }
  }

  /// Resume music (e.g., app foregrounded).
  Future<void> resumeMusic() async {
    if (!_musicEnabled) return;
    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      debugPrint('AudioService: Resume music failed: $e');
    }
  }

  // ──────────────────────────────────────────────
  // Game Event SFX
  // ──────────────────────────────────────────────

  /// Correct answer -- bright positive chime.
  Future<void> playCorrect() async {
    if (!_soundEnabled) return;
    _correctPool?.start(volume: _sfxVolume);
  }

  /// Wrong answer -- gentle buzz.
  Future<void> playWrong() async {
    if (!_soundEnabled) return;
    _wrongPool?.start(volume: _sfxVolume);
  }

  /// Streak milestone reached -- ascending sparkle.
  Future<void> playStreak() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/streak.wav');
  }

  /// Level completed -- short triumphant fanfare.
  Future<void> playLevelComplete() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/level_complete.wav');
  }

  /// Achievement unlocked -- grand magical reveal.
  Future<void> playAchievement() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/achievement.wav');
  }

  /// Scales/currency earned -- light gem pickup.
  Future<void> playScalesEarn() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/scales_earn.wav', volume: _uiSfxVolume);
  }

  /// Game over -- sad descending tone.
  Future<void> playGameOver() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/game_over.wav');
  }

  /// Countdown tick (3-2-1-GO).
  Future<void> playCountdown() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/countdown.wav');
  }

  /// Power-up activated -- energy surge.
  Future<void> playPowerUp() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/power_up.wav');
  }

  /// Hint revealed -- gentle magical sparkle.
  Future<void> playHint() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/hint.wav');
  }

  // ──────────────────────────────────────────────
  // Game-Specific SFX
  // ──────────────────────────────────────────────

  /// Dragon Eggs: egg cracking.
  Future<void> playEggCrack() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/egg_crack.wav');
  }

  /// Dragon Eggs: egg hatching complete.
  Future<void> playEggHatch() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/egg_hatch.wav');
  }

  /// Evolution screen: dragon roar.
  Future<void> playDragonRoar() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/dragon_roar.wav');
  }

  /// Dragon's Feast: chomping/eating.
  Future<void> playMunch() async {
    if (!_soundEnabled) return;
    _munchPool?.start(volume: _sfxVolume);
  }

  /// Dragon Runes: magical energy connection.
  Future<void> playRuneConnect() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/rune_connect.wav');
  }

  /// Fire Trail / Dragon's Feast: swipe/direction change.
  Future<void> playSwipe() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/swipe.wav', volume: _uiSfxVolume);
  }

  // ──────────────────────────────────────────────
  // UI SFX
  // ──────────────────────────────────────────────

  /// Generic button tap -- soft UI click.
  Future<void> playButtonTap() async {
    if (!_soundEnabled) return;
    _buttonTapPool?.start(volume: _uiSfxVolume);
  }

  /// Dragon evolution -- dramatic transformation.
  Future<void> playEvolution() async {
    if (!_soundEnabled) return;
    _playSfx('sfx/evolution.wav');
  }

  // ──────────────────────────────────────────────
  // Settings-Reactive Controls
  // ──────────────────────────────────────────────

  /// Called when the music toggle changes in Settings.
  /// If music was just disabled, stop playback immediately.
  /// If music was just enabled, resume the current screen's music.
  Future<void> onMusicSettingChanged(bool enabled) async {
    if (!enabled) {
      await _stopMusicInternal();
    }
    // If re-enabled, the caller (SettingsScreen) should trigger
    // the appropriate playHubMusic() or playGameMusic() call.
  }

  /// Called when the sound toggle changes in Settings.
  /// No active cleanup needed -- SFX are fire-and-forget.
  void onSoundSettingChanged(bool enabled) {
    // Nothing to do. The _soundEnabled getter will prevent future SFX.
  }

  // ──────────────────────────────────────────────
  // Cleanup
  // ──────────────────────────────────────────────

  /// Dispose all audio resources. Call from app dispose.
  Future<void> dispose() async {
    await _stopMusicInternal();
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
    _sfxPreloaded = false;
  }

  // ──────────────────────────────────────────────
  // Private Helpers
  // ──────────────────────────────────────────────

  /// Map game IDs to music track filenames.
  String? _musicTrackForGame(String gameId) {
    return switch (gameId) {
      'dragon_eggs'   => 'music/dragon_eggs.ogg',
      'fire_trail'    => 'music/fire_trail.ogg',
      'dragon_runes'  => 'music/dragon_runes.ogg',
      'dragons_feast' => 'music/dragons_feast.ogg',
      _ => null,
    };
  }

  /// Internal: play a looping music track with cross-fade.
  Future<void> _playMusic(String track) async {
    if (!_musicEnabled) return;

    // Skip if this track is already playing
    if (_currentMusicTrack == track) return;

    // Stop current music (with brief fade-out handled by Bgm)
    await _stopMusicInternal();

    _currentMusicTrack = track;
    try {
      FlameAudio.bgm.play(track, volume: _musicVolume);
    } catch (e) {
      debugPrint('AudioService: Music playback failed for $track: $e');
    }
  }

  /// Internal: stop music and clear the current track reference.
  Future<void> _stopMusicInternal() async {
    _currentMusicTrack = null;
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      debugPrint('AudioService: Stop music failed: $e');
    }
  }

  /// Internal: play a one-shot SFX from cache.
  void _playSfx(String file, {double volume = _sfxVolume}) {
    try {
      FlameAudio.play(file, volume: volume);
    } catch (e) {
      debugPrint('AudioService: SFX play failed for $file: $e');
    }
  }
}
```

### Key Design Decisions

| Decision | Rationale |
|---|---|
| Singleton via Provider (not static) | Testable, mockable, consistent with existing services |
| Settings checked per-call, not cached | Responds immediately when user toggles sound/music |
| All methods are `Future<void>` | Callers can await if needed, but typically fire-and-forget |
| Every call wrapped in try/catch | Audio must never crash the app; failures are logged and swallowed |
| `AudioPool` for 4 high-frequency SFX | `correct`, `wrong`, `button_tap`, `munch` can fire rapidly in succession |
| Music volume at 40%, SFX at 80% | Music is a background layer; SFX must be clearly audible over it |

---

## 3. Music Lifecycle Management

### 3.1 Screen-to-Music Mapping

| Screen / Context | Music Track | Behavior |
|---|---|---|
| Hub screen | `hub_theme.ogg` | Looping. Starts on hub mount. |
| Dragon Eggs game | `dragon_eggs.ogg` | Looping. Starts when GameShell mounts. |
| Fire Trail game | `fire_trail.ogg` | Looping. Starts when GameShell mounts. |
| Dragon Runes game | `dragon_runes.ogg` | Looping. Starts when GameShell mounts. |
| Dragon's Feast game | `dragons_feast.ogg` | Looping. Starts when GameShell mounts. |
| Result screen | `victory.ogg` | Non-looping. Plays once when results appear. |
| Settings screen | (inherit from parent) | No change; parent screen's music continues. |
| Achievement screen | (inherit from parent) | No change; hub music continues. |
| Store screen | (inherit from parent) | No change; hub music continues. |

### 3.2 Music Transition Flow

```
Hub Screen (hub_theme.ogg looping)
    |
    v  [user taps game card]
    |
    AudioService.stopMusic()  -- hub theme stops
    AudioService.playGameMusic('fire_trail')  -- game music starts
    |
    v  [game plays]
    |
    v  [game over]
    |
    AudioService.stopMusic()  -- game music stops
    AudioService.playVictoryMusic()  -- victory jingle plays once
    |
    v  [user taps "Back to Hub"]
    |
    AudioService.stopMusic()  -- victory music stops (if still playing)
    AudioService.playHubMusic()  -- hub theme resumes
```

### 3.3 App Lifecycle Handling

The app already uses `WidgetsBindingObserver` in `_MathDragonsAppState` (see `app.dart` lines 47-48, 128-137). Audio lifecycle hooks should be added to the existing `didChangeAppLifecycleState`:

```dart
// In _MathDragonsAppState.didChangeAppLifecycleState (app.dart):
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused ||
      state == AppLifecycleState.detached) {
    _sessionManager.endAppSession();
    widget.cloudSync.syncNow();
    _audioService.pauseMusic();       // <-- ADD THIS
  } else if (state == AppLifecycleState.resumed) {
    _sessionManager.startAppSession();
    _audioService.resumeMusic();      // <-- ADD THIS
  }
}
```

**Note:** `FlameAudio.bgm` also has its own internal `WidgetsBindingObserver` that auto-pauses on background. The explicit calls above ensure correct behavior even if the `Bgm` internal observer does not cover all edge cases (such as `detached` state).

### 3.4 Pause Menu Behavior

When the user opens the pause overlay in `GameShell`:

- **Music:** Continue playing at reduced volume (duck to 20%) during pause. Resume full volume on unpause.
- **SFX:** Disabled while paused (the game is frozen, so no events fire).

```dart
// In GameShell._togglePause():
void _togglePause() {
  setState(() {
    _isPaused = !_isPaused;
  });
  widget.onPauseChanged?.call(_isPaused);

  // Duck/restore music volume during pause
  final audio = context.read<AudioService>();
  if (_isPaused) {
    audio.duckMusic();    // Reduce to 20% volume
  } else {
    audio.restoreMusic(); // Restore to normal 40% volume
  }
}
```

This requires adding two small methods to `AudioService`:

```dart
/// Reduce music volume during pause overlay (duck to 20%).
void duckMusic() {
  // Implementation uses FlameAudio.bgm's underlying player
  // to set volume without stopping playback.
}

/// Restore music volume after pause overlay dismissed.
void restoreMusic() {
  // Restore to _musicVolume (0.4).
}
```

---

## 4. Integration Points

### 4.1 GameShell (`lib/games/shared/game_shell.dart`)

The GameShell wraps all four mini-games and is the ideal place for music start/stop:

```dart
// game_shell.dart -- additions to _GameShellState

@override
void initState() {
  super.initState();
  final session = context.read<SessionManager>();
  session.startGame(widget.gameId);

  // Start game music                              // <-- ADD
  final audio = context.read<AudioService>();       // <-- ADD
  audio.playGameMusic(widget.gameId);               // <-- ADD

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    final eventBus = context.read<EventBus>();
    eventBus.emit(GameStarted(
      gameId: widget.gameId,
      levelNumber: widget.level,
    ));
  });
}

@override
void dispose() {
  try {
    final session = context.read<SessionManager>();
    session.endGame();

    // Stop game music on exit                      // <-- ADD
    final audio = context.read<AudioService>();      // <-- ADD
    audio.stopMusic();                               // <-- ADD
  } catch (_) {
    // Provider may not be available during dispose
  }
  super.dispose();
}
```

### 4.2 Hub Screen (`lib/hub/hub_screen.dart`)

Start hub music when the hub screen mounts:

```dart
// hub_screen.dart -- additions to _HubScreenState

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkBackupPrompt();
    // Start hub music                              // <-- ADD
    final audio = context.read<AudioService>();       // <-- ADD
    audio.playHubMusic();                             // <-- ADD
  });
}
```

### 4.3 Game Card Taps (`lib/hub/game_card.dart`)

Add button tap SFX on game card press:

```dart
// game_card.dart -- in _onTap()
void _onTap() {
  context.read<AudioService>().playButtonTap();  // <-- ADD
  Navigator.of(context).push(
    DragonPageRoute.gameTransition(gameId: widget.gameId),
  );
}
```

### 4.4 Result Screen (`lib/games/shared/result_screen.dart`)

Play victory music when the result screen appears:

```dart
// result_screen.dart -- in _ResultScreenState.initState()
@override
void initState() {
  super.initState();
  // ... existing animation controllers ...

  // Play victory music                             // <-- ADD
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    context.read<AudioService>().playVictoryMusic();
  });

  _slideController.forward().then((_) {
    _starsController.forward().then((_) {
      _scalesController.forward();
    });
  });
}
```

### 4.5 Achievement Popup (`lib/widgets/achievement_popup.dart`)

Play achievement SFX alongside the existing haptic feedback:

```dart
// achievement_popup.dart -- in _showNext()
Future<void> _showNext() async {
  if (_queue.isEmpty) {
    setState(() => _current = null);
    return;
  }

  setState(() => _current = _queue.removeAt(0));

  // Haptic feedback
  final haptics = context.mounted ? context.read<HapticsService>() : null;
  haptics?.onAchievementUnlocked();

  // Achievement SFX                                 // <-- ADD
  final audio = context.mounted ? context.read<AudioService>() : null;
  audio?.playAchievement();                           // <-- ADD

  await _controller.forward();
  await Future.delayed(const Duration(seconds: 2));
  await _controller.reverse();
  _showNext();
}
```

### 4.6 Dragon Eggs Game (`lib/games/dragon_eggs/dragon_eggs_game.dart`)

Game-specific SFX in the existing callbacks:

```dart
// dragon_eggs_game.dart -- in _onEquationResult()
void _onEquationResult(EquationResult result, int responseTimeMs) {
  final eventBus = context.read<EventBus>();
  final audio = context.read<AudioService>();       // <-- ADD

  eventBus.emit(AnswerGiven(...));

  if (result.isCorrect) {
    audio.playCorrect();                             // <-- ADD
  } else {
    audio.playWrong();                               // <-- ADD
  }

  // Streak milestone SFX handled by EventBus listener (see Section 5)

  setState(() { ... });
}

// In _onGameOver()
void _onGameOver() {
  if (_gameOverShown) return;
  _gameOverShown = true;

  context.read<AudioService>().playGameOver();       // <-- ADD

  // ... existing code ...
}
```

### 4.7 Fire Trail Game

Similar to Dragon Eggs. Add in the FlameGame's event emission callbacks:
- `playCorrect()` / `playWrong()` on answer results
- `playCountdown()` in the countdown overlay (called once per tick: 3, 2, 1)
- `playSwipe()` on direction changes (already has haptic `onDirectionChange`)
- `playGameOver()` on flame intensity reaching zero

### 4.8 Dragon Runes Game

- `playRuneConnect()` when a valid equation chain is connected
- `playCorrect()` when the equation is validated as correct
- `playWrong()` when an invalid equation is submitted (shake animation)
- `playHint()` when a hint is activated
- `playLevelComplete()` when all targets are solved

### 4.9 Dragon's Feast Game

- `playMunch()` on correct tile consumption (uses AudioPool for rapid fire)
- `playWrong()` on incorrect tile consumption
- `playPowerUp()` on power-up activation (freeze, wings, shield)
- `playCountdown()` in the countdown overlay
- `playGameOver()` when lives reach zero

### 4.10 Settings Screen (`lib/hub/settings_screen.dart`)

Wire the toggle handlers to notify AudioService:

```dart
// settings_screen.dart -- update the sound toggle
_buildToggle(
  context,
  icon: Icons.volume_up,
  title: l10n.sound,
  subtitle: l10n.soundDescription,
  value: _soundEnabled,
  onChanged: (v) {
    setState(() => _soundEnabled = v);
    _saveSettings();
    context.read<AudioService>().onSoundSettingChanged(v); // <-- ADD
  },
),

// Update the music toggle
_buildToggle(
  context,
  icon: Icons.music_note,
  title: l10n.music,
  subtitle: l10n.musicDescription,
  value: _musicEnabled,
  onChanged: (v) {
    setState(() => _musicEnabled = v);
    _saveSettings();
    context.read<AudioService>().onMusicSettingChanged(v); // <-- ADD
    if (v) {
      // Re-enable: restart whatever music is appropriate
      // Settings is always accessed from hub or pause menu
      context.read<AudioService>().playHubMusic();         // <-- ADD
    }
  },
),
```

### 4.11 Evolution Screen (if exists / when built)

- `playEvolution()` when the dragon evolution animation starts
- `playDragonRoar()` when the evolution animation completes (dragon appears at new stage)

### 4.12 Store Screen

- `playButtonTap()` on purchase button taps
- `playScalesEarn()` on cosmetic purchase confirmation (satisfying pickup sound plays on spend, providing tactile feedback for the transaction)

---

## 5. EventBus Integration

### Reactive Audio via EventBus

Rather than scattering `audioService.playX()` calls across every game's code, an **EventBus listener approach** can handle cross-cutting audio concerns centrally. This mirrors the pattern used by `RewardService` (`lib/core/reward_service.dart` lines 67-80).

The AudioService can optionally subscribe to EventBus events for sounds that should always play regardless of which game emitted them:

```dart
/// Optional: wire AudioService to listen to EventBus for
/// centralized, cross-game SFX triggers.
class AudioEventListener {
  final AudioService _audio;
  final EventBus _eventBus;
  final List<StreamSubscription<GameEvent>> _subscriptions = [];

  AudioEventListener({
    required AudioService audio,
    required EventBus eventBus,
  })  : _audio = audio,
        _eventBus = eventBus {
    _subscribe();
  }

  void _subscribe() {
    // Correct/wrong answer SFX
    _subscriptions.add(
      _eventBus.on<AnswerGiven>().listen((event) {
        if (event.correct) {
          _audio.playCorrect();
        } else {
          _audio.playWrong();
        }
      }),
    );

    // Streak milestone SFX
    _subscriptions.add(
      _eventBus.on<StreakAchieved>().listen((event) {
        _audio.playStreak();
      }),
    );

    // Level completed SFX
    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen((event) {
        _audio.playLevelComplete();
      }),
    );

    // Game over SFX
    _subscriptions.add(
      _eventBus.on<GameEnded>().listen((event) {
        _audio.playGameOver();
      }),
    );

    // Achievement unlocked SFX
    _subscriptions.add(
      _eventBus.on<AchievementUnlocked>().listen((event) {
        _audio.playAchievement();
      }),
    );
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
```

### Trade-off: Direct Calls vs. EventBus Listener

| Approach | Pros | Cons |
|---|---|---|
| **EventBus listener (centralized)** | Single place for all game-event audio. No changes needed inside individual game files for these 5 events. | Cannot avoid double-play if the game also calls `playCorrect()` directly. Less control over timing relative to visual feedback. |
| **Direct calls (per-game)** | Precise control over when SFX plays relative to animations. Can add game-specific variants. | Must add `audioService.playX()` in each game's callback code. More code changes across files. |

### Recommendation: Hybrid approach

Use the **EventBus listener** for the 5 cross-cutting events (`AnswerGiven`, `StreakAchieved`, `LevelCompleted`, `GameEnded`, `AchievementUnlocked`). This eliminates the need to add `playCorrect()` / `playWrong()` / `playStreak()` / `playLevelComplete()` / `playGameOver()` inside each game's code -- they will fire automatically via EventBus.

Use **direct calls** for game-specific SFX that are not modeled as EventBus events:
- `playMunch()` -- Dragon's Feast tile consumption
- `playEggCrack()` / `playEggHatch()` -- Dragon Eggs specific
- `playRuneConnect()` -- Dragon Runes specific
- `playSwipe()` -- Fire Trail / Dragon's Feast direction changes
- `playCountdown()` -- countdown overlays
- `playPowerUp()` -- Dragon's Feast power-ups
- `playHint()` -- Dragon Runes hint button
- `playButtonTap()` -- UI interactions
- `playEvolution()` / `playDragonRoar()` -- evolution screen
- `playScalesEarn()` -- scales animations

This means Section 4.6's explicit `playCorrect()` / `playWrong()` calls in `_onEquationResult` are **NOT needed** if the EventBus listener is used -- the `AnswerGiven` event already fires there. Remove the direct calls from Section 4.6 to avoid double-play.

---

## 6. Asset File Organization

### Directory Structure

The asset directories are already declared in `pubspec.yaml` (lines 68-69):
```yaml
    - assets/sounds/music/
    - assets/sounds/sfx/
```

However, `flame_audio` expects assets under `assets/audio/` by default (it uses `AudioCache` which prepends `assets/audio/`). There are two options:

**Option A (Recommended): Use flame_audio's default path prefix.**

Create the directory structure:
```
assets/audio/
  music/
    hub_theme.ogg
    dragon_eggs.ogg
    fire_trail.ogg
    dragon_runes.ogg
    dragons_feast.ogg
    victory.ogg
  sfx/
    correct.wav
    wrong.wav
    streak.wav
    level_complete.wav
    achievement.wav
    scales_earn.wav
    egg_crack.wav
    egg_hatch.wav
    dragon_roar.wav
    munch.wav
    button_tap.wav
    evolution.wav
    countdown.wav
    game_over.wav
    power_up.wav
    hint.wav
    rune_connect.wav
    swipe.wav
```

Update `pubspec.yaml` asset declarations:
```yaml
  assets:
    - assets/images/dragons/
    - assets/images/hub/
    - assets/images/games/
    - assets/images/ui/
    - assets/animations/
    - assets/audio/music/         # CHANGED from assets/sounds/music/
    - assets/audio/sfx/           # CHANGED from assets/sounds/sfx/
```

**Option B: Configure `AudioCache` with a custom prefix.**

Keep the existing `assets/sounds/` paths and set:
```dart
FlameAudio.audioCache.prefix = 'assets/sounds/';
```

**Recommendation:** Use Option A. The `assets/audio/` prefix is the standard convention for `flame_audio` projects, and changing it during step 12 (before any audio files exist) has zero cost.

### File Naming Convention

All filenames use `snake_case` with no spaces, matching the Dart convention:
- Music: `{descriptive_name}.ogg`
- SFX: `{descriptive_name}.wav`

---

## 7. Format Recommendations

### Music: OGG Vorbis

| Attribute | Value |
|---|---|
| **Format** | OGG Vorbis |
| **Bitrate** | 128 kbps (sufficient for mobile speakers/earbuds) |
| **Sample Rate** | 44100 Hz |
| **Channels** | Stereo |
| **Estimated Size** | ~1 MB per 60-second track |
| **Total Music Size** | ~5.5 MB (5 x 60-90s loops + 1 x 15-20s victory) |

**Why OGG?**
- Significantly smaller than WAV (10-15x compression)
- Better compression ratio than MP3 at equivalent quality
- No licensing fees (unlike MP3)
- Fully supported by `audioplayers` (the engine behind `flame_audio`) on both Android and iOS
- Designed for streaming playback -- low decoder memory footprint

**Conversion Command (from WAV source):**
```bash
ffmpeg -i hub_theme.wav -c:a libvorbis -b:a 128k hub_theme.ogg
```

### SFX: WAV (Uncompressed PCM)

| Attribute | Value |
|---|---|
| **Format** | WAV (PCM) |
| **Bit Depth** | 16-bit |
| **Sample Rate** | 44100 Hz |
| **Channels** | Mono (SFX do not need stereo) |
| **Duration** | 0.1s - 2.0s |
| **Estimated Size** | 5 KB - 180 KB per file |
| **Total SFX Size** | ~1 MB (all 18 files) |

**Why WAV for SFX?**
- **Zero decode latency** -- PCM data plays instantly with no decompression step
- Critical for game feedback sounds (`correct.wav`, `wrong.wav`) where timing matters
- Small file sizes (all SFX are under 2 seconds) make compression unnecessary
- Mono is sufficient -- SFX do not benefit from stereo separation on mobile

**Processing Tip:** Normalize all SFX to -3 dB peak to ensure consistent perceived loudness. Use Audacity's "Normalize" effect or:
```bash
ffmpeg -i correct_raw.wav -af "loudnorm=I=-14:TP=-3" -ar 44100 -ac 1 -sample_fmt s16 correct.wav
```

### Total Audio Bundle Size

| Category | Files | Estimated Size |
|---|---|---|
| Music (OGG) | 6 | ~5.5 MB |
| SFX (WAV) | 18 | ~1.0 MB |
| **Total** | **24** | **~6.5 MB** |

This is well within acceptable APK size budgets. For reference, the current APK build (without audio) is likely under 30 MB, and Google Play allows up to 150 MB for APKs (or 200 MB with AAB).

---

## 8. Provider Wiring

### 8.1 Add AudioService to MathDragonsApp

In `lib/app.dart`, add `AudioService` and `AudioEventListener` to the existing service initialization:

```dart
// app.dart -- add to imports
import 'core/audio_service.dart';

// app.dart -- add to _MathDragonsAppState fields
late final AudioService _audioService;
late final AudioEventListener _audioEventListener;

// app.dart -- add to initState()
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);

  _eventBus = EventBus();
  // ... existing services ...
  _hapticsService = HapticsService(storage: widget.storage);

  // Audio service                                    // <-- ADD
  _audioService = AudioService(storage: widget.storage);

  // ... remaining services ...

  // Audio event listener (after EventBus is created) // <-- ADD
  _audioEventListener = AudioEventListener(
    audio: _audioService,
    eventBus: _eventBus,
  );

  // ... existing code ...
}
```

### 8.2 Add to MultiProvider

```dart
// app.dart -- add to the providers list in build()
providers: [
  Provider<LocalStorage>.value(value: widget.storage),
  Provider<EventBus>.value(value: _eventBus),
  Provider<GameRegistry>.value(value: _registry),
  Provider<RewardService>.value(value: _rewardService),
  Provider<FactTracker>.value(value: _factTracker),
  Provider<SessionManager>.value(value: _sessionManager),
  Provider<HapticsService>.value(value: _hapticsService),
  Provider<AudioService>.value(value: _audioService),      // <-- ADD
  Provider<DifficultyEngine>.value(value: _difficultyEngine),
  // ... rest of providers ...
],
```

### 8.3 Add to Dispose

```dart
// app.dart -- add to dispose()
@override
void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  _connectivityMonitor.dispose();
  _sessionManager.endAppSession();
  _audioEventListener.dispose();  // <-- ADD (before AudioService)
  _audioService.dispose();        // <-- ADD
  _achievementTracker.dispose();
  // ... rest of existing dispose calls ...
  super.dispose();
}
```

### 8.4 Preload SFX During Startup

In `lib/main.dart`, add SFX preloading after storage initialization:

```dart
// main.dart -- after storage.initialize()
final storage = LocalStorage();
await storage.initialize();

// Preload audio SFX (non-blocking -- failures are graceful)
final audioService = AudioService(storage: storage);
await audioService.preloadSfx();
```

**Alternative:** Pass `audioService` into `MathDragonsApp` constructor (similar to `storage`, `authService`, `cloudSync`), so `main.dart` owns the preloading and `app.dart` receives a pre-warmed service. This avoids creating `AudioService` in two places.

**Recommended main.dart change:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ... existing setup ...

  final storage = LocalStorage();
  await storage.initialize();

  // Preload audio                              // <-- ADD
  final audioService = AudioService(storage: storage);
  unawaited(audioService.preloadSfx());         // <-- fire-and-forget

  // ... Firebase, auth, cloud sync ...

  runApp(MathDragonsApp(
    storage: storage,
    authService: authService,
    cloudSync: cloudSync,
    audioService: audioService,                 // <-- ADD parameter
  ));
}
```

Then update `MathDragonsApp` to accept `audioService` as a constructor parameter (same pattern as `storage`, `authService`, `cloudSync`).

---

## 9. Preloading Strategy

### SFX: Preload All During App Startup

All 18 SFX files total ~1 MB. This is small enough to load entirely into memory at startup:

```dart
await FlameAudio.audioCache.loadAll([
  'sfx/correct.wav',
  'sfx/wrong.wav',
  // ... all 18 files ...
]);
```

**When:** During `main()`, after `storage.initialize()` completes but before `runApp()`.

**Why preload all:** SFX must play with zero latency. The first `FlameAudio.play()` call for an unloaded file incurs a ~100-200ms disk read delay, which is unacceptable for real-time game feedback.

**Error handling:** Use `unawaited()` for the preload call so a failure does not block app startup. Log the error and continue -- the game functions fine without audio.

### Music: Load On Demand

Music tracks are ~1 MB each. Loading all 6 at startup would consume ~6 MB of memory unnecessarily (only one plays at a time).

**Strategy:** Let `FlameAudio.bgm.play()` handle loading on first play. The `Bgm` class internally caches the loaded track.

**Warm-up concern:** The first music play may have a ~200-500ms delay while the file loads from disk. This is acceptable for music (unlike SFX) because:
1. Music is not a real-time response to user input
2. The player will not notice a 200ms delay before background music starts
3. Subsequent plays of the same track are instant (cached)

**Optional enhancement:** Preload the hub theme specifically during startup, since it plays first:
```dart
// Warm up hub theme in the background
unawaited(FlameAudio.audioCache.load('music/hub_theme.ogg'));
```

### Preloading Summary

| Category | When | How | Memory Impact |
|---|---|---|---|
| All 18 SFX | App startup (main.dart) | `audioCache.loadAll()` + `createPool()` | ~1 MB permanent |
| Hub theme music | App startup (optional) | `audioCache.load()` | ~1 MB until evicted |
| Game music tracks | On navigation to game | `bgm.play()` auto-loads | ~1 MB per loaded track |
| Victory music | On result screen show | `bgm.play()` auto-loads | ~0.3 MB |

---

## 10. Performance Considerations

### 10.1 Audio Pools for High-Frequency SFX

Four SFX can fire in rapid succession and need pooling:

| SFX | Pool Size | Scenario |
|---|---|---|
| `correct.wav` | 4 | Fast correct-answer streaks in any game |
| `wrong.wav` | 3 | Multiple wrong taps in Dragon Eggs |
| `button_tap.wav` | 3 | Rapid UI interactions |
| `munch.wav` | 4 | Fast munching in Dragon's Feast |

`AudioPool` pre-creates multiple `AudioPlayer` instances. When `.start()` is called, it reuses an available player from the pool, avoiding the overhead of creating a new player each time.

Without pooling, calling `FlameAudio.play()` for rapid sounds creates a new `AudioPlayer` per call, which can lead to:
- Audible pops/clicks from player creation overhead
- Memory churn from many short-lived player instances
- Dropped sounds if the platform hits a concurrent player limit

### 10.2 Maximum Concurrent Sounds

Android and iOS both have limits on concurrent audio streams:
- **Android (AudioTrack):** Varies by device, typically 32-64 streams
- **iOS (AVAudioSession):** Typically 32 streams

Our worst case: 1 music track + 4 pooled SFX (up to 14 pool instances) + occasional one-shot SFX = ~20 concurrent players maximum. This is well within platform limits.

### 10.3 Memory Budget

| Resource | Memory |
|---|---|
| SFX AudioCache (18 files, ~1 MB WAV data) | ~1 MB |
| AudioPool instances (4 pools, ~14 players total) | ~2 MB (player overhead) |
| Music (1 active track in Bgm) | ~1 MB |
| **Total audio memory** | **~4 MB** |

This is a modest footprint. For context, a single full-screen image at 1080x1920 RGBA is ~8 MB.

### 10.4 Battery Impact

Audio playback has a small but non-zero battery impact. Mitigations:
- **OGG for music** -- hardware-decoded on most devices, lower CPU than software decode
- **Mono WAV for SFX** -- half the data of stereo, less processing
- **Pause on background** -- stops all audio when the app is not visible
- **No continuous SFX loops** -- all SFX are one-shot, not looping background sounds

### 10.5 Thread Safety

`FlameAudio` methods run on the main isolate. Since Flutter's Flame game loop also runs on the main isolate, there are no threading concerns. All audio calls from Flame components, EventBus listeners, and Flutter widgets execute on the same thread.

### 10.6 Graceful Degradation

The `AudioService` wraps every call in `try/catch` and logs errors via `debugPrint`. If audio fails for any reason (missing file, platform error, permission issue), the game continues to function normally without audio. This matches the existing pattern in the codebase where `Firebase.initializeApp()` failure is caught and the app continues in local-only mode.

---

## 11. Settings Toggle Behavior

### Existing Settings Architecture

`PlayerSettings` (Hive typeId: 2) already has:
- `soundEnabled` (bool, default `true`) -- controls SFX
- `musicEnabled` (bool, default `true`) -- controls background music

The `SettingsScreen` already renders toggles for both (lines 226-258 of `settings_screen.dart`).

### Behavioral Contract

| User Action | Sound Effects | Background Music |
|---|---|---|
| Disable "Sound" toggle | All SFX stop immediately. No future SFX play. | No change to music. |
| Enable "Sound" toggle | Future SFX play normally. | No change to music. |
| Disable "Music" toggle | No change to SFX. | Music stops immediately. |
| Enable "Music" toggle | No change to SFX. | Music resumes for current screen (hub or game). |
| Both disabled | Silent. No audio at all. | Silent. No audio at all. |

### Implementation Detail

The `_soundEnabled` and `_musicEnabled` getters in `AudioService` read directly from `_storage.getProfile().settings` on every call. This means settings changes take effect immediately -- no restart or service reload needed.

The one edge case is re-enabling music: when the user turns music back on in settings, the `SettingsScreen` must explicitly call `playHubMusic()` (since settings is accessed from the hub or pause menu, hub music is the correct default). If accessed from the pause menu, the game's `onPauseChanged` handler should call `playGameMusic()` on resume.

---

## 12. Testing Strategy

### 12.1 Unit Testing AudioService

`AudioService` depends on `FlameAudio` which uses platform channels. For unit tests, create a testable interface:

```dart
// For testing, make AudioService accept an optional AudioCache/Bgm
// or use a simple flag to disable actual playback in tests.

class AudioService {
  @visibleForTesting
  static bool testMode = false;

  void _playSfx(String file, {double volume = _sfxVolume}) {
    if (testMode) return;  // Skip actual playback in tests
    // ... real implementation ...
  }
}
```

Alternatively, extract an `AudioBackend` interface for full mocking:

```dart
abstract class AudioBackend {
  Future<void> playSfx(String file, {double volume});
  Future<void> playMusic(String file, {double volume});
  Future<void> stopMusic();
  Future<void> pauseMusic();
  Future<void> resumeMusic();
  Future<AudioPool> createPool(String file, {int maxPlayers});
  Future<void> preloadAll(List<String> files);
}
```

### 12.2 Test Cases

**Settings respect:**
- `playCorrect()` does nothing when `soundEnabled = false`
- `playHubMusic()` does nothing when `musicEnabled = false`
- `onMusicSettingChanged(false)` stops active music
- `onMusicSettingChanged(true)` does not auto-play (caller must trigger)

**Music lifecycle:**
- `playGameMusic('fire_trail')` sets `_currentMusicTrack`
- `stopMusic()` clears `_currentMusicTrack`
- `playGameMusic()` with same track does not restart (skip if already playing)
- `playVictoryMusic()` stops any existing music first

**EventBus integration (AudioEventListener):**
- Emitting `AnswerGiven(correct: true)` triggers `playCorrect()`
- Emitting `AnswerGiven(correct: false)` triggers `playWrong()`
- Emitting `StreakAchieved` triggers `playStreak()`
- Emitting `LevelCompleted` triggers `playLevelComplete()`
- Emitting `GameEnded` triggers `playGameOver()`
- Emitting `AchievementUnlocked` triggers `playAchievement()`

**Dispose:**
- `dispose()` clears cache and stops music
- `AudioEventListener.dispose()` cancels all subscriptions

### 12.3 Integration Testing

Manual testing checklist for each game:

- [ ] Hub screen plays hub_theme.ogg on launch
- [ ] Tapping a game card plays button_tap.wav
- [ ] Entering a game transitions from hub music to game music
- [ ] Correct answers play correct.wav (via EventBus)
- [ ] Wrong answers play wrong.wav (via EventBus)
- [ ] Streak milestones play streak.wav
- [ ] Level completion plays level_complete.wav
- [ ] Game over plays game_over.wav
- [ ] Result screen plays victory.ogg
- [ ] Returning to hub plays hub_theme.ogg again
- [ ] Pausing the game ducks music volume
- [ ] Resuming restores music volume
- [ ] Backgrounding the app pauses music
- [ ] Foregrounding resumes music
- [ ] Disabling music in settings stops music immediately
- [ ] Re-enabling music starts hub/game music
- [ ] Disabling sound stops SFX but not music
- [ ] Achievement popup plays achievement.wav
- [ ] Dragon Eggs: egg_crack and egg_hatch SFX play at correct moments
- [ ] Dragon Runes: rune_connect.wav plays on chain validation
- [ ] Dragon's Feast: munch.wav plays on tile consumption
- [ ] Fire Trail: countdown.wav plays on 3-2-1 overlay ticks

---

## Summary: Files to Create/Modify

### New Files

| File | Description |
|---|---|
| `lib/core/audio_service.dart` | AudioService class + AudioEventListener class |
| `assets/audio/music/` (directory) | 6 music OGG files |
| `assets/audio/sfx/` (directory) | 18 SFX WAV files |

### Modified Files

| File | Changes |
|---|---|
| `pubspec.yaml` | Uncomment `flame_audio: ^2.1.6`, update asset paths to `assets/audio/` |
| `lib/main.dart` | Create AudioService, call `preloadSfx()`, pass to MathDragonsApp |
| `lib/app.dart` | Accept AudioService param, create AudioEventListener, add to MultiProvider, add lifecycle calls, add to dispose |
| `lib/games/shared/game_shell.dart` | Add `playGameMusic()` in initState, `stopMusic()` in dispose, music duck/restore on pause |
| `lib/hub/hub_screen.dart` | Add `playHubMusic()` in initState |
| `lib/hub/game_card.dart` | Add `playButtonTap()` in onTap |
| `lib/games/shared/result_screen.dart` | Add `playVictoryMusic()` in initState |
| `lib/widgets/achievement_popup.dart` | Add `playAchievement()` in _showNext |
| `lib/hub/settings_screen.dart` | Add `onMusicSettingChanged()` / `onSoundSettingChanged()` to toggle handlers |
| `lib/games/dragon_eggs/dragon_eggs_game.dart` | Add game-specific SFX (egg_crack, egg_hatch) |
| `lib/games/fire_trail/` (game files) | Add countdown, swipe SFX |
| `lib/games/dragon_runes/` (game files) | Add rune_connect, hint SFX |
| `lib/games/dragons_feast/` (game files) | Add munch, power_up SFX |

### Estimated Effort

| Task | Estimate |
|---|---|
| Create AudioService + AudioEventListener | 1-2 hours |
| Wire into Provider, main.dart, app.dart | 30 min |
| Integrate into GameShell, HubScreen, ResultScreen | 30 min |
| Integrate into 4 game files (game-specific SFX) | 1-2 hours |
| Settings screen wiring | 15 min |
| Source and convert 18 SFX files | 2-4 hours |
| Generate/acquire 6 music tracks | 3-6 hours |
| Write unit tests (~30-40 tests) | 1-2 hours |
| Manual integration testing | 1-2 hours |
| **Total** | **~10-18 hours** |
