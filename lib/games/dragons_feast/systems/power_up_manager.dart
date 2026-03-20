import '../models/power_up_type.dart';

/// Manages power-up spawning for Dragon's Feast.
class PowerUpManager {
  const PowerUpManager();

  /// Determine what power-up to place for this level (if any).
  /// Power-ups appear on even-numbered levels starting from level 2.
  static PowerUpType? powerUpForLevel(int levelNumber) {
    if (levelNumber < 2) return null;
    if (levelNumber % 2 != 0) return null;

    // Cycle: freeze → wings → shield → freeze → ...
    const types = [PowerUpType.freeze, PowerUpType.wings, PowerUpType.shield];
    return types[(levelNumber ~/ 2 - 1) % types.length];
  }
}
