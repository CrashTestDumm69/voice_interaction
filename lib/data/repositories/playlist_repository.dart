import 'dart:async';

import 'package:voice_interaction/data/services/playlist_api_service.dart';
import 'package:voice_interaction/data/services/playlist_storage_service.dart';
import 'package:voice_interaction/domain/models/announcement_id_api/announcement_id_api.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist_api/playlist_api.dart';
import 'package:voice_interaction/domain/models/playlist_id_api/playlist_id_api.dart';

class PlaylistRepository {
  final PlaylistApiService _playlistApiService;
  final PlaylistStorageService _playlistStorageService;

  PlaylistRepository({
    required PlaylistApiService playlistApiService,
    required PlaylistStorageService playlistStorageService
  }) : _playlistApiService = playlistApiService,
      _playlistStorageService = playlistStorageService;

  bool _playlistUpdateAvailable = false;
  bool _announcementUpdateAvailable = false;

  Playlist? _currentPlaylist;
  Playlist? _currentAnnouncement;

  Playlist? get currentPlaylist => _currentPlaylist;
  Playlist? get currentAnnouncement => _currentAnnouncement;

  Future<bool> checkForUpdate() async {
    try {
      final PlaylistIdApi? remotePlaylistId = await _playlistApiService.getCurrentPlaylistId();
      final Playlist? localPlaylist = currentPlaylist;

      final AnnouncementIdApi? remoteAnnouncementId = await _playlistApiService.getCurrentAnnouncementId();
      final Playlist? localAnnouncement = currentAnnouncement;

      if (remotePlaylistId != null && localPlaylist == null) {
        _playlistUpdateAvailable = true;
      } else if (remotePlaylistId == null && localPlaylist != null) {
        _playlistUpdateAvailable = true;
      } else if (remotePlaylistId == null && localPlaylist == null) {
        _playlistUpdateAvailable = false;
      } else if (remotePlaylistId!.playlistId == localPlaylist!.id && remotePlaylistId.versionId == localPlaylist.versionId) {
        _playlistUpdateAvailable = false;
      } else {
        _playlistUpdateAvailable = true;
      }

      if (remoteAnnouncementId != null && localAnnouncement == null) {
        _announcementUpdateAvailable = true;
      } else if (remoteAnnouncementId == null && localAnnouncement != null) {
        _announcementUpdateAvailable = true;
      } else if (remoteAnnouncementId == null && localAnnouncement == null) {
        _announcementUpdateAvailable = false;
      } else if (remoteAnnouncementId!.announcementId == localAnnouncement!.id && remoteAnnouncementId.versionId == localAnnouncement.versionId) {
        _announcementUpdateAvailable = false;
      } else {
        _announcementUpdateAvailable = true;
      }

      return (_playlistUpdateAvailable || _announcementUpdateAvailable);

    } catch (e) {
      return false;
    }
  }

  Future<void> downloadUpdates({Function(int currentFile, int totalFiles, double percent)? onProgress}) async {
    try {
      int totalFiles = 0;
      int currentFileCount = 0;
      
      Playlist? playlist;
      Playlist? announcement;

      if (_playlistUpdateAvailable) {
        await _playlistStorageService.deletePlaylist();

        final PlaylistIdApi? remotePlaylistId  = await _playlistApiService.getCurrentPlaylistId();
        if (remotePlaylistId == null) {
          return;
        }
        
        final PlaylistApi? remotePlaylist = await _playlistApiService.getPlaylist(remotePlaylistId.playlistId);

        if (remotePlaylist == null) {
          throw Exception("Failed to get playlist");
        }

        playlist = Playlist.fromJson(remotePlaylist.toJson());
        totalFiles += playlist.files.length;

        _playlistUpdateAvailable = false;
      }

      if (_announcementUpdateAvailable) {
        await _playlistStorageService.deleteAnnouncement();

        final AnnouncementIdApi? remoteAnnouncementId  = await _playlistApiService.getCurrentAnnouncementId();
        if (remoteAnnouncementId == null) {
          return;
        }
        
        final PlaylistApi? remoteAnnouncement = await _playlistApiService.getPlaylist(remoteAnnouncementId.announcementId);

        if (remoteAnnouncement == null) {
          throw Exception("Failed to get playlist");
        }

        announcement = Playlist.fromJson(remoteAnnouncement.toJson());
        totalFiles += announcement.files.length;

        _announcementUpdateAvailable = false;
      }

      if (playlist != null) {
        await _playlistStorageService.store(playlist, onProgress: (currentFile, _, percent) {
          currentFileCount = currentFile;
          onProgress?.call(currentFileCount, totalFiles, percent);
        });
      }

      if (announcement != null) {
        await _playlistStorageService.store(announcement, onProgress: (currentFile, _, percent) {
          final adjustedCount = currentFileCount + currentFile;
          onProgress?.call(adjustedCount, totalFiles, percent);
        });
      }

      await loadPlaylists();

    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkMissingFiles() async {
    try {
      _playlistUpdateAvailable = await _playlistStorageService.checkMissingPlaylistFiles();
      _announcementUpdateAvailable = await _playlistStorageService.checkMissingAnnouncementFiles();

      return (_playlistUpdateAvailable || _announcementUpdateAvailable);
    } catch (e) {
      return false;
    }
  }

  Future<void> loadPlaylists() async {
    _currentPlaylist = await _playlistStorageService.getCurrentPlaylist();
    _currentAnnouncement = await _playlistStorageService.getCurrentAnnouncement();
  }
}