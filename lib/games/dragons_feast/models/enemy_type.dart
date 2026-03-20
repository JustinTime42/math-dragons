/// Enemy types in Dragon's Feast.
enum EnemyType {
  /// Pursues the player (60% chance to move toward, 40% random).
  chaser,

  /// Moves randomly in cardinal directions.
  wanderer,
}

/// Runtime data for a single enemy on the grid.
class EnemyData {
  int x, y;
  EnemyType type;
  double nextMoveTimer;
  double moveInterval; // 3.0-6.0 seconds between steps
  bool isMoving = false;
  double moveAnimTimer = 0;
  int fromX, fromY;
  int toX, toY;
  bool isFrozen = false;

  EnemyData({
    required this.x,
    required this.y,
    required this.type,
    required this.moveInterval,
  })  : nextMoveTimer = moveInterval,
        fromX = x,
        fromY = y,
        toX = x,
        toY = y;
}
