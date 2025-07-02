import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';

class Playlist extends HiveObject {
  final String id;
  final String versionId;
  final String contentType;
  final List<PlaylistFile> files;

  Playlist({
    required this.id,
    required this.versionId,
    required this.contentType,
    required this.files,
  });

  bool get isPlaylist => contentType == "playlist";
  bool get isAnnouncement => contentType == "announcement";

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as String;
    final versionId = json["versionId"] as String;
    final contentType = (json["contentType"] as String);
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
    return "ID - $id, Version ID - $versionId, Files - ${files.map((e) => e.toString())}";
  }
}