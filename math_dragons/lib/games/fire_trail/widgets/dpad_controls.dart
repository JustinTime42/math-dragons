import 'package:flutter/material.dart';

import '../models/grid_position.dart';

/// Touch D-pad controls for Fire Trail.
class DPadControls extends StatelessWidget {
  final void Function(Direction) onDirection;

  static const double _buttonSize = 64.0;
  static const double _gap = 8.0;

  const DPadControls({super.key, required this.onDirection});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonSize * 3 + _gap * 2,
      height: _buttonSize * 3 + _gap * 2,
      child: Stack(
        children: [
          // Up
          Positioned(
            left: _buttonSize + _gap,
            top: 0,
            child: _DPadButton(
              icon: Icons.arrow_drop_up,
              onPressed: () => onDirection(Direction.up),
              size: _buttonSize,
            ),
          ),
          // Down
          Positioned(
            left: _buttonSize + _gap,
            bottom: 0,
            child: _DPadButton(
              icon: Icons.arrow_drop_down,
              onPressed: () => onDirection(Direction.down),
              size: _buttonSize,
            ),
          ),
          // Left
          Positioned(
            left: 0,
            top: _buttonSize + _gap,
            child: _DPadButton(
              icon: Icons.arrow_left,
              onPressed: () => onDirection(Direction.left),
              size: _buttonSize,
            ),
          ),
          // Right
          Positioned(
            right: 0,
            top: _buttonSize + _gap,
            child: _DPadButton(
              icon: Icons.arrow_right,
              onPressed: () => onDirection(Direction.right),
              size: _buttonSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _DPadButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _DPadButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  State<_DPadButton> createState() => _DPadButtonState();
}

class _DPadButtonState extends State<_DPadButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onPressed();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _pressed
                ? const [Color(0xFF3A3F81), Color(0xFF2C3167)]
                : const [Color(0xFF2A2F61), Color(0xFF1C2147)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed
                ? const Color(0xFFF4A261).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.12),
            width: _pressed ? 1.5 : 1.0,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: const Color(0xFFF4A261).withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          widget.icon,
          color: _pressed
              ? const Color(0xFFF4A261)
              : const Color(0xFFE8ECFF),
          size: 32,
        ),
      ),
    );
  }
}
