// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionCall _$FunctionCallFromJson(Map<String, dynamic> json) => FunctionCall(
  id: json['id'] as String?,
  name: json['name'] as String,
  args: json['args'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$FunctionCallToJson(FunctionCall instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': instance.name,
      'args': ?instance.args,
    };
