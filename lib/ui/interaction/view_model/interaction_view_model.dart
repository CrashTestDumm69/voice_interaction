import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rive/rive.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

class InteractionViewModel extends Notifier<void> {
  final RealtimeApiService service = RealtimeApiService();
  StateMachineController? controller;
  SMITrigger? bringMic;
  SMITrigger? bringMouth;
  SMITrigger? stopMouth;
  SMITrigger? stillAgain;

  bool isPlaying = false;
  Timer? _inactivityTimer;
  final Duration _inactivityDuration = const Duration(seconds: 15);
  final List<String> _conversationItems = [];

  Map<String, dynamic>? _packageDetails;
  Map<String, dynamic>? get packageDetails => _packageDetails;

  @override
  void build() {}

  Future<void> init() async {
    await _initService();
  }

  Future<void> _initService() async {
    await service.initConnection();
    service.dataChannel?.onMessage = (RTCDataChannelMessage msg) {
      final data = jsonDecode(msg.text);
      final String type = data["type"];

      if (type == "session.created") {
        debugPrint("Session created");
        return;
      }

      _resetInactivityTimer();

      if (type == "conversation.item.created") {
        final String itemId = data["item"]["id"];
        _conversationItems.add(itemId);
      } else if (type == "response.function_call_arguments.done") {
        _resetInactivityTimer();
        service.callFunction(data["name"] as String, data["arguments"] as String, data["call_id"] as String)
          .then((result) {
            if (result["status"] == "success" && result["data"] != null) {
              _packageDetails = result["data"];
              ref.notifyListeners();
            }
          });
      } else if (type == "output_audio_buffer.started") {
        _handleTrigger(bringMouth);
        _inactivityTimer?.cancel();
      } else if (type == "output_audio_buffer.stopped") {
        _handleTrigger(stopMouth);
        _resetInactivityTimer();
      } else if (type == "input_audio_buffer.speech_started") {
        _handleTrigger(stopMouth);
      }
    };

    service.dataChannel?.onDataChannelState = (RTCDataChannelState state) {
      if (state == RTCDataChannelState.RTCDataChannelClosed) {
        debugPrint("Data channel closed, restarting connection");
        dispose();
        init();
      }
    };
  }

  void clearPackageDetails() {
    _packageDetails = null;
    _resetInactivityTimer();
    ref.notifyListeners();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (_packageDetails == null) {
      _inactivityTimer = Timer(_inactivityDuration, () async {
        service.muteMic();
        debugPrint("Inactivity triggered");
        _handleTrigger(stillAgain);
        await service.clearHistory(_conversationItems);
        _conversationItems.clear();
      });
    }
  }

  void onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine (robot speaks)',
    );

    if (controller != null) {
      artboard.addController(controller!);
      bringMic = controller!.getTriggerInput('bring mic');
      bringMouth = controller!.getTriggerInput('bring mouth');
      stopMouth = controller!.getTriggerInput('stop mouth');
      stillAgain = controller!.getTriggerInput('still again');

      isPlaying = true;
    }
  }

  void _handleTrigger(SMITrigger? trigger) {
    trigger?.fire();
  }

  void unmuteMic() {
    service.unmuteMic();
    _handleTrigger(bringMic);
    _resetInactivityTimer();
  }

  void dispose() {
    _inactivityTimer?.cancel();
    service.dispose();
  }
}

final voiceInteractionProvider = NotifierProvider<InteractionViewModel, void>(InteractionViewModel.new);
