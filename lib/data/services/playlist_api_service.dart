import 'package:dio/dio.dart';

import 'package:voice_interaction/config/platform_api_data.dart';
import 'package:voice_interaction/domain/models/announcement_id_api/announcement_id_api.dart';
import 'package:voice_interaction/domain/models/playlist_api/playlist_api.dart';
import 'package:voice_interaction/domain/models/playlist_id_api/playlist_id_api.dart';

class PlaylistApiService {
  final Dio _dio;

  PlaylistApiService({
    required Dio dio
  }) : _dio = dio;

  Future<PlaylistIdApi?> getCurrentPlaylistId() async {
    final response = await _dio.get(PlatformApiData.getPlaylistIdUrl);
    if (response.statusCode == 200) {
      final data = response.data;
      final currentPlaylist = data["currentPlaylist"];
      return currentPlaylist != null ? PlaylistIdApi.fromJson(currentPlaylist) : null;
    }
    return null;
  }

  Future<AnnouncementIdApi?> getCurrentAnnouncementId() async {
    final response = await _dio.get(PlatformApiData.getPlaylistIdUrl);
    if (response.statusCode == 200) {
      final data = response.data;
      final currentAnnouncement = data["currentAnnouncement"];
      return currentAnnouncement != null ? AnnouncementIdApi.fromJson(currentAnnouncement) : null;
    }
    return null;
  }

  Future<PlaylistApi?> getPlaylist(String id) async {
    final response = await _dio.get(PlatformApiData.getPlaylistUrl(id));
    if (response.statusCode == 200) {
      final data = response.data;
      if (data["success"]) {
        final playlistData = data["playlistData"];
        return PlaylistApi.fromJson(playlistData);
      }
    }

    return null;
  }
}