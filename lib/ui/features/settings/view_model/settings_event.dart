part of 'settings_view_model.dart';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ChangeInitialLocation extends SettingsEvent {
  final String newLocation;

  ChangeInitialLocation(this.newLocation);
}