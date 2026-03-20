import '../models/egg_data.dart';
import '../models/difficulty_config.dart';
import '../components/egg_component.dart';
import 'egg_spawner.dart';

/// Ensures at least one valid equation can be formed on screen.
class SolvabilityChecker {
  double _checkTimer = 0;
  static const double _checkIntervalMs = 2000;

  /// Check if at least one valid equation exists among active eggs.
  /// If not, spawns the missing pieces via the spawner.
  void check(
    List<EggComponent> eggs,
    EggSpawner spawner,
    DifficultyTier tier,
    void Function(EggComponent) onSpawn,
  ) {
    _checkTimer -= 16; // approximate one frame at 60fps
    if (_checkTimer > 0) return;
    _checkTimer = _checkIntervalMs;

    final activeNums = eggs
        .where(
            (e) => e.type == EggType.number && e.state == EggState.active)
        .map((e) => e.value as int)
        .toList();

    final activeOps = eggs
        .where(
            (e) => e.type == EggType.operator && e.state == EggState.active)
        .map((e) => e.value as MathOp)
        .toList();

    // Need at least 3 numbers and 1 operator
    if (activeNums.length < 3 || activeOps.isEmpty) {
      // Spawn missing pieces
      if (activeOps.isEmpty) {
        onSpawn(spawner.createEgg(eggs));
      }
      while (activeNums.length < 3) {
        final egg = spawner.createEgg(eggs);
        onSpawn(egg);
        if (egg.type == EggType.number) {
          activeNums.add(egg.value as int);
        }
      }
      return;
    }

    // Check if any valid equation is possible
    final numsSet = activeNums.toSet();
    for (final op in activeOps) {
      for (final a in activeNums) {
        for (final b in activeNums) {
          if (identical(a, b) && activeNums.where((n) => n == a).length < 2) {
            continue;
          }
          final result = _compute(a, op, b);
          if (result > 0 && numsSet.contains(result)) {
            return; // solvable
          }
        }
      }
    }

    // Not solvable — spawn helpful eggs
    onSpawn(spawner.createEgg(eggs));
  }

  static int _compute(int a, MathOp op, int b) {
    switch (op) {
      case MathOp.add:
        return a + b;
      case MathOp.subtract:
        return a - b;
      case MathOp.multiply:
        return a * b;
      case MathOp.divide:
        return b >= 2 && a % b == 0 ? a ~/ b : -1;
    }
  }
}
