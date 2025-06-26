enum RealtimeApiToolParamType {
  string,
  number,
  boolean,
}

class RealtimeApiToolParam {
  final String name;
  final String description;
  final RealtimeApiToolParamType type;
  final bool required;
  final List<String>? enumValues;
  final int? minimum;
  final int? maximum;

  RealtimeApiToolParam({
    required this.name,
    required this.description,
    required this.type,
    this.required = false,
    this.enumValues,
    this.minimum,
    this.maximum,
  });

  Map<String, dynamic> toJson() {
    switch(type) {
      case RealtimeApiToolParamType.string:
        return {
          "type": "string",
          "description": description,
          if (enumValues != null) "enum": enumValues,
        };
      case RealtimeApiToolParamType.number:
        return {
          "type": "number",
          "description": description,
          if (minimum != null) "minimum": minimum,
          if (maximum != null) "maximum": maximum,
        };
      case RealtimeApiToolParamType.boolean:
        return {
          "type": "boolean",
          "description": description,
        };
    }
  }
}