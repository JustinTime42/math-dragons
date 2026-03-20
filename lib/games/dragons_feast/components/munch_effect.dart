import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

class _MunchParticle {
  double x = 0, y = 0;
  final double vx;
  double vy;
  final double life;
  final Color color;
  double t = 0;

  _MunchParticle({
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
  });
}

/// Particle burst effect on eating a tile.
class MunchEffect extends PositionComponent {
  static const int particleCount = 15;

  final bool isCorrect;
  final List<_MunchParticle> _particles = [];
  final Random _random = Random();

  MunchEffect({required this.isCorrect}) : super(priority: 20);

  @override
  Future<void> onLoad() async {
    final color = isCorrect
        ? const Color(0xFF27AE60) // treasure green
        : const Color(0xFFE74C3C); // red

    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 40 + _random.nextDouble() * 100;
      final particleAlpha = 0.5 + _random.nextDouble() * 0.5;
      _particles.add(_MunchParticle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        life: 0.3 + _random.nextDouble() * 0.3,
        color: color.withAlpha((particleAlpha * 255).round()),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 30 * dt; // slight gravity
      p.t += dt;
    }
    _particles.removeWhere((p) => p.t >= p.life);
    if (_particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final alpha = (1.0 - p.t / p.life).clamp(0.0, 1.0);
      final size = 3.0 * (1.0 - p.t / p.life * 0.5);
      canvas.drawCircle(
        Offset(p.x, p.y),
        size,
        Paint()..color = p.color.withAlpha((alpha * 255).round()),
      );
    }
  }
}
