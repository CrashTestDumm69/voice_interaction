import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/live_api/common_types/content/content.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/generation_config/generation_config.dart';

part 'content_setup.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ContentSetup {
  String model;
  GenerationConfig? generationConfig;
  Content? systemInstruction;

  ContentSetup({
    required this.model,
    this.generationConfig,
    this.systemInstruction,
  });

  factory ContentSetup.fromJson(Map<String, dynamic> json) => _$ContentSetupFromJson(json);
  Map<String, dynamic> toJson() => _$ContentSetupToJson(this);
}