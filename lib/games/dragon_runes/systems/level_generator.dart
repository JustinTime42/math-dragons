import 'dart:math';

import '../../shared/math_problem.dart';
import '../models/dragon_runes_config.dart';
import '../models/rune_node_data.dart';
import '../models/equation_target.dart';

/// Generates solvable Dragon Runes puzzles.
class LevelGenerator {
  final Random random;

  LevelGenerator({Random? random}) : random = random ?? Random();

  /// Generate a complete level, optionally seeded with engine-suggested facts.
  GeneratedLevel generate(
    DragonRunesConfig config, {
    List<MathFact>? suggestedFacts,
  }) {
    // 1. Generate number families, biased toward suggested operands
    final families = _generateFamilies(config, suggestedFacts: suggestedFacts);

    // 2. Generate all equations from families
    final allEquations = <Equation>[];
    for (final family in families) {
      allEquations.addAll(_familyEquations(family, config.allowedOps));
    }

    // 3. Select balanced targets
    final targets =
        _pickTargets(allEquations, config.targetCount, config.allowedOps);

    // 4. Calculate node counts from selected targets
    final targetNumberCounts = <int, int>{};
    for (final target in targets) {
      for (final num in target.numbers) {
        final neededInThisEq = target.numbers.where((n) => n == num).length;
        targetNumberCounts[num] =
            max(targetNumberCounts[num] ?? 0, neededInThisEq);
      }
    }

    // 5. Build node list
    final nodeList = <RuneNodeData>[];

    // Add number nodes
    for (final entry in targetNumberCounts.entries) {
      for (int i = 0; i < entry.value; i++) {
        nodeList.add(RuneNodeData(
          type: RuneNodeType.number,
          value: '${entry.key}',
          numericValue: entry.key,
        ));
      }
    }

    // Add operator nodes (all ops used in targets + all enabled ops)
    final usedOps = <String>{};
    for (final target in targets) {
      usedOps.add(target.opSymbol);
    }
    for (final op in config.allowedOps) {
      usedOps.add(op.symbol);
    }
    for (final op in usedOps) {
      nodeList.add(RuneNodeData(
        type: RuneNodeType.operator,
        value: op,
      ));
    }

    // Add equals node
    nodeList.add(const RuneNodeData(
      type: RuneNodeType.equals,
      value: '=',
    ));

    // 6. Shuffle nodes
    nodeList.shuffle(random);

    return GeneratedLevel(
      nodes: nodeList,
      targets: targets
          .map((e) => EquationTarget(
                canonical: e.canonical,
                displayText: e.displayText,
              ))
          .toList(),
    );
  }

  /// Generate number families (pairs a, b) for the level.
  List<NumberFamily> _generateFamilies(
    DragonRunesConfig config, {
    List<MathFact>? suggestedFacts,
  }) {
    final families = <NumberFamily>[];
    final usedPairs = <String>{};
    final usedNumbers = <int>{};
    final spread = config.adjacencySpread;
    final isVariety = config.isVarietyLevel;

    // Seed first family from engine suggestion if available
    if (suggestedFacts != null && suggestedFacts.isNotEmpty) {
      final fact = suggestedFacts.first;
      final a = fact.left.clamp(config.numberMin, config.numberMax);
      final b = fact.right.clamp(config.numberMin, config.numberMax);
      final lo = a < b ? a : b;
      final hi = a < b ? b : a;

      if (lo != hi || config.numberOfFamilies > 1) {
        usedPairs.add('$lo,$hi');
        usedNumbers.add(lo);
        usedNumbers.add(hi);
        families.add(NumberFamily(a: lo, b: hi));
      }
    }

    for (int f = families.length; f < config.numberOfFamilies; f++) {
      for (int attempt = 0; attempt < 300; attempt++) {
        int a, b;

        if (isVariety) {
          // Variety levels: old fully-random behavior
          if (f > 0 && usedNumbers.isNotEmpty && random.nextDouble() < 0.8) {
            a = usedNumbers.elementAt(random.nextInt(usedNumbers.length));
            b = config.numberMin +
                random.nextInt(config.numberMax - config.numberMin + 1);
          } else {
            a = config.numberMin +
                random.nextInt(config.numberMax - config.numberMin + 1);
            b = config.numberMin +
                random.nextInt(config.numberMax - config.numberMin + 1);
          }
        } else if (f == 0) {
          // First family (no engine seed): start near numberMin
          a = config.numberMin +
              random.nextInt(min(spread + 1, config.numberMax - config.numberMin + 1));
          final bMin = a;
          final bMax = min(a + spread, config.numberMax);
          b = bMin + random.nextInt(bMax - bMin + 1);
        } else {
          // Subsequent families: reuse a number 80%, pick new one nearby
          if (usedNumbers.isNotEmpty && random.nextDouble() < 0.8) {
            a = usedNumbers.elementAt(random.nextInt(usedNumbers.length));
          } else {
            // Pick near an existing number
            final anchor = usedNumbers.elementAt(random.nextInt(usedNumbers.length));
            final lo = max(config.numberMin, anchor - spread);
            final hi = min(config.numberMax, anchor + spread);
            a = lo + random.nextInt(hi - lo + 1);
          }
          // New number adjacent to a
          final bLo = max(config.numberMin, a - spread);
          final bHi = min(config.numberMax, a + spread);
          b = bLo + random.nextInt(bHi - bLo + 1);
        }

        // Normalize: smaller first
        if (a > b) {
          final t = a;
          a = b;
          b = t;
        }

        // Skip duplicates
        final pairKey = '$a,$b';
        if (usedPairs.contains(pairKey)) continue;

        // Skip a==b for single-op single-family (too trivial)
        if (config.numberOfFamilies == 1 &&
            config.allowedOps.length == 1 &&
            a == b) {
          continue;
        }

        // Skip if both <= 1 and multiplication is an option
        if (a <= 1 &&
            b <= 1 &&
            config.allowedOps.contains(MathOp.multiply)) {
          continue;
        }

        usedPairs.add(pairKey);
        usedNumbers.add(a);
        usedNumbers.add(b);
        families.add(NumberFamily(a: a, b: b));
        break;
      }
    }

    // Fallback: if generation failed, force simple addition family
    if (families.isEmpty) {
      families.add(const NumberFamily(a: 1, b: 2));
    }

    return families;
  }

  /// Generate all valid equations from a number family.
  List<Equation> _familyEquations(NumberFamily family, List<MathOp> ops) {
    final equations = <Equation>[];
    final a = family.a;
    final b = family.b;

    for (final op in ops) {
      switch (op) {
        case MathOp.add:
          final c = a + b;
          equations.add(Equation.fromParts(a, '+', b, c));
          if (a != b) equations.add(Equation.fromParts(b, '+', a, c));

        case MathOp.subtract:
          final c = a + b;
          equations.add(Equation.fromParts(c, '\u2212', a, b));
          if (a != b) equations.add(Equation.fromParts(c, '\u2212', b, a));

        case MathOp.multiply:
          if (a <= 1 && b <= 1) break;
          final product = a * b;
          if (product > 144) break;
          equations.add(Equation.fromParts(a, '\u00D7', b, product));
          if (a != b) {
            equations.add(Equation.fromParts(b, '\u00D7', a, product));
          }

        case MathOp.divide:
          final product = a * b;
          if (product > 144) break;
          if (a > 0) {
            equations.add(Equation.fromParts(product, '\u00F7', a, b));
          }
          if (b > 0 && a != b) {
            equations.add(Equation.fromParts(product, '\u00F7', b, a));
          }
      }
    }

    return equations;
  }

  /// Select a balanced set of target equations.
  List<Equation> _pickTargets(
    List<Equation> pool,
    int count,
    List<MathOp> ops,
  ) {
    if (pool.length <= count) return List.from(pool);

    final selected = <Equation>[];
    final remaining = List<Equation>.from(pool);
    final selectedCanonicals = <String>{};

    // Phase 1: Pick one per operation type for diversity
    for (final op in ops) {
      final opSymbol = op.symbol;
      final candidates =
          remaining.where((e) => e.opSymbol == opSymbol).toList();
      if (candidates.isNotEmpty && selected.length < count) {
        final pick = candidates[random.nextInt(candidates.length)];
        if (!selectedCanonicals.contains(pick.canonical)) {
          selected.add(pick);
          selectedCanonicals.add(pick.canonical);
          remaining.remove(pick);
        }
      }
    }

    // Phase 2: Fill remaining slots randomly, avoiding duplicate canonicals
    remaining.shuffle(random);
    for (final eq in remaining) {
      if (selected.length >= count) break;
      if (!selectedCanonicals.contains(eq.canonical)) {
        selected.add(eq);
        selectedCanonicals.add(eq.canonical);
      }
    }

    return selected;
  }
}
