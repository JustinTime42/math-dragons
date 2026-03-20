import 'package:flutter/material.dart';

import '../../fire_trail/models/grid_position.dart';

/// D-pad controls for Dragon's Feast. Matches Fire Trail pattern.
class FeastDPadControls extends StatelessWidget {
  final void Function(Direction) onDirection;
  final VoidCallback? onMunch;

  static const double _buttonSize = 64.0;
  static const double _gap = 8.0;

  const FeastDPadControls({super.key, required this.onDirection, this.onMunch});

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
          // Munch (center)
          Positioned(
            left: _buttonSize + _gap,
            top: _buttonSize + _gap,
            child: _MunchButton(
              onPressed: onMunch ?? () {},
              size: _buttonSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _DPadButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _DPadButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2F61), Color(0xFF1C2147)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withAlpha(31),
          ),
        ),
        child: Icon(icon, color: const Color(0xFFE8ECFF), size: 32),
      ),
    );
  }
}

class _MunchButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const _MunchButton({required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF6B35), Color(0xFFCC4400)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withAlpha(51),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withAlpha(80),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'MUNCH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
