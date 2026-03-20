import 'package:flutter/material.dart';

/// Shows the current drag chain as token chips.
class ChainDisplay extends StatelessWidget {
  final List<String> chainTokens;

  const ChainDisplay({super.key, required this.chainTokens});

  @override
  Widget build(BuildContext context) {
    if (chainTokens.isEmpty) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'Drag across runes to cast a spell',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: Color(0xFFA89DB8),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: chainTokens.map((token) {
          final isOp = !RegExp(r'^\d+$').hasMatch(token);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0F3D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF66E3FF).withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              token,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isOp
                    ? const Color(0xFFF4A261) // gold for operators
                    : const Color(0xFFF0E6D3), // white for numbers
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
