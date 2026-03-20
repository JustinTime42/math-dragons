import 'dart:math';

import '../models/grid_cell.dart';
import '../models/math_category.dart';
import '../models/power_up_type.dart';

/// Result of board generation.
class GeneratedBoard {
  final List<List<GridCell>> cells;
  final int requiredCorrect;
  final MathCategory category;

  const GeneratedBoard({
    required this.cells,
    required this.requiredCorrect,
    required this.category,
  });
}

/// Generates 5x5 boards for Dragon's Feast.
class BoardGenerator {
  final MathCategory category;
  final int gridSize;
  final Random random;

  /// Numbers the engine wants the player to see more of.
  List<int>? biasNumbers;

  BoardGenerator({
    required this.category,
    required this.gridSize,
    Random? random,
  }) : random = random ?? Random();

  /// Set number bias from the difficulty engine.
  void setBias(List<int> numbers) {
    biasNumbers = numbers;
  }

  /// Generate a 5x5 board with ~40% correct tiles.
  GeneratedBoard generate({
    int targetCorrectCount = 10,
    PowerUpType? powerUp,
  }) {
    // 1. Generate correct numbers (matching category)
    final correctNumbers = _generateCorrectNumbers(targetCorrectCount);

    // 2. Generate wrong numbers (not matching category)
    final wrongCount = gridSize * gridSize - correctNumbers.length;
    final wrongNumbers = _generateWrongNumbers(wrongCount);

    // 3. Combine and shuffle
    final allNumbers = [...correctNumbers, ...wrongNumbers];
    allNumbers.shuffle(random);

    // 4. Assign to grid
    final board = List.generate(
      gridSize,
      (y) => List.generate(gridSize, (x) {
        final idx = y * gridSize + x;
        final num = allNumbers[idx];
        return GridCell(
          x: x,
          y: y,
          number: num,
          isCorrect: category.predicate(num),
        );
      }),
    );

    // 5. Place power-up on a random non-player cell if specified
    if (powerUp != null) {
      _placePowerUp(board, powerUp);
    }

    return GeneratedBoard(
      cells: board,
      requiredCorrect: correctNumbers.length,
      category: category,
    );
  }

  List<int> _generateCorrectNumbers(int count) {
    final numbers = <int>[];
    final usedNumbers = <int>{};
    int attempts = 0;

    // Seed with biased numbers first (up to 30% of count)
    if (biasNumbers != null && biasNumbers!.isNotEmpty) {
      final biasLimit = (count * 0.3).ceil();
      final candidates =
          biasNumbers!.where((n) => category.predicate(n)).toList()..shuffle(random);
      for (final n in candidates) {
        if (numbers.length >= biasLimit) break;
        if (!usedNumbers.contains(n)) {
          numbers.add(n);
          usedNumbers.add(n);
        }
      }
    }

    while (numbers.length < count && attempts < 500) {
      final n =
          category.rangeMin + random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (category.predicate(n) && !usedNumbers.contains(n)) {
        numbers.add(n);
        usedNumbers.add(n);
      }
      attempts++;
    }

    // If not enough unique numbers, allow repeats
    while (numbers.length < count) {
      final n =
          category.rangeMin + random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (category.predicate(n)) {
        numbers.add(n);
      }
    }

    return numbers;
  }

  List<int> _generateWrongNumbers(int count) {
    final numbers = <int>[];
    final usedNumbers = <int>{};
    int attempts = 0;

    while (numbers.length < count && attempts < 500) {
      final n =
          category.rangeMin + random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (!category.predicate(n) && !usedNumbers.contains(n)) {
        numbers.add(n);
        usedNumbers.add(n);
      }
      attempts++;
    }

    // Fallback: if not enough wrong numbers, generate from wider range
    while (numbers.length < count) {
      final n = 1 + random.nextInt(99);
      if (!category.predicate(n)) {
        numbers.add(n);
      }
    }

    return numbers;
  }

  void _placePowerUp(List<List<GridCell>> board, PowerUpType powerUp) {
    // Avoid (0,0) where player starts
    final candidates = <GridCell>[];
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (x == 0 && y == 0) continue;
        candidates.add(board[y][x]);
      }
    }
    if (candidates.isNotEmpty) {
      final cell = candidates[random.nextInt(candidates.length)];
      cell.powerUp = powerUp;
    }
  }

  /// Generate a single correct number for respawning.
  /// 30% chance to use a biased number if available and matching.
  int generateSingleCorrect() {
    if (biasNumbers != null &&
        biasNumbers!.isNotEmpty &&
        random.nextDouble() < 0.30) {
      final candidates =
          biasNumbers!.where((n) => category.predicate(n)).toList();
      if (candidates.isNotEmpty) {
        return candidates[random.nextInt(candidates.length)];
      }
    }
    for (int i = 0; i < 100; i++) {
      final n =
          category.rangeMin + random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (category.predicate(n)) return n;
    }
    // Fallback — try all numbers in range
    for (int n = category.rangeMin; n <= category.rangeMax; n++) {
      if (category.predicate(n)) return n;
    }
    return category.rangeMin;
  }

  /// Generate a single wrong number for respawning.
  int generateSingleWrong() {
    for (int i = 0; i < 100; i++) {
      final n =
          category.rangeMin + random.nextInt(category.rangeMax - category.rangeMin + 1);
      if (!category.predicate(n)) return n;
    }
    // Fallback
    for (int n = 1; n <= 99; n++) {
      if (!category.predicate(n)) return n;
    }
    return 1;
  }
}
