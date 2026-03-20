import '../models/enemy_type.dart';

/// Collision detection between player and enemies.
class CollisionSystem {
  const CollisionSystem();

  /// Check if any enemy occupies the same cell as the player.
  /// Returns the index of the colliding enemy, or -1 if no collision.
  int checkCollision({
    required int playerX,
    required int playerY,
    required List<EnemyData> enemies,
    required bool isInvulnerable,
    required bool hasWings,
    required bool hasShield,
  }) {
    if (isInvulnerable || hasWings || hasShield) return -1;

    for (int i = 0; i < enemies.length; i++) {
      final data = enemies[i];
      // Use target position for moving enemies
      final ex = data.isMoving ? data.toX : data.x;
      final ey = data.isMoving ? data.toY : data.y;

      if (ex == playerX && ey == playerY) {
        return i;
      }
    }
    return -1;
  }
}
