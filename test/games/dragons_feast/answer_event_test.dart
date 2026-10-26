// FET-1 (docs/specs/adaptive-practice.md section 9.3, rule FE-b).
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragons_feast/dragons_feast_game.dart';
import 'package:math_dragons/games/dragons_feast/systems/category_system.dart';

void main() {
  final mult3 = CategorySystem.allCategories.firstWhere(
    (c) => c.id == 'mult_3',
  );

  test('FET-1 eating 14 on mult_3 is a miss on "mult_3:14"', () {
    final event = answerEventForTile(
      category: mult3,
      number: 14,
      responseTimeMs: 700,
    );
    expect(event.factKey, 'mult_3:14');
    expect(event.correct, isFalse);
    expect(event.gameId, 'dragons_feast');
    expect(event.firstAttempt, isTrue);
    expect(event.responseTimeMs, 700);
  });

  test('FET-1 eating 12 on mult_3 is correct on "mult_3:12"', () {
    final event = answerEventForTile(
      category: mult3,
      number: 12,
      responseTimeMs: 700,
    );
    expect(event.factKey, 'mult_3:12');
    expect(event.correct, isTrue);
  });

  test('every category id yields keys in the property grammar', () {
    final grammar = RegExp(r'^([a-z][a-z0-9_]*):(\d{1,3})$');
    for (final category in [
      ...CategorySystem.allCategories,
      CategorySystem.factorsOfCategory(24),
      CategorySystem.greaterThanCategory(20),
      CategorySystem.lessThanCategory(20),
      CategorySystem.inRangeCategory(10, 20),
    ]) {
      final event = answerEventForTile(
        category: category,
        number: 12,
        responseTimeMs: 1,
      );
      expect(grammar.hasMatch(event.factKey!), isTrue, reason: category.id);
    }
  });
}
