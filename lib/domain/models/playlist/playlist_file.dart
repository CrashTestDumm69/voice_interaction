import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/config/platform_data.dart';

class PlaylistFile extends HiveObject {
  String fileUrl;
  int displayOrder;
  int delay;
  String filePath;
  String type;
  String? imageUrl;
  String? imageFilePath;

  PlaylistFile({
    required this.fileUrl,
    required this.displayOrder,
    required this.delay,
    required this.filePath,
    required this.type,
    this.imageUrl,
    this.imageFilePath,
  });

  factory PlaylistFile.fromJson(Map<String, dynamic> json) {
    final path = json["path"] as String;
    final displayOrder = (json["displayOrder"] as num).toInt();
    final delay = (json["delay"] as num).toInt();
    final type = json["type"] as String;
    final backgroundImage = json["backgroundImage"] as String?;

    return PlaylistFile(
      fileUrl: "${PlatformData.baseUrl}$path",
      displayOrder: displayOrder,
      delay: delay,
      filePath: "${PlatformData.playlistPath}/${path.split("/").last}",
      type: type,
      imageUrl: type == 'video' || backgroundImage == null ? null : "${PlatformData.baseUrl}$backgroundImage",
      imageFilePath: type == 'video' || backgroundImage == null ? null : "${PlatformData.playlistPath}/${backgroundImage.split("/").last}"
    );
  }
}