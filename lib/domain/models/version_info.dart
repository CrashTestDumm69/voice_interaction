import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_info.freezed.dart';

@freezed
class VersionInfo with _$VersionInfo {
  @override
  final String tagName;
  
  @override
  final String browserDownloadUrl;

  VersionInfo({
    required this.tagName,
    required this.browserDownloadUrl,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    final asset = (json['assets'] as List<dynamic>).first;
    return VersionInfo(
      tagName: json['tag_name'] as String,
      browserDownloadUrl: asset['browser_download_url'] as String,
    );
  }
}