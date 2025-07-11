import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/playlist_repository.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';

part 'media_player_event.dart';
part 'media_player_state.dart';

class MediaFile {
  final String filePath;
  final String? imageFilePath;
  final bool isVideo;
  final bool isAudio;
  final bool hasImage;
  final int delay;
  
  MediaFile({
    required this.filePath,
    this.imageFilePath,
    required this.isVideo,
    required this.isAudio,
    required this.hasImage,
    required this.delay,
  });
}

class MediaPlayerViewModel extends Bloc<MediaPlayerEvent, MediaPlayerState> {
  final PlaylistRepository _playlistRepository;

  Playlist? _playlist;
  Playlist? _announcement;
  Timer? _updateCheckTimer;

  MediaPlayerViewModel({
    required PlaylistRepository playlistRepository
  }) : _playlistRepository = playlistRepository,
       super(MediaPlayerInitial()) {

    _playlist = _playlistRepository.currentPlaylist;
    _announcement = _playlistRepository.currentAnnouncement;

    on<StartUpdateCheck>((event, emit) {
      _startPeriodicUpdateCheck();
    });

    on<StopUpdateCheck>((event, emit) {
      _stopPeriodicUpdateCheck();
      emit(MediaPlayerInitial());
    });

    on<CheckForUpdate>((event, emit) async {
      if (await _playlistRepository.checkForUpdate()) {
        emit(MediaPlayerInitial());
        _stopPeriodicUpdateCheck();
        add(DownloadUpdates());
      } else {
        if (state is! MediaReady && _playlist != null) {
          emit(
            MediaReady(
              playlistFiles: _convertToMediaFiles(_playlist),
              announcementFiles: _convertToMediaFiles(_announcement)
            )
          );
        }
      }
    });

    on<DownloadUpdates>((event, emit) async {
      emit(
        MediaDownloading(
          curFile: 0,
          totalFiles: 0,
          percent: null
        )
      );
      await _playlistRepository.downloadUpdates(
        onProgress: (currentFile, totalFiles, percent) {
          add(
            DownloadProgress(
              curFile: currentFile,
              totalFiles: totalFiles,
              percent: percent
            )
          );
        }
      );
      _playlist = _playlistRepository.currentPlaylist;
      _announcement = _playlistRepository.currentAnnouncement;
      
      if(!await _playlistRepository.checkMissingFiles()) {
        if (_playlist == null) {
          emit(MediaError(message: "No playlist available"));
        } else {
          emit(
            MediaReady(
              playlistFiles: _convertToMediaFiles(_playlist),
              announcementFiles: _convertToMediaFiles(_announcement)
            )
          );
        }
      } else {
        emit(MediaError(message: "Download corrupted. Please wait"));
      }

      _startPeriodicUpdateCheck();
    });

    on<DownloadProgress>((event, emit) {
      emit(
        MediaDownloading(
          curFile: event.curFile,
          totalFiles: event.totalFiles,
          percent: event.percent
        )
      );
    });
  }

  List<MediaFile> _convertToMediaFiles(Playlist? playlist) {
    if (playlist != null) {
      return playlist.files.map((e) => MediaFile(
        filePath: e.filePath,
        isVideo: e.isVideo,
        isAudio: e.isAudio,
        hasImage: e.hasBackgroundImage,
        imageFilePath: e.imageFilePath,
        delay: e.delay)).toList();
    } else {
      return [];
    }
  }

  void _startPeriodicUpdateCheck() {
    _updateCheckTimer?.cancel();
    _updateCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      add(CheckForUpdate());
    });
  }

  void _stopPeriodicUpdateCheck() {
    _updateCheckTimer?.cancel();
    _updateCheckTimer = null;
  }

  @override
  Future<void> close() {
    _stopPeriodicUpdateCheck();
    return super.close();
  }
}