import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/speech_config/speech_config.dart';

part 'generation_config.g.dart';

enum Modality {
  @JsonValue("IMAGE")
  image,

  @JsonValue("AUDIO")
  audio
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GenerationConfig {
  List<Modality>? responseModalities;
  int? maxOutputTokens;
  int? temperature;
  int? topP;
  int? topK;
  SpeechConfig? speechConfig;

  GenerationConfig({
    this.responseModalities = const [Modality.audio],
    this.maxOutputTokens = 4096,
    this.temperature,
    this.topP,
    this.topK,
    this.speechConfig
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) => _$GenerationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);
}