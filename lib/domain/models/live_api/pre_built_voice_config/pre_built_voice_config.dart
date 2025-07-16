import 'package:freezed_annotation/freezed_annotation.dart';

part 'pre_built_voice_config.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PreBuiltVoiceConfig {
  String voice;

  PreBuiltVoiceConfig({
    required this.voice
  });

  factory PreBuiltVoiceConfig.fromJson(Map<String, dynamic> json) => _$PreBuiltVoiceConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PreBuiltVoiceConfigToJson(this);
}