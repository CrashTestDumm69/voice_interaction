import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:voice_interaction/config/realtime_api_data.dart';
import 'package:voice_interaction/data/models/health_package.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RealtimeApiService {
  late final String apiKey;
  RTCPeerConnection? connection;
  RTCDataChannel? dataChannel;
  MediaStream? _audioStream;
  final Dio dio = Dio();
  late final List<HealthPackage> packages;
  late final List<String> packageNames;

  Future<void> initConnection() async {
    await dotenv.load(fileName: ".env");
    apiKey = dotenv.env["OPENAI_API_KEY"] ?? "";
    final MethodChannel channel = const MethodChannel('volume');
    channel.invokeMethod('setCallVolume', {"level": 15});
    final packagesJson = await rootBundle.loadString('assets/packages.json');
    packages = (jsonDecode(packagesJson) as List)
      .map((e) => HealthPackage.fromJson(e))
      .toList();
    packageNames = packages.map((pkg) => pkg.package).toList();
    final config = {
      'iceServers': [
        {'urls': ['stun:stun1.l.google.com:19302']}
      ]
    };
    connection = await createPeerConnection(config);

    _audioStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    _audioStream!.getTracks().forEach((track) {
      track.enabled = false;
      debugPrint("Track - ${track.label}");
      debugPrint("Kind - ${track.kind}");
      debugPrint("ID - ${track.getSettings()}");
      connection!.addTrack(track, _audioStream!);
    });

    dataChannel = await connection!.createDataChannel('oai-events', RTCDataChannelInit());
    
    RTCSessionDescription offer = await connection!.createOffer();
    await connection!.setLocalDescription(offer);

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
          "instructions": RealtimeApiData.instructions,
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
    await connection!.setRemoteDescription(answer);
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
        await dataChannel?.send(sendMsg);
        returnData = {
          "status": "failed",
          "data": "No packages available"
        };
      } else if (packageNames.contains(packageName)) {
        final package = packages.firstWhere((pkg) => pkg.package == packageName);
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
        await dataChannel?.send(sendMsg);
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
        await dataChannel?.send(sendMsg);
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
    await dataChannel?.send(RTCDataChannelMessage(jsonEncode({"type": "response.create"})));

    return returnData;
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

  Future<void> clearHistory(List<String> itemIds) async {
    for(String itemId in itemIds) {
      final msg = {
        "type": "conversation.item.delete",
        "item_id": itemId,
      };
      RTCDataChannelMessage sendMsg = RTCDataChannelMessage(jsonEncode(msg));
      await dataChannel?.send(sendMsg);
    }
  }

  void dispose() {
    connection!.close();
    _audioStream?.dispose();
  }
}
