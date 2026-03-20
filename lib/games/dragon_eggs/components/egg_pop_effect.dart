import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Pop/sparkle particle effect when eggs are "hatched."
class EggPopEffect extends PositionComponent {
  final Color color;
  final List<_Particle> _particles = [];
  double _elapsed = 0;
  static const double _duration = 0.6;

  EggPopEffect({required Vector2 effectPosition, required this.color})
      : super(position: effectPosition) {
    final random = Random();
    final particleCount = 8 + random.nextInt(6); // 8-13 particles

    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi * i) / particleCount + random.nextDouble() * 0.3;
      final speed = 80 + random.nextDouble() * 120;
      _particles.add(_Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        radius: 2 + random.nextDouble() * 3,
        color: i % 2 == 0 ? DragonColors.dragonGold : DragonColors.warmGlow,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) {
      removeFromParent();
      return;
    }

    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 200 * dt; // gravity on particles
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = 1.0 - (_elapsed / _duration);
    for (final p in _particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(p.x, p.y), p.radius * opacity, paint);
    }
  }
}

class _Particle {
  double x = 0;
  double y = 0;
  final double vx;
  double vy;
  final double radius;
  final Color color;

  _Particle({
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
  });
}
