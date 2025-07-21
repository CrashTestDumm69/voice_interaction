// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeechConfig _$SpeechConfigFromJson(Map<String, dynamic> json) => SpeechConfig(
  voiceConfig:
      json['voiceConfig'] == null
          ? null
          : VoiceConfig.fromJson(json['voiceConfig'] as Map<String, dynamic>),
  languageCode: json['languageCode'] as String?,
);

Map<String, dynamic> _$SpeechConfigToJson(
  SpeechConfig instance,
) => <String, dynamic>{
  if (instance.voiceConfig?.toJson() case final value?) 'voiceConfig': value,
  if (instance.languageCode case final value?) 'languageCode': value,
};
