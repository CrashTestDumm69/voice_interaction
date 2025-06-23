import 'package:voice_interaction/ui/models/display_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';

class DoctorsDetails extends DisplayDetails {
  final Grid items;

  DoctorsDetails({
    required super.heading,
    super.description = '',
    required this.items,
  });
}