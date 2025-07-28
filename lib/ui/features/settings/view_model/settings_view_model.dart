import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/settings_repository.dart';
import 'package:voice_interaction/routing/routes.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsViewModel extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeInitialLocation>(_onChangeInitialLocation);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());
    try {
      final settings = _settingsRepository.currentSettings;
      late final String location;
      if (settings.initialLocation == Routes.home) {
        location = "Home";
      } else if (settings.initialLocation == Routes.mediaPlayer) {
        location = "Media Player";
      } else {
        location = "Home";
      }
      emit(SettingsLoaded(initialLocation: location));
    } catch (e) {
      emit(SettingsError('Failed to load settings'));
    }
  }

  void _onChangeInitialLocation(ChangeInitialLocation event, Emitter<SettingsState> emit) {
    try {
      late String location;
      if(event.newLocation == "Home") {
        location = Routes.home;
      } else if (event.newLocation == "Media Player") {
        location = Routes.mediaPlayer;
      } else {
        location = Routes.home;
      }

      _settingsRepository.changeInitialLocation(location);
      emit(SettingsLoaded(initialLocation: event.newLocation));
    } catch (e) {
      emit(SettingsError('Failed to change location'));
    }
  }
}
