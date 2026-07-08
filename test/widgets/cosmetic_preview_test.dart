import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/widgets/cosmetic_preview.dart';

// The adopted art direction (see docs/step12/ACCESSORY_PIPELINE_DECISION.md)
// renders accessories as full-canvas posed layers registered 1:1 to the dragon
// template, with occlusion baked into each layer's alpha. There is no runtime
// per-accessory anchor positioning and no separate "behind" pass; every
// equipped accessory layer is stacked over the dragon at the same registered
// offset. These tests assert that registered-layer behavior.
void main() {
  group('CosmeticPreview', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CosmeticPreview(evolutionStage: 0)),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(CosmeticPreview),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, 72);
      expect(sizedBox.height, 72);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CosmeticPreview(evolutionStage: 0, size: 160)),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
    });

    testWidgets('uses portrait posed art by default (useHubImage: false)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CosmeticPreview(evolutionStage: 1)),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.isNotEmpty, isTrue);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('portrait'));
      expect(assetImage.assetName, contains('stage1'));
    });

    testWidgets('uses hub posed art when useHubImage is true', (tester) async {
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

    testWidgets('shows skin-specific posed art when equippedColorId is set',
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

    testWidgets('stacks a registered accessory layer over the dragon',
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

      // Dragon + one registered crown layer.
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 2);
      final accImage = images[1].image as AssetImage;
      expect(accImage.assetName, contains('acc_crown'));

      // Registered layers are placed with Positioned (at the shared offset).
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('stacks multiple registered accessory layers', (tester) async {
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

      // Dragon + 2 registered layers.
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 3);

      final names = images
          .map((i) => (i.image as AssetImage).assetName)
          .toList();
      expect(names.any((n) => n.contains('acc_crown')), isTrue);
      expect(names.any((n) => n.contains('acc_scarf')), isTrue);
    });

    testWidgets('wing decorations render as a registered layer', (tester) async {
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

      // Dragon + 2 registered layers. Occlusion (wings behind the body) is
      // baked into each layer's alpha, not handled by a separate draw pass.
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 3);

      // The dragon is drawn under the accessory layers.
      final dragonName = (images[0].image as AssetImage).assetName;
      expect(dragonName, contains('dragon_'));

      final names = images
          .map((i) => (i.image as AssetImage).assetName)
          .toList();
      expect(names.any((n) => n.contains('acc_wing_decorations')), isTrue);
      expect(names.any((n) => n.contains('acc_crown')), isTrue);
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

      // Only the dragon (egg) posed art; wearable accessories start at stage 1.
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 1);
      final assetImage = images.first.image as AssetImage;
      expect(assetImage.assetName, contains('stage0'));

      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('clamps evolution stage to valid range', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CosmeticPreview(evolutionStage: 99)),
          ),
        ),
      );

      expect(find.byType(CosmeticPreview), findsOneWidget);
    });

    testWidgets('stacks one registered layer per equipped accessory',
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

      // Dragon + 3 registered accessory layers.
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 4);

      final positioned =
          tester.widgetList<Positioned>(find.byType(Positioned)).toList();
      expect(positioned.length, 3);
    });
  });
}
