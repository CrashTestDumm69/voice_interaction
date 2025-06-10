class Grid {
  final String heading;
  final List<String> items;

  Grid({required this.heading, required this.items});

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}