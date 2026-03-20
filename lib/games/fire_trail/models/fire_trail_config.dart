import '../../dragon_eggs/models/egg_data.dart';

/// Per-level difficulty configuration for Fire Trail.
class FireTrailConfig {
  final int worldNumber;
  final int levelInWorld; // 1-8
  final int numberMin;
  final int numberMax;
  final List<MathOp> allowedOperations;
  final double stepsPerSecond;
  final int distractorCount; // 3-5
  final bool wrapMode;
  final int correctToAdvance;

  const FireTrailConfig({
    required this.worldNumber,
    required this.levelInWorld,
    required this.numberMin,
    required this.numberMax,
    required this.allowedOperations,
    required this.stepsPerSecond,
    required this.distractorCount,
    required this.wrapMode,
    required this.correctToAdvance,
  });

  /// Interpolate speed linearly within a world.
  static double speedForLevel(int worldNumber, int levelInWorld) {
    const worldSpeeds = [
      (base: 3.5, max: 4.5), // World 1
      (base: 5.0, max: 6.0), // World 2
      (base: 6.5, max: 8.0), // World 3
      (base: 8.5, max: 10.0), // World 4
      (base: 10.5, max: 12.0), // World 5
    ];

    final world = worldSpeeds[(worldNumber - 1).clamp(0, 4)];
    final t = (levelInWorld - 1) / 7; // 0.0 to 1.0
    return world.base + (world.max - world.base) * t;
  }

  /// Interpolate correct-to-advance within a world.
  static int correctToAdvanceForLevel(int worldNumber, int levelInWorld) {
    const worldTargets = [
      (base: 6, max: 8), // World 1
      (base: 8, max: 10), // World 2
      (base: 10, max: 12), // World 3
      (base: 12, max: 14), // World 4
      (base: 14, max: 16), // World 5
    ];

    final world = worldTargets[(worldNumber - 1).clamp(0, 4)];
    final t = (levelInWorld - 1) / 7;
    return (world.base + (world.max - world.base) * t).round();
  }

  /// Build config for a specific world/level.
  factory FireTrailConfig.forLevel(int worldNumber, int levelInWorld) {
    final speed = FireTrailConfig.speedForLevel(worldNumber, levelInWorld);
    final target =
        FireTrailConfig.correctToAdvanceForLevel(worldNumber, levelInWorld);

    switch (worldNumber) {
      case 1:
        return FireTrailConfig(
          worldNumber: 1,
          levelInWorld: levelInWorld,
          numberMin: 1,
          numberMax: (5 + (levelInWorld * 0.4)).round().clamp(5, 8),
          allowedOperations: const [MathOp.add],
          stepsPerSecond: speed,
          distractorCount: 3,
          wrapMode: true,
          correctToAdvance: target,
        );
      case 2:
        return FireTrailConfig(
          worldNumber: 2,
          levelInWorld: levelInWorld,
          numberMin: 1,
          numberMax: 10,
          allowedOperations: const [MathOp.add, MathOp.subtract],
          stepsPerSecond: speed,
          distractorCount: levelInWorld > 4 ? 4 : 3,
          wrapMode: true,
          correctToAdvance: target,
        );
      case 3:
        return FireTrailConfig(
          worldNumber: 3,
          levelInWorld: levelInWorld,
          numberMin: 2,
          numberMax: 10,
          allowedOperations: const [
            MathOp.add,
            MathOp.subtract,
            MathOp.multiply,
          ],
          stepsPerSecond: speed,
          distractorCount: 4,
          wrapMode: true,
          correctToAdvance: target,
        );
      case 4:
        return FireTrailConfig(
          worldNumber: 4,
          levelInWorld: levelInWorld,
          numberMin: 2,
          numberMax: 12,
          allowedOperations: const [
            MathOp.add,
            MathOp.subtract,
            MathOp.multiply,
            MathOp.divide,
          ],
          stepsPerSecond: speed,
          distractorCount: levelInWorld > 4 ? 5 : 4,
          wrapMode: true,
          correctToAdvance: target,
        );
      case 5:
      default:
        return FireTrailConfig(
          worldNumber: 5,
          levelInWorld: levelInWorld,
          numberMin: 2,
          numberMax: 12,
          allowedOperations: const [
            MathOp.add,
            MathOp.subtract,
            MathOp.multiply,
            MathOp.divide,
          ],
          stepsPerSecond: speed,
          distractorCount: 5,
          wrapMode: true,
          correctToAdvance: target,
        );
    }
  }
}
