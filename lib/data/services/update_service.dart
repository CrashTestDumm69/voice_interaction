import 'package:android_package_installer/android_package_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_interaction/domain/models/version_info.dart';

class UpdateService {
  Future<VersionInfo> getLatestVersion() async {
    try {
      final Dio dio = Dio();
      final response = await dio.get("https://api.github.com/repos/crashtestdumm69/flutter-releases/releases/latest");
    
      if (response.statusCode == 200) {
        return VersionInfo.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch latest version: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadAndInstall(VersionInfo app, {void Function(int count, int total)? onProgress}) async {
    final Dio dio = Dio();
    final fileDir = await getDownloadsDirectory();
    debugPrint(fileDir.toString());
    final filePath = "${fileDir?.path}/releases/latest.apk";
    await dio.download(app.browserDownloadUrl, filePath, onReceiveProgress: onProgress);
    await AndroidPackageInstaller.installApk(apkFilePath: filePath);
  }
}