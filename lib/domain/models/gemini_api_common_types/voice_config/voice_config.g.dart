// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceConfig _$VoiceConfigFromJson(Map<String, dynamic> json) => VoiceConfig(
  prebuiltVoiceConfig: PrebuiltVoiceConfig.fromJson(
    json['prebuiltVoiceConfig'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$VoiceConfigToJson(VoiceConfig instance) =>
    <String, dynamic>{
      'prebuiltVoiceConfig': instance.prebuiltVoiceConfig.toJson(),
    };
