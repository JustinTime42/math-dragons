import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/models/equation_target.dart';
import 'package:math_dragons/games/dragon_runes/models/rune_node_data.dart';
import 'package:math_dragons/games/dragon_runes/systems/hint_manager.dart';

void main() {
  group('HintManager', () {
    // Nodes: 2, +, 3, =, 5
    final nodes = [
      const RuneNodeData(
          type: RuneNodeType.number, value: '2', numericValue: 2),
      const RuneNodeData(type: RuneNodeType.operator, value: '+'),
      const RuneNodeData(
          type: RuneNodeType.number, value: '3', numericValue: 3),
      const RuneNodeData(type: RuneNodeType.equals, value: '='),
      const RuneNodeData(
          type: RuneNodeType.number, value: '5', numericValue: 5),
    ];

    final targets = [
      const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
    ];

    test('initial hints = 3', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {},
        nodes: nodes,
      );
      expect(manager.remaining, 3);
    });

    test('useHint returns node indices for an unsolved target', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {},
        nodes: nodes,
      );
      final indices = manager.useHint();
      expect(indices, isNotNull);
      expect(indices!.length, greaterThanOrEqualTo(5));
    });

    test('useHint decrements remaining', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {},
        nodes: nodes,
      );
      manager.useHint();
      expect(manager.remaining, 2);
    });

    test('after 3 uses, remaining = 0 and useHint returns null', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {},
        nodes: nodes,
      );
      manager.useHint();
      manager.useHint();
      manager.useHint();
      expect(manager.remaining, 0);
      expect(manager.useHint(), isNull);
    });

    test('when all targets solved, useHint returns null', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {'2+3=5'},
        nodes: nodes,
      );
      expect(manager.useHint(), isNull);
      expect(manager.remaining, 3); // didn't decrement
    });

    test('hint finds correct nodes matching the target equation', () {
      final manager = HintManager(
        targets: targets,
        solvedTargets: {},
        nodes: nodes,
      );
      final indices = manager.useHint()!;
      // The tokens should correspond to 2, +, 3, =, 5
      final values = indices.map((i) => nodes[i].value).toList();
      expect(values, ['2', '+', '3', '=', '5']);
    });

    test('hint skips already-solved targets', () {
      final twoTargets = [
        const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
        const EquationTarget(canonical: '3+2=5', displayText: '3 + 2 = 5'),
      ];
      // Add extra nodes for the second target
      final extendedNodes = [
        ...nodes,
        const RuneNodeData(
            type: RuneNodeType.number, value: '3', numericValue: 3),
        const RuneNodeData(type: RuneNodeType.operator, value: '+'),
        const RuneNodeData(
            type: RuneNodeType.number, value: '2', numericValue: 2),
      ];

      final manager = HintManager(
        targets: twoTargets,
        solvedTargets: {'2+3=5'}, // first target solved
        nodes: extendedNodes,
      );
      final indices = manager.useHint();
      expect(indices, isNotNull);
      // Should hint the second target, not the first
      final hintedCanonical =
          indices!.map((i) => extendedNodes[i].value).join('');
      expect(hintedCanonical, contains('3'));
    });
  });
}
