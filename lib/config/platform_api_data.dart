import 'package:path_provider/path_provider.dart';

class PlatformApiData {
  static const String baseUrl = "http://10.71.172.247:3000";
  static const String serialNumber = "1234";
  static const String getPlaylistIdUrl = "$baseUrl/api/device-playlists/serialNumber?serialNumber=$serialNumber";
  static String getPlaylistUrl(String id) {
    return "$baseUrl/api/get-playlist?id=$id";
  }

  static late final String playlistPath;

  static Future<void> init() async {
    playlistPath = "${(await getApplicationSupportDirectory()).path}/playlist_files";
  }
}