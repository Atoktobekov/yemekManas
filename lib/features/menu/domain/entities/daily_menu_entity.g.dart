// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyMenuEntityAdapter extends TypeAdapter<DailyMenuEntity> {
  @override
  final typeId = 2;

  @override
  DailyMenuEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMenuEntity(
      date: fields[0] as String,
      items: (fields[1] as List).cast<MenuItemEntity>(),
      lastUpdate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMenuEntity obj) {
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
      other is DailyMenuEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
