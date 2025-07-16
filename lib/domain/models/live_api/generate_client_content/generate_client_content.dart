import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/content/content.dart';

part 'generate_client_content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GenerateClientContent {
  List<Content>? turns;
  bool? turnComplete;

  GenerateClientContent({
    this.turns,
    this.turnComplete = true
  });

  factory GenerateClientContent.fromJson(Map<String, dynamic> json) => _$GenerateClientContentFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateClientContentToJson(this);
}