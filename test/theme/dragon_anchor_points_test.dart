import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/theme/dragon_anchor_points.dart';
import 'package:math_dragons/theme/dragon_rig.dart';

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
    AccessoryAnchor? anchor(
      String accessoryId,
      int stage, {
      DragonRenderContext context = DragonRenderContext.hub,
      String poseId = DragonRig.defaultHubPoseId,
    }) {
      return DragonAnchorPoints.getAccessoryAnchor(
        accessoryId: accessoryId,
        evolutionStage: stage,
        context: context,
        poseId: poseId,
      );
    }

    test('getAccessoryAnchor returns null for stage 0 (egg)', () {
      for (final id in allAccessoryIds) {
        expect(
          anchor(id, 0),
          isNull,
          reason: '$id should not have an anchor on egg stage',
        );
      }
    });

    test(
      'getAccessoryAnchor returns non-null for all 6 accessories x stages 1-5',
      () {
        for (final id in allAccessoryIds) {
          for (int stage = 1; stage <= 5; stage++) {
            expect(
              anchor(id, stage),
              isNotNull,
              reason: '$id should have an anchor for stage $stage',
            );
          }
        }
      },
    );

    test('getAccessoryAnchor returns null for unknown accessory ID', () {
      expect(anchor('acc_nonexistent', 1), isNull);
    });

    test('crown and wizard hat return different anchors for same stage', () {
      for (int stage = 1; stage <= 5; stage++) {
        final crown = anchor('acc_crown', stage)!;
        final hat = anchor('acc_wizard_hat', stage)!;

        // Wizard hat should sit higher (lower dy) than crown
        expect(
          hat.dy,
          lessThan(crown.dy),
          reason: 'Wizard hat should be higher than crown at stage $stage',
        );
        // Wizard hat should be larger
        expect(
          hat.scale,
          greaterThan(crown.scale),
          reason: 'Wizard hat should be larger than crown at stage $stage',
        );
      }
    });

    test('scarf and necklace return different anchors for same stage', () {
      for (int stage = 1; stage <= 5; stage++) {
        final scarf = anchor('acc_scarf', stage)!;
        final necklace = anchor('acc_necklace', stage)!;

        // Necklace pendant hangs lower than scarf
        expect(
          necklace.dy,
          greaterThan(scarf.dy),
          reason: 'Necklace should hang lower than scarf at stage $stage',
        );
      }
    });

    test('pose-specific lookup falls back to legacy anchors', () {
      final unknownPose = anchor('acc_crown', 3, poseId: 'unknown_pose');
      final defaultPose = anchor('acc_crown', 3);

      expect(unknownPose, isNotNull);
      expect(unknownPose?.dx, defaultPose?.dx);
      expect(unknownPose?.dy, defaultPose?.dy);
    });

    test('all anchor values are in valid ranges', () {
      for (final id in allAccessoryIds) {
        for (int stage = 1; stage <= 5; stage++) {
          final anchor = DragonAnchorPoints.getAccessoryAnchor(
            accessoryId: id,
            evolutionStage: stage,
            context: DragonRenderContext.hub,
            poseId: DragonRig.defaultHubPoseId,
          )!;
          expect(
            anchor.dx,
            inInclusiveRange(-0.2, 1.2),
            reason: '$id stage $stage dx out of range',
          );
          expect(
            anchor.dy,
            inInclusiveRange(-0.3, 1.2),
            reason: '$id stage $stage dy out of range',
          );
          expect(
            anchor.scale,
            inInclusiveRange(0.1, 0.6),
            reason: '$id stage $stage scale out of range',
          );
        }
      }
    });

    test('wing decorations are marked as behind', () {
      for (int stage = 1; stage <= 5; stage++) {
        final wingAnchor = anchor('acc_wing_decorations', stage)!;
        expect(
          wingAnchor.behind,
          isTrue,
          reason: 'Wing decorations should render behind dragon',
        );
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
        final frontAnchor = anchor(id, 1)!;
        expect(
          frontAnchor.behind,
          isFalse,
          reason: '$id should render in front of dragon',
        );
      }
    });

    test('stage is clamped to 1-5 range', () {
      // Stage 99 should clamp to 5
      final stage99 = anchor('acc_crown', 99);
      final stage5 = anchor('acc_crown', 5);
      expect(stage99?.dx, stage5?.dx);
      expect(stage99?.dy, stage5?.dy);
      expect(stage99?.scale, stage5?.scale);
    });
  });
}
