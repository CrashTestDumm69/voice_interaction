// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  role: json['role'] as String?,
  parts: (json['parts'] as List<dynamic>)
      .map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'role': ?instance.role,
  'parts': instance.parts.map((e) => e.toJson()).toList(),
};
