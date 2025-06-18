import 'package:package_info_plus/package_info_plus.dart';
import 'package:voice_interaction/data/services/update_service.dart';
import 'package:voice_interaction/domain/models/version_info.dart';

class UpdateRepository {
  final UpdateService _updateService;

  UpdateRepository({required UpdateService updateService}) : _updateService = updateService;

  Future<bool> checkForUpdate() async {
    try {
      final VersionInfo latestVersion = await _updateService.getLatestVersion();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      return latestVersion.tagName.replaceAll("v", '') != currentVersion;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateApp({void Function(int count, int total)? onProgress}) async {
    final VersionInfo latestVersion = await _updateService.getLatestVersion();
    await _updateService.downloadAndInstall( latestVersion, onProgress: onProgress);
  }
}