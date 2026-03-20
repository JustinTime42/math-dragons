import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import '../storage/local_storage.dart';
import 'event_bus.dart';
import 'game_events.dart';

class AudioService {
  final LocalStorage _storage;

  String? _currentMusicTrack;
  bool _sfxPreloaded = false;

  AudioPool? _correctPool;
  AudioPool? _wrongPool;
  AudioPool? _buttonTapPool;
  AudioPool? _munchPool;

  static const double _musicVolume = 0.4;
  static const double _sfxVolume = 0.8;
  static const double _uiSfxVolume = 0.5;

  AudioService({required LocalStorage storage}) : _storage = storage;

  bool get _soundEnabled => _storage.getProfile().settings.soundEnabled;
  bool get _musicEnabled => _storage.getProfile().settings.musicEnabled;

  // ── Initialization ──

  Future<void> preloadSfx() async {
    if (_sfxPreloaded) return;

    try {
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

      _correctPool = await FlameAudio.createPool('sfx/correct.wav', maxPlayers: 4);
      _wrongPool = await FlameAudio.createPool('sfx/wrong.wav', maxPlayers: 3);
      _buttonTapPool = await FlameAudio.createPool('sfx/button_tap.wav', maxPlayers: 3);
      _munchPool = await FlameAudio.createPool('sfx/munch.wav', maxPlayers: 4);

      _sfxPreloaded = true;
    } catch (e) {
      debugPrint('AudioService: SFX preload failed: $e');
    }
  }

  // ── Music ──

  Future<void> playHubMusic() async {
    await _playMusic('music/hub_theme.ogg');
  }

  Future<void> playGameMusic(String gameId) async {
    final track = _musicTrackForGame(gameId);
    if (track != null) {
      await _playMusic(track);
    }
  }

  Future<void> playVictoryMusic() async {
    if (!_musicEnabled) return;
    await _stopMusicInternal();
    _currentMusicTrack = 'music/victory.ogg';
    try {
      FlameAudio.bgm.play('music/victory.ogg', volume: _musicVolume);
    } catch (e) {
      debugPrint('AudioService: Victory music failed: $e');
    }
  }

  Future<void> stopMusic() async {
    await _stopMusicInternal();
  }

  Future<void> pauseMusic() async {
    try {
      FlameAudio.bgm.pause();
    } catch (e) {
      debugPrint('AudioService: Pause music failed: $e');
    }
  }

  Future<void> resumeMusic() async {
    if (!_musicEnabled) return;
    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      debugPrint('AudioService: Resume music failed: $e');
    }
  }

  // ── Game Event SFX ──

  void playCorrect() {
    if (!_soundEnabled) return;
    _correctPool?.start(volume: _sfxVolume);
  }

  void playWrong() {
    if (!_soundEnabled) return;
    _wrongPool?.start(volume: _sfxVolume);
  }

  void playStreak() {
    if (!_soundEnabled) return;
    _playSfx('sfx/streak.wav');
  }

  void playLevelComplete() {
    if (!_soundEnabled) return;
    _playSfx('sfx/level_complete.wav');
  }

  void playAchievement() {
    if (!_soundEnabled) return;
    _playSfx('sfx/achievement.wav');
  }

  void playScalesEarn() {
    if (!_soundEnabled) return;
    _playSfx('sfx/scales_earn.wav', volume: _uiSfxVolume);
  }

  void playGameOver() {
    if (!_soundEnabled) return;
    _playSfx('sfx/game_over.wav');
  }

  void playCountdown() {
    if (!_soundEnabled) return;
    _playSfx('sfx/countdown.wav');
  }

  void playPowerUp() {
    if (!_soundEnabled) return;
    _playSfx('sfx/power_up.wav');
  }

  void playHint() {
    if (!_soundEnabled) return;
    _playSfx('sfx/hint.wav');
  }

  // ── Game-Specific SFX ──

  void playEggCrack() {
    if (!_soundEnabled) return;
    _playSfx('sfx/egg_crack.wav');
  }

  void playEggHatch() {
    if (!_soundEnabled) return;
    _playSfx('sfx/egg_hatch.wav');
  }

  void playDragonRoar() {
    if (!_soundEnabled) return;
    _playSfx('sfx/dragon_roar.wav');
  }

  void playMunch() {
    if (!_soundEnabled) return;
    _munchPool?.start(volume: _sfxVolume);
  }

  void playRuneConnect() {
    if (!_soundEnabled) return;
    _playSfx('sfx/rune_connect.wav');
  }

  void playSwipe() {
    if (!_soundEnabled) return;
    _playSfx('sfx/swipe.wav', volume: _uiSfxVolume);
  }

  // ── UI SFX ──

  void playButtonTap() {
    if (!_soundEnabled) return;
    _buttonTapPool?.start(volume: _uiSfxVolume);
  }

  void playEvolution() {
    if (!_soundEnabled) return;
    _playSfx('sfx/evolution.wav');
  }

  // ── Settings ──

  Future<void> onMusicSettingChanged(bool enabled) async {
    if (!enabled) {
      await _stopMusicInternal();
    }
  }

  void onSoundSettingChanged(bool enabled) {
    // No active cleanup needed -- future calls check _soundEnabled.
  }

  // ── Cleanup ──

  Future<void> dispose() async {
    await _stopMusicInternal();
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
    _sfxPreloaded = false;
  }

  // ── Private ──

  String? _musicTrackForGame(String gameId) {
    return switch (gameId) {
      'dragon_eggs'   => 'music/dragon_eggs.ogg',
      'fire_trail'    => 'music/fire_trail.ogg',
      'dragon_runes'  => 'music/dragon_runes.ogg',
      'dragons_feast' => 'music/dragons_feast.ogg',
      _ => null,
    };
  }

  Future<void> _playMusic(String track) async {
    if (!_musicEnabled) return;
    if (_currentMusicTrack == track) return;

    await _stopMusicInternal();
    _currentMusicTrack = track;
    try {
      FlameAudio.bgm.play(track, volume: _musicVolume);
    } catch (e) {
      debugPrint('AudioService: Music playback failed for $track: $e');
    }
  }

  Future<void> _stopMusicInternal() async {
    _currentMusicTrack = null;
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      debugPrint('AudioService: Stop music failed: $e');
    }
  }

  void _playSfx(String file, {double volume = _sfxVolume}) {
    try {
      FlameAudio.play(file, volume: volume);
    } catch (e) {
      debugPrint('AudioService: SFX play failed for $file: $e');
    }
  }
}

/// Centralized EventBus listener that triggers SFX for cross-game events.
/// This avoids scattering audio calls across every game file.
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
    _subscriptions.add(
      _eventBus.on<AnswerGiven>().listen((event) {
        if (event.correct) {
          _audio.playCorrect();
        } else {
          _audio.playWrong();
        }
      }),
    );

    _subscriptions.add(
      _eventBus.on<StreakAchieved>().listen((event) {
        _audio.playStreak();
      }),
    );

    _subscriptions.add(
      _eventBus.on<LevelCompleted>().listen((event) {
        _audio.playLevelComplete();
      }),
    );

    _subscriptions.add(
      _eventBus.on<GameEnded>().listen((event) {
        _audio.playGameOver();
      }),
    );

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
