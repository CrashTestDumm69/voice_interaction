import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/prebuilt_voice_config/prebuilt_voice_config.dart';

part 'voice_config.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class VoiceConfig {
  PrebuiltVoiceConfig prebuiltVoiceConfig;

  VoiceConfig({
    required this.prebuiltVoiceConfig,
  });

  factory VoiceConfig.fromJson(Map<String, dynamic> json) => _$VoiceConfigFromJson(json);
  Map<String, dynamic> toJson() => _$VoiceConfigToJson(this);
}