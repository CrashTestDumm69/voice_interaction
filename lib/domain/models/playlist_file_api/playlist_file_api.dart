import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_file_api.g.dart';

@JsonSerializable()
class PlaylistFileApi {
  final String path;
  final int displayOrder;
  final int delay;
  final String type;
  final String? backgroundImage;
  final bool? backgroundImageEnabled;

  PlaylistFileApi({
    required this.path,
    required this.displayOrder,
    required this.delay,
    required this.type,
    this.backgroundImage,
    this.backgroundImageEnabled,
  });

  factory PlaylistFileApi.fromJson(Map<String, dynamic> json) => _$PlaylistFileApiFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistFileApiToJson(this);
}