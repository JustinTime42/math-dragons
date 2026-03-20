import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/systems/chain_manager.dart';

void main() {
  group('ChainManager', () {
    late ChainManager manager;

    setUp(() {
      manager = ChainManager();
    });

    test('start chain at a node creates chain with 1 element', () {
      manager.start(3);
      expect(manager.chain, [3]);
      expect(manager.isDragging, true);
    });

    test('extend chain with new node grows chain', () {
      manager.start(0);
      final action = manager.extend(1);
      expect(action, ChainAction.added);
      expect(manager.chain, [0, 1]);
    });

    test('extend with last node is ignored', () {
      manager.start(0);
      final action = manager.extend(0);
      expect(action, ChainAction.ignored);
      expect(manager.chain, [0]);
    });

    test('extend with already-in-chain node is ignored', () {
      manager.start(0);
      manager.extend(1);
      manager.extend(2);
      final action = manager.extend(0);
      expect(action, ChainAction.ignored);
      expect(manager.chain, [0, 1, 2]);
    });

    test('backtrack: extend with previous node shrinks chain', () {
      manager.start(0);
      manager.extend(1);
      manager.extend(2);
      final action = manager.extend(1); // previous node
      expect(action, ChainAction.backtracked);
      expect(manager.chain, [0, 1]);
    });

    test('end chain with length >= 5 returns the chain', () {
      manager.start(0);
      manager.extend(1);
      manager.extend(2);
      manager.extend(3);
      manager.extend(4);
      final result = manager.end();
      expect(result, [0, 1, 2, 3, 4]);
      expect(manager.chain, isEmpty);
      expect(manager.isDragging, false);
    });

    test('end chain with length < 5 returns null', () {
      manager.start(0);
      manager.extend(1);
      manager.extend(2);
      final result = manager.end();
      expect(result, isNull);
      expect(manager.chain, isEmpty);
    });

    test('clear empties chain and stops dragging', () {
      manager.start(0);
      manager.extend(1);
      manager.clear();
      expect(manager.chain, isEmpty);
      expect(manager.isDragging, false);
    });

    test('extend when not dragging is ignored', () {
      final action = manager.extend(0);
      expect(action, ChainAction.ignored);
    });
  });
}
