import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/settings/settings.dart';
import 'package:voice_interaction/routing/routes.dart';

class SettingsStorageService {
  late final Box<Settings> _settingsBox;
  static const _settingsBoxKey = "settings";

  final Settings _defaultSettings = Settings(initialLocation: Routes.home);

  Future<void> init() async {
    _settingsBox = await Hive.openBox<Settings>(_settingsBoxKey); 
  }

  Future<void> changeSetting(Settings settings) async {
    await _settingsBox.delete(_settingsBoxKey);
    await _settingsBox.put(_settingsBoxKey, settings);
  }

  Settings getCurrentSettings() {
    return _settingsBox.get(_settingsBoxKey) ?? _defaultSettings;
  }
}