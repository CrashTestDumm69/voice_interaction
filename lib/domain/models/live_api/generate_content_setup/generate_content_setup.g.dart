// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_content_setup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateContentSetup _$GenerateContentSetupFromJson(
  Map<String, dynamic> json,
) => GenerateContentSetup(
  model: json['model'] as String,
  generationConfig:
      json['generationConfig'] == null
          ? null
          : GenerationConfig.fromJson(
            json['generationConfig'] as Map<String, dynamic>,
          ),
  systemInstruction: json['systemInstruction'] as String?,
);

Map<String, dynamic> _$GenerateContentSetupToJson(
  GenerateContentSetup instance,
) => <String, dynamic>{
  'model': instance.model,
  if (instance.generationConfig?.toJson() case final value?)
    'generationConfig': value,
  if (instance.systemInstruction case final value?) 'systemInstruction': value,
};
