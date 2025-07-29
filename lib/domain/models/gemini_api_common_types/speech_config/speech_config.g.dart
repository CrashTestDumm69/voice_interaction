// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeechConfig _$SpeechConfigFromJson(Map<String, dynamic> json) => SpeechConfig(
  voiceConfig: VoiceConfig.fromJson(
    json['voiceConfig'] as Map<String, dynamic>,
  ),
  languageCode: json['languageCode'] as String,
);

Map<String, dynamic> _$SpeechConfigToJson(SpeechConfig instance) =>
    <String, dynamic>{
      'voiceConfig': instance.voiceConfig.toJson(),
      'languageCode': instance.languageCode,
    };
