// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerProfileAdapter extends TypeAdapter<PlayerProfile> {
  @override
  final int typeId = 0;

  @override
  PlayerProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerProfile(
      id: fields[0] as String,
      dragonName: fields[1] as String,
      dragonEvolution: fields[2] as int,
      totalScales: fields[3] as int,
      totalCorrectAnswers: fields[4] as int,
      totalPlayTimeMinutes: fields[5] as int,
      dailyChallengeStreak: fields[6] as int,
      createdAt: fields[7] as DateTime?,
      lastPlayedAt: fields[8] as DateTime?,
      gameStats: (fields[9] as Map?)?.cast<String, GameStats>(),
      settings: fields[10] as PlayerSettings?,
      ownedCosmetics: (fields[11] as List?)?.cast<String>(),
      equippedColor: fields[12] as String?,
      equippedAccessories: (fields[13] as List?)?.cast<String>(),
      schemaVersion: fields[14] as int,
      isFirstSession: fields[15] as bool,
      ageGroup: fields[16] as String?,
      firebaseUid: fields[17] as String?,
      linkedProvider: fields[18] as String?,
      equippedBackground: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerProfile obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dragonName)
      ..writeByte(2)
      ..write(obj.dragonEvolution)
      ..writeByte(3)
      ..write(obj.totalScales)
      ..writeByte(4)
      ..write(obj.totalCorrectAnswers)
      ..writeByte(5)
      ..write(obj.totalPlayTimeMinutes)
      ..writeByte(6)
      ..write(obj.dailyChallengeStreak)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastPlayedAt)
      ..writeByte(9)
      ..write(obj.gameStats)
      ..writeByte(10)
      ..write(obj.settings)
      ..writeByte(11)
      ..write(obj.ownedCosmetics)
      ..writeByte(12)
      ..write(obj.equippedColor)
      ..writeByte(13)
      ..write(obj.equippedAccessories)
      ..writeByte(14)
      ..write(obj.schemaVersion)
      ..writeByte(15)
      ..write(obj.isFirstSession)
      ..writeByte(16)
      ..write(obj.ageGroup)
      ..writeByte(17)
      ..write(obj.firebaseUid)
      ..writeByte(18)
      ..write(obj.linkedProvider)
      ..writeByte(19)
      ..write(obj.equippedBackground);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameStatsAdapter extends TypeAdapter<GameStats> {
  @override
  final int typeId = 1;

  @override
  GameStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStats(
      currentLevel: fields[0] as int,
      highScore: fields[1] as int,
      totalStars: fields[2] as int,
      timesPlayed: fields[3] as int,
      bestStreak: fields[4] as int,
      accuracy: fields[5] as double,
      totalCorrect: fields[6] as int,
      totalAttempted: fields[7] as int,
      lastPlayed: fields[8] as DateTime?,
      levelStars: (fields[9] as Map).cast<int, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameStats obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.highScore)
      ..writeByte(2)
      ..write(obj.totalStars)
      ..writeByte(3)
      ..write(obj.timesPlayed)
      ..writeByte(4)
      ..write(obj.bestStreak)
      ..writeByte(5)
      ..write(obj.accuracy)
      ..writeByte(6)
      ..write(obj.totalCorrect)
      ..writeByte(7)
      ..write(obj.totalAttempted)
      ..writeByte(8)
      ..write(obj.lastPlayed)
      ..writeByte(9)
      ..write(obj.levelStars);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerSettingsAdapter extends TypeAdapter<PlayerSettings> {
  @override
  final int typeId = 2;

  @override
  PlayerSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerSettings(
      soundEnabled: fields[0] as bool,
      musicEnabled: fields[1] as bool,
      hapticsEnabled: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.soundEnabled)
      ..writeByte(1)
      ..write(obj.musicEnabled)
      ..writeByte(2)
      ..write(obj.hapticsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
