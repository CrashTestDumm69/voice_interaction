import 'package:freezed_annotation/freezed_annotation.dart';

part 'function_call.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FunctionCall {
  String? id;
  String name;
  Map<String, dynamic>? args;

  FunctionCall({
    this.id,
    required this.name,
    this.args
  });

  factory FunctionCall.fromJson(Map<String, dynamic> json) => _$FunctionCallFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionCallToJson(this);
}