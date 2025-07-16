import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/generation_config/generation_config.dart';

part 'generate_content_setup.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GenerateContentSetup {
  String model;
  GenerationConfig? generationConfig;
  String? systemInstruction;

  GenerateContentSetup({
    required this.model,
    this.generationConfig,
    this.systemInstruction,
  });

  factory GenerateContentSetup.fromJson(Map<String, dynamic> json) => _$GenerateContentSetupFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateContentSetupToJson(this);
}