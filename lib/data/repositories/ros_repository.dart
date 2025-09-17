import 'dart:async';

import 'package:voice_interaction/data/services/ros_service.dart';

class RosRepository {
  final RosService _rosService;

  RosRepository({
    required RosService rosService,
  }) : _rosService = rosService;
  
  static const String speechStartMessage = "remote_start";
  static const String speechStopMessage = "remote_stop";
  static const String blockCodeEnableMessage = "Enable";
  static const String blockCodeDisableMessage = "Disable";

  static const String url = "ws://c20000002.local:9090";

  String _armActions = "";

  Stream<List<String>> get armActionsStream => _armActionsController.stream;
  final _armActionsController = StreamController<List<String>>.broadcast();

  Stream<double> get batteryStateStream => _batteryStateController.stream;
  final _batteryStateController = StreamController<double>.broadcast();

  void init() {
    _rosService.init(url);
    _subscribeArmActions();
    _subscribeBatteryState();
  }

  void speechStart() {
    _rosService.publishSpeechString(speechStartMessage);
  }

  void speechStop() {
    _rosService.publishSpeechString(speechStopMessage);
  }

  void blockCodeEnable() {
    _rosService.publishBlockCodeString(blockCodeEnableMessage);
  }

  void blockCodeDisable() {
    _rosService.publishBlockCodeString(blockCodeDisableMessage);
  }

  void sendArmAction(String action) {
    _rosService.sendArmAction(action);
  }

  void _subscribeArmActions() {
    _rosService.subscribeArmActionsString((data) {
      if (data == _armActions) return;
      _armActions = data;
      final actions = data.split(',');
      _armActionsController.add(actions);
    });
  }

  void _subscribeBatteryState() {
    _rosService.subscribeBatteryState((data) {
      _batteryStateController.add(data);
    });
  }
}