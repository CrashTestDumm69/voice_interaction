// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_client_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateClientContent _$GenerateClientContentFromJson(
  Map<String, dynamic> json,
) => GenerateClientContent(
  turns:
      (json['turns'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
  turnComplete: json['turnComplete'] as bool? ?? true,
);

Map<String, dynamic> _$GenerateClientContentToJson(
  GenerateClientContent instance,
) => <String, dynamic>{
  if (instance.turns?.map((e) => e.toJson()).toList() case final value?)
    'turns': value,
  if (instance.turnComplete case final value?) 'turnComplete': value,
};
