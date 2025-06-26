import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_id_api.g.dart';

@JsonSerializable()
class PlaylistIdApi {
  final String playlistId;
  final String versionId;

  PlaylistIdApi({
    required this.playlistId,
    required this.versionId,
  });

  factory PlaylistIdApi.fromJson(Map<String, dynamic> json) => _$PlaylistIdApiFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistIdApiToJson(this);
}