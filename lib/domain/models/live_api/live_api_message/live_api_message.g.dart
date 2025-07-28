// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_api_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveApiMessage _$LiveApiMessageFromJson(
  Map<String, dynamic> json,
) => LiveApiMessage(
  setup: json['setup'] == null
      ? null
      : ContentSetup.fromJson(json['setup'] as Map<String, dynamic>),
  clientContent: json['clientContent'] == null
      ? null
      : ClientContent.fromJson(json['clientContent'] as Map<String, dynamic>),
  realtimeInput: json['realtimeInput'] == null
      ? null
      : RealtimeInput.fromJson(json['realtimeInput'] as Map<String, dynamic>),
  setupComplete: json['setupComplete'] as Map<String, dynamic>?,
  serverContent: json['serverContent'] == null
      ? null
      : ServerContent.fromJson(json['serverContent'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveApiMessageToJson(LiveApiMessage instance) =>
    <String, dynamic>{
      'setup': ?instance.setup?.toJson(),
      'clientContent': ?instance.clientContent?.toJson(),
      'realtimeInput': ?instance.realtimeInput?.toJson(),
      'setupComplete': ?instance.setupComplete,
      'serverContent': ?instance.serverContent?.toJson(),
    };
