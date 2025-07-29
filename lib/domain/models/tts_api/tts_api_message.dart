import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/content/content.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/generation_config/generation_config.dart';

part 'tts_api_message.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TtsApiMessage {
  Content contents;
  GenerationConfig generationConfig;

  TtsApiMessage({required this.contents, required this.generationConfig});

  factory TtsApiMessage.fromJson(Map<String, dynamic> json) =>
      _$TtsApiMessageFromJson(json);
  Map<String, dynamic> toJson() => _$TtsApiMessageToJson(this);
}
