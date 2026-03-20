import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Big animated feedback text that pops in at the center of the screen.
/// Shows points scored and combo callouts.
class FeedbackOverlay extends StatefulWidget {
  final String? text;
  final bool isCorrect;
  final int combo;
  final bool isNewFact;

  /// Monotonically increasing counter so repeated identical text still triggers.
  final int feedbackKey;

  const FeedbackOverlay({
    super.key,
    required this.text,
    required this.isCorrect,
    this.combo = 0,
    this.isNewFact = false,
    this.feedbackKey = 0,
  });

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_controller);
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.15), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 65),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(FeedbackOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != null && widget.feedbackKey != oldWidget.feedbackKey) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text == null) return const SizedBox.shrink();

    final hasCombo = widget.isCorrect && widget.combo > 1;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          );
        },
        child: IgnorePointer(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "NEW!" badge for first-time facts
                if (widget.isCorrect && widget.isNewFact) ...[
                  Text(
                    'NEW FACT!',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DragonColors.amethyst,
                      shadows: [
                        Shadow(
                          color: DragonColors.amethyst.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                // Main points / result text
                Text(
                  widget.text!,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: hasCombo ? 44 : 38,
                    fontWeight: FontWeight.bold,
                    color: widget.isCorrect
                        ? DragonColors.emeraldFlame
                        : DragonColors.fireOrange,
                    shadows: [
                      Shadow(
                        color: (widget.isCorrect
                                ? DragonColors.emeraldFlame
                                : DragonColors.fireOrange)
                            .withValues(alpha: 0.6),
                        blurRadius: 20,
                      ),
                      Shadow(
                        color: (widget.isCorrect
                                ? DragonColors.emeraldFlame
                                : DragonColors.fireOrange)
                            .withValues(alpha: 0.3),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ),
                // Combo callout
                if (hasCombo) ...[
                  const SizedBox(height: 4),
                  Text(
                    'COMBO x${widget.combo}!',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: DragonColors.dragonGold,
                      shadows: [
                        Shadow(
                          color:
                              DragonColors.dragonGold.withValues(alpha: 0.6),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
