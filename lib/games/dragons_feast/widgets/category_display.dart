import 'package:flutter/material.dart';

import '../../../theme/dragon_colors.dart';

/// Displays the current math category prominently above the grid.
class CategoryDisplay extends StatelessWidget {
  final String categoryName;

  const CategoryDisplay({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: DragonColors.deepVoid.withAlpha(217),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DragonColors.dragonsFeastAccent.withAlpha(102),
          width: 1.5,
        ),
      ),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF0E6D3),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
