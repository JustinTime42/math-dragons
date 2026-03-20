import 'dart:math';

import '../models/enemy_type.dart';

/// Enemy movement AI for Dragon's Feast.
class EnemyAI {
  final int gridSize;
  final Random random;

  EnemyAI({required this.gridSize, Random? random})
      : random = random ?? Random();

  /// Calculate next move for an enemy. Returns (dx, dy).
  (int, int) nextMove(EnemyData enemy, int playerX, int playerY) {
    switch (enemy.type) {
      case EnemyType.chaser:
        return _chaserMove(enemy, playerX, playerY);
      case EnemyType.wanderer:
        return _wandererMove(enemy);
    }
  }

  /// Chaser AI: 60% chance to move toward player, 40% random.
  (int, int) _chaserMove(EnemyData enemy, int playerX, int playerY) {
    if (random.nextDouble() < 0.6) {
      final dx = playerX - enemy.x;
      final dy = playerY - enemy.y;
      final adx = dx.abs();
      final ady = dy.abs();

      int mx = 0, my = 0;
      if (adx > ady) {
        mx = dx > 0 ? 1 : -1;
      } else if (ady > 0) {
        my = dy > 0 ? 1 : -1;
      } else {
        // Same position, random
        return _randomMove(enemy);
      }

      final nx = enemy.x + mx;
      final ny = enemy.y + my;
      if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
        return (mx, my);
      }
    }

    return _randomMove(enemy);
  }

  /// Wanderer AI: purely random movement.
  (int, int) _wandererMove(EnemyData enemy) {
    return _randomMove(enemy);
  }

  (int, int) _randomMove(EnemyData enemy) {
    final dirs = [(0, -1), (0, 1), (-1, 0), (1, 0)];
    dirs.shuffle(random);
    for (final (dx, dy) in dirs) {
      final nx = enemy.x + dx;
      final ny = enemy.y + dy;
      if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
        return (dx, dy);
      }
    }
    return (0, 0);
  }
}
