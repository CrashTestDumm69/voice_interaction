import 'package:freezed_annotation/freezed_annotation.dart';

part 'function_response.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FunctionResponse {
  String? id;
  String name;
  Map<String, dynamic> response;

  FunctionResponse({
    this.id,
    required this.name,
    required this.response
  });

  factory FunctionResponse.fromJson(Map<String, dynamic> json) => _$FunctionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionResponseToJson(this);
}