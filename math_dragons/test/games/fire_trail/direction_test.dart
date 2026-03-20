import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';

void main() {
  group('Direction', () {
    test('right has dx=1, dy=0', () {
      expect(Direction.right.dx, 1);
      expect(Direction.right.dy, 0);
    });

    test('left has dx=-1, dy=0', () {
      expect(Direction.left.dx, -1);
      expect(Direction.left.dy, 0);
    });

    test('up has dx=0, dy=-1', () {
      expect(Direction.up.dx, 0);
      expect(Direction.up.dy, -1);
    });

    test('down has dx=0, dy=1', () {
      expect(Direction.down.dx, 0);
      expect(Direction.down.dy, 1);
    });

    test('right.isOpposite(left) is true', () {
      expect(Direction.right.isOpposite(Direction.left), isTrue);
    });

    test('left.isOpposite(right) is true', () {
      expect(Direction.left.isOpposite(Direction.right), isTrue);
    });

    test('up.isOpposite(down) is true', () {
      expect(Direction.up.isOpposite(Direction.down), isTrue);
    });

    test('down.isOpposite(up) is true', () {
      expect(Direction.down.isOpposite(Direction.up), isTrue);
    });

    test('right.isOpposite(up) is false', () {
      expect(Direction.right.isOpposite(Direction.up), isFalse);
    });

    test('right.isOpposite(right) is false', () {
      expect(Direction.right.isOpposite(Direction.right), isFalse);
    });
  });

  group('GridPosition', () {
    test('equality works', () {
      expect(const GridPosition(3, 5), const GridPosition(3, 5));
    });

    test('inequality works', () {
      expect(const GridPosition(3, 5) == const GridPosition(3, 6), isFalse);
    });

    test('hashCode is consistent', () {
      final a = const GridPosition(3, 5);
      final b = const GridPosition(3, 5);
      expect(a.hashCode, b.hashCode);
    });
  });
}
