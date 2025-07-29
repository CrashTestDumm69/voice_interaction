// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_api_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TtsApiMessage _$TtsApiMessageFromJson(Map<String, dynamic> json) =>
    TtsApiMessage(
      contents: Content.fromJson(json['contents'] as Map<String, dynamic>),
      generationConfig: GenerationConfig.fromJson(
        json['generationConfig'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TtsApiMessageToJson(TtsApiMessage instance) =>
    <String, dynamic>{
      'contents': instance.contents.toJson(),
      'generationConfig': instance.generationConfig.toJson(),
    };
