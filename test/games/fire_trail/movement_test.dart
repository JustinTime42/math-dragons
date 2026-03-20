import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';
import 'package:math_dragons/games/fire_trail/systems/movement_system.dart';

void main() {
  group('MovementSystem (no wrap)', () {
    late MovementSystem system;

    setUp(() {
      system = MovementSystem(gridSize: 15, wrap: false);
    });

    test('moving right from (5,5) gives (6,5)', () {
      final result =
          system.nextPosition(const GridPosition(5, 5), Direction.right);
      expect(result, const GridPosition(6, 5));
    });

    test('moving left from (5,5) gives (4,5)', () {
      final result =
          system.nextPosition(const GridPosition(5, 5), Direction.left);
      expect(result, const GridPosition(4, 5));
    });

    test('moving up from (5,5) gives (5,4)', () {
      final result =
          system.nextPosition(const GridPosition(5, 5), Direction.up);
      expect(result, const GridPosition(5, 4));
    });

    test('moving down from (5,5) gives (5,6)', () {
      final result =
          system.nextPosition(const GridPosition(5, 5), Direction.down);
      expect(result, const GridPosition(5, 6));
    });

    test('wall collision right from (14,5) returns null', () {
      final result =
          system.nextPosition(const GridPosition(14, 5), Direction.right);
      expect(result, isNull);
    });

    test('wall collision left from (0,5) returns null', () {
      final result =
          system.nextPosition(const GridPosition(0, 5), Direction.left);
      expect(result, isNull);
    });

    test('wall collision up from (5,0) returns null', () {
      final result =
          system.nextPosition(const GridPosition(5, 0), Direction.up);
      expect(result, isNull);
    });

    test('wall collision down from (5,14) returns null', () {
      final result =
          system.nextPosition(const GridPosition(5, 14), Direction.down);
      expect(result, isNull);
    });
  });

  group('MovementSystem (wrap)', () {
    late MovementSystem system;

    setUp(() {
      system = MovementSystem(gridSize: 15, wrap: true);
    });

    test('wrap right from (14,5) gives (0,5)', () {
      final result =
          system.nextPosition(const GridPosition(14, 5), Direction.right);
      expect(result, const GridPosition(0, 5));
    });

    test('wrap left from (0,5) gives (14,5)', () {
      final result =
          system.nextPosition(const GridPosition(0, 5), Direction.left);
      expect(result, const GridPosition(14, 5));
    });

    test('wrap up from (5,0) gives (5,14)', () {
      final result =
          system.nextPosition(const GridPosition(5, 0), Direction.up);
      expect(result, const GridPosition(5, 14));
    });

    test('wrap down from (5,14) gives (5,0)', () {
      final result =
          system.nextPosition(const GridPosition(5, 14), Direction.down);
      expect(result, const GridPosition(5, 0));
    });
  });
}
