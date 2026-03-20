import 'dart:ui';

/// Tracks the dragon's flame intensity (0.0 - 1.0).
/// Replaces the original game's lives system.
class FlameIntensity {
  double _value = 1.0;

  double get value => _value;
  int get percent => (_value * 100).round();
  bool get isAlive => _value > 0;

  /// Penalty for wrong answer or wall hit: -20%.
  void onWrongAnswer() {
    _value = ((_value - 0.20).clamp(0.0, 1.0) * 100).roundToDouble() / 100;
  }

  /// Reward for correct answer: +10% (capped at 100%).
  void onCorrectAnswer() {
    _value = ((_value + 0.10).clamp(0.0, 1.0) * 100).roundToDouble() / 100;
  }

  /// Reset to full.
  void reset() {
    _value = 1.0;
  }

  /// Get the visual flame color based on current intensity.
  Color get flameColor {
    if (_value > 0.7) return const Color(0xFFE74C3C); // bright red-orange
    if (_value > 0.4) return const Color(0xFFF4A261); // gold-orange
    if (_value > 0.2) return const Color(0xFFE76F51); // fire orange (warning)
    return const Color(0xFF8B2500); // dark ember (danger)
  }

  /// Static helper for widgets that only have the value.
  static Color colorForValue(double intensity) {
    if (intensity > 0.7) return const Color(0xFFE74C3C);
    if (intensity > 0.4) return const Color(0xFFF4A261);
    if (intensity > 0.2) return const Color(0xFFE76F51);
    return const Color(0xFF8B2500);
  }
}
