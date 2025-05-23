import 'package:flutter/services.dart';

class NativeVolumeHandler {
  final MethodChannel _volumeChannel = const MethodChannel('volume');
  static const int maxVolume = 15;

  void setVolume(int level) {
    _volumeChannel.invokeMethod('setCallVolume', {"level": 15});
  }
}