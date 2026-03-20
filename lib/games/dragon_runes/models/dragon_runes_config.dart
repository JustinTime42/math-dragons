import 'rune_node_data.dart';
import 'equation_target.dart';

/// Allowed math operations in Dragon Runes.
enum MathOp {
  add,
  subtract,
  multiply,
  divide;

  String get symbol {
    switch (this) {
      case MathOp.add:
        return '+';
      case MathOp.subtract:
        return '\u2212'; // minus sign
      case MathOp.multiply:
        return '\u00D7'; // multiplication sign
      case MathOp.divide:
        return '\u00F7'; // division sign
    }
  }
}

/// Per-level difficulty configuration for Dragon Runes.
class DragonRunesConfig {
  final int levelNumber;
  final int worldNumber;
  final int levelInWorld; // 1-10
  final int numberOfFamilies; // 1-3
  final int targetCount;
  final int numberMin;
  final int numberMax;
  final List<MathOp> allowedOps;
  final bool showOpsInTargets;
  final int adjacencySpread; // max distance for adjacent family numbers
  final bool isVarietyLevel; // true = skip adjacency, use old random behavior

  const DragonRunesConfig({
    required this.levelNumber,
    required this.worldNumber,
    required this.levelInWorld,
    required this.numberOfFamilies,
    required this.targetCount,
    required this.numberMin,
    required this.numberMax,
    required this.allowedOps,
    required this.showOpsInTargets,
    required this.adjacencySpread,
    required this.isVarietyLevel,
  });

  /// Generate config for a specific level number (1-50).
  factory DragonRunesConfig.forLevel(int levelNumber) {
    final world = ((levelNumber - 1) ~/ 10) + 1;
    final levelInWorld = ((levelNumber - 1) % 10) + 1;
    final t = (levelInWorld - 1) / 9;
    final isVariety = levelInWorld % 3 == 0; // levels 3, 6, 9
    final spread = switch (world) {
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 2,
      5 => 3,
      _ => 1,
    };

    int families;
    int targetCount;
    bool showOps;
    int numberMin;
    int numberMax;
    List<MathOp> ops;

    switch (world) {
      case 1:
        families = t < 0.5 ? 1 : 2;
        targetCount = _lerp(2, 4, t).round();
        showOps = true;
        numberMin = 1;
        numberMax = _lerp(5, 8, t).round();
        ops = [MathOp.add];
      case 2:
        families = 2;
        targetCount = _lerp(4, 6, t).round();
        showOps = false;
        numberMin = 1;
        numberMax = _lerp(8, 10, t).round();
        ops = [MathOp.add, MathOp.subtract];
      case 3:
        families = t < 0.5 ? 2 : 3;
        targetCount = _lerp(6, 8, t).round();
        showOps = false;
        numberMin = 2;
        numberMax = _lerp(10, 12, t).round();
        ops = [MathOp.add, MathOp.subtract, MathOp.multiply];
      case 4:
        families = 3;
        targetCount = _lerp(8, 10, t).round();
        showOps = false;
        numberMin = 2;
        numberMax = _lerp(12, 15, t).round();
        ops = [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide];
      case 5:
        families = 3;
        targetCount = _lerp(10, 12, t).round();
        showOps = false;
        numberMin = 2;
        numberMax = 15;
        ops = [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide];
      default:
        families = 1;
        targetCount = 2;
        showOps = true;
        numberMin = 1;
        numberMax = 5;
        ops = [MathOp.add];
    }

    return DragonRunesConfig(
      levelNumber: levelNumber,
      worldNumber: world,
      levelInWorld: levelInWorld,
      numberOfFamilies: families,
      targetCount: targetCount,
      numberMin: numberMin,
      numberMax: numberMax,
      allowedOps: ops,
      showOpsInTargets: showOps,
      adjacencySpread: spread,
      isVarietyLevel: isVariety,
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

/// A pair of numbers forming a number family for equation generation.
class NumberFamily {
  final int a;
  final int b;

  const NumberFamily({required this.a, required this.b});

  @override
  String toString() => 'NumberFamily($a, $b)';
}

/// An equation generated from a number family.
class Equation {
  final int left;
  final String opSymbol;
  final int right;
  final int result;
  final String canonical;
  final String displayText;

  Equation.fromParts(this.left, this.opSymbol, this.right, this.result)
      : displayText = '$left $opSymbol $right = $result',
        canonical = _buildCanonical(left, opSymbol, right, result);

  List<int> get numbers => [left, right, result];

  static String _buildCanonical(int l, String op, int r, int res) {
    // Preserve exact operand order — each ordering is a distinct target
    return '$l$op$r=$res';
  }

  @override
  String toString() => 'Equation($displayText)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Equation && canonical == other.canonical;

  @override
  int get hashCode => canonical.hashCode;
}

/// Result of a generated level.
class GeneratedLevel {
  final List<RuneNodeData> nodes;
  final List<EquationTarget> targets;

  const GeneratedLevel({
    required this.nodes,
    required this.targets,
  });
}
