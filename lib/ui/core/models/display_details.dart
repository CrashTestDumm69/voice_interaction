import 'package:voice_interaction/ui/core/models/grid.dart';

class DisplayDetails {
  final String heading;
  final String? description;
  final List<Grid>? grids;

  DisplayDetails({required this.heading, this.description, this.grids});
}