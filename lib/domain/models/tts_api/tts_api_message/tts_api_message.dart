import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/content/content.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/generation_config/generation_config.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/prebuilt_voice_config/prebuilt_voice_config.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/speech_config/speech_config.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/voice_config/voice_config.dart';

part 'tts_api_message.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TtsApiMessage {
  Content contents;
  GenerationConfig generationConfig;

  TtsApiMessage({required this.contents, required this.generationConfig});

  factory TtsApiMessage.fromJson(Map<String, dynamic> json) => _$TtsApiMessageFromJson(json);

  Map<String, dynamic> toJson() => _$TtsApiMessageToJson(this);

  factory TtsApiMessage.generateSpeech({required String text, required String voice, required String languageCode}) {
    return TtsApiMessage(
      contents: Content.prompt("Say $text"),
      generationConfig: GenerationConfig(
        speechConfig: SpeechConfig(
          voiceConfig: VoiceConfig(
            prebuiltVoiceConfig: PrebuiltVoiceConfig(
              voiceName: voice
            )
          ),
          languageCode: languageCode
        )
      )
    );
  }
}
