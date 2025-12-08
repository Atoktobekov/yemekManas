// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyMenuAdapter extends TypeAdapter<DailyMenu> {
  @override
  final typeId = 2;

  @override
  DailyMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMenu(
      date: fields[0] as String,
      items: (fields[1] as List).cast<MenuItem>(),
      lastUpdate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMenu obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
