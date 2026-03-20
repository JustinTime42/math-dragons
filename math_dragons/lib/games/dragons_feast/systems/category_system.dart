import 'dart:math' show sqrt;

import '../models/math_category.dart';

/// All math category definitions for Dragon's Feast.
class CategorySystem {
  CategorySystem._();

  static bool _isPrime(int n) {
    if (n < 2) return false;
    if (n < 4) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }

  static bool _isPerfectSquare(int n) {
    if (n < 1) return false;
    final root = sqrt(n.toDouble()).round();
    return root * root == n;
  }

  static final List<MathCategory> allCategories = [
    // Even / Odd
    MathCategory(
      id: 'even',
      displayName: 'Even Numbers',
      description: 'Numbers divisible by 2',
      predicate: (n) => n > 0 && n % 2 == 0,
    ),
    MathCategory(
      id: 'odd',
      displayName: 'Odd Numbers',
      description: 'Numbers not divisible by 2',
      predicate: (n) => n > 0 && n % 2 == 1,
    ),

    // Multiples of N (2-12)
    for (final m in [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
      MathCategory(
        id: 'mult_$m',
        displayName: 'Multiples of $m',
        description: 'Numbers divisible by $m',
        predicate: (n) => n > 0 && n % m == 0,
      ),

    // Primes & Composites
    MathCategory(
      id: 'prime',
      displayName: 'Prime Numbers',
      description: 'Numbers with exactly 2 factors',
      predicate: _isPrime,
    ),
    MathCategory(
      id: 'composite',
      displayName: 'Composite Numbers',
      description: 'Numbers with more than 2 factors',
      predicate: (n) => n > 1 && !_isPrime(n),
    ),

    // Perfect Squares
    MathCategory(
      id: 'squares',
      displayName: 'Perfect Squares',
      description: 'Numbers that are perfect squares',
      predicate: _isPerfectSquare,
      rangeMax: 144,
    ),
  ];

  /// Create a "Factors of N" category.
  static MathCategory factorsOfCategory(int n) {
    return MathCategory(
      id: 'factors_$n',
      displayName: 'Factors of $n',
      description: 'Numbers that divide evenly into $n',
      predicate: (x) => x > 0 && n % x == 0,
      rangeMin: 1,
      rangeMax: n,
    );
  }

  /// Create a "Greater than N" category.
  static MathCategory greaterThanCategory(int n) {
    return MathCategory(
      id: 'gt_$n',
      displayName: 'Greater than $n',
      description: 'Numbers larger than $n',
      predicate: (x) => x > n,
    );
  }

  /// Create a "Less than N" category.
  static MathCategory lessThanCategory(int n) {
    return MathCategory(
      id: 'lt_$n',
      displayName: 'Less than $n',
      description: 'Numbers smaller than $n',
      predicate: (x) => x > 0 && x < n,
    );
  }

  /// Create a "Between A and B" range category.
  static MathCategory inRangeCategory(int lo, int hi) {
    return MathCategory(
      id: 'range_${lo}_$hi',
      displayName: 'Between $lo and $hi',
      description: 'Numbers from $lo to $hi',
      predicate: (x) => x >= lo && x <= hi,
      rangeMin: 1,
      rangeMax: hi + 20,
    );
  }

  /// Get category for a specific level (1-40).
  static MathCategory categoryForLevel(int levelNumber) {
    switch (levelNumber) {
      // World 1: Easy Pickings
      case 1:
        return allCategories.firstWhere((c) => c.id == 'even');
      case 2:
        return allCategories.firstWhere((c) => c.id == 'odd');
      case 3:
        return allCategories.firstWhere((c) => c.id == 'mult_2');
      case 4:
        return allCategories.firstWhere((c) => c.id == 'mult_5');
      case 5:
        return allCategories.firstWhere((c) => c.id == 'mult_10');
      case 6:
        return allCategories.firstWhere((c) => c.id == 'mult_3');
      case 7:
        return allCategories.firstWhere((c) => c.id == 'mult_4');
      case 8:
        return greaterThanCategory(25);

      // World 2: Growing Appetite
      case 9:
        return allCategories.firstWhere((c) => c.id == 'mult_6');
      case 10:
        return allCategories.firstWhere((c) => c.id == 'mult_7');
      case 11:
        return allCategories.firstWhere((c) => c.id == 'mult_8');
      case 12:
        return allCategories.firstWhere((c) => c.id == 'mult_9');
      case 13:
        return lessThanCategory(30);
      case 14:
        return allCategories.firstWhere((c) => c.id == 'mult_11');
      case 15:
        return allCategories.firstWhere((c) => c.id == 'mult_12');
      case 16:
        return inRangeCategory(20, 50);

      // World 3: Refined Palate
      case 17:
        return allCategories.firstWhere((c) => c.id == 'prime');
      case 18:
        return allCategories.firstWhere((c) => c.id == 'composite');
      case 19:
        return allCategories.firstWhere((c) => c.id == 'squares');
      case 20:
        return factorsOfCategory(24);
      case 21:
        return allCategories.firstWhere((c) => c.id == 'even');
      case 22:
        return allCategories.firstWhere((c) => c.id == 'odd');
      case 23:
        return allCategories.firstWhere((c) => c.id == 'mult_7');
      case 24:
        return allCategories.firstWhere((c) => c.id == 'prime');

      // World 4: Gourmet Dragon
      case 25:
        return factorsOfCategory(36);
      case 26:
        return factorsOfCategory(48);
      case 27:
        return factorsOfCategory(60);
      case 28:
        return allCategories.firstWhere((c) => c.id == 'mult_11');
      case 29:
        return allCategories.firstWhere((c) => c.id == 'prime');
      case 30:
        return allCategories.firstWhere((c) => c.id == 'composite');
      case 31:
        return allCategories.firstWhere((c) => c.id == 'squares');
      case 32:
        return greaterThanCategory(50);

      // World 5: Dragon King's Feast
      case 33:
        return allCategories.firstWhere((c) => c.id == 'prime');
      case 34:
        return factorsOfCategory(72);
      case 35:
        return allCategories.firstWhere((c) => c.id == 'mult_7');
      case 36:
        return allCategories.firstWhere((c) => c.id == 'squares');
      case 37:
        return factorsOfCategory(96);
      case 38:
        return allCategories.firstWhere((c) => c.id == 'composite');
      case 39:
        return inRangeCategory(30, 70);
      case 40:
        return allCategories.firstWhere((c) => c.id == 'prime');

      default:
        return allCategories.firstWhere((c) => c.id == 'even');
    }
  }
}
