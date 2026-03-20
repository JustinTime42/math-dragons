import 'package:flutter/material.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';

/// Animated scales counter that ticks up when scales are earned.
///
/// Shows the current value, then animates to the new value when it increases.
/// Displays a floating "+X" text that fades upward.
class AnimatedScalesCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;

  const AnimatedScalesCounter({
    super.key,
    required this.value,
    this.style,
  });

  @override
  State<AnimatedScalesCounter> createState() => _AnimatedScalesCounterState();
}

class _AnimatedScalesCounterState extends State<AnimatedScalesCounter>
    with SingleTickerProviderStateMixin {
  late int _displayValue;
  int? _delta;
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0, end: -40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _delta = null);
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedScalesCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final delta = widget.value - oldWidget.value;
      if (delta > 0) {
        setState(() {
          _delta = delta;
          _displayValue = widget.value;
        });
        _controller.forward();
      } else {
        setState(() => _displayValue = widget.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: DragonColors.dragonGold,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
            );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(DragonAssets.iconScale, width: 18, height: 18),
            const SizedBox(width: 4),
            Text(_formatNumber(_displayValue), style: style),
          ],
        ),
        if (_delta != null)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _floatAnimation.value,
                right: 0,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    '+$_delta',
                    style: style?.copyWith(
                      fontSize: 14,
                      color: DragonColors.dragonGold,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return n.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
