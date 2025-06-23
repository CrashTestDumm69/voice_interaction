import 'package:flutter/services.dart';

class NativeVolumeHandlerService {
  static const MethodChannel _volumeChannel = MethodChannel('volume');

  int get maxVolume => 15;

  Future<void> setVolume(int level) async {
    await _volumeChannel.invokeMethod('setCallVolume', {"level": level});
  }

  Future<int> getCurrentVolume() async {
    final int current = await _volumeChannel.invokeMethod('getCurrentCallVolume');
    return current;
  }
}