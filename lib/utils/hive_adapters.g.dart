// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final typeId = 0;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist(
      id: fields[0] as String,
      versionId: fields[1] as String,
      contentType: fields[2] as String,
      files: (fields[3] as List).cast<PlaylistFile>(),
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.versionId)
      ..writeByte(2)
      ..write(obj.contentType)
      ..writeByte(3)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistFileAdapter extends TypeAdapter<PlaylistFile> {
  @override
  final typeId = 1;

  @override
  PlaylistFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistFile(
      fileUrl: fields[0] as String,
      displayOrder: (fields[1] as num).toInt(),
      delay: (fields[2] as num).toInt(),
      filePath: fields[3] as String,
      type: fields[4] as String,
      imageUrl: fields[5] as String?,
      imageFilePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistFile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fileUrl)
      ..writeByte(1)
      ..write(obj.displayOrder)
      ..writeByte(2)
      ..write(obj.delay)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.imageFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
