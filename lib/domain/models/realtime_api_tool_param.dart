class RealtimeApiToolParam {
  final String name;
  final String description;
  final bool required;
  final List<String>? enumValues;

  RealtimeApiToolParam({
    required this.name,
    required this.description,
    this.required = false,
    this.enumValues,
  });

  Map<String, dynamic> toJson() {
    if (enumValues != null && enumValues!.isNotEmpty) {
      return {
        "type": "string",
        "enum": enumValues,
        "description": description,
      };
    } else {
      return {
        "type": "string",
        "description": description,
      };
    }
  }
}