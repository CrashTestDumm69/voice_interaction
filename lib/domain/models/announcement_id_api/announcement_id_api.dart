import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_id_api.g.dart';

@JsonSerializable()
class AnnouncementIdApi {
  final String announcementId;
  final String versionId;

  AnnouncementIdApi({
    required this.announcementId,
    required this.versionId
  });

  factory AnnouncementIdApi.fromJson(Map<String, dynamic> json) => _$AnnouncementIdApiFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementIdApiToJson(this);
}