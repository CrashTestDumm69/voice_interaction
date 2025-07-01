part of 'media_player_view_model.dart';

abstract class MediaPlayerState {}

class MediaPlayerInitial extends MediaPlayerState {}

class MediaDownloading extends MediaPlayerState {}

class MediaDelay extends MediaPlayerState {}

class MediaError extends MediaPlayerState {
  final String message;

  MediaError({
    required this.message
  });
}

abstract class PlayMedia extends MediaPlayerState {
  final String filePath;

  PlayMedia({
    required this.filePath
  });
}

class PlayVideo extends PlayMedia {
  PlayVideo({
    required super.filePath
  });
}

class PlayAudio extends PlayMedia {
  final String backgroundImagePath;
  final bool hasImage;
  
  PlayAudio({
    required super.filePath,
    required this.backgroundImagePath,
    required this.hasImage
  });
}