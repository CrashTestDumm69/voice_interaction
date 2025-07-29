// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TtsApiResponse _$TtsApiResponseFromJson(Map<String, dynamic> json) =>
    TtsApiResponse(
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => Candidate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TtsApiResponseToJson(TtsApiResponse instance) =>
    <String, dynamic>{
      'candidates': instance.candidates.map((e) => e.toJson()).toList(),
    };
