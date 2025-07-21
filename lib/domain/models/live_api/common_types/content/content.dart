import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/part/part.dart';

part 'content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Content {
  List<Part> parts;
  String role;

  Content({
    required this.parts,
    required this.role
  });

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);

  factory Content.text(String msg, String role) => Content(parts: [Part(text: msg)], role: "user");
}