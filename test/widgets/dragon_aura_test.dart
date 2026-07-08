import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/widgets/cosmetic_preview.dart';
import 'package:math_dragons/widgets/dragon_aura.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('DragonAura in CosmeticPreview', () {
    testWidgets('renders an aura when an effect is equipped', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CosmeticPreview(
            evolutionStage: 3,
            equippedAccessoryIds: ['effect_ember_aura'],
            size: 120,
          ),
        ),
      );

      expect(find.byType(DragonAura), findsOneWidget);
    });

    testWidgets('renders no aura when nothing is equipped', (tester) async {
      await tester.pumpWidget(
        wrap(const CosmeticPreview(evolutionStage: 3, size: 120)),
      );

      expect(find.byType(DragonAura), findsNothing);
    });

    testWidgets('aura shows even at egg stage (non-occluding, stage-agnostic)',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const CosmeticPreview(
            evolutionStage: 0,
            equippedAccessoryIds: ['effect_frost_aura'],
            size: 120,
          ),
        ),
      );

      expect(find.byType(DragonAura), findsOneWidget);
    });
  });
}
