import 'package:flutter/material.dart';

/// All color constants for the Math Dragons app.
/// See VISUAL_DESIGN_GUIDE.md for full documentation.
class DragonColors {
  DragonColors._();

  // ──── Primary Palette ────
  static const dragonPurple = Color(0xFF2D1B69);
  static const amethyst = Color(0xFF4A2D8F);
  static const deepVoid = Color(0xFF1A0F3D);
  static const dragonGold = Color(0xFFF4A261);
  static const warmGlow = Color(0xFFF7C08A);
  static const agedGold = Color(0xFFD4843A);
  static const emeraldFlame = Color(0xFF2A9D8F);
  static const fireOrange = Color(0xFFE76F51);
  static const midnightBlue = Color(0xFF1A1A2E);
  static const nightSurface = Color(0xFF16213E);
  static const twilight = Color(0xFF1F2F50);

  // ──── Semantic Colors ────
  static const correct = emeraldFlame;
  static const incorrect = fireOrange;
  static const warning = dragonGold;
  static const info = Color(0xFF5B8DEF);
  static const disabled = Color(0xFF4A4A6A);
  static const textPrimary = Color(0xFFF0E6D3);
  static const textSecondary = Color(0xFFA89DB8);
  static const textOnGold = deepVoid;
  static const divider = Color(0xFF2A2A4A);

  // ──── Game Accent Colors ────
  static const runesAccent = Color(0xFF9B59B6);
  static const runesAccentLight = Color(0xFFBB8FCE);
  static const runesAccentDark = Color(0xFF6C3483);

  static const fireTrailAccent = Color(0xFFE74C3C);
  static const fireTrailAccentLight = Color(0xFFF1948A);
  static const fireTrailAccentDark = Color(0xFFC0392B);

  static const dragonEggsAccent = Color(0xFF3498DB);
  static const dragonEggsAccentLight = Color(0xFF85C1E9);
  static const dragonEggsAccentDark = Color(0xFF2471A3);

  static const dragonsFeastAccent = Color(0xFF27AE60);
  static const dragonsFeastAccentLight = Color(0xFF82E0AA);
  static const dragonsFeastAccentDark = Color(0xFF1E8449);

  // ──── Dragon Eggs: Egg Colors ────
  static const eggCream = Color(0xFFF5E6CA);
  static const eggBlue = Color(0xFFAED6F1);
  static const eggGreen = Color(0xFFA9DFBF);
  static const eggOrange = Color(0xFFF5CBA7);
  static const eggDivision = Color(0xFF8E44AD);
  static const eggOperator = Color(0xFFF4D03F);

  // ──── Gradients ────
  static const lairGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepVoid, dragonPurple, nightSurface],
  );

  static const goldShimmer = LinearGradient(
    colors: [agedGold, dragonGold, warmGlow],
  );

  static const fireGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [fireOrange, dragonGold, Color(0xFFFFF3B0)],
  );

  static const nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0D1A), midnightBlue, nightSurface],
  );

  // ──── Opacity Helpers ────
  static Color overlayHeavy(Color c) => c.withValues(alpha: 0.8);
  static Color overlayMedium(Color c) => c.withValues(alpha: 0.6);
  static Color overlayLight(Color c) => c.withValues(alpha: 0.3);
  static Color disabledOpacity(Color c) => c.withValues(alpha: 0.4);
}
