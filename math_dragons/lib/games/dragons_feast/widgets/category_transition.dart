import 'package:flutter/material.dart';

/// Category announcement overlay between levels.
class CategoryTransition extends StatefulWidget {
  final String categoryName;
  final VoidCallback onComplete;

  const CategoryTransition({
    super.key,
    required this.categoryName,
    required this.onComplete,
  });

  @override
  State<CategoryTransition> createState() => _CategoryTransitionState();
}

class _CategoryTransitionState extends State<CategoryTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final opacity = _controller.value < 0.7
            ? 1.0
            : 1.0 - (_controller.value - 0.7) / 0.3;

        return Container(
          color: const Color(0xFF0A174E).withAlpha(200),
          child: Center(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Text(
                widget.categoryName,
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF0E6D3),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
