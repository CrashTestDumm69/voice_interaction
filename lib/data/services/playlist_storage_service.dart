import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';

class PlaylistStorageService {
  static const String _playlistBoxKey = "playlist";
  static const String _announcementBoxKey = "announcement";

  late final Box<Playlist> _playlistBox;

  final Dio _dio;

  PlaylistStorageService({required Dio dio}) : _dio = dio;

  Future<void> initService() async {
    _playlistBox = await Hive.openBox<Playlist>(_playlistBoxKey);
  }

  Future<void> close() async {
    await _playlistBox.close();
  }

  Future<void> store(
    Playlist playlist, {
    Function(int currentFile, int totalFiles, double percent)? onProgress,
  }) async {
    if (playlist.isPlaylist) {
      await _playlistBox.put(_playlistBoxKey, playlist);
    } else if (playlist.isAnnouncement) {
      await _playlistBox.put(_announcementBoxKey, playlist);
    } else {
      return;
    }

    final List<String> filesToDownload = [];

    for (PlaylistFile file in playlist.files) {
      final localFile = File(file.filePath);
      if (!(await localFile.exists())) {
        filesToDownload.add(file.filePath);
      }

      if (file.isAudio && file.hasBackgroundImage) {
        final imageFile = File(file.imageFilePath!);
        if (!(await imageFile.exists())) {
          filesToDownload.add(file.imageFilePath!);
        }
      }
    }

    final totalFiles = filesToDownload.length;
    if (totalFiles == 0) return;

    int currentFile = 0;

    for (PlaylistFile file in playlist.files) {
      final localFile = File(file.filePath);
      if (!(await localFile.exists())) {
        currentFile++;
        await _dio.download(
          file.fileUrl,
          file.filePath,
          onReceiveProgress: (count, total) {
            final percent = ((count / total) * 100);
            onProgress?.call(currentFile, totalFiles, percent);
          },
        );
      }

      if (file.isAudio && file.hasBackgroundImage) {
        final imageFile = File(file.imageFilePath!);
        if (!(await imageFile.exists())) {
          currentFile++;
          await _dio.download(
            file.imageUrl!,
            file.imageFilePath,
            onReceiveProgress: (count, total) {
              final percent = ((count / total) * 100);
              onProgress?.call(currentFile, totalFiles, percent);
            },
          );
        }
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

  Future<bool> checkMissingPlaylistFiles() async {
    final Playlist? playlist = await getCurrentPlaylist();

    if (playlist == null) {
      return false;
    }

    for (PlaylistFile file in playlist.files) {
      final localFile = File(file.filePath);
      if (!await localFile.exists()) {
        return true;
      }

      if (file.isAudio && file.hasBackgroundImage) {
        if (!await File(file.imageFilePath!).exists()) {
          return true;
        }
      }
    }

    return false;
  }

  Future<bool> checkMissingAnnouncementFiles() async {
    final Playlist? announcement = await getCurrentAnnouncement();

    if (announcement == null) {
      return false;
    }

    for (PlaylistFile file in announcement.files) {
      final localFile = File(file.filePath);
      if (!await localFile.exists()) {
        return true;
      }

      if (file.isAudio && file.hasBackgroundImage) {
        if (!await File(file.imageFilePath!).exists()) {
          return true;
        }
      }
    }

    return false;
  }
}
