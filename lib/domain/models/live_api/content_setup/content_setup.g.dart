// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_setup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentSetup _$ContentSetupFromJson(Map<String, dynamic> json) => ContentSetup(
  model: json['model'] as String,
  generationConfig:
      json['generationConfig'] == null
          ? null
          : GenerationConfig.fromJson(
            json['generationConfig'] as Map<String, dynamic>,
          ),
  systemInstruction:
      json['systemInstruction'] == null
          ? null
          : Content.fromJson(json['systemInstruction'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContentSetupToJson(ContentSetup instance) =>
    <String, dynamic>{
      'model': instance.model,
      if (instance.generationConfig?.toJson() case final value?)
        'generationConfig': value,
      if (instance.systemInstruction?.toJson() case final value?)
        'systemInstruction': value,
    };
