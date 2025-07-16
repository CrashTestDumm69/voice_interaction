import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/live_api/blob/blob.dart';

import 'package:voice_interaction/domain/models/live_api/function_call/function_call.dart';
import 'package:voice_interaction/domain/models/live_api/function_response/function_response.dart';

part 'content.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Content {
  String? text;
  Blob? inlineData;
  FunctionCall? functionCall;
  FunctionResponse? functionResponse;

  Content({
    this.text,
    this.functionCall,
    this.functionResponse
  });

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);

  factory Content.text(String text) => Content(text: text);
}