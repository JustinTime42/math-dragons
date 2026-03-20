import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

/// Pulsing gold highlight on hinted nodes.
class HintHighlight extends PositionComponent {
  static const double duration = 2.0;
  double elapsed = 0;
  final double nodeRadius;

  HintHighlight({required this.nodeRadius}) : super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;
    if (elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final alpha = 0.3 + 0.3 * sin(elapsed * 10);
    final paint = Paint()
      ..color = Color.fromRGBO(255, 213, 74, alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, nodeRadius + 12, paint);
  }
}
