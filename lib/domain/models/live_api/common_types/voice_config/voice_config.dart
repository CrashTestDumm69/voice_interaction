import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/pre_built_voice_config/pre_built_voice_config.dart';

part 'voice_config.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class VoiceConfig {
  PreBuiltVoiceConfig? preBuiltVoiceConfig;

  VoiceConfig({
    this.preBuiltVoiceConfig,
  });

  factory VoiceConfig.fromJson(Map<String, dynamic> json) => _$VoiceConfigFromJson(json);
  Map<String, dynamic> toJson() => _$VoiceConfigToJson(this);
}