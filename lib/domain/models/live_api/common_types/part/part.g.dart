// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Part _$PartFromJson(Map<String, dynamic> json) => Part(
    text: json['text'] as String?,
    functionCall:
        json['functionCall'] == null
            ? null
            : FunctionCall.fromJson(
              json['functionCall'] as Map<String, dynamic>,
            ),
    functionResponse:
        json['functionResponse'] == null
            ? null
            : FunctionResponse.fromJson(
              json['functionResponse'] as Map<String, dynamic>,
            ),
  )
  ..inlineData =
      json['inlineData'] == null
          ? null
          : Blob.fromJson(json['inlineData'] as Map<String, dynamic>);

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
  if (instance.text case final value?) 'text': value,
  if (instance.inlineData?.toJson() case final value?) 'inlineData': value,
  if (instance.functionCall?.toJson() case final value?) 'functionCall': value,
  if (instance.functionResponse?.toJson() case final value?)
    'functionResponse': value,
};
