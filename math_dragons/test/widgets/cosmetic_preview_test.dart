import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/widgets/cosmetic_preview.dart';

void main() {
  group('CosmeticPreview', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(evolutionStage: 0),
            ),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
      // Default size SizedBox should be 72x72
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CosmeticPreview),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, 72);
      expect(sizedBox.height, 72);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(evolutionStage: 0, size: 160),
            ),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
    });

    testWidgets('uses portrait images by default (useHubImage: false)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(evolutionStage: 1),
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.isNotEmpty, isTrue);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('dragon_hatchling'));
    });

    testWidgets('uses hub images when useHubImage is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(evolutionStage: 1, useHubImage: true),
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.isNotEmpty, isTrue);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('hub'));
    });

    testWidgets('shows color variant when equippedColorId is set',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 1,
                equippedColorId: 'color_crimson',
              ),
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.isNotEmpty, isTrue);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('crimson'));
    });

    testWidgets('shows accessory images with Positioned widgets',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 1,
                equippedAccessoryIds: ['acc_crown'],
              ),
            ),
          ),
        ),
      );

      // Should have 2 images: dragon + crown accessory
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 2);
      final accImage = images[1].image as AssetImage;
      expect(accImage.assetName, contains('acc_crown'));

      // The accessory should be inside a Positioned widget
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('shows multiple accessory images at different positions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 1,
                equippedAccessoryIds: ['acc_crown', 'acc_scarf'],
              ),
            ),
          ),
        ),
      );

      // Dragon + 2 accessories
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 3);

      // Both accessories should be in Positioned widgets
      final positioned =
          tester.widgetList<Positioned>(find.byType(Positioned)).toList();
      expect(positioned.length, greaterThanOrEqualTo(2));

      // Crown (headTop) and scarf (neck) should have different top positions
      expect(positioned[0].top, isNot(equals(positioned[1].top)));
    });

    testWidgets('wing decorations render behind dragon (z-order)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 1,
                equippedAccessoryIds: ['acc_wing_decorations', 'acc_crown'],
              ),
            ),
          ),
        ),
      );

      // Should have Stack with 3 images: wing (behind), dragon, crown (front)
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 3);

      // First image should be the wing decorations (behind layer)
      final firstImage = images[0].image as AssetImage;
      expect(firstImage.assetName, contains('acc_wing_decorations'));

      // Second should be dragon
      final secondImage = images[1].image as AssetImage;
      expect(secondImage.assetName, contains('dragon_'));

      // Third should be crown (front layer)
      final thirdImage = images[2].image as AssetImage;
      expect(thirdImage.assetName, contains('acc_crown'));
    });

    testWidgets('egg stage does not show accessories', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 0,
                equippedAccessoryIds: ['acc_crown', 'acc_scarf'],
              ),
            ),
          ),
        ),
      );

      // Only dragon image, no accessories rendered
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 1);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('dragon_egg'));

      // No Positioned widgets for accessories
      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('clamps evolution stage to valid range', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(evolutionStage: 99),
            ),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
    });

    testWidgets('accessories from different slots render at different positions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CosmeticPreview(
                evolutionStage: 3,
                useHubImage: true,
                size: 200,
                equippedAccessoryIds: [
                  'acc_crown',
                  'acc_necklace',
                  'acc_battle_armor',
                ],
              ),
            ),
          ),
        ),
      );

      // Dragon + 3 accessories
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 4);

      // 3 Positioned widgets for 3 accessories
      final positioned =
          tester.widgetList<Positioned>(find.byType(Positioned)).toList();
      expect(positioned.length, 3);

      // Each should have a unique top value (head, neck, chest are different)
      final tops = positioned.map((p) => p.top).toSet();
      expect(tops.length, 3, reason: 'All three slots should have unique Y positions');
    });
  });
}
