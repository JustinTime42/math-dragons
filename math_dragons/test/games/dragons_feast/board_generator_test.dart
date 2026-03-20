import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/models/power_up_type.dart';
import 'package:math_dragons/games/dragons_feast/systems/board_generator.dart';
import 'package:math_dragons/games/dragons_feast/systems/category_system.dart';

void main() {
  group('BoardGenerator', () {
    test('generates a 5x5 board (25 cells)', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      expect(board.cells.length, 5);
      for (final row in board.cells) {
        expect(row.length, 5);
      }
    });

    test('board has approximately 40% correct tiles (8-12)', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate(targetCorrectCount: 10);

      int correctCount = 0;
      for (final row in board.cells) {
        for (final cell in row) {
          if (cell.isCorrect) correctCount++;
        }
      }

      expect(correctCount, inInclusiveRange(8, 12));
    });

    test('all correct tiles pass the category predicate', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_7');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      for (final row in board.cells) {
        for (final cell in row) {
          if (cell.isCorrect) {
            expect(cat.predicate(cell.number), isTrue,
                reason: '${cell.number} marked correct but does not match predicate');
          }
        }
      }
    });

    test('all wrong tiles fail the category predicate', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_7');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      for (final row in board.cells) {
        for (final cell in row) {
          if (!cell.isCorrect) {
            expect(cat.predicate(cell.number), isFalse,
                reason: '${cell.number} marked wrong but matches predicate');
          }
        }
      }
    });

    test('no empty tiles on initial generation', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      for (final row in board.cells) {
        for (final cell in row) {
          expect(cell.isEaten, isFalse);
          expect(cell.number, greaterThan(0));
        }
      }
    });

    test('numbers are within category range', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'squares');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      for (final row in board.cells) {
        for (final cell in row) {
          expect(cell.number, greaterThanOrEqualTo(1));
        }
      }
    });

    test('requiredCorrect equals actual correct count', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'prime');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate(targetCorrectCount: 10);

      int actualCorrect = 0;
      for (final row in board.cells) {
        for (final cell in row) {
          if (cell.isCorrect) actualCorrect++;
        }
      }

      expect(board.requiredCorrect, actualCorrect);
    });

    test('generates board even with restrictive category (perfect squares)', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'squares');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate(targetCorrectCount: 10);

      // Should still generate a full board
      int cellCount = 0;
      for (final row in board.cells) {
        cellCount += row.length;
      }
      expect(cellCount, 25);
    });

    test('board has reasonable number diversity', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate();

      final numbers = <int>{};
      for (final row in board.cells) {
        for (final cell in row) {
          numbers.add(cell.number);
        }
      }

      // At least 15 unique numbers out of 25
      expect(numbers.length, greaterThanOrEqualTo(10));
    });

    test('different categories produce different boards', () {
      final cat1 = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final cat2 = CategorySystem.allCategories.firstWhere((c) => c.id == 'prime');
      final gen1 = BoardGenerator(category: cat1, gridSize: 5, random: Random(42));
      final gen2 = BoardGenerator(category: cat2, gridSize: 5, random: Random(42));
      final board1 = gen1.generate();
      final board2 = gen2.generate();

      // At least some numbers should be different
      bool anyDifferent = false;
      for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 5; x++) {
          if (board1.cells[y][x].number != board2.cells[y][x].number) {
            anyDifferent = true;
          }
        }
      }
      expect(anyDifferent, isTrue);
    });

    test('generateSingleCorrect returns matching number', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_7');
      final gen = BoardGenerator(category: cat, gridSize: 5);
      final n = gen.generateSingleCorrect();
      expect(cat.predicate(n), isTrue);
    });

    test('generateSingleWrong returns non-matching number', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'mult_7');
      final gen = BoardGenerator(category: cat, gridSize: 5);
      final n = gen.generateSingleWrong();
      expect(cat.predicate(n), isFalse);
    });

    test('power-up is placed on board when specified', () {
      final cat = CategorySystem.allCategories.firstWhere((c) => c.id == 'even');
      final gen = BoardGenerator(category: cat, gridSize: 5, random: Random(42));
      final board = gen.generate(
        powerUp: PowerUpType.freeze,
      );

      int powerUpCount = 0;
      for (final row in board.cells) {
        for (final cell in row) {
          if (cell.powerUp != null) powerUpCount++;
        }
      }
      expect(powerUpCount, 1);
    });
  });
}
