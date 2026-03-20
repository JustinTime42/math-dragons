import 'dart:math';

import 'math_category.dart';
import 'power_up_type.dart';
import '../systems/category_system.dart';
import '../systems/power_up_manager.dart';

/// Per-level difficulty configuration for Dragon's Feast.
class DragonsFeastConfig {
  final int levelNumber;
  final int worldNumber;
  final int levelInWorld; // 1-8
  final MathCategory category;
  final int enemyCount; // 2-6
  final double enemySpeedMin; // minimum step interval (seconds)
  final double enemySpeedMax; // maximum step interval (seconds)
  final int correctTileCount; // how many correct tiles on board
  final bool hasPowerUp;
  final PowerUpType? powerUpType;

  const DragonsFeastConfig({
    required this.levelNumber,
    required this.worldNumber,
    required this.levelInWorld,
    required this.category,
    required this.enemyCount,
    required this.enemySpeedMin,
    required this.enemySpeedMax,
    required this.correctTileCount,
    required this.hasPowerUp,
    this.powerUpType,
  });

  /// Get enemy speed range for a given world.
  static (double min, double max) enemySpeedForWorld(int worldNumber) {
    switch (worldNumber) {
      case 1:
        return (4.0, 6.0); // Slow
      case 2:
        return (3.5, 5.5); // Medium-slow
      case 3:
        return (3.0, 5.0); // Medium
      case 4:
        return (2.5, 4.5); // Medium-fast
      case 5:
        return (2.0, 4.0); // Fast
      default:
        return (3.0, 6.0);
    }
  }

  /// Generate config for a specific level number (1-40).
  static DragonsFeastConfig configForLevel(int levelNumber) {
    final world = ((levelNumber - 1) ~/ 8) + 1;
    final levelInWorld = ((levelNumber - 1) % 8) + 1;

    final category = CategorySystem.categoryForLevel(levelNumber);
    final enemyCount = min(2 + (levelNumber ~/ 3), 6);
    final (speedMin, speedMax) = enemySpeedForWorld(world);

    // Correct tile count: ~40% of 25 = 10, with slight variation
    final correctCount = (8 + levelInWorld * 0.5).round().clamp(8, 12);

    // Power-up on even-numbered levels starting from level 2
    final powerUpType = PowerUpManager.powerUpForLevel(levelNumber);

    return DragonsFeastConfig(
      levelNumber: levelNumber,
      worldNumber: world,
      levelInWorld: levelInWorld,
      category: category,
      enemyCount: enemyCount,
      enemySpeedMin: speedMin,
      enemySpeedMax: speedMax,
      correctTileCount: correctCount,
      hasPowerUp: powerUpType != null,
      powerUpType: powerUpType,
    );
  }
}
