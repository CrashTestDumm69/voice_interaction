import 'package:path_provider/path_provider.dart';

class PlatformApiData {
  static const String baseUrl = "https://cento-platform.vercel.app";
  static const String serialNumber = "test-cento";
  static const String getPlaylistIdUrl = "$baseUrl/api/device-playlists/serialNumber?serialNumber=$serialNumber";
  static String getPlaylistUrl(String id) {
    return "$baseUrl/api/get-playlist?id=$id";
  }

  static late final String _playlistPath;

  static String get playlistPath => _playlistPath;

  static Future<void> init() async {
    _playlistPath = "${(await getApplicationSupportDirectory()).path}/playlist_files";
  }
}