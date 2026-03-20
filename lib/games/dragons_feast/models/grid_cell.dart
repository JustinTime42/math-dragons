import 'power_up_type.dart';

/// A single cell in the 5x5 Dragon's Feast grid.
class GridCell {
  final int x;
  final int y;
  int number;
  bool isCorrect;
  bool isEaten;
  PowerUpType? powerUp;

  GridCell({
    required this.x,
    required this.y,
    required this.number,
    required this.isCorrect,
    this.isEaten = false,
    this.powerUp,
  });
}
