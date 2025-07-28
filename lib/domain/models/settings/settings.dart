import 'package:hive_ce/hive.dart';

class Settings extends HiveObject {
  String initialLocation;

  Settings({
    required this.initialLocation
  });

  Settings copyWith({String? initialLocation}) {
    return Settings(
      initialLocation: initialLocation ?? this.initialLocation
    );
  }
}