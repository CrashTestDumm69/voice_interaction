import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/blob/blob.dart';
import 'package:voice_interaction/domain/models/live_api/client_content/client_content.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/content/content.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/prebuilt_voice_config/prebuilt_voice_config.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/speech_config/speech_config.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/voice_config/voice_config.dart';
import 'package:voice_interaction/domain/models/live_api/content_setup/content_setup.dart';
import 'package:voice_interaction/domain/models/live_api/realtime_input/realtime_input.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/generation_config/generation_config.dart';
import 'package:voice_interaction/domain/models/live_api/server_content/server_content.dart';

part 'live_api_message.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LiveApiMessage {
  ContentSetup? setup;
  ClientContent? clientContent;
  RealtimeInput? realtimeInput;
  Map? setupComplete;
  ServerContent? serverContent;

  LiveApiMessage({
    this.setup,
    this.clientContent,
    this.realtimeInput,
    this.setupComplete,
    this.serverContent
  });

  factory LiveApiMessage.fromJson(Map<String, dynamic> json) => _$LiveApiMessageFromJson(json);
  Map<String, dynamic> toJson() => _$LiveApiMessageToJson(this);

  factory LiveApiMessage.clientText(String msg) => LiveApiMessage(clientContent: ClientContent.clientText(msg));
  
  factory LiveApiMessage.setup({required String model, required String voice, required String languageCode, required String prompt}) {
    return LiveApiMessage(
      setup: ContentSetup(
        model: model,
        systemInstruction: Content.prompt(prompt),
        generationConfig: GenerationConfig(
          maxOutputTokens: 4096,
          speechConfig: SpeechConfig(
            voiceConfig: VoiceConfig(
              prebuiltVoiceConfig: PrebuiltVoiceConfig(
                voiceName: voice
              ),
            ),
            languageCode: languageCode
          )
        )
      ),
    );
  }
  
  factory LiveApiMessage.realtimeInput({String? audio, String? video, String? text}) {
    RealtimeInput realtimeInput = RealtimeInput();
    if (audio != null) {
      realtimeInput.audio = Blob(mimeType: "audio/pcm;rate=24000", data: audio);
    }

    if (video != null) {
      realtimeInput.video = Blob(mimeType: "video/mp4", data: video);
    }

    if (text != null) {
      realtimeInput.text = text;
    }

    return LiveApiMessage(realtimeInput: realtimeInput);
  }
}