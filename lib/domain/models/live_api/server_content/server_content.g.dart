// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerContent _$ServerContentFromJson(Map<String, dynamic> json) =>
    ServerContent(
      modelTurn:
          json['modelTurn'] == null
              ? null
              : Content.fromJson(json['modelTurn'] as Map<String, dynamic>),
      generationComplete: json['generationComplete'] as bool?,
      turnComplete: json['turnComplete'] as bool?,
      interrupted: json['interrupted'] as bool?,
    );

Map<String, dynamic> _$ServerContentToJson(ServerContent instance) =>
    <String, dynamic>{
      if (instance.modelTurn?.toJson() case final value?) 'modelTurn': value,
      if (instance.generationComplete case final value?)
        'generationComplete': value,
      if (instance.turnComplete case final value?) 'turnComplete': value,
      if (instance.interrupted case final value?) 'interrupted': value,
    };
