import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/content/content.dart';

part 'server_content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ServerContent {
  final Content? modelTurn;
  final bool? generationComplete;
  final bool? turnComplete;
  final bool? interrupted;

  ServerContent({
    this.modelTurn,
    this.generationComplete,
    this.turnComplete,
    this.interrupted
  });

  factory ServerContent.fromJson(Map<String, dynamic> json) => _$ServerContentFromJson(json);
  Map<String, dynamic> toJson() => _$ServerContentToJson(this);
}