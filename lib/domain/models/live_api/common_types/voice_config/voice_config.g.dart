// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceConfig _$VoiceConfigFromJson(Map<String, dynamic> json) => VoiceConfig(
  prebuiltVoiceConfig:
      json['prebuiltVoiceConfig'] == null
          ? null
          : PrebuiltVoiceConfig.fromJson(
            json['prebuiltVoiceConfig'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$VoiceConfigToJson(VoiceConfig instance) =>
    <String, dynamic>{
      if (instance.prebuiltVoiceConfig?.toJson() case final value?)
        'prebuiltVoiceConfig': value,
    };
