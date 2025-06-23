import 'package:voice_interaction/domain/models/realtime_api_tool_param.dart';

class RealtimeApiTool {
  final String name;
  final String description;
  final List<RealtimeApiToolParam>? parameters;

  RealtimeApiTool({
    required this.name,
    required this.description,
    this.parameters,
  });

  Map<String, dynamic> toJson() {
    if (parameters == null || parameters!.isEmpty) {
      return {
        "type": "function",
        "name": name,
        "description": description,
        "parameters": {
          "type": "object",
          "properties": {},
        },
      };
    } else {
      return {
        "type": "function",
        "name": name,
        "description": description,
        "parameters": {
          "type": "object",
          "properties": Map.fromEntries(
            parameters!.map((param) => MapEntry(param.name, param.toJson())),
          ),
          "required": parameters!
              .where((param) => param.required)
              .map((param) => param.name)
              .toList(),
        },
      };
    }
  }
}