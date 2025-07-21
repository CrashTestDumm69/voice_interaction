// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealtimeInput _$RealtimeInputFromJson(Map<String, dynamic> json) =>
    RealtimeInput(
      audio:
          json['audio'] == null
              ? null
              : Blob.fromJson(json['audio'] as Map<String, dynamic>),
      video:
          json['video'] == null
              ? null
              : Blob.fromJson(json['video'] as Map<String, dynamic>),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$RealtimeInputToJson(RealtimeInput instance) =>
    <String, dynamic>{
      if (instance.audio?.toJson() case final value?) 'audio': value,
      if (instance.video?.toJson() case final value?) 'video': value,
      if (instance.text case final value?) 'text': value,
    };
