// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistApi _$PlaylistApiFromJson(Map<String, dynamic> json) => PlaylistApi(
  id: json['id'] as String,
  versionId: json['versionId'] as String,
  contentType: $enumDecode(_$PlaylistTypeEnumMap, json['contentType']),
  files:
      (json['files'] as List<dynamic>)
          .map((e) => PlaylistFileApi.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PlaylistApiToJson(PlaylistApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionId': instance.versionId,
      'contentType': _$PlaylistTypeEnumMap[instance.contentType]!,
      'files': instance.files,
    };

const _$PlaylistTypeEnumMap = {
  PlaylistType.playlist: 'playlist',
  PlaylistType.announcement: 'announcement',
};
