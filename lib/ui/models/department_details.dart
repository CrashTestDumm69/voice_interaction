import 'package:voice_interaction/ui/models/display_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';

class DepartmentDetails extends DisplayDetails {
  Grid doctors;

  DepartmentDetails({
    required super.heading,
    required super.description,
    required this.doctors,
  });
}