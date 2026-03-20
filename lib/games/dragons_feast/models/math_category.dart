/// A math category for Dragon's Feast levels.
/// The predicate tests whether a number matches the category.
class MathCategory {
  final String id;
  final String displayName;
  final String description;
  final bool Function(int n) predicate;
  final int rangeMin;
  final int rangeMax;

  const MathCategory({
    required this.id,
    required this.displayName,
    required this.description,
    required this.predicate,
    this.rangeMin = 1,
    this.rangeMax = 99,
  });
}
