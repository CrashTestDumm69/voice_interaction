import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/live_api/blob/blob.dart';
import 'package:voice_interaction/domain/models/live_api/content/content.dart';
import 'package:voice_interaction/domain/models/live_api/generate_client_content/generate_client_content.dart';

import 'package:voice_interaction/domain/models/live_api/generate_content_setup/generate_content_setup.dart';
import 'package:voice_interaction/domain/models/live_api/generate_realtime_input/generate_realtime_input.dart';
import 'package:voice_interaction/domain/models/live_api/generation_config/generation_config.dart';

part 'live_api_message.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LiveApiMessage {
  GenerateContentSetup? setup;
  GenerateClientContent? clientContent;
  GenerateRealtimeInput? realtimeInput;

  LiveApiMessage({
    this.setup,
    this.clientContent,
    this.realtimeInput
  });

  factory LiveApiMessage.fromJson(Map<String, dynamic> json) => _$LiveApiMessageFromJson(json);
  Map<String, dynamic> toJson() => _$LiveApiMessageToJson(this);

  factory LiveApiMessage.clientContent(Content content) => LiveApiMessage(clientContent: GenerateClientContent(turns: [content]));
  
  factory LiveApiMessage.setup({required String model, String? prompt}) {
    return LiveApiMessage(
      setup: GenerateContentSetup(
        model: model,
        systemInstruction: prompt,
        generationConfig: GenerationConfig()
      ),
    );
  }
  
  factory LiveApiMessage.realtimeInput({String? audio, String? video, String? text}) {
    GenerateRealtimeInput realtimeInput = GenerateRealtimeInput();
    if (audio != null) {
      realtimeInput.audio = Blob(mimeType: "audio/mpeg", data: audio);
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