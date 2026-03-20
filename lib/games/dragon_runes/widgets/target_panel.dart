import 'package:flutter/material.dart';
import '../../../theme/dragon_colors.dart';

/// Displays found equations only — unfound targets are hidden.
/// Required and bonus equations are styled differently.
class TargetPanel extends StatelessWidget {
  final int totalTargets;
  final List<String> foundTargets;
  final List<String> foundBonuses;
  const TargetPanel({
    super.key,
    required this.totalTargets,
    required this.foundTargets,
    required this.foundBonuses,
  });

  @override
  Widget build(BuildContext context) {
    final hasAny = foundTargets.isNotEmpty || foundBonuses.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.runesAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress header
          Row(
            children: [
              Text(
                '${foundTargets.length} / $totalTargets',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A9D8F),
                ),
              ),
              if (foundBonuses.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '+${foundBonuses.length} bonus',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DragonColors.dragonGold,
                  ),
                ),
              ],
            ],
          ),
          if (hasAny) ...[
            const SizedBox(height: 6),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ...foundTargets.map((text) => _FoundChip(
                          text: text,
                          isBonus: false,
                        )),
                    ...foundBonuses.map((text) => _FoundChip(
                          text: text,
                          isBonus: true,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

}

class _FoundChip extends StatelessWidget {
  final String text;
  final bool isBonus;

  const _FoundChip({
    required this.text,
    required this.isBonus,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isBonus ? DragonColors.dragonGold : const Color(0xFF2A9D8F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              isBonus ? Icons.auto_awesome : Icons.check_circle,
              color: color,
              size: 14,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
