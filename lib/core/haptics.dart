import 'package:flutter/services.dart';
import '../storage/local_storage.dart';

/// Named haptic feedback methods matching the Visual Design Guide.
/// All methods check the user's haptics setting before firing.
class HapticsService {
  final LocalStorage _storage;

  HapticsService({required LocalStorage storage}) : _storage = storage;

  bool get _enabled => _storage.getProfile().settings.hapticsEnabled;

  // ---- Game Events ----

  /// Correct answer -- light, satisfying tap.
  Future<void> onCorrectAnswer() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Wrong answer -- brief sharp buzz.
  Future<void> onWrongAnswer() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Streak milestone (5, 10, 15...) -- celebratory double tap.
  Future<void> onStreakMilestone() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Level complete -- positive medium then light.
  Future<void> onLevelComplete() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Dragon evolution -- momentous triple selection click.
  Future<void> onDragonEvolution() async {
    if (!_enabled) return;
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.selectionClick();
      if (i < 2) await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  /// Achievement unlocked -- descending intensity sequence.
  Future<void> onAchievementUnlocked() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  // ---- UI Interactions ----

  /// Scales earned -- subtle background click.
  Future<void> onScalesEarned() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Button press -- standard selection click.
  Future<void> onButtonPress() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Error or invalid action -- warning buzz.
  Future<void> onError() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  // ---- Game-Specific ----

  /// Egg select (Dragon Eggs) -- soft tap.
  Future<void> onEggSelect() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Egg hatch (Dragon Eggs) -- cracking medium impact.
  Future<void> onEggHatch() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Munch (Dragon's Feast) -- quick light nom.
  Future<void> onMunch() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Rune node select (Dragon Runes) -- light pulse.
  Future<void> onRuneSelect() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Snake direction change (Fire Trail) -- directional click.
  Future<void> onDirectionChange() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }
}
