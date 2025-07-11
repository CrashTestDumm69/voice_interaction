part of 'media_player_view_model.dart';

abstract class MediaPlayerState {}

class MediaPlayerInitial extends MediaPlayerState {}

class MediaDownloading extends MediaPlayerState {
  final int curFile;
  final int totalFiles;
  final double? percent;

  MediaDownloading({
    required this.curFile,
    required this.totalFiles,
    required this.percent,
  });
}

class MediaError extends MediaPlayerState {
  final String message;

  MediaError({
    required this.message
  });
}

class MediaReady extends MediaPlayerState {
  final List<MediaFile> playlistFiles;
  final List<MediaFile> announcementFiles;

  MediaReady({
    required this.playlistFiles,
    required this.announcementFiles
  });
}