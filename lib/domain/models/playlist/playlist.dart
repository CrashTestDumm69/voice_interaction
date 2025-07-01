import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_type.dart';

class Playlist extends HiveObject {
  final String id;
  final String versionId;
  final PlaylistType contentType;
  final List<PlaylistFile> files;

  Playlist({
    required this.id,
    required this.versionId,
    required this.contentType,
    required this.files,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as String;
    final versionId = json["versionId"] as String;
    final contentType = (json["contentType"] as String) == "announcement" ? PlaylistType.announcement : PlaylistType.playlist;
    final files = json["files"] as List<dynamic>;
    
    return Playlist(
      id: id,
      versionId: versionId,
      contentType: contentType,
      files: files
          .map((file) => PlaylistFile.fromJson(file))
          .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder))
    );
  }

  @override
  String toString() {
    return "ID - $id, Version ID - $versionId";
  }
}