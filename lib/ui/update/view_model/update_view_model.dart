import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/update_repository.dart';

part 'update_states.dart';
part 'update_events.dart';

class UpdateViewModel extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _updateRepository;
  Timer? _updateCheckTimer;
  static const updateCheckInterval = Duration(hours: 1);

  UpdateViewModel({
    required UpdateRepository updateRepository,
  }) : _updateRepository = updateRepository,
       super(UpdateInitial()) {
    
    on<CheckForUpdate>((event, emit) async {
      final hasUpdate = await _updateRepository.checkForUpdate();
      debugPrint(hasUpdate.toString());
      if (hasUpdate) {
        emit(UpdateAvailable());
      } else {
        emit(UpdateNotAvailable());
      }
    });

    on<StartUpdateCheck>((event, emit) {
      _updateCheckTimer?.cancel();
      _updateCheckTimer = Timer.periodic(updateCheckInterval, (timer) {
        add(CheckForUpdate());
      });
      add(CheckForUpdate()); // Check immediately when starting
    });

    on<StopUpdateCheck>((event, emit) {
      _updateCheckTimer?.cancel();
      _updateCheckTimer = null;
    });

    on<PerformUpdate>((event, emit) async {      
      await _updateRepository.updateApp(onProgress: (progress, total) {
        add(Updating(progress: progress, total: total));
      });
    });

    on<Updating>((event, emit) async {
      emit(UpdateInProgress(progress: event.progress, total: event.total));
    });
  }

  @override
  Future<void> close() {
    _updateCheckTimer?.cancel();
    return super.close();
  }
}