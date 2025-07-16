import 'package:voice_interaction/domain/models/live_api/live_api_tool_param.dart';

enum Behaviour {
  blocking,
  nonBlocking
}

enum LiveApiToolParamType {
  string,
  number,
  integer,
  boolean,
  array,
  object,
  nullType
}

class FunctionDeclaration {
  String name;
  String description;
  Behaviour? behaviour;
  List<LiveApiToolParam>? parameters;
}

class LiveApiTool {
  List<FunctionDeclaration>? functionDeclarations;
}