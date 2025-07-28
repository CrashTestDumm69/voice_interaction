part of 'settings_view_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String initialLocation;

  SettingsLoaded({
    required this.initialLocation
  });
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}