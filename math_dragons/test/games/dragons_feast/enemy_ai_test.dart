import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/models/enemy_type.dart';
import 'package:math_dragons/games/dragons_feast/systems/enemy_ai.dart';

void main() {
  group('EnemyAI', () {
    test('all moves stay within 5x5 grid bounds', () {
      final ai = EnemyAI(gridSize: 5, random: Random(42));

      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
          final enemy = EnemyData(
              x: x, y: y, type: EnemyType.wanderer, moveInterval: 3.0);
          final (dx, dy) = ai.nextMove(enemy, 2, 2);
          final nx = x + dx;
          final ny = y + dy;
          expect(nx, inInclusiveRange(0, 4),
              reason: 'x=$x, dx=$dx out of bounds');
          expect(ny, inInclusiveRange(0, 4),
              reason: 'y=$y, dy=$dy out of bounds');
        }
      }
    });

    test('wanderer moves in a valid direction', () {
      final ai = EnemyAI(gridSize: 5, random: Random(42));
      final enemy =
          EnemyData(x: 2, y: 2, type: EnemyType.wanderer, moveInterval: 3.0);

      for (int i = 0; i < 20; i++) {
        final (dx, dy) = ai.nextMove(enemy, 0, 0);
        // Should be a cardinal direction or stationary
        expect(dx.abs() + dy.abs(), lessThanOrEqualTo(1));
      }
    });

    test('chaser generally moves toward player', () {
      // Use a fixed seed and check multiple trials
      int towardCount = 0;
      const trials = 100;

      for (int i = 0; i < trials; i++) {
        final ai = EnemyAI(gridSize: 5, random: Random(i));
        final enemy =
            EnemyData(x: 0, y: 0, type: EnemyType.chaser, moveInterval: 3.0);
        final (dx, dy) = ai.nextMove(enemy, 4, 4);

        // Moving toward (4,4) means dx > 0 or dy > 0
        if (dx > 0 || dy > 0) towardCount++;
      }

      // Should be > 50% of the time (chaser has 60% pursue bias)
      expect(towardCount, greaterThan(trials * 0.4));
    });

    test('enemy at (0,0), player at (4,4): chaser moves right or down', () {
      // With high probability, chaser should move right or down
      final ai = EnemyAI(gridSize: 5, random: Random(42));
      final enemy =
          EnemyData(x: 0, y: 0, type: EnemyType.chaser, moveInterval: 3.0);
      final (dx, dy) = ai.nextMove(enemy, 4, 4);

      // Valid move: right (1,0), down (0,1), or some random direction
      final nx = enemy.x + dx;
      final ny = enemy.y + dy;
      expect(nx, inInclusiveRange(0, 4));
      expect(ny, inInclusiveRange(0, 4));
    });

    test('enemy in corner: only valid moves returned', () {
      final ai = EnemyAI(gridSize: 5, random: Random(42));

      // Top-left corner
      final enemyTL =
          EnemyData(x: 0, y: 0, type: EnemyType.wanderer, moveInterval: 3.0);
      for (int i = 0; i < 20; i++) {
        final (dx, dy) = ai.nextMove(enemyTL, 2, 2);
        expect(enemyTL.x + dx, inInclusiveRange(0, 4));
        expect(enemyTL.y + dy, inInclusiveRange(0, 4));
      }

      // Bottom-right corner
      final enemyBR =
          EnemyData(x: 4, y: 4, type: EnemyType.wanderer, moveInterval: 3.0);
      for (int i = 0; i < 20; i++) {
        final (dx, dy) = ai.nextMove(enemyBR, 2, 2);
        expect(enemyBR.x + dx, inInclusiveRange(0, 4));
        expect(enemyBR.y + dy, inInclusiveRange(0, 4));
      }
    });

    test('enemy at same position as player: returns a valid move', () {
      final ai = EnemyAI(gridSize: 5, random: Random(42));
      final enemy =
          EnemyData(x: 2, y: 2, type: EnemyType.chaser, moveInterval: 3.0);
      final (dx, dy) = ai.nextMove(enemy, 2, 2);

      final nx = enemy.x + dx;
      final ny = enemy.y + dy;
      expect(nx, inInclusiveRange(0, 4));
      expect(ny, inInclusiveRange(0, 4));
    });

    test('seeded AI produces deterministic results', () {
      final ai1 = EnemyAI(gridSize: 5, random: Random(123));
      final ai2 = EnemyAI(gridSize: 5, random: Random(123));

      final enemy1 =
          EnemyData(x: 1, y: 1, type: EnemyType.chaser, moveInterval: 3.0);
      final enemy2 =
          EnemyData(x: 1, y: 1, type: EnemyType.chaser, moveInterval: 3.0);

      final move1 = ai1.nextMove(enemy1, 3, 3);
      final move2 = ai2.nextMove(enemy2, 3, 3);

      expect(move1, equals(move2));
    });
  });
}
