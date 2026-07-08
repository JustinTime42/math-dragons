import 'egg_data.dart';

class DifficultyTier {
  final int level;
  final int numberMin;
  final int numberMax;
  final List<MathOp> operations;
  final double gravityMultiplier;
  final int spawnIntervalMs;
  final int resultMax;
  final int requiredSolves;

  const DifficultyTier({
    required this.level,
    required this.numberMin,
    required this.numberMax,
    required this.operations,
    required this.gravityMultiplier,
    required this.spawnIntervalMs,
    required this.resultMax,
    required this.requiredSolves,
  });

  int get tier => level;

  static DifficultyTier forLevel(int levelNum) {
    final l = levelNum.clamp(1, 50);

    final int maxNum;
    if (l <= 1) {
      maxNum = 4;
    } else if (l <= 3) {
      maxNum = 5;
    } else if (l <= 5) {
      maxNum = 6;
    } else if (l <= 8) {
      maxNum = 7;
    } else if (l <= 11) {
      maxNum = 8;
    } else if (l <= 15) {
      maxNum = 9;
    } else if (l <= 20) {
      maxNum = 10;
    } else if (l <= 30) {
      maxNum = 11;
    } else {
      maxNum = 12;
    }

    final List<MathOp> ops;
    if (l <= 10) {
      ops = [MathOp.add];
    } else if (l <= 20) {
      ops = [MathOp.add, MathOp.subtract];
    } else if (l <= 35) {
      ops = [MathOp.add, MathOp.subtract, MathOp.multiply];
    } else {
      ops = [MathOp.add, MathOp.subtract, MathOp.multiply, MathOp.divide];
    }

    final gravity = 0.95 + (l - 1) * 0.018;
    final spawnMs = (2100 - (l - 1) * 28).clamp(620, 2100);

    final int resMax;
    if (l <= 20) {
      resMax = maxNum * 2;
    } else {
      resMax = maxNum * maxNum;
    }

    final solves = (14 + (l - 1) * 0.75).round().clamp(14, 52);

    return DifficultyTier(
      level: l,
      numberMin: 1,
      numberMax: maxNum,
      operations: ops,
      gravityMultiplier: gravity,
      spawnIntervalMs: spawnMs,
      resultMax: resMax,
      requiredSolves: solves,
    );
  }

  static final tiers = List.generate(50, (i) => forLevel(i + 1));
}
