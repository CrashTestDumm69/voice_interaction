import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:voice_interaction/config/realtime_api_data.dart';
import 'package:voice_interaction/config/realtime_api_response_types.dart';
import 'package:voice_interaction/domain/models/realtime_connection_state.dart';
import 'package:voice_interaction/domain/models/realtime_speech_state.dart';

class RealtimeApiService {
  RTCPeerConnection? _connection;
  RTCDataChannel? _dataChannel;
  MediaStream? _audioStream;
  final Dio dio = Dio();
  final _connectionController = StreamController<RealtimeConnectionState>.broadcast();
  final _speechController = StreamController<RealtimeSpeechState>.broadcast();

  Stream<RealtimeConnectionState> get connectionStateStream => _connectionController.stream;
  Stream<RealtimeSpeechState> get speechStateStream => _speechController.stream;

  RealtimeConnectionState _connectionState = RealtimeConnectionState.connecting;
  RealtimeSpeechState _speechState = RealtimeSpeechState.idle;

  void _setConnectionState(RealtimeConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      _connectionController.add(newState);
      if (newState != RealtimeConnectionState.connected) {
        _setSpeechState(RealtimeSpeechState.idle);
      }
    }
  }

  void _setSpeechState(RealtimeSpeechState newState) {
    if (_connectionState == RealtimeConnectionState.connected &&
        newState != _speechState) {
      _speechState = newState;
      _speechController.add(newState);
    }
  }

  Future<void> initConnection(String apiKey, String instruction, {void Function(String functionName, String args)? onFuntionCall}) async {
    final config = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302'
          ]
        }
      ]
    };
    _connection = await createPeerConnection(config);

    _connection!.onConnectionState = (state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _setConnectionState(RealtimeConnectionState.disconnected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          _setConnectionState(RealtimeConnectionState.connecting);
          break;
        default:
          break;
      }
    };

    _audioStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    _audioStream!.getTracks().forEach((track) {
      track.enabled = true;
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
          "instructions": instruction == "English" ? RealtimeApiData.englishInstructions : RealtimeApiData.tamilInstructions,
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

        if (type == RealtimeApiResponseTypes.sessionCreated) {
          debugPrint("Session created");
          _setConnectionState(RealtimeConnectionState.connected);
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStarted) {
          debugPrint("Robo Speaking");
          _setSpeechState(RealtimeSpeechState.speaking);
        } else if (type == RealtimeApiResponseTypes.outputAudioBufferStopped) {
          debugPrint("Robo done");
          _setSpeechState(RealtimeSpeechState.listening);
        } else if (type == RealtimeApiResponseTypes.inputSpeechStarted) {
          debugPrint("User heard");
          _setSpeechState(RealtimeSpeechState.listening);
        } else if (type == RealtimeApiResponseTypes.functionCallArgumentsDone) {
          debugPrint("Function call arguments done");
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

  void muteMic() {
    for (var track in _audioStream!.getTracks()) {
      track.enabled = false;
    }
  }

  void unmuteMic() {
    for (var track in _audioStream!.getTracks()) {
      track.enabled = true;
    }
  }
  
  void close() {
    _dataChannel?.close();
    _audioStream?.dispose();
    _connection?.close();
    _connection?.dispose();
  }

  void dispose() {
    close();
    dio.close();
  }
}
