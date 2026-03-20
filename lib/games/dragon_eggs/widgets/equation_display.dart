import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';
import '../../../theme/dragon_spacing.dart';
import '../systems/equation_builder.dart';

/// Flutter overlay showing the equation being built.
class EquationDisplay extends StatelessWidget {
  final String equationText;
  final EquationStep step;
  final VoidCallback onEquals;

  const EquationDisplay({
    super.key,
    required this.equationText,
    required this.step,
    required this.onEquals,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DragonSpacing.sm,
      left: DragonSpacing.base,
      right: DragonSpacing.base,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DragonSpacing.base,
            vertical: DragonSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: DragonColors.deepVoid.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                equationText,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: DragonColors.textPrimary,
                ),
              ),
              if (step == EquationStep.pressEquals) ...[
                const SizedBox(width: DragonSpacing.sm),
                _buildEqualsButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEqualsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEquals,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DragonSpacing.md,
            vertical: DragonSpacing.xs,
          ),
          decoration: BoxDecoration(
            gradient: DragonColors.goldShimmer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '=',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: DragonColors.deepVoid,
            ),
          ),
        ),
      ),
    );
  }
}
