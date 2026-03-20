import 'package:flutter/material.dart';

/// The contract every mini-game must implement.
/// Adding a new game = implement this + register in GameRegistry.
abstract class MathDragonsGame {
  // ── Identity ──
  String get gameId;
  String get displayName;
  String get description;
  String get iconAsset;
  String get environmentAsset;
  Color get accentColor;

  // ── Difficulty / Levels ──
  List<GameLevel> get levels;
  GameLevel currentLevel(PlayerGameStats stats);

  // ── Rewards ──
  RewardConfig get rewardConfig;

  // ── Math skills this game teaches ──
  List<MathSkill> get mathSkills;

  // ── The actual game widget ──
  Widget buildGame(GameContext context);

  // ── Difficulty engine hook ──
  DifficultyProfile get difficultyProfile;
}

/// A single level within a game.
class GameLevel {
  final int levelNumber;
  final String name;
  final String worldName;
  final DifficultyParams params;
  final int starsRequired;

  const GameLevel({
    required this.levelNumber,
    required this.name,
    required this.worldName,
    required this.params,
    this.starsRequired = 0,
  });
}

/// Difficulty parameters for a level. Games extend this with game-specific params.
class DifficultyParams {
  final int numberMin;
  final int numberMax;
  final Set<MathOperation> operations;
  final double speedMultiplier;

  const DifficultyParams({
    required this.numberMin,
    required this.numberMax,
    required this.operations,
    this.speedMultiplier = 1.0,
  });
}

/// Math operations available in games.
enum MathOperation { addition, subtraction, multiplication, division }

/// Math skills tracked across games.
enum MathSkill {
  addition,
  subtraction,
  multiplication,
  division,
  equationBuilding,
  mentalMathSpeed,
  numberProperties,
  categorization,
}

/// Configuration for how a game awards currency.
class RewardConfig {
  final int baseScalesPerCorrect;
  final int streakBonusCap;
  final int levelCompletionBonus;
  final int threeStarBonus;

  const RewardConfig({
    required this.baseScalesPerCorrect,
    required this.streakBonusCap,
    required this.levelCompletionBonus,
    required this.threeStarBonus,
  });
}

/// Per-game stats for a player. Used to determine current level.
class PlayerGameStats {
  final int currentLevel;
  final int highScore;
  final int totalStars;
  final int timesPlayed;
  final int bestStreak;
  final double accuracy;

  const PlayerGameStats({
    this.currentLevel = 1,
    this.highScore = 0,
    this.totalStars = 0,
    this.timesPlayed = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
  });
}

/// Context passed to a game when it's launched.
class GameContext {
  final GameLevel level;
  final PlayerGameStats stats;

  const GameContext({
    required this.level,
    required this.stats,
  });
}

/// Profile for adaptive difficulty. Games define their difficulty parameters.
class DifficultyProfile {
  final double minAccuracyForAdvance;
  final int minProblemsPerLevel;

  const DifficultyProfile({
    this.minAccuracyForAdvance = 0.6,
    this.minProblemsPerLevel = 10,
  });
}
