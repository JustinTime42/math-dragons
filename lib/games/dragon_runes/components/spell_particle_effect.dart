import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class _SpellParticle {
  double x, y, vx, vy;
  double life;
  double t = 0;
  Color color;

  _SpellParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
  });
}

/// Spell-casting particle burst on correct equations.
class SpellParticleEffect extends PositionComponent {
  final List<Vector2> nodePositions;
  final int particleCount;
  final List<_SpellParticle> _particles = [];
  final Random _random = Random();

  SpellParticleEffect({
    required this.nodePositions,
    this.particleCount = 8,
  });

  @override
  Future<void> onLoad() async {
    for (final pos in nodePositions) {
      for (int i = 0; i < particleCount; i++) {
        final angle = _random.nextDouble() * 2 * pi;
        final speed = 60 + _random.nextDouble() * 180;
        final isGold = _random.nextDouble() < 0.4;
        _particles.add(_SpellParticle(
          x: pos.x,
          y: pos.y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          life: 0.5 + _random.nextDouble() * 0.4,
          color: isGold
              ? const Color(0xFFF4A261) // gold
              : const Color(0xFFBB8FCE), // purple
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 40 * dt; // slight gravity
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
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }
}
