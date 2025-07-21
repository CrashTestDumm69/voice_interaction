// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceConfig _$VoiceConfigFromJson(Map<String, dynamic> json) => VoiceConfig(
  preBuiltVoiceConfig:
      json['preBuiltVoiceConfig'] == null
          ? null
          : PreBuiltVoiceConfig.fromJson(
            json['preBuiltVoiceConfig'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$VoiceConfigToJson(VoiceConfig instance) =>
    <String, dynamic>{
      if (instance.preBuiltVoiceConfig?.toJson() case final value?)
        'preBuiltVoiceConfig': value,
    };
