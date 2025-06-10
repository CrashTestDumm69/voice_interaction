import 'package:voice_interaction/ui/models/display_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';

class PackageDetials extends DisplayDetails {
  final String price;
  final Grid consultations;
  final Grid tests;

  PackageDetials({
    required super.heading,
    required super.description,
    required this.price,
    required this.consultations,
    required this.tests,
  });
}