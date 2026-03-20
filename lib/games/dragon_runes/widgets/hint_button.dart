import 'package:flutter/material.dart';

/// Hint button with remaining count.
class HintButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  const HintButton({
    super.key,
    required this.remaining,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canUse = remaining > 0;

    return GestureDetector(
      onTap: canUse ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: canUse ? const Color(0xFF2A2F61) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: canUse
                ? const Color(0xFFF4A261).withValues(alpha: 0.4)
                : const Color(0xFF4A4A6A),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 18,
              color:
                  canUse ? const Color(0xFFF4A261) : const Color(0xFF4A4A6A),
            ),
            const SizedBox(width: 4),
            Text(
              '$remaining',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: canUse
                    ? const Color(0xFFF4A261)
                    : const Color(0xFF4A4A6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
