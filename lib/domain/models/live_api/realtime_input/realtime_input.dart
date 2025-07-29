import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/gemini_api_common_types/blob/blob.dart';

part 'realtime_input.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RealtimeInput {
  Blob? audio;
  Blob? video;
  String? text;

  RealtimeInput({
    this.audio,
    this.video,
    this.text
  });

  factory RealtimeInput.fromJson(Map<String, dynamic> json) => _$RealtimeInputFromJson(json);
  Map<String, dynamic> toJson() => _$RealtimeInputToJson(this);
}