// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_api_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveApiMessage _$LiveApiMessageFromJson(Map<String, dynamic> json) =>
    LiveApiMessage(
      setup:
          json['setup'] == null
              ? null
              : GenerateContentSetup.fromJson(
                json['setup'] as Map<String, dynamic>,
              ),
      clientContent:
          json['clientContent'] == null
              ? null
              : GenerateClientContent.fromJson(
                json['clientContent'] as Map<String, dynamic>,
              ),
      realtimeInput:
          json['realtimeInput'] == null
              ? null
              : GenerateRealtimeInput.fromJson(
                json['realtimeInput'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$LiveApiMessageToJson(LiveApiMessage instance) =>
    <String, dynamic>{
      if (instance.setup?.toJson() case final value?) 'setup': value,
      if (instance.clientContent?.toJson() case final value?)
        'clientContent': value,
      if (instance.realtimeInput?.toJson() case final value?)
        'realtimeInput': value,
    };
