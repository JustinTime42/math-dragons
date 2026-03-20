import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/games/dragon_runes/models/dragon_runes_config.dart';
import 'package:math_dragons/games/dragon_runes/models/rune_node_data.dart';
import 'package:math_dragons/games/dragon_runes/systems/level_generator.dart';

void main() {
  group('LevelGenerator', () {
    late LevelGenerator generator;

    setUp(() {
      generator = LevelGenerator(random: Random(42)); // deterministic
    });

    test('generated level has at least 1 target equation', () {
      final config = DragonRunesConfig.forLevel(1);
      final level = generator.generate(config);
      expect(level.targets, isNotEmpty);
    });

    test('generated level has requested number of targets (or fewer if pool is small)', () {
      final config = DragonRunesConfig.forLevel(1);
      final level = generator.generate(config);
      expect(level.targets.length, lessThanOrEqualTo(config.targetCount));
      expect(level.targets.length, greaterThan(0));
    });

    test('node list contains at least one equals sign', () {
      final config = DragonRunesConfig.forLevel(1);
      final level = generator.generate(config);
      final equalsNodes =
          level.nodes.where((n) => n.type == RuneNodeType.equals);
      expect(equalsNodes, isNotEmpty);
    });

    test('node list contains operators matching allowed operations', () {
      final config = DragonRunesConfig.forLevel(1); // addition only
      final level = generator.generate(config);
      final opNodes =
          level.nodes.where((n) => n.type == RuneNodeType.operator);
      expect(opNodes, isNotEmpty);
      expect(opNodes.any((n) => n.value == '+'), true);
    });

    test('all target equations are solvable from provided nodes', () {
      // Test across multiple levels
      for (int lvl = 1; lvl <= 10; lvl++) {
        final config = DragonRunesConfig.forLevel(lvl);
        final gen = LevelGenerator(random: Random(lvl));
        final level = gen.generate(config);

        for (final target in level.targets) {
          // Tokenize the canonical form
          final tokens = _tokenize(target.canonical);
          expect(tokens, isNotNull,
              reason: 'Level $lvl target ${target.canonical} should tokenize');

          // Verify each token exists in nodes
          final usedIndices = <int>{};
          for (final token in tokens!) {
            bool found = false;
            for (int i = 0; i < level.nodes.length; i++) {
              if (!usedIndices.contains(i) && level.nodes[i].value == token) {
                usedIndices.add(i);
                found = true;
                break;
              }
            }
            expect(found, true,
                reason:
                    'Level $lvl: token "$token" from target "${target.canonical}" not found in nodes');
          }
        }
      }
    });

    test('when only addition is enabled, all targets are addition', () {
      final config = DragonRunesConfig.forLevel(1); // World 1: addition only
      final level = generator.generate(config);
      for (final target in level.targets) {
        expect(target.canonical.contains('+'), true,
            reason: 'Target ${target.canonical} should be addition');
      }
    });

    test('multiplication products never exceed 144', () {
      // Test higher levels with multiplication
      for (int lvl = 21; lvl <= 30; lvl++) {
        final config = DragonRunesConfig.forLevel(lvl);
        final gen = LevelGenerator(random: Random(lvl));
        final level = gen.generate(config);

        for (final target in level.targets) {
          if (target.canonical.contains('\u00D7')) {
            // Parse and check product
            final match = RegExp(r'(\d+)\u00D7(\d+)=(\d+)')
                .firstMatch(target.canonical);
            if (match != null) {
              final result = int.parse(match.group(3)!);
              expect(result, lessThanOrEqualTo(144),
                  reason:
                      'Multiplication result in ${target.canonical} exceeds 144');
            }
          }
        }
      }
    });

    test('1-family level generates valid equations', () {
      final config = DragonRunesConfig.forLevel(1); // 1 family
      expect(config.numberOfFamilies, 1);
      final level = generator.generate(config);
      expect(level.targets, isNotEmpty);
      expect(level.nodes, isNotEmpty);
    });

    test('3-family level generates valid equations', () {
      final config = DragonRunesConfig.forLevel(30); // 3 families
      expect(config.numberOfFamilies, 3);
      final level = generator.generate(config);
      expect(level.targets, isNotEmpty);
      expect(level.nodes, isNotEmpty);
    });

    test('non-variety levels produce adjacent families within spread', () {
      // World 1 levels 1,2,4,5,7,8,10 are non-variety (spread ±1)
      for (final lvl in [1, 2, 4, 5, 7, 8, 10]) {
        final config = DragonRunesConfig.forLevel(lvl);
        expect(config.isVarietyLevel, false,
            reason: 'Level $lvl should not be variety');
        expect(config.adjacencySpread, 1,
            reason: 'World 1 spread should be 1');

        // Generate many times to check adjacency holds
        for (int seed = 0; seed < 20; seed++) {
          final gen = LevelGenerator(random: Random(lvl * 100 + seed));
          final level = gen.generate(config);

          // Extract family operands from targets (left, right — not results)
          final familyNumbers = <int>{};
          for (final target in level.targets) {
            final match = RegExp(r'(\d+)[+\u2212\u00D7\u00F7](\d+)=')
                .firstMatch(target.canonical);
            if (match != null) {
              familyNumbers.add(int.parse(match.group(1)!));
              familyNumbers.add(int.parse(match.group(2)!));
            }
          }

          // Every family operand should be within spread of at least one other
          if (familyNumbers.length > 1) {
            for (final n in familyNumbers) {
              final hasNeighbor = familyNumbers.any(
                  (other) => other != n && (other - n).abs() <= config.adjacencySpread);
              expect(hasNeighbor, true,
                  reason:
                      'Level $lvl seed $seed: operand $n has no neighbor within spread ${config.adjacencySpread}, operands: $familyNumbers');
            }
          }
        }
      }
    });

    test('first family starts near numberMin on non-variety levels', () {
      for (int seed = 0; seed < 50; seed++) {
        final config = DragonRunesConfig.forLevel(1); // World 1, level 1
        final gen = LevelGenerator(random: Random(seed));
        final level = gen.generate(config);

        // Extract number nodes
        final numbers = level.nodes
            .where((n) => n.type == RuneNodeType.number)
            .map((n) => n.numericValue)
            .toSet();
        if (numbers.isEmpty) continue;
        final minNum = numbers.reduce(min);
        // First family should start near numberMin (within spread)
        expect(minNum, lessThanOrEqualTo(config.numberMin + config.adjacencySpread),
            reason:
                'Seed $seed: smallest number $minNum should be near numberMin ${config.numberMin}');
      }
    });

    test('variety levels (levelInWorld % 3 == 0) still generate valid equations', () {
      // Levels 3, 6, 9 in world 1 → levels 3, 6, 9
      for (final lvl in [3, 6, 9]) {
        final config = DragonRunesConfig.forLevel(lvl);
        expect(config.isVarietyLevel, true,
            reason: 'Level $lvl should be a variety level');

        for (int seed = 0; seed < 10; seed++) {
          final gen = LevelGenerator(random: Random(lvl * 100 + seed));
          final level = gen.generate(config);
          expect(level.targets, isNotEmpty,
              reason: 'Level $lvl seed $seed should have targets');
          expect(level.nodes, isNotEmpty,
              reason: 'Level $lvl seed $seed should have nodes');
        }
      }
    });

    test('world 3 uses spread of 2', () {
      // World 3 = levels 21-30, non-variety: 21,22,24,25,27,28,30
      final config = DragonRunesConfig.forLevel(21);
      expect(config.adjacencySpread, 2);
      expect(config.isVarietyLevel, false);
    });

    test('node counts match: if a target needs two 3s, nodes have two 3s', () {
      // Generate a level and verify
      for (int lvl = 1; lvl <= 20; lvl++) {
        final config = DragonRunesConfig.forLevel(lvl);
        final gen = LevelGenerator(random: Random(lvl + 100));
        final level = gen.generate(config);

        // For each target, check that we have enough nodes
        for (final target in level.targets) {
          final tokens = _tokenize(target.canonical);
          if (tokens == null) continue;

          final usedIndices = <int>{};
          for (final token in tokens) {
            bool found = false;
            for (int i = 0; i < level.nodes.length; i++) {
              if (!usedIndices.contains(i) && level.nodes[i].value == token) {
                usedIndices.add(i);
                found = true;
                break;
              }
            }
            expect(found, true,
                reason:
                    'Level $lvl: need "$token" for ${target.canonical} but not enough in nodes');
          }
        }
      }
    });
  });
}

List<String>? _tokenize(String canonical) {
  final result = <String>[];
  final buffer = StringBuffer();

  for (final char in canonical.runes) {
    final c = String.fromCharCode(char);
    if (RegExp(r'[0-9]').hasMatch(c)) {
      buffer.write(c);
    } else {
      if (buffer.isNotEmpty) {
        result.add(buffer.toString());
        buffer.clear();
      }
      result.add(c);
    }
  }
  if (buffer.isNotEmpty) result.add(buffer.toString());

  return result.length >= 5 ? result : null;
}
