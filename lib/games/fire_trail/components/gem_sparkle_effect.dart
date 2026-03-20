import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class GemSparkleEffect extends PositionComponent {
  static const int particleCount = 28;
  static const List<Color> _sparkleColors = [
    Color(0xFFFFD54A),
    Color(0xFFF4A261),
    Color(0xFF2A9D8F),
    Color(0xFFFFF9C4),
    Color(0xFFE74C3C),
  ];

  final Random _random = Random();
  final List<_Particle> _particles = [];

  GemSparkleEffect({required Vector2 position})
      : super(position: position);

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 60 + _random.nextDouble() * 180;
      _particles.add(_Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        life: 0.35 + _random.nextDouble() * 0.4,
        color: _sparkleColors[_random.nextInt(_sparkleColors.length)],
        radius: 1.5 + _random.nextDouble() * 2.0,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.vy += 40 * dt;
      p.vx *= 0.99;
      p.t += dt;
    }
    _particles.removeWhere((p) => p.t >= p.life);
    if (_particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final progress = p.t / p.life;
      final alpha = (1.0 - progress * progress).clamp(0.0, 1.0);
      final currentRadius = p.radius * (1.0 - progress * 0.5);

      canvas.drawCircle(
        Offset(p.x, p.y),
        currentRadius,
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }
}

class _Particle {
  double x = 0;
  double y = 0;
  double vx;
  double vy;
  double life;
  double t = 0;
  Color color;
  double radius;

  _Particle({
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
    required this.radius,
  });
}
