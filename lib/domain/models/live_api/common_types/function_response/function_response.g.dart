// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionResponse _$FunctionResponseFromJson(Map<String, dynamic> json) =>
    FunctionResponse(
      id: json['id'] as String?,
      name: json['name'] as String,
      response: json['response'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$FunctionResponseToJson(FunctionResponse instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'name': instance.name,
      'response': instance.response,
    };
