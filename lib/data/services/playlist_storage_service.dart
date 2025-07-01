import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_type.dart';
import 'package:voice_interaction/utils/hive_registrar.g.dart';

class PlaylistStorageService {
  static const String _playlistBoxKey = "playlist";
  static const String _announcementBoxKey = "announcement";

  late final Box _playlistBox;

  final Dio _dio;

  PlaylistStorageService({required Dio dio}) : _dio = dio;

  Future<void> initService() async {
    final directory = await getApplicationSupportDirectory();
    Hive
      ..init("${directory.path}/boxes")
      ..registerAdapters();
    _playlistBox = await Hive.openBox<Playlist>(_playlistBoxKey);
  }

  Future<void> close() async {
    await _playlistBox.close();
  }

  Future<void> store(Playlist playlist) async {
    if (playlist.contentType == PlaylistType.playlist) {
      await _playlistBox.put(_playlistBoxKey, playlist);
    } else {
      await _playlistBox.put(_announcementBoxKey, playlist);
    }
    
    for (PlaylistFile file in playlist.files) {
      final localFile = File(file.filePath);
      if (!(await localFile.exists())) {
        await _dio.download(file.fileUrl, file.filePath);
      }

      if (file.type == 'audio' && file.imageUrl != null) {
        await _dio.download(file.imageUrl!, file.imageFilePath);
      }
    }
  }

  Future<Playlist?> getCurrentPlaylist() async {
    final Playlist? playlist = _playlistBox.get(_playlistBoxKey);
    return playlist;
  }

  Future<Playlist?> getCurrentAnnouncement() async {
    final Playlist? announcement = _playlistBox.get(_announcementBoxKey);
    return announcement;
  } 

  Future<void> deletePlaylist() async {
    final Playlist? currentPlaylist = await getCurrentPlaylist();
    
    if (currentPlaylist == null) {
      return;
    }
    
    for (final PlaylistFile file in currentPlaylist.files) {
      final localFile = File(file.filePath);
      if (await localFile.exists()) {
        await localFile.delete();
      }
    }
    
    await _playlistBox.delete(_playlistBoxKey);
  }

  Future<void> deleteAnnouncement() async {
    final Playlist? currentAnnouncement = await getCurrentAnnouncement();
    
    if (currentAnnouncement == null) {
      return;
    }
    
    for (final PlaylistFile file in currentAnnouncement.files) {
      final localFile = File(file.filePath);
      if (await localFile.exists()) {
        await localFile.delete();
      }
    }
    
    await _playlistBox.delete(_announcementBoxKey);
  }

  Future<bool> checkPlaylistFiles() async {
    final Playlist? playlist = await getCurrentPlaylist();

    if (playlist == null) {
      return true;
    }

    for (PlaylistFile file in playlist.files) {
      final localFile = File(file.filePath);
      if (!await localFile.exists()) {
        return false;
      }

      if (file.type == "audio" && file.imageFilePath != null) {
        if(!await File(file.imageFilePath!).exists()) {
          return false;
        }
      }
    }

    return true;
  }

  Future<bool> checkAnnouncementFiles() async {
    final Playlist? announcement = await getCurrentAnnouncement();

    if (announcement == null) {
      return true;
    }

    for (PlaylistFile file in announcement.files) {
      final localFile = File(file.filePath);
      if (!await localFile.exists()) {
        return false;
      }

      if (file.type == "audio" && file.imageFilePath != null) {
        if(!await File(file.imageFilePath!).exists()) {
          return false;
        }
      }
    }

    return true;
  }
}