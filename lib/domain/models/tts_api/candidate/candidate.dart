import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/content/content.dart';

part 'candidate.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Candidate {
  Content content;

  Candidate({
    required this.content
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => _$CandidateFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateToJson(this);
}