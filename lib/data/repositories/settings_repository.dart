import 'package:voice_interaction/data/services/settings_storage_service.dart';
import 'package:voice_interaction/domain/models/settings/settings.dart';

class SettingsRepository {
  final SettingsStorageService _settingsStorageService;

  SettingsRepository({
    required SettingsStorageService settingsStorageService
  }) : _settingsStorageService = settingsStorageService;

  Settings get currentSettings => _getCurrentSettings();

  Future<void> init() async {
    await _settingsStorageService.init();
  }

  Settings _getCurrentSettings() {
    return _settingsStorageService.getCurrentSettings();
  }

  void changeInitialLocation(String location) {
    final settings = currentSettings.copyWith(initialLocation: location);
    _settingsStorageService.changeSetting(settings);
  }
}