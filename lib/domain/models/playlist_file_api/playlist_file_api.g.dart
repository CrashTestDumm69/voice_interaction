// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_file_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistFileApi _$PlaylistFileApiFromJson(Map<String, dynamic> json) =>
    PlaylistFileApi(
      path: json['path'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      delay: (json['delay'] as num).toInt(),
      type: json['type'] as String,
      backgroundImage: json['backgroundImage'] as String?,
      backgroundImageEnabled: json['backgroundImageEnabled'] as bool?,
    );

Map<String, dynamic> _$PlaylistFileApiToJson(PlaylistFileApi instance) =>
    <String, dynamic>{
      'path': instance.path,
      'displayOrder': instance.displayOrder,
      'delay': instance.delay,
      'type': instance.type,
      'backgroundImage': instance.backgroundImage,
      'backgroundImageEnabled': instance.backgroundImageEnabled,
    };
