part of 'media_player_view_model.dart';

abstract class MediaPlayerEvent {}

class PlayNextMedia extends MediaPlayerEvent {}

class CheckForUpdate extends MediaPlayerEvent {}

class DownloadUpdates extends MediaPlayerEvent {}