import 'package:android_package_installer/android_package_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_interaction/domain/models/version/version.dart';

class UpdateService {
  Future<Version> getLatestVersion() async {
    try {
      final Dio dio = Dio();
      final response = await dio.get("https://api.github.com/repos/crashtestdumm69/flutter-releases/releases/latest");
    
      if (response.statusCode == 200) {
        final version = (response.data["tag_name"] as String).replaceAll("v", "");
        return Version.parse(version);
      } else {
        throw Exception("Failed to fetch latest version: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadLatest({void Function(int count, int total)? onProgress}) async {
    final Dio dio = Dio();
    final fileDir = await getApplicationSupportDirectory();
    debugPrint(fileDir.toString());
    final filePath = "${fileDir.path}/releases/latest.apk";
    final response = await dio.get("https://api.github.com/repos/crashtestdumm69/flutter-releases/releases/latest");
    throwIf(response.statusCode != 200, "Update failed");
    final asset = (response.data["assets"] as List<dynamic>).first;
    final downloadUrl = asset["browser_download_url"];
    await dio.download(downloadUrl, filePath, onReceiveProgress: onProgress);
  }

  Future<void> installLatest() async {
    final fileDir = await getApplicationSupportDirectory();
    final filePath = "${fileDir.path}/releases/latest.apk";
    await AndroidPackageInstaller.installApk(apkFilePath: filePath);
  }
}