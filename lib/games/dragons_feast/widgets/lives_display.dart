import 'package:flutter/material.dart';

/// Displays lives as filled/empty hearts.
class LivesDisplay extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesDisplay({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            i < lives ? Icons.favorite : Icons.favorite_border,
            color: i < lives
                ? const Color(0xFFE74C3C)
                : const Color(0xFF4A4A6A),
            size: 20,
          ),
        );
      }),
    );
  }
}
