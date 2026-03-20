import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/models/enemy_type.dart';
import 'package:math_dragons/games/dragons_feast/systems/collision_system.dart';

void main() {
  group('CollisionSystem', () {
    const system = CollisionSystem();

    EnemyData makeEnemy(int x, int y) {
      return EnemyData(
          x: x, y: y, type: EnemyType.chaser, moveInterval: 3.0);
    }

    test('player and enemy at same cell → caught', () {
      final enemies = [makeEnemy(2, 3)];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 3,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: false,
        hasShield: false,
      );
      expect(result, 0);
    });

    test('player and enemy at different cells → not caught', () {
      final enemies = [makeEnemy(0, 0)];
      final result = system.checkCollision(
        playerX: 4,
        playerY: 4,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: false,
        hasShield: false,
      );
      expect(result, -1);
    });

    test('player invulnerable → no caught even at same cell', () {
      final enemies = [makeEnemy(2, 2)];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 2,
        enemies: enemies,
        isInvulnerable: true,
        hasWings: false,
        hasShield: false,
      );
      expect(result, -1);
    });

    test('wings active → no caught even at same cell', () {
      final enemies = [makeEnemy(2, 2)];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 2,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: true,
        hasShield: false,
      );
      expect(result, -1);
    });

    test('shield active → no caught even at same cell', () {
      final enemies = [makeEnemy(2, 2)];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 2,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: false,
        hasShield: true,
      );
      expect(result, -1);
    });

    test('caught returns correct enemy index', () {
      final enemies = [
        makeEnemy(0, 0),
        makeEnemy(2, 3),
        makeEnemy(4, 4),
      ];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 3,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: false,
        hasShield: false,
      );
      expect(result, 1);
    });

    test('moving enemy uses target position for collision', () {
      final enemy = makeEnemy(1, 1);
      enemy.isMoving = true;
      enemy.toX = 2;
      enemy.toY = 2;

      final result = system.checkCollision(
        playerX: 2,
        playerY: 2,
        enemies: [enemy],
        isInvulnerable: false,
        hasWings: false,
        hasShield: false,
      );
      expect(result, 0);
    });

    test('multiple enemies: first collision returned', () {
      final enemies = [
        makeEnemy(2, 2),
        makeEnemy(2, 2),
      ];
      final result = system.checkCollision(
        playerX: 2,
        playerY: 2,
        enemies: enemies,
        isInvulnerable: false,
        hasWings: false,
        hasShield: false,
      );
      expect(result, 0);
    });
  });
}
