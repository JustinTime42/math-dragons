// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_tracker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactRecordAdapter extends TypeAdapter<FactRecord> {
  @override
  final int typeId = 3;

  @override
  FactRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FactRecord(
      factKey: fields[0] as String,
      timesPresented: fields[1] as int,
      timesCorrect: fields[2] as int,
      currentStreak: fields[3] as int,
      lastPresented: fields[4] as DateTime?,
      lastIncorrect: fields[5] as DateTime?,
      averageResponseTimeMs: fields[6] as double,
      totalResponseTimeMs: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FactRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.factKey)
      ..writeByte(1)
      ..write(obj.timesPresented)
      ..writeByte(2)
      ..write(obj.timesCorrect)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.lastPresented)
      ..writeByte(5)
      ..write(obj.lastIncorrect)
      ..writeByte(6)
      ..write(obj.averageResponseTimeMs)
      ..writeByte(7)
      ..write(obj.totalResponseTimeMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FactStatusAdapter extends TypeAdapter<FactStatus> {
  @override
  final int typeId = 4;

  @override
  FactStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FactStatus.newFact;
      case 1:
        return FactStatus.learning;
      case 2:
        return FactStatus.familiar;
      case 3:
        return FactStatus.mastered;
      default:
        return FactStatus.newFact;
    }
  }

  @override
  void write(BinaryWriter writer, FactStatus obj) {
    switch (obj) {
      case FactStatus.newFact:
        writer.writeByte(0);
        break;
      case FactStatus.learning:
        writer.writeByte(1);
        break;
      case FactStatus.familiar:
        writer.writeByte(2);
        break;
      case FactStatus.mastered:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
