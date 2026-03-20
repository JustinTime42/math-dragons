/// A target equation that the player needs to find.
class EquationTarget {
  final String canonical; // normalized form for matching, e.g. "2+3=5"
  final String displayText; // human-readable form, e.g. "2 + 3 = 5"

  const EquationTarget({
    required this.canonical,
    required this.displayText,
  });

  @override
  String toString() => 'EquationTarget($displayText)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquationTarget && canonical == other.canonical;

  @override
  int get hashCode => canonical.hashCode;
}
