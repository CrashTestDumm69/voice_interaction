import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/domain/models/live_api/common_types/blob/blob.dart';

import 'package:voice_interaction/domain/models/live_api/common_types/function_call/function_call.dart';
import 'package:voice_interaction/domain/models/live_api/common_types/function_response/function_response.dart';

part 'part.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Part {
  String? text;
  Blob? inlineData;
  FunctionCall? functionCall;
  FunctionResponse? functionResponse;

  Part({
    this.text,
    this.inlineData,
    this.functionCall,
    this.functionResponse
  });

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
  Map<String, dynamic> toJson() => _$PartToJson(this);

  factory Part.text(String text) => Part(text: text);
}