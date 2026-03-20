import '../models/equation_target.dart';
import '../models/rune_node_data.dart';

/// Manages the hint system (3 hints per level).
class HintManager {
  int remaining;
  final List<EquationTarget> targets;
  final Set<String> solvedTargets;
  final List<RuneNodeData> nodes;

  HintManager({
    required this.targets,
    required this.solvedTargets,
    required this.nodes,
    this.remaining = 3,
  });

  /// Use a hint. Returns the node indices to highlight, or null if no hints
  /// left or all targets are solved.
  List<int>? useHint() {
    if (remaining <= 0) return null;

    // Find first unsolved target
    EquationTarget? unsolved;
    for (final t in targets) {
      if (!solvedTargets.contains(t.canonical)) {
        unsolved = t;
        break;
      }
    }
    if (unsolved == null) return null;

    final indices = _findNodesForEquation(unsolved);
    if (indices == null) return null;

    remaining--;
    return indices;
  }

  /// Find node indices that can form the given equation.
  List<int>? _findNodesForEquation(EquationTarget target) {
    // Parse canonical form back into tokens
    final tokens = _tokenize(target.canonical);
    if (tokens == null) return null;

    final indices = <int>[];
    final usedIndices = <int>{};

    for (final token in tokens) {
      // Find a matching unused node
      int? found;
      for (int i = 0; i < nodes.length; i++) {
        if (usedIndices.contains(i)) continue;
        if (nodes[i].value == token) {
          found = i;
          break;
        }
      }
      if (found == null) return null;
      indices.add(found);
      usedIndices.add(found);
    }

    return indices;
  }

  /// Split canonical form "2+3=5" into ["2", "+", "3", "=", "5"].
  List<String>? _tokenize(String canonical) {
    final result = <String>[];
    final buffer = StringBuffer();

    for (final char in canonical.runes) {
      final c = String.fromCharCode(char);
      if (RegExp(r'[0-9]').hasMatch(c)) {
        buffer.write(c);
      } else {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
        result.add(c);
      }
    }
    if (buffer.isNotEmpty) result.add(buffer.toString());

    return result.length >= 5 ? result : null;
  }
}
