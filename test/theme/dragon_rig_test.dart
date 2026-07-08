import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/theme/dragon_anchor_points.dart';
import 'package:math_dragons/theme/dragon_assets.dart';
import 'package:math_dragons/theme/dragon_rig.dart';

void main() {
  group('DragonRig', () {
    test(
      'resolves existing portrait and hub anchors through render context',
      () {
        final portrait = DragonRig.getAccessoryAnchor(
          accessoryId: 'acc_crown',
          evolutionStage: 3,
          context: DragonRenderContext.portrait,
        );
        final hub = DragonRig.getAccessoryAnchor(
          accessoryId: 'acc_crown',
          evolutionStage: 3,
          context: DragonRenderContext.hub,
        );

        expect(portrait, isNotNull);
        expect(hub, isNotNull);
        expect(portrait?.dx, hub?.dx);
        expect(portrait?.dy, hub?.dy);
      },
    );

    test('maps skins to pose ids for lookup', () {
      final crimsonAnchor = DragonRig.getAccessoryAnchor(
        accessoryId: 'acc_crown',
        evolutionStage: 3,
        context: DragonRenderContext.hub,
        skinId: 'color_crimson',
      );
      final defaultAnchor = DragonRig.getAccessoryAnchor(
        accessoryId: 'acc_crown',
        evolutionStage: 3,
        context: DragonRenderContext.hub,
        skinId: DragonRig.defaultSkinId,
      );

      expect(crimsonAnchor, isNotNull);
      expect(crimsonAnchor?.dx, defaultAnchor?.dx);
      expect(
        DragonRig.poseIdFor(
          context: DragonRenderContext.hub,
          skinId: 'color_crimson',
        ),
        DragonRig.defaultHubPoseId,
      );
    });

    test('formats context and pose snippets for calibration output', () {
      const anchor = AccessoryAnchor(dx: 0.4, dy: 0.2, scale: 0.3);

      final snippet = DragonRig.formatStageEntry(
        accessoryId: 'acc_crown',
        evolutionStage: 3,
        context: DragonRenderContext.hub,
        poseId: DragonRig.defaultHubPoseId,
        anchor: anchor,
      );

      expect(snippet, contains('DragonRenderContext.hub'));
      expect(snippet, contains("'${DragonRig.defaultHubPoseId}': {"));
      expect(snippet, contains('3: AccessoryAnchor'));
    });

    test('formats snippets for calibration output', () {
      const anchor = AccessoryAnchor(
        dx: 0.3333,
        dy: 0.0444,
        scale: 0.2444,
        behind: true,
        rotation: 0.1234,
      );

      expect(
        DragonRig.formatAnchorSnippet(anchor),
        'AccessoryAnchor(dx: 0.333, dy: 0.044, scale: 0.244, behind: true, rotation: 0.123)',
      );
    });

    test('resolves posed dragon image paths by context, stage, and skin', () {
      expect(
        DragonAssets.resolveDragonImage(
          evolutionStage: 3,
          context: DragonRenderContext.hub,
          skinId: 'color_crimson',
        ),
        'assets/images/dragons/posed/raw/dragons/hub/stage_3_young/dragon_hub_front_3q_left_stage3_color_crimson.png',
      );

      expect(
        DragonAssets.resolveDragonImage(
          evolutionStage: 99,
          context: DragonRenderContext.portrait,
        ),
        'assets/images/dragons/posed/raw/dragons/portrait/stage_5_elder/dragon_portrait_front_3q_left_stage5_default.png',
      );
    });

    test('resolves posed accessory image paths by context and stage', () {
      expect(
        DragonAssets.resolveAccessoryImage(
          accessoryId: 'acc_crown',
          evolutionStage: 3,
          context: DragonRenderContext.hub,
        ),
        'assets/images/dragons/posed/raw/accessories/hub/stage_3_young/acc_crown_hub_front_3q_left_stage3.png',
      );
    });

    test('crown resolves to the shared per-stage layer for every skin', () {
      // The Track A crown is skin-independent (skins preserve head geometry), so
      // the same per-stage layer composites over any skin. No skin suffix.
      expect(
        DragonAssets.resolveAccessoryImage(
          accessoryId: 'acc_crown',
          evolutionStage: 3,
          context: DragonRenderContext.hub,
          skinId: 'color_crimson',
        ),
        'assets/images/dragons/posed/raw/accessories/hub/stage_3_young/acc_crown_hub_front_3q_left_stage3.png',
      );

      expect(
        DragonAssets.resolveAccessoryImage(
          accessoryId: 'acc_scarf',
          evolutionStage: 3,
          context: DragonRenderContext.hub,
          skinId: 'color_crimson',
        ),
        'assets/images/dragons/posed/raw/accessories/hub/stage_3_young/acc_scarf_hub_front_3q_left_stage3.png',
      );
    });
  });
}
