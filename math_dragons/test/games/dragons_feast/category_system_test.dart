import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/systems/category_system.dart';

void main() {
  group('CategorySystem', () {
    group('Even Numbers', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');

      test('identifies even numbers', () {
        expect(cat.predicate(2), isTrue);
        expect(cat.predicate(4), isTrue);
        expect(cat.predicate(6), isTrue);
        expect(cat.predicate(10), isTrue);
        expect(cat.predicate(100), isTrue);
      });

      test('rejects odd numbers', () {
        expect(cat.predicate(1), isFalse);
        expect(cat.predicate(3), isFalse);
        expect(cat.predicate(5), isFalse);
        expect(cat.predicate(99), isFalse);
      });

      test('rejects zero and negatives', () {
        expect(cat.predicate(0), isFalse);
      });
    });

    group('Odd Numbers', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'odd');

      test('identifies odd numbers', () {
        expect(cat.predicate(1), isTrue);
        expect(cat.predicate(3), isTrue);
        expect(cat.predicate(5), isTrue);
        expect(cat.predicate(99), isTrue);
      });

      test('rejects even numbers', () {
        expect(cat.predicate(2), isFalse);
        expect(cat.predicate(4), isFalse);
        expect(cat.predicate(6), isFalse);
      });
    });

    group('Multiples of 7', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_7');

      test('identifies multiples of 7', () {
        expect(cat.predicate(7), isTrue);
        expect(cat.predicate(14), isTrue);
        expect(cat.predicate(21), isTrue);
        expect(cat.predicate(49), isTrue);
        expect(cat.predicate(77), isTrue);
      });

      test('rejects non-multiples of 7', () {
        expect(cat.predicate(8), isFalse);
        expect(cat.predicate(15), isFalse);
        expect(cat.predicate(20), isFalse);
      });
    });

    group('Multiples of 12', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_12');

      test('identifies multiples of 12', () {
        expect(cat.predicate(12), isTrue);
        expect(cat.predicate(24), isTrue);
        expect(cat.predicate(36), isTrue);
        expect(cat.predicate(96), isTrue);
      });

      test('rejects non-multiples of 12', () {
        expect(cat.predicate(11), isFalse);
        expect(cat.predicate(13), isFalse);
        expect(cat.predicate(25), isFalse);
      });
    });

    group('Prime Numbers', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'prime');

      test('identifies primes', () {
        for (final p in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]) {
          expect(cat.predicate(p), isTrue, reason: '$p should be prime');
        }
      });

      test('rejects non-primes', () {
        for (final n in [1, 4, 6, 8, 9, 10, 12, 15, 16, 20, 25]) {
          expect(cat.predicate(n), isFalse, reason: '$n should not be prime');
        }
      });

      test('rejects 0 and 1', () {
        expect(cat.predicate(0), isFalse);
        expect(cat.predicate(1), isFalse);
      });
    });

    group('Composite Numbers', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'composite');

      test('identifies composites', () {
        for (final n in [4, 6, 8, 9, 10, 12, 15]) {
          expect(cat.predicate(n), isTrue, reason: '$n should be composite');
        }
      });

      test('rejects primes', () {
        for (final p in [2, 3, 5, 7, 11, 13]) {
          expect(cat.predicate(p), isFalse, reason: '$p should not be composite');
        }
      });

      test('rejects 1', () {
        expect(cat.predicate(1), isFalse);
      });
    });

    group('Perfect Squares', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'squares');

      test('identifies perfect squares', () {
        for (final s in [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144]) {
          expect(cat.predicate(s), isTrue, reason: '$s should be a perfect square');
        }
      });

      test('rejects non-perfect-squares', () {
        for (final n in [2, 3, 5, 10, 50]) {
          expect(cat.predicate(n), isFalse, reason: '$n should not be a perfect square');
        }
      });
    });

    group('Factors of N', () {
      test('factors of 24', () {
        final cat = CategorySystem.factorsOfCategory(24);
        for (final f in [1, 2, 3, 4, 6, 8, 12, 24]) {
          expect(cat.predicate(f), isTrue, reason: '$f should be a factor of 24');
        }
        for (final n in [5, 7, 9, 10, 11]) {
          expect(cat.predicate(n), isFalse, reason: '$n should not be a factor of 24');
        }
      });

      test('factors of 36', () {
        final cat = CategorySystem.factorsOfCategory(36);
        for (final f in [1, 2, 3, 4, 6, 9, 12, 18, 36]) {
          expect(cat.predicate(f), isTrue, reason: '$f should be a factor of 36');
        }
      });
    });

    group('Greater/Less Than', () {
      test('greater than 25', () {
        final cat = CategorySystem.greaterThanCategory(25);
        expect(cat.predicate(26), isTrue);
        expect(cat.predicate(30), isTrue);
        expect(cat.predicate(50), isTrue);
        expect(cat.predicate(99), isTrue);
        expect(cat.predicate(25), isFalse);
        expect(cat.predicate(1), isFalse);
      });

      test('less than 30', () {
        final cat = CategorySystem.lessThanCategory(30);
        expect(cat.predicate(1), isTrue);
        expect(cat.predicate(15), isTrue);
        expect(cat.predicate(29), isTrue);
        expect(cat.predicate(30), isFalse);
        expect(cat.predicate(31), isFalse);
        expect(cat.predicate(50), isFalse);
      });
    });

    group('In Range', () {
      test('between 20 and 50', () {
        final cat = CategorySystem.inRangeCategory(20, 50);
        expect(cat.predicate(20), isTrue);
        expect(cat.predicate(35), isTrue);
        expect(cat.predicate(50), isTrue);
        expect(cat.predicate(19), isFalse);
        expect(cat.predicate(51), isFalse);
      });
    });

    group('All categories have unique IDs', () {
      test('no duplicate IDs in allCategories', () {
        final ids = CategorySystem.allCategories.map((c) => c.id).toSet();
        expect(ids.length, CategorySystem.allCategories.length);
      });
    });

    group('categoryForLevel', () {
      test('returns valid categories for all 40 levels', () {
        for (int i = 1; i <= 40; i++) {
          final cat = CategorySystem.categoryForLevel(i);
          expect(cat.id, isNotEmpty, reason: 'Level $i should have a category');
          expect(cat.displayName, isNotEmpty);
        }
      });

      test('level 1 is even', () {
        expect(CategorySystem.categoryForLevel(1).id, 'even');
      });

      test('level 17 is prime', () {
        expect(CategorySystem.categoryForLevel(17).id, 'prime');
      });

      test('level 25 is factors of 36', () {
        expect(CategorySystem.categoryForLevel(25).id, 'factors_36');
      });

      test('default returns even for out of range', () {
        expect(CategorySystem.categoryForLevel(41).id, 'even');
      });
    });
  });
}
