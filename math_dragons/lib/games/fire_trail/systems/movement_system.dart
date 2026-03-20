import '../models/grid_position.dart';

/// Handles step-based movement and wall collision on the grid.
class MovementSystem {
  final int gridSize;
  final bool wrap;

  MovementSystem({required this.gridSize, required this.wrap});

  /// Calculate the next position. Returns null if wall collision (no-wrap mode).
  GridPosition? nextPosition(GridPosition current, Direction dir) {
    int nx = current.x + dir.dx;
    int ny = current.y + dir.dy;

    if (wrap) {
      nx = (nx + gridSize) % gridSize;
      ny = (ny + gridSize) % gridSize;
      return GridPosition(nx, ny);
    }

    if (nx < 0 || ny < 0 || nx >= gridSize || ny >= gridSize) {
      return null; // wall collision
    }

    return GridPosition(nx, ny);
  }
}
