/// Types of rune nodes on the circle.
enum RuneNodeType { number, operator, equals }

/// Data model for a single rune node.
class RuneNodeData {
  final RuneNodeType type;
  final String value; // "7", "+", "="
  final int numericValue; // 7 for numbers, -1 for ops/equals

  const RuneNodeData({
    required this.type,
    required this.value,
    this.numericValue = -1,
  });

  @override
  String toString() => 'RuneNodeData($value)';
}
