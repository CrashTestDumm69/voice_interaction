// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientContent _$ClientContentFromJson(Map<String, dynamic> json) =>
    ClientContent(
      turns: (json['turns'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      turnComplete: json['turn_complete'] as bool? ?? true,
    );

Map<String, dynamic> _$ClientContentToJson(ClientContent instance) =>
    <String, dynamic>{
      'turns': ?instance.turns?.map((e) => e.toJson()).toList(),
      'turn_complete': ?instance.turnComplete,
    };
