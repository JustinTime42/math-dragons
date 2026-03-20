import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/theme/dragon_anchor_points.dart';

void main() {
  group('DragonAnchorPoints', () {
    const allAccessoryIds = [
      'acc_crown',
      'acc_wizard_hat',
      'acc_scarf',
      'acc_necklace',
      'acc_battle_armor',
      'acc_wing_decorations',
    ];

    test('getAccessoryAnchor returns null for stage 0 (egg)', () {
      for (final id in allAccessoryIds) {
        expect(
          DragonAnchorPoints.getAccessoryAnchor(
            accessoryId: id,
            evolutionStage: 0,
            isColorVariant: false,
          ),
          isNull,
          reason: '$id should not have an anchor on egg stage',
        );
      }
    });

    test('getAccessoryAnchor returns non-null for all 6 accessories x stages 1-5',
        () {
      for (final id in allAccessoryIds) {
        for (int stage = 1; stage <= 5; stage++) {
          expect(
            DragonAnchorPoints.getAccessoryAnchor(
              accessoryId: id,
              evolutionStage: stage,
              isColorVariant: false,
            ),
            isNotNull,
            reason: '$id should have an anchor for stage $stage',
          );
        }
      }
    });

    test('getAccessoryAnchor returns null for unknown accessory ID', () {
      expect(
        DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_nonexistent',
          evolutionStage: 1,
          isColorVariant: false,
        ),
        isNull,
      );
    });

    test('crown and wizard hat return different anchors for same stage', () {
      for (int stage = 1; stage <= 5; stage++) {
        final crown = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_crown',
          evolutionStage: stage,
          isColorVariant: false,
        )!;
        final hat = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_wizard_hat',
          evolutionStage: stage,
          isColorVariant: false,
        )!;

        // Wizard hat should sit higher (lower dy) than crown
        expect(hat.dy, lessThan(crown.dy),
            reason: 'Wizard hat should be higher than crown at stage $stage');
        // Wizard hat should be larger
        expect(hat.scale, greaterThan(crown.scale),
            reason: 'Wizard hat should be larger than crown at stage $stage');
      }
    });

    test('scarf and necklace return different anchors for same stage', () {
      for (int stage = 1; stage <= 5; stage++) {
        final scarf = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_scarf',
          evolutionStage: stage,
          isColorVariant: false,
        )!;
        final necklace = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_necklace',
          evolutionStage: stage,
          isColorVariant: false,
        )!;

        // Necklace pendant hangs lower than scarf
        expect(necklace.dy, greaterThan(scarf.dy),
            reason: 'Necklace should hang lower than scarf at stage $stage');
      }
    });

    test('color variant: head/neck accessories have anchors', () {
      const headNeckIds = [
        'acc_crown',
        'acc_wizard_hat',
        'acc_scarf',
        'acc_necklace',
      ];
      for (final id in headNeckIds) {
        expect(
          DragonAnchorPoints.getAccessoryAnchor(
            accessoryId: id,
            evolutionStage: 3,
            isColorVariant: true,
          ),
          isNotNull,
          reason: '$id should have a color variant anchor',
        );
      }
    });

    test('color variant: armor and wings return null (not visible in bust)',
        () {
      expect(
        DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_battle_armor',
          evolutionStage: 3,
          isColorVariant: true,
        ),
        isNull,
      );
      expect(
        DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_wing_decorations',
          evolutionStage: 3,
          isColorVariant: true,
        ),
        isNull,
      );
    });

    test('all anchor values are in valid ranges', () {
      for (final id in allAccessoryIds) {
        for (int stage = 1; stage <= 5; stage++) {
          final anchor = DragonAnchorPoints.getAccessoryAnchor(
            accessoryId: id,
            evolutionStage: stage,
            isColorVariant: false,
          )!;
          expect(anchor.dx, inInclusiveRange(-0.2, 1.2),
              reason: '$id stage $stage dx out of range');
          expect(anchor.dy, inInclusiveRange(-0.3, 1.2),
              reason: '$id stage $stage dy out of range');
          expect(anchor.scale, inInclusiveRange(0.1, 0.6),
              reason: '$id stage $stage scale out of range');
        }
      }
    });

    test('wing decorations are marked as behind', () {
      for (int stage = 1; stage <= 5; stage++) {
        final anchor = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: 'acc_wing_decorations',
          evolutionStage: stage,
          isColorVariant: false,
        )!;
        expect(anchor.behind, isTrue,
            reason: 'Wing decorations should render behind dragon');
      }
    });

    test('non-wing accessories are not marked as behind', () {
      const frontIds = [
        'acc_crown',
        'acc_wizard_hat',
        'acc_scarf',
        'acc_necklace',
        'acc_battle_armor',
      ];
      for (final id in frontIds) {
        final anchor = DragonAnchorPoints.getAccessoryAnchor(
          accessoryId: id,
          evolutionStage: 1,
          isColorVariant: false,
        )!;
        expect(anchor.behind, isFalse,
            reason: '$id should render in front of dragon');
      }
    });

    test('stage is clamped to 1-5 range', () {
      // Stage 99 should clamp to 5
      final anchor = DragonAnchorPoints.getAccessoryAnchor(
        accessoryId: 'acc_crown',
        evolutionStage: 99,
        isColorVariant: false,
      );
      final stage5 = DragonAnchorPoints.getAccessoryAnchor(
        accessoryId: 'acc_crown',
        evolutionStage: 5,
        isColorVariant: false,
      );
      expect(anchor?.dx, stage5?.dx);
      expect(anchor?.dy, stage5?.dy);
      expect(anchor?.scale, stage5?.scale);
    });
  });
}
