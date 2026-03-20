/// A position on the grid (column x, row y).
class GridPosition {
  final int x;
  final int y;

  const GridPosition(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is GridPosition && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ (y.hashCode * 31);

  @override
  String toString() => 'GridPosition($x, $y)';
}

/// Direction of movement on the grid.
enum Direction {
  up(0, -1),
  down(0, 1),
  left(-1, 0),
  right(1, 0);

  final int dx;
  final int dy;

  const Direction(this.dx, this.dy);

  bool isOpposite(Direction other) => dx == -other.dx && dy == -other.dy;
}
