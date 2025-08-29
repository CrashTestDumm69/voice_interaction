import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_voice_engine/flutter_voice_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:voice_interaction/config/live_api_config.dart';
import 'package:voice_interaction/domain/models/live_api/live_api_message/live_api_message.dart';
import 'package:web_socket_channel/io.dart';

class LiveApiService {
  final _voiceEngine = FlutterVoiceEngine();

  IOWebSocketChannel? _channel;

  final StreamController<Uint8List> _speakerStream = StreamController<Uint8List>.broadcast();

  Future<void> _initAudio() async {
    await Permission.microphone.request();
    
    _voiceEngine.audioConfig = AudioConfig(
      sampleRate: 24000,
      channels: 1,
      bitDepth: 16,
      bufferSize: 2048,
      amplitudeThreshold: 0.05,
      enableAEC: true
    );

    _voiceEngine.sessionConfig = AudioSessionConfig(
      category: AudioCategory.playAndRecord,
      mode: AudioMode.voiceChat,
      options: const {AudioOption.defaultToSpeaker, AudioOption.duckOthers},
      preferredBufferDuration: 0.005
    );

    await _voiceEngine.initialize();
  }

  Future<void> initConnection(String apiKey) async {
    _channel = IOWebSocketChannel.connect(
      Uri.parse("${LiveApiConfig.websocketUrl}?key=$apiKey"),
    );
    await _initAudio();
    print("Starting socket");
    _channel!.stream.listen(
      (data) {
        final msg = utf8.decode(data);
        final structuredMsg = LiveApiMessage.fromJson(jsonDecode(msg));
        print("\n\nMessage - $msg\n\n");

        if (structuredMsg.setupComplete != null) {
          print("Setup done");
        } else if (structuredMsg.serverContent != null) {
          final serverContent = structuredMsg.serverContent;
          if (serverContent!.modelTurn != null) {
            final model = serverContent.modelTurn;
            final parts = model!.parts;
            for (var part in parts) {
              if (part.inlineData != null) {
                final data = part.inlineData!.data;
                final sound = base64Decode(data);
                _speakerStream.add(sound);
              }
            }
          } else if (serverContent.turnComplete != null) {
            print("Turn completion - ${serverContent.turnComplete}");
          } else if (serverContent.generationComplete != null) {
            print("Gen completion - ${serverContent.generationComplete}");
          }
        }
      },
      onDone: () => print("Done"),
      onError: (err) => print("Error - $err")
    );


    _voiceEngine.audioChunkStream.listen((audio) {
      final micInput = LiveApiMessage.realtimeInput(audio: base64Encode(audio));
      _channel?.sink.add(jsonEncode(micInput));
    });

    _speakerStream.stream.listen((audio) async {
      await _voiceEngine.playAudioChunk(audio);
    });

    await _voiceEngine.startRecording();
    print("Start speaking");

    final msg = LiveApiMessage.setup(
      model: LiveApiConfig.model,
      voice: "zephyr",
      languageCode: "en-AU",
      prompt: "Always speak in English."
    );
    print(jsonEncode(msg));
    _channel!.sink.add(jsonEncode(msg));
  }

  void returnFunctionCall(Map<String, dynamic> msg) async {}

  void muteMic() {}

  void unmuteMic() {}

  void close() {}
}
