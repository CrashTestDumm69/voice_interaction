import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/playlist_repository.dart';
import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';

part 'media_player_event.dart';
part 'media_player_state.dart';

class MediaPlayerViewModel extends Bloc<MediaPlayerEvent, MediaPlayerState> {
  final PlaylistRepository _playlistRepository;

  Playlist? _playlist;
  int _currentMediaIndex = -1;

  MediaPlayerViewModel({
    required PlaylistRepository playlistRepository
  }) : _playlistRepository = playlistRepository,
       super(MediaPlayerInitial()) {

    _playlist = _playlistRepository.currentPlaylist;

    on<PlayNextMedia>((event, emit) {
      if (_playlist == null) {
        emit(MediaError(message: "No playlist available"));
        return;
      }
      _currentMediaIndex++;
      if (_currentMediaIndex >= _playlist!.files.length) {
        _currentMediaIndex = 0;
      }

      final PlaylistFile currentFile = _playlist!.files[_currentMediaIndex];
      if (currentFile.isAudio) {
        emit(
          PlayAudio(
            filePath: currentFile.filePath,
            backgroundImagePath: currentFile.hasBackgroundImage ? currentFile.imageFilePath! : "",
            hasImage: currentFile.hasBackgroundImage
          )
        );
      } else if (currentFile.isVideo) {
        emit(PlayVideo(filePath: currentFile.filePath));
      }
    });

    on<CheckForUpdate>((event, emit) async {
      if (await _playlistRepository.checkForUpdate()) {
        add(DownloadUpdates());
      } else {
        _currentMediaIndex = -1;
        add(PlayNextMedia());
      }
    });

    on<DownloadUpdates>((event, emit) async {
      emit(MediaDownloading());
      await _playlistRepository.downloadUpdates();
      if(!await _playlistRepository.checkMissingFiles()) {
        _currentMediaIndex = -1;
        add(PlayNextMedia());
      } else {
        emit(MediaError(message: "Download corrupted"));
      }
    });
  }
}