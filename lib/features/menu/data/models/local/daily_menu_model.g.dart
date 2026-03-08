// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyMenuModelAdapter extends TypeAdapter<DailyMenuModel> {
  @override
  final typeId = 2;

  @override
  DailyMenuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMenuModel(
      date: fields[0] as String,
      items: (fields[1] as List).cast<MenuItemModel>(),
      lastUpdate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMenuModel obj) {
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
      other is DailyMenuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
