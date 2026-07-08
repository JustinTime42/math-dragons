import 'dart:math' as math;

import 'dragon_anchor_points.dart';

/// Resolves accessory placement for the current dragon art pipeline.
class DragonRig {
  DragonRig._();

  static const defaultSkinId = 'default';
  static const defaultHubPoseId = 'hub_front_3q_left';
  static const defaultPortraitPoseId = 'portrait_front_3q_left';

  static const skinPoseIds = <DragonRenderContext, Map<String, String>>{};

  static AccessoryAnchor? getAccessoryAnchor({
    required String accessoryId,
    required int evolutionStage,
    required DragonRenderContext context,
    String? skinId,
    String? poseId,
  }) {
    return DragonAnchorPoints.getAccessoryAnchor(
      accessoryId: accessoryId,
      evolutionStage: evolutionStage,
      context: context,
      poseId: poseId ?? poseIdFor(context: context, skinId: skinId),
    );
  }

  static String poseIdFor({
    required DragonRenderContext context,
    String? skinId,
  }) {
    final resolvedSkinId = skinId ?? defaultSkinId;
    return skinPoseIds[context]?[resolvedSkinId] ?? defaultPoseIdFor(context);
  }

  static String defaultPoseIdFor(DragonRenderContext context) {
    switch (context) {
      case DragonRenderContext.hub:
        return defaultHubPoseId;
      case DragonRenderContext.portrait:
        return defaultPortraitPoseId;
    }
  }

  static String formatAnchorSnippet(AccessoryAnchor anchor) {
    final args = [
      'dx: ${_formatDouble(anchor.dx)}',
      'dy: ${_formatDouble(anchor.dy)}',
      'scale: ${_formatDouble(anchor.scale)}',
      if (anchor.behind) 'behind: true',
      if (anchor.rotationX != 0)
        'rotationX: ${_formatDouble(anchor.rotationX)}',
      if (anchor.rotationY != 0)
        'rotationY: ${_formatDouble(anchor.rotationY)}',
      if (anchor.rotation != 0) 'rotation: ${_formatDouble(anchor.rotation)}',
    ];
    return 'AccessoryAnchor(${args.join(', ')})';
  }

  static String formatStageEntry({
    required String accessoryId,
    required int evolutionStage,
    required DragonRenderContext context,
    required AccessoryAnchor anchor,
    required String poseId,
  }) {
    return [
      '// $accessoryId, ${context.label}, $poseId, stage $evolutionStage',
      '// Paste into DragonAnchorPoints.accessoryAnchorsByContext after visual review.',
      'DragonRenderContext.${context.name}: {',
      "  '$poseId': {",
      "    '$accessoryId': {",
      '      $evolutionStage: ${formatAnchorSnippet(anchor)},',
      '    },',
      '  },',
      '},',
    ].join('\n');
  }

  static double rotationDegrees(AccessoryAnchor anchor) =>
      anchor.rotation * 180 / math.pi;

  static double rotationXDegrees(AccessoryAnchor anchor) =>
      anchor.rotationX * 180 / math.pi;

  static double rotationYDegrees(AccessoryAnchor anchor) =>
      anchor.rotationY * 180 / math.pi;

  static double radiansFromDegrees(double degrees) => degrees * math.pi / 180;

  static String _formatDouble(double value) => value.toStringAsFixed(3);
}
