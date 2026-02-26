// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuItemEntityAdapter extends TypeAdapter<MenuItemEntity> {
  @override
  final typeId = 1;

  @override
  MenuItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuItemEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: (fields[2] as num).toInt(),
      thumbUrl: fields[3] as String,
      fullPhotoUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MenuItemEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.thumbUrl)
      ..writeByte(4)
      ..write(obj.fullPhotoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
