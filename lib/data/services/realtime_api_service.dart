import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:voice_interaction/config/realtime_api_data.dart';
import 'package:voice_interaction/config/realtime_api_response_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/utils/native_volume_handler.dart';

enum RealtimeConnectionState {
  connected,
  disconnected,
  connecting
}

enum SpeechState {
  idle,
  speaking,
  listening
}

class RealtimeApiService {
  late final String apiKey;
  RTCPeerConnection? _connection;
  RTCDataChannel? _dataChannel;
  MediaStream? _audioStream;
  final Dio dio = Dio();
  Timer? _inactivityTimer;
  final PackageHandlerService _packageService = PackageHandlerService();
  final NativeVolumeHandler _volumeHandler = NativeVolumeHandler();

  bool _isMicMuted = true;
  bool get isMicMuted => _isMicMuted;

  final _connectionStateController = StreamController<RealtimeConnectionState>.broadcast();
  Stream<RealtimeConnectionState> get connectionState => _connectionStateController.stream.asBroadcastStream(
    onListen: (subscription) {
      _connectionStateController.add(RealtimeConnectionState.disconnected);
    }
  );

  final _speachStateController = StreamController<SpeechState>.broadcast();
  Stream<SpeechState> get speechState => _speachStateController.stream.asBroadcastStream(
    onListen: (subscription) {
      _speachStateController.add(SpeechState.idle);
    },
  );

  Future<void> initConnection(String instruction) async {
    _connectionStateController.add(RealtimeConnectionState.connecting);
    
    await dotenv.load(fileName: ".env");
    apiKey = dotenv.env["OPENAI_API_KEY"] ?? "";
    
    _volumeHandler.setVolume(NativeVolumeHandler.maxVolume);

    await _packageService.loadPackages();

    final config = {
      'iceServers': [
        {'urls': ['stun:stun1.l.google.com:19302']}
      ]
    };
    _connection = await createPeerConnection(config);

    _connection!.onConnectionState = (state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _connectionStateController.add(RealtimeConnectionState.connected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _connectionStateController.add(RealtimeConnectionState.disconnected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          _connectionStateController.add(RealtimeConnectionState.connecting);
          break;
        default:
          break;
      }
    };

    _audioStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    _audioStream!.getTracks().forEach((track) {
      track.enabled = false;
      debugPrint("Track - ${track.label}");
      debugPrint("Kind - ${track.kind}");
      debugPrint("ID - ${track.getSettings()}");
      _connection!.addTrack(track, _audioStream!);
    });

    _dataChannel = await _connection!.createDataChannel('oai-events', RTCDataChannelInit());
    
    RTCSessionDescription offer = await _connection!.createOffer();
    await _connection!.setLocalDescription(offer);

    late final Response secretResponse;
    try {
      secretResponse = await dio.post(
        RealtimeApiData.realtimeAPISessionsUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode({
          "model": RealtimeApiData.realtimeAPIModelVersion,
          "voice": RealtimeApiData.voice,
          "instructions": instruction,
          "turn_detection": {
            "type": "server_vad",
            "threshold": 0.8,
            "silence_duration_ms": 1000,
          },
          "tools": RealtimeApiData.tools,
          "tool_choice": "auto",
          "max_response_output_tokens": 4096,
        }),
      );

      _dataChannel?.onMessage = (msg) {
        final data = jsonDecode(msg.text);
        final String type = data["type"];
        _resetInactivityTimer();

        if (type == RealtimeApiResponseTypes.sessionCreated) {
          debugPrint("Session created");
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStarted) {
          debugPrint("Robo Speaking");
          _speachStateController.add(SpeechState.speaking);
          _inactivityTimer?.cancel();
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStopped) {
          debugPrint("Robo done");
          _speachStateController.add(SpeechState.listening);
          _resetInactivityTimer();
        } else if (type == RealtimeApiResponseTypes.inputSpeechStarted) {
          debugPrint("User heard");
          _speachStateController.add(SpeechState.listening);
        } else if (type == RealtimeApiResponseTypes.functionCallArgumentsDone) {
          callFunction(data["name"] as String, data["arguments"] as String, data["call_id"] as String);
        } else if (type == RealtimeApiResponseTypes.error) {
          debugPrint("Error - $data");
        }
      };
    } catch (e) {
      debugPrint("Failed to create session: $e");
      debugPrint("Response - ${secretResponse.data}");
      return;
    }

    late final String secret;
    if (secretResponse.statusCode == 200) {
      Map<String, dynamic> res = secretResponse.data;
      secret = res["client_secret"]["value"];
    } else {
      debugPrint("Failed to get secret key: ${secretResponse.data}");
      return;
    }

    late final Response response;
    try {
      response = await dio.post(
        "${RealtimeApiData.realtimeAPIBaseUrl}?model=${RealtimeApiData.realtimeAPIModelVersion}",
        options: Options(
          headers: {
            "Authorization": "Bearer $secret",
            "Content-Type": "application/sdp",
          },
        ),
        data: offer.sdp,
      );
    } catch (e) {
      debugPrint("Failed to send offer: $e");
      return;
    }

    final answer = RTCSessionDescription(response.data, "answer");
    await _connection!.setRemoteDescription(answer);
  }

  Future<Map<String, dynamic>> callFunction(String functionName, String arguments, String callId) async {
    final args = jsonDecode(arguments);
    Map<String, dynamic> returnData;

    if (functionName == "get_healthcare_package") {
      final String? packageName = args["package_name"];
      debugPrint("Package name - $packageName");

      if (packageName == null) {
        debugPrint("Package name is null");
        final msg = {
          "type": "conversation.item.create",
          "item": {
            "type": "function_call_output",
            "call_id": callId,
            "output": {
              "status": "failed",
              "data": "No packages available"
            }
          }
        };
        RTCDataChannelMessage sendMsg = RTCDataChannelMessage(jsonEncode(msg));
        await _dataChannel?.send(sendMsg);
        returnData = {
          "status": "failed",
          "data": "No packages available"
        };
      } else if (_packageService.packageNames.contains(packageName)) {
        final package = _packageService.packages.firstWhere((pkg) => pkg.package == packageName);
        final msg = {
          "type": "conversation.item.create",
          "item": {
            "type": "function_call_output",
            "call_id": callId,
            "output": jsonEncode({
              "status": "success",
              "data": package.toJson()
            })
          }
        };
        RTCDataChannelMessage sendMsg = RTCDataChannelMessage(jsonEncode(msg));
        await _dataChannel?.send(sendMsg);
        returnData = {
          "status": "success",
          "data": package.toJson()
        };
      } else {
        debugPrint("Package not found");
        final msg = {
          "type": "conversation.item.create",
          "item": {
            "type": "function_call_output",
            "call_id": callId,
            "output": {
              "status": "failed",
              "data": "Package not found",
            }
          }
        };
        RTCDataChannelMessage sendMsg = RTCDataChannelMessage(jsonEncode(msg));
        await _dataChannel?.send(sendMsg);
        returnData = {
          "status": "failed",
          "data": "Package not found"
        };
      }
    } else {
      returnData = {
        "status": "failed",
        "data": "Function not found"
      };
    }
    await _dataChannel?.send(RTCDataChannelMessage(jsonEncode({"type": "response.create"})));

    return returnData;
  }

  void muteMic() {
    for (var track in _audioStream!.getTracks()) {
      track.enabled = false;
    }
    _isMicMuted = true;
  }

  void unmuteMic() {
    for (var track in _audioStream!.getTracks()) {
      track.enabled = true;
    }
    _isMicMuted = false;
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 15), _handleInactivity);
  }

  void _handleInactivity() async {
    dispose();
  }

  void dispose() {
    _connection?.close();
    _dataChannel?.close();
    _audioStream?.dispose();
    _inactivityTimer?.cancel();
  }
}
