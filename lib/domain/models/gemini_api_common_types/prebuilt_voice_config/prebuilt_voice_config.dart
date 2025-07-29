import 'package:freezed_annotation/freezed_annotation.dart';

part 'prebuilt_voice_config.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PrebuiltVoiceConfig {
  String voiceName;

  PrebuiltVoiceConfig({
    required this.voiceName
  });

  factory PrebuiltVoiceConfig.fromJson(Map<String, dynamic> json) => _$PrebuiltVoiceConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PrebuiltVoiceConfigToJson(this);
}