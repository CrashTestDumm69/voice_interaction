import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:voice_interaction/config/realtime_api_config.dart';
import 'package:voice_interaction/config/realtime_api_response_types.dart';
import 'package:voice_interaction/data/services/realtime_api_tools_service.dart';

class RealtimeApiService {
  RTCPeerConnection? _connection;
  RTCDataChannel? _dataChannel;
  MediaStream? _audioStream;
  final Dio _dio;
  final RealtimeApiToolsService _realtimeApiToolsService;

  RealtimeApiService({required RealtimeApiToolsService realtimeApiToolsService, required Dio dio})
      : _realtimeApiToolsService = realtimeApiToolsService,
        _dio = dio;

  Future<void> initConnection(
    String apiKey, {
    required void Function()? onSpeak,
    required void Function()? onListen,
    required void Function()? onConnect,
    required void Function()? onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    Future<Map<String, dynamic>> Function(
      String functionName,
      Map<String, dynamic> args,
    )?
    onFunctionCall,
  }) async {
    final config = {
      'iceServers': [
        {
          'urls': ['stun:stun1.l.google.com:19302'],
        },
      ],
    };
    _connection = await createPeerConnection(config);

    _connection!.onConnectionState = (state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          onDisconnect?.call();
          break;
        default:
          break;
      }
    };

    _audioStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    _audioStream!.getTracks().forEach((track) {
      track.enabled = true;
      _connection!.addTrack(track, _audioStream!);
    });

    _dataChannel = await _connection!.createDataChannel(
      'oai-events',
      RTCDataChannelInit(),
    );

    RTCSessionDescription offer = await _connection!.createOffer();
    await _connection!.setLocalDescription(offer);

    late final Response secretResponse;
    try {
      secretResponse = await _dio.post(
        RealtimeApiConfig.realtimeAPISessionsUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode({
          "model": RealtimeApiConfig.realtimeAPIModelVersion,
          "voice": RealtimeApiConfig.voice,
          "instructions": RealtimeApiConfig.instructions,
          "turn_detection": {
            "type": "server_vad",
            "threshold": 0.8,
            "silence_duration_ms": 1000,
          },
          "tools": _realtimeApiToolsService.tools.map((tool) => tool.toJson()).toList(),
          "tool_choice": "auto",
          "max_response_output_tokens": 4096,
        }),
      );

      _dataChannel?.onMessage = (msg) async {
        final data = jsonDecode(msg.text);
        final String type = data["type"];

        if (type == RealtimeApiResponseTypes.sessionCreated) {
          onConnect?.call();
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStarted) {
          onSpeak?.call();
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStopped) {
          onListen?.call();
        } else if (type == RealtimeApiResponseTypes.inputSpeechStarted) {
          onListen?.call();
        } else if (type == RealtimeApiResponseTypes.functionCallArgumentsDone) {
          if (onFunctionCall != null) {
            final String functionName = data["name"];
            final Map<String, dynamic> args = jsonDecode(data["arguments"]);
            final returnData = await onFunctionCall(functionName, args);
            final msg = {
              "type": "conversation.item.create",
              "item": {
                "type": "function_call_output",
                "call_id": data["call_id"],
                "output": jsonEncode(returnData),
              },
            };
            returnFunctionCall(msg);
          }
        } else if (type == RealtimeApiResponseTypes.error) {
          if (onError != null) {
            onError(data);
          }
        } else {
          if (onMessage != null) {
            onMessage(data);
          }
        }
      };
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      return;
    }

    late final String secret;
    if (secretResponse.statusCode == 200) {
      Map<String, dynamic> res = secretResponse.data;
      secret = res["client_secret"]["value"];
    } else {
      if (onError != null) {
        onError("Failed to get secret key: ${secretResponse.data}");
      }
      return;
    }

    late final Response response;
    try {
      response = await _dio.post(
        "${RealtimeApiConfig.realtimeAPIBaseUrl}?model=${RealtimeApiConfig.realtimeAPIModelVersion}",
        options: Options(
          headers: {
            "Authorization": "Bearer $secret",
            "Content-Type": "application/sdp",
          },
        ),
        data: offer.sdp,
      );
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      return;
    }

    final answer = RTCSessionDescription(response.data, "answer");
    await _connection!.setRemoteDescription(answer);
  }

  void returnFunctionCall(Map<String, dynamic> msg) async {
    await _dataChannel?.send(RTCDataChannelMessage(jsonEncode(msg)));
    await _dataChannel?.send(
      RTCDataChannelMessage(jsonEncode({"type": "response.create"})),
    );
  }

  void muteMic() {
    for (var track in _audioStream!.getTracks()) {
      Helper.setMicrophoneMute(true, track);
    }
  }

  void unmuteMic() {
    for (var track in _audioStream!.getTracks()) {
      Helper.setMicrophoneMute(false, track);
    }
  }

  void close() {
    _dataChannel?.close();
    _audioStream?.dispose();
    _connection?.close();
    _connection?.dispose();
  }
}
