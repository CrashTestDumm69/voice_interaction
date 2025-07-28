// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerContent _$ServerContentFromJson(Map<String, dynamic> json) =>
    ServerContent(
      modelTurn: json['modelTurn'] == null
          ? null
          : Content.fromJson(json['modelTurn'] as Map<String, dynamic>),
      generationComplete: json['generationComplete'] as bool?,
      turnComplete: json['turnComplete'] as bool?,
      interrupted: json['interrupted'] as bool?,
    );

Map<String, dynamic> _$ServerContentToJson(ServerContent instance) =>
    <String, dynamic>{
      'modelTurn': ?instance.modelTurn?.toJson(),
      'generationComplete': ?instance.generationComplete,
      'turnComplete': ?instance.turnComplete,
      'interrupted': ?instance.interrupted,
    };
