import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'dragon_runes_game.dart';
import 'models/dragon_runes_config.dart';

/// MathDragonsGame implementation for Dragon Runes.
class DragonRunesRegistration implements MathDragonsGame {
  @override
  String get gameId => 'dragon_runes';

  @override
  String get displayName => 'Dragon Runes';

  @override
  String get description => 'Connect ancient runes to cast spells';

  @override
  String get iconAsset => 'assets/images/games/dragon_runes/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/dragon_runes/env.png';

  @override
  Color get accentColor => DragonColors.runesAccent;

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
        levelCompletionBonus: 25,
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
    return const DragonRunesScreen();
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
        minAccuracyForAdvance: 0.6,
        minProblemsPerLevel: 4,
      );

  /// Generate all 50 levels across 5 worlds (10 levels each).
  static List<GameLevel> _generateLevels() {
    final levels = <GameLevel>[];

    // World 1: Ember Equations (Levels 1-10)
    for (int i = 1; i <= 10; i++) {
      final config = DragonRunesConfig.forLevel(i);
      levels.add(GameLevel(
        levelNumber: i,
        name: 'Ember Equations $i',
        worldName: 'Ember Equations',
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {MathOperation.addition},
          speedMultiplier: 1.0,
        ),
        starsRequired: i > 1 ? 1 : 0,
      ));
    }

    // World 2: Flame Formulas (Levels 11-20)
    for (int i = 1; i <= 10; i++) {
      final config = DragonRunesConfig.forLevel(10 + i);
      levels.add(GameLevel(
        levelNumber: 10 + i,
        name: 'Flame Formulas $i',
        worldName: 'Flame Formulas',
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {
            MathOperation.addition,
            MathOperation.subtraction,
          },
          speedMultiplier: 1.0,
        ),
        starsRequired: 1,
      ));
    }

    // World 3: Inferno Algebra (Levels 21-30)
    for (int i = 1; i <= 10; i++) {
      final config = DragonRunesConfig.forLevel(20 + i);
      levels.add(GameLevel(
        levelNumber: 20 + i,
        name: 'Inferno Algebra $i',
        worldName: 'Inferno Algebra',
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
          },
          speedMultiplier: 1.0,
        ),
        starsRequired: 1,
      ));
    }

    // World 4: Dragon's Calculus (Levels 31-40)
    for (int i = 1; i <= 10; i++) {
      final config = DragonRunesConfig.forLevel(30 + i);
      levels.add(GameLevel(
        levelNumber: 30 + i,
        name: "Dragon's Calculus $i",
        worldName: "Dragon's Calculus",
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
            MathOperation.division,
          },
          speedMultiplier: 1.0,
        ),
        starsRequired: 1,
      ));
    }

    // World 5: Elder Runes (Levels 41-50)
    for (int i = 1; i <= 10; i++) {
      final config = DragonRunesConfig.forLevel(40 + i);
      levels.add(GameLevel(
        levelNumber: 40 + i,
        name: 'Elder Runes $i',
        worldName: 'Elder Runes',
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
            MathOperation.division,
          },
          speedMultiplier: 1.0,
        ),
        starsRequired: 1,
      ));
    }

    return levels;
  }
}
