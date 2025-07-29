import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:voice_interaction/config/tts_api_config.dart';
import 'package:voice_interaction/domain/models/tts_api/tts_api_message/tts_api_message.dart';
import 'package:voice_interaction/domain/models/tts_api/tts_api_response/tts_api_response.dart';
import 'package:voice_interaction/utils/pcm_to_wav.dart';

class GeminiTtsService {
  final Dio _dio;

  GeminiTtsService({
    required Dio dio
  }) : _dio = dio;

  Future<Uint8List?> convertToSpeech({required String apiKey, required String text}) async {
    final msg = TtsApiMessage.generateSpeech(
      text: text,
      voice: "zephyr",
      languageCode: "en-IN"
    );
    
    final response = await _dio.post(
      TtsApiConfig.apiUrl,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey
        }
      ),
      data: jsonEncode(msg)
    );

    if (response.statusCode == 200) {
      final speechData = TtsApiResponse.fromJson(response.data);

      if (speechData.candidates.singleOrNull != null) {
        for (var part in speechData.candidates.single.content.parts) {
          if (part.inlineData != null) {
            final data = part.inlineData!.data;
            final audio = base64Decode(data);
            return pcmToWav(pcmBytes: audio);
          }
        }
      }
    }

    return null;
  }
}
