part of 'media_player_view_model.dart';

abstract class MediaPlayerEvent {}

class StartUpdateCheck extends MediaPlayerEvent {}

class StopUpdateCheck extends MediaPlayerEvent {}

class CheckForUpdate extends MediaPlayerEvent {}

class DownloadUpdates extends MediaPlayerEvent {}

class DownloadProgress extends MediaPlayerEvent {
  final int curFile;
  final int totalFiles;
  final double? percent;

  DownloadProgress({
    required this.curFile,
    required this.totalFiles,
    required this.percent
  });
}