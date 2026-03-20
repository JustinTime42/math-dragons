import '../models/rune_node_data.dart';
import '../models/equation_target.dart';

/// Result of validating an equation chain.
sealed class EquationResult {
  const EquationResult();
}

class InvalidEquation extends EquationResult {
  const InvalidEquation();
}

class AlreadyFoundEquation extends EquationResult {
  const AlreadyFoundEquation();
}

class BonusEquation extends EquationResult {
  final String displayText;
  final String canonical;
  const BonusEquation({required this.displayText, required this.canonical});
}

class TargetMatchEquation extends EquationResult {
  final EquationTarget target;
  const TargetMatchEquation({required this.target});
}

/// Validates equation chains against target equations.
class EquationValidator {
  final List<RuneNodeData> nodes;
  final List<EquationTarget> targets;
  final Set<String> solvedTargets;
  final Set<String> foundCanonicals;

  EquationValidator({
    required this.nodes,
    required this.targets,
    required this.solvedTargets,
    required this.foundCanonicals,
  });

  /// Validate a chain of node indices.
  EquationResult validate(List<int> chain) {
    // 1. Extract tokens from chain
    final tokens = chain.map((i) => nodes[i].value).toList();

    // 2. Find '=' position
    final eqIndex = tokens.indexOf('=');
    if (eqIndex < 0) return const InvalidEquation();

    // 3. Split into LHS and RHS
    final lhs = tokens.sublist(0, eqIndex);
    final rhs = tokens.sublist(eqIndex + 1);

    if (lhs.isEmpty || rhs.isEmpty) return const InvalidEquation();

    // 4. Evaluate both sides (left-to-right, no precedence)
    final lhsValue = _evalExpr(lhs);
    final rhsValue = _evalExpr(rhs);

    if (lhsValue == null || rhsValue == null) return const InvalidEquation();
    if (lhsValue != rhsValue) return const InvalidEquation();

    // 5. Build canonical form and match against targets
    final canonical = _canonicalForm(lhs, rhs);

    // Check against targets (exact match only — each ordering is distinct)
    for (final target in targets) {
      if (target.canonical == canonical) {
        if (solvedTargets.contains(target.canonical)) {
          return const AlreadyFoundEquation();
        }
        return TargetMatchEquation(target: target);
      }
    }

    // Valid equation but not a target — check for duplicate bonus
    if (foundCanonicals.contains(canonical)) {
      return const AlreadyFoundEquation();
    }
    return BonusEquation(displayText: tokens.join(' '), canonical: canonical);
  }

  /// Evaluate an expression left-to-right without operator precedence.
  static double? _evalExpr(List<String> tokens) {
    if (tokens.isEmpty) return null;

    final first = double.tryParse(tokens[0]);
    if (first == null) return null;

    double result = first;

    for (int i = 1; i < tokens.length; i += 2) {
      if (i + 1 >= tokens.length) return null;

      final op = tokens[i];
      final b = double.tryParse(tokens[i + 1]);
      if (b == null) return null;

      switch (op) {
        case '+':
          result = result + b;
        case '\u2212': // minus sign
        case '-':
          result = result - b;
        case '\u00D7': // multiplication sign
        case '*':
        case 'x':
          result = result * b;
        case '\u00F7': // division sign
        case '/':
          if (b == 0) return null;
          result = result / b;
        default:
          return null;
      }
    }

    // Must be integer result
    if (result != result.roundToDouble()) return null;
    if (result < 0) return null;

    return result;
  }

  /// Build canonical form: longer side first, "a+b=c" format.
  static String _canonicalForm(List<String> lhs, List<String> rhs) {
    final lhsStr = lhs.join('');
    final rhsStr = rhs.join('');
    if (lhs.length >= rhs.length) {
      return '$lhsStr=$rhsStr';
    }
    return '$rhsStr=$lhsStr';
  }

}
