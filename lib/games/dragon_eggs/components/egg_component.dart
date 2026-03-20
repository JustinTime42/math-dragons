import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../models/egg_data.dart';
import '../../../theme/dragon_colors.dart';

/// An individual egg in the Dragon Eggs game.
class EggComponent extends PositionComponent with TapCallbacks {
  final EggType type;
  final dynamic value; // int for numbers, MathOp for operators
  final double radius;
  final Color baseColor;

  double vx;
  double vy;
  EggState state = EggState.active;
  bool settled = false;
  bool hasEnteredField = false;
  int? selectionIndex;

  /// Callback when this egg is tapped.
  void Function(EggComponent)? onTapped;

  /// Animation progress for popping (0.0 to 1.0).
  double _popProgress = 0;

  EggComponent({
    required this.type,
    required this.value,
    required Vector2 eggPosition,
    required this.radius,
    required this.baseColor,
    double initialVx = 0,
    double initialVy = 0,
  })  : vx = initialVx,
        vy = initialVy,
        super(
          position: eggPosition,
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    // Sync Flame position with our physics position
    size = Vector2.all(radius * 2);

    if (state == EggState.popping) {
      _popProgress += dt / 0.4; // 400ms total
      if (_popProgress >= 1.0) {
        state = EggState.dead;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (state == EggState.dead) return;

    final center = Offset(radius, radius);
    double scale = 1.0;

    if (state == EggState.popping) {
      // Scale up to 1.4x then shrink to 0
      if (_popProgress < 0.4) {
        scale = 1.0 + (_popProgress / 0.4) * 0.4;
      } else {
        scale = 1.4 * (1.0 - ((_popProgress - 0.4) / 0.6));
      }
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(scale);
      canvas.translate(-center.dx, -center.dy);
    }

    // Draw egg body (circle with gradient)
    final gradient = RadialGradient(
      colors: [
        baseColor.withValues(alpha: 0.9),
        baseColor.withValues(alpha: 0.6),
      ],
      stops: const [0.3, 1.0],
    );
    final bodyPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawCircle(center, radius, bodyPaint);

    // Draw highlight/shine
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawOval(
      Rect.fromLTWH(
        center.dx - radius * 0.3,
        center.dy - radius * 0.5,
        radius * 0.5,
        radius * 0.3,
      ),
      shinePaint,
    );

    // Draw border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = state == EggState.selected ? 3 : 1
      ..color = state == EggState.selected
          ? DragonColors.dragonGold
          : baseColor.withValues(alpha: 0.4);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw value text (only if not paused - handled by the game)
    if (state != EggState.popping) {
      _drawText(canvas, center);
    }

    if (state == EggState.popping) {
      canvas.restore();
    }
  }

  void _drawText(Canvas canvas, Offset center) {
    final text = type == EggType.number
        ? '$value'
        : (value as MathOp).symbol;

    final fontSize = _fontSizeForText(text);
    final textStyle = TextStyle(
      fontFamily: 'Nunito',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: _textColor(),
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  double _fontSizeForText(String text) {
    final diameter = radius * 2;
    if (type == EggType.operator) return diameter * 0.5;
    if (text.length == 1) return diameter * 0.42;
    if (text.length == 2) return diameter * 0.36;
    return diameter * 0.28;
  }

  Color _textColor() {
    // Dark text on light eggs, light text on dark eggs
    final brightness = baseColor.computeLuminance();
    return brightness > 0.5 ? DragonColors.deepVoid : DragonColors.textPrimary;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (state != EggState.active && state != EggState.selected) return false;
    onTapped?.call(this);
    return true;
  }

  /// Start the pop animation.
  void startPop() {
    state = EggState.popping;
    _popProgress = 0;
  }
}
