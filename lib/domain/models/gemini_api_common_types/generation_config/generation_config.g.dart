// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationConfig _$GenerationConfigFromJson(Map<String, dynamic> json) =>
    GenerationConfig(
      responseModalities:
          (json['responseModalities'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ModalityEnumMap, e))
              .toList() ??
          const [Modality.audio],
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
      temperature: (json['temperature'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toInt(),
      topK: (json['topK'] as num?)?.toInt(),
      speechConfig: json['speechConfig'] == null
          ? null
          : SpeechConfig.fromJson(json['speechConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerationConfigToJson(GenerationConfig instance) =>
    <String, dynamic>{
      'responseModalities': ?instance.responseModalities
          ?.map((e) => _$ModalityEnumMap[e]!)
          .toList(),
      'maxOutputTokens': ?instance.maxOutputTokens,
      'temperature': ?instance.temperature,
      'topP': ?instance.topP,
      'topK': ?instance.topK,
      'speechConfig': ?instance.speechConfig?.toJson(),
    };

const _$ModalityEnumMap = {Modality.image: 'IMAGE', Modality.audio: 'AUDIO'};
