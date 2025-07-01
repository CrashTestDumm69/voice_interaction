import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/playlist_file_api/playlist_file_api.dart';

part 'playlist_api.g.dart';

@JsonSerializable()
class PlaylistApi {
  final String id;
  final String versionId;
  final String contentType;
  final List<PlaylistFileApi> files;

  PlaylistApi({
    required this.id,
    required this.versionId,
    required this.contentType,
    required this.files,
  });

  factory PlaylistApi.fromJson(Map<String, dynamic> json) => _$PlaylistApiFromJson(json);
  
  Map<String, dynamic> toJson() => _$PlaylistApiToJson(this);
}