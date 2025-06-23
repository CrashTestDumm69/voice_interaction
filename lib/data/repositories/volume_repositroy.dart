import 'package:voice_interaction/data/services/native_volume_handler_service.dart';

class VolumeRepositroy {
  final NativeVolumeHandlerService _nativeVolumeHandlerService;

  VolumeRepositroy({required NativeVolumeHandlerService nativeVolumeHandlerService})
      : _nativeVolumeHandlerService = nativeVolumeHandlerService;

  Future<int> getVolume() async {
    final int currentVolume = await _nativeVolumeHandlerService.getCurrentVolume();
    return currentVolume;
  }

  Future<void> setVolume(int level) async {
    level.clamp(0, 15);
    await _nativeVolumeHandlerService.setVolume(level);
  }
}