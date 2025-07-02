import 'dart:async';

import 'package:flutter/foundation.dart';

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

      debugPrint(remotePlaylistId.toString());
      debugPrint(localPlaylist.toString());

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

      debugPrint((_playlistUpdateAvailable || _announcementUpdateAvailable).toString());

      return (_playlistUpdateAvailable || _announcementUpdateAvailable);

    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  Future<void> downloadUpdates() async {
    debugPrint("Starting download");
    try {
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

        final Playlist playlist = Playlist.fromJson(remotePlaylist.toJson());
        await _playlistStorageService.store(playlist);

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

        final Playlist announcement = Playlist.fromJson(remoteAnnouncement.toJson());
        await _playlistStorageService.store(announcement);

        _announcementUpdateAvailable = false;
      }

      debugPrint("Updates done");

      await loadPlaylists();

    } catch (e) {
      debugPrint("Error downloading updates: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> checkMissingFiles() async {
    try {
      _playlistUpdateAvailable = await _playlistStorageService.checkMissingPlaylistFiles();
      _announcementUpdateAvailable = await _playlistStorageService.checkMissingAnnouncementFiles();

      return (_playlistUpdateAvailable || _announcementUpdateAvailable);
    } catch (e) {
      debugPrint("Error checking files: $e");
      return false;
    }
  }

  Future<void> loadPlaylists() async {
    _currentPlaylist = await _playlistStorageService.getCurrentPlaylist();
    _currentAnnouncement = await _playlistStorageService.getCurrentAnnouncement();

    debugPrint(currentPlaylist.toString());
  }
}