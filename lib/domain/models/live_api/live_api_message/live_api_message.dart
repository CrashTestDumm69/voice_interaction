import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/blob/blob.dart';
import 'package:voice_interaction/domain/models/live_api/common_types/content/content.dart';
import 'package:voice_interaction/domain/models/live_api/client_content/client_content.dart';
import 'package:voice_interaction/domain/models/live_api/content_setup/content_setup.dart';
import 'package:voice_interaction/domain/models/live_api/realtime_input/realtime_input.dart';
import 'package:voice_interaction/domain/models/live_api/common_types/generation_config/generation_config.dart';
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

  factory LiveApiMessage.clientContent(Content content) => LiveApiMessage(clientContent: ClientContent(turns: [content]));
  
  factory LiveApiMessage.setup({required String model, String? prompt}) {
    return LiveApiMessage(
      setup: ContentSetup(
        model: model,
        systemInstruction: prompt,
        generationConfig: GenerationConfig()
      ),
    );
  }
  
  factory LiveApiMessage.realtimeInput({String? audio, String? video, String? text}) {
    RealtimeInput realtimeInput = RealtimeInput();
    if (audio != null) {
      realtimeInput.audio = Blob(mimeType: "audio/pcm", data: audio);
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