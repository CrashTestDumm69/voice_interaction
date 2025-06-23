import 'package:voice_interaction/data/services/native_volume_handler_service.dart';

class VolumeRepositroy {
  final NativeVolumeHandlerService _nativeVolumeHandlerService;

  VolumeRepositroy({required NativeVolumeHandlerService nativeVolumeHandlerService})
      : _nativeVolumeHandlerService = nativeVolumeHandlerService;

  int get maxVolume => _nativeVolumeHandlerService.maxVolume;

  Future<int> getVolume() async {
    final int currentVolume = await _nativeVolumeHandlerService.getCurrentVolume();
    return currentVolume;
  }

  Future<void> setVolume(int level) async {
    level.clamp(0, maxVolume);
    await _nativeVolumeHandlerService.setVolume(level);
  }
}