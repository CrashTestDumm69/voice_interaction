import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/voice_config/voice_config.dart';

part 'speech_config.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SpeechConfig {
  VoiceConfig voiceConfig;
  String languageCode;

  SpeechConfig({
    required this.voiceConfig,
    required this.languageCode
  });

  factory SpeechConfig.fromJson(Map<String, dynamic> json) => _$SpeechConfigFromJson(json);
  Map<String, dynamic> toJson() => _$SpeechConfigToJson(this);
}