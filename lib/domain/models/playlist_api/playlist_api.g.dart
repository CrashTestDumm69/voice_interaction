// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistApi _$PlaylistApiFromJson(Map<String, dynamic> json) => PlaylistApi(
  id: json['id'] as String,
  versionId: json['versionId'] as String,
  contentType: json['contentType'] as String,
  files:
      (json['files'] as List<dynamic>)
          .map((e) => PlaylistFileApi.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PlaylistApiToJson(PlaylistApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionId': instance.versionId,
      'contentType': instance.contentType,
      'files': instance.files
          .map((e) => e.toJson())
          .toList(),
    };
