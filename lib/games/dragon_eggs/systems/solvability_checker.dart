import '../components/egg_component.dart';
import 'egg_spawner.dart';

/// Ensures at least one valid equation can be formed on screen.
class SolvabilityChecker {
  double _checkTimer = 0;
  static const double _checkIntervalMs = 2000;

  /// Check if at least one valid equation exists among active eggs.
  /// If not, spawns the missing pieces via the spawner.
  void check(
    double dt,
    List<EggComponent> eggs,
    EggSpawner spawner,
    void Function(EggComponent) onSpawn,
  ) {
    _checkTimer -= dt * 1000;
    if (_checkTimer > 0) return;
    _checkTimer = _checkIntervalMs;

    if (spawner.hasSolvableEquation(eggs)) return;

    // Not solvable — spawn helpful eggs
    onSpawn(spawner.createHelperEgg(eggs));
  }
}
