// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyChallengeStateAdapter extends TypeAdapter<DailyChallengeState> {
  @override
  final int typeId = 6;

  @override
  DailyChallengeState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyChallengeState(
      dateKey: fields[0] as String,
      completedTaskIds: (fields[1] as List).cast<String>(),
      allComplete: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyChallengeState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.completedTaskIds)
      ..writeByte(2)
      ..write(obj.allComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyChallengeStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
