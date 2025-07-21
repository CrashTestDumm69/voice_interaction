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
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt() ?? 4096,
      temperature: (json['temperature'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toInt(),
      topK: (json['topK'] as num?)?.toInt(),
      speechConfig:
          json['speechConfig'] == null
              ? null
              : SpeechConfig.fromJson(
                json['speechConfig'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$GenerationConfigToJson(
  GenerationConfig instance,
) => <String, dynamic>{
  if (instance.responseModalities?.map((e) => _$ModalityEnumMap[e]!).toList()
      case final value?)
    'responseModalities': value,
  if (instance.maxOutputTokens case final value?) 'maxOutputTokens': value,
  if (instance.temperature case final value?) 'temperature': value,
  if (instance.topP case final value?) 'topP': value,
  if (instance.topK case final value?) 'topK': value,
  if (instance.speechConfig?.toJson() case final value?) 'speechConfig': value,
};

const _$ModalityEnumMap = {Modality.image: 'IMAGE', Modality.audio: 'AUDIO'};
