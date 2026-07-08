import 'dart:math';
import 'package:flame/components.dart';
import '../models/egg_data.dart';
import '../models/difficulty_config.dart';
import '../components/egg_component.dart';
import '../../shared/math_problem.dart';
import '../../../theme/dragon_colors.dart';
import 'egg_field_planner.dart';
import 'package:flutter/material.dart';

/// Controls when and what type of eggs appear.
class EggSpawner {
  final double fieldWidth;
  final double dangerLineY;
  DifficultyTier tier;
  List<MathFact> factPool = const [];

  final Random _random = Random();
  final EggFieldPlanner _fieldPlanner = EggFieldPlanner();
  double _spawnTimer = 0;
  bool _penaltyActive = false;
  double _penaltyTimer = 0;

  static const double _baseEggSize = 64.0;
  static const double _sizeVariance = 0.1;
  static const double _minTouchSize = 44.0;

  EggSpawner({
    required this.fieldWidth,
    required this.dangerLineY,
    required this.tier,
  });

  void update(
    double dt,
    List<EggComponent> eggs,
    void Function(EggComponent) onSpawn,
    double intensity,
  ) {
    _spawnTimer -= dt * 1000; // convert to ms
    if (_spawnTimer <= 0) {
      final intensityScale = (1.0 - intensity.clamp(0.0, 1.0) * 0.45).clamp(
        0.45,
        1.0,
      );
      final interval =
          (_penaltyActive ? tier.spawnIntervalMs / 2 : tier.spawnIntervalMs) *
          intensityScale;
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
    final plan = _fieldPlanner.planNormalSpawn(
      visibleValues: _visibleValues(eggs),
      tier: tier,
      factPool: factPool,
    );
    return _createEggFromPlan(plan);
  }

  EggComponent createHelperEgg(List<EggComponent> eggs) {
    final plan = _fieldPlanner.planHelperSpawn(
      visibleValues: _visibleValues(eggs),
      tier: tier,
      factPool: factPool,
    );
    return _createEggFromPlan(plan);
  }

  void recordSolvedFact(String factKey) {
    _fieldPlanner.recordSolvedFact(factKey);
  }

  void resetSession() {
    _fieldPlanner.resetSession();
  }

  bool hasSolvableEquation(List<EggComponent> eggs) {
    return _fieldPlanner.findSolvableEquation(_visibleValues(eggs)) != null;
  }

  EggComponent _createEggFromPlan(EggValuePlan plan) {
    final type = plan.type;
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
      value = plan.value as int;
      baseColor = _colorForNumber(value as int);
    } else {
      value = plan.value as MathOp;
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

  List<VisibleEggValue> _visibleValues(List<EggComponent> eggs) {
    return eggs
        .where(
          (egg) =>
              egg.state == EggState.active || egg.state == EggState.selected,
        )
        .map((egg) {
          if (egg.type == EggType.number) {
            return VisibleEggValue.number(egg.value as int);
          }
          return VisibleEggValue.operator(egg.value as MathOp);
        })
        .toList();
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
