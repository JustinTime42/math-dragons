import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragons_feast_game.dart';
import 'models/feast_config.dart';

/// MathDragonsGame implementation for Dragon's Feast.
class DragonsFeastRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragons_feast';

  @override
  String get displayName => "Dragon's Feast";

  @override
  String get description => 'Feast on the right numbers';

  @override
  String get iconAsset => 'assets/images/games/dragons_feast/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragons_feast/env.png';

  @override
  Color get accentColor => DragonColors.dragonsFeastAccent;

  @override
  List<GameLevel> get levels => _generateLevels();

  @override
  GameLevel currentLevel(PlayerGameStats stats) {
    final levelNum = stats.currentLevel.clamp(1, levels.length);
    return levels[levelNum - 1];
  }

  @override
  RewardConfig get rewardConfig => const RewardConfig(
        baseScalesPerCorrect: 2,
        streakBonusCap: 5,
        levelCompletionBonus: 20,
        threeStarBonus: 15,
      );

  @override
  List<MathSkill> get mathSkills => [
        MathSkill.numberProperties,
        MathSkill.categorization,
      ];

  @override
  Widget buildGame(GameContext context) {
    return const DragonsFeastScreen();
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
        minAccuracyForAdvance: 0.6,
        minProblemsPerLevel: 6,
      );

  static List<GameLevel> _generateLevels() {
    final levels = <GameLevel>[];
    final worldNames = [
      'Easy Pickings',
      'Growing Appetite',
      'Refined Palate',
      'Gourmet Dragon',
      "Dragon King's Feast",
    ];

    for (int world = 0; world < 5; world++) {
      for (int i = 1; i <= 8; i++) {
        final levelNumber = world * 8 + i;
        final config = DragonsFeastConfig.configForLevel(levelNumber);
        levels.add(GameLevel(
          levelNumber: levelNumber,
          name: '${worldNames[world]} $i',
          worldName: worldNames[world],
          params: DifficultyParams(
            numberMin: config.category.rangeMin,
            numberMax: config.category.rangeMax,
            operations: const {},
            speedMultiplier: 1.0,
          ),
          starsRequired: levelNumber > 1 ? 1 : 0,
        ));
      }
    }

    return levels;
  }
}
