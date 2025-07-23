import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/content/content.dart';

part 'client_content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClientContent {
  List<Content>? turns;

  @JsonKey(name: "turn_complete")
  bool? turnComplete;

  ClientContent({
    this.turns,
    this.turnComplete = true
  });

  factory ClientContent.fromJson(Map<String, dynamic> json) => _$ClientContentFromJson(json);
  Map<String, dynamic> toJson() => _$ClientContentToJson(this);

  factory ClientContent.clientText(String msg) => ClientContent(turns: [Content.text(msg)]);
}