import '../models/grid_position.dart';

/// Manages the flame trail growth and shrinking.
class TrailManager {
  final int initialLength;
  int pendingGrowth = 0;

  TrailManager({required this.initialLength});

  /// Called on a normal step (no gem eaten). Handles tail removal or growth.
  void handleNormalStep(List<GridPosition> trail) {
    if (pendingGrowth > 0) {
      pendingGrowth--;
      // Don't remove tail — trail grows by 1
    } else if (trail.isNotEmpty) {
      trail.removeLast();
    }
  }

  /// Reset for a new game.
  void reset() {
    pendingGrowth = 0;
  }
}
