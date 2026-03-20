import 'dart:math';
import '../components/egg_component.dart';
import '../models/egg_data.dart';

class EggPhysicsConstants {
  static const double gravity = 550.0;
  static const double restitution = 0.2;
  static const double damping = 0.4;
  static const double friction = 0.93;
  static const double settleVelocity = 10.0;
  static const double maxVelocity = 350.0;
  static const int collisionPasses = 4;
  static const double wakeOverlap = 3.0;
  static const double penetrationSlop = 0.5;
  static const double correctionFactor = 0.6;
  static const double settleFrames = 3;
}

class EggPhysics {
  final double fieldWidth;
  final double fieldHeight;
  final Map<int, int> _settleCounters = {};

  EggPhysics({required this.fieldWidth, required this.fieldHeight});

  void update(List<EggComponent> eggs, double dt, double gravityMultiplier) {
    for (final egg in eggs) {
      if (egg.state == EggState.selected ||
          egg.state == EggState.popping ||
          egg.state == EggState.dead) {
        continue;
      }
      if (egg.settled) continue;

      egg.vy += EggPhysicsConstants.gravity * gravityMultiplier * dt;

      final speed = sqrt(egg.vx * egg.vx + egg.vy * egg.vy);
      if (speed > EggPhysicsConstants.maxVelocity) {
        final scale = EggPhysicsConstants.maxVelocity / speed;
        egg.vx *= scale;
        egg.vy *= scale;
      }

      egg.position.x += egg.vx * dt;
      egg.position.y += egg.vy * dt;

      final frictionFactor = pow(EggPhysicsConstants.friction, dt * 60);
      egg.vx *= frictionFactor;
      egg.vy *= frictionFactor;
    }

    for (int pass = 0; pass < EggPhysicsConstants.collisionPasses; pass++) {
      _resolveCollisions(eggs, pass);
    }

    _checkSettling(eggs);
  }

  bool _isSupportedBySettled(EggComponent egg, List<EggComponent> eggs) {
    for (final other in eggs) {
      if (other == egg) continue;
      if (other.state != EggState.active) continue;
      if (!other.settled) continue;
      if (other.position.y <= egg.position.y) continue;

      final dx = other.position.x - egg.position.x;
      final dy = other.position.y - egg.position.y;
      final dist = sqrt(dx * dx + dy * dy);
      final minDist = egg.radius + other.radius;

      if (dist < minDist + 2.0) {
        return true;
      }
    }
    return false;
  }

  void _checkSettling(List<EggComponent> eggs) {
    for (final egg in eggs) {
      if (egg.state != EggState.active || egg.settled) continue;

      final onFloor = (egg.position.y + egg.radius >= fieldHeight - 1);
      final onSettled = _isSupportedBySettled(egg, eggs);
      final supported = onFloor || onSettled;
      final lowVel = (egg.vy.abs() < EggPhysicsConstants.settleVelocity &&
          egg.vx.abs() < EggPhysicsConstants.settleVelocity);

      if (supported && lowVel) {
        final id = egg.hashCode;
        _settleCounters[id] = (_settleCounters[id] ?? 0) + 1;
        if (_settleCounters[id]! >= EggPhysicsConstants.settleFrames) {
          egg.settled = true;
          egg.vx = 0;
          egg.vy = 0;
          if (onFloor) {
            egg.position.y = fieldHeight - egg.radius;
          }
          _settleCounters.remove(id);
        }
      } else {
        _settleCounters.remove(egg.hashCode);
      }
    }
  }

  void _resolveCollisions(List<EggComponent> eggs, int pass) {
    final activeEggs = eggs
        .where((e) => e.state == EggState.active || e.state == EggState.selected)
        .toList();

    for (final egg in activeEggs) {
      if (egg.position.y + egg.radius > fieldHeight) {
        egg.position.y = fieldHeight - egg.radius;
        if (pass == 0 && egg.state != EggState.selected) {
          if (egg.vy.abs() > EggPhysicsConstants.settleVelocity) {
            egg.vy = -egg.vy * EggPhysicsConstants.restitution;
          } else {
            egg.vy = 0;
          }
        }
      }

      if (egg.position.x - egg.radius < 0) {
        egg.position.x = egg.radius;
        if (pass == 0 && egg.state != EggState.selected) {
          egg.vx = egg.vx.abs() * EggPhysicsConstants.restitution;
        }
      }

      if (egg.position.x + egg.radius > fieldWidth) {
        egg.position.x = fieldWidth - egg.radius;
        if (pass == 0 && egg.state != EggState.selected) {
          egg.vx = -egg.vx.abs() * EggPhysicsConstants.restitution;
        }
      }
    }

    for (int i = 0; i < activeEggs.length; i++) {
      for (int j = i + 1; j < activeEggs.length; j++) {
        final a = activeEggs[i];
        final b = activeEggs[j];

        final dx = b.position.x - a.position.x;
        final dy = b.position.y - a.position.y;
        final dist = sqrt(dx * dx + dy * dy);
        final minDist = a.radius + b.radius;
        final overlap = minDist - dist;

        if (overlap > EggPhysicsConstants.penetrationSlop && dist > 0.001) {
          final nx = dx / dist;
          final ny = dy / dist;

          final aSelected = a.state == EggState.selected;
          final bSelected = b.state == EggState.selected;

          final correctable = (overlap - EggPhysicsConstants.penetrationSlop) *
              EggPhysicsConstants.correctionFactor;

          if (aSelected && !bSelected) {
            b.position.x += nx * correctable;
            b.position.y += ny * correctable;
          } else if (!aSelected && bSelected) {
            a.position.x -= nx * correctable;
            a.position.y -= ny * correctable;
          } else if (!aSelected && !bSelected) {
            final half = correctable / 2;
            a.position.x -= nx * half;
            a.position.y -= ny * half;
            b.position.x += nx * half;
            b.position.y += ny * half;
          }

          if (pass == 0) {
            final relVelX = a.vx - b.vx;
            final relVelY = a.vy - b.vy;
            final relVelDotN = relVelX * nx + relVelY * ny;

            if (relVelDotN > 0) {
              final impulse = relVelDotN * EggPhysicsConstants.damping;
              if (!aSelected) {
                a.vx -= impulse * nx;
                a.vy -= impulse * ny;
              }
              if (!bSelected) {
                b.vx += impulse * nx;
                b.vy += impulse * ny;
              }
            }
          }

          if (overlap > EggPhysicsConstants.wakeOverlap) {
            if (a.settled) {
              a.settled = false;
              _settleCounters.remove(a.hashCode);
            }
            if (b.settled) {
              b.settled = false;
              _settleCounters.remove(b.hashCode);
            }
          }
        }
      }
    }
  }
}
