import 'package:flutter/material.dart';
import '../../core/game_interface.dart';
import '../../theme/dragon_colors.dart';
import 'fire_trail_game.dart';
import 'models/fire_trail_config.dart';

/// MathDragonsGame implementation for Fire Trail.
class FireTrailRegistration implements MathDragonsGame {
  @override
  String get gameId => 'fire_trail';

  @override
  String get displayName => 'Fire Trail';

  @override
  String get description => 'Blaze a trail of correct answers';

  @override
  String get iconAsset => 'assets/images/games/fire_trail/icon.png';

  @override
  String get environmentAsset => 'assets/images/games/fire_trail/env.png';

  @override
  Color get accentColor => DragonColors.fireTrailAccent;

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
        MathSkill.addition,
        MathSkill.subtraction,
        MathSkill.multiplication,
        MathSkill.division,
        MathSkill.mentalMathSpeed,
      ];

  @override
  Widget buildGame(GameContext context) {
    return const FireTrailScreen();
  }

  @override
  DifficultyProfile get difficultyProfile => const DifficultyProfile(
        minAccuracyForAdvance: 0.6,
        minProblemsPerLevel: 8,
      );

  static List<GameLevel> _generateLevels() {
    final levels = <GameLevel>[];

    // World 1: First Flight (Levels 1-8)
    for (int i = 1; i <= 8; i++) {
      final config = FireTrailConfig.forLevel(1, i);
      levels.add(GameLevel(
        levelNumber: i,
        name: 'First Flight $i',
        worldName: 'First Flight',
        params: DifficultyParams(
          numberMin: config.numberMin,
          numberMax: config.numberMax,
          operations: const {MathOperation.addition},
          speedMultiplier: 1.0,
        ),
        starsRequired: i > 1 ? 1 : 0,
      ));
    }

    // World 2: Thermal Currents (Levels 9-16)
    for (int i = 1; i <= 8; i++) {
      final config = FireTrailConfig.forLevel(2, i);
      levels.add(GameLevel(
        levelNumber: 8 + i,
        name: 'Thermal Currents $i',
        worldName: 'Thermal Currents',
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

    // World 3: Firestorm (Levels 17-24)
    for (int i = 1; i <= 8; i++) {
      final config = FireTrailConfig.forLevel(3, i);
      levels.add(GameLevel(
        levelNumber: 16 + i,
        name: 'Firestorm $i',
        worldName: 'Firestorm',
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

    // World 4: Inferno (Levels 25-32)
    for (int i = 1; i <= 8; i++) {
      final config = FireTrailConfig.forLevel(4, i);
      levels.add(GameLevel(
        levelNumber: 24 + i,
        name: 'Inferno $i',
        worldName: 'Inferno',
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

    // World 5: Dragon Master (Levels 33-40)
    for (int i = 1; i <= 8; i++) {
      final config = FireTrailConfig.forLevel(5, i);
      levels.add(GameLevel(
        levelNumber: 32 + i,
        name: 'Dragon Master $i',
        worldName: 'Dragon Master',
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
