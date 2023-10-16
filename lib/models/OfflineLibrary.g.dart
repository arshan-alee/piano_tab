// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OfflineLibrary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineLibraryAdapter extends TypeAdapter<OfflineLibrary> {
  @override
  final int typeId = 2;

  @override
  OfflineLibrary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineLibrary(
      isLoggedIn: fields[0] as bool?,
      points: fields[1] as String?,
      offlineLibrary: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineLibrary obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isLoggedIn)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.offlineLibrary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineLibraryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}