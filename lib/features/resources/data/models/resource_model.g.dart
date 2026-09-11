// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceModelAdapter extends TypeAdapter<ResourceModel> {
  @override
  final int typeId = 1;

  @override
  ResourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResourceModel(
      hiveId: fields[0] as String,
      hiveCourseId: fields[1] as String,
      hiveTitle: fields[2] as String,
      hiveType: fields[3] as String,
      hiveUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResourceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hiveId)
      ..writeByte(1)
      ..write(obj.hiveCourseId)
      ..writeByte(2)
      ..write(obj.hiveTitle)
      ..writeByte(3)
      ..write(obj.hiveType)
      ..writeByte(4)
      ..write(obj.hiveUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
