import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:voice_interaction/data/services/update_service.dart';
import 'package:voice_interaction/domain/models/version/version.dart';

class UpdateRepository {
  final UpdateService _updateService;

  UpdateRepository({required UpdateService updateService}) : _updateService = updateService;

  Future<Version?> checkForUpdate() async {
    try {
      final Version latestVersion = await _updateService.getLatestVersion();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);
      return latestVersion > currentVersion ? latestVersion : null;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<void> downloadUpdate({void Function(int count, int total)? onProgress}) async {
    try {
      await _updateService.downloadLatest(onProgress: onProgress);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateApp() async {
    await _updateService.installLatest();
  }
}