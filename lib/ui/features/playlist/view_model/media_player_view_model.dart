import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/playlist_repository.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';

part 'media_player_event.dart';
part 'media_player_state.dart';

class MediaPlayerViewModel extends Bloc<MediaPlayerEvent, MediaPlayerState> {
  final PlaylistRepository _playlistRepository;

  Playlist? _playlist;
  Timer? _updateCheckTimer;

  MediaPlayerViewModel({
    required PlaylistRepository playlistRepository
  }) : _playlistRepository = playlistRepository,
       super(MediaPlayerInitial()) {

    _playlist = _playlistRepository.currentPlaylist;

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
              files: _playlist!.files
                .map((e) => MediaFile(
                  filePath: e.filePath,
                  isVideo: e.isVideo,
                  isAudio: e.isAudio,
                  hasImage: e.hasBackgroundImage,
                  imageFilePath: e.imageFilePath,
                  delay: e.delay
                ))
                .toList()
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
      if(!await _playlistRepository.checkMissingFiles()) {
        if (_playlist == null) {
          emit(MediaError(message: "No playlist available"));
        } else {
          emit(
            MediaReady(
              files: _playlist!.files
                .map((e) => MediaFile(
                  filePath: e.filePath,
                  isVideo: e.isVideo,
                  isAudio: e.isAudio,
                  hasImage: e.hasBackgroundImage,
                  imageFilePath: e.imageFilePath,
                  delay: e.delay
                ))
                .toList()
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