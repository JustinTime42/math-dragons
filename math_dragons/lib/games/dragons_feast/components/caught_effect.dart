import 'dart:ui';

import 'package:flame/components.dart';

/// Expanding ring effect when the player is caught by an enemy.
class CaughtEffect extends PositionComponent {
  double elapsed = 0;
  static const double duration = 0.9;

  CaughtEffect() : super(priority: 20);

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;
    if (elapsed >= duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = elapsed / duration;
    final radius = 20.0 + progress * 40.0;
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Color.fromRGBO(231, 76, 60, alpha * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }
}
