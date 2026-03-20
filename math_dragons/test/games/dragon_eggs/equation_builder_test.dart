import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/systems/equation_builder.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/dragon_eggs/components/egg_component.dart';

/// Helper to create a test egg without needing Flame's full game context.
EggComponent _makeEgg(EggType type, dynamic value) {
  return EggComponent(
    type: type,
    value: value,
    eggPosition: Vector2.zero(),
    radius: 32,
    baseColor: Colors.blue,
  );
}

void main() {
  group('EquationBuilder', () {
    late EquationBuilder builder;

    setUp(() {
      builder = EquationBuilder();
    });

    test('initial state is selectLeft', () {
      expect(builder.step, EquationStep.selectLeft);
      expect(builder.parts, isEmpty);
    });

    test('selecting a number at step 0 advances to selectOperator', () {
      final egg = _makeEgg(EggType.number, 3);
      final accepted = builder.trySelect(egg);

      expect(accepted, isTrue);
      expect(builder.step, EquationStep.selectOperator);
      expect(builder.parts.length, 1);
      expect(egg.state, EggState.selected);
    });

    test('selecting an operator at step 0 is rejected', () {
      final egg = _makeEgg(EggType.operator, MathOp.add);
      final accepted = builder.trySelect(egg);

      expect(accepted, isFalse);
      expect(builder.step, EquationStep.selectLeft);
      expect(builder.parts, isEmpty);
    });

    test('selecting a number at step 1 (selectOperator) is rejected', () {
      final num1 = _makeEgg(EggType.number, 3);
      builder.trySelect(num1);

      final num2 = _makeEgg(EggType.number, 5);
      final accepted = builder.trySelect(num2);

      expect(accepted, isFalse);
      expect(builder.step, EquationStep.selectOperator);
    });

    test('full valid sequence: number -> operator -> number -> equals -> number',
        () {
      final left = _makeEgg(EggType.number, 3);
      final op = _makeEgg(EggType.operator, MathOp.add);
      final right = _makeEgg(EggType.number, 5);
      final answer = _makeEgg(EggType.number, 8);

      expect(builder.trySelect(left), isTrue);
      expect(builder.step, EquationStep.selectOperator);

      expect(builder.trySelect(op), isTrue);
      expect(builder.step, EquationStep.selectRight);

      expect(builder.trySelect(right), isTrue);
      expect(builder.step, EquationStep.pressEquals);

      // Can't select egg at pressEquals
      final extra = _makeEgg(EggType.number, 9);
      expect(builder.trySelect(extra), isFalse);

      // Press equals
      expect(builder.pressEquals(), isTrue);
      expect(builder.step, EquationStep.selectAnswer);

      expect(builder.trySelect(answer), isTrue);
      expect(builder.parts.length, 4);
      expect(builder.shouldEvaluate, isTrue);
    });

    test('tapping a selected egg deselects it and everything after', () {
      final left = _makeEgg(EggType.number, 3);
      final op = _makeEgg(EggType.operator, MathOp.add);
      final right = _makeEgg(EggType.number, 5);

      builder.trySelect(left);
      builder.trySelect(op);
      builder.trySelect(right);

      expect(builder.parts.length, 3);

      // Tap the operator (index 1) — should deselect op and right
      builder.trySelect(op);

      expect(builder.parts.length, 1);
      expect(builder.step, EquationStep.selectOperator);
      expect(op.state, EggState.active);
      expect(right.state, EggState.active);
      expect(left.state, EggState.selected);
    });

    test('deselectAll resets to step 0 with empty parts', () {
      final left = _makeEgg(EggType.number, 3);
      final op = _makeEgg(EggType.operator, MathOp.add);

      builder.trySelect(left);
      builder.trySelect(op);
      builder.deselectAll();

      expect(builder.parts, isEmpty);
      expect(builder.step, EquationStep.selectLeft);
      expect(left.state, EggState.active);
      expect(op.state, EggState.active);
    });

    test('pressEquals only works at step 3', () {
      expect(builder.pressEquals(), isFalse); // step 0

      final left = _makeEgg(EggType.number, 3);
      builder.trySelect(left);
      expect(builder.pressEquals(), isFalse); // step 1

      final op = _makeEgg(EggType.operator, MathOp.add);
      builder.trySelect(op);
      expect(builder.pressEquals(), isFalse); // step 2

      final right = _makeEgg(EggType.number, 5);
      builder.trySelect(right);
      expect(builder.pressEquals(), isTrue); // step 3
    });

    test('display string updates correctly at each step', () {
      expect(builder.displayString, '? _ ? = ?');

      builder.trySelect(_makeEgg(EggType.number, 3));
      expect(builder.displayString, startsWith('3'));

      builder.trySelect(_makeEgg(EggType.operator, MathOp.add));
      expect(builder.displayString, contains('+'));

      builder.trySelect(_makeEgg(EggType.number, 5));
      expect(builder.displayString, contains('5'));
    });

    test('reset clears all state', () {
      builder.trySelect(_makeEgg(EggType.number, 3));
      builder.trySelect(_makeEgg(EggType.operator, MathOp.add));
      builder.reset();

      expect(builder.parts, isEmpty);
      expect(builder.step, EquationStep.selectLeft);
      expect(builder.displayString, '? _ ? = ?');
    });
  });
}
