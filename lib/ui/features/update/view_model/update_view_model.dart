import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/update_repository.dart';

part 'update_states.dart';
part 'update_events.dart';

class UpdateViewModel extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _updateRepository;

  UpdateViewModel({
    required UpdateRepository updateRepository,
  }) : _updateRepository = updateRepository,
       super(UpdateInitial()) {
    
    on<CheckForUpdate>((event, emit) async {
      emit(CheckingForUpdate());
      final hasUpdate = await _updateRepository.checkForUpdate();
      debugPrint(hasUpdate.toString());
      if (hasUpdate != null) {
        emit(UpdateAvailable(version: hasUpdate.toString()));
      } else {
        emit(UpdateNotAvailable());
      }
    });

    on<PerformUpdate>((event, emit) async {
      emit(UpdateInProgress(percent: null));
      try {
        await _updateRepository.downloadUpdate(onProgress: (progress, total) {
          add(Updating(progress: progress, total: total));
        });
      } catch (e) {
        emit(UpdateFailed(message: e.toString()));
      }
      emit(UpdateCompleted());
      add(InstallUpdate());
    });

    on<InstallUpdate>((event, emit) async {
      await _updateRepository.updateApp();
    });

    on<Updating>((event, emit) async {
      final percent = (event.progress / event.total);
      emit(UpdateInProgress(percent: percent));
    });
  }
}