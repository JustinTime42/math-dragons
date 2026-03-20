import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragon_eggs_game.dart';
import 'models/difficulty_config.dart';

class DragonEggsRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragon_eggs';

  @override
  String get displayName => 'Dragon Eggs';

  @override
  String get description => 'Hatch dragon eggs with math equations';

  @override
  String get iconAsset => 'assets/images/games/dragon_eggs/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragon_eggs/env.png';

  @override
  Color get accentColor => DragonColors.dragonEggsAccent;

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
        levelCompletionBonus: 15,
        threeStarBonus: 15,
      );

  @override
  List<MathSkill> get mathSkills => [
        MathSkill.addition,
        MathSkill.subtraction,
        MathSkill.multiplication,
        MathSkill.division,
        MathSkill.equationBuilding,
      ];

  @override
  Widget buildGame(GameContext context) {
    return DragonEggsScreen(startingLevel: context.level.levelNumber);
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
        minAccuracyForAdvance: 0.6,
        minProblemsPerLevel: 3,
      );

  static List<GameLevel> _generateLevels() {
    final levels = <GameLevel>[];

    for (int i = 1; i <= 50; i++) {
      final tier = DifficultyTier.forLevel(i);

      final String worldName;
      if (i <= 10) {
        worldName = 'Nest of Addition';
      } else if (i <= 20) {
        worldName = 'Cracking Subtraction';
      } else if (i <= 35) {
        worldName = 'Multiplication Roost';
      } else {
        worldName = 'Division Den';
      }

      final opsSet = <MathOperation>{};
      for (final op in tier.operations) {
        switch (op.name) {
          case 'add':
            opsSet.add(MathOperation.addition);
          case 'subtract':
            opsSet.add(MathOperation.subtraction);
          case 'multiply':
            opsSet.add(MathOperation.multiplication);
          case 'divide':
            opsSet.add(MathOperation.division);
        }
      }

      levels.add(GameLevel(
        levelNumber: i,
        name: 'Egg $i',
        worldName: worldName,
        params: DifficultyParams(
          numberMin: tier.numberMin,
          numberMax: tier.numberMax,
          operations: opsSet,
          speedMultiplier: tier.gravityMultiplier,
        ),
        starsRequired: i > 1 ? 1 : 0,
      ));
    }

    return levels;
  }
}
