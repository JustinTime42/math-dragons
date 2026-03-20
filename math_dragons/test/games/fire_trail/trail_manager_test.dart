import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/fire_trail/models/grid_position.dart';
import 'package:math_dragons/games/fire_trail/systems/trail_manager.dart';

void main() {
  group('TrailManager', () {
    late TrailManager manager;

    setUp(() {
      manager = TrailManager(initialLength: 5);
    });

    test('normal step with no pending growth: trail shrinks by 1', () {
      final trail = [
        const GridPosition(6, 7),
        const GridPosition(5, 7),
        const GridPosition(4, 7),
      ];
      manager.handleNormalStep(trail);
      expect(trail.length, 2);
    });

    test('normal step with pending growth: trail stays same', () {
      manager.pendingGrowth = 1;
      final trail = [
        const GridPosition(6, 7),
        const GridPosition(5, 7),
        const GridPosition(4, 7),
      ];
      manager.handleNormalStep(trail);
      expect(trail.length, 3);
      expect(manager.pendingGrowth, 0);
    });

    test('after 2 pending growth: trail grows by 2 over 2 steps', () {
      manager.pendingGrowth = 2;
      final trail = [
        const GridPosition(6, 7),
        const GridPosition(5, 7),
        const GridPosition(4, 7),
      ];

      // Step 1: pending=2, consume one, no tail removal
      manager.handleNormalStep(trail);
      expect(trail.length, 3);
      expect(manager.pendingGrowth, 1);

      // Step 2: pending=1, consume one, no tail removal
      manager.handleNormalStep(trail);
      expect(trail.length, 3);
      expect(manager.pendingGrowth, 0);

      // Step 3: pending=0, normal tail removal
      manager.handleNormalStep(trail);
      expect(trail.length, 2);
    });

    test('trail never goes below 0 length', () {
      final trail = <GridPosition>[];
      manager.handleNormalStep(trail);
      expect(trail.length, 0);
    });

    test('multiple pending growths stack correctly', () {
      manager.pendingGrowth = 3;
      final trail = [const GridPosition(6, 7)];

      manager.handleNormalStep(trail);
      expect(manager.pendingGrowth, 2);
      expect(trail.length, 1);

      manager.handleNormalStep(trail);
      expect(manager.pendingGrowth, 1);

      manager.handleNormalStep(trail);
      expect(manager.pendingGrowth, 0);

      // Now normal behavior
      manager.handleNormalStep(trail);
      expect(trail.length, 0);
    });

    test('reset clears pending growth', () {
      manager.pendingGrowth = 5;
      manager.reset();
      expect(manager.pendingGrowth, 0);
    });
  });
}
