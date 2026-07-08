import 'package:flutter/material.dart';

/// A soft, code-drawn glow rendered behind the dragon for aura
/// [CosmeticType.effect] cosmetics.
///
/// The aura is a non-occluding cosmetic: it sits wholly behind the dragon and
/// never intersects the silhouette, so it needs no per-stage/per-skin art and
/// sidesteps the perspective/occlusion problem of worn accessories on the 3/4
/// painterly dragon art. See `docs/step12/ACCESSORY_PIPELINE_DECISION.md`.
class DragonAura extends StatelessWidget {
  /// Tint of the glow.
  final Color color;

  /// Box size the aura is painted within (typically the dragon preview size).
  final double size;

  const DragonAura({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _AuraPainter(color)),
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  final Color color;

  _AuraPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Halo: transparent core (covered by the dragon), a bright ring around the
    // silhouette, fading to transparent at the edge. Additive blend for glow.
    final gradient = RadialGradient(
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.38),
        color.withValues(alpha: 0.0),
      ],
      stops: const [0.34, 0.62, 1.0],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.plus;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter oldDelegate) =>
      oldDelegate.color != color;
}
