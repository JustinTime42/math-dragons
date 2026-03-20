import 'dart:math';
import 'package:flame/components.dart';
import '../models/egg_data.dart';
import '../models/difficulty_config.dart';
import '../components/egg_component.dart';
import '../../shared/math_problem.dart';
import '../../../core/difficulty_engine.dart';
import '../../../theme/dragon_colors.dart';
import 'package:flutter/material.dart';

/// Controls when and what type of eggs appear.
class EggSpawner {
  final double fieldWidth;
  final double dangerLineY;
  DifficultyTier tier;
  MathFact? focusFact;

  /// Optional difficulty engine for adaptive fact selection.
  DifficultyEngine? difficultyEngine;

  final Random _random = Random();
  double _spawnTimer = 0;
  bool _penaltyActive = false;
  double _penaltyTimer = 0;

  static const double _baseEggSize = 64.0;
  static const double _sizeVariance = 0.1;
  static const double _minTouchSize = 44.0;
  static const int _maxOperators = 8;

  EggSpawner({
    required this.fieldWidth,
    required this.dangerLineY,
    required this.tier,
  });

  void update(
    double dt,
    List<EggComponent> eggs,
    void Function(EggComponent) onSpawn,
  ) {
    _spawnTimer -= dt * 1000; // convert to ms
    if (_spawnTimer <= 0) {
      final interval = _penaltyActive
          ? tier.spawnIntervalMs / 2
          : tier.spawnIntervalMs;
      _spawnTimer = interval.toDouble();
      onSpawn(createEgg(eggs));
    }

    // Decay penalty timer
    if (_penaltyActive) {
      _penaltyTimer -= dt * 1000;
      if (_penaltyTimer <= 0) {
        _penaltyActive = false;
      }
    }
  }

  void activatePenalty() {
    _penaltyActive = true;
    _penaltyTimer = 2000; // 2 seconds
  }

  void updateTier(DifficultyTier newTier) {
    tier = newTier;
  }

  EggComponent createEgg(List<EggComponent> eggs) {
    final type = _selectType(eggs);
    final radius = _generateEggRadius();

    // x: random within field, keeping edges clear
    final x = radius + _random.nextDouble() * (fieldWidth - radius * 2);

    // y: just above danger line (spawns at top)
    final y = dangerLineY - radius * 2;

    // Initial velocity: slight horizontal drift
    final vx = (_random.nextDouble() - 0.5) * 60;

    final dynamic value;
    final Color baseColor;

    if (type == EggType.number) {
      value = _selectNumberValue();
      baseColor = _colorForNumber(value as int);
    } else {
      value = _selectOperator();
      baseColor = _colorForOperator(value as MathOp);
    }

    return EggComponent(
      type: type,
      value: value,
      eggPosition: Vector2(x, y),
      radius: radius,
      initialVx: vx,
      initialVy: 0,
      baseColor: baseColor,
    );
  }

  EggType _selectType(List<EggComponent> eggs) {
    final numCount = eggs
        .where(
            (e) => e.type == EggType.number && e.state == EggState.active)
        .length;
    final opCount = eggs
        .where(
            (e) => e.type == EggType.operator && e.state == EggState.active)
        .length;

    if (opCount >= _maxOperators) return EggType.number;

    final ratio = opCount / max(numCount, 1);
    if (ratio < 0.4) return EggType.operator;
    if (ratio > 0.6) return EggType.number;

    return _random.nextDouble() < 0.35 ? EggType.operator : EggType.number;
  }

  int _selectNumberValue() {
    // 30% chance: spawn a component of the current focus fact
    if (focusFact != null && _random.nextDouble() < 0.30) {
      final components = [focusFact!.left, focusFact!.right, focusFact!.result];
      return components[_random.nextInt(components.length)];
    }

    // 70% chance: random number from current tier's range
    return tier.numberMin +
        _random.nextInt(tier.numberMax - tier.numberMin + 1);
  }

  MathOp _selectOperator() {
    final ops = tier.operations;
    return ops[_random.nextInt(ops.length)];
  }

  double _generateEggRadius() {
    final variance = (_random.nextDouble() * 2 - 1) * _sizeVariance;
    final diameter = _baseEggSize * (1 + variance);
    return max(diameter, _minTouchSize) / 2;
  }

  Color _colorForNumber(int value) {
    if (value <= 3) return DragonColors.eggCream;
    if (value <= 6) return DragonColors.eggBlue;
    if (value <= 9) return DragonColors.eggGreen;
    return DragonColors.eggOrange;
  }

  Color _colorForOperator(MathOp op) {
    if (op == MathOp.divide) return DragonColors.eggDivision;
    return DragonColors.eggOperator;
  }
}
