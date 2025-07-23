import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/part/part.dart';

part 'content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Content {
  String? role;
  List<Part> parts;

  Content({
    required this.role,
    required this.parts
  });

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);

  factory Content.text(String msg) => Content(parts: [Part(text: msg)], role: "user");
  factory Content.prompt(String prompt) {
    final paras = prompt.trim().split(RegExp(r'\n\s*\n')).map((para) => para.trim()).toList();
    final parts = paras.map((para) => Part.text(para)).toList();
    return Content(parts: parts, role: null);
  }
}