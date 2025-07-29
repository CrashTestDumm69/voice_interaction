// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Part _$PartFromJson(Map<String, dynamic> json) => Part(
  text: json['text'] as String?,
  inlineData: json['inlineData'] == null
      ? null
      : Blob.fromJson(json['inlineData'] as Map<String, dynamic>),
  functionCall: json['functionCall'] == null
      ? null
      : FunctionCall.fromJson(json['functionCall'] as Map<String, dynamic>),
  functionResponse: json['functionResponse'] == null
      ? null
      : FunctionResponse.fromJson(
          json['functionResponse'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
  'text': ?instance.text,
  'inlineData': ?instance.inlineData?.toJson(),
  'functionCall': ?instance.functionCall?.toJson(),
  'functionResponse': ?instance.functionResponse?.toJson(),
};
