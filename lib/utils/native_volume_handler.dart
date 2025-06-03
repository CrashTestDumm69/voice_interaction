import 'package:flutter/services.dart';

class NativeVolumeHandler {
  static const MethodChannel _volumeChannel = MethodChannel('volume');
  static const int maxVolume = 15;

  static void setVolume(int level) {
    _volumeChannel.invokeMethod('setCallVolume', {"level": 15});
  }
}