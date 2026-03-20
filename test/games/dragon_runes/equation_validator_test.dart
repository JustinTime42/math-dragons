import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/models/equation_target.dart';
import 'package:math_dragons/games/dragon_runes/models/rune_node_data.dart';
import 'package:math_dragons/games/dragon_runes/systems/equation_validator.dart';

void main() {
  group('EquationValidator', () {
    // Helper to create nodes from value strings
    List<RuneNodeData> makeNodes(List<String> values) {
      return values.map((v) {
        if (v == '=') {
          return RuneNodeData(type: RuneNodeType.equals, value: v);
        } else if (RegExp(r'^\d+$').hasMatch(v)) {
          return RuneNodeData(
            type: RuneNodeType.number,
            value: v,
            numericValue: int.parse(v),
          );
        } else {
          return RuneNodeData(type: RuneNodeType.operator, value: v);
        }
      }).toList();
    }

    test('valid addition: 2 + 3 = 5 matches target', () {
      final nodes = makeNodes(['2', '+', '3', '=', '5']);
      final targets = [
        const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('valid subtraction: 5 - 3 = 2 matches target', () {
      final nodes = makeNodes(['5', '\u2212', '3', '=', '2']);
      final targets = [
        const EquationTarget(
            canonical: '5\u2212\u0033=2', displayText: '5 \u2212 3 = 2'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      // Canonical form: longer side first = "5−3=2"
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('valid multiplication: 3 × 4 = 12 matches target', () {
      final nodes = makeNodes(['3', '\u00D7', '4', '=', '12']);
      final targets = [
        const EquationTarget(
            canonical: '3\u00D74=12', displayText: '3 \u00D7 4 = 12'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('valid division: 12 ÷ 3 = 4 matches target', () {
      final nodes = makeNodes(['12', '\u00F7', '3', '=', '4']);
      final targets = [
        const EquationTarget(
            canonical: '12\u00F73=4', displayText: '12 \u00F7 3 = 4'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('invalid: LHS != RHS', () {
      final nodes = makeNodes(['2', '+', '3', '=', '6']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('invalid: no equals sign', () {
      final nodes = makeNodes(['2', '+', '3', '+', '5']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('invalid: division by zero', () {
      final nodes = makeNodes(['5', '\u00F7', '0', '=', '0']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('invalid: non-integer result', () {
      final nodes = makeNodes(['7', '\u00F7', '2', '=', '3']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('invalid: negative result', () {
      final nodes = makeNodes(['2', '\u2212', '5', '=', '3']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      // 2-5 = -3, which doesn't match RHS 3 anyway, but also negative
      expect(result, isA<InvalidEquation>());
    });

    test('left-to-right evaluation: 2+3*4=20, not 14', () {
      // (2+3)*4 = 20 in left-to-right
      final nodes = makeNodes(['2', '+', '3', '\u00D7', '4', '=', '20']);
      final targets = [
        const EquationTarget(
            canonical: '2+3\u00D74=20', displayText: '2 + 3 \u00D7 4 = 20'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4, 5, 6]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('each ordering is a distinct target: 3+2=5 does not match 2+3=5', () {
      final nodes = makeNodes(['3', '+', '2', '=', '5']);
      final targets = [
        const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      // 3+2=5 is valid math but not the target 2+3=5
      expect(result, isA<BonusEquation>());
    });

    test('each ordering is a distinct target: 3+2=5 matches its own target', () {
      final nodes = makeNodes(['3', '+', '2', '=', '5']);
      final targets = [
        const EquationTarget(canonical: '3+2=5', displayText: '3 + 2 = 5'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });

    test('each ordering is a distinct target: 4×3=12 does not match 3×4=12', () {
      final nodes = makeNodes(['4', '\u00D7', '3', '=', '12']);
      final targets = [
        const EquationTarget(
            canonical: '3\u00D74=12', displayText: '3 \u00D7 4 = 12'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<BonusEquation>());
    });

    test('already-found target returns AlreadyFoundEquation', () {
      final nodes = makeNodes(['2', '+', '3', '=', '5']);
      final targets = [
        const EquationTarget(canonical: '2+3=5', displayText: '2 + 3 = 5'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {'2+3=5'},
        foundCanonicals: {'2+3=5'},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<AlreadyFoundEquation>());
    });

    test('valid equation not in targets returns BonusEquation', () {
      final nodes = makeNodes(['1', '+', '1', '=', '2']);
      final targets = [
        const EquationTarget(canonical: '3+4=7', displayText: '3 + 4 = 7'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<BonusEquation>());
    });

    test('empty LHS is invalid', () {
      final nodes = makeNodes(['=', '2', '+', '3', '5']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('empty RHS is invalid', () {
      final nodes = makeNodes(['2', '+', '3', '5', '=']);
      final validator = EquationValidator(
        nodes: nodes,
        targets: [],
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<InvalidEquation>());
    });

    test('two-digit numbers validated correctly: 12+3=15', () {
      final nodes = makeNodes(['12', '+', '3', '=', '15']);
      final targets = [
        const EquationTarget(
            canonical: '12+3=15', displayText: '12 + 3 = 15'),
      ];
      final validator = EquationValidator(
        nodes: nodes,
        targets: targets,
        solvedTargets: {},
        foundCanonicals: {},
      );
      final result = validator.validate([0, 1, 2, 3, 4]);
      expect(result, isA<TargetMatchEquation>());
    });
  });
}
