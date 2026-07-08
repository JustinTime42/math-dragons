import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_eggs/models/difficulty_config.dart';
import 'package:math_dragons/games/dragon_eggs/models/egg_data.dart';
import 'package:math_dragons/games/dragon_eggs/systems/egg_field_planner.dart';
import 'package:math_dragons/games/shared/math_problem.dart';

void main() {
  group('EggFieldPlanner', () {
    test('findSolvableEquation requires enough duplicate number eggs', () {
      final planner = EggFieldPlanner(random: Random(1));

      final notEnoughDuplicates = [
        const VisibleEggValue.number(1),
        const VisibleEggValue.number(2),
        const VisibleEggValue.operator(MathOp.add),
      ];
      expect(planner.findSolvableEquation(notEnoughDuplicates), isNull);

      final enoughDuplicates = [
        const VisibleEggValue.number(1),
        const VisibleEggValue.number(1),
        const VisibleEggValue.number(2),
        const VisibleEggValue.operator(MathOp.add),
      ];
      final equation = planner.findSolvableEquation(enoughDuplicates);
      expect(equation, isNotNull);
      expect(equation!.factKey, '1+1');
    });

    test('helper spawn completes a visible partial equation', () {
      final planner = EggFieldPlanner(random: Random(2));
      final tier = DifficultyTier.forLevel(1);
      final factPool = generateFacts(
        numberMin: tier.numberMin,
        numberMax: tier.numberMax,
        operations: tier.operations,
        resultMax: tier.resultMax,
      );

      final helper = planner.planHelperSpawn(
        visibleValues: [
          const VisibleEggValue.number(2),
          const VisibleEggValue.number(3),
          const VisibleEggValue.operator(MathOp.add),
        ],
        tier: tier,
        factPool: factPool,
      );

      expect(helper.isHelper, isTrue);
      expect(helper.type, EggType.number);
      expect(helper.value, 5);
    });

    test('helper spawn adds an operator when the field has only numbers', () {
      final planner = EggFieldPlanner(random: Random(3));
      final tier = DifficultyTier.forLevel(1);

      final helper = planner.planHelperSpawn(
        visibleValues: [
          const VisibleEggValue.number(2),
          const VisibleEggValue.number(3),
          const VisibleEggValue.number(5),
        ],
        tier: tier,
        factPool: const [],
      );

      expect(helper.isHelper, isTrue);
      expect(helper.type, EggType.operator);
      expect(helper.value, MathOp.add);
    });

    test('normal spawn repairs the field when no equation is solvable', () {
      final planner = EggFieldPlanner(random: Random(4));
      final tier = DifficultyTier.forLevel(1);
      final factPool = generateFacts(
        numberMin: tier.numberMin,
        numberMax: tier.numberMax,
        operations: tier.operations,
        resultMax: tier.resultMax,
      );

      final plan = planner.planNormalSpawn(
        visibleValues: [
          const VisibleEggValue.number(2),
          const VisibleEggValue.number(3),
          const VisibleEggValue.operator(MathOp.add),
        ],
        tier: tier,
        factPool: factPool,
      );

      expect(plan.isHelper, isTrue);
      expect(plan.type, EggType.number);
      final repairedEquation = planner.findSolvableEquation([
        const VisibleEggValue.number(2),
        const VisibleEggValue.number(3),
        const VisibleEggValue.operator(MathOp.add),
        VisibleEggValue.number(plan.value as int),
      ]);
      expect(repairedEquation, isNotNull);
    });
  });
}
