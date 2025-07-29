import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/tts_api/candidate/candidate.dart';

part 'tts_api_response.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TtsApiResponse {
  List<Candidate> candidates;

  TtsApiResponse({
    required this.candidates
  });

  factory TtsApiResponse.fromJson(Map<String, dynamic> json) => _$TtsApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TtsApiResponseToJson(this);
}