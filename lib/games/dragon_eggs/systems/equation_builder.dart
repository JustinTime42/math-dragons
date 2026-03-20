import '../models/egg_data.dart';
import '../components/egg_component.dart';

/// Steps in the equation building state machine.
enum EquationStep {
  selectLeft, // Step 0: tap a number (left operand)
  selectOperator, // Step 1: tap an operator
  selectRight, // Step 2: tap a number (right operand)
  pressEquals, // Step 3: press the = button
  selectAnswer, // Step 4: tap a number (answer) -> auto-evaluate
}

/// 5-step equation building state machine.
class EquationBuilder {
  EquationStep step = EquationStep.selectLeft;
  final List<EggComponent> parts = [];

  /// Attempt to select an egg. Returns true if accepted.
  bool trySelect(EggComponent egg) {
    // If egg is already selected, deselect it and everything after it
    final idx = parts.indexOf(egg);
    if (idx >= 0) {
      _deselectFrom(idx);
      return true;
    }

    // Step 3 doesn't accept egg taps (must press = button)
    if (step == EquationStep.pressEquals) return false;

    // Validate egg type for current step
    switch (step) {
      case EquationStep.selectLeft:
      case EquationStep.selectRight:
      case EquationStep.selectAnswer:
        if (egg.type != EggType.number) return false;
        break;
      case EquationStep.selectOperator:
        if (egg.type != EggType.operator) return false;
        break;
      case EquationStep.pressEquals:
        return false;
    }

    // Accept selection
    egg.state = EggState.selected;
    egg.selectionIndex = parts.length;
    parts.add(egg);

    // Advance step
    step = EquationStep.values[parts.length];

    return true;
  }

  /// Whether we have 4 parts and should auto-evaluate.
  bool get shouldEvaluate => parts.length == 4;

  /// Called when the = button is pressed (only valid at step 3).
  bool pressEquals() {
    if (step != EquationStep.pressEquals) return false;
    step = EquationStep.selectAnswer;
    return true;
  }

  /// Deselect from index onward.
  void _deselectFrom(int fromIndex) {
    for (int i = parts.length - 1; i >= fromIndex; i--) {
      parts[i].state = EggState.active;
      parts[i].selectionIndex = null;
      parts.removeAt(i);
    }
    step = EquationStep.values[parts.length];
  }

  /// Deselect all.
  void deselectAll() {
    if (parts.isNotEmpty) {
      _deselectFrom(0);
    }
  }

  /// Get the current equation display string.
  String get displayString {
    final left = parts.isNotEmpty ? '${parts[0].value}' : '?';
    final op =
        parts.length > 1 ? (parts[1].value as MathOp).symbol : '_';
    final right = parts.length > 2 ? '${parts[2].value}' : '?';
    final answer = parts.length > 3 ? '${parts[3].value}' : '?';
    return '$left $op $right = $answer';
  }

  /// Reset for next equation.
  void reset() {
    parts.clear();
    step = EquationStep.selectLeft;
  }
}
