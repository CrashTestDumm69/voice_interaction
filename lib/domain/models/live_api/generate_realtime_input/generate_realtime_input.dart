import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/blob/blob.dart';

part 'generate_realtime_input.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GenerateRealtimeInput {
  Blob? audio;
  Blob? video;
  String? text;

  GenerateRealtimeInput({
    this.audio,
    this.video,
    this.text
  });

  factory GenerateRealtimeInput.fromJson(Map<String, dynamic> json) => _$GenerateRealtimeInputFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateRealtimeInputToJson(this);
}